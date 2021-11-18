Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D58455416
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 06:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhKRFOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 00:14:53 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:33144 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242463AbhKRFOv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Nov 2021 00:14:51 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id A63481F9F4;
        Thu, 18 Nov 2021 05:11:50 +0000 (UTC)
Date:   Thu, 18 Nov 2021 05:11:50 +0000
From:   Eric Wong <e@80x24.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PATCH v2 3/7] debian/rules: fix for newer debhelper
Message-ID: <20211118051150.GA10496@dcvr>
References: <20211118031016.354105-1-e@80x24.org>
 <20211118031016.354105-4-e@80x24.org>
 <4a3f4693-40dc-ec48-e25b-904dd73343b1@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4a3f4693-40dc-ec48-e25b-904dd73343b1@samba.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:
> I have this:
> 
> $ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description:    Ubuntu 20.04.3 LTS
> Release:        20.04
> Codename:       focal
> $ perl -MDebian::Debhelper::Dh_Version -e 'print "$Debian::Debhelper::Dh_Version::version\n";'
> 12.10ubuntu1
> 
> and it needs the --add-udeb argument.
> 
> So this still fails for me.

Ah, so the "ubuntu1" is causing the Perl version-string comparison to fail.
It should only be checking "v12.10"...

Does squashing this in help?

diff --git a/debian/rules b/debian/rules
index cd41bb8..73f53fe 100755
--- a/debian/rules
+++ b/debian/rules
@@ -84,7 +84,8 @@ binary-arch: install-arch
 # --add-udeb is needed for < 12.3, and breaks with auto-detection
 #  on debhelper 13.3.4, at least
 	if perl -MDebian::Debhelper::Dh_Version -e \
-	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
+	'($$v) = ($$Debian::Debhelper::Dh_Version::version =~ /\A([\d\.]+)/)' \
+	-e 'exit(eval("v$$v") lt v12.3)'; \
 		then dh_makeshlibs -a; else \
 		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
 

Also, just to confirm, does your dh_makeshlibs(1) manpage have this?:

       Since debhelper 12.3, dh_makeshlibs will by default add an additional
       udeb line for udebs in the shlibs file, when the udeb has the same name
       as the deb followed by a "-udeb" suffix (e.g. if the deb is called
       "libfoo1", then debhelper will auto-detect the udeb if it is named
       "libfoo1-udeb"). Please use the --add-udeb and --no-add-udeb options
       below when this auto-detection is insufficient.
