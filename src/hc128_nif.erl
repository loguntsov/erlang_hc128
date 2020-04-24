-module(hc128_nif).

-export([
  new/1,
  setiv/2,
  combine/2
]).

-define(APP, erlang_hc128).
-define(C_LIBRARY, "hc128_nif").

-on_load(init/0).

-opaque context() :: reference().
-export_type([
  context/0
]).

init() ->
    SoName = case code:priv_dir(?APP) of
        {error, bad_name} ->
            case code:which(?MODULE) of
                Filename when is_list(Filename) ->
                    filename:join([filename:dirname(Filename),"../priv", ?C_LIBRARY]);
                _ ->
                    filename:join("../priv", ?C_LIBRARY)
            end;
        Dir ->
            filename:join(Dir, ?C_LIBRARY)
    end,
    erlang:load_nif(SoName, 0).

-spec new(binary()) -> {ok, context()}.
new(_Key) ->
    erlang:nif_error({error, not_loaded}).

-spec free(context()) -> ok.
free(_Context) ->
  erlang:nif_error({error, not_loaded}).

-spec setiv(context(), binary()) -> ok.
setiv(_Context, _IV) ->
  erlang:nif_error({error, not_loaded}).

-spec combine(context(), binary()) -> {ok, binary()}.
combine(_Context, _Binary) ->
  erlang:nif_error({error, not_loaded}).
