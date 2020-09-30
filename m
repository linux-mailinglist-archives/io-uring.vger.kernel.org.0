Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48AE27F2D6
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgI3UAr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UAq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E47CC061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z4so3147710wrr.4
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ezLqihm2KgRitBbY3qHhfc43cqat9V6zjqZA3t75GnM=;
        b=Azo6TTm2Vr/1VO9TZ24lLDCWpoSDdpCiQ6AKoex3d6QLSHcm3FYH+trtw/TXmIkkcJ
         cI7zZ9Qna4uRjBjiyjzXipPYX58enkFxMzNRYNWDU2VOaAJKfonE5gMRHggFwS2yiEbE
         HvhVjo2Z9xgLXXfAIICtZ8uUXdjxh8nnTjv8iFJVUXRMCDLZ7fwfshjW8W6JEobUw4r9
         thNURWBrHqrs8IHRXISYAl1yD41+qx3cI1eqQOQ68ecGZ/lCN138b7M/hGUswccjzQ85
         0rLc8ZO0ZTEjCPpJL4+hEWKc1pjPes3zyYlSpbxmsXyi6b9+lW0Dpq3lSEuLMWBuVSC+
         h84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ezLqihm2KgRitBbY3qHhfc43cqat9V6zjqZA3t75GnM=;
        b=njFNVV/V8O6wz4supiXPra6Jn2dol72AFBqGoC81cp6rfFgu+7KD8g1m+HVmMXujIi
         GYEg6zmXyrbySmCWdVnvr3Ck3OeLPBauFj9iBWSr5hJw6o1Y8vT9Ks8x4A+uKQZA35KD
         X7Lzsfhyz32KlcKtoEF00pM/3mzwWqRC+kLkKEMSnChpFERATN5n2PyV1r38Fu3DEYuz
         wt5t7U/vNlZeNjKoNdchLWVCZYcTMA9NQVlm/RAmSgsy8tMzYx2KpaCl3NYNNOZ+5M0I
         lKGQr0o3MVM+o4b8ib/q4e+Hnplrep3Q9dUl49ylkbHUBzxHj2dhK6VF2H7v4LNNW2Ov
         j8/w==
X-Gm-Message-State: AOAM5328DUzmugz4dqlm+gP5E+miA+qc7VESnOpLGVgHfiYVXZLZR25h
        F8sSnA6NdOi1AEThRH2NPjw=
X-Google-Smtp-Source: ABdhPJx9u5OOVEIBZctJnNHpiGsa5bcydecFXJHpoMNEx7yFZz1pg8KbL88s7TXxa3c9o2naQuDJZg==
X-Received: by 2002:a5d:4591:: with SMTP id p17mr4791487wrq.408.1601496045104;
        Wed, 30 Sep 2020 13:00:45 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id x17sm5127176wrg.57.2020.09.30.13.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: decouple issuing and req preparation
Date:   Wed, 30 Sep 2020 22:57:55 +0300
Message-Id: <208eee65aa1139997518de0d1d2d5c00126fab29.1601495335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601495335.git.asml.silence@gmail.com>
References: <cover.1601495335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_issue_sqe() does two things at once, trying to prepare request and
issuing them. Split it in two and deduplicate with io_defer_prep().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 266 +++++++++++---------------------------------------
 1 file changed, 55 insertions(+), 211 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24f411aa4d1f..0ce0ebee4808 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5519,121 +5519,94 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static int io_req_defer_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
+static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	ssize_t ret = 0;
-
-	if (!sqe)
-		return 0;
-
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-	ret = io_prep_work_files(req);
-	if (unlikely(ret))
-		return ret;
-
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		break;
+		return 0;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		ret = io_read_prep(req, sqe);
-		break;
+		return io_read_prep(req, sqe);
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		ret = io_write_prep(req, sqe);
-		break;
+		return io_write_prep(req, sqe);
 	case IORING_OP_POLL_ADD:
-		ret = io_poll_add_prep(req, sqe);
-		break;
+		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove_prep(req, sqe);
-		break;
+		return io_poll_remove_prep(req, sqe);
 	case IORING_OP_FSYNC:
