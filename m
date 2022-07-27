Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32CA5829B4
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiG0PeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiG0PeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:22 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5811C237F4
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:19 -0700 (PDT)
Received: (qmail 14981 invoked by uid 989); 27 Jul 2022 15:27:37 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Peter Eszlari <peter.eszlari@gmail.com>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 1/9] add Meson build system
Date:   Wed, 27 Jul 2022 17:27:15 +0200
Message-Id: <20220727152723.3320169-2-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: --
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) BAYES_HAM(-1.039819) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -2.139819
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:37 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peter Eszlari <peter.eszlari@gmail.com>

Meson is a fast and simple build system. Adoption started mainly in the
desktop space (Gnome, X11, Mesa) to replace autotools, but since then,
some low level projects (systemd, qemu) have switched to it too.

Since liburing is a rather small codebase, the difference in
speed and simplicity are not as huge as with other projects.
Nonetheless, there are still some advantages:

* It comes with some nice features (e.g. out-of-source builds),
  that one would need to implement in shell otherwise.
* Other projects that use Meson could integrate liburing easily
  into their build system by using Meson's subproject() functionality.
* Meson provides some useful editor/IDE integration,
  e.g. by generating compile_commands.json for clangd.
* Distribution packagers are provided with a "standard" build system,
  with well known options/features/behavior, that is actively developed.

Co-developed-by: Florian Fischer <florian.fischer@muhq.space>
Signed-off-by: Peter Eszlari <peter.eszlari@gmail.com>
Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 .gitignore                       |   2 +
 examples/meson.build             |  17 ++++
 man/meson.build                  |   7 ++
 meson.build                      | 133 ++++++++++++++++++++++++++++
 meson_options.txt                |   9 ++
 src/include/liburing/compat.h.in |   7 ++
 src/include/liburing/meson.build |  46 ++++++++++
 src/include/meson.build          |   3 +
 src/meson.build                  |  17 ++++
 test/meson.build                 | 147 +++++++++++++++++++++++++++++++
 10 files changed, 388 insertions(+)
 create mode 100644 examples/meson.build
 create mode 100644 man/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 src/include/liburing/compat.h.in
 create mode 100644 src/include/liburing/meson.build
 create mode 100644 src/include/meson.build
 create mode 100644 src/meson.build
 create mode 100644 test/meson.build

diff --git a/.gitignore b/.gitignore
index 6e8a2f7..40d3717 100644
--- a/.gitignore
+++ b/.gitignore
@@ -30,3 +30,5 @@ config.log
 liburing.pc
 
 cscope.out
