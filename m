Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1C4D4800
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 14:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiCJNZf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 08:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbiCJNZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 08:25:34 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0227BCEA24
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:24:31 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p8so5089986pfh.8
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 05:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=o5IvQV1WjWmJf/aHwQ2SxU3sB0EykZpyrdLtO0AUHEg=;
        b=DiTmKFGakOyxauqUwKRqzI4s+wuvOr9jjZ7DJJqPc6iJzhEEP4eSHrCIkqiU6hAmH6
         +qJ3Snu/OICLxm+c9JrivHQc3H+qet8iFlaCdaaMbyPzjKMelmuNByTXfJGpOqxir/ao
         ZHdJxw96z0pyF4bGHqJQJpM8Opz9g5ELyS36HzkYL0mISn+2DPZhrDirv4rk43yPCZv4
         afMVEg/azUr3XgFVF/ltJLHBwbMe6ATL+W8hqNCd8WrRxVjPgYAloWPq38s3UIr9QqoY
         TZWDFY6+hm4z3akOr3JMeM4piJIBcEj+EP1sdbVmHKHKpzWsEYQEUAQb2siON0bdawto
         kChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=o5IvQV1WjWmJf/aHwQ2SxU3sB0EykZpyrdLtO0AUHEg=;
        b=4aBjyzG6Aa358sc9yf/Av/pRsWtZTpeeeEM2vsytiJus4zqhQdWU6UpNk+D94diK5N
         Vf9M9POnOdYDFEYMk9h/DxEfELBERzcvD3jmXk6S32fPJkOhNHCvrc4u15FeYfojUxEQ
         nvrItQjlim6PlwfipP1iHyMKtSKCBhFCj0edpAgje0EWogMpVKqhIUgQdhrpr4dEg4/c
         YT0OBRgSbQBmtEnlVqSTUaS/NF0oTzpkLcV98cAWk0wSCtV01qZaG32rQASdY6i8A3EZ
         OzE2jbbxUHiIFaiU/lREsyu1mprcW1ql5Kps7/JL7oplY3zu5fSDZRNwoLOd71qXNbjA
         l6qw==
X-Gm-Message-State: AOAM531uHkN+eLjWniNeO/PvrxZFYtBrQNgpi1s8q+yum0BmQdC0zuMc
        tZlEyxumml8d3Iq2UeFHE9aFkdt3+T/9kOwY
X-Google-Smtp-Source: ABdhPJzWZpc1x4dcR8WZSqEWoVRt6yIUVjxE95KFEGaNt/awn9VltbhlFwKTCdPqR4dfIa0aYijCRA==
X-Received: by 2002:a65:6942:0:b0:378:9365:5963 with SMTP id w2-20020a656942000000b0037893655963mr4056263pgq.142.1646918670024;
        Thu, 10 Mar 2022 05:24:30 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a633c0d000000b0037ffd2e6a4asm5899500pga.86.2022.03.10.05.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 05:24:29 -0800 (PST)
Message-ID: <35b8fdf8-25c0-0aae-417c-c9f808a27643@kernel.dk>
Date:   Thu, 10 Mar 2022 06:24:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add support for IORING_OP_MSG_RING command
Cc:     Artyom Pavlov <newpavlov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for IORING_OP_MSG_RING, which allows an SQE to signal
another ring. That allows either waking up someone waiting on the ring,
or even passing a 64-bit value via the user_data field in the CQE.

sqe->fd must point to the fd of a ring that should receive the CQE.
sqe->off will be propagated to the cqe->user_data on the target ring,
and the CQE will have IORING_CQE_F_MSG set in its flags to indicate that
this CQE was generated from a messaging request rather than a SQE issued
locally on that ring. cqe->res will contain the pid/tid of the
application that sent the request.

This request type has the following request specific error cases:

- -EBADFD. Set if the sqe->fd doesn't point to a file descriptor that is
  of the io_uring type.
- -EOVERFLOW. Set if the target rings CQ ring was in an overflow state
  and we could not post the msssage.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

There's a test case in the liburing wakeup-ring branch:

https://git.kernel.dk/cgit/liburing/log/?h=wakeup-ring

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ea5356599cb..941d513f50cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -707,6 +707,11 @@ struct io_hardlink {
 	int				flags;
 };
 
+struct io_msg {
+	struct file			*file;
+	u64 user_data;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -872,6 +877,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_msg		msg;
 	};
 
 	u8				opcode;
@@ -1122,6 +1128,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_MSG_RING] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4356,6 +4365,46 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_msg_ring_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index || sqe->len ||
+		     sqe->rw_flags || sqe->splice_fd_in || sqe->buf_index ||
+		     sqe->personality))
+		return -EINVAL;
+
+	if (req->file->f_op != &io_uring_fops)
+		return -EBADFD;
+
+	req->msg.user_data = READ_ONCE(sqe->off);
+	return 0;
+}
+
+static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx;
+	struct io_uring_cqe *cqe;
+	int ret = -EOVERFLOW;
+
+	target_ctx = req->file->private_data;
+	spin_lock(&target_ctx->completion_lock);
+	cqe = io_get_cqe(target_ctx);
+	if (cqe) {
+		ret = 0;
+		WRITE_ONCE(cqe->user_data, req->msg.user_data);
+		WRITE_ONCE(cqe->res, current->pid);
+		WRITE_ONCE(cqe->flags, IORING_CQE_F_MSG);
+		trace_io_uring_complete(target_ctx, NULL, cqe->user_data,
+					cqe->res, cqe->flags);
+	}
+	io_commit_cqring(target_ctx);
+	spin_unlock(&target_ctx->completion_lock);
+	io_cqring_ev_posted(target_ctx);
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6734,6 +6783,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_MSG_RING:
+		return io_msg_ring_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7017,6 +7068,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_MSG_RING:
+		ret = io_msg_ring(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 42b2fe84dbcd..8bd4bfdd9a89 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_MSG_RING,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -199,9 +200,11 @@ struct io_uring_cqe {
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
+ * IORING_CQE_F_MSG	If set, CQE was generated with IORING_OP_MSG_RING
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
+#define IORING_CQE_F_MSG		(1U << 2)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,

-- 
Jens Axboe

