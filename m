Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF062C7A44
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgK2RdJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2RdI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:33:08 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E4BC0613D2
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:28 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id 64so12018548wra.11
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UokOhwEZXPKSMw138xED25wHOwtlXMHTwi6GJVud/ig=;
        b=orXmzmWr37gcFQXyAUOF3Wz/9kar69p0IWmo1GQvbD8GGMcgrvEFRDbRYuiiN8hltl
         8vbnPu3Y6ABfZDaMk1Mr9/N/UGFTeN+e4Rl3YMcIkmlKA9hSsWR2xlPKk+woHQaGSVDT
         vUI5I0CNaxpt9RO2+BH7jTUThJL6kUnxCKHLUNm+x+nhgDlM9eeKJUVtBSW3o5+ndvd7
         J1fwuzi/Qe/QZnClAKtEZzGD+r3faqF42lbBNxr9smjqxSlEdXliZb0pQyPr2u6DgnW2
         xVa70kOodtYzXUYZifjDgzBI/mtwUrHp6iN1yz64XU2Nm1KhKT7Gc99YDziZUFQoRg5t
         jw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UokOhwEZXPKSMw138xED25wHOwtlXMHTwi6GJVud/ig=;
        b=IJUR6D6O1jgb31k9p4BcyaEDNHNF4dSYOY05/13GguhsLTcxNm3093X/310RNKyeOb
         co9/JZ3+MIQ6yQ3aMmwkszBqit2qKO2ssIvy53pVHdP4hWv4MSN8PpMsZQCO+XC1xBSA
         oYS3lvqF9DBi/Ae+Edlegl3PcSRKELP6Tw/jZyIzGl5gUQBhSKco2wajxBYaSuvu9jTG
         VLhPL1ZRvhAjR08mQIhiSzOlKUpKwYZ1ZwsfJYVdusJiRBsahbYOXXUD5Zwp+kHGpFGQ
         FQxPnLL9lAKuz+Gsjc04Nrlm2LT5pWaeFJO5q9yGY8ZN9QNQDPOCTQJUb7zMrRr5YFb4
         r3Dw==
X-Gm-Message-State: AOAM531LWVGkBNQ9KmDX1GVaqr1IXup+jp48ISyhXvjxsHQzTRvp8Um6
        wJp5+TN7OrEjkeNhirCmAM+iPfiSzq0=
X-Google-Smtp-Source: ABdhPJw45yx481CFLSQUp6K5CBmY8Uo7cENnEMx6qJOEazw/gCgVeQQ6ZWkV5806utghFlpQQ/aLcw==
X-Received: by 2002:adf:a551:: with SMTP id j17mr23810280wrb.217.1606671147041;
        Sun, 29 Nov 2020 09:32:27 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id l24sm25306377wrb.28.2020.11.29.09.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:32:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] Add timeout update
Date:   Sun, 29 Nov 2020 17:29:06 +0000
Message-Id: <aad4e71874ead60dab48fb949722a0256557dc36.1606670836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606670836.git.asml.silence@gmail.com>
References: <cover.1606670836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_uring_prep_timeout_update() helper and update io_uring.h.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          | 9 +++++++++
 src/include/liburing/io_uring.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cc32232..ebfc424 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -326,6 +326,15 @@ static inline void io_uring_prep_timeout_remove(struct io_uring_sqe *sqe,
 	sqe->timeout_flags = flags;
 }
 
+static inline void io_uring_prep_timeout_update(struct io_uring_sqe *sqe,
+						struct __kernel_timespec *ts,
+						__u64 user_data, unsigned flags)
+{
+	io_uring_prep_rw(IORING_OP_TIMEOUT_REMOVE, sqe, -1,
+				(void *)(unsigned long)user_data, 0, (__u64)ts);
+	sqe->timeout_flags = flags | IORING_TIMEOUT_UPDATE;
+}
+
 static inline void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 					struct sockaddr *addr,
 					socklen_t *addrlen, int flags)
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 8555de9..abdc737 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -155,6 +155,7 @@ enum {
  * sqe->timeout_flags
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
+#define IORING_TIMEOUT_UPDATE	(1U << 31)
 
 /*
  * sqe->splice_flags
-- 
2.24.0

