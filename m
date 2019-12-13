Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1F11EA7A
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfLMSgs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:48 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:38364 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfLMSgr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:47 -0500
Received: by mail-io1-f65.google.com with SMTP id v3so647055ioj.5
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8mvrfoU5fjtmV9bGsLJ5bvKErIr5JboWLd+OqRbct8U=;
        b=wTh3TlYZwLU7u47jKmMvSfzvrN9XZVQnh3OwhWUfoM0WIJid3N0sD0zpK22hnXAH6P
         qcbhIXAt59stJloyfCLoFZ6igtsGN6pmzWPjgIk4Lix5FA+7J8gyujoOaoKLxKUn7j3i
         pl+/wj3TMvg98ZGToHzY1rOopu/AreNGYw48pww0nUH7fJb4tFJa6pXak2+hSd3Nqbns
         mzFg2pSAQj4dVisNkbRaV8gwF03JcBNZnTClWG6TI7+M8i4CAyfualL8SKQGNeblXmdA
         wS9mYiJLCEejMqaah6ZRBf/vs+kLwfiz1COIebzJ0ct/z71Bo/zstb3n77Hb4kmfruGl
         kqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8mvrfoU5fjtmV9bGsLJ5bvKErIr5JboWLd+OqRbct8U=;
        b=jo0feJBAAc41yWMjAG5vFpqVpypZ+K16+raZwfMN/9zmuDjkmTm4t2DtpNYL4S7d8/
         IYMRnVyaxSRM9sP/W49XwGSf8Ogj05ImoPXcl134qUHvoys+/1/2Gvb80oOH2JIqNkuc
         TAKmLqnETtCi/Bf3V3tAxD24cqkpX857RdnIxkPmUsxaLpsob0hpcIcDR3OlXUmwn1Kl
         WoePMGoAh+iaF0VNAqaT9a46k1M0Jj6Inla+RSGj1ccYIMhsM33FMJu+IGqNhZW8oGSE
         8PazoWyB3fdxPmpmmxIDw96G38jpGrO7g6Y88r6Gzu7B3EgrzY2p0KizOt+9k1lfktTH
         0LBQ==
X-Gm-Message-State: APjAAAV/h7Qy0uEPObsvndC1QOdDQbiM1h3mco0703OpZBDfaE4DVZpZ
        JcscfFNvJ2HBRosSVfLYMo3XY0JFpsjpAw==
X-Google-Smtp-Source: APXvYqzVCEpOVXcUq8nJCEWoL/HqdbB4g89uCdezZpRpfgHbnkqbm5MyL/bslp/VzGPqdvlzHeULsg==
X-Received: by 2002:a5d:96c6:: with SMTP id r6mr8727568iol.236.1576262206029;
        Fri, 13 Dec 2019 10:36:46 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] io_uring: add support for IORING_OP_CLOSE
Date:   Fri, 13 Dec 2019 11:36:30 -0700
Message-Id: <20191213183632.19441-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This works just like close(2), unsurprisingly. We remove the file
descriptor and post the completion inline, then offload the actual
(potential) last file put to async context.

Mark the async part of this work as uncancellable, as we really must
guarantee that the latter part of the close is run.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 70 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 71 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 132f887ef18d..927f28112f0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -298,6 +298,11 @@ struct io_poll_iocb {
 	struct wait_queue_entry		wait;
 };
 
+struct io_close {
+	struct file			*file;
+	struct file			*put_file;
+};
+
 struct io_timeout_data {
 	struct io_kiocb			*req;
 	struct hrtimer			timer;
@@ -350,6 +355,7 @@ struct io_kiocb {
 		struct file		*file;
 		struct kiocb		rw;
 		struct io_poll_iocb	poll;
+		struct io_close		close;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -2093,6 +2099,64 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
+		    bool force_nonblock)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+	int ret, fd;
+
+	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
+	    sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	fd = READ_ONCE(sqe->fd);
+	if (req->file->f_op == &io_uring_fops || fd == req->ring_fd)
+		return -EBADF;
+
+	/*
+	 * If we queue this for async, it must not be cancellable. That would
+	 * leave the 'file' in an undeterminate state.
+	 */
+	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
+
+	ret = 0;
+	if (force_nonblock) {
+		req->close.put_file = NULL;
+		ret = __close_fd_get_file(fd, &req->close.put_file);
+		if (ret < 0)
+			return ret;
+
+		/* if the file has a flush method, be safe and punt to async */
+		if (req->close.put_file->f_op->flush) {
+			req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+			return -EAGAIN;
+		}
+
+		/*
+		 * No ->flush(), safely close from here and just punt the
+		 * fput() to async context.
+		 */
+		ret = filp_close(req->close.put_file, current->files);
+		if (ret < 0)
+			req_set_fail_links(req);
+
+		io_cqring_add_event(req, ret);
+		return -EAGAIN;
+	} else {
+		/* Invoked with files, we need to do the close */
+		if (req->work.files) {
+			ret = filp_close(req->close.put_file, req->work.files);
+			if (ret < 0)
+				req_set_fail_links(req);
+			io_cqring_add_event(req, ret);
+		}
+		fput(req->close.put_file);
+	}
+
+	io_put_req_find_next(req, nxt);
+	return ret;
+}
+
 static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3116,6 +3180,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_OPENAT:
 		ret = io_openat(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_CLOSE:
+		ret = io_close(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3275,6 +3342,9 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (!req->ring_file)
+		return -EBADF;
+
 	rcu_read_lock();
 	spin_lock_irq(&ctx->inflight_lock);
 	/*
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 02af580754ce..42a7f0e8dee3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -79,6 +79,7 @@ enum {
 	IORING_OP_CONNECT,
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
+	IORING_OP_CLOSE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

