Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3020645531B
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 04:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbhKRDNl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 22:13:41 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:40552 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242656AbhKRDNP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 22:13:15 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 55BA71F9F4;
        Thu, 18 Nov 2021 03:10:16 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 0/7] liburing debian packaging fixes
Date:   Thu, 18 Nov 2021 03:10:09 +0000
Message-Id: <20211118031016.354105-1-e@80x24.org>
In-Reply-To: <20211116224456.244746-1-e@80x24.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

3 new patches on top of the original series, this addresses
the issues noticed by Stefan in the original series.

I'm getting these warnings from dpkg-gensymbols, but AFAIK
they're not fatal:

  dpkg-gensymbols: warning: new libraries appeared in the symbols file: liburing.so
  dpkg-gensymbols: warning: some libraries disappeared in the symbols file: liburing.so.1
  dpkg-gensymbols: warning: debian/liburing1/DEBIAN/symbols doesn't match completely debian/liburing1.symbols
  --- debian/liburing1.symbols (liburing1_2.1-1_amd64)
  +++ dpkg-gensymbolsHfPj7C	2021-11-18 03:07:48.131823699 +0000
  @@ -1,32 +1,41 @@
  -liburing.so.1 liburing1 #MINVER#
  - (symver)LIBURING_0.1 0.1-1
  - (symver)LIBURING_0.2 0.2-1
  - (symver)LIBURING_0.3 0.3-1
  - (symver)LIBURING_0.4 0.4-1
  - (symver)LIBURING_0.5 0.5-1
  - (symver)LIBURING_0.6 0.6-1
  - (symver)LIBURING_0.7 0.7-1
  - __io_uring_get_cqe@LIBURING_0.2 0.2-1
  - io_uring_get_probe@LIBURING_0.4 0.4-1
  - io_uring_get_probe_ring@LIBURING_0.4 0.4-1
  - io_uring_get_sqe@LIBURING_0.1 0.1-1
  - io_uring_peek_batch_cqe@LIBURING_0.2 0.2-1
  - io_uring_queue_exit@LIBURING_0.1 0.1-1
  - io_uring_queue_init@LIBURING_0.1 0.1-1
  - io_uring_queue_init_params@LIBURING_0.2 0.2-1
  - io_uring_queue_mmap@LIBURING_0.1 0.1-1
  - io_uring_register_buffers@LIBURING_0.1 0.1-1
  - io_uring_register_eventfd@LIBURING_0.1 0.1-1
  - io_uring_register_eventfd_async@LIBURING_0.6 0.6-1
  - io_uring_register_files@LIBURING_0.1 0.1-1
  - io_uring_register_files_update@LIBURING_0.2 0.2-1
  - io_uring_register_personality@LIBURING_0.4 0.4-1
  - io_uring_register_probe@LIBURING_0.4 0.4-1
  - io_uring_ring_dontfork@LIBURING_0.4 0.4-1
  - io_uring_submit@LIBURING_0.1 0.1-1
  - io_uring_submit_and_wait@LIBURING_0.1 0.1-1
  - io_uring_unregister_buffers@LIBURING_0.1 0.1-1
  - io_uring_unregister_files@LIBURING_0.1 0.1-1
  - io_uring_unregister_personality@LIBURING_0.4 0.4-1
  - io_uring_wait_cqe_timeout@LIBURING_0.2 0.2-1
  - io_uring_wait_cqes@LIBURING_0.2 0.2-1
  +liburing.so liburing1 #MINVER#
  + LIBURING_2.0@LIBURING_2.0 2.1-1
  + LIBURING_2.1@LIBURING_2.1 2.1-1
  + LIBURING_2.2@LIBURING_2.2 2.1-1
  + __io_uring_get_cqe@LIBURING_2.0 2.1-1
  + __io_uring_sqring_wait@LIBURING_2.0 2.1-1
  + io_uring_free_probe@LIBURING_2.0 2.1-1
  + io_uring_get_probe@LIBURING_2.0 2.1-1
  + io_uring_get_probe_ring@LIBURING_2.0 2.1-1
  + io_uring_get_sqe@LIBURING_2.0 2.1-1
  + io_uring_mlock_size@LIBURING_2.1 2.1-1
  + io_uring_mlock_size_params@LIBURING_2.1 2.1-1
  + io_uring_peek_batch_cqe@LIBURING_2.0 2.1-1
  + io_uring_queue_exit@LIBURING_2.0 2.1-1
  + io_uring_queue_init@LIBURING_2.0 2.1-1
  + io_uring_queue_init_params@LIBURING_2.0 2.1-1
  + io_uring_queue_mmap@LIBURING_2.0 2.1-1
  + io_uring_register_buffers@LIBURING_2.0 2.1-1
  + io_uring_register_buffers_tags@LIBURING_2.1 2.1-1
  + io_uring_register_buffers_update_tag@LIBURING_2.1 2.1-1
  + io_uring_register_eventfd@LIBURING_2.0 2.1-1
  + io_uring_register_eventfd_async@LIBURING_2.0 2.1-1
  + io_uring_register_files@LIBURING_2.0 2.1-1
  + io_uring_register_files_tags@LIBURING_2.1 2.1-1
  + io_uring_register_files_update@LIBURING_2.0 2.1-1
  + io_uring_register_files_update_tag@LIBURING_2.1 2.1-1
  + io_uring_register_iowq_aff@LIBURING_2.1 2.1-1
  + io_uring_register_iowq_max_workers@LIBURING_2.1 2.1-1
  + io_uring_register_personality@LIBURING_2.0 2.1-1
  + io_uring_register_probe@LIBURING_2.0 2.1-1
  + io_uring_ring_dontfork@LIBURING_2.0 2.1-1
  + io_uring_submit@LIBURING_2.0 2.1-1
  + io_uring_submit_and_wait@LIBURING_2.0 2.1-1
  + io_uring_submit_and_wait_timeout@LIBURING_2.2 2.1-1
  + io_uring_unregister_buffers@LIBURING_2.0 2.1-1
  + io_uring_unregister_eventfd@LIBURING_2.0 2.1-1
  + io_uring_unregister_files@LIBURING_2.0 2.1-1
  + io_uring_unregister_iowq_aff@LIBURING_2.1 2.1-1
  + io_uring_unregister_personality@LIBURING_2.0 2.1-1
  + io_uring_wait_cqe_timeout@LIBURING_2.0 2.1-1
  + io_uring_wait_cqes@LIBURING_2.0 2.1-1

