Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911A14964FD
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382093AbiAUS0q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:46 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50912 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381955AbiAUS0p (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:45 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id CA2991FA10;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PATCH v3 4/7] debian/rules: support parallel build
Date:   Fri, 21 Jan 2022 18:26:32 +0000
Message-Id: <20220121182635.1147333-5-e@80x24.org>
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
References: <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This bit stolen from the debian/rules file of `git'
speeds up builds from ~35s to ~10s for me.

Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/rules | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/debian/rules b/debian/rules
index 6631b10..f26271e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -9,6 +9,16 @@ DEB_CFLAGS_MAINT_PREPEND = -Wall
 include /usr/share/dpkg/default.mk
 include /usr/share/dpkg/buildtools.mk
 
+# taken from the debian/rules of src:git
+ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
+  NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
+  MAKEFLAGS += -j$(NUMJOBS)
+  # Setting this with a pattern-specific rule prevents -O from
+  # affecting the top-level make, which would break realtime build
+  # output (unless dh is run as +dh, which causes other problems).
+  %: MAKEFLAGS += -O
+endif
+
 export CC
 
 lib := liburing1
