Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B1F673DFE
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjASPzB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 10:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjASPzA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 10:55:00 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A861A1BDC
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 07:54:58 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id j1so1158839iob.6
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 07:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXgc01oxsQ0R8HFXWDgCczZPrghy8TxPqRjr7I7e0jw=;
        b=08rxQMMSMWWKuHd2yNY7PtLaBYfKPIAbJJkJBOsfwkV/l8gGTHgI8MpeEHQ1WV+zA6
         wj18+ZVzlcyDRNPkyXE0GTAJ7RPTFqw7FtBpHw+5H/ebSzxwZGLNmXTbyPlR7PzYE6yg
         A3Sp6NTRsy4XceHeV69K7kACrMIv3IPcHNKkgjU1OVX/OsbI13/AaTlhlSenjiH2yCs2
         srBTrtXXl+Nq2bWRTMjMXsgAEAJBpKq+eSM+aQUK8I2YIG+t4UodeFQnneNMjkCAtHtK
         zU6FE5HEFvZEWcrpBgdxgS0j+QZJAs91kBCOUOtQTIy7iR3GPqKDyZwI4s8pvCNR5NGb
         eV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXgc01oxsQ0R8HFXWDgCczZPrghy8TxPqRjr7I7e0jw=;
        b=VAXk9VAPb5bhy7/gJYPeVxbzt6k3gtyF8X4q793iX6hEz6a+WvaGkiWY7bcxzcv0pP
         okXkllDmHFcR5QgirnFuG4W74F0XkArl8YetqKt4FxHsQ50cqD7e/N9/VTmvLTh2jbex
         4kW0UdqkTxTe2VnH7IU9e1nnnePL3Ij/lBEFd6NUlsuKOd65PzmZuUEloK4YK27wgHpj
         ogMuARDEbPlwoGCFEZrMqnfzYubmGaqARWDrWbWMjHg65Vp1p8t5Rmyn3VeF2NSnZD7s
         Gkg7Z84fkuHAx6LBrKYXsxjJgZO0IVMtSOv/X6LbSJp263E9FdwIcIZKaz5UhloE1CfU
         w8dQ==
X-Gm-Message-State: AFqh2krMkirxx95s1XIV92ZSJ6tH8O3kw5kbKZ6aS0UjRyW+fIVKbAyq
        BFD3dhACunGzZgBM190rc28EDsF92g3eXA0J
X-Google-Smtp-Source: AMrXdXvNLsv2DE9YfwLlNRJL4qfK/yEtOIhSYhBfH1MTQ474cCS8j0/AY5GAuTppO4IkoP66m4CcKQ==
X-Received: by 2002:a5d:97c9:0:b0:704:ad00:3844 with SMTP id k9-20020a5d97c9000000b00704ad003844mr1552920ios.1.1674143697787;
        Thu, 19 Jan 2023 07:54:57 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y93-20020a029566000000b003a4894d46e0sm4048770jah.176.2023.01.19.07.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 07:54:57 -0800 (PST)
