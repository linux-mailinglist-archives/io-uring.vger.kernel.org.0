Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FD5455452
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 06:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbhKRFiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 00:38:20 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:34876 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241800AbhKRFiM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Nov 2021 00:38:12 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id CD60D1F9F4;
        Thu, 18 Nov 2021 05:35:12 +0000 (UTC)
Date:   Thu, 18 Nov 2021 05:35:12 +0000
From:   Eric Wong <e@80x24.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
Subject: Re: [PATCH v2 3/7] debian/rules: fix for newer debhelper
Message-ID: <20211118053512.M750014@dcvr>
References: <20211118031016.354105-1-e@80x24.org>
 <20211118031016.354105-4-e@80x24.org>
 <4a3f4693-40dc-ec48-e25b-904dd73343b1@samba.org>
 <20211118051150.GA10496@dcvr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211118051150.GA10496@dcvr>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eric Wong <e@80x24.org> wrote:
> Does squashing this in help?

Sorry, I missed a semi-colon and temporarily lost connectivity
to my bullseye machine :x  Tested on both bullseye and buster, now

diff --git a/debian/rules b/debian/rules
index cd41bb8..d0b4eea 100755
--- a/debian/rules
+++ b/debian/rules
@@ -84,7 +84,8 @@ binary-arch: install-arch
 # --add-udeb is needed for < 12.3, and breaks with auto-detection
 #  on debhelper 13.3.4, at least
 	if perl -MDebian::Debhelper::Dh_Version -e \
-	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
+	'($$v) = ($$Debian::Debhelper::Dh_Version::version =~ /\A([\d\.]+)/);' \
+	-e 'exit(eval("v$$v") lt v12.3)'; \
 		then dh_makeshlibs -a; else \
 		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
 
