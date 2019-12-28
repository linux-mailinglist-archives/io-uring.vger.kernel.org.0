Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B58D312BEAE
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfL1TV1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55112 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfL1TV1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:27 -0500
Received: by mail-pj1-f68.google.com with SMTP id kx11so6167609pjb.4
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YPpUUym820AYcTi/mgn1dTAQDhjwtBGZh6R48GgyPdQ=;
        b=0+tkLJGB5gPiCvvE9sUUk6HoAvvjZ9cAYUm6bdAIyGQ7R3aJD48NIR4Ny1TrisnKvJ
         3PHX4JE/FSByB2xjMQ+6Vxe1lFwyx7RNQPwhCE1oQDmDm0eKTeLzrZZIG/IUJLBm3zSy
         FyH7U0wEI/HfZokIWYRlabbjC1WcF46suM0wXgm/i6Z6GDBJAyjA+pUhVhZhUotq5Zu3
         KWEXGRp7bhaLn1Gj6FDY+lKpn1utEprslW7cMocDSZjiHwI4eoVbWZ0ZBmRM8Y0AGyFK
         wUlC1yzRBixbn6wErbqb7ZyhMdhzxOf+XJ0UWE/MDdbf7pxXW0xC7SUz7++3k220mT7O
         zV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YPpUUym820AYcTi/mgn1dTAQDhjwtBGZh6R48GgyPdQ=;
        b=pFUuPWl6iIs0G5AjFL74HScS2ONq2HTxqxePY8sFA0usB+Vhii2tUs/JF9lfM5ruER
         quNPCkNq8v4cLO6Eu4fjDw12KvwGgENkKLtg+sOFWI5QsKLRhGMLYjzuso0EczgotoYW
         A+p56KNh0BcgAlNOe8iQnvGdypXvPH3fkyx/YdiVHUbCPj6nmg1t8eYVdUyaaT7RoFlg
         cn1CTo5ymSJIltqtDwUu4KcP5PXgjrEYjoVIynyvSQ+eHcnQbqVztXse7T36QKSjrUH+
         Qgb9mDq21YKRjkPsp7aBAlg8C/BN3zZ4rXUaN0PV0YmZi8bxNzbsKtSlcTmgjRKrPZUa
         n1dA==
X-Gm-Message-State: APjAAAWRZEZko49UDAhbXWd2aF2T2kSXdKy34BqyVZ/bs3tADP0PVPVL
        zA4N2aDoagEr4hURUh72DePyvG7J5jvPqg==
X-Google-Smtp-Source: APXvYqzAleo3ciWHKmZ3KOWWZQ/PTB5W9agsC1EA5UFQMAj24YZ4liot9AD7ZuHHfgOyU+2zk2nlpw==
X-Received: by 2002:a17:902:6b09:: with SMTP id o9mr54360965plk.209.1577560886319;
        Sat, 28 Dec 2019 11:21:26 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 6/9] io_uring: allow use of offset == -1 to mean file position
Date:   Sat, 28 Dec 2019 12:21:15 -0700
Message-Id: <20191228192118.4005-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This behaves like preadv2/pwritev2 with offset == -1, it'll use (and
update) the current file position. This obviously comes with the caveat
that if the application has multiple read/writes in flight, then the
end result will not be as expected. This is similar to threads sharing
a file descriptor and doing IO using the current file position.

Since this feature isn't easily detectable by doing a read or write,
add a feature flags, IORING_FEAT_RW_CUR_POS, to allow applications to
detect presence of this feature.

Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 11 ++++++++++-
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 464ca73f2dd3..b24fcb4272be 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -495,6 +495,7 @@ struct io_kiocb {
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
 #define REQ_F_FORCE_ASYNC	131072	/* IOSQE_ASYNC */
+#define REQ_F_CUR_POS		262144	/* read/write uses file position */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1713,6 +1714,10 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
+	if (kiocb->ki_pos == -1 && !(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		kiocb->ki_pos = req->file->f_pos;
+	}
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 
@@ -1784,6 +1789,10 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt,
 		       bool in_async)
 {
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
+	if (req->flags & REQ_F_CUR_POS)
+		req->file->f_pos = kiocb->ki_pos;
 	if (in_async && ret >= 0 && kiocb->ki_complete == io_complete_rw)
 		*nxt = __io_complete_rw(kiocb, ret);
 	else
@@ -6153,7 +6162,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 		goto err;
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE;
+			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 03d2dde46152..80f892628e66 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -174,6 +174,7 @@ struct io_uring_params {
 #define IORING_FEAT_SINGLE_MMAP		(1U << 0)
 #define IORING_FEAT_NODROP		(1U << 1)
 #define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
+#define IORING_FEAT_RW_CUR_POS		(1U << 3)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.24.1

