Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0234D549F79
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbiFMUhJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 16:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiFMUgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 16:36:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2E911149
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x17so8348272wrg.6
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wE12O0cTdrBz8taoM7ZHhVhAlWqDyXCCGx9RSHXJV/U=;
        b=fm0EXuIkyC6jEOOKkhCr00DT/XT9kUXA0joJjnwSmUUY2uel8xCPq7a5Ao2tnCKauP
         NHxbbFi6Ddj23GvHNC5KztSeqTeym6WIDNzXWCGA58GRv0h0iRVOJfN5ILlBEOdiRDFD
         SprBm0fYVtUc0+M7shlCJIoyJR5g4B66RzAh5WsL6p02jd4DPoqJolAzlKFaHi/OhxJR
         gx2Dg5epq+7uR/094qRwJpaB5OJr7JnbKil9TI8eGwt7sHWQq/KeRPvDsT/whGem74JP
         YKSVc3yGJ529YAZUIuOnp/8uKNhZy4o91MfwYMu2RcdtRiiMEkpiNuZE9Ts9jQeWwoEi
         axOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wE12O0cTdrBz8taoM7ZHhVhAlWqDyXCCGx9RSHXJV/U=;
        b=XcAME2tvu0P5kdWqgnuuflC+AZVhkj9LNQfq20m1itfgNqvMvYNXH2ik2ZgUAWNcFD
         J4fIwryaiDPdCh1FFb9BFE4+PHR1sx/l4oPKcahMKpjMUgGBXR0shwGDR6FmZKqa2sEQ
         xnpLUaFtJNveH2v+vKKipyh1ODsNYtYs2Cb9+siPQjh7O1WmSla0ZnVeb8uNMl5DgEw7
         aREbfKukBXCufmMXzeUU3JWnZ9XlV+LKnVsGXOQNWApGZWfUCZN2ooOiR26gso0tB615
         dI6r+6HpHI4HY21XiuFW9nOzNomvOplNfmrcQGqhy9YySOCLxIOLGyHS02A4v8lv5Bag
         AW8g==
X-Gm-Message-State: AJIora97L2ZucrZ4zy2I6u53WO8ldrfA+xHDX6JMa2fy131JoTMFSuBr
        jZJlTRqH0aJy3uYKUQFOkKNr/ND4C0uxAnPo
X-Google-Smtp-Source: AGRyM1vwmjzMggp49katFQIbDtG9bKpl78HSGM46yYcGA9oWjDGG9jPjHzxucrp4vpDrDKQnycqi3g==
X-Received: by 2002:adf:e3c3:0:b0:219:e5a8:c112 with SMTP id k3-20020adfe3c3000000b00219e5a8c112mr1266501wrm.397.1655148408400;
        Mon, 13 Jun 2022 12:26:48 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b497:0:f4c0:c139:b453:c8db])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b0039aef592ca0sm10163198wmg.35.2022.06.13.12.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 12:26:48 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [RFC 3/3] io_uring: add support for IORING_OP_MSGRCV
Date:   Mon, 13 Jun 2022 20:26:42 +0100
Message-Id: <20220613192642.2040118-4-usama.arif@bytedance.com>
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

This adds support for async msgrcv through io_uring.

All the information needed after punt to async context
is already stored in the io_msgrcv_prep call.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c                 | 45 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 46 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5949fcadb380..124914d8ee50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1217,6 +1217,8 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MSGSND] = {
 		.async_size		= sizeof(struct io_async_msg_msg),
 	},
+	[IORING_OP_MSGRCV] = {
+	},
 	[IORING_OP_TIMEOUT] = {
 		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_timeout_data),
@@ -1424,6 +1426,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "RECVMSG";
 	case IORING_OP_MSGSND:
 		return "MSGSND";
+	case IORING_OP_MSGRCV:
+		return "MSGRCV";
 	case IORING_OP_TIMEOUT:
 		return "TIMEOUT";
 	case IORING_OP_TIMEOUT_REMOVE:
@@ -6275,6 +6279,42 @@ static int io_msgsnd(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_complete(req, ret);
 	return ret;
 }
+
+static int io_msgrcv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_msg_sr *msg_sr = &req->msg_sr;
+
+	if (unlikely(sqe->file_index))
+		return -EINVAL;
+
+	msg_sr->msq_id = READ_ONCE(sqe->fd);
+	msg_sr->msg_p = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	msg_sr->msg_type = READ_ONCE(sqe->off);
+	msg_sr->msg_sz = READ_ONCE(sqe->len);
+	msg_sr->msg_flags = READ_ONCE(sqe->msg_flags);
+	return 0;
+}
+
+static int io_msgrcv(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_msg_sr *msg_sr = &req->msg_sr;
+	int ret;
+	int flags;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	if (force_nonblock)
+		flags = msg_sr->msg_flags | IPC_NOWAIT;
+
+	ret = ksys_msgrcv(msg_sr->msq_id, msg_sr->msg_p, msg_sr->msg_sz,
+			  msg_sr->msg_type, flags);
+
+	if (ret == -ENOMSG)
+		return -EAGAIN;
+
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
@@ -8289,6 +8329,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_uring_cmd_prep(req, sqe);
 	case IORING_OP_MSGSND:
 		return io_msgsnd_prep(req, sqe);
+	case IORING_OP_MSGRCV:
+		return io_msgrcv_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -8636,6 +8678,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_MSGSND:
 		ret = io_msgsnd(req, issue_flags);
 		break;
+	case IORING_OP_MSGRCV:
+		ret = io_msgrcv(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fa29bd96207d..b5dcaac30d9d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -191,6 +191,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_MSGSND,
+	IORING_OP_MSGRCV,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

