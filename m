Return-Path: <io-uring+bounces-7783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7BEAA4536
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 10:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 385784C75C4
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 08:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F889217F27;
	Wed, 30 Apr 2025 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+p8fZf4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D3F1E9B09;
	Wed, 30 Apr 2025 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746001469; cv=none; b=BV2Jlk58NDrESjUelyljKOLqaS/OhlRPIZzkFA2n3eptHzqi+XyoIa9++GrG4MsqVEfsdXGosvuhXMc5gilTqCFNZnyI+OwdgAGzlOSeWiCCiNhd6TyNxPAe1Aff/R/A31nu+zTMCy2cnT0CjFIgBrn0JJ7lGKZHfjNDTjFY4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746001469; c=relaxed/simple;
	bh=8fkyNyUVXECHN7O9FkVLB8YeVUBDa+UCuwUf/uSwB2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SD6OKWI3YcteLYlliASBoKU5Ecnm9MZGv4PEF5nRmNySlaweUBBvumepiLp7g3SoRxRfNcyl3SJNqP6FJk8nCj4fEJmRmGKOY62HUeu9vUUDSqTN4lbxrfEdQsuTK77mS02zptFXzDlSUz+Gk5aahqm/eo1r6gFJRf6E2dCZdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L+p8fZf4; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac7bd86f637so126957066b.1;
        Wed, 30 Apr 2025 01:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746001466; x=1746606266; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XqLVOpmJpq6TMB8CUcP8JUDj3MsyXiQ/2WIfIK3FJgo=;
        b=L+p8fZf4B0X9cI7bYQm63VrEAu2kSTbvpLaHAcsScMAGSE/okUpmMQiWQR3uY9Inu/
         XVYaXBDR7ZfHTM05It8lio+86doGzTLoNBFdhHLBEosQLdPgJhiu7xTluuCll8Tdpdzz
         91Wql2/ycg79dcqNmCkzSwNUgafSM3lqs/fwwphMavY4UonqtKkPXF5oPoMFqMzv/ozF
         mQTPBrpKDZTcWWYuxp1KA+wXgrtylue4AaWkLCDBjLGnptvnZR3hStQIPLhWsGOf1Z2H
         HaEvvzAQmgjBLTZJYMbDSXD9S2sX9yC70//zH+k4MkyP2av9f12cHm/pcaK63SrPg6V1
         RAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746001466; x=1746606266;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqLVOpmJpq6TMB8CUcP8JUDj3MsyXiQ/2WIfIK3FJgo=;
        b=OICld6AgZNc0zCTn9rJjVe2PAeaICoZfSME/C4kxzNnFrCVrqlgOrWvgSPzHuBvt3e
         xb+jpq/0w45Hki8jqA/lQ6kJzGXJbrw4DkzrpdsMWlEOpKYzXwKPH34/uT20Jgln+z6N
         y/DRZhOt1Og+sh1FDj1guIjDiP1yE05wV+30MdDWOtCp0n2wkJ/VZw3i62MMqSJ57Z7g
         pWdN6wOlekY7ah73fUrcIWXtopKCaV8qgWjAVyyPlxkqAMuvfzWEmy5m0QQ0IeyNBy/r
         Hbthv+sHyn9kbROe88T+6gzOcRkFEqugBpGENpu8g4vVujfDrwVDE8phlUnxrQ25sAZF
         WaNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHrxOuNzsS6bFKePgEVeoofRf/3yVWR5D44jOzlbsWcm1LFTvqUTX+WNAVYtnqXJQUT2ahEZym8g==@vger.kernel.org, AJvYcCWQBGUY4zq+pYZCVR1QkBxzZOZAO7i+0LR8ZuhBAojj0n0Vgy17Dw4CsygSPoD7WzGG0W0TH20b2T/ZOPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTk8fJvmtZyJ/DrYJswpsu5SuIijArfnK1DLhj5zHE845ZSVK0
	n25Mc4Lv+BuPHWV/WuClrXLQpZyI1189qsRmPNkpOHNw8j5hmVgO
X-Gm-Gg: ASbGncuqOmVqdWrG2SzudP8lflbUjqINm9dQVzSL775gjGDZnFT/Ruue53tzn7nMpXr
	Ut8qgDI7h4aO0ci41kucgwnaERiPlnKfJBEujyFDRBsDTUdyE34Y2UoxJlHn6o/h3RQLC1Wh3fS
	jnK4YuG70GrRkRuz4btcRI6X2ffoGU02Ri3n16UYijDNeYVA6B0tynqxRN95azbe4HAE4PYF0wY
	eR+LnuwPtw81LrJcrYHd4OBFLU4xsX9IvEDmFXBRo+tflzqrW3ulYBYLyMRXyj56/hHLCcusssT
	UpewdKXeVBME5nU2YjLff1EuUqtGLK/6+fui1juSxfy1k340WRdN
