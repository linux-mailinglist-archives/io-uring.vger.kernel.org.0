Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C142FD119
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 14:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbhATNE5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 08:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389887AbhATMj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 07:39:57 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21A4C0613D6
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 04:39:16 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l12so17730334wry.2
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 04:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UWfxsm42WqIJXb9VaTVUyLpKMIcCLFJrrP/q9MwfN7w=;
        b=IF7LHdcKskkkxZ+Xxz1wKwW7eWs6xl6/tx8Ar39ALooVqg38lzMteKomZn0mhcL8ID
         zOLDb5LabWtiGfbsvnqsHWIE1osYx1/+2KAat09iKGFteqF9NdjqNusDsvvomJEq3TRE
         HdpCg9IqAvBP0V/UQegebSU8ve7rdOCs/QI2tK/4dp/ql7Z2hR5Q/qDl0BcUZUEhRUok
         /t1rQxSOpCQlHOL/qBwJkpQMIprwAtn/YaFUWX7/7N3MmlmHJURTjOBddpoDyHnueTPX
         4TziG/qUzwNVo6D5ClA8/ihtY8PDOJjBlevSBXRvcmOoEcvuOaJaZEff2tGTDToF/AYV
         BK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UWfxsm42WqIJXb9VaTVUyLpKMIcCLFJrrP/q9MwfN7w=;
        b=GLbt3fV2S/AsCdsnOHNDeO6MTvRyu2lRR/ZzGSuuhd0l8DwSvy0xpzkzMUzq7pp3jG
         rjg5uMKHwdhLdWagY7PYUA3cU7m+0Ux+spSINyOUlaQiOhxu/ElaWptUyIJInChDRtj6
         Lov3ZR3F4Vz6WxuIe7e2bKZzio/IbNDnjaZixSrRN9v3nbqAw+1dsA2IovDNZw+dG98H
         622ZwvDHpVWEqKIRDxwdfmHOex3oOMyS3WuYYllK7McHKCi1qnQbzmuXFIAnqo+Zr4ox
         +movBu0/wew4R8POd25eLed2MeLGtahatSR3nz4n+vPyHbwEf1VDGuLYVLWclUT06dXv
         5QmA==
X-Gm-Message-State: AOAM530Nt630h8uNIc778iQyTzwDkHXrXQxPaZv/KYy5jxZ+FZvpVo3g
        zrii02AU9wJAZ7doGyeVz5Shtf8B7cv4yg==
X-Google-Smtp-Source: ABdhPJwPh2ppKjP4UuHp97RMS153sq8Feh//PxZ06aU9foPkWCV2GRTjEUXzZyf8NS1yCPBhA1RKkw==
X-Received: by 2002:a5d:43d2:: with SMTP id v18mr9216066wrr.326.1611146354521;
        Wed, 20 Jan 2021 04:39:14 -0800 (PST)
Received: from [192.168.8.137] ([148.252.129.228])
        by smtp.gmail.com with ESMTPSA id 17sm3390589wmk.48.2021.01.20.04.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 04:39:13 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: leave clean req to be done in flush overflow
