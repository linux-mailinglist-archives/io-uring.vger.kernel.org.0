Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0495829B6
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiG0Pe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiG0Pe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:27 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C3024963
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:26 -0700 (PDT)
Received: (qmail 15095 invoked by uid 989); 27 Jul 2022 15:27:43 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 3/9] meson: update available tests to liburing 2.3
Date:   Wed, 27 Jul 2022 17:27:17 +0200
Message-Id: <20220727152723.3320169-4-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: --
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-0.000002)
X-Rspamd-Score: -2.600002
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:43 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* Update the available tests.

* Check for -Warray-bound and -Wstringop-overflow and use them if available.
  Include test/helper.c when building the test executables.

* Bump required meson version from 0.53 to 0.54 to use fs.stem.

* Simplify the meson test definition code by using a plain list of source
  files instead of the complex list of lists.
  Obtain the test name by stripping the file suffix from the test source
  using the meson fs module.

* Link each test with the thread dependency similar to: 664bf78.

* Run tests sequentially to prevent dmesg log intermixing expected
  by the test tooling.
  Suggested-by: Eli Schwartz <eschwartz@archlinux.org>

* Add a 'parallel' test suite to mirror make test-parallel.

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 meson.build      |   3 +
 test/meson.build | 306 ++++++++++++++++++++++++++++-------------------
 2 files changed, 187 insertions(+), 122 deletions(-)

diff --git a/meson.build b/meson.build
index 7c91b97..0a63fef 100644
--- a/meson.build
+++ b/meson.build
@@ -20,6 +20,9 @@ thread_dep = dependency('threads')
 
 cc = meson.get_compiler('c')
 
