^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package rtmros_hironx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.0.12 (2014-02-26)
-------------------
* Adding and improving unit test files.
* Adding travis conf files.
* Adding more checker programs for robot's internal os.
* Contributors: Isaac Isao Saito, Kei Okada

1.0.11 (2014-02-19)
-------------------
* Moved from googlecode.com to github.
* Initial commit of CHANGELOG.rst files.
* (hironx_client.py) Documenting a bunch. Removed humanoid specific methods.
* (hironx.py) fix to `#14 <https://github.com/start-jsk/rtmros_hironx/issues/14>`_
* (test-hironx.py) quick fix to get it run with a real robot. This needs enhancement for versatility. Also removed test_goOffpose that interrupt the testing sequence by turning down servo.
* Fix the same issue with https://github.com/tork-a/rtmros_nextage/issues/25#issuecomment-32332068 by the same patch (https://github.com/tork-a/rtmros_nextage/commit/d4268d81ec14a514bb4b3b52614c81e708dd1ecc#diff-20257dd6ad60c0892cfb122c37a8f2ba)
* (hironx.py) Use generic name for the robot instance. This enables users on the script commandline (eg. ipython0 to run the same commands without asking them to specifically tell what robot they're using (eg. hiro, nxc). This is backward compatible so that users can still keep using `hiro`.
* Contributors: Isaac Isao Saito, Kei Okada
