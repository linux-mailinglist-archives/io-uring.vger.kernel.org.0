Return-Path: <io-uring+bounces-1095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9760287E8ED
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 12:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52E8D282579
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 11:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D42537140;
	Mon, 18 Mar 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYK1YowG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F11E374E9;
	Mon, 18 Mar 2024 11:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710762726; cv=none; b=VnTyPCPZ28SwLRNVBx5isb27UTfRnbs3vbsjZwq6wAThiYVMz2RbLyNKiJZzcUUN05NvsaAVy4b7ZDyPSj3RD9bd2BZrJEmIiKVVXLIOTGw7Ksf51kas4iTDQ7okHJz4zIxcbwX1M0YnGip35TppQ+napzid0+m5nSbJRmie0FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710762726; c=relaxed/simple;
	bh=9WsAR3teH75pXAmu1P4iEy175TzCN6G4J6MS098sdPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdqZL7ESOY7fJpNsZJdGwpg4V4qfHIApvOZh5gxd0wZABLZPgT863TF/4mH+2SQuQLfd/bQpvoAPOAtp/jzfVNvTlwH7pcpBR4z5UslFCmFTUzeaQqFAi80hXzTTeXdGyBPOMiJqnO3xSh9a76TURfD8iCHSMR6SxmKCIm8YP78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cYK1YowG; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3412f49bac7so1033400f8f.0;
        Mon, 18 Mar 2024 04:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710762723; x=1711367523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fTPBON2nGMCqUjdCxQvCXJp/3kfvag8MxQ/6L8GGJR8=;
        b=cYK1YowGm+GcnwCo80DMAZZMEcW509cHawtOIAoAHZMYqh64arrOwmiHLSkSNaHpcu
         8TEn1b1dF2T9/TyqNngtoyHufGiy4R49aBblnMlmgnFiqFi2XNQhZN4NsG62MLEP9/3A
         PjzeWoY7JzECQh2r1UT1kIVhPZ9IKMH1uYmzD4LsrSD0siLrPLQXq6zWHL2SLDi1ZvOR
         P34WIecLCkZCq4KOEmXo8XlocqF3REO2b43WeHyjlbtaZHdtro/7qg9npfuhMBGWfHML
         I8e9HfeU61wu1fiDOJx1YhSZXEmKEKPXyRbOfYx6o8UsZm90Zr/jI5OFiPW1uYwdOjIp
         4GWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710762723; x=1711367523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTPBON2nGMCqUjdCxQvCXJp/3kfvag8MxQ/6L8GGJR8=;
        b=UPf7yifKRBn7aiFUSDjVeKaIj+uB3eoAeserLTkkHeffLn4W8y74DEDtFWKkroURE6
         BH6NqBagrukMzLzip464tF0iTcbZa1O7FNfaQWYYhH8YXivY2Bkvx9g+1uG0ewWCbrPR
         7aouhY2k4PsDqfOvV+7MLTCmk2LRae/vFpgkKifNGUE24txAuncXl47bkrB1SZXWuRwL
         Kb/FOW4NhUtQAfx9ujVVLX/EgElLKW//3fUj+RaoW/ylcUBFhZisJSdYdv2farTHsOfL
         Yw5PzSmDkuxiYsjc7K/zx/6C9umbrD+wHiSGFkmNnOZ9YhDSVdF25VGUnXz0lD9iK7Q8
         l3xQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+NRFI2kfYNuLFBK94TBRhFf6p9mgGXoDhLJT1uRiYe1xIHfVQJVTdsHzqO/OgLcwNIyJsdghc8IJ2sg5eLHQAvZIIjZQ4mo46hDg=
X-Gm-Message-State: AOJu0YxRTwAsjB+LISkf5jwuS+FvhU9E0LYSS94bb5xjvX815q3+Ky/q
	rmYBX/af+Hqe0zeR8Sw/c5kc4xZ+CipK5aQcOYcwue7Q6lpOJuBn+kvdC726
X-Google-Smtp-Source: AGHT+IHop/NqrSoiMJaJr6zupWXIw2SouctMfhZM+gpeT9xTbHWfdEH6ABPXg/RF0/t3J5oLa5YZOg==
X-Received: by 2002:a5d:6c63:0:b0:341:76bc:2bfe with SMTP id r3-20020a5d6c63000000b0034176bc2bfemr2611505wrz.4.1710762722661;
        Mon, 18 Mar 2024 04:52:02 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d69c6000000b0033e9f6997c7sm9587791wrw.66.2024.03.18.04.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 04:52:02 -0700 (PDT)
Message-ID: <4c6a5b55-2833-4ef7-a514-577fe61160dd@gmail.com>
Date: Mon, 18 Mar 2024 11:50:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/14] io_uring/cmd: make io_uring_cmd_done irq safe
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <faeec0d1e7c740a582f51f80626f61c745ed9a52.1710720150.git.asml.silence@gmail.com>
 <Zff25z0fPGBPfJs1@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zff25z0fPGBPfJs1@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 08:10, Ming Lei wrote:
> On Mon, Mar 18, 2024 at 12:41:48AM +0000, Pavel Begunkov wrote:
>> io_uring_cmd_done() is called from the irq context and is considered to
>> be irq safe, however that's not the case if the driver requires
>> cancellations because io_uring_cmd_del_cancelable() could try to take
>> the uring_lock mutex.
>>
>> Clean up the confusion, by deferring cancellation handling to
>> locked task_work if we came into io_uring_cmd_done() from iowq
>> or other IO_URING_F_UNLOCKED path.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/uring_cmd.c | 24 +++++++++++++++++-------
>>   1 file changed, 17 insertions(+), 7 deletions(-)
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index ec38a8d4836d..9590081feb2d 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -14,19 +14,18 @@
>>   #include "rsrc.h"on 
>>   #include "uring_cmd.h"
>>   
>> -static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
>> -		unsigned int issue_flags)
>> +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
>>   {
>>   	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   
>> +	lockdep_assert_held(&ctx->uring_lock);
>> +
>>   	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
>>   		return;
>>   
>>   	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
>> -	io_ring_submit_lock(ctx, issue_flags);
>>   	hlist_del(&req->hash_node);
>> -	io_ring_submit_unlock(ctx, issue_flags);
>>   }
>>   
>>   /*
>> @@ -44,6 +43,9 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>   	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   
>> +	if (WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL))
>> +		return;
>> +
> 
> This way limits cancelable command can't be used in iopoll context, and
> it isn't reasonable, and supporting iopoll has been in ublk todo list,
> especially single ring context is shared for both command and normal IO.

That's something that can be solved when it's needed, and hence the
warning so it's not missed. That would need del_cancelable on the
->iopoll side, but depends on the "leaving in cancel queue"
problem resolution.

-- 
Pavel Begunkov

