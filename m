Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50A3383DAC
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhEQTns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 15:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhEQTnr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 15:43:47 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA1C061573
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 12:42:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621280545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A0bLEENqsSFK1RconDgHLjIfzCQL17TLzG8OXu0IieU=;
        b=q4tcXnAJroJWQMq8iRoem/aFElFAcGNuyVZuvCWio89zuE5i4VS2o1G/zKvnx+yelt+82J
        6oFst8Cdit8gGUNInB/kwTqfK6n7cPisosSEvzHIiDNFWsDFcCb4ywmmYT13+Xh7hGNzeg
        MDkhbzaROD/hyWw2ESy7MYNEB3BfjrjX0/x146KEddKK10ywIJ828gK6BAW65juRN48HPQ
        BbcwxndW3DSTYps74xNZmTZ3St/tj9XrHypZIoglVl0ODDGthaxdE9Tv+a7nEYVxawj94c
        3Wsu5aiJwkQhSoLXniswq1TsG3XgCZNgzQK7RyQS8wyj9ktHjJzDZL/kl6SHkg==
From:   Drew DeVault <sir@cmpwn.com>
To:     io-uring@vger.kernel.org
Cc:     Drew DeVault <sir@cmpwn.com>, noah <goldstein.w.n@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
Date:   Mon, 17 May 2021 15:22:53 -0400
Message-Id: <20210517192253.23313-1-sir@cmpwn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This signals that the kernel supports IORING_REGISTER_FILES_SKIP.

Signed-off-by: Drew DeVault <sir@cmpwn.com>
---
 fs/io_uring.c                 | 3 ++-
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e481ac8a757a..6338c4892cd2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9659,7 +9659,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS;
+			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
+			IORING_FEAT_FILES_SKIP;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..1b0887ab4d07 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,7 @@ struct io_uring_params {
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
+#define IORING_FEAT_FILES_SKIP		(1U << 10)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.31.1

