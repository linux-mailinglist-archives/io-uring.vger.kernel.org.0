Return-Path: <io-uring+bounces-1322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28A1C891F86
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AF2B1C28E45
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A631137900;
	Fri, 29 Mar 2024 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pcWGN8kJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE2C1369AA
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711719166; cv=none; b=e/NkfroQ7vhYmRdp7EcW1YfRmdz3203XsssN4vlt40FCx1SZhCKQ4QDyv0TmeKD3T1vYX6tGsbD+v8Up4sYjgV8BejwHyFx1w3xSpZ2igbom0r0HeOg96gfGzkEvm11g0hXzF5YsgCCgntYJbqFrk/Z6yzyTYjNns4Y6oHk1jJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711719166; c=relaxed/simple;
	bh=KcXiADnTQ2ikz3B+x/bufCtcVMmJ2lEv00Fn3d5Kuaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kVA04Z66x16X20L441HqXYSwZhdcyWZB3H8T9iSkViwa1ukxIzWZLiGZKaGeC4+xzVl6pIYmcWhLbgwbPzwD39M8PzMYR2KLb3+dshdFTxt7gY1jh+wS/cKesof4SlXFf7qSWeDc8pcButMdFlQiE197ko4ZHuVRSRNOwLE3XG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pcWGN8kJ; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5d862e8b163so452196a12.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 06:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711719164; x=1712323964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4djzyLVWkNg7QvxroevNGZkVJkZgbK2rnmSxOWF2yt0=;
        b=pcWGN8kJ+QkSHPoatqXYICJ2x06FT3oWwkjUnDRYRJM2mFL0kw3rIsqwYsJnYA9d2L
         UT1TN8ErN2pJyc0UYJUouAxmse6UJ2AQWwwqFOzrRUALy41k1bAyNX0mvQFkIC7abRTl
         NIkd/5ZS+X44HuGZE/20NOTV78AHrpG6Nxhr+AL9aNEQocVZ/reVW+AytUonb7zKlgA2
         yalJfOeFzRw99WDM24rkIvLIhu2wIIY6zN9yXOpbOxhT+p5nVdvLmM+GKjY9f0p6y1Cv
         dY5ihZ5CoZva63RntoDmfxVd21iRGdRvweCh9SwR+AKXtvQowE3eA0O3w6RvfgdPIJR2
         /4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711719164; x=1712323964;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4djzyLVWkNg7QvxroevNGZkVJkZgbK2rnmSxOWF2yt0=;
        b=eTNJfkRW060gVaqLDJx0XuOcMI9+gs80m+Gy+EbLpOsaHlbhthklSBzDmPY6JhbhEe
         jqzAulBLloBEBc84s+VcJpc+2z3hmXExr78tud/YbIONk1wPsy118SuTY3Rmv+vNywm6
         jmW4DLQIS6zoQtT/pEvVCIxVys/C3YmHpEsZDBbmhabvu68gx4WHCUoNNidw0c/BwBeD
         o60qCk7P2fr3uCHISxHQ0oi14AW0q1NXs4knSLzvNsN9vZ9fLBv8Go34ecZoxqOD82dy
         YUvAmHsdWNKXwoCgCDl9SdkYM6xO6m+QlRxLCU/8J+MeSvNj3jfV03WgOqpKiwN/qE2F
         mfwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz3zHIAJTTB5ERfF+Hw6rSZqNQxzR6dF1JRPsfCZhDIijfyBtse2kkvV01oIPvKvDKek0wffIpsfSNMrCuCoEIVXeem+5kuaM=
X-Gm-Message-State: AOJu0YwNor+zMW10NU6zYVj4PC+SwjdzjSF5wXTNO2AwOhOXeUWsNOnt
	MjMcrXNJ1Vqms4LWqArFFwb+U7E3m072DrcCCRg7GTPlTsjCCcEGyYCvthIXH8s8yCqeEywGVNG
	c
X-Google-Smtp-Source: AGHT+IE67zUicjFdPlOgTXtBK5Wa2cuFXcM032+2Du1rAw1vpZhHVfSgkl/WfBuwKkfYCzkRWzQg6A==
X-Received: by 2002:a17:902:c401:b0:1dd:e128:16b1 with SMTP id k1-20020a170902c40100b001dde12816b1mr2415374plk.6.1711719163630;
        Fri, 29 Mar 2024 06:32:43 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e0b5d49fc7sm3413770plg.161.2024.03.29.06.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 06:32:42 -0700 (PDT)
Message-ID: <597e01b6-901e-41c3-85bb-fc58b5514715@kernel.dk>
Date: Fri, 29 Mar 2024 07:32:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE
 posting
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240328185413.759531-1-axboe@kernel.dk>
 <20240328185413.759531-4-axboe@kernel.dk>
 <4edaf418-2012-4f85-9984-2130235cd31c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4edaf418-2012-4f85-9984-2130235cd31c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 6:54 AM, Pavel Begunkov wrote:
> On 3/28/24 18:52, Jens Axboe wrote:
>> Use the exported helper for queueing task_work, rather than rolling our
>> own.
>>
>> This improves peak performance of message passing by about 5x in some
>> basic testing, with 2 threads just sending messages to each other.
>> Before this change, it was capped at around 700K/sec, with the change
>> it's at over 4M/sec.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/msg_ring.c | 27 ++++++++++-----------------
>>   1 file changed, 10 insertions(+), 17 deletions(-)
>>
>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>> index d1f66a40b4b4..e12a9e8a910a 100644
>> --- a/io_uring/msg_ring.c
>> +++ b/io_uring/msg_ring.c
>> @@ -11,9 +11,9 @@
>>   #include "io_uring.h"
>>   #include "rsrc.h"
>>   #include "filetable.h"
>> +#include "refs.h"
>>   #include "msg_ring.h"
>>   -
>>   /* All valid masks for MSG_RING */
>>   #define IORING_MSG_RING_MASK        (IORING_MSG_RING_CQE_SKIP | \
>>                       IORING_MSG_RING_FLAGS_PASS)
>> @@ -21,7 +21,6 @@
>>   struct io_msg {
>>       struct file            *file;
>>       struct file            *src_file;
>> -    struct callback_head        tw;
>>       u64 user_data;
>>       u32 len;
>>       u32 cmd;
>> @@ -73,26 +72,20 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
>>       return current != target_ctx->submitter_task;
>>   }
>>   -static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
>> +static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
>>   {
>>       struct io_ring_ctx *ctx = req->file->private_data;
>> -    struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
>>       struct task_struct *task = READ_ONCE(ctx->submitter_task);
>>   -    if (unlikely(!task))
>> -        return -EOWNERDEAD;
>> -
>> -    init_task_work(&msg->tw, func);
>> -    if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
>> -        return -EOWNERDEAD;
>> -
>> +    __io_req_set_refcount(req, 2);
> 
> I'd argue it's better avoid any more req refcount users, I'd be more
> happy it it dies out completely at some point.
> 
> Why it's even needed here? You pass it via tw to post a CQE/etc and
> then pass it back via another tw hop to complete IIRC, the ownership
> is clear. At least it worth a comment.

It's not, it was more documentation than anything else. But I agree that
we should just avoid it, I'll kill it.

-- 
Jens Axboe


