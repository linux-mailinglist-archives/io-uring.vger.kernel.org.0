Return-Path: <io-uring+bounces-565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0C084C25A
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 03:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B51D1F24DC8
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 02:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B21DDB3;
	Wed,  7 Feb 2024 02:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="op6u/aXV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE38DF78
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272332; cv=none; b=RfJ/Fz/N5HVK3j6fg+T5PUkvOY/01QB04WsBAZEFHYQoSZ2DI0qNrgJvUtxhUpavoTLPkDdrd/kPZsWjHeR7HeAkaZRGAtdze7HRlsnmaLaVXurGz3c4O3sRrNfPKOOYJtQx+P80urP912MWhgfgOYPjh2691yUxS+PBrzTY/cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272332; c=relaxed/simple;
	bh=iNymVJjQWpgJ6K9iWHIZxeATuHv1VlVVDp96ItEk0k0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OujO0hIhjf0Dq+28QA1ygzq3cSC62SmEJiYdykdf6plk/7/vepaa+KoZCNUj/ebS3a7H5b/sTnjiXlPRyOsL+S88iWptr12TWZ5rG11/Kn/ygBBv7pyb/HTzJ7H7lNPKYCVCPOTa52KfYgVpNMHTUWXdz3wiv4DoKtS5MJHT82o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=op6u/aXV; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5dc13b142ffso29332a12.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 18:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707272329; x=1707877129; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3+ZCF2BGRCusCVH44hr0pB7gxPO1rQwdDSa9kElAzNI=;
        b=op6u/aXVFuWInsU1eiPB59gwcROLlzxdW/2R250c62i6hoIDVD3crN5bVcdHGnZWDD
         cY2aAhSNcQ48HoYS5tiCzo4/VaEAI74BqD/mpWl8JjcEE/nHOGE0VyMC6uwRX9hQA/9l
         U1lz0nIeUyMQwp8OsrhigKXHeuGVaA27Qemgu78z/Eu2maByB1BTMpHYX78qXvQNNarY
         VJ1xnulVxCVFi4OBYYzbw9W3eQDJ+knKYEA30cNHeuaoGBbqbI9kHST8JT7SDFnIEXHK
         dhtsOmLwH/kaVNcgilfv8Inx6bMY+9dkrzGEMvrq8PhGHQtXrRYGs5IeQfDQP3yEP5mQ
         c5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707272329; x=1707877129;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+ZCF2BGRCusCVH44hr0pB7gxPO1rQwdDSa9kElAzNI=;
        b=mclQYIE/JHzqlf5Ph6gtfv658oNWwn44P3TkNW16OtfTU8HWYhXCnzadFHVfniR0kL
         rryR2r0NbASqFea6uwOEzqslEE5EMqCjxBHtHPzuOEZv2im9aFy1JQ7UrCDfdgNgkDgm
         97tBjLR3ITmtsIX9CeG+ZuejQ8U82AEb6g0iRX9B3zk1IIo35t8IArq4LC9w5OWIDnh+
         3MKazVqBh+8wFQz6yyvzPY5Zx1tydWqUY/3fspE0Lyxi1VgbrtwJYIXQd0bUbQqjapJE
         nunJX+LtRWGlQGp/m+e4dm57bA+qTf1QGiOqtOazVwvZF4qR6F9fRQSXkOMNsG7+gKaq
         phcw==
X-Gm-Message-State: AOJu0YyRRIWcb+ZvKK+n153eyoiplMH/qnLxN7Da3nOcW6FhDIUlmisZ
	vp667GKuDaHsBGWBn2Vl1sNbnxWcwomyVOf+XBU4MhD8xsGOMwXouH9si2A/DCQ8RPistYNFC8W
	FZI4=
X-Google-Smtp-Source: AGHT+IHKlEEu93/NqoYB2w3mRI9MyjawC4uSJ/84n5ufogvcgEDDphuWfE361PP2i7WodlP576OV+Q==
X-Received: by 2002:a05:6a00:6ca5:b0:6e0:3353:1280 with SMTP id jc37-20020a056a006ca500b006e033531280mr4735205pfb.3.1707272329016;
        Tue, 06 Feb 2024 18:18:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXTbCic7TpBoEaumNd5Ufe5qnPqqCm/Mg8SFGi0BSnkdyr9SBxIH/kNi5lTan1f5ulD2MqzeC898NZGDkhCd9FReTxZ+vFpKpw=
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id g3-20020a62e303000000b006dddf2ed8f0sm196230pfh.154.2024.02.06.18.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 18:18:48 -0800 (PST)
Message-ID: <6f55dbd7-62a3-48d0-bc5a-2ddddb69e9ac@kernel.dk>
Date: Tue, 6 Feb 2024 19:18:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to
 64-bits
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-2-axboe@kernel.dk>
 <f4e5bd14-2550-4683-bdc3-7521351f81e1@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f4e5bd14-2550-4683-bdc3-7521351f81e1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 5:43 PM, Pavel Begunkov wrote:
