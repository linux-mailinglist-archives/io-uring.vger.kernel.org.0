Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37ED241BCE
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgHKNxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 09:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbgHKNw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 09:52:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6405CC061788
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 06:52:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r4so6854436pls.2
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hBzW2ieVn9S8WRpjKKZgk2Q3k8ADXArcvCAn26f+FAQ=;
        b=orVavcgkq+oqS6qEImOMZ7TduLcai2+huD3HOzc8GZ81U9cIjaQ3KO3g8aRDLC5qhm
         tBkfM656WfiKaIUq7+ys9Tb3NWPAseTKmhaVbeuD2Qse6kHpyMmmzW4QyfQkZDQnMztJ
         TwJrhe5Nm814ITfkYa1qv8vLqdavM8GecCVkKJPgolAmQPdogKIacoekFViV0SxRm2Fr
         5FJhC2BRs0m09S+5VGzFyFMZJc0VT/idJguqhrnc+TUbXLzHOGAiCIeQlAzclGvpsFlI
         EYlb7tdV0SvpeGIdNQjFpafNS6HvZuC5vDCYvrX0izWvA8d7Kk2ZIX84hyRMqvpuKqli
         EbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBzW2ieVn9S8WRpjKKZgk2Q3k8ADXArcvCAn26f+FAQ=;
        b=Ks4UXfBC13Fa+93hJok7pXOzMhmoQh4VWyotAvF8I1Eg+QD0h4jE+m5g0OEvnmQFob
         TqlePXuQNOZLzOievWbBQthNR2a1A1TunUoxmNNOF6SM1WjNp7f9wKQkEvHEGsZ5wIOf
         WZohEEuIpw9DgPXp6451dKFiSjc0K4TSJHOQQeEohWKwG9iNYcSCg3Bd67BXhSNEZLxG
         G52njd9yPmaTTvxCDOp1vH4lRBBKJao6g73wJ/6RwB/nkZTGzDON2uW2D5zWgp/1/0VE
         rfNwgseq8BYnO84ooErfBfXFYI1zgSrmv4sb9EmcZEz+FsAFmW4i8TajtQhDEXAvqVUw
         XITw==
X-Gm-Message-State: AOAM531oA2EG746qCiNt/SyNbEQxGMluDor1kxG8TUDJhIu199UJgv0K
        H6U4w0V+wAJVbmT6ETZLYD0mjA==
X-Google-Smtp-Source: ABdhPJx12PhBcxf+TNd8YFsjKf2yGKjJp+AULNeiYiPgLCw5lrr7juZl0TULuUBcIPn0OeevPFd6kg==
X-Received: by 2002:a17:90b:164a:: with SMTP id il10mr1284815pjb.2.1597153978420;
        Tue, 11 Aug 2020 06:52:58 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id in12sm2924184pjb.29.2020.08.11.06.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 06:52:57 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_async_task_func
To:     syzbot <syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000002753ac05ac9471f4@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4acc639d-ec4a-e630-3a0b-33c4f675b41d@kernel.dk>
Date:   Tue, 11 Aug 2020 07:52:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000002753ac05ac9471f4@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/20 12:47 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    fc80c51f Merge tag 'kbuild-v5.9' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17601ab2900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d48472fcc2f68903
> dashboard link: https://syzkaller.appspot.com/bug?extid=9b260fc33297966f5a8e
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174272b2900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com

I think the below should fix it, for this use case and potentially others.
If the ring is closed and the task_work bound req is holding the last
reference, we need to hold a ctx reference around it.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5488698189da..cc4bb16ff570 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1821,8 +1821,10 @@ static void __io_req_task_submit(struct io_kiocb *req)
 static void io_req_task_submit(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	__io_req_task_submit(req);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
@@ -1830,6 +1832,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	int ret;
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
@@ -2318,6 +2321,8 @@ static void io_rw_resubmit(struct callback_head *cb)
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	}
+
+	percpu_ref_put(&ctx->refs);
 }
 #endif
 
@@ -2330,6 +2335,8 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 		return false;
 
 	init_task_work(&req->task_work, io_rw_resubmit);
+	percpu_ref_get(&req->ctx->refs);
+
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (!ret)
 		return true;
@@ -3033,6 +3040,8 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	list_del_init(&wait->entry);
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
+
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req, &req->task_work);
@@ -4565,6 +4574,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4652,11 +4663,13 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
 	if (nxt)
 		__io_req_task_submit(nxt);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4752,6 +4765,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 

-- 
Jens Axboe

