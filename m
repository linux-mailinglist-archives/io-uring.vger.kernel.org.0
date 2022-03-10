Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074644D4F0E
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243760AbiCJQYt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiCJQYn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:24:43 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA766192E1F
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:22:15 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e22so7019891ioe.11
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=JL/OWl7Wxq2BpgSGJwBpumBPRc2H7mNaM8Hl2D+xR5c=;
        b=zwejSd+mvhv0JC48OlXPSprhPRpMQUtbG+EUZyv1BX5nXkecGEG23qklvy1LN9w9dy
         vgOu8bNwmx47euGZ8TPZM3QKRI40eseTJ6nwO08X3/c+IQBSWiYYDxDi8cmTpeHZiUr6
         Np1CO0kVscmtlpt+Sf4nf2ctYSoWWuPTM5xM+I7CUp1HNB9y0YfYAo6VQ+GTRX6k1im3
         gBb/D1JjpzSvVKPPZ/1VNLtWR5E8PV9D+YQc0MjMlsiapDJy9mHCXNkPBn+R+SuVui9A
         mQONABhVJdcRdUlLoTl34/FSJCN9qqb8Vb8SY3S12AT/x7GpKs/OzFwmtuRoBqw9zOQe
         PYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=JL/OWl7Wxq2BpgSGJwBpumBPRc2H7mNaM8Hl2D+xR5c=;
        b=i1pmb4/WXbniRU2afDzlkwOqOr+f1N1ApEWAy3X5lN/kHV9XkrkNsRHWvs7fZZ7piZ
         eXaq026sDpyfhvZxWW4Wb/cWdVzL3eSDN3l3NRpZsn2/nNU+ay31CgtJOZm4yXn6IBjo
         e2OLGG1h+i4IBsDus5l3fXtXid6akfF0I7wazB3rA9WpXisfYhr32YkSHnVCcSRWqyWY
         M06kvMZAXrbnUrV4ECiin/n28h8mUpXxrwNjqhJguBRf34sPv3aQ4UdpbM6sJd/m6dKC
         YeFHq1tV4dKKs5dsIUtQ1fF23Q56dN5lxp13X5qXaHxfCVVl212eg4LBNWUPpTuI9ysD
         N8ig==
X-Gm-Message-State: AOAM532xDO14Lgp9rQczA2Z/5ji6soQfHTlR4lEPkpDSyyOtzB+65C6g
        FR/fJfnjyhi8QD0v1VHPI1EhMmiog23QBq/8
X-Google-Smtp-Source: ABdhPJxqcP4wTj9Tpfbhkm75joyTj53CucDMsy3SlC9ux3SC0VHjXDOSIvoUclpF64lb3oKG33PhlA==
X-Received: by 2002:a02:c857:0:b0:317:bee6:48df with SMTP id r23-20020a02c857000000b00317bee648dfmr4436273jao.106.1646929334075;
        Thu, 10 Mar 2022 08:22:14 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d9544000000b00640a6eb6e1esm2892903ios.53.2022.03.10.08.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:22:13 -0800 (PST)
Message-ID: <c0da9b0b-8bab-a33c-7955-027aa4655ff6@kernel.dk>
Date:   Thu, 10 Mar 2022 09:22:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Artyom Pavlov <newpavlov@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: add support for IORING_OP_MSG_RING command
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

sqe->fd must contain the fd of a ring that should receive the CQE.
sqe->off will be propagated to the cqe->user_data on the target ring,
and sqe->len will be propagated to cqe->res. The results CQE will have
IORING_CQE_F_MSG set in its flags, to indicate that this CQE was generated
from a messaging request rather than a SQE issued locally on that ring.
This effectively allows passing a 64-bit and a 32-bit quantify between
the two rings.

This request type has the following request specific error cases:

- -EBADFD. Set if the sqe->fd doesn't point to a file descriptor that is
  of the io_uring type.
- -EOVERFLOW. Set if we were not able to deliver a request to the target
  ring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:
	- Use io_fill_cqe_aux() (Pavel)
	- Pass through length as well rather than hardcode pid (me)

Test case and liburing support has been updated too:

https://git.kernel.dk/cgit/liburing/log/?h=wakeup-ring


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f5e999e569f..36b001365a79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -706,6 +706,12 @@ struct io_hardlink {
 	int				flags;
 };
 
+struct io_msg {
+	struct file			*file;
+	u64 user_data;
+	u32 len;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -871,6 +877,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_msg		msg;
 	};
 
 	u8				opcode;
@@ -1121,6 +1128,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_MSG_RING] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4322,6 +4332,46 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_msg_ring_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->rw_flags || sqe->splice_fd_in || sqe->buf_index ||
+		     sqe->personality))
+		return -EINVAL;
+
+	if (req->file->f_op != &io_uring_fops)
+		return -EBADFD;
+
+	req->msg.user_data = READ_ONCE(sqe->off);
+	req->msg.len = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx;
+	struct io_msg *msg = &req->msg;
+	int ret = -EOVERFLOW;
+	bool filled;
+
+	target_ctx = req->file->private_data;
+
+	spin_lock(&target_ctx->completion_lock);
+	filled = io_fill_cqe_aux(target_ctx, msg->user_data, msg->len,
+					IORING_CQE_F_MSG);
+	io_commit_cqring(target_ctx);
+	spin_unlock(&target_ctx->completion_lock);
+
+	if (filled) {
+		io_cqring_ev_posted(target_ctx);
+		ret = 0;
+	}
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6700,6 +6750,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_MSG_RING:
+		return io_msg_ring_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6983,6 +7035,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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

