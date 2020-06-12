Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3F1F7BCD
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 18:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgFLQsH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgFLQsH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 12:48:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF9BC03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 09:48:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h95so4087565pje.4
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 09:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0AUAcvHJwskROEjlmDaFAkKnySaij+Go6v0Bllxdf7w=;
        b=AkwSDhQQzOofxLzEFbF+qXq58kSZ+0YE1eOkPTxzq4sZ0f7DBu5bGOfOH3nE1Jd2ms
         FqBbl4pAztNoFFmkehCWasxq+d23r5xyEb5O5Mp49nbLBfOgVLgd/LLbZ8zsssTZUQut
         jLex2teeJH5DwRBHaRt3KnX3lIS5UAXZ3UeGoKnnVXUfebzlWDhxjvedMhK1hQf74DUM
         X5oJcujeNU+UZsD1CX1KaD7uHRO5DQyPbkiQczvZWaEzYKAVhvbo12IW7BugOLK3td6m
         KhX5jWh5aZ/ER9KGziBrA6JBSDnkMFCanQhELhTBarxgww93BnUmnqNRjiFrkHwGDOZP
         +CPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0AUAcvHJwskROEjlmDaFAkKnySaij+Go6v0Bllxdf7w=;
        b=AgqpDFxwOJof6LzE+LnbN4XmI+6Xh5oTGHdsXK+8yDt8V3SQSuyp2oDe33MtLpB5TX
         xRAjuhPRFs7FL2k/ereoc3+zKsfA2C2dINvmUNH8f2UnufQybge0E64rpXt9w1wEJxa2
         CtrvtKhraQLB+YU1RwQZUDL9chU2TciOAOz+u15Av3eEDX9NrqhiMn+Kjj/WHwXwSDsm
         aIj7PbZ59I3XGnBHW+ZeWzJxoSpnqtThIREPdtiKqMdahGgydKBNT9gfYSQ6Y44ReBIg
         IIuwi5mpulO/7WX5mHli8FcUeaj2b95DC6nWH5aCWWPBz+Ane7wW8TOCBLT9tx/3CuQw
         88wQ==
X-Gm-Message-State: AOAM531NUKfRSCyD4+BZxiQSHL4O/wooPNg+ySNR4r3IXvZ+sDIaH4bk
        +yHp3fNqcpifT6w3UpAPVIsXfh5Po6v/Iw==
X-Google-Smtp-Source: ABdhPJwXEX+mKGNl1zdaMsPRY58b11OZwBB36Dux/sX9tAn68k2dsCfQP9vK3lym8l9mHnVHqqs6TQ==
X-Received: by 2002:a17:90a:9dc8:: with SMTP id x8mr13263221pjv.23.1591980485844;
        Fri, 12 Jun 2020 09:48:05 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y3sm6135635pff.37.2020.06.12.09.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 09:48:05 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
From:   Jens Axboe <axboe@kernel.dk>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
Message-ID: <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
Date:   Fri, 12 Jun 2020 10:48:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 8:58 AM, Jens Axboe wrote:
> On 6/11/20 8:30 PM, Jiufei Xue wrote:
>> poll events should be 32-bits to cover EPOLLEXCLUSIVE.
>>
>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> ---
>>  fs/io_uring.c                 | 4 ++--
>>  include/uapi/linux/io_uring.h | 2 +-
>>  tools/io_uring/liburing.h     | 2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 47790a2..6250227 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4602,7 +4602,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>  static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  {
>>  	struct io_poll_iocb *poll = &req->poll;
>> -	u16 events;
>> +	u32 events;
>>  
>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  		return -EINVAL;
>> @@ -8196,7 +8196,7 @@ static int __init io_uring_init(void)
>>  	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
>>  	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
>>  	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
>> -	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
>> +	BUILD_BUG_SQE_ELEM(28, __u32,  poll_events);
>>  	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
>>  	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
>>  	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 92c2269..afc7edd 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -31,7 +31,7 @@ struct io_uring_sqe {
>>  	union {
>>  		__kernel_rwf_t	rw_flags;
>>  		__u32		fsync_flags;
>> -		__u16		poll_events;
>> +		__u32		poll_events;
>>  		__u32		sync_range_flags;
>>  		__u32		msg_flags;
>>  		__u32		timeout_flags;
> 
> We obviously have the space in there as most other flag members are 32-bits, but
> I'd want to double check if we're not changing the ABI here. Is this always
> going to be safe, on any platform, regardless of endianess etc?

Double checked, and as I feared, we can't safely do this. We'll have to
do something like the below, grabbing an unused bit of the poll mask
space and if that's set, then store the fact that EPOLLEXCLUSIVE is set.
So probably best to turn this just into one patch, since it doesn't make
a lot of sense to do it as a prep patch at that point.

This does have the benefit of not growing io_poll_iocb. With your patch,
it'd go beyond a cacheline, and hence bump the size of the entire
io_iocb as well, which would be very unfortunate.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d830ddb..64a98bf11943 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -350,6 +350,7 @@ struct io_poll_iocb {
 		u64			addr;
 	};
 	__poll_t			events;
+	bool				exclusive;
 	bool				done;
 	bool				canceled;
 	struct wait_queue_entry		wait;
@@ -4543,7 +4544,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	u16 events;
+	u32 events;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4553,6 +4554,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EBADF;
 
 	events = READ_ONCE(sqe->poll_events);
+	if ((events & IORING_POLL_32BIT) &&
+	    (sqe->poll32_events & EPOLLEXCLUSIVE))
+		poll->exclusive = true;
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
 
 	get_task_struct(current);
@@ -8155,6 +8159,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
 	BUILD_BUG_SQE_ELEM(28, __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
 	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..16d473d909eb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -32,6 +32,7 @@ struct io_uring_sqe {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;
+		__u32		poll32_events;
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
@@ -60,6 +61,8 @@ struct io_uring_sqe {
 	};
 };
 
+#define IORING_POLL_32BIT	(1U << 15)
+
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,

-- 
Jens Axboe