+
+/build/
diff --git a/examples/meson.build b/examples/meson.build
new file mode 100644
index 0000000..becfc02
--- /dev/null
+++ b/examples/meson.build
@@ -0,0 +1,17 @@
+executable('io_uring-cp',
+           'io_uring-cp.c',
+           dependencies: uring)
+
+executable('io_uring-test',
+           'io_uring-test.c',
+           dependencies: uring)
+
+executable('link-cp',
+           'link-cp.c',
+           dependencies: uring)
+
+if has_ucontext
+    executable('ucontext-cp',
+               'ucontext-cp.c',
+               dependencies: uring)
+endif
diff --git a/man/meson.build b/man/meson.build
new file mode 100644
index 0000000..94e44b3
--- /dev/null
+++ b/man/meson.build
@@ -0,0 +1,7 @@
+install_man('io_uring.7',
+            'io_uring_enter.2',
+            'io_uring_get_sqe.3',
+            'io_uring_queue_exit.3',
+            'io_uring_queue_init.3',
+            'io_uring_register.2',
+            'io_uring_setup.2')
diff --git a/meson.build b/meson.build
new file mode 100644
index 0000000..cb7dd9e
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,133 @@
+project('liburing', ['c','cpp'],
+        version: run_command('awk', '/Version:/ { print $2 }', 'liburing.spec').stdout().strip(),
+        license: ['MIT', 'LGPL-2.1-only', 'GPL-2.0-only WITH Linux-syscall-note'],
+        meson_version: '>=0.53.0',
+        default_options: ['default_library=both',
+                          'buildtype=debugoptimized',
+                          'c_std=c11',
+                          'cpp_std=c++11',
+                          'warning_level=3'])
+
+add_project_arguments('-D_GNU_SOURCE',
+                      '-D__SANE_USERSPACE_TYPES__',
+                      '-include', meson.current_build_dir() + '/config-host.h',
+                      '-Wno-unused-parameter',
+                      '-Wno-sign-compare',
+                      '-fomit-frame-pointer',
+                      language: ['c', 'cpp'])
+
+thread_dep = dependency('threads')
+
+cc = meson.get_compiler('c')
+
+code = '''#include <linux/fs.h>
+int main(int argc, char **argv)
+{
+  __kernel_rwf_t x;
+  x = 0;
+  return x;
+}
+'''
+has__kernel_rwf_t = cc.compiles(code, name : '__kernel_rwf_t')
+
+code = '''#include <linux/time.h>
+#include <linux/time_types.h>
+int main(int argc, char **argv)
+{
+  struct __kernel_timespec ts;
+  ts.tv_sec = 0;
+  ts.tv_nsec = 1;
+  return 0;
+}
+'''
+has__kernel_timespec = cc.compiles(code, name : '__kernel_timespec')
+
+code = '''#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+int main(int argc, char **argv)
+{
+  struct open_how how;
+  how.flags = 0;
+  how.mode = 0;
+  how.resolve = 0;
+  return 0;
+}
+'''
+has_open_how = cc.compiles(code, name: 'open_how')
+
+code = '''#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <linux/stat.h>
+int main(int argc, char **argv)
+{
+  struct statx x;
+
+  return memset(&x, 0, sizeof(x)) != NULL;
+}
+'''
+has_statx = cc.compiles(code, name: 'statx')
+
+cpp = meson.get_compiler('cpp')
+
+code = '''#include <iostream>
+int main(int argc, char **argv)
+{
+  std::cout << "Test";
+  return 0;
+}
+'''
+has_cxx = cpp.compiles(code, name: 'C++')
+
+code = '''#include <ucontext.h>
+int main(int argc, char **argv)
+{
+  ucontext_t ctx;
+  getcontext(&ctx);
+  return 0;
+}
+'''
+has_ucontext = cc.compiles(code, name : 'ucontext')
+
+conf_data = configuration_data()
+conf_data.set('CONFIG_HAVE_KERNEL_RWF_T', has__kernel_rwf_t)
+conf_data.set('CONFIG_HAVE_KERNEL_TIMESPEC', has__kernel_timespec)
+conf_data.set('CONFIG_HAVE_OPEN_HOW', has_open_how)
+conf_data.set('CONFIG_HAVE_STATX', has_statx)
+conf_data.set('CONFIG_HAVE_CXX', has_cxx)
+conf_data.set('CONFIG_HAVE_UCONTEXT', has_ucontext)
+configure_file(output: 'config-host.h',
+               configuration: conf_data)
+
+subdir('src')
+subdir('man')
+
+if get_option('examples')
+    subdir('examples')
+endif
+
+if get_option('tests')
+    if get_option('default_library') != 'both'
+        error('default_library=both required to build tests')
+    endif
+    subdir('test')
+endif
+
+pkg_mod = import('pkgconfig')
+pkg_mod.generate(libraries: liburing,
+                 name: 'liburing',
+                 version: meson.project_version(),
+                 description: 'io_uring library',
+                 url: 'http://git.kernel.dk/cgit/liburing/')
+
+summary({'bindir': get_option('bindir'),
+         'libdir': get_option('libdir'),
+         'datadir': get_option('datadir'),
+        }, section: 'Directories')
+summary({'examples': get_option('examples'),
+         'tests': get_option('tests')
+        }, section: 'Configuration', bool_yn: true)
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 0000000..e9f581a
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,9 @@
+option('examples',
+       type : 'boolean',
+       value : false,
+       description : 'Build example programs')
+
+option('tests',
+       type : 'boolean',
+       value : false,
+       description : 'Build test programs')
diff --git a/src/include/liburing/compat.h.in b/src/include/liburing/compat.h.in
new file mode 100644
index 0000000..2e92907
--- /dev/null
+++ b/src/include/liburing/compat.h.in
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef LIBURING_COMPAT_H
+#define LIBURING_COMPAT_H
+@__kernel_rwf_t_compat@
+@__kernel_timespec_compat@
+@open_how_compat@
+#endif
diff --git a/src/include/liburing/meson.build b/src/include/liburing/meson.build
new file mode 100644
index 0000000..f60cbc7
--- /dev/null
+++ b/src/include/liburing/meson.build
@@ -0,0 +1,46 @@
+if has__kernel_rwf_t
+    __kernel_rwf_t_compat = ''
+else
+    __kernel_rwf_t_compat = '''typedef int __kernel_rwf_t;
+'''
+endif
+
+if has__kernel_timespec
+    __kernel_timespec_compat = '''#include <linux/time_types.h>
+'''
+else
+    __kernel_timespec_compat = '''#include <stdint.h>
+
+struct __kernel_timespec {
+  int64_t    tv_sec;
+  long long  tv_nsec;
+};
+'''
+endif
+
+if has_open_how
+    open_how_compat = ''
+else
+    open_how_compat = '''#include <inttypes.h>
+
+struct open_how {
+  uint64_t flags;
+  uint64_t mode;
+  uint64_t resolve;
+};
+'''
+endif
+
+conf_data = configuration_data()
+conf_data.set('__kernel_rwf_t_compat', __kernel_rwf_t_compat)
+conf_data.set('__kernel_timespec_compat', __kernel_timespec_compat)
+conf_data.set('open_how_compat', open_how_compat)
+configure_file(input: 'compat.h.in',
+               output: 'compat.h',
+               configuration: conf_data,
+               install: true,
+               install_dir: get_option('includedir') / 'liburing')
+
+install_headers('barrier.h',
+                'io_uring.h',
+                subdir: 'liburing')
diff --git a/src/include/meson.build b/src/include/meson.build
new file mode 100644
index 0000000..7d5ddf0
--- /dev/null
+++ b/src/include/meson.build
@@ -0,0 +1,3 @@
+install_headers('liburing.h')
+
+subdir('liburing')
diff --git a/src/meson.build b/src/meson.build
new file mode 100644
index 0000000..b3aa751
--- /dev/null
+++ b/src/meson.build
@@ -0,0 +1,17 @@
+subdir('include')
+
+inc = include_directories(['include'])
+
+liburing = library('uring',
+                   'queue.c',
+                   'register.c',
+                   'setup.c',
+                   'syscall.c',
+                   include_directories: inc,
+                   link_args: '-Wl,--version-script=' + meson.current_source_dir() + '/liburing.map',
+                   link_depends: 'liburing.map',
+                   version: meson.project_version(),
+                   install: true)
+
+uring = declare_dependency(link_with: liburing,
+                           include_directories: inc)
diff --git a/test/meson.build b/test/meson.build
new file mode 100644
index 0000000..888b74d
--- /dev/null
+++ b/test/meson.build
@@ -0,0 +1,147 @@
+all_tests = [['232c93d07b74-test', 'c', thread_dep],
+             ['35fa71a030ca-test', 'c', thread_dep],
+             ['500f9fbadef8-test', 'c', []],
+             ['7ad0e4b2f83c-test', 'c', []],
+             ['8a9973408177-test', 'c', []],
+             ['917257daa0fe-test', 'c', []],
+             ['a0908ae19763-test', 'c', []],
+             ['a4c0b3decb33-test', 'c', []],
+             ['accept', 'c', []],
+             ['accept-link', 'c', thread_dep],
+             ['accept-reuse', 'c', []],
+             ['accept-test', 'c', []],
+             ['across-fork', 'c', thread_dep],
+             ['splice', 'c', []],
+             ['b19062a56726-test', 'c', []],
+             ['b5837bd5311d-test', 'c', []],
+             ['ce593a6c480a-test', 'c', thread_dep],
+             ['close-opath', 'c', []],
+             ['connect', 'c', []],
+             ['cq-full', 'c', []],
+             ['cq-overflow', 'c', []],
+             ['cq-overflow-peek', 'c', []],
+             ['cq-peek-batch', 'c', []],
+             ['cq-ready', 'c', []],
+             ['cq-size', 'c', []],
+             ['d4ae271dfaae-test', 'c', []],
+             ['d77a67ed5f27-test', 'c', []],
+             ['defer', 'c', []],
+             ['double-poll-crash', 'c', []],
+             ['eeed8b54e0df-test', 'c', []],
+             ['eventfd', 'c', []],
+             ['eventfd-disable', 'c', []],
+             ['eventfd-ring', 'c', []],
+             ['fadvise', 'c', []],
+             ['fallocate', 'c', []],
+             ['fc2a85cb02ef-test', 'c', []],
+             ['file-register', 'c', []],
+             ['file-update', 'c', []],
+             ['files-exit-hang-poll', 'c', []],
+             ['files-exit-hang-timeout', 'c', []],
+             ['fixed-link', 'c', []],
+             ['fsync', 'c', []],
+             ['io-cancel', 'c', []],
+             ['io_uring_enter', 'c', []],
+             ['io_uring_register', 'c', []],
+             ['io_uring_setup', 'c', []],
+             ['iopoll', 'c', []],
+             ['lfs-openat', 'c', []],
+             ['lfs-openat-write', 'c', []],
+             ['link', 'c', []],
+             ['link-timeout', 'c', []],
+             ['link_drain', 'c', []],
+             ['madvise', 'c', []],
+             ['nop', 'c', []],
+             ['nop-all-sizes', 'c', []],
+             ['open-close', 'c', []],
+             ['openat2', 'c', []],
+             ['personality', 'c', []],
+             ['pipe-eof', 'c', thread_dep],
+             ['pipe-reuse', 'c', []],
+             ['poll', 'c', []],
+             ['poll-cancel', 'c', []],
+             ['poll-cancel-ton', 'c', []],
+             ['poll-link', 'c', thread_dep],
+             ['poll-many', 'c', []],
+             ['poll-ring', 'c', []],
+             ['poll-v-poll', 'c', thread_dep],
+             ['probe', 'c', []],
+             ['read-write', 'c', []],
+             ['register-restrictions', 'c', []],
+             ['rename', 'c', []],
+             ['ring-leak', 'c', []],
+             ['ring-leak2', 'c', thread_dep],
+             ['self', 'c', []],
+             ['send_recv', 'c', thread_dep],
+             ['send_recvmsg', 'c', thread_dep],
+             ['shared-wq', 'c', []],
+             ['short-read', 'c', []],
+             ['shutdown', 'c', []],
+             ['sigfd-deadlock', 'c', []],
+             ['socket-rw', 'c', []],
+             ['socket-rw-eagain', 'c', []],
+             ['sq-full', 'c', []],
+             ['sq-poll-dup', 'c', []],
+             ['sq-poll-kthread', 'c', []],
+             ['sq-poll-share', 'c', []],
+             ['sqpoll-exit-hang', 'c', []],
+             ['sqpoll-sleep', 'c', []],
+             ['sq-space_left', 'c', []],
+             ['stdout', 'c', []],
+             ['submit-reuse', 'c', thread_dep],
+             ['teardowns', 'c', []],
+             ['thread-exit', 'c', thread_dep],
+             ['timeout', 'c', []],
+             ['timeout-new', 'c', thread_dep],
+             ['timeout-overflow', 'c', []],
+             ['unlink', 'c', []],
+             ['wakeup-hang', 'c', thread_dep]]
+
+if has_statx
+    all_tests += [['statx', 'c', []]]
+endif
+
+if has_cxx
+    all_tests += [['sq-full-cpp', 'cc', []]]
+endif
+
+runtests_sh = find_program('runtests.sh')
+runtests_loop_sh = find_program('runtests-loop.sh')
+
+foreach t : all_tests
+    executable(t[0],
+               t[0] + '.' + t[1],
+               include_directories: inc,
+               link_with: liburing.get_static_lib(),
+               dependencies: t[2],
+               install: true,
+               install_dir: get_option('datadir') / 'liburing-test')
+
+    test(t[0],
+         runtests_sh,
+         args: t[0],
+         workdir : meson.current_build_dir(),
+         suite: 'once')
+
+    test(t[0] + '_loop',
+         runtests_loop_sh,
+         args: t[0],
+         workdir: meson.current_build_dir(),
+         suite: 'loop')
+endforeach
+
+configure_file(input: 'runtests.sh',
+               output: 'runtests.sh',
+               copy: true)
+
+configure_file(input: 'runtests-loop.sh',
+               output: 'runtests-loop.sh',
+               copy: true)
+
+configure_file(input: 'config',
+               output: 'config.local',
+               copy: true)
+
+install_data('runtests.sh',
+             'runtests-loop.sh',
+             install_dir: get_option('datadir') / 'liburing-test')
-- 
2.37.1