Message-ID: <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
Date:   Wed, 20 Jan 2021 12:35:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/01/2021 08:11, Joseph Qi wrote:
> Abaci reported the following BUG:
> 
> [   27.629441] BUG: sleeping function called from invalid context at fs/file.c:402
> [   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1012, name: io_wqe_worker-0
> [   27.633220] 1 lock held by io_wqe_worker-0/1012:
> [   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock){....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
> [   27.636487] irq event stamp: 66658
> [   27.637302] hardirqs last  enabled at (66657): [<ffffffff8144ba02>] kmem_cache_free+0x1f2/0x3b0
> [   27.639211] hardirqs last disabled at (66658): [<ffffffff82003a77>] _raw_spin_lock_irqsave+0x17/0x50
> [   27.641196] softirqs last  enabled at (64686): [<ffffffff824003c5>] __do_softirq+0x3c5/0x5aa
> [   27.643062] softirqs last disabled at (64681): [<ffffffff8220108f>] asm_call_irq_on_stack+0xf/0x20
> [   27.645029] CPU: 1 PID: 1012 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc4+ #68
> [   27.646651] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> [   27.649249] Call Trace:
> [   27.649874]  dump_stack+0xac/0xe3
> [   27.650666]  ___might_sleep+0x284/0x2c0
> [   27.651566]  put_files_struct+0xb8/0x120
> [   27.652481]  __io_clean_op+0x10c/0x2a0
> [   27.653362]  __io_cqring_fill_event+0x2c1/0x350
> [   27.654399]  __io_req_complete.part.102+0x41/0x70
> [   27.655464]  io_openat2+0x151/0x300
> [   27.656297]  io_issue_sqe+0x6c/0x14e0
> [   27.657170]  ? lock_acquire+0x31a/0x440
> [   27.658068]  ? io_worker_handle_work+0x24e/0x8a0
> [   27.659119]  ? find_held_lock+0x28/0xb0
> [   27.660026]  ? io_wq_submit_work+0x7f/0x240
> [   27.660991]  io_wq_submit_work+0x7f/0x240
> [   27.661915]  ? trace_hardirqs_on+0x46/0x110
> [   27.662890]  io_worker_handle_work+0x501/0x8a0
> [   27.663917]  ? io_wqe_worker+0x135/0x520
> [   27.664836]  io_wqe_worker+0x158/0x520
> [   27.665719]  ? __kthread_parkme+0x96/0xc0
> [   27.666663]  ? io_worker_handle_work+0x8a0/0x8a0
> [   27.667726]  kthread+0x134/0x180
> [   27.668506]  ? kthread_create_worker_on_cpu+0x90/0x90
> [   27.669641]  ret_from_fork+0x1f/0x30
> 
> It blames we call cond_resched() with completion_lock when clean
> request. In fact we will do it during flush overflow and it seems we
> have no reason to do it before. So just remove io_clean_op() in
> __io_cqring_fill_event() to fix this BUG.

Nope, it would be broken. You may override, e.g. iov pointer
that is dynamically allocated, and the function makes sure all
those are deleted and freed. Most probably there will be problems
on flush side as well.

Looks like the problem is that we do spin_lock_irqsave() in
__io_req_complete() and then just spin_lock() for put_files_struct().
Jens, is it a real problem?

At least for 5.12 there is a cleanup as below, moving drop_files()
into io_req_clean_work/io_free_req(), which is out of locks. Depends
on that don't-cancel-by-files patch, but I guess can be for 5.11


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4f702d03d375..3d3087851fed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -614,7 +614,6 @@ enum {
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	REQ_F_FAIL_LINK_BIT,
-	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
@@ -647,8 +646,6 @@ enum {
 
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
-	/* on inflight list */
-	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
@@ -1057,8 +1054,7 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static inline void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
-			  REQ_F_INFLIGHT))
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
 		__io_clean_op(req);
 }
 
@@ -1375,6 +1371,11 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
+	if (req->work.flags & IO_WQ_WORK_FILES) {
+		put_files_struct(req->work.identity->files);
+		put_nsproxy(req->work.identity->nsproxy);
+		req->work.flags &= ~IO_WQ_WORK_FILES;
+	}
 
 	io_put_identity(req->task->io_uring, req);
 }
@@ -1483,7 +1484,6 @@ static bool io_grab_identity(struct io_kiocb *req)
 			return false;
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
-		req->flags |= REQ_F_INFLIGHT;
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
@@ -6128,18 +6128,6 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
-static void io_req_drop_files(struct io_kiocb *req)
-{
-	struct io_uring_task *tctx = req->task->io_uring;
-
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
-	req->flags &= ~REQ_F_INFLIGHT;
-	req->work.flags &= ~IO_WQ_WORK_FILES;
-	if (atomic_read(&tctx->in_idle))
-		wake_up(&tctx->wait);
-}
-
 static void __io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
@@ -6197,9 +6185,6 @@ static void __io_clean_op(struct io_kiocb *req)
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
-
-	if (req->flags & REQ_F_INFLIGHT)
-		io_req_drop_files(req);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,


-- 
Pavel Begunkov
