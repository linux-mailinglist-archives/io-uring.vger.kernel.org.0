Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D00B3B3100
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFXOMs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOMr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DCAC061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:28 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m3so4065043wms.4
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GQh04pfIDLhgeGnJiOT0X+Ue2bnUsF2jJyhnvBXJevE=;
        b=WgdfkeqXIWMXeKyMDc74YX3Cu+QpdN12+LyLjyV1jADitzveq2u+RKEvhHIaqtdS63
         kl+eBLnWMxXbK44YQ13qh0C68YDkLbUbEJaI55xriABhfLZAnfvvy+ZG6Ot1J406Qea+
         QSMzfLoXh6m3xBy1l2YpANavpJm+vQwvzvUze6XcmGSDN2HzxZTfzzrWtg98RM6k5LKK
         m4HaKiABkGK6+zHJvaQyMo7OleNDXcwUWNgZQDAQtV0MnlqaOkP3I6ZBW5FiVH/DkaGS
         0Fmdd3t4m1My3nGuM64FXoa6Dz44EDqi8tE2fyz0XgHw2P3wkBPbUQiR9WLu9jkAkNsT
         rccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GQh04pfIDLhgeGnJiOT0X+Ue2bnUsF2jJyhnvBXJevE=;
        b=cfI61uz8Mqr3e4f1Y584cKMqewfdpyD2ds5wSmuX6mse23rJ4zBIVl3nKzTfeaNIoa
         4RF6osHggQa6kxeaSVWyOXcnbMnm8nK1AfuKw8+3uhbnccfSm/6iHxWsGGXtshVGZq+Y
         /vKld+U+WF+tM1aP4Vlqy+dPOZBYJNhEnQ5au+ongkBtgYoCZ3+zeB+h2SgZzHJkiGtV
         LNDfn+lS7qzio0snvitsz22TcS/E9hSerwkNxK0zHK4QPPJTFgp4T7EbwDTwnh26lTZz
         4nPsuRYJGu8W6vVcZ3I/9G5n/bq0ikiIipHSb+khchQTvxonjR7BsSPLfmyfRnJBzyqu
         M5Tw==
X-Gm-Message-State: AOAM5327PDbdzajqW+Ig67klNz2grRFjZb8Of8wyq3qNRIT6WoaSCs4V
        xnSSyL9wqHFCBaUMbNvLGPg=
X-Google-Smtp-Source: ABdhPJxH4TKp06XaP+0HQmucpBB5hBaVtsme1Admza5H+yJsN3BLzIqOkv7Lb04lcWxWrF6dC6sQGg==
X-Received: by 2002:a1c:544e:: with SMTP id p14mr4629686wmi.152.1624543827047;
        Thu, 24 Jun 2021 07:10:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: simplify struct io_uring_sqe layout
Date:   Thu, 24 Jun 2021 15:09:59 +0100
Message-Id: <2e21ef7aed136293d654450bc3088973a8adc730.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Flatten struct io_uring_sqe, the last union is exactly 64B, so move them
out of union { struct { ... }}, and decrease __pad2 size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c735fc22e459..10eb38d2864f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -47,21 +47,17 @@ struct io_uring_sqe {
 		__u32		hardlink_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
+	/* pack this to avoid bogus arm OABI complaints */
 	union {
-		struct {
-			/* pack this to avoid bogus arm OABI complaints */
-			union {
-				/* index into fixed buffers, if used */
-				__u16	buf_index;
-				/* for grouped buffer selection */
-				__u16	buf_group;
-			} __attribute__((packed));
-			/* personality to use, if used */
-			__u16	personality;
-			__s32	splice_fd_in;
-		};
-		__u64	__pad2[3];
-	};
+		/* index into fixed buffers, if used */
+		__u16	buf_index;
+		/* for grouped buffer selection */
+		__u16	buf_group;
+	} __attribute__((packed));
+	/* personality to use, if used */
+	__u16	personality;
+	__s32	splice_fd_in;
+	__u64	__pad2[2];
 };
 
 enum {
-- 
2.32.0

