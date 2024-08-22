Return-Path: <io-uring+bounces-2898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2466195BA11
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 17:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C183D1F239E2
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4549F18EAB;
	Thu, 22 Aug 2024 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lSVRF5IJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5C1CB15E
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724340472; cv=none; b=YOwUMHGG01W8MWnMXeIbMiMzYBgbEMcmOXsGBdDQNygDUnujsWeYSv4tMrFdD2l2xKEdUYU30y8ORNORCCjfsC7oRPVkHDJlZuTfFGQEtuv5AL9YkNzVaiqIpjolY/1pyuDYbkmGhoFiOGSRVu9pXdRJCLBYhuUYZBMWpNyh0Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724340472; c=relaxed/simple;
	bh=CLtBJe/V1fxPsOPagCa2+AaLvy/viZf60GONTiW5Ul4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OYvrxqfFABmzeR1m4v4ay2BNGaPpz+sMdjFnWCwT7axtvynSU5Gifhnwui/b/Y4OcOiPQHR0lJ2pvH8M6M0COEfuV65m32ZiVodliKTwJfiCx9HJTk+vGUD+/tyahmGd+GoMmrVratre78EuIWq5HsXLVLZA33HqNv7LjGaa7WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lSVRF5IJ; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-39d20c4be31so3218545ab.1
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724340467; x=1724945267; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DvcfzcDN+GbsuQF4HB/k2SKkNArYSCVe7D7j4FBcku0=;
        b=lSVRF5IJXid10dgFtEn8aMuq0vlpprtyQcbfhI9i20ZcY7L9xUXHeChto7pPswP77w
         p1opD8l6EFlaP8IZ7Rnv6X+fn1b9S9mbzpDpuTuccnziaTDbB7LERD4Mhk64amV4zzEz
         o/5in3nW73eh7fTRQ0hPd4QKlrsw0LzMO5hnXmhhrrx+kCAhlBMRkhK41umSJgmDjD9A
         HCwgVEbiogSl4tPmZnDPvqy6gAHTPTeD+7VP5agnRKCW+Y/O+4HGaSN7kqBc1IUYuvTe
         RnTWaOKC/bK9IiQHSFIB7N/XOAXAL46AN2dArYmHDVaLMQaxGb/1gxn8XGD6eCNb22At
         4UdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724340467; x=1724945267;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DvcfzcDN+GbsuQF4HB/k2SKkNArYSCVe7D7j4FBcku0=;
        b=N/ZVFE9BRO95Pet/D0PYxy/HvMCY0PQ6OgbvT6CdYzLHYA7PYQlrgttlQa9T2lFq+o
         io/re9FqXmkw5hK39oV1Dymdd/tY8LwTORMsCIed16HszFQm0eRX2vuJiXS0+qIpEH7Q
         ScL3gzs+UrmtdNRnqLNNTerPwMNNYXXiqML+qvQXNg8W0Srz6aXf4aq5P1Pz7rHF0slK
         2RAyHIT0WSsYBZq+8miQQH1UgbzZKEo7SQIq2pSAcRNlrOLDbQoxCDNiKQVakPO94RS8
         dND3q7uTrXsTIocIYJbBna/aLmpvQdWdLjKaR/WPn4gszaKFjbU8s5klEyYYVQhlhxEa
         oxsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMoekEPk37/mETjPyS69pqYe1fMcqLRK0GRAJ7CcohLNMLgjs3aSS4IwyvLKnEqoDOidGAnpipow==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc3WldQZAG8zImJCDkDPITBW3sgxwpLBlwaM6Yg7FlXVMQ007H
	uLpk6ovCcJ9rEz0q2XEKK0toLBZhTAOFMI1hWyNEzDBt+4Y1VUUYWR5NQVY0fqY=
X-Google-Smtp-Source: AGHT+IFuCNDcRJz1sDQbTERAE3NnQ5Vx6NJiNmXovM+jYX/nYEmvoJ7im7MZJxjDfOWz6CY75PZANQ==
X-Received: by 2002:a05:6e02:178c:b0:39b:2daf:1b82 with SMTP id e9e14a558f8ab-39d74b73e9fmr33183025ab.16.1724340467352;
        Thu, 22 Aug 2024 08:27:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d73e7cfc0sm7212815ab.49.2024.08.22.08.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 08:27:46 -0700 (PDT)
Message-ID: <7a198254-780b-4d1f-9a0b-27780c3373e4@kernel.dk>
Date: Thu, 22 Aug 2024 09:27:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-4-axboe@kernel.dk>
 <00ce2394-03e2-4769-bc55-8affdc578bd1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00ce2394-03e2-4769-bc55-8affdc578bd1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/22/24 7:22 AM, Pavel Begunkov wrote:
> On 8/21/24 15:16, Jens Axboe wrote:
>> In preparation for having two distinct timeouts and avoid waking the
>> task if we don't need to.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/io_uring.c | 37 ++++++++++++++++++++++++++++++++-----
>>   io_uring/io_uring.h |  2 ++
>>   2 files changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 9e2b8d4c05db..4ba5292137c3 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>        * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>        * the task, and the next invocation will do it.
>>        */
>> -    if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>> +    if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
> 
> Shouldn't be needed. If the timer fires, it should wake the task,
> and the task will check ->hit_timeout there and later remove the
> itself from the waitqueue.

Good point indeed, I'll kill it.

-- 
Jens Axboe


