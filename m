Return-Path: <io-uring+bounces-6286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B88AA2AABA
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 15:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C64A16080F
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2025 14:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5B41C7010;
	Thu,  6 Feb 2025 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hshrcueh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3441C6FF9
	for <io-uring@vger.kernel.org>; Thu,  6 Feb 2025 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738850868; cv=none; b=d8fUIV+Qt0sdejGN03Qi/6Zc4sW+4jQPvxp/dIVmUbCVjhVCkd0o25/4P2kkgrxFBVXWZ6mROu/X85wtMJxoQG0UW7fPabnWe1mZTbkYAZnLXfE0jTB8A2y8MsFLboHj0ZOM8Zg0/jYdVeCnPnQx7cIX2MY2XZFjVuVJGu/mCr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738850868; c=relaxed/simple;
	bh=tOudQq/qQlc1o7PWoEIftOqbFngzjGvRdf3mWIgN8sA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRWvDt5RRdfPi3uGIGDwSvZxub6V3+WRPEG1tADTAEN/vLLiT25UEMqUpaq8+RUv/UboEQUkpTpfnrAVpvivYDZraCOu2vjjv8s5nVwjZUHtLqIFnpZSfvtJ6ZJCCTC2LlvxzS9gf6/DObO4n6rPCyBkENiuSgdPZllwprbDZhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hshrcueh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-84cdacbc373so30114739f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2025 06:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738850863; x=1739455663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O4Yj0d3H8QL3yCi7nyuyFBuf5ec+MQo5lXNozgw4FEI=;
        b=hshrcuehtE8REf5xGRUxtKYYjyY5ln0r5TOT+DglwphDMDJkHCOvsYX3oDJYbD+2+Q
         FdPN67tiIisJRhs8ioUTBCIYva9dcbV7a5SehKuZsoI+UVmmLJRyDfYf2ddjwk7tJWv3
         +HVl8XwXzAvvx2AnKdHCDfnmPMXLcVLxhKzzhvNk5pCLXtM8T3nnH9OdsiG8fmk3Jo0l
         xJ9if621MlgBGxxIu7Vh+woA1OEQLzNavUAH1WYw45bz1FhLSj2TN3GdAIA6cTikkksX
         /QAx7G0nhWNLOud3NB7tiutUKncHToXOYgRhebDyfJA+fY7J6IXtZCAze8v82QaRJdYx
         +OZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738850863; x=1739455663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4Yj0d3H8QL3yCi7nyuyFBuf5ec+MQo5lXNozgw4FEI=;
        b=Ny5KtxJRoWHGcWTZkHY+gT3TS2NQn7haydsxH0j9T18rwdYwqf6kWWfOTvvbO5y6Qx
         G5lv3BMNazgiz7uWvxbWV5wthLUQeP957TQQ4ks4MmxHTPYksfbEZB62hPN1tbIO36xB
         IDr3aZWGYP3EJT9Xe9g4+uyPi3epNKJ6CrvYovtbE2LNsN5xvJNeunGzMC/WKVT9QJrk
         MgbCmxrU0ekVeSuNYWFlUdMfKku8+YWKOVaIFS6IAydo2TduFrLCCiQ2q7mFPcX8oo5Z
         Tg5cBb7H0fBoshv5GafB0K/CnNRrr6s5uIShdCr+JupW4tlPA8pCWqVIlrVF0XPDAqE0
         yJfg==
X-Gm-Message-State: AOJu0YzjRRkaAv1Va4f8LMHH79xSrzaa6BkSCiFHlHqKtF8GF0zu2Gus
	nbk/p1/nge6t/LERzBcYn5/6AGLn/UHj+AbxcYZiWKT2foOotzPO52majOAwXbo=
X-Gm-Gg: ASbGnctaIdjr1GefAJlzDfSptaWkbdNc5+CNdaXBmbYITxCrHEJKi9koe8MxpIQWyqt
	wBBco+oDK6v4p8u4aMlZnZuFs458Hep83yYTJVkuEMoG+puT/Yk6RpvKMqhLJ2tq8BUq7JhZyVh
	MZUZVJ0zhdELlhrWuw0Fx6LYr8JC1O+Yo6VnI/qjO9CBKKrb90BQ1Z0NJvS0iU2fdBLqgF916rn
	+6Occ9B8MPNq2+iPn/eVOretT346HrHxp2TK45snYMNRiu57JsOobLTvYwMSpx3whiotsnrT/b6
	DgnBAPsjy+g=
X-Google-Smtp-Source: AGHT+IGgdua/wtJt5ycoAx8vmrteBESRh/5EhCdex08ZmgXc4MBcWUSy4aqadZC9n6U5h8SYaBidNw==
X-Received: by 2002:a05:6602:3791:b0:835:4931:b110 with SMTP id ca18e2360f4ac-854ea433c31mr719215239f.5.1738850863091;
        Thu, 06 Feb 2025 06:07:43 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccf9df8dasm264602173.39.2025.02.06.06.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:07:42 -0800 (PST)
Message-ID: <45cbcbe2-ed8c-4684-940f-fadc1d0a21b9@kernel.dk>
Date: Thu, 6 Feb 2025 07:07:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
To: lizetao <lizetao1@huawei.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250205202641.646812-1-axboe@kernel.dk>
 <20250205202641.646812-2-axboe@kernel.dk>
 <689a799d20e048f8a42ab2e927493279@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <689a799d20e048f8a42ab2e927493279@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/25 5:46 AM, lizetao wrote:
> 
> 
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Thursday, February 6, 2025 4:26 AM
>> To: io-uring@vger.kernel.org
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Subject: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
>>
>> Any opcode that is cancelable ends up defining its own remove all helper, which
>> iterates the pending list and cancels matches. Add a generic helper for it, which
>> can be used by them.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/cancel.c | 20 ++++++++++++++++++++  io_uring/cancel.h |  4 ++++
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c index
>> 484193567839..0565dc0d7611 100644
>> --- a/io_uring/cancel.c
>> +++ b/io_uring/cancel.c
>> @@ -341,3 +341,23 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user
>> *arg)
>>  		fput(file);
>>  	return ret;
>>  }
>> +
>> +bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
>> +			  struct hlist_head *list, bool cancel_all,
>> +			  bool (*cancel)(struct io_kiocb *)) {
>> +	struct hlist_node *tmp;
>> +	struct io_kiocb *req;
>> +	bool found = false;
>> +
>> +	lockdep_assert_held(&ctx->uring_lock);
>> +
>> +	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
>> +		if (!io_match_task_safe(req, tctx, cancel_all))
>> +			continue;
> 
> Should call hlist_del_init(&req->hash_node) here, just like the
> original code logic.

Indeed, good catch! I'll make the change.

-- 
Jens Axboe

