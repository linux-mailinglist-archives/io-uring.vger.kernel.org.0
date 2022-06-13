Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625B8549F77
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiFMUhJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiFMUgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 16:36:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3ADB87C
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:49 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s1so8327982wra.9
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNun443gmW7wbVTjed4qejtBRRuNiOc9hkyTDWaolG8=;
        b=c6k3HOxqYDvXPIEmepc8jYSZO9KpITLCeUKWXXUek/2OQgKDcSlgbaSOijaxV7qQVu
         fnxlQja+yBC/tK/7e75Mss25TPM4Vddko6vfInRcVl5NotMeF8oF4yX2Ch4zpLr7TXB/
         1seqqU7r7+idZwMw1c6ToifIBtH/L0+0mm5U1sjPX2CcQTZJCFgyXrhpXbQskUXT+j4s
         hFJl1IrKba3qPDzJ9TNAZmI5Cqk8DhH+q8uVq5VZOCQcKI8DA15R5xtZ4d9UrkhFuL2G
         eIeIKqBW7pEx+vxkT3EAtF7Nh4iWRC6EL5P+90Dap5oWXCQDzmZsfFrbymxYAvz7Ee4x
         ll3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNun443gmW7wbVTjed4qejtBRRuNiOc9hkyTDWaolG8=;
        b=zU28hjMiLRHMmE+1k+lCiacA2rf+pmZIN0ZlXqb1NTWurzvXeiJ4686rTLkdN0D8h5
         8E3GshQH528ZNnb/pSge0EFU33Uyn+IMIMaLXFl3boNxkTrWpuVYm+xNyO/JI+IHQdvN
         Kq0Kue9WNvFGoiwRbjPSqzcIresaDW+MxSXU93O1nRZYxBwrP65AAtyk6r/5Upv7RpQy
         pHmFKSWOmzwaZ33CyuRv2prWm13v4Z8TYZqpZ2dJTN88KoFK4dL7iwk2uTG/khVhiSOz
         z7rMBDE8DJftXeqYYqdKLZM+L1+1I8Bil2yQW4ywBb+kKtDbdiRYJ9LqSI/p8nSJTetj
         hSJQ==
X-Gm-Message-State: AJIora9Cd/BmVeN0nm8PRU4a6EdUkhJN6dbTH418bpnrIASOqi25ZA5L
        0Z1nWK0KDKYfm6UXs4j3ReBeoj8cGwvW8rHL
X-Google-Smtp-Source: AGRyM1t0dkhROGRUA9LqMxjg+Zjxv3Mb384VQ2+G7hntrxIqp6sWpZ9riGwwd1hZcJh0F3GH1HWy5A==
X-Received: by 2002:a05:6000:2c8:b0:218:4982:7f90 with SMTP id o8-20020a05600002c800b0021849827f90mr1322820wry.64.1655148407559;
        Mon, 13 Jun 2022 12:26:47 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:f4c0:c139:b453:c8db])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b0039aef592ca0sm10163198wmg.35.2022.06.13.12.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 12:26:47 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 2/3] io_uring: add support for IORING_OP_MSGSND
Date:   Mon, 13 Jun 2022 20:26:41 +0100
Message-Id: <20220613192642.2040118-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220613192642.2040118-1-usama.arif@bytedance.com>
References: <20220613192642.2040118-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for async msgsnd through io_uring.

The message is stored in msg pointer in io_msgsnd and is saved
in io_setup_async_msgq if we need to punt to async context.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 107 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 108 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aab4182fd89..5949fcadb380 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -81,6 +81,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/xattr.h>
+#include <linux/msg.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -669,6 +670,15 @@ struct io_sr_msg {
 	unsigned int			flags;
 };
 
