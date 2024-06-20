Return-Path: <io-uring+bounces-2286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D522E91018B
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A2CE2826B3
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 10:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8224D17CA1B;
	Thu, 20 Jun 2024 10:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eIV/D/sf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86702594
	for <io-uring@vger.kernel.org>; Thu, 20 Jun 2024 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718879739; cv=none; b=W1cGaFqfBetIQSABZFHZo6qEtAUG9rJqdQgPGxpCLRl+iKg7aq20Q42/4gmjm7o2PS7pELh8Gsu8ocBhuvUmqI5Uf95H6ITpRIicHkYZBbNDYap3k2XT5rLf9YsayEqDN32WZJAEUi40UPG7nVa+LKZrsGEfz+Yt30nKmZPZrRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718879739; c=relaxed/simple;
	bh=13yi8/6IF1P/Hzgp4fCl0MKxpbGClzeQbn5J6U3EpNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TOyU47mfNsrewb418qzzMi99VMdgxhNeTmpmlri2bwG9obXRLyBoicLNIlV6y2ubdF56twGVhnlo1zscEucxAQjb8fYk5R1xSu5OMuD9RdBc0oEhln5b0YyuERxpwfQIALApzL5mdvoIAbsm6ZC8Bq1O9uqjhTZZmqIAuHRN0h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eIV/D/sf; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4217dbeb4caso6894205e9.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jun 2024 03:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718879736; x=1719484536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UETTkeH+zQkMe/QrapPb4SQriiVVbFbLUFi/stPRFWI=;
        b=eIV/D/sfnMwrAT9LB4z/neyx++CmQBJA5C6co0TjYpUsH30coHvvohYN9M4erp/pTe
         6Yv/bqe/bz2/788fKTKo7CVIBaR1l/lCCRYXgSCWIdmVNK6YymeVg3dUQwSfwK/6fV/H
         dHrHgTlemaOyx2TULFiryRL6BqWOsGM2DW640CX4Yj2TtNVvG3OmK6RkndUzZZ0jAB3i
         qhg2vHqA/XFAMUMFcq76vbu5WQpCTopQdrMlU0zvSMkkYZR7z0j4Kk9l/F9Trpi+6SZe
         5mAFY0LFFsG7eP0ZPQYp0HCeET/h+S2hVAbzK5oSo/M7u96wcf94gGjCXncXwiakzf59
         RXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718879736; x=1719484536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UETTkeH+zQkMe/QrapPb4SQriiVVbFbLUFi/stPRFWI=;
        b=w5XTRMu3AJxY6T5KcBtXtWciwfXhtSI8NAag+O8lKs11VAPs15NlEfYmiRpj59wnF7
         1FtRl2CV4RT6P+4NSxFMzUvDXw3Y0HccE4SagplhC5FmcbzNhmuRc9GFpAYA8e4GfCAx
         i0btXt0Y0aweNmJ3MBF8pYkNitM9Iem6gmbXnza/fJ1lEa7Q9SjtiL3PR13ZmRjIOBoL
         HEI2uogVFIM0D99OrNl+VxNq9H9K5ThdKOQoZbSXPF5lh/OP+PDsBprzLMTwb5Jy825P
         EWyP1EiDPf6hyElCBbJy8/lmuKpewycWiXVSII4nyzseU1q6ylW3LDlrT1nJFPjifcoI
         kbyw==
X-Gm-Message-State: AOJu0Yxk5XzvlmYQMRTru2B+l/MYR1ZIg5VetqekwPXiu0l3yp32Ml/b
	Hv9MaPPqLEzjNMeneoU1m1pZsSttHsv8gdXCEl9CI6H9VLWlg6gn
X-Google-Smtp-Source: AGHT+IFCze3P71XeMq/HwLgdD5zfB+N4DPDVOJAvz7vFb80Akhald3CFN3halIsKmOKZpwTtrG5OMw==
X-Received: by 2002:a05:600c:4651:b0:423:6957:89bd with SMTP id 5b1f17b1804b1-424751749e9mr35484345e9.12.1718879735884;
        Thu, 20 Jun 2024 03:35:35 -0700 (PDT)
Received: from [192.168.42.105] (82-132-223-223.dab.02.net. [82.132.223.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-363e110ea83sm3354136f8f.113.2024.06.20.03.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 03:35:35 -0700 (PDT)
Message-ID: <d3592023-281c-445a-b418-49552ff1249d@gmail.com>
Date: Thu, 20 Jun 2024 11:35:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix incorrect assignment of iter->nr_segs
 in io_import_fixed
To: Chenliang Li <lcljoric@gmail.com>, Chenliang Li
 <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20240619063825epcas5p26224fc244b0ff14899731dea6d5a674b@epcas5p2.samsung.com>
 <20240619063819.2445-1-cliang01.li@samsung.com>
 <b51fe1ca-5a3f-46e1-a33e-a3c91ce9ad6c@gmail.com>
 <05758c01-265e-4567-8f68-8fbafec1631a@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <05758c01-265e-4567-8f68-8fbafec1631a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/19/24 16:47, Chenliang Li wrote:
> 
> 在 2024/6/19 22:27, Pavel Begunkov 写道:
>> On 6/19/24 07:38, Chenliang Li wrote:
>>> In io_import_fixed when advancing the iter within the first bvec, the
>>> iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
>>> bvecs, plus we don't need to adjust it here, so just remove it.
>>
>> Good catch, quite old. It's our luck that bvec iteration
>> honours the length and doesn't step outside of the first entry.
>>
>>> Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
>>> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
>>> ---
>>>   io_uring/rsrc.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 60c00144471a..a860516bf448 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -1049,7 +1049,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>>>                * branch doesn't expect non PAGE_SIZE'd chunks.
>>>                */
>>>               iter->bvec = bvec;
>>> -            iter->nr_segs = bvec->bv_len;
>>
>> iter->nr_segs = 1, please
> Why 1? There could be multiple bvecs.

You're right

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

