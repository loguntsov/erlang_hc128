-module(hc128).

-export([
  new/1,
  free/1,
  setiv/2,
  next_keystream/1,
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

-spec next_keystream(context()) -> ok.
next_keystream(Context) ->
  hc128_nif:next_keystream(Context).

-spec combine(context(), binary()) -> {ok, binary()}.
combine(Context, Binary) ->
  hc128_nif:combine(Context, Binary).
