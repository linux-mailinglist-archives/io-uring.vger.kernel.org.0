Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3DB387D1F
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350477AbhERQOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 May 2021 12:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350527AbhERQOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 May 2021 12:14:15 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E363EC061573
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 09:12:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621354373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Em2v7MBg96EeAkrZl3ZdJ7/jTPEebOn7fhRpkYWs1io=;
        b=sPjh6SZor8TKGxW9O8gW3hiTYbPNlYY51VXLfXpX7C5RKhRiGORgFMqnmC8oXfOkyn7OTJ
        KG98WBRdX2QV91qPpagLT/XQP3HXBHDFFXsiAfBKDEn7sqlxNLXAEsLtNiUP0lxLuZvnCR
        8r5knCAzJbmlteLMFK7NpthUpS/wVdJariqCvoibR4+gQbxV4UrUJpwzyIVkzoq8Paynll
        e139vp6t/haTjSfNVmxpq9JQAgRIGm2NEPxBsxGuogzMNtV6HlO1vzVhXrZS6buduquJC4
        ylVzSHu01CVjsE61NVv4evivmnyqyvokOiFgIDUJSSmVT/mNcE0wp0rxunKOXQ==
From:   Drew DeVault <sir@cmpwn.com>
To:     io-uring@vger.kernel.org
Cc:     Drew DeVault <sir@cmpwn.com>, noah <goldstein.w.n@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>
Subject: [PATCH] Add IORING_FEAT_FILES_SKIP feature flag
Date:   Tue, 18 May 2021 12:12:41 -0400
Message-Id: <20210518161241.10532-1-sir@cmpwn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is aliased to IORING_FEAT_NATIVE_WORKERS, which was shipped in the
same kernel release. A separate flag is useful because the features are
unrelated, so user code testing for IORING_FEAT_NATIVE_WORKERS before
using FILES_SKIP is not very obvious in intent.

Signed-off-by: Drew DeVault <sir@cmpwn.com>
---
 man/io_uring_register.2         | 10 ++++++++--
 src/include/liburing/io_uring.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 5326a87..c71ce40 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -156,8 +156,14 @@ since 5.5.
 File descriptors can be skipped if they are set to
 .B IORING_REGISTER_FILES_SKIP.
 Skipping an fd will not touch the file associated with the previous
-fd at that index. Available since 5.12.
-
+fd at that index. Available since 5.12. Availability of this feature is
+indicated by the presence of the
+.B IORING_FEAT_FILES_SKIP
+bit in the
+.I features
+field of the
+.I io_uring_params
+structure.
 
 .TP
 .B IORING_UNREGISTER_FILES
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 5a3cb90..091dcf7 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -285,6 +285,7 @@ struct io_uring_params {
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
+#define IORING_FEAT_FILES_SKIP		IORING_FEAT_NATIVE_WORKERS
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.31.1

