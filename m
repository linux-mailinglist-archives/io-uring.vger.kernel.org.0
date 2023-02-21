Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA95D69D7E0
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjBUBHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjBUBHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:08 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C4B22030
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:04 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p3-20020a05600c358300b003e206711347so2026477wmq.0
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMVNMVd8aSkCu82AxH2WGVGFz2ZJ4OqZ2LItsoW1tpA=;
        b=NvnFUSnHOiyDJ9pYIONsKlbo+1DA/p755XNrAnRQ8jgMp9lWU3vZdM2Y9R5cRHDsxD
         3IOv7n0GGXCouqFGbt/LTDp3x6QpP2ipUQnGf3w3s3tIDGBreaDEf0kuFYefXveHiO79
         UZSDQ/pXvqOnxFZORt3irdgdwlxCxCo0R/xk4Rl0CJikhLmOXH85n9CiYRkGTpYxKVNW
         X2hJNE3Z56KJCNTRqaXAGgi9zeYEaIKL5+RCF8u8zZ4mKfIP/Ak3hgbXPOBllLrfiBTY
         2F0bF/GotmubyS4x8lzNosPVFqSch7NEv7W4Nz4zmYqgQ4myuBMkW5lrG+ShOaVl8Sh/
         FxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMVNMVd8aSkCu82AxH2WGVGFz2ZJ4OqZ2LItsoW1tpA=;
        b=DobD53Lgc9Ighhy65d6Mb2PMsDm+/wQlY0P7+LKkWrEdPb9vR8soBw0MOEiaveIJy2
         lwJh31qLC1DQVsqysNTNrCwm5g9rkK/mrctijZQxFGjglA+Zyv3EQykUYYakpXuGz3t0
         9n4NSDW9xOH7o/HprHnao2NX2uKx5Hy8aPUMmkZgviCJ/bCKkFa+lAWyha8llGPcvD2F
         B1eLcdABb8rlZT/p4v9aUbrOjxmoR6iB2U6z5G1sl4Qq72On0eWHhnu7R8cxDoPKh8Wa
         cHIJpErMmKdN8tY907uQZwNwi9NuMRlyOnRViZepla2RLETfR6eYxGd8wTH3k9YB7xRw
         ZEiA==
X-Gm-Message-State: AO0yUKWHpQ4ZO1CbFACTZuVAtvI36Pd6cMfKSJU4EtPcJWZOEKVo4te+
        2kQQQITr2nY0J+5zt4sNfUdXPsin99Q=
X-Google-Smtp-Source: AK7set+NMsgXGBUmZY6XDJZnb3T7nmOovtOun9naV9Fx4lRsHFjaIouN2FLdVGxY5rHkAHOLXYx33g==
X-Received: by 2002:a05:600c:3b11:b0:3e2:669:757 with SMTP id m17-20020a05600c3b1100b003e206690757mr1739705wms.10.1676941622730;
        Mon, 20 Feb 2023 17:07:02 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/7] send: test send with hugetlb
Date:   Tue, 21 Feb 2023 01:05:54 +0000
Message-Id: <c89fe57dea283ab376eb97a2dbc073c36720a880.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index e663be7..f1277fa 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -33,6 +33,8 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/wait.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
 
 #include "liburing.h"
 #include "helpers.h"
@@ -56,6 +58,9 @@ enum {
 	BUF_T_SMALL,
 	BUF_T_NONALIGNED,
 	BUF_T_LARGE,
+	BUF_T_HUGETLB,
+
+	__BUF_NR,
 };
 
 /* 32MB, should be enough to trigger a short send */
@@ -63,7 +68,7 @@ enum {
 
 static size_t page_sz;
 static char *tx_buffer, *rx_buffer;
-static struct iovec buffers_iov[4];
+static struct iovec buffers_iov[__BUF_NR];
 static bool has_sendmsg;
 
 static bool check_cq_empty(struct io_uring *ring)
@@ -748,6 +753,11 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	srand((unsigned)time(NULL));
+	for (i = 0; i < len; i++)
+		tx_buffer[i] = i;
+	memset(rx_buffer, 0, len);
+
 	buffers_iov[BUF_T_NORMAL].iov_base = tx_buffer + page_sz;
 	buffers_iov[BUF_T_NORMAL].iov_len = page_sz;
 	buffers_iov[BUF_T_SMALL].iov_base = tx_buffer;
@@ -755,17 +765,26 @@ int main(int argc, char *argv[])
 	buffers_iov[BUF_T_NONALIGNED].iov_base = tx_buffer + BUFFER_OFFSET;
 	buffers_iov[BUF_T_NONALIGNED].iov_len = 2 * page_sz - BUFFER_OFFSET - 13;
 
+	if (len == LARGE_BUF_SIZE) {
+		void *huge_page;
+		int off = page_sz + 27;
+
+		len = 1U << 22;
+		huge_page = mmap(NULL, len, PROT_READ|PROT_WRITE,
+				 MAP_PRIVATE | MAP_HUGETLB | MAP_HUGE_2MB | MAP_ANONYMOUS,
+				 -1, 0);
+		if (huge_page != MAP_FAILED) {
+			buffers_iov[BUF_T_HUGETLB].iov_base = huge_page + off;
+			buffers_iov[BUF_T_HUGETLB].iov_len = len - off;
+		}
+	}
+
 	ret = io_uring_queue_init(32, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	srand((unsigned)time(NULL));
-	for (i = 0; i < len; i++)
-		tx_buffer[i] = i;
-	memset(rx_buffer, 0, len);
-
 	ret = test_basic_send(&ring, sp[0], sp[1]);
 	if (ret == T_EXIT_SKIP)
 		return ret;
-- 
2.39.1

