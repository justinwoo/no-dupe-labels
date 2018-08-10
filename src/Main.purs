module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Prim.Row as Row
import Prim.RowList as RL
import Type.Prelude (class TypeEquals, RProxy(..))

class NoDuplicateFields (rl :: RL.RowList) (row :: # Type) | rl -> row

instance noDuplicateRowsNil :: NoDuplicateFields RL.Nil row

instance noDuplicateRowsCons ::
  ( Row.Cons name ty row' row
  , Row.Lacks name row'
  , NoDuplicateFields tail row
  ) => NoDuplicateFields (RL.Cons name ty tail) row

checkNoDuplicateFields :: forall proxy row rl. RL.RowToList row rl => NoDuplicateFields rl row => proxy row -> Unit
checkNoDuplicateFields _ = unit

valid :: Unit
valid = checkNoDuplicateFields (RProxy :: RProxy ( a :: Unit, b :: Unit, c :: Unit ))

-- invalid :: Unit
-- invalid = checkNoDuplicateFields (RProxy :: RProxy ( d :: Unit, d :: Unit ))

-- invalid will give the following error, which starts with a tautology, then
-- explains how the error occurred when trying to apply checkNoDuplicateFields and
-- its constraint NoDuplicateFields:

-- No type class instance was found for

--     Prim.Row.Lacks "d"
--                    ( d :: Unit
--                    )

-- while applying a function checkNoDuplicateFields
--   of type RowToList t0 t1 => NoDuplicateFields t1 t0 => t2 t0 -> Unit
--   to argument RProxy
-- while checking that expression checkNoDuplicateFields RProxy
--   has type Unit
-- in value declaration invalid

checkNoDuplicateFields2 :: forall proxy row row'. Row.Nub row row' => TypeEquals (proxy row) (proxy row') => proxy row -> Unit
checkNoDuplicateFields2 _ = unit

valid2 :: Unit
valid2 = checkNoDuplicateFields2 (RProxy :: RProxy ( a :: Unit, b :: Unit, c :: Unit ))

-- invalid2 :: Unit
-- invalid2 = checkNoDuplicateFields2 (RProxy :: RProxy ( d :: Unit, d :: Unit ))

-- again, this is invalid, but the unmatched constraint comes first, and then we
-- can see the expression that the constraint came from

-- Could not match type

--     ( d :: Unit
--     , d :: Unit
--     )

--   with type

--     ( d :: Unit
--     )


-- while trying to match type t1
--   with type RProxy
--               ( d :: Unit
--               )
-- while solving type class constraint

--   Type.Equality.TypeEquals (RProxy
--                               ( d :: Unit
--                               , d :: Unit
--                               )
--                           )
--                           (RProxy t0)

-- while checking that expression checkNoDuplicateFields2 RProxy
--   has type Unit
-- in value declaration invalid2

main :: Effect Unit
main = do
  log "Hello sailor!"
