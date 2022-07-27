Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB735829B8
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiG0Peb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbiG0Pea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:30 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9B324963
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:28 -0700 (PDT)
Received: (qmail 15226 invoked by uid 989); 27 Jul 2022 15:27:46 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 6/9] meson: support building without libc
Date:   Wed, 27 Jul 2022 17:27:20 +0200
Message-Id: <20220727152723.3320169-7-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999999)
X-Rspamd-Score: -5.599999
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:45 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a new meson option 'nolibc'.
Include the headers in src/arch when building liburing.
Build the src/syscall.c as seperate library for the tests when building
without libc.

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 meson.build       |  8 +++++++-
 meson_options.txt |  5 +++++
 src/meson.build   | 28 +++++++++++++++++++---------
 test/meson.build  |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/meson.build b/meson.build
index 0a63fef..e88e060 100644
--- a/meson.build
+++ b/meson.build
@@ -72,6 +72,10 @@ has_cxx = true
 has_ucontext = (cc.has_type('ucontext_t', prefix: '#include <ucontext.h>')
   and cc.has_function('makecontext', prefix: '#include <ucontext.h>'))
 
+nolibc = get_option('nolibc')
+
+build_tests = get_option('tests')
+
 conf_data = configuration_data()
 conf_data.set('CONFIG_HAVE_KERNEL_RWF_T', has__kernel_rwf_t)
 conf_data.set('CONFIG_HAVE_KERNEL_TIMESPEC', has__kernel_timespec)
@@ -80,6 +84,8 @@ conf_data.set('CONFIG_HAVE_STATX', has_statx)
 conf_data.set('CONFIG_HAVE_GLIBC_STATX', glibc_statx)
 conf_data.set('CONFIG_HAVE_CXX', has_cxx)
 conf_data.set('CONFIG_HAVE_UCONTEXT', has_ucontext)
+conf_data.set('CONFIG_NOLIBC', nolibc)
+conf_data.set('LIBURING_BUILD_TEST', build_tests)
 configure_file(output: 'config-host.h',
                configuration: conf_data)
 
@@ -90,7 +96,7 @@ if get_option('examples')
     subdir('examples')
 endif
 
-if get_option('tests')
+if build_tests
     if get_option('default_library') != 'both'
         error('default_library=both required to build tests')
     endif
diff --git a/meson_options.txt b/meson_options.txt
index e9f581a..5579b39 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -7,3 +7,8 @@ option('tests',
        type : 'boolean',
        value : false,
        description : 'Build test programs')
+
+option('nolibc',
+       type : 'boolean',
+       value : false,
+       description : 'Build liburing without libc')
diff --git a/src/meson.build b/src/meson.build
index fad0fca..8dd8139 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -1,18 +1,28 @@
 subdir('include')
 
-inc = include_directories(['include'])
+liburing_includes = include_directories(['include'])
+liburing_internal_includes = [liburing_includes]
+
+liburing_sources = ['queue.c', 'register.c', 'setup.c']
+liburing_c_args = ['-DLIBURING_INTERNAL', '-fno-stack-protector']
+liburing_link_args = ['-Wl,--version-script=' + meson.current_source_dir() + '/liburing.map']
+
+if nolibc
+  liburing_internal_includes += include_directories(['arch'])
+
+  liburing_sources += ['nolibc.c']
+  liburing_c_args += ['-nostdlib', '-nodefaultlibs', '-ffreestanding']
+  liburing_link_args += ['-nostdlib', '-nodefaultlibs']
+endif
 
 liburing = library('uring',
-                   'queue.c',
-                   'register.c',
-                   'setup.c',
-                   'syscall.c',
-                   include_directories: inc,
-                   c_args: ['-DLIBURING_INTERNAL', '-fno-stack-protector'],
-                   link_args: '-Wl,--version-script=' + meson.current_source_dir() + '/liburing.map',
+                   liburing_sources,
+                   include_directories: liburing_internal_includes,
+                   c_args: liburing_c_args,
+                   link_args: liburing_link_args,
                    link_depends: 'liburing.map',
                    version: meson.project_version(),
                    install: true)
 
 uring = declare_dependency(link_with: liburing,
-                           include_directories: inc)
+                           include_directories: liburing_includes)
diff --git a/test/meson.build b/test/meson.build
index af394a4..1537ad9 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -170,7 +170,7 @@ foreach test_source: all_tests
                [test_source, 'helpers.c'],
                c_args: xcflags,
                cpp_args: xcflags,
-               include_directories: inc,
+               include_directories: liburing_internal_includes,
                link_with: liburing.get_static_lib(),
                dependencies: test_dependencies,
                install: true,
-- 
2.37.1

