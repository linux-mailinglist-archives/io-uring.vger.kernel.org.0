Return-Path: <io-uring+bounces-587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF30984E99F
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 21:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E19A1C2402F
	for <lists+io-uring@lfdr.de>; Thu,  8 Feb 2024 20:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D758383AC;
	Thu,  8 Feb 2024 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k1A7JWmi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D738DF2
	for <io-uring@vger.kernel.org>; Thu,  8 Feb 2024 20:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423762; cv=none; b=CD7hPWcg1fneFRjfYg8fBqg2gZDBiy79IFS5aSgskZHwNKOFmO+UA5V2RyBahHOS76USAPK1iYEwdKzePZ7OVoazbKrEo+gay4jDOXSG6bW/B/MJDo9GZZUgwDhQIVh9w4CDdI4lMNmExlEIzbSlDMDQj5ICnkwIJJ2XtIbry7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423762; c=relaxed/simple;
	bh=wMMbcoO0Jl1GQvD+Z9eroRXDu9YSlxQlyJPssFOLDn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CurwrfSwl/thH4ZQO7qX4Bq39QU/LTZtaUfGi9aNBzaCp5vBPzmjf+ixIvOStZabRKdPZFv/FU+2EH5OtTmU2L+W6rEdlsb8Ad8yhRUjKW024GMT+n/4wudTfT0UU9PRjVML73FKkR91FXou/F0OJ6DGKXhDCGKgHU72MFRmg58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k1A7JWmi; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so1901439f.0
        for <io-uring@vger.kernel.org>; Thu, 08 Feb 2024 12:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707423757; x=1708028557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jFzjfQqFhjx46QWGGtHda9G5kgJ79u2xo7E4qPTViu4=;
        b=k1A7JWmiKpEHzkK+9gWQhWNbUCc1ntqq0UmV2NLdGpVwP6XoQ4gm8gFqPtCKI7zw0y
         rtRmp/gjAJzKWxklonbEt7v2uo3Xlrt5vRAopkuBW4SgUOtstO4PzUx4u0my7nQ1KZLJ
         EHPynlyH84GWlI/rtEUMsuVkrgnVD/5VTv1hWz6UkVmMOaIjDH9z73E+prrXJXJciPIj
         CBkS0HM6alxIMrRjMxxAZIkmqRUey25+0cHZDl6k3Ppa/q2mQeTPLF9bJ9l644NTwSY0
         spDUhPrNoGA0vkxpG6gKh7cZulbQkEBVuFNFclv+w+09HXBJr68HpMI2S+VbAj04XzVI
         K9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707423757; x=1708028557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFzjfQqFhjx46QWGGtHda9G5kgJ79u2xo7E4qPTViu4=;
        b=hEOrrqkRIMBSIwWK0aY1A22iAyRUtDF4TnXJu0QU9oDqGVNuDtuLJGGr4hgbng8pCK
         Q5e/dR4xTUs2Ht3/zuZ9lL1SSQx0ZGIrfuiPah+HJts3rTv9Rft2GpttmH7GRhDj7yDx
         XE0TxAZfc3mO/Ytu8On4LdOxlEmhFqPGv2c9xLcQLBg4ZiYLZaf0jHfOY8ibODvdvFWj
         L7G094w8VzXKs33pJWGMr/Le7Wfm8wJjvSAuaGuxvE6T9W0nSHFISplSrNzYb2/pANFr
         FDuqdhvGg0dsBTd0FArkeFTGE6oTYUqPOGJKKL45zMcbNMXAV1qqv3s2XYLvBlFGjx42
         VO/w==
X-Gm-Message-State: AOJu0YwN/4J7vAbsBhTkvC3xvwa98hpZMUzakmOLZ9RDr/fAJOFwXwjK
	SMvZuWxFkdblFM1sRQjO1NzHhJ2xJOvflvQ+XU2OTQl5xko+HILCSoKw63b3pecGzK4XcqNR/Tz
	pPs8=
X-Google-Smtp-Source: AGHT+IFioD6m1+PdxgKz7Jiap4CsbkbYh23flEKVtObieFAZYGwR6gw10JW0EdbPnjilUJbBRwJ0cA==
X-Received: by 2002:a6b:6909:0:b0:7c4:655:6e05 with SMTP id e9-20020a6b6909000000b007c406556e05mr662492ioc.2.1707423757198;
        Thu, 08 Feb 2024 12:22:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d5-20020a02a485000000b0046f3b865e63sm28327jam.178.2024.02.08.12.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 12:22:36 -0800 (PST)
Message-ID: <098a9f8c-c5b7-402d-ac35-c48361a9d403@kernel.dk>
Date: Thu, 8 Feb 2024 13:22:35 -0700
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
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240207171941.1091453-1-axboe@kernel.dk>
 <20240207171941.1091453-2-axboe@kernel.dk>
 <87cyt6vhvm.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87cyt6vhvm.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/8/24 1:08 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> 
>> -	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, %s queue, work %p",
>> +	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%lx, %s queue, work %p",
>>  		__entry->ctx, __entry->req, __entry->user_data,
>> -		__get_str(op_str),
>> -		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
>> +		__get_str(op_str), (long) __entry->flags,
> 
> Hi Jens,
> 
> Minor, but on 32-bit kernel the cast is wrong since
> sizeof(long)==4. Afaik, io_uring still builds on 32-bit archs.
> 
> If you use (unsigned long long), it will be 64 bit anywhere.

Ah thanks, I'll make that edit.

>> @@ -2171,7 +2171,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>  	/* req is partially pre-initialised, see io_preinit_req() */
>>  	req->opcode = opcode = READ_ONCE(sqe->opcode);
>>  	/* same numerical values with corresponding REQ_F_*, safe to copy */
>> -	req->flags = sqe_flags = READ_ONCE(sqe->flags);
>> +	sqe_flags = READ_ONCE(sqe->flags);
> 
> Did you consider that READ_ONCE won't protect from load tearing the
> userspace value in 32-bit architectures? It builds silently, though, and
> I suspect it is mostly fine in the current code, but might become a bug
> eventually.

sqe->flags is just a byte, so no tearing is possible here. The only
thing that changed type is req->flags.

-- 
Jens Axboe