+struct io_msg_sr {
+	struct file			*file;
+	int				msq_id;
+	struct msgbuf __user		*msg_p;
+	size_t				msg_sz;
+	long				msg_type;
+	int				msg_flags;
+};
+
 struct io_open {
 	struct file			*file;
 	int				dfd;
@@ -803,6 +813,10 @@ struct io_async_msghdr {
 	struct sockaddr_storage		addr;
 };
 
+struct io_async_msg_msg {
+	struct msg_msg			*msg;
+};
+
 struct io_rw_state {
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
@@ -996,6 +1010,7 @@ struct io_kiocb {
 		struct io_socket	sock;
 		struct io_nop		nop;
 		struct io_uring_cmd	uring_cmd;
+		struct io_msg_sr	msg_sr;
 	};
 
 	u8				opcode;
@@ -1199,6 +1214,9 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
+	[IORING_OP_MSGSND] = {
+		.async_size		= sizeof(struct io_async_msg_msg),
+	},
 	[IORING_OP_TIMEOUT] = {
 		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_timeout_data),
@@ -1404,6 +1422,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "SENDMSG";
 	case IORING_OP_RECVMSG:
 		return "RECVMSG";
+	case IORING_OP_MSGSND:
+		return "MSGSND";
 	case IORING_OP_TIMEOUT:
 		return "TIMEOUT";
 	case IORING_OP_TIMEOUT_REMOVE:
@@ -6180,6 +6200,81 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_setup_async_msg_msg(struct io_kiocb *req, struct msg_msg *msg)
+{
+	struct io_async_msg_msg *async_msg_msg = req->async_data;
+
+	if (async_msg_msg)
+		return -EAGAIN;
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+	async_msg_msg = req->async_data;
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	async_msg_msg->msg = msg;
+
+	return -EAGAIN;
+}
+
+static int io_msgsnd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_msg_sr *msg_sr = &req->msg_sr;
+	struct msgbuf __user	*msg_p;
+	long mtype;
+
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
+
+	msg_sr->msq_id = READ_ONCE(sqe->fd);
+	msg_p = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	msg_sr->msg_p = msg_p;
+	if (get_user(mtype, &msg_p->mtype))
+		return -EFAULT;
+	msg_sr->msg_type = mtype;
+	msg_sr->msg_sz = READ_ONCE(sqe->len);
+	msg_sr->msg_flags = READ_ONCE(sqe->msg_flags);
+	if (msg_sr->msg_flags & IPC_NOWAIT)
+		req->flags |= REQ_F_NOWAIT;
+
+	return 0;
+}
+
+static int io_msgsnd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_msg_msg *async_msg_msg;
+	struct io_msg_sr *msg_sr = &req->msg_sr;
+	int ret;
+	int flags;
+	struct msg_msg *msg;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	if (req_has_async_data(req)) {
+		async_msg_msg = req->async_data;
+		msg = async_msg_msg->msg;
+	} else {
+		ret = check_and_load_msgsnd(msg_sr->msq_id, msg_sr->msg_type,
+					    msg_sr->msg_p->mtext,
+					    &msg, msg_sr->msg_sz);
+		if (ret)
+			return ret;
+	}
+
+	if (force_nonblock)
+		flags = msg_sr->msg_flags | IPC_NOWAIT;
+
+	ret = __do_msgsnd(msg_sr->msq_id, msg_sr->msg_type, &msg,
+					msg_sr->msg_sz, flags);
+
+	if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+		return io_setup_async_msg_msg(req, msg);
+
+	if (msg != NULL)
+		free_msg(msg);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_req_complete(req, ret);
+	return ret;
+}
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
@@ -8192,6 +8287,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_socket_prep(req, sqe);
 	case IORING_OP_URING_CMD:
 		return io_uring_cmd_prep(req, sqe);
+	case IORING_OP_MSGSND:
+		return io_msgsnd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -8316,6 +8413,13 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(io->free_iov);
 			break;
 			}
+		case IORING_OP_MSGSND: {
+			struct io_async_msg_msg *io = req->async_data;
+
+			if (io->msg != NULL)
+				free_msg(io->msg);
+			break;
+			}
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
@@ -8529,6 +8633,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_URING_CMD:
 		ret = io_uring_cmd(req, issue_flags);
 		break;
+	case IORING_OP_MSGSND:
+		ret = io_msgsnd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 776e0278f9dd..fa29bd96207d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -190,6 +190,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_MSGSND,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

