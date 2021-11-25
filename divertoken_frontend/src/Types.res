type apiState<'data, 'err> = Idle | Loading | Success('data) | Fail('err)
