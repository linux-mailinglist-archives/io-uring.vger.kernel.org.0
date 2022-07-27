Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7F5829B3
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiG0PeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiG0PeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:22 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456EC1F61F
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:21 -0700 (PDT)
Received: (qmail 15032 invoked by uid 989); 27 Jul 2022 15:27:38 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 2/9] meson: update meson build files for liburing 2.3
Date:   Wed, 27 Jul 2022 17:27:16 +0200
Message-Id: <20220727152723.3320169-3-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: ------
X-Rspamd-Report: MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.996886)
X-Rspamd-Score: -6.096886
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:38 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

* meson has builtin methods to check if the used compiler supports certain
  types and their expected members. Therefore we don't need to check if code
  using those types compiles. This makes the build file more readable.
  Suggested-By: Nils Tonnätt <nils.tonnaett@posteo.de>

* do not use -Wpedantic like the custom build system

* check if ucontext functions are available. See: b5f2347

* add explicit run_command check kwarg
  The default will change in future meson versions causing possible
  unexpected behavior.
  And the awk command should not fail in the first place.

* set -DLIBURING_INTERNAL introduced in 8be8af4a

* include linux/openat2.h for struct open_how. See: 326ed975

* check if glibc provides struct statx. See: 44b12f5

* use -O3 as default. See: 7d1cce2

* update project CFLAGS. Remove -fomit-frame-pointer (de21479) and
  add -fno-stack-protector (2de9832).
  Reported-by: Eli Schwartz <eschwartz@archlinux.org>

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 meson.build                      | 81 ++++++++++++--------------------
 src/include/liburing/meson.build |  7 ++-
 src/meson.build                  |  1 +
 test/meson.build                 |  2 +-
 4 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/meson.build b/meson.build
index cb7dd9e..7c91b97 100644
--- a/meson.build
+++ b/meson.build
@@ -1,103 +1,80 @@
 project('liburing', ['c','cpp'],
-        version: run_command('awk', '/Version:/ { print $2 }', 'liburing.spec').stdout().strip(),
+        version: run_command('awk', '/Version:/ { print $2 }', 'liburing.spec', check: true).stdout().strip(),
         license: ['MIT', 'LGPL-2.1-only', 'GPL-2.0-only WITH Linux-syscall-note'],
         meson_version: '>=0.53.0',
         default_options: ['default_library=both',
                           'buildtype=debugoptimized',
                           'c_std=c11',
                           'cpp_std=c++11',
-                          'warning_level=3'])
+                          'optimization=3',
+                          'warning_level=2'])
 
 add_project_arguments('-D_GNU_SOURCE',
                       '-D__SANE_USERSPACE_TYPES__',
                       '-include', meson.current_build_dir() + '/config-host.h',
                       '-Wno-unused-parameter',
                       '-Wno-sign-compare',
-                      '-fomit-frame-pointer',
                       language: ['c', 'cpp'])
 
 thread_dep = dependency('threads')
 
 cc = meson.get_compiler('c')
 
-code = '''#include <linux/fs.h>
-int main(int argc, char **argv)
-{
-  __kernel_rwf_t x;
-  x = 0;
-  return x;
-}
-'''
-has__kernel_rwf_t = cc.compiles(code, name : '__kernel_rwf_t')
+has__kernel_rwf_t = cc.has_type('__kernel_rwf_t', prefix: '#include <linux/fs.h>')
 
-code = '''#include <linux/time.h>
-#include <linux/time_types.h>
-int main(int argc, char **argv)
-{
-  struct __kernel_timespec ts;
-  ts.tv_sec = 0;
-  ts.tv_nsec = 1;
-  return 0;
-}
-'''
-has__kernel_timespec = cc.compiles(code, name : '__kernel_timespec')
+has__kernel_timespec = cc.has_members('struct __kernel_timespec',
+                                      'tv_sec',
+                                      'tv_nsec',
+                                      prefix: '#include <linux/time.h>')
+
+has_open_how = cc.has_members('struct open_how',
+                                      'flags',
+                                      'mode',
+                                      'resolve',
+                                      prefix: '#include <linux/openat2.h>')
 
 code = '''#include <sys/types.h>
 #include <sys/stat.h>
+#include <unistd.h>
 #include <fcntl.h>
 #include <string.h>
+#include <linux/stat.h>
 int main(int argc, char **argv)
 {
-  struct open_how how;
-  how.flags = 0;
-  how.mode = 0;
-  how.resolve = 0;
-  return 0;
+  struct statx x;
+
+  return memset(&x, 0, sizeof(x)) != NULL;
 }
 '''