-		ret = io_prep_fsync(req, sqe);
-		break;
+		return io_prep_fsync(req, sqe);
 	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_prep_sfr(req, sqe);
-		break;
+		return io_prep_sfr(req, sqe);
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
-		ret = io_sendmsg_prep(req, sqe);
-		break;
+		return io_sendmsg_prep(req, sqe);
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
-		ret = io_recvmsg_prep(req, sqe);
-		break;
+		return io_recvmsg_prep(req, sqe);
 	case IORING_OP_CONNECT:
-		ret = io_connect_prep(req, sqe);
-		break;
+		return io_connect_prep(req, sqe);
 	case IORING_OP_TIMEOUT:
-		ret = io_timeout_prep(req, sqe, false);
-		break;
+		return io_timeout_prep(req, sqe, false);
 	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove_prep(req, sqe);
-		break;
+		return io_timeout_remove_prep(req, sqe);
 	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel_prep(req, sqe);
-		break;
+		return io_async_cancel_prep(req, sqe);
 	case IORING_OP_LINK_TIMEOUT:
-		ret = io_timeout_prep(req, sqe, true);
-		break;
+		return io_timeout_prep(req, sqe, true);
 	case IORING_OP_ACCEPT:
-		ret = io_accept_prep(req, sqe);
-		break;
+		return io_accept_prep(req, sqe);
 	case IORING_OP_FALLOCATE:
-		ret = io_fallocate_prep(req, sqe);
-		break;
+		return io_fallocate_prep(req, sqe);
 	case IORING_OP_OPENAT:
-		ret = io_openat_prep(req, sqe);
-		break;
+		return io_openat_prep(req, sqe);
 	case IORING_OP_CLOSE:
-		ret = io_close_prep(req, sqe);
-		break;
+		return io_close_prep(req, sqe);
 	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update_prep(req, sqe);
-		break;
+		return io_files_update_prep(req, sqe);
 	case IORING_OP_STATX:
-		ret = io_statx_prep(req, sqe);
-		break;
+		return io_statx_prep(req, sqe);
 	case IORING_OP_FADVISE:
-		ret = io_fadvise_prep(req, sqe);
-		break;
+		return io_fadvise_prep(req, sqe);
 	case IORING_OP_MADVISE:
-		ret = io_madvise_prep(req, sqe);
-		break;
+		return io_madvise_prep(req, sqe);
 	case IORING_OP_OPENAT2:
-		ret = io_openat2_prep(req, sqe);
-		break;
+		return io_openat2_prep(req, sqe);
 	case IORING_OP_EPOLL_CTL:
-		ret = io_epoll_ctl_prep(req, sqe);
-		break;
+		return io_epoll_ctl_prep(req, sqe);
 	case IORING_OP_SPLICE:
-		ret = io_splice_prep(req, sqe);
-		break;
+		return io_splice_prep(req, sqe);
 	case IORING_OP_PROVIDE_BUFFERS:
-		ret = io_provide_buffers_prep(req, sqe);
-		break;
+		return io_provide_buffers_prep(req, sqe);
 	case IORING_OP_REMOVE_BUFFERS:
-		ret = io_remove_buffers_prep(req, sqe);
-		break;
+		return io_remove_buffers_prep(req, sqe);
 	case IORING_OP_TEE:
-		ret = io_tee_prep(req, sqe);
-		break;
+		return io_tee_prep(req, sqe);
 	case IORING_OP_SHUTDOWN:
-		ret = io_shutdown_prep(req, sqe);
-		break;
-	default:
-		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
-				req->opcode);
-		ret = -EINVAL;
-		break;
+		return io_shutdown_prep(req, sqe);
 	}
 
