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
  main_test
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