+has_stringop_overflow = cc.has_argument('-Wstringop-overflow=0')
+has_array_bounds = cc.has_argument('-Warray-bounds=0')
+
 has__kernel_rwf_t = cc.has_type('__kernel_rwf_t', prefix: '#include <linux/fs.h>')
 
 has__kernel_timespec = cc.has_members('struct __kernel_timespec',
diff --git a/test/meson.build b/test/meson.build
index 60b50c2..4d9b3f3 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -1,147 +1,209 @@
-all_tests = [['232c93d07b74-test', 'c', thread_dep],
-             ['35fa71a030ca-test', 'c', thread_dep],
-             ['500f9fbadef8-test', 'c', []],
-             ['7ad0e4b2f83c-test', 'c', []],
-             ['8a9973408177-test', 'c', []],
-             ['917257daa0fe-test', 'c', []],
-             ['a0908ae19763-test', 'c', []],
-             ['a4c0b3decb33-test', 'c', []],
-             ['accept', 'c', []],
-             ['accept-link', 'c', thread_dep],
-             ['accept-reuse', 'c', []],
-             ['accept-test', 'c', []],
-             ['across-fork', 'c', thread_dep],
-             ['splice', 'c', []],
-             ['b19062a56726-test', 'c', []],
-             ['b5837bd5311d-test', 'c', []],
-             ['ce593a6c480a-test', 'c', thread_dep],
-             ['close-opath', 'c', []],
-             ['connect', 'c', []],
-             ['cq-full', 'c', []],
-             ['cq-overflow', 'c', []],
-             ['cq-overflow-peek', 'c', []],
-             ['cq-peek-batch', 'c', []],
-             ['cq-ready', 'c', []],
-             ['cq-size', 'c', []],
-             ['d4ae271dfaae-test', 'c', []],
-             ['d77a67ed5f27-test', 'c', []],
-             ['defer', 'c', []],
-             ['double-poll-crash', 'c', []],
-             ['eeed8b54e0df-test', 'c', []],
-             ['eventfd', 'c', []],
-             ['eventfd-disable', 'c', []],
-             ['eventfd-ring', 'c', []],
-             ['fadvise', 'c', []],
-             ['fallocate', 'c', []],
-             ['fc2a85cb02ef-test', 'c', []],
-             ['file-register', 'c', []],
-             ['file-update', 'c', []],
-             ['files-exit-hang-poll', 'c', []],
-             ['files-exit-hang-timeout', 'c', []],
-             ['fixed-link', 'c', []],
-             ['fsync', 'c', []],
-             ['io-cancel', 'c', []],
-             ['io_uring_enter', 'c', []],
-             ['io_uring_register', 'c', []],
-             ['io_uring_setup', 'c', []],
-             ['iopoll', 'c', []],
-             ['lfs-openat', 'c', []],
-             ['lfs-openat-write', 'c', []],
-             ['link', 'c', []],
-             ['link-timeout', 'c', []],
-             ['link_drain', 'c', []],
-             ['madvise', 'c', []],
-             ['nop', 'c', []],
-             ['nop-all-sizes', 'c', []],
-             ['open-close', 'c', []],
-             ['openat2', 'c', []],
-             ['personality', 'c', []],
-             ['pipe-eof', 'c', thread_dep],
-             ['pipe-reuse', 'c', []],
-             ['poll', 'c', []],
-             ['poll-cancel', 'c', []],
-             ['poll-cancel-ton', 'c', []],
-             ['poll-link', 'c', thread_dep],
-             ['poll-many', 'c', []],
-             ['poll-ring', 'c', []],
-             ['poll-v-poll', 'c', thread_dep],
-             ['probe', 'c', []],
-             ['read-write', 'c', []],
-             ['register-restrictions', 'c', []],
-             ['rename', 'c', []],
-             ['ring-leak', 'c', []],
-             ['ring-leak2', 'c', thread_dep],
-             ['self', 'c', []],
-             ['send_recv', 'c', thread_dep],
-             ['send_recvmsg', 'c', thread_dep],
-             ['shared-wq', 'c', []],
-             ['short-read', 'c', []],
-             ['shutdown', 'c', []],
-             ['sigfd-deadlock', 'c', []],
-             ['socket-rw', 'c', []],
-             ['socket-rw-eagain', 'c', []],
-             ['sq-full', 'c', []],
-             ['sq-poll-dup', 'c', []],
-             ['sq-poll-kthread', 'c', []],
-             ['sq-poll-share', 'c', []],
-             ['sqpoll-exit-hang', 'c', []],
-             ['sqpoll-sleep', 'c', []],
-             ['sq-space_left', 'c', []],
-             ['stdout', 'c', []],
-             ['submit-reuse', 'c', thread_dep],
-             ['teardowns', 'c', []],
-             ['thread-exit', 'c', thread_dep],
-             ['timeout', 'c', []],
-             ['timeout-new', 'c', thread_dep],
-             ['timeout-overflow', 'c', []],
-             ['unlink', 'c', []],
-             ['wakeup-hang', 'c', thread_dep]]
+all_tests = [
+  '232c93d07b74.c',
+  '35fa71a030ca.c',
+  '500f9fbadef8.c',
+  '7ad0e4b2f83c.c',
+  '8a9973408177.c',
+  '917257daa0fe.c',
+  'a0908ae19763.c',
+  'a4c0b3decb33.c',
+  'accept.c',
+  'accept-link.c',
+  'accept-reuse.c',
+  'accept-test.c',
+  'across-fork.c',
+  'b19062a56726.c',
+  'b5837bd5311d.c',
+  'buf-ring.c',
+  'ce593a6c480a.c',
+  'close-opath.c',
+  'connect.c',
+  'cq-full.c',
+  'cq-overflow.c',
+  'cq-peek-batch.c',
+  'cq-ready.c',
+  'cq-size.c',
+  'd4ae271dfaae.c',
+  'd77a67ed5f27.c',
+  'defer.c',
+  'double-poll-crash.c',
+  'drop-submit.c',
+  'eeed8b54e0df.c',
+  'empty-eownerdead.c',
+  'eventfd.c',
+  'eventfd-disable.c',
+  'eventfd-reg.c',
+  'eventfd-ring.c',
+  'exec-target.c',
+  'exit-no-cleanup.c',
+  'fadvise.c',
+  'fallocate.c',
+  'fc2a85cb02ef.c',
+  'fd-pass.c',
+  'file-register.c',
+  'files-exit-hang-poll.c',
+  'files-exit-hang-timeout.c',
+  'file-update.c',
+  'file-verify.c',
+  'fixed-buf-iter.c',
+  'fixed-link.c',
+  'fixed-reuse.c',
+  'fpos.c',
+  'fsync.c',
+  'hardlink.c',
+  'io-cancel.c',
+  'iopoll.c',
+  'io_uring_enter.c',
+  'io_uring_register.c',
+  'io_uring_setup.c',
+  'lfs-openat.c',
+  'lfs-openat-write.c',
+  'link.c',
+  'link_drain.c',
+  'link-timeout.c',
+  'madvise.c',
+  'mkdir.c',
+  'msg-ring.c',
+  'multicqes_drain.c',
+  'nolibc.c',
+  'nop-all-sizes.c',
+  'nop.c',
+  'openat2.c',
+  'open-close.c',
+  'open-direct-link.c',
+  'open-direct-pick.c',
+  'personality.c',
+  'pipe-eof.c',
+  'pipe-reuse.c',
+  'poll.c',
+  'poll-cancel.c',
+  'poll-cancel-all.c',
+  'poll-cancel-ton.c',
+  'poll-link.c',
+  'poll-many.c',
+  'poll-mshot-overflow.c',
+  'poll-mshot-update.c',
+  'poll-ring.c',
+  'poll-v-poll.c',
+  'pollfree.c',
+  'probe.c',
+  'read-before-exit.c',
+  'read-write.c',
+  'recv-msgall.c',
+  'recv-msgall-stream.c',
+  'recv-multishot.c',
+  'register-restrictions.c',
+  'rename.c',
+  'ring-leak2.c',
+  'ring-leak.c',
+  'rsrc_tags.c',
+  'rw_merge_test.c',
+  'self.c',
+  'send_recv.c',
+  'sendmsg_fs_cve.c',
+  'send_recvmsg.c',
+  'send-zerocopy.c',
+  'shared-wq.c',
+  'short-read.c',
+  'shutdown.c',
+  'sigfd-deadlock.c',
+  'single-issuer.c',
+  'skip-cqe.c',
+  'socket.c',
+  'socket-rw.c',
+  'socket-rw-eagain.c',
+  'socket-rw-offset.c',
+  'splice.c',
+  'sq-full.c',
+  'sqpoll-cancel-hang.c',
+  'sqpoll-disable-exit.c',
+  'sq-poll-dup.c',
+  'sqpoll-exit-hang.c',
+  'sq-poll-kthread.c',
+  'sq-poll-share.c',
+  'sqpoll-sleep.c',
+  'sq-space_left.c',
+  'stdout.c',
+  'submit-link-fail.c',
+  'submit-reuse.c',
+  'symlink.c',
+  'sync-cancel.c',
+  'teardowns.c',
+  'thread-exit.c',
+  'timeout.c',
+  'timeout-new.c',
+  'timeout-overflow.c',
+  'tty-write-dpoll.c',
+  'unlink.c',
+  'wakeup-hang.c',
+  'xattr.c',
+]
 
 if has_statx or glibc_statx
-    all_tests += [['statx', 'c', []]]
+    all_tests += ['statx.c']
 endif
 
 if has_cxx
-    all_tests += [['sq-full-cpp', 'cc', []]]
+    all_tests += ['sq-full-cpp.cc']
 endif
 
 runtests_sh = find_program('runtests.sh')
 runtests_loop_sh = find_program('runtests-loop.sh')
+runtests_quiet_sh = find_program('runtests-quiet.sh')
 
-foreach t : all_tests
-    executable(t[0],
-               t[0] + '.' + t[1],
+xcflags = []
+if has_stringop_overflow
+    xcflags = xcflags + ['-Wstringop-overflow=0']
+endif
+if has_array_bounds
+    xcflags = xcflags + ['-Warray-bounds=0']
+endif
+
+test_dependencies = [thread_dep]
+
+foreach test_source: all_tests
+    # Tests are not allowed to contain multiple '.' in their name
+    # using the meson filesystem module would solve this restriction
+    # but require to bump our minimum meson version to '>= 0.54'.
+    test_name = test_source.split()[0]
+    executable(test_name,
+               [test_source, 'helpers.c'],
+               c_args: xcflags,
+               cpp_args: xcflags,
                include_directories: inc,
                link_with: liburing.get_static_lib(),
-               dependencies: t[2],
+               dependencies: test_dependencies,
                install: true,
                install_dir: get_option('datadir') / 'liburing-test')
 
-    test(t[0],
+    test(test_name,
          runtests_sh,
-         args: t[0],
-         workdir : meson.current_build_dir(),
+         args: test_name,
+         is_parallel: false,
+         workdir: meson.current_build_dir(),
          suite: 'once')
 
-    test(t[0] + '_loop',
+    test(test_name + '_loop',
          runtests_loop_sh,
-         args: t[0],
+         args: test_name,
+         is_parallel: false,
          workdir: meson.current_build_dir(),
          suite: 'loop')
-endforeach
 
-configure_file(input: 'runtests.sh',
-               output: 'runtests.sh',
-               copy: true)
+    test(test_name + '_quiet',
+         runtests_quiet_sh,
+         args: test_name,
+         workdir: meson.current_build_dir(),
+         suite: 'parallel')
+endforeach
 
-configure_file(input: 'runtests-loop.sh',
-               output: 'runtests-loop.sh',
-               copy: true)
+test_runners = ['runtests.sh', 'runtests-loop.sh', 'runtests-quiet.sh']
 
-configure_file(input: 'config',
-               output: 'config.local',
-               copy: true)
+foreach test_runner: test_runners
+  configure_file(input: test_runner,
+                 output: test_runner,
+                 copy: true)
 
-install_data('runtests.sh',
-             'runtests-loop.sh',
-             install_dir: get_option('datadir') / 'liburing-test')
+  install_data(test_runner,
+               install_dir: get_option('datadir') / 'liburing-test')
+endforeach
-- 
2.37.1