-	return ret;
+	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
+			req->opcode);
+	return -EINVAL;
+}
+
+static int io_req_defer_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	if (!sqe)
+		return 0;
+	if (io_alloc_async_data(req))
+		return -EAGAIN;
+
+	ret = io_prep_work_files(req);
+	if (unlikely(ret))
+		return ret;
+	return io_req_prep(req, sqe);
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
@@ -5758,6 +5731,12 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	if (sqe) {
+		ret = io_req_prep(req, sqe);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, cs);
@@ -5765,62 +5744,27 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		if (sqe) {
-			ret = io_read_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_read(req, force_nonblock, cs);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		if (sqe) {
-			ret = io_write_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_write(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FSYNC:
-		if (sqe) {
-			ret = io_prep_fsync(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_fsync(req, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
-		if (sqe) {
-			ret = io_poll_add_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_poll_add(req);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		if (sqe) {
-			ret = io_poll_remove_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_poll_remove(req);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
-		if (sqe) {
-			ret = io_prep_sfr(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_sync_file_range(req, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
-		if (sqe) {
-			ret = io_sendmsg_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		if (req->opcode == IORING_OP_SENDMSG)
 			ret = io_sendmsg(req, force_nonblock, cs);
 		else
@@ -5828,166 +5772,66 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
-		if (sqe) {
-			ret = io_recvmsg_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		if (req->opcode == IORING_OP_RECVMSG)
 			ret = io_recvmsg(req, force_nonblock, cs);
 		else
 			ret = io_recv(req, force_nonblock, cs);
 		break;
 	case IORING_OP_TIMEOUT:
-		if (sqe) {
-			ret = io_timeout_prep(req, sqe, false);
-			if (ret)
-				break;
-		}
 		ret = io_timeout(req);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
-		if (sqe) {
-			ret = io_timeout_remove_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_timeout_remove(req);
 		break;
 	case IORING_OP_ACCEPT:
-		if (sqe) {
-			ret = io_accept_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_accept(req, force_nonblock, cs);
 		break;
 	case IORING_OP_CONNECT:
-		if (sqe) {
-			ret = io_connect_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_connect(req, force_nonblock, cs);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
-		if (sqe) {
-			ret = io_async_cancel_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_async_cancel(req);
 		break;
 	case IORING_OP_FALLOCATE:
-		if (sqe) {
-			ret = io_fallocate_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_fallocate(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT:
-		if (sqe) {
-			ret = io_openat_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_openat(req, force_nonblock);
 		break;
 	case IORING_OP_CLOSE:
-		if (sqe) {
-			ret = io_close_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_close(req, force_nonblock, cs);
 		break;
 	case IORING_OP_FILES_UPDATE:
-		if (sqe) {
-			ret = io_files_update_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_files_update(req, force_nonblock, cs);
 		break;
 	case IORING_OP_STATX:
-		if (sqe) {
-			ret = io_statx_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_statx(req, force_nonblock);
 		break;
 	case IORING_OP_FADVISE:
-		if (sqe) {
-			ret = io_fadvise_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_fadvise(req, force_nonblock);
 		break;
 	case IORING_OP_MADVISE:
-		if (sqe) {
-			ret = io_madvise_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_madvise(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
-		if (sqe) {
-			ret = io_openat2_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_openat2(req, force_nonblock);
 		break;
 	case IORING_OP_EPOLL_CTL:
-		if (sqe) {
-			ret = io_epoll_ctl_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_epoll_ctl(req, force_nonblock, cs);
 		break;
 	case IORING_OP_SPLICE:
-		if (sqe) {
-			ret = io_splice_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_splice(req, force_nonblock);
 		break;
 	case IORING_OP_PROVIDE_BUFFERS:
-		if (sqe) {
-			ret = io_provide_buffers_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_provide_buffers(req, force_nonblock, cs);
 		break;
 	case IORING_OP_REMOVE_BUFFERS:
-		if (sqe) {
-			ret = io_remove_buffers_prep(req, sqe);
-			if (ret)
-				break;
-		}
 		ret = io_remove_buffers(req, force_nonblock, cs);
 		break;
 	case IORING_OP_TEE:
-		if (sqe) {
-			ret = io_tee_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_tee(req, force_nonblock);
 		break;
 	case IORING_OP_SHUTDOWN:
-		if (sqe) {
-			ret = io_shutdown_prep(req, sqe);
-			if (ret < 0)
-				break;
-		}
 		ret = io_shutdown(req, force_nonblock);
 		break;
 	default:
-- 
2.24.0

