Return-Path: <io-uring+bounces-93-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D577EC414
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 14:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDAFDB20A86
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 13:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4DF1A703;
	Wed, 15 Nov 2023 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fP18WPoR"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF7F1EB42
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 13:49:34 +0000 (UTC)
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943E9181
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:49:29 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-6708d2df1a3so9975676d6.1
        for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 05:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700056168; x=1700660968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=erEY7eGwbIJ0By9wrnzsR+zSyGR5ZzvjSybj8CiAMI4=;
        b=fP18WPoRucz3NMD/9BAOVbleaZ5aygduqdOI1ww2Kxc0Ye4RmJCngMZDjFS/+HYCdI
         1c59fjzVOgVo1hjShLhXgKyfGzY7j0/B7XWSHseU2TgjzFl8ggKIlLZ2kmyRo44WMvuh
         nIgjD45WPS4BMn+UbbgHdnYoN4NvyeKGSfqPi6PO6gs0B4ncVvyUIiTOIH3g4M2zwrI7
         jcJolTvfxhsIO5fce8JY1OluY/6kAF1xR50sHToTVAg6bu0UpK08eJ3o0bN2xPS/inhx
         WH/zUJz5f2NLih0Z6gx3iE66xKp4dIjX8dG3HsShIfv5v2VJeSpK5vRP4l1erGAEIWEO
         pHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700056168; x=1700660968;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=erEY7eGwbIJ0By9wrnzsR+zSyGR5ZzvjSybj8CiAMI4=;
        b=jyZOj8RIlgAcwtx1teQeyi+L+rH6U3ohRCU4Iqzyez1I6TnIRCFIIGp5u9hpMiRiqf
         0V0jgLt+uBFgVnxLOv33YfGVdVKBvKYyPOtUQ+DLlIhuSFQxeb4wlhGJ9gFK5xCYnNo3
         IcoYsU4vGJDEyMWQz2YbvfdYYrCxPbvkRiedBvkexSkzphcidNBlk4Ya04f6xQ4nUjDM
         AuulBQs3wIrcGhFkiddwAoMhHzXAim32uR9qSJ0SbohZAk0+4Hsly14Cu84lIxfcIdlq
         vndDtlpAE/XXvuLU6k72nOA3cFZ+qg4nSnqhJkuqjtSWdYHLIcuKiYiyvN/GwWIBWtEC
         qhKw==
X-Gm-Message-State: AOJu0Yy3udKcPBdxh1taW38xTPQIEIyyPwVecxQMlwNEe89Dm3/v/bJ6
	1lnVQ20DA64/7yEpDJbPrimhleVfswrR72qbQVu6nA==
X-Google-Smtp-Source: AGHT+IGfke/reW3hGuUYLNKjYKfHwjYTE4H2FusWIlKJ2RXmtb7rNQVGy2186Xc4RhAKbNJzgimpLg==
X-Received: by 2002:a05:620a:bc1:b0:76c:ed4e:ac10 with SMTP id s1-20020a05620a0bc100b0076ced4eac10mr5606104qki.6.1700056168693;
        Wed, 15 Nov 2023 05:49:28 -0800 (PST)
Received: from ?IPV6:2600:380:9175:75f:e6af:c913:71c3:9f81? ([2600:380:9175:75f:e6af:c913:71c3:9f81])
        by smtp.gmail.com with ESMTPSA id sn7-20020a05620a948700b0076f058f5834sm3456647qkn.61.2023.11.15.05.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 05:49:28 -0800 (PST)
Message-ID: <605eac76-ec47-436b-872a-f6e8b4094293@kernel.dk>
Date: Wed, 15 Nov 2023 06:49:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Xiaobing Li <xiaobing.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, kun.dou@samsung.com,
 peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
 wenwen.chen@samsung.com, ruyi.zhang@samsung.com
References: <ffbbe596-c6a9-42ed-9156-e6d5c21eca9b@kernel.dk>
 <CGME20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46@epcas5p2.samsung.com>
 <20231115061027.20214-1-xiaobing.li@samsung.com>
 <433e9977-a85c-4d5a-aed2-a6f82fcc6bf4@kernel.dk>
In-Reply-To: <433e9977-a85c-4d5a-aed2-a6f82fcc6bf4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/23 6:42 AM, Jens Axboe wrote:
>> 2. Sometimes it can output, sometimes it outputs -1.
>>
>> The test results are as follows:
>> Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
>> SqMask: 0x3
>> SqHead: 6765744
>> SqTail: 6765744
>> CachedSqHead:   6765744
>> SqThread:       -1
>> SqThreadCpu:    -1
>> SqBusy: 0%
>> -------------------------------------------
>> Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
>> SqMask: 0x3
>> SqHead: 7348727
>> SqTail: 7348728
>> CachedSqHead:   7348728
>> SqThread:       9571
>> SqThreadCpu:    174
>> SqBusy: 95%
> 
> Right, this is due to the uring_lock. We got rid of the main
> regression, which was the new trylock for the sqd->lock, but the old
> one remains. We can fix this as well for sqpoll info, but it's not a
> regression from past releases, it's always been like that.
> 
> Pavel and I discussed it yesterday, and the easy solution is to make
> io_sq_data be under RCU protection. But that requires this patch
> first, so we don't have to fiddle with the sqpoll task itself. I can
> try and hack up the patch if you want to test it, it'd be on top of
> this one and for the next kernel release rather than 6.7.

Something like this, totally untested.

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..434a21a6b653 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -142,11 +142,16 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	 */
 	has_lock = mutex_trylock(&ctx->uring_lock);
 
-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
-		struct io_sq_data *sq = ctx->sq_data;
-
-		sq_pid = sq->task_pid;
-		sq_cpu = sq->sq_cpu;
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct io_sq_data *sq;
+
+		rcu_read_lock();
+		sq = READ_ONCE(ctx->sq_data);
+		if (sq) {
+			sq_pid = sq->task_pid;
+			sq_cpu = sq->sq_cpu;
+		}
+		rcu_read_unlock();
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850..583c76945cdf 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -70,7 +70,7 @@ void io_put_sq_data(struct io_sq_data *sqd)
 		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
 
 		io_sq_thread_stop(sqd);
-		kfree(sqd);
+		kfree_rcu(sqd, rcu);
 	}
 }
 
@@ -313,7 +313,7 @@ static int io_sq_thread(void *data)
 	}
 
 	io_uring_cancel_generic(true, sqd);
-	sqd->thread = NULL;
+	WRITE_ONCE(sqd->thread, NULL);
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
 	io_run_task_work();
@@ -411,7 +411,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
-		sqd->thread = tsk;
+		WRITE_ONCE(sqd->thread, tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..0cf0c5833a27 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -18,6 +18,8 @@ struct io_sq_data {
 
 	unsigned long		state;
 	struct completion	exited;
+
+	struct rcu_head		rcu;
 };
 
 int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);

-- 
Jens Axboe


