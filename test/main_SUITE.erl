-module(main_SUITE).

%% API
-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

init_per_suite(Config) ->
  {ok, _} = application:ensure_all_started(erlang_hc128),
  Config.

end_per_suite(Config) ->
  application:stop(erlang_hc128),
  Config.

init_per_testcase(_, Config) ->
  Config.

end_per_testcase(_TestCaseName, _Config) ->
  _Config.

all() -> [
  main_test,
  plain_test
].

main_test(_) ->
  Key = crypto:hash(md5, <<"hello">>),
  Data = crypto:strong_rand_bytes(1020094),
  IV = crypto:strong_rand_bytes(104787),
  { ok, Stream1 } = hc128:new(Key),
  { ok, Stream2 } = hc128:new(Key),

  ok = hc128:setiv(Stream1, IV),
  ok = hc128:setiv(Stream2, IV),

  { ok, Encrypted } = hc128:combine(Stream1, Data),
  { ok, Decrypted } = hc128:combine(Stream2, Encrypted),

  ?_assertEqual(Decrypted, Data).

plain_test(_) ->
  %% Data taken from https://www.cryptopp.com/wiki/HC-128
  Key = <<16#A5, 16#1C, 16#98, 16#3C, 16#4F, 16#ED, 16#63, 16#68, 16#A4, 16#62, 16#36, 16#AF, 16#11, 16#63, 16#D9, 16#1F>>,
  IV  = <<16#79, 16#F6, 16#70, 16#49, 16#06, 16#ED, 16#2D, 16#D9, 16#60, 16#7F, 16#46, 16#FF, 16#C0, 16#93, 16#2C, 16#ED>>,
  Text = <<"HC-128 stream cipher test">>,
  Cipher = <<16#D1,16#9B,16#B4,16#B0,16#07,16#8C,16#DB,16#27,16#86,16#16,16#55,16#E7,16#42,16#11,16#74,16#32,16#A6,16#55,16#63,16#63,16#67,16#70,16#E1,16#C7,16#84>>,

  { ok, Stream1} = hc128:new(Key),
  ok = hc128:setiv(Stream1, IV),

  { ok, Encrypted } = hc128:combine(Stream1, Text),

  ?_assertEqual(Encrypted, Cipher),

  { ok, Stream2 } = hc128:new(Key),
  ok = hc128:setiv(Stream2, IV),

  { ok, Decrypted } = hc128:combine(Stream2, Cipher),

  ?_assertEqual(Decrypted, Text),

  ok.


