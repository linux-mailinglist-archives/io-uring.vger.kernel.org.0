Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8673975E8
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhFAPAl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 11:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhFAPAi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 11:00:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756D6C061574;
        Tue,  1 Jun 2021 07:58:56 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z8so9564495wrp.12;
        Tue, 01 Jun 2021 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r+ZDp2MX14n2P2eiCGRvIM1kDjuYaOV/V/d7u2BhKxU=;
        b=C9W+uhYumE184gHUe2A17WI1k6OUSKnUMSOlPxD9DzuqrJLhDNIQkGaKWUKIEiW4v1
         mNeh2Y4YpZnQs1t27DpJQ3jjUuxr/OzZLDbmGOsx1aCDwyzOl2TGF8e9t6rFT04DPqV6
         m4sPMX+LJfq3mrA4LQ97TpK6CI01oePa/rfDWPLfZoiYnxzpS+vMqpYR+epbx7JQ8K2K
         gXiReU9pjUIzNjq2u5fe6yghw+ZR7qJDdTEEYS9sKhUT7EOFMf4tAz0wCoEDsurME/vM
         Sc+Wophdi9+3KOlYQp4+xQNhUe0gnxqhbiWsuySYfv1/OrJiCv7dnEwfbEIOIA1vqZsz
         DAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r+ZDp2MX14n2P2eiCGRvIM1kDjuYaOV/V/d7u2BhKxU=;
        b=j2opq+UQCnfmq6kvGiDfUXBZMFLXGM5TnlHCPbcU6qoabRV4FGouKk/RKdHdMU3SIK
         VLzo5FRnE3n0UxMsc0ja7tSxKyy9M13d9YZYC4ZP5Rgy6MaKZrvqwIaghIMlFIENLlE/
         vo3N1D+4MEg2nII03kYkyzq5+SYYZhDFZwGuqjQbKpxKqTzPUlae4D8+9qPjhEqvfPLz
         NVandNtbYZK7fICmogHsxcv8EEqw98wt6KoaqEAajTCJp7R8s/p70xbBFoJnImu12xUO
         HMuQEa+CvuQMoA8ESHH5NdpdhhA07cE8Tm2dLllq7QyZSBbileada3yN3DwssU3i2FjK
         21Qg==
X-Gm-Message-State: AOAM530vwDPtmuvf8Pt2alWVut45yf5h0Zz03gI6j4Jf/w3DJRw3I7LW
        qXuZsHX2ToUKqV+RH80skTfMEObLDm/hHw==
X-Google-Smtp-Source: ABdhPJyrg5+f0xUmH302dzE4IPBJ0+uJdRyhon962O01ooqk7iAaOTm4XMlIRidsWPcg2jCEYjuAEQ==
X-Received: by 2002:adf:eb86:: with SMTP id t6mr28618701wrn.253.1622559534854;
        Tue, 01 Jun 2021 07:58:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id b4sm10697061wmj.42.2021.06.01.07.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:58:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC 4/4] io_uring: implement futex wait
Date:   Tue,  1 Jun 2021 15:58:29 +0100
Message-Id: <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622558659.git.asml.silence@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add futex wait requests, those always go through io-wq for simplicity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 38 ++++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  2 +-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99f4f8d9f685..9c3d075a6647 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -670,8 +670,15 @@ struct io_futex {
 	struct file			*file;
 	unsigned int			futex_op;
 
-	unsigned int			nr_wake;
-	unsigned int			wake_op_arg;
+	union {
+		/* wake */
+		struct {
+			unsigned int	nr_wake;
+			unsigned int	wake_op_arg;
+		};
+		/* wait */
+		u32 			val;
+	};
 	unsigned int			flags;
 	void __user			*uaddr;
 };
@@ -5894,10 +5901,23 @@ static int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	v = READ_ONCE(sqe->off);
-	f->nr_wake = (u32)v;
-	f->wake_op_arg = (u32)(v >> 32);
-	f->futex_op = READ_ONCE(sqe->futex_op);
 	f->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	f->futex_op = READ_ONCE(sqe->futex_op);
+
+	switch (f->futex_op) {
+	case IORING_FUTEX_WAKE_OP:
+		f->nr_wake = (u32)v;
+		f->wake_op_arg = (u32)(v >> 32);
+		break;
+	case IORING_FUTEX_WAIT:
+		f->val = (u32)v;
+		if (unlikely(v >> 32))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -5916,8 +5936,12 @@ static int io_futex(struct io_kiocb *req, unsigned int issue_flags)
 		if (nonblock && ret == -EAGAIN)
 			return -EAGAIN;
 		break;
-	default:
-		ret = -EINVAL;
+	case IORING_FUTEX_WAIT:
+		if (nonblock)
+			return -EAGAIN;
+		ret = futex_wait(f->uaddr, f->flags, f->val, NULL,
+				 FUTEX_BITSET_MATCH_ANY);
+		break;
 	}
 
 	if (ret < 0)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6fa5a6e59934..7ab11ee2ce12 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -186,7 +186,7 @@ enum {
 
 enum {
 	IORING_FUTEX_WAKE_OP = 0,
-
+	IORING_FUTEX_WAIT,
 	IORING_FUTEX_LAST,
 };
 
-- 
2.31.1

