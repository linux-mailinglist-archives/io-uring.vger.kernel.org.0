Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3947D11EA6A
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfLMSgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:37 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36481 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728796AbfLMSgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:37 -0500
Received: by mail-io1-f68.google.com with SMTP id a22so663112ios.3
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U7isoIObpuRRvGbDmlJPXFmnp7SHo6u55T+05rXJIhk=;
        b=V1JgPYs9GYLnWWGbB/pAa3+atwjeMO5ZlhkFhkc8E/ahNRqhnIHvZxZ5/IAFVWkXpb
         Q+7gxX+Gsu3MkK+MvgcElGFhrv2iyB7Ezo/lYfw2V384/TKfGzXy6ajaOO93Bsfg7XfT
         DJ8jc79up0e5rQHS/5oOsDail4nKRqrAWe4MsgXfNdWZoBpd7pIddO/lMpUFyIsDxPXR
         vz5i9VqJGaHAUIs7xrC+32T0OmlpXwj2/yk5wROERWeZOYjEw6ordFM9J3zhsdbiz4jm
         ffZcD8K/3lvqlLgYNwHlT3byn1k0pnmOJmr4yVmTLCSmcd/RO7XTMDPBTymWH77fkQzt
         7yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U7isoIObpuRRvGbDmlJPXFmnp7SHo6u55T+05rXJIhk=;
        b=oBqEsHLss6Ikjd4OIdvdvgisWO1t8TkTOTN633bY67woc4DjVmrtS09LaqYAPKlPbC
         ESAOaYpZS8ckZzWwq8fKyJ/viAiXH+09xy7PMzOBbnY5P1qSxRTwsZa/Jl1e5w9p+O6E
         IeRFGu99kOnKiTP4JouOI9lKweaT3+J+gdU4qPxVwFMyVfcT0ukICjEAF86ss67Kw4G8
         zLuJAgRuqdJLztUku6cdWWmtGE1nVjesIFhowH5pi662fEs+wrTOG6KMStMNRtEO2igp
         Rpgh3QufKS7y2js2l+Wjz9s6770zVSnZfb5XXLX6Axwbf3hY98EcYnA7X/drYQgOwoO7
         j4lQ==
X-Gm-Message-State: APjAAAV5w65Z1rmEMhGOr2C7Hm11ZedCJ8HQFkXxvrMt/L4ov/QXnd4T
        eE0AYCZYLGwlM/vvuGoFMqk1vMWX+HRVmw==
X-Google-Smtp-Source: APXvYqyMCRq/HKzzM2Kr95H2+asaRrKeYF/lWVJBYnbOzJo8ilwYYQaltp9jY/K8CGHtVX4k9n192w==
X-Received: by 2002:a6b:f60e:: with SMTP id n14mr8659684ioh.241.1576262196463;
        Fri, 13 Dec 2019 10:36:36 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/10] io_uring: add support for fallocate()
Date:   Fri, 13 Dec 2019 11:36:23 -0700
Message-Id: <20191213183632.19441-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This exposes fallocate(2) through io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 29 +++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b1833fedc5c..d780477b9a56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1974,6 +1974,32 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static int io_fallocate(struct io_kiocb *req, struct io_kiocb **nxt,
+			bool force_nonblock)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+	loff_t offset, len;
+	int ret, mode;
+
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+		return -EINVAL;
+
+	/* fallocate always requiring blocking context */
+	if (force_nonblock)
+		return -EAGAIN;
+
+	offset = READ_ONCE(sqe->off);
+	len = READ_ONCE(sqe->addr);
+	mode = READ_ONCE(sqe->len);
+
+	ret = vfs_fallocate(req->file, mode, offset, len);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2983,6 +3009,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel(req, req->sqe, nxt);
 		break;
+	case IORING_OP_FALLOCATE:
+		ret = io_fallocate(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a3300e1b9a01..bdbe2b130179 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -76,6 +76,7 @@ enum {
 	IORING_OP_ASYNC_CANCEL,
 	IORING_OP_LINK_TIMEOUT,
 	IORING_OP_CONNECT,
+	IORING_OP_FALLOCATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