X-Google-Smtp-Source: AGHT+IGCIrJhEEgA9gt/jbp5wNy3f0GP/PWbWGzNVUvDBGdMeH0nd6Is3aPKIH+uQxD+rkSlZfW15g==
X-Received: by 2002:a17:907:da15:b0:abf:174b:8ca6 with SMTP id a640c23a62f3a-acedf9e3c55mr161405866b.27.1746001465489;
        Wed, 30 Apr 2025 01:24:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::ee? ([2620:10d:c092:600::1:a554])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acec4a8426dsm260900966b.56.2025.04.30.01.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 01:24:24 -0700 (PDT)
Message-ID: <2ad7f153-9d22-43df-8b7d-3d098916c62b@gmail.com>
Date: Wed, 30 Apr 2025 09:25:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/7] io_uring: support to register bvec buffer to
 specified io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@kernel.org>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-4-ming.lei@redhat.com>
 <0c542e65-d203-4a3e-b9fd-aa090c144afd@gmail.com> <aBAhr01KAr2qj5qi@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aBAhr01KAr2qj5qi@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 01:47, Ming Lei wrote:
> On Mon, Apr 28, 2025 at 11:28:30AM +0100, Pavel Begunkov wrote:
>> On 4/28/25 10:44, Ming Lei wrote:
>>> Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
>>> supporting to register/unregister bvec buffer to specified io_uring,
>>> which FD is usually passed from userspace.
>>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    include/linux/io_uring/cmd.h |  4 ++
>>>    io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
>>>    2 files changed, 67 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>> index 78fa336a284b..7516fe5cd606 100644
>>> --- a/include/linux/io_uring/cmd.h
>>> +++ b/include/linux/io_uring/cmd.h
>>> @@ -25,6 +25,10 @@ struct io_uring_cmd_data {
>> ...
>>>    	io_ring_submit_lock(ctx, issue_flags);
>>> -	ret = __io_buffer_unregister_bvec(ctx, buf);
>>> +	if (reg)
>>> +		ret = __io_buffer_register_bvec(ctx, buf);
>>> +	else
>>> +		ret = __io_buffer_unregister_bvec(ctx, buf);
>>>    	io_ring_submit_unlock(ctx, issue_flags);
>>>    	return ret;
>>>    }
>>> +
>>> +static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
>>> +				    struct io_buf_data *buf,
>>> +				    unsigned int issue_flags,
>>> +				    bool reg)
>>> +{
>>> +	struct io_ring_ctx *remote_ctx = ctx;
>>> +	struct file *file = NULL;
>>> +	int ret;
>>> +
>>> +	if (buf->has_fd) {
>>> +		file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
>>
>> io_uring_register_get_file() accesses task private data and the request
>> doesn't control from which task it's executed. IOW, you can't use the
>> helper here. It can be iowq or sqpoll, but either way nothing is
>> promised.
> 
> Good catch!
> 
> Actually ublk uring_cmd is guaranteed to be issued from user context.
> 
> We can enhance it by failing buffer register:
> 
> 	if ((current->flags & PF_KTHREAD) || (issue_flags & IO_URING_F_IOWQ))
> 		return -EACCESS;

Can it somehow check that current matches the desired task? That's exactly
the condition where it can go wrong, and that's much better than listing all
corner cases that might change.

Just to avoid confusion, it's not guaranteed by io_uring it'll be run from
the "right" task. If that changes in the future, either the ublk uapi should
be mandating the user to fall back to something else like regular fds, or
ublk will need to handle it somehow.

>>> +		if (IS_ERR(file))
>>> +			return PTR_ERR(file);
>>> +		remote_ctx = file->private_data;
>>> +		if (!remote_ctx)
>>> +			return -EINVAL;
>>
>> nit: this check is not needed.
> 
> OK.
> 
>>
>>> +	}
>>> +
>>> +	if (remote_ctx == ctx) {
>>> +		do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
>>> +	} else {
>>> +		if (!(issue_flags & IO_URING_F_UNLOCKED))
>>> +			mutex_unlock(&ctx->uring_lock);
>>
>> We shouldn't be dropping the lock in random helpers, for example
>> it'd be pretty nasty suspending a submission loop with a submission
>> from another task.
>>
>> You can try lock first, if fails it'll need a fresh context via
>> iowq to be task-work'ed into the ring. see msg_ring.c for how
>> it's done for files.
> 
> Looks trylock is better, will take this approach by returning -EAGAIN,
> and let ublk driver retry.

Is there a reliable fall back path for the userspace? Hammering the
same thing until it succeeds in never a good option.

-- 
Pavel Begunkov


