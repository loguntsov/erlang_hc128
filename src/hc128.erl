-module(hc128).

-export([
  new/1,
  setiv/2,
  combine/2
]).

-type context() :: hc128_nif:context().

-spec new(binary()) -> {ok, context()}.
new(Key) when is_binary(Key), size(Key) =:= 16 ->
  hc128_nif:new(Key).

-spec free(context()) -> ok.
free(Context) ->
  hc128_nif:free(Context).

-spec setiv(context(), binary()) -> ok.
setiv(Context, IV) ->
  hc128_nif:setiv(Context, IV).

-spec combine(context(), binary()) -> {ok, binary()}.
combine(Context, Binary) ->
  hc128_nif:combine(Context, Binary).
