Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A041D67A9
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgEQLTc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgEQLTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:19:30 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BEAC05BD09;
        Sun, 17 May 2020 04:19:30 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so6795306ljd.3;
        Sun, 17 May 2020 04:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9wt+O+yv/PQr9z525iw+0SXZ25Ejzm66XRYb+KUwGw4=;
        b=KzXUO/0e/U2U3jf8/0azMceYt7Tb+FOrIhkouxp36MBvrDy1XNnEfMwRJXAhKx+5oF
         /B+C/WYoqCFhCLShik3HTZvXIEqMKHMxBiF/AophQhHMMfLyJ/c/rIiRodG/fh/QrabH
         Fjef5Hz7g4qUCvj54TOAFvx8+T+BuOaFgFvZerOwwLzmD4iYZNo5XEZGg5p26Ho5/u5p
         kXWkgX73WIU4p9dhRg4TwY4H+UnSFcPaglGLtja8kvNoJEftOhwWiXPRXbd1nukIrcyb
         cPz0xv2Ypv3z61KRa8xW6e8/B9Mn2tDEeb2Ggzy1IGRsSoH7h6GZoqGUxG/Rbi9UgwS6
         gPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wt+O+yv/PQr9z525iw+0SXZ25Ejzm66XRYb+KUwGw4=;
        b=pwpeA3h9W5Jnjj0NvepyeEOeWFWFKS9grMUOWQzSn3Fj/jSd/N7xOPhmYe79BkPP8u
         4MHzd+UTE7QTxxd8TISjnlUVDNM51MsIKvInHsftTSXoI14vHznEj+LVoKNlv8E4TO5m
         BjBpENywdznVdP+avGINCmRXBQV7enQttkufTF1zw//E3PFRPs5B3jAgus+unVFBXlTO
         0+lYDC73dSpov8rtKyRHI2sn/oR99YrkYpPSWNMD2tz+hH6xRSvBvX5Exbt7hErWzx8e
         N5AcCYUBKRKyNgaTR8AIre7t8rgGz+ctaoZ+ggP48dXAKt62UhBC79/rJz0YROWdpmrN
         tcuw==
X-Gm-Message-State: AOAM533oMcgLslv+moV9gVDWuQsmuSZ/PEe3v14zi//16JB7Ab/5q9VX
        wlYZ4A8d2CdFvGY4iiklPxk=
X-Google-Smtp-Source: ABdhPJzZmnBIgNfB2kgiLaSIcUx4eSFZOxuJqvpBxny5qrEj8rUtQ/GUxtH4/Eghg1vkKcu4qJzOrw==
X-Received: by 2002:a2e:b004:: with SMTP id y4mr886045ljk.273.1589714368947;
        Sun, 17 May 2020 04:19:28 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id f24sm5534246lfk.36.2020.05.17.04.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:19:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] io_uring: add tee(2) support
Date:   Sun, 17 May 2020 14:18:06 +0300
Message-Id: <75938ad218288a56c0a0add9abca02fe097c51ad.1589714180.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714180.git.asml.silence@gmail.com>
References: <cover.1589714180.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_OP_TEE implementing tee(2) support. Almost identical to
splice bits, but without offsets.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 62 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 83b599815cf0..7f25e145a60a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -853,6 +853,11 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
+	[IORING_OP_TEE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2748,7 +2753,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	return ret;
 }
 
-static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int __io_splice_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
 {
 	struct io_splice* sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
@@ -2758,8 +2764,6 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	sp->file_in = NULL;
-	sp->off_in = READ_ONCE(sqe->splice_off_in);
-	sp->off_out = READ_ONCE(sqe->off);
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
 
@@ -2778,6 +2782,46 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_tee_prep(struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe)
+{
+	if (READ_ONCE(sqe->splice_off_in) || READ_ONCE(sqe->off))
+		return -EINVAL;
+	return __io_splice_prep(req, sqe);
+}
+
+static int io_tee(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_splice *sp = &req->splice;
+	struct file *in = sp->file_in;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	long ret = 0;
+
+	if (force_nonblock)
+		return -EAGAIN;
+	if (sp->len)
+		ret = do_tee(in, out, sp->len, flags);
+
+	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_cqring_add_event(req, ret);
+	if (ret != sp->len)
+		req_set_fail_links(req);
+	io_put_req(req);
+	return 0;
+}
+
+static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice* sp = &req->splice;
+
+	sp->off_in = READ_ONCE(sqe->splice_off_in);
+	sp->off_out = READ_ONCE(sqe->off);
+	return __io_splice_prep(req, sqe);
+}
+
 static int io_splice(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_splice *sp = &req->splice;
@@ -5087,6 +5131,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_REMOVE_BUFFERS:
 		ret = io_remove_buffers_prep(req, sqe);
 		break;
+	case IORING_OP_TEE:
+		ret = io_tee_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -5161,6 +5208,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 		putname(req->open.filename);
 		break;
 	case IORING_OP_SPLICE:
+	case IORING_OP_TEE:
 		io_put_file(req, req->splice.file_in,
 			    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
 		break;
@@ -5391,6 +5439,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_remove_buffers(req, force_nonblock);
 		break;
+	case IORING_OP_TEE:
+		if (sqe) {
+			ret = io_tee_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
+		ret = io_tee(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8c5775df08b8..92c22699a5a7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -129,6 +129,7 @@ enum {
 	IORING_OP_SPLICE,
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
+	IORING_OP_TEE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

