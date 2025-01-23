Return-Path: <io-uring+bounces-6088-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8055DA1A64F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:54:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7705B18892A1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5875F20F971;
	Thu, 23 Jan 2025 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TbPJSC2k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193D38B
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644058; cv=none; b=uVNriyqrugx2Gqj+TS3hKPJNpK8SaVexnw8YfyWouzsPeVd1zoxYX6yCbr/oSSmudkttGgV+P7+YNVWKgcG2tdvBKmYh8n8Zq3f6X0hh6Rc7+lgVPOMopLxE0husU7ZfzuEzMj/R5A1Bpq8F+4gGOaW/DXbtbuBC5jtNVeEk+g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644058; c=relaxed/simple;
	bh=M4lTLg7+6NCJXD9JUcrYPwKDA5U9mlkboPyaH+ZE65E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWUaX5fwuNlvPeXe+VdclS+G7kSytyr99G6Q5Itlnyh1rAYlUwRXmkahO6CAGrvczGF3fMB6paooxXOheKy5ENlyw7kJ2gT4rs81HrtmtSXvYMg0IL+QqAuUZrQeEZ+G1IfU6kRaoDsKPX8/JUwdIIYGDJ9g4/29Gim00T8dHVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TbPJSC2k; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ce873818a3so8346465ab.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737644054; x=1738248854; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8hj4Gcqkqium/Nt7dhku3mFqlrTo3vUq8i/35lf57CM=;
        b=TbPJSC2komk5LL8GSh42ixhyg2I/AWVje0kSFsMwig2O4Os/CCYXGzi00+43tP2eHl
         8qG1AWbKJWC988U8A2HquVSXau21CtQDsaaPJD9TYxnwB4XSutxjc22/1XFzhv6e0u3o
         y3qiUJ1amtoj/rttBSNGSQnnoNUHnQhWaEFqQRZGf1M4/p/u7xo8wT9/owbCp4n22n/V
         zfUMOxZ2gH/TRAo+woTFbPa9pafqDKLeVAMhlkDNng3HSV22G9wudywFfPjquQ3qDS5z
         kxRVLGvMPfZEakqaDl6N5cxYgKXDondvn+RbCa2+0iP/wIDTT3EiW9LcGibYO7KuB20Y
         JnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644054; x=1738248854;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8hj4Gcqkqium/Nt7dhku3mFqlrTo3vUq8i/35lf57CM=;
        b=hfg2/Ppf9HNzIodwwmOjEvxelshI/AUpwOyjQKcA9xXst125/1u1k+O5G4C145YnKM
         Mgl0NaUYLI33pTuJJCA8sT7P7ENkRCwQ5tSdpBbjwm93PACeGf4Fui81INXLi0U6qTGr
         mdtvJYPmwpF+fOQKEdFGc3wlXFxiRAt7wQ95K2ji1TNbMOatKDLbh54dv4bwG6HwGaRe
         PuRqLy4T6FWN2S+oYAu4ydYrNvZi5C3XH1fEaGJnrbS5myojyWC0vePbzS+OMjTXdyHz
         91KEH4jLamxng1HS8fNLFN25m02ZHlzSyvwyZt647fum5gu67wRnxyW6Uy9uOU83I9S3
         Qu9A==
X-Forwarded-Encrypted: i=1; AJvYcCUpWxjES1ak8XHQr8HSX+rUhcIyfF7iRKMj3AxjfFgvnWOZiClBA1BgEVOFgMs66xE1KDOiYhxe6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUusReBFRdsLDthGclzSpwdooaUshgXoN34/vsZJazWDHpnOXU
	lELyN6Q6gFoksg4hdeWdA5gPDheh7ZAR+DcjSdmpo+AqIzvCmMxuzTe0jin1O4l3dEsgRtB7gGM
	E
X-Gm-Gg: ASbGncs8/4En1m79+WFM7+8djQ/ykmoLoft30tnlczDRWOtnb+dxv4SHrACWilcfJ6f
	qXxdA7zAymrBtjuVUzYPnC0g6dS1HmA55RXWMKG8Mz+0fkfPAY6tGN+xxuW4LYZHt209GRh5dFR
	bV/8pMEagqgfxuqZ102J7dWU1+Hw0nUTbWrJFmBhKJkcUvt1/JaIQke8R5mhICeD2P90XFi+iwM
	GApaYLMyoolgl+OFfMw6hxbyV7L+7ZxwhCSzSAB2T7Xq+iwD9agdpIonka6G+ydO+aelepCtqrJ
X-Google-Smtp-Source: AGHT+IF8giI8A97pN04pGTUYNHrqYDIzRmtQDvJBZz9IsX/J3BcVgtdXtFpEZjTS5Vu3q9sQtetljw==
X-Received: by 2002:a05:6e02:1c23:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3cf744905d8mr221612215ab.14.1737644054062;
        Thu, 23 Jan 2025 06:54:14 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71a764efsm42848305ab.12.2025.01.23.06.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:54:13 -0800 (PST)
Message-ID: <832dd761-32ad-4b7e-8d6b-1fae9caf5a83@kernel.dk>
Date: Thu, 23 Jan 2025 07:54:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/uring_cmd: cleanup struct io_uring_cmd_data
 layout
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-2-axboe@kernel.dk>
 <914661c1-4718-4637-ab2b-6aa5af675d23@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <914661c1-4718-4637-ab2b-6aa5af675d23@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 7:38 AM, Pavel Begunkov wrote:
> On 1/23/25 14:21, Jens Axboe wrote:
>> A few spots in uring_cmd assume that the SQEs copied are always at the
>> start of the structure, and hence mix req->async_data and the struct
>> itself.
>>
>> Clean that up and use the proper indices.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/uring_cmd.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 3993c9339ac7..6a63ec4b5445 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>           return 0;
>>       }
>>   -    memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
>> -    ioucmd->sqe = req->async_data;
>> +    memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
>> +    ioucmd->sqe = cache->sqes;
>>       return 0;
>>   }
>>   @@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>           struct io_uring_cmd_data *cache = req->async_data;
>>             if (ioucmd->sqe != (void *) cache)
>> -            memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
>> +            memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
> 
> 3347fa658a1b ("io_uring/cmd: add per-op data to struct io_uring_cmd_data")
> 
> IIUC the patch above is queued for 6.14, and with that this patch
> looks like a fix? At least it feels pretty dangerous without.

It's not a fix, the sqes are first in the struct even with that patch.
So I'd consider it a cleanup. In any case, targeting 6.14 for these
alloc cache cleanups as it got introduced there as well.

-- 
Jens Axboe

