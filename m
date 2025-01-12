Return-Path: <io-uring+bounces-5835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F492A0AAC7
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 17:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E84CC3A645C
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 16:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B040D1BD9CE;
	Sun, 12 Jan 2025 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNPtr71G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122181BD50D;
	Sun, 12 Jan 2025 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736698455; cv=none; b=ONvBsjtjQqDxP5sAtqBCJs+lN6gg+eQlGxzLKYQJ8BXcIfYxMfA2ANwq7nnjqxJOSYyFrpU4rThxWiB4IK/wiEj6xUuj8VwMJiVzEDyY02QrGxjkzS6/lR/oH1jOqnJvoyCkWwvewDuxdoUx0mTQ/7SGpMFmNwBEUmJ0eIOIwNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736698455; c=relaxed/simple;
	bh=vyq9RgiC9dE0E7EF1X7gllkJtYwNmM4xqIKLX4cqI+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mu9NaB5ONhmtzvtKwI0xzwe1rOSL1OhTlOLWHO84Wn0YIQ9Pup5J3ou5wkM7u1lS8TwUusUK+1UHLjLgzlQ3PKPTY/sSYJn0Ptsiwvz6PGfz4e1AhhChIaiZdOstVlOwWKsgjcOJX3b94Ebwv9Js72PIooIXS/EeBcYisBGynnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNPtr71G; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21631789fcdso57703275ad.1;
        Sun, 12 Jan 2025 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736698453; x=1737303253; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oBzhJr+k1vq1LNK3Y3l4RwsWZcC3JndJ879hRjD0Iik=;
        b=eNPtr71GWAN7YH3ZJx0YIkLLTUwvgxKveSGj8t1O5RMP3sSEWgUmjxR8od3Ye/Onql
         vvlYIogdt43AWjUYzXV9ih95vv2bcOvbXBsIRiiXEZJalO9OZLQ9GWpk4K4muU5FYYGC
         JLtd9pwrUwKg5488vs6HbF98CFLUdE/4Sjnb5/lHo5EtOc8pspf9SpC9Wwv5WFviGgqv
         oP2XRddzgOQrjybO6W1JrorIbp9HUF1sSQw8KTpU6hioOn0UPktsbBmgWLJWC0HncrrL
         nTspSkhNTWZyYq8cBdr50oB0GfPXpnmg8ZH+OCtn5hDh9XfcMy09r2zZrWeJw64SPxd2
         KdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736698453; x=1737303253;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBzhJr+k1vq1LNK3Y3l4RwsWZcC3JndJ879hRjD0Iik=;
        b=ONi9CNHWV0RH9t3N9UqYOQAuvpe2oxXad8kn0APnlgwhtN7YLX/2wEoBoVc3Wz2drX
         po1PK3DvVqgVa/Ro7xfbxICQsi+waZlJmtLYb1/ptI3B2AEp2pp5qnv2IXDY9zg74d5a
         5rildILEDwAHHoltQ+jmRAQC+ubtusc+Yxv6qUrEoRNUId0uXAB2EOvioc6FzWc/bQt3
         CgfObw4W8wZ/pL+IPdxdsjVkZOwhYfL8Q1BIi0ZAGNd9OVXzK3NAYg1TUpiuyujrLFYy
         Sur+RD1oPqmFswPCrLZrR9b8iRXn7iTIrVVzMZMeomL/iQ47Aa0Z88DmA7jPjhYga3w8
         z8Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXuRnKf9dgcgXpNQ6+7qrjkGqysKFaSVVoq6TaUdG2RTS/dOt0NN9J8o3p5FG1qLjC1iuD2g9E34MWkRNxh@vger.kernel.org, AJvYcCXutYX2DPB9WlOChccVsuYyu8QIqgNk+QO0ZPDn0eOBPjS1Z5gqr8FUCZgD1wFTzNPvn9If4RZqzw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/6Hfi+pZyN2IssN913Od9UVbuC94/B4c65pf00ceqOgAgCOYq
	uT0TdEZPSORC1MCz2wFOhT1gDdbvehXmlnec/LlaTluXDmvaTQSG
X-Gm-Gg: ASbGncv9DLBLlAd+dPMbuhWVUNC6cNHT8e+R87jS+dmRvXcKAlQT7HsiN1FA0qtbZpX
	e119waJDwbe38Rz7AwcUPUSlKNLvCCbLwv7fPn44H4znXxlfinEKnOeK2QzDaBQLbSmJpKOm3yG
	EtDk3PW2dXHtQqtAUmWBbFMjrT3nvLQyG8jdMT0Dw6pPd+zriu9ykemljC0oW/PiLSTJqnEjeEW
	EsEA9wllTCmi3b2jiZqoSuNUIyk/OJ6B6NqRdTSRB9yMDPa1SqJ/kQOj16uxC8uFTq51+2fuvZw
	r8D4hx26w7lEyGgNyXiTfZJ6m6UZlgmM85c=
X-Google-Smtp-Source: AGHT+IEtRQErnOF4WJIU3VxNAlu7FszxexVnk6fZPfJM+2Ar1lmjbYcuHr9BDGcps7YNH0jfVVIVCg==
X-Received: by 2002:a17:90b:4ed0:b0:2ee:edae:775 with SMTP id 98e67ed59e1d1-2f55831577dmr18437910a91.3.1736698453238;
        Sun, 12 Jan 2025 08:14:13 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4c:d5a0:dc9e:dbbf:276e:9751? ([2001:ee0:4f4c:d5a0:dc9e:dbbf:276e:9751])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10e0dfsm40536105ad.41.2025.01.12.08.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 08:14:12 -0800 (PST)