-has_open_how = cc.compiles(code, name: 'open_how')
+has_statx = cc.compiles(code, name: 'statx')
 
-code = '''#include <sys/types.h>
-#include <sys/stat.h>
+code= '''#include <sys/types.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <string.h>
 #include <linux/stat.h>
-int main(int argc, char **argv)
+main(int argc, char **argv)
 {
   struct statx x;
 
   return memset(&x, 0, sizeof(x)) != NULL;
 }
 '''
-has_statx = cc.compiles(code, name: 'statx')
-
-cpp = meson.get_compiler('cpp')
+glibc_statx = cc.compiles(code, name: 'glibc_statx')
 
-code = '''#include <iostream>
-int main(int argc, char **argv)
-{
-  std::cout << "Test";
-  return 0;
-}
-'''
-has_cxx = cpp.compiles(code, name: 'C++')
+# Since the project is configured to use C++
+# meson fails if no C++ compiler is available.
+has_cxx = true
 
-code = '''#include <ucontext.h>
-int main(int argc, char **argv)
-{
-  ucontext_t ctx;
-  getcontext(&ctx);
-  return 0;
-}
-'''
-has_ucontext = cc.compiles(code, name : 'ucontext')
+has_ucontext = (cc.has_type('ucontext_t', prefix: '#include <ucontext.h>')
+  and cc.has_function('makecontext', prefix: '#include <ucontext.h>'))
 
 conf_data = configuration_data()
 conf_data.set('CONFIG_HAVE_KERNEL_RWF_T', has__kernel_rwf_t)
 conf_data.set('CONFIG_HAVE_KERNEL_TIMESPEC', has__kernel_timespec)
 conf_data.set('CONFIG_HAVE_OPEN_HOW', has_open_how)
 conf_data.set('CONFIG_HAVE_STATX', has_statx)
+conf_data.set('CONFIG_HAVE_GLIBC_STATX', glibc_statx)
 conf_data.set('CONFIG_HAVE_CXX', has_cxx)
 conf_data.set('CONFIG_HAVE_UCONTEXT', has_ucontext)
 configure_file(output: 'config-host.h',
diff --git a/src/include/liburing/meson.build b/src/include/liburing/meson.build
index f60cbc7..ed5c65b 100644
--- a/src/include/liburing/meson.build
+++ b/src/include/liburing/meson.build
@@ -19,7 +19,7 @@ struct __kernel_timespec {
 endif
 
 if has_open_how
-    open_how_compat = ''
+    open_how_compat = '#include <linux/openat2.h>'
 else
     open_how_compat = '''#include <inttypes.h>
 
@@ -35,6 +35,11 @@ conf_data = configuration_data()
 conf_data.set('__kernel_rwf_t_compat', __kernel_rwf_t_compat)
 conf_data.set('__kernel_timespec_compat', __kernel_timespec_compat)
 conf_data.set('open_how_compat', open_how_compat)
+
+if not glibc_statx and has_statx
+  conf_data.set('no_glibc_statx', '#include <stat/stat.h>')
+endif
+
 configure_file(input: 'compat.h.in',
                output: 'compat.h',
                configuration: conf_data,
diff --git a/src/meson.build b/src/meson.build
index b3aa751..fad0fca 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -8,6 +8,7 @@ liburing = library('uring',
                    'setup.c',
                    'syscall.c',
                    include_directories: inc,
+                   c_args: ['-DLIBURING_INTERNAL', '-fno-stack-protector'],
                    link_args: '-Wl,--version-script=' + meson.current_source_dir() + '/liburing.map',
                    link_depends: 'liburing.map',
                    version: meson.project_version(),
diff --git a/test/meson.build b/test/meson.build
index 888b74d..60b50c2 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -97,7 +97,7 @@ all_tests = [['232c93d07b74-test', 'c', thread_dep],
              ['unlink', 'c', []],
              ['wakeup-hang', 'c', thread_dep]]
 
-if has_statx
+if has_statx or glibc_statx
     all_tests += [['statx', 'c', []]]
 endif
 
-- 
2.37.1