Message-ID: <6b21328e-d32c-3a54-0578-7a39412d4615@kernel.dk>
Date:   Thu, 19 Jan 2023 08:54:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: WARNING in io_fill_cqe_aux
Content-Language: en-US
To:     Xingyuan Mo <hdthky0@gmail.com>, asml.silence@gmail.com
Cc:     syzkaller@googlegroups.com, io-uring@vger.kernel.org
References: <Y8krlYa52/0YGqkg@ip-172-31-85-199.ec2.internal>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8krlYa52/0YGqkg@ip-172-31-85-199.ec2.internal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/23 4:37?AM, Xingyuan Mo wrote:
> Hello,
> 
> Recently, when using our tool to fuzz kernel, the following bug was
> triggered.
> 
> HEAD commit: 5dc4c995db9e Linux 6.2-rc4
> git tree: mainline
> compiler: gcc (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0
> kernel config: https://drive.google.com/file/d/1anGeZxcTgSKNZX4oywvsSfLqw1tcZSTp/view?usp=share_link
> C reproducer: https://drive.google.com/file/d/1DxYuWGnFSBhqve-jjXloYhwKpyUm8nDt/view?usp=share_link
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
> WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
> Modules linked in:
> CPU: 1 PID: 36200 Comm: syz-executor.0 Not tainted 6.2.0-rc4 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
> RIP: 0010:io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
> RIP: 0010:io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
> Code: fd 48 8d bb a8 00 00 00 be ff ff ff ff e8 dd 1b 02 06 31 ff 89 c5 89 c6 e8 c2 76 7e fd 85 ed 0f 85 44 fa ff ff e8 05 7a 7e fd <0f> 0b e9 38 fa ff ff e8 f9 79 7e fd 31 ff 89 ee e8 a0 76 7e fd 85
> RSP: 0018:ffffc90015747b68 EFLAGS: 00010212
> RAX: 000000000000016e RBX: ffff8881245b6000 RCX: ffffc90013881000
> RDX: 0000000000040000 RSI: ffffffff8401f31b RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881245b6018
> FS:  00007fcf02ab4700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2e024000 CR3: 00000001054e6000 CR4: 0000000000752ee0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __io_post_aux_cqe root/linux-6.2-rc4/io_uring/io_uring.c:880 [inline]
>  io_post_aux_cqe+0x3b/0x90 root/linux-6.2-rc4/io_uring/io_uring.c:890
>  io_msg_ring_data root/linux-6.2-rc4/io_uring/msg_ring.c:74 [inline]
>  io_msg_ring+0x5b9/0xb70 root/linux-6.2-rc4/io_uring/msg_ring.c:227
>  io_issue_sqe+0x6c2/0x1210 root/linux-6.2-rc4/io_uring/io_uring.c:1856
>  io_queue_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2028 [inline]
>  io_submit_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2286 [inline]
>  io_submit_sqes+0x96c/0x1e10 root/linux-6.2-rc4/io_uring/io_uring.c:2397
>  __do_sys_io_uring_enter+0xc20/0x2540 root/linux-6.2-rc4/io_uring/io_uring.c:3345
>  do_syscall_x64 root/linux-6.2-rc4/arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 root/linux-6.2-rc4/arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fcf01c8f6cd
> Code: c3 e8 17 32 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcf02ab3bf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007fcf01dbbf80 RCX: 00007fcf01c8f6cd
> RDX: 0000000000000000 RSI: 0000000000007b84 RDI: 0000000000000004
> RBP: 00007fcf01cfcb05 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcf01edfb2f R14: 00007fcf01edfcd0 R15: 00007fcf02ab3d80
>  </TASK>

I think this should fix it. Pavel?

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 2d3cd945a531..c98e9c74054b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -25,6 +25,28 @@ struct io_msg {
 	u32 flags;
 };
 
+static void io_double_unlock_ctx(struct io_ring_ctx *octx)
+{
+	mutex_unlock(&octx->uring_lock);
+}
+
+static int io_double_lock_ctx(struct io_ring_ctx *octx,
+			      unsigned int issue_flags)
+{
+	/*
+	 * To ensure proper ordering between the two ctxs, we can only
+	 * attempt a trylock on the target. If that fails and we already have
+	 * the source ctx lock, punt to io-wq.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		if (!mutex_trylock(&octx->uring_lock))
+			return -EAGAIN;
+		return 0;
+	}
+	mutex_lock(&octx->uring_lock);
+	return 0;
+}
+
 void io_msg_ring_cleanup(struct io_kiocb *req)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -43,20 +65,25 @@ static void io_msg_tw_complete(struct callback_head *head)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	int ret = 0;
 
-	if (current->flags & PF_EXITING)
+	if (current->flags & PF_EXITING) {
 		ret = -EOWNERDEAD;
-	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
-		ret = -EOVERFLOW;
+	} else {
+		mutex_lock(&target_ctx->uring_lock);
+		if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+			ret = -EOVERFLOW;
+		mutex_unlock(&target_ctx->uring_lock);
+	}
 
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_queue_tw_complete(req, ret);
 }
 
-static int io_msg_ring_data(struct io_kiocb *req)
+static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	int ret;
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
@@ -71,33 +98,14 @@ static int io_msg_ring_data(struct io_kiocb *req)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
-		return 0;
-
-	return -EOVERFLOW;
-}
-
-static void io_double_unlock_ctx(struct io_ring_ctx *octx,
-				 unsigned int issue_flags)
-{
-	mutex_unlock(&octx->uring_lock);
-}
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
 
-static int io_double_lock_ctx(struct io_ring_ctx *octx,
-			      unsigned int issue_flags)
-{
-	/*
-	 * To ensure proper ordering between the two ctxs, we can only
-	 * attempt a trylock on the target. If that fails and we already have
-	 * the source ctx lock, punt to io-wq.
-	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		if (!mutex_trylock(&octx->uring_lock))
-			return -EAGAIN;
-		return 0;
-	}
-	mutex_lock(&octx->uring_lock);
-	return 0;
+	ret = -EOVERFLOW;
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+		ret = 0;
+	io_double_unlock_ctx(target_ctx);
+	return ret;
 }
 
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
@@ -148,7 +156,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(target_ctx, issue_flags);
+	io_double_unlock_ctx(target_ctx);
 	return ret;
 }
 
@@ -224,7 +232,7 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 
 	switch (msg->cmd) {
 	case IORING_MSG_DATA:
-		ret = io_msg_ring_data(req);
+		ret = io_msg_ring_data(req, issue_flags);
 		break;
 	case IORING_MSG_SEND_FD:
 		ret = io_msg_send_fd(req, issue_flags);

-- 
Jens Axboe

