Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058AD455321
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 04:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbhKRDNy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 22:13:54 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:41258 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242647AbhKRDNv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Nov 2021 22:13:51 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 1B3A21FA19;
        Thu, 18 Nov 2021 03:10:17 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 6/7] make-debs: use version from RPM .spec
Date:   Thu, 18 Nov 2021 03:10:15 +0000
Message-Id: <20211118031016.354105-7-e@80x24.org>
In-Reply-To: <20211118031016.354105-1-e@80x24.org>
References: <20211118031016.354105-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

git tags may be behind the .spec file during development, so
favor the .spec file as in commit c0b43df28a982747
(src/Makefile: use VERSION variable consistently, 2021-11-15).
This brings us one step closer to being able to build Debian
packages without git.

Signed-off-by: Eric Wong <e@80x24.org>
---
 Makefile     | 5 ++++-
 make-debs.sh | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 28c0fd8..48fb48a 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,10 @@ all:
 	@$(MAKE) -C test
 	@$(MAKE) -C examples
 
-.PHONY: all install default clean test
+print-version:
+	@echo $(VERSION)
+
+.PHONY: all install default clean test print-version
 .PHONY: FORCE cscope
 
 partcheck: all
diff --git a/make-debs.sh b/make-debs.sh
index aea05f0..0913c47 100755
--- a/make-debs.sh
+++ b/make-debs.sh
@@ -32,7 +32,7 @@ src_dir=$(readlink -e `basename $0`)
 liburing_dir=$(dirname $src_dir)
 basename=$(basename $liburing_dir)
 dirname=$(dirname $liburing_dir)
-version=$(git describe --match "lib*" | cut -d '-' -f 2)
+version=$(make print-version | tail -n1)
 outfile="liburing-$version"
 orgfile=$(echo $outfile | tr '-' '_')
 
