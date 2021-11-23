Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D004598FC
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 01:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhKWALr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 19:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhKWALr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 19:11:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18F2C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:39 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso627428wml.1
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8kYpT/l2Ee4j67z15tJSK24Y/mYRN2vaS2d4YvfKjM=;
        b=mTdNngraVp9KUTNpRYDXNNOOhyVIsrWWALhD904Vf56S/VRoKGyLxgP8Y/MTlw/81I
         Y52YQhHRmmH0UDRqy/Gvq6+hNa7Z4ik4Jjy7lqPchoNKnAbXHGOZNv2wamiOr3QLLsHK
         Z6RmdXXr2xSegh2rn9Bc2RoZlUd6LaruGx6G0bWa4EqSC2PSkOZE61SsQ0JgMER8mTR3
         d7Y73FqX8TCYfOvWB3ikgdmnrLNkCOj5ulMl4mK8go15wSmpr2OeFAnzV4pRCWL0L/ob
         ya4qZXihnkeZ7MUDHDpO/TjA0Wwu1dY5JTsk9QakNR7fCuRYOU3Kk39TBXWr3b05AwXD
         ombA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8kYpT/l2Ee4j67z15tJSK24Y/mYRN2vaS2d4YvfKjM=;
        b=c/KxNAw5FRtAXhihxWnUzWmI2WNyw1Mq4h/21r0VQwtzhatGtmMlA3BdPSa6nSFtYe
         Y07Oi6jhjQOS6A6bpUesoiiAIVvxzz/lzN/lmB05MM7lFsZ9ps0O+umcLgVjkI2bOKs6
         C/4ERnVZ1OzNBY/CDJLb2n8qVjhNajjRlk3NVb64Wln2PkGG4T/kRdYfSVctTRjZ/v9P
         DKRA82AFFZSjhjOz1JPQuGfBQmqsFjOm9Zab6U3O96Ayjc0dZcxRR0wUrpKe2VqbD6RM
         71ucnJPhGqbcjqUXzW7NnpGDx49UU9dzRjdgjCwOyI/4LX5pdaIA/FisM4aVArSt7WPx
         Cqlg==
X-Gm-Message-State: AOAM531i5S4SYlXZmQ6W3CcehcBN9y5BlNpdGFILgQ0RQa2HBeTVH+Td
        ESCbGpEVWfBxJti2vjvh5qsqtgLo5Jc=
X-Google-Smtp-Source: ABdhPJybS4xFh6NmDgp4OzOFRvF057Uc9HU91MOn2pvEVJ7BySiNhkHO7CRI3IKPKyXlHvT2BMYjAQ==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr1506616wmg.145.1637626118343;
        Mon, 22 Nov 2021 16:08:38 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id r62sm10139409wmr.35.2021.11.22.16.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:08:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/4] io_uring: improve argument types of kiocb_done()
Date:   Tue, 23 Nov 2021 00:07:49 +0000
Message-Id: <252016eed77806f58b48251a85cd8c645f900433.1637524285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637524285.git.asml.silence@gmail.com>
References: <cover.1637524285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

kiocb_done() accepts a pointer to struct kiocb, pass struct io_kiocb
(i.e. io_uring's request) instead so we can get rid of useless
container_of().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3b44867d4499..2158d5c4fd0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2922,10 +2922,9 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
+static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
 
 	/* add previously done IO, if any */
@@ -2937,11 +2936,11 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	}
 
 	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
+		req->file->f_pos = req->rw.kiocb.ki_pos;
+	if (ret >= 0 && (req->rw.kiocb.ki_complete == io_complete_rw))
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
-		io_rw_done(kiocb, ret);
+		io_rw_done(&req->rw.kiocb, ret);
 
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -3584,7 +3583,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 	} while (ret > 0);
 done:
-	kiocb_done(kiocb, ret, issue_flags);
+	kiocb_done(req, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
@@ -3681,7 +3680,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto copy_iov;
 done:
-		kiocb_done(kiocb, ret2, issue_flags);
+		kiocb_done(req, ret2, issue_flags);
 	} else {
 copy_iov:
 		iov_iter_restore(&s->iter, &s->iter_state);
-- 
2.33.1

