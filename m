Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C9240ADA
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgHJPzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgHJPzU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:55:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52826C061787
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:55:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id z20so5130256plo.6
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zhOM5a+db+03fu+9y+KxnwpweHHDcuys502DsmoxXhA=;
        b=RvBExdkmAnkEgOU6Nk2vKZAwFQtYELi1S05QGaY2btfkBADpiYjpkJ7NP5nf0OsOa4
         UQM/FJqfeF+8Wa8px8VUNM1HFR1xfquXIGgc1HGYIeCGWPzy35fia4JArsDV98K8vu7D
         LvpzHFUSJ3Cr3ZdwkymRADgiY2ZI2BLDxjcMsR9UJ+Up6xwwNzh+c1qUWauE/l9KM6u6
         LYAS2XW1wns6e7aSBI4M5yjsgixUuRivdxtxmhuxm6MqnbTcc5m0Mzm1a5QbabZgBcdV
         vm5N9gAjWyyepf7xoba8s/OH/wop7ELxgVk/cVuJOgVVHkP7qbu0XeOPDd+pLnmo42xP
         udRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhOM5a+db+03fu+9y+KxnwpweHHDcuys502DsmoxXhA=;
        b=EaWVmtyZrVxG0FHV8WyZFaWXeMCObf7EeCF3BBjPtamjau8ZvBcD0bASxc4/V15SLJ
         CXEdGYnOuh1NS477YO2WXEswSA8eO74DdWwDSIth0o2ZbkiHc1PdqmozGSsyKZ0frxfZ
         d9vMSg1jorNpgLK8q5VMk+ua1NH+Z2McmUCOZy6npeP/SzQ1O2W/3nhQ+y+1bPCZ6ZYa
         nSKGCX3FsLN6em+KMus2wp2jJxF7kzBPmzB55qmo1jQrczQ+L6jci2EU3cH/uvjSW8nx
         lg1Hg5ayAaRi+qyUwDdirx/kJBa5/9NqQ/ad5m/UrLKkABRe/tbdsHuF9PmCWf1fQbgs
         8atA==
X-Gm-Message-State: AOAM532sGeWLJ92p8HRU6sZCHsvsTkwGpUpHUtro5JQaha2VeMth1i/B
        7UfgYxAoei5dDhpL5FKKoSde/VQVljk=
X-Google-Smtp-Source: ABdhPJzS8pMd0LP91YQq4K7gL3JBidwfv5SgjeMK+Al5ZyYEWz94BQMEK2mULY/PgMZVaibUFKaGZQ==
X-Received: by 2002:a17:90a:4e42:: with SMTP id t2mr8373707pjl.121.1597074919593;
        Mon, 10 Aug 2020 08:55:19 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x22sm22145374pfn.41.2020.08.10.08.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 08:55:19 -0700 (PDT)
Subject: Re: possible deadlock in __io_queue_deferred
To:     syzbot <syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000035fdf505ac87b7f9@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <76cc7c43-2ebb-180d-c2c8-912972a3f258@kernel.dk>
Date:   Mon, 10 Aug 2020 09:55:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000035fdf505ac87b7f9@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 9:36 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d41e02900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
> dashboard link: https://syzkaller.appspot.com/bug?extid=996f91b6ec3812c48042
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133c9006900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1191cb1a900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com

Thanks, the below should fix this one.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 443eecdfeda9..f9be665d1c5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -898,6 +898,7 @@ static void io_put_req(struct io_kiocb *req);
 static void io_double_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
+static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
@@ -1179,7 +1180,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 			io_prep_async_work(cur);
 }
 
-static void __io_queue_async_work(struct io_kiocb *req)
+static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
@@ -1187,16 +1188,19 @@ static void __io_queue_async_work(struct io_kiocb *req)
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
 	io_wq_enqueue(ctx->io_wq, &req->work);
-
-	if (link)
-		io_queue_linked_timeout(link);
+	return link;
 }
 
 static void io_queue_async_work(struct io_kiocb *req)
 {
+	struct io_kiocb *link;
+
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
-	__io_queue_async_work(req);
+	link = __io_queue_async_work(req);
+
+	if (link)
+		io_queue_linked_timeout(link);
 }
 
 static void io_kill_timeout(struct io_kiocb *req)
@@ -1229,12 +1233,19 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 	do {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
+		struct io_kiocb *link;
 
 		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
 		/* punt-init is done before queueing for defer */
-		__io_queue_async_work(de->req);
+		link = __io_queue_async_work(de->req);
+		if (link) {
+			__io_queue_linked_timeout(link);
+			/* drop submission reference */
+			link->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(link);
+		}
 		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
 }
@@ -5945,15 +5956,12 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void io_queue_linked_timeout(struct io_kiocb *req)
+static void __io_queue_linked_timeout(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	/*
 	 * If the list is now empty, then our linked request finished before
 	 * we got a chance to setup the timer
 	 */
-	spin_lock_irq(&ctx->completion_lock);
 	if (!list_empty(&req->link_list)) {
 		struct io_timeout_data *data = &req->io->timeout;
 
@@ -5961,6 +5969,14 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
 				data->mode);
 	}
+}
+
+static void io_queue_linked_timeout(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	__io_queue_linked_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* drop submission reference */

-- 
Jens Axboe