> On 2/6/24 16:22, Jens Axboe wrote:
>> We're out of space here, and none of the flags are easily reclaimable.
>> Bump it to 64-bits and re-arrange the struct a bit to avoid gaps.
>>
>> Add a specific bitwise type for the request flags, io_request_flags_t.
>> This will help catch violations of casting this value to a smaller type
>> on 32-bit archs, like unsigned int.
>>
>> No functional changes intended in this patch.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring_types.h  | 87 ++++++++++++++++++---------------
>>   include/trace/events/io_uring.h | 14 +++---
>>   io_uring/filetable.h            |  2 +-
>>   io_uring/io_uring.c             |  9 ++--
>>   4 files changed, 60 insertions(+), 52 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 854ad67a5f70..5ac18b05d4ee 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -428,7 +428,7 @@ struct io_tw_state {
>>       bool locked;
>>   };
>>   -enum {
>> +enum io_req_flags {
>>       REQ_F_FIXED_FILE_BIT    = IOSQE_FIXED_FILE_BIT,
>>       REQ_F_IO_DRAIN_BIT    = IOSQE_IO_DRAIN_BIT,
>>       REQ_F_LINK_BIT        = IOSQE_IO_LINK_BIT,
>> @@ -468,70 +468,73 @@ enum {
>>       __REQ_F_LAST_BIT,
>>   };
>>   +typedef enum io_req_flags __bitwise io_req_flags_t;
>> +#define IO_REQ_FLAG(bitno)    ((__force io_req_flags_t) BIT_ULL((bitno)))
>> +
>>   enum {
>>       /* ctx owns file */
>> -    REQ_F_FIXED_FILE    = BIT(REQ_F_FIXED_FILE_BIT),
>> +    REQ_F_FIXED_FILE    = IO_REQ_FLAG(REQ_F_FIXED_FILE_BIT),
>>       /* drain existing IO first */
>> -    REQ_F_IO_DRAIN        = BIT(REQ_F_IO_DRAIN_BIT),
>> +    REQ_F_IO_DRAIN        = IO_REQ_FLAG(REQ_F_IO_DRAIN_BIT),
>>       /* linked sqes */
>> -    REQ_F_LINK        = BIT(REQ_F_LINK_BIT),
>> +    REQ_F_LINK        = IO_REQ_FLAG(REQ_F_LINK_BIT),
>>       /* doesn't sever on completion < 0 */
>> -    REQ_F_HARDLINK        = BIT(REQ_F_HARDLINK_BIT),
>> +    REQ_F_HARDLINK        = IO_REQ_FLAG(REQ_F_HARDLINK_BIT),
>>       /* IOSQE_ASYNC */
>> -    REQ_F_FORCE_ASYNC    = BIT(REQ_F_FORCE_ASYNC_BIT),
>> +    REQ_F_FORCE_ASYNC    = IO_REQ_FLAG(REQ_F_FORCE_ASYNC_BIT),
>>       /* IOSQE_BUFFER_SELECT */
>> -    REQ_F_BUFFER_SELECT    = BIT(REQ_F_BUFFER_SELECT_BIT),
>> +    REQ_F_BUFFER_SELECT    = IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
>>       /* IOSQE_CQE_SKIP_SUCCESS */
>> -    REQ_F_CQE_SKIP        = BIT(REQ_F_CQE_SKIP_BIT),
>> +    REQ_F_CQE_SKIP        = IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
>>         /* fail rest of links */
>> -    REQ_F_FAIL        = BIT(REQ_F_FAIL_BIT),
>> +    REQ_F_FAIL        = IO_REQ_FLAG(REQ_F_FAIL_BIT),
>>       /* on inflight list, should be cancelled and waited on exit reliably */
>> -    REQ_F_INFLIGHT        = BIT(REQ_F_INFLIGHT_BIT),
>> +    REQ_F_INFLIGHT        = IO_REQ_FLAG(REQ_F_INFLIGHT_BIT),
>>       /* read/write uses file position */
>> -    REQ_F_CUR_POS        = BIT(REQ_F_CUR_POS_BIT),
>> +    REQ_F_CUR_POS        = IO_REQ_FLAG(REQ_F_CUR_POS_BIT),
>>       /* must not punt to workers */
>> -    REQ_F_NOWAIT        = BIT(REQ_F_NOWAIT_BIT),
>> +    REQ_F_NOWAIT        = IO_REQ_FLAG(REQ_F_NOWAIT_BIT),
>>       /* has or had linked timeout */
>> -    REQ_F_LINK_TIMEOUT    = BIT(REQ_F_LINK_TIMEOUT_BIT),
>> +    REQ_F_LINK_TIMEOUT    = IO_REQ_FLAG(REQ_F_LINK_TIMEOUT_BIT),
>>       /* needs cleanup */
>> -    REQ_F_NEED_CLEANUP    = BIT(REQ_F_NEED_CLEANUP_BIT),
>> +    REQ_F_NEED_CLEANUP    = IO_REQ_FLAG(REQ_F_NEED_CLEANUP_BIT),
>>       /* already went through poll handler */
>> -    REQ_F_POLLED        = BIT(REQ_F_POLLED_BIT),
>> +    REQ_F_POLLED        = IO_REQ_FLAG(REQ_F_POLLED_BIT),
>>       /* buffer already selected */
>> -    REQ_F_BUFFER_SELECTED    = BIT(REQ_F_BUFFER_SELECTED_BIT),
>> +    REQ_F_BUFFER_SELECTED    = IO_REQ_FLAG(REQ_F_BUFFER_SELECTED_BIT),
>>       /* buffer selected from ring, needs commit */
>> -    REQ_F_BUFFER_RING    = BIT(REQ_F_BUFFER_RING_BIT),
>> +    REQ_F_BUFFER_RING    = IO_REQ_FLAG(REQ_F_BUFFER_RING_BIT),
>>       /* caller should reissue async */
>> -    REQ_F_REISSUE        = BIT(REQ_F_REISSUE_BIT),
>> +    REQ_F_REISSUE        = IO_REQ_FLAG(REQ_F_REISSUE_BIT),
>>       /* supports async reads/writes */
>> -    REQ_F_SUPPORT_NOWAIT    = BIT(REQ_F_SUPPORT_NOWAIT_BIT),
>> +    REQ_F_SUPPORT_NOWAIT    = IO_REQ_FLAG(REQ_F_SUPPORT_NOWAIT_BIT),
>>       /* regular file */
>> -    REQ_F_ISREG        = BIT(REQ_F_ISREG_BIT),
>> +    REQ_F_ISREG        = IO_REQ_FLAG(REQ_F_ISREG_BIT),
>>       /* has creds assigned */
>> -    REQ_F_CREDS        = BIT(REQ_F_CREDS_BIT),
>> +    REQ_F_CREDS        = IO_REQ_FLAG(REQ_F_CREDS_BIT),
>>       /* skip refcounting if not set */
>> -    REQ_F_REFCOUNT        = BIT(REQ_F_REFCOUNT_BIT),
>> +    REQ_F_REFCOUNT        = IO_REQ_FLAG(REQ_F_REFCOUNT_BIT),
>>       /* there is a linked timeout that has to be armed */
>> -    REQ_F_ARM_LTIMEOUT    = BIT(REQ_F_ARM_LTIMEOUT_BIT),
>> +    REQ_F_ARM_LTIMEOUT    = IO_REQ_FLAG(REQ_F_ARM_LTIMEOUT_BIT),
>>       /* ->async_data allocated */
>> -    REQ_F_ASYNC_DATA    = BIT(REQ_F_ASYNC_DATA_BIT),
>> +    REQ_F_ASYNC_DATA    = IO_REQ_FLAG(REQ_F_ASYNC_DATA_BIT),
>>       /* don't post CQEs while failing linked requests */
>> -    REQ_F_SKIP_LINK_CQES    = BIT(REQ_F_SKIP_LINK_CQES_BIT),
>> +    REQ_F_SKIP_LINK_CQES    = IO_REQ_FLAG(REQ_F_SKIP_LINK_CQES_BIT),
>>       /* single poll may be active */
>> -    REQ_F_SINGLE_POLL    = BIT(REQ_F_SINGLE_POLL_BIT),
>> +    REQ_F_SINGLE_POLL    = IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
>>       /* double poll may active */
>> -    REQ_F_DOUBLE_POLL    = BIT(REQ_F_DOUBLE_POLL_BIT),
>> +    REQ_F_DOUBLE_POLL    = IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
>>       /* request has already done partial IO */
>> -    REQ_F_PARTIAL_IO    = BIT(REQ_F_PARTIAL_IO_BIT),
>> +    REQ_F_PARTIAL_IO    = IO_REQ_FLAG(REQ_F_PARTIAL_IO_BIT),
>>       /* fast poll multishot mode */
>> -    REQ_F_APOLL_MULTISHOT    = BIT(REQ_F_APOLL_MULTISHOT_BIT),
>> +    REQ_F_APOLL_MULTISHOT    = IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
>>       /* recvmsg special flag, clear EPOLLIN */
>> -    REQ_F_CLEAR_POLLIN    = BIT(REQ_F_CLEAR_POLLIN_BIT),
>> +    REQ_F_CLEAR_POLLIN    = IO_REQ_FLAG(REQ_F_CLEAR_POLLIN_BIT),
>>       /* hashed into ->cancel_hash_locked, protected by ->uring_lock */
>> -    REQ_F_HASH_LOCKED    = BIT(REQ_F_HASH_LOCKED_BIT),
>> +    REQ_F_HASH_LOCKED    = IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
>>       /* don't use lazy poll wake for this request */
>> -    REQ_F_POLL_NO_LAZY    = BIT(REQ_F_POLL_NO_LAZY_BIT),
>> +    REQ_F_POLL_NO_LAZY    = IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
>>   };
>>     typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
>> @@ -592,15 +595,14 @@ struct io_kiocb {
>>        * and after selection it points to the buffer ID itself.
>>        */
>>       u16                buf_index;
>> -    unsigned int            flags;
>>   -    struct io_cqe            cqe;
> 
> With the current layout the min number of lines we touch per
> request is 2 (including the op specific 64B), that's includes
> setting up cqe at init and using it for completing. Moving cqe
> down makes it 3.
> 
>> +    atomic_t            refs;
> 
> We're pulling it refs, which is not touched at all in the hot
> path. Even if there's a hole I'd argue it's better to leave it
> at the end.
> 
>> +
>> +    io_req_flags_t            flags;
>>         struct io_ring_ctx        *ctx;
>>       struct task_struct        *task;
>>   -    struct io_rsrc_node        *rsrc_node;
> 
> It's used in hot paths, registered buffers/files, would be
> unfortunate to move it to the next line.

Yep I did feel a bit bad about that one... Let me take another stab at
it.

>> -
>>       union {
>>           /* store used ubuf, so we can prevent reloading */
>>           struct io_mapped_ubuf    *imu;
>> @@ -615,18 +617,23 @@ struct io_kiocb {
>>           struct io_buffer_list    *buf_list;
>>       };
>>   +    /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>> +    struct hlist_node        hash_node;
>> +
> 
> And we're pulling hash_node into the hottest line, which is
> used only when we arm a poll and remove poll. So, it's mostly
> for networking, sends wouldn't use it much, and multishots
> wouldn't normally touch it.
> 
> As for ideas how to find space:
> 1) iopoll_completed completed can be converted to flags2

That's a good idea, but won't immediately find any space as it'd just
leave a hole anyway. But would be good to note in there perhaps, you
never know when it needs re-arranging again.

> 2) REQ_F_{SINGLE,DOUBLE}_POLL is a weird duplication. Can
> probably be combined into one flag, or removed at all.
> Again, sends are usually not so poll heavy and the hot
> path for recv is multishot.

Normal receive is also a hot path, even if multishot should be preferred
in general. Ditto on non-sockets but still pollable files, doing eg read
for example.

> 3) we can probably move req->task down and replace it with
> 
> get_task() {
>     if (req->ctx->flags & DEFER_TASKRUN)
>         task = ctx->submitter_task;
>     else
>         task = req->task;
> }

Assuming ctx flags is hot, which is would generally be, that's not a bad
idea at all.

I'll do another loop over this one.

-- 
Jens Axboe


