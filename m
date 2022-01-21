Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898834964FB
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiAUS0l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:41 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50864 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382083AbiAUS0j (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:39 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 7E4F51FA00;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PATCH v3 2/7] debian: avoid prompting package builder for signature
Date:   Fri, 21 Jan 2022 18:26:30 +0000
Message-Id: <20220121182635.1147333-3-e@80x24.org>
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
References: <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

By setting the distribution to "UNRELEASED", debuild(1) will no
longer prompt users to sign the package(s).  I expect most users
building these Debian packages with make-debs.sh will be using
them locally on a development system which may not have private
keys.

While "debuild -us -uc" could also be used to avoid signatures,
using "UNRELEASED" also helps communicate to changelog readers
that the package(s) are not from an official Debian source.

AFAIK the official Debian package is maintained separately at
<https://git.hadrons.org/git/debian/pkgs/liburing.git>,
and won't be affected by this change.

Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/changelog | 6 ++++++
 make-debs.sh     | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index f0032e3..fbc361b 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+liburing (2.0-1) UNRELEASED; urgency=low
+
+  * development package built for local use
+
+ -- Local User <user@example.com>  Tue, 16 Nov 2021 18:04:09 +0000
+
 liburing (0.7-1) stable; urgency=low
 
   * Update to 0.7
diff --git a/make-debs.sh b/make-debs.sh
index 136b79e..aea05f0 100755
--- a/make-debs.sh
+++ b/make-debs.sh
@@ -20,7 +20,10 @@ set -o pipefail
 
 # Create dir for build
 base=${1:-/tmp/release}
-codename=$(lsb_release -sc)
+
+# UNRELEASED here means debuild won't prompt for signing
+codename=UNRELEASED
+
 releasedir=$base/$(lsb_release -si)/liburing
 rm -rf $releasedir
 mkdir -p $releasedir