Eric Wong (7):
  make-debs: fix version detection
  debian: avoid prompting package builder for signature
  debian/rules: fix for newer debhelper
  debian/rules: support parallel build
  debian: rename package to liburing2 to match .so version
  make-debs: use version from RPM .spec
  make-debs: remove dependency on git

 Makefile                                      |  5 ++++-
 debian/changelog                              |  6 ++++++
 debian/control                                |  6 +++---
 ...g1-udeb.install => liburing2-udeb.install} |  0
 .../{liburing1.install => liburing2.install}  |  0
 .../{liburing1.symbols => liburing2.symbols}  |  2 +-
 debian/rules                                  | 21 +++++++++++++++++--
 make-debs.sh                                  | 19 ++++++++++++-----
 8 files changed, 47 insertions(+), 12 deletions(-)
 rename debian/{liburing1-udeb.install => liburing2-udeb.install} (100%)
 rename debian/{liburing1.install => liburing2.install} (100%)
 rename debian/{liburing1.symbols => liburing2.symbols} (97%)

Range-diff against v1:
1:  d3d6028 = 1:  bc20a43 make-debs: fix version detection
2:  49d995f ! 2:  c61015a debian: avoid prompting package builder for signature
    @@ Commit message
         them locally on a development system which may not have private
         keys.
     
    +    While "debuild -us -uc" could also be used to avoid signatures,
    +    using "UNRELEASED" also helps communicate to changelog readers
    +    that the package(s) are not from an official Debian source.
    +
         AFAIK the official Debian package is maintained separately at
         <https://git.hadrons.org/git/debian/pkgs/liburing.git>,
         and won't be affected by this change.
3:  2774a5e ! 3:  8a10758 debian/rules: fix for newer debhelper
    @@ Commit message
     
         Reading the current dh_makeshlibs(1) manpage reveals --add-udeb
         is nowadays implicit as of debhelper 12.3 and no longer
    -    necessary.  Compatibility with Debian oldstable (buster) remains
    -    intact.  Tested with debhelper 12.1.1 on Debian 10.x (buster)
    -    and debhelper 13.3.4 on Debian 11.x (bullseye).
    +    necessary.  Compatibility with older debhelper on Debian
    +    oldstable (buster) remains intact.  Tested with debhelper 12.1.1
    +    on Debian 10.x (buster) and debhelper 13.3.4 on Debian 11.x
    +    (bullseye).
     
         Signed-off-by: Eric Wong <e@80x24.org>
     
    @@ debian/rules: binary-arch: install-arch
      	dh_fixperms -a
     -	dh_makeshlibs -a --add-udeb '$(libudeb)'
     +
    -+# --add-udeb is needed for <= 12.3, and breaks with auto-detection
    ++# --add-udeb is needed for < 12.3, and breaks with auto-detection
     +#  on debhelper 13.3.4, at least
     +	if perl -MDebian::Debhelper::Dh_Version -e \
    -+	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") le v12.3)'; \
    ++	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
     +		then dh_makeshlibs -a; else \
     +		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
     +
4:  cbc950c = 4:  ca43b96 debian/rules: support parallel build
-:  ------- > 5:  c33d422 debian: rename package to liburing2 to match .so version
-:  ------- > 6:  9e27918 make-debs: use version from RPM .spec
-:  ------- > 7:  bbc1200 make-debs: remove dependency on git