Message-ID: <3cab5ad8-3089-46c7-868e-38bd3c250b26@gmail.com>
Date: Sun, 12 Jan 2025 23:14:07 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
To: lizetao <lizetao1@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com"
 <syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com>
References: <20250112143358.49671-1-minhquangbui99@gmail.com>
 <aff011219272498a900f052d0142978c@huawei.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <aff011219272498a900f052d0142978c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/25 22:45, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Bui Quang Minh <minhquangbui99@gmail.com>
>> Sent: Sunday, January 12, 2025 10:34 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: Bui Quang Minh <minhquangbui99@gmail.com>; Jens Axboe
>> <axboe@kernel.dk>; Pavel Begunkov <asml.silence@gmail.com>; io-
>> uring@vger.kernel.org;
>> syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com; lizetao
>> <lizetao1@huawei.com>
>> Subject: [PATCH] io_uring: simplify the SQPOLL thread check when cancelling
>> requests
>>
>> In io_uring_try_cancel_requests, we check whether sq_data->thread ==
>> current to determine if the function is called by the SQPOLL thread to do iopoll
>> when IORING_SETUP_SQPOLL is set. This check can race with the SQPOLL
>> thread termination.
>>
>> io_uring_cancel_generic is used in 2 places: io_uring_cancel_generic and
>> io_ring_exit_work. In io_uring_cancel_generic, we have the information
>> whether the current is SQPOLL thread already. In io_ring_exit_work, in case
>> the SQPOLL thread reaches this path, we don't need to iopoll and leave that for
>> io_uring_cancel_generic to handle.
>>
>> So to avoid the racy check, this commit adds a boolean flag to
>> io_uring_try_cancel_requests to determine if we need to do iopoll inside the
>> function and only sets this flag in io_uring_cancel_generic when the current is
>> SQPOLL thread.
>>
>> Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
>> Reported-by: Li Zetao <lizetao1@huawei.com>
>> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
>> ---
>>   io_uring/io_uring.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c index
>> ff691f37462c..f28ea1254143 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -143,7 +143,8 @@ struct io_defer_entry {
>>
>>   static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>   					 struct io_uring_task *tctx,
>> -					 bool cancel_all);
>> +					 bool cancel_all,
>> +					 bool force_iopoll);
>>
>>   static void io_queue_sqe(struct io_kiocb *req);
>>
>> @@ -2898,7 +2899,12 @@ static __cold void io_ring_exit_work(struct
>> work_struct *work)
>>   		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>   			io_move_task_work_from_local(ctx);
>>
>> -		while (io_uring_try_cancel_requests(ctx, NULL, true))
>> +		/*
>> +		 * Even if SQPOLL thread reaches this path, don't force
>> +		 * iopoll here, let the io_uring_cancel_generic handle
>> +		 * it.
> 
> Just curious, will sq_thread enter this io_ring_exit_work path?

AFAIK, yes. The SQPOLL thread is created with create_io_thread, this 
function creates a new task with CLONE_FILES. So all the open files is 
shared. There will be case that the parent closes its io_uring file and 
SQPOLL thread become the only owner of that file. So it can reach this 
path when terminating.


>> +		 */
>> +		while (io_uring_try_cancel_requests(ctx, NULL, true, false))
>>   			cond_resched();
>>
>>   		if (ctx->sq_data) {
>> @@ -3066,7 +3072,8 @@ static __cold bool io_uring_try_cancel_iowq(struct
>> io_ring_ctx *ctx)
>>
>>   static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>   						struct io_uring_task *tctx,
>> -						bool cancel_all)
>> +						bool cancel_all,
>> +						bool force_iopoll)
>>   {
>>   	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
>>   	enum io_wq_cancel cret;
>> @@ -3096,7 +3103,7 @@ static __cold bool
>> io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>
>>   	/* SQPOLL thread does its own polling */
>>   	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
>> -	    (ctx->sq_data && ctx->sq_data->thread == current)) {
>> +	    force_iopoll) {
>>   		while (!wq_list_empty(&ctx->iopoll_list)) {
>>   			io_iopoll_try_reap_events(ctx);
>>   			ret = true;
>> @@ -3169,13 +3176,15 @@ __cold void io_uring_cancel_generic(bool
>> cancel_all, struct io_sq_data *sqd)
>>   					continue;
>>   				loop |= io_uring_try_cancel_requests(node-
>>> ctx,
>>   							current->io_uring,
>> -							cancel_all);
>> +							cancel_all,
>> +							false);
>>   			}
>>   		} else {
>>   			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>>   				loop |= io_uring_try_cancel_requests(ctx,
>>   								     current-
>>> io_uring,
>> -								     cancel_all);
>> +								     cancel_all,
>> +								     true);
>>   		}
>>
>>   		if (loop) {
>> --
>> 2.43.0
>>
> 
> Maybe you miss something, just like Begunkov mentioned in your last version patch:
> 
>    io_uring_cancel_generic
>      WARN_ON_ONCE(sqd && sqd->thread != current);
> 
> This WARN_ON_ONCE will never be triggered, so you could remove it.

He meant that we don't need to annotate sqd->thread access in this debug 
check. The io_uring_cancel_generic function has assumption that the sgd 
is not NULL only when it's called by a SQPOLL thread. So the check means 
to ensure this assumption. A data race happens only when this function 
is called by other tasks than the SQPOLL thread, so it can race with the 
SQPOLL termination. However, the sgd is not NULL only when this function 
is called by SQPOLL thread. In normal situation following the 
io_uring_cancel_generic's assumption, the data race cannot happen. And 
in case the assumption is broken, the warning almost always is triggered 
even if data race happens. So we can ignore the race here.

Thanks,
Quang Minh.


