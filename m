Return-Path: <io-uring+bounces-2857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77538959057
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:14:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32C7A2822C2
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6BE1C68BB;
	Tue, 20 Aug 2024 22:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="U+g62lIK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E6614D444
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192094; cv=none; b=jxKCD5oFf4SO9hXHiGYynJlx7JZ9i6Ct7pq0s/hpSznVfGs64DysK6XJKx5ode6OXvRb7bLuywRqkO+UbfA/ybJm61VyP+BS3UnVql/TUM92xXYGJX/XsU7t9WG2VUfVT1bVxhLxfUPQIg48dYEVwrbxrIA9gjCWq53OqwZC2bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192094; c=relaxed/simple;
	bh=Q6VbGEb14DeHWokBfoPqiEV6PQkTdYS6XKVuYZQ165c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FqEyb3J82fsJOfAgcgRmq+zDgmUg4w5L9WsFFCE4xrkl9pI9CqL43EaXxfN2Cpwiuxv9fEbb3zZhRKBZwCQtPctl67/gQVHDjZ5Jb4JEhdhNzQkNv9PYJ+WFqMwQo9W0wAfxZUtOfdpoxKXIaHeP3xB3nxtC3fdD8MaQA85sN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=U+g62lIK; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2d3dc25b1b5so3614141a91.2
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724192093; x=1724796893; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9rgxCDdsAuCU4ovOE1XioTFEMPjdu87dODVSkSAbRog=;
        b=U+g62lIKXxRvxRbRAhQy+Rpe2YJgyawR2M5Zit4l+/+JV1x6ZtAn18vSG9qLiLp+U5
         iAnM8CulIH87n6ZxPdFjH7YZwwwjdyChQfMA9/IZCRQt6jwMhoghRXxSNRXJv/oW5kmC
         v3YFcw/sGpGx5mI/OF1UQhtfqwViBDJ9662PoyrjpktNu8MQ0i8x/oxFjpX2DA9BRTbo
         2SjZeQ3J+Gy89Qgb9TesQR2pK7zVDnbsaRBxaGj0HslgCMN+PlszBMbfEyBQ6s2xHLOH
         8nO66Nv1aKDBZFpBepEtdRALi7WwDiQnmdr+ChCT9bPjz522Fh1kM5W7H3l59zoCzBKc
         cxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724192093; x=1724796893;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rgxCDdsAuCU4ovOE1XioTFEMPjdu87dODVSkSAbRog=;
        b=eFmOajGVl0/Dau+7H9o+lvpjwAF+92nisfR4hav41ue7Mchf1o7YhxBGhRVSLWoAFe
         0Rr4YaYDtIz68zJ6OatZUyxhpb1sa/hjCfUSUtuYWfPTdaUiesA4YJ29JV4nog6gpuQx
         HRMjzK0cq8EShjMG1OyeNlnx9rCVpVDvd8Gd6Bu5/CsY48O4KyMPBDi4SOyqf68XBRRH
         T8IbU/+NVvrGEVitbuZY9o5gru1/OkhYMGXHTt11S0elI/90vlNcuNdqkMHvDoTZMLCZ
         pE34C9DrQOs9f3UV3pZvldqkKDdA3zBhHotPvhmAd3cKuVb0Z+qphhk8tqCDnT5f7O1m
         z9bw==
X-Forwarded-Encrypted: i=1; AJvYcCVbbm+J7GeXYdCBSe3kb1NqXN+qMhM9OgDd866Et/bsX7uKnOaYsoR4zIwCmtcjdARyy1V3LVvuhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEiMHPvmwK85ej3yiNGfA5PYQ4fGsMCn42BLV7NcDQ2NacSIrz
	sKuxLA3iF7hjWK3dNEYXTfBfHT1a2AkOkKHfHHQWhmwSZXeasrfHOCwh+y2Fq40=
X-Google-Smtp-Source: AGHT+IG+eF/nqQrhEczskwbN+C79+UNEEAlqxzFj+NjZkfdS9wD7Jr30OTDkAhEgKNtiWIxrpSfQnA==
X-Received: by 2002:a17:90b:1643:b0:2cf:5e34:f1e4 with SMTP id 98e67ed59e1d1-2d5e99f2834mr509259a91.13.1724192092517;
        Tue, 20 Aug 2024 15:14:52 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5ebbb009bsm113000a91.41.2024.08.20.15.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:14:52 -0700 (PDT)
Message-ID: <344d1781-0004-4623-9eb4-2c2f479267f4@davidwei.uk>
Date: Tue, 20 Aug 2024 15:14:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
 <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
 <4b0ed07b-1cb0-4564-9d13-44a7e6680190@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <4b0ed07b-1cb0-4564-9d13-44a7e6680190@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-20 15:13, Pavel Begunkov wrote:
>>>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>> To rephase the question, why is the original code calling
>>>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>>>> between defer taskrun and not?
>>>
>>> Because that part is the same, the task schedules out and goes to sleep.
>>> That has always been the same regardless of how the ring is setup. Only
>>> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
>>> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
>>> manually.
>>>
>>
>> io_cqring_timer_wakeup() is the timer expired callback which calls
>> wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.
>>
>> The original code calling schedule_hrtimeout_range_clock() uses
>> hrtimer_sleeper instead, which has a default timer expired callback set
>> to hrtimer_wakeup().
>>
>> hrtimer_wakeup() only calls wake_up_process().
>>
>> My question is: why this asymmetry? Why does the new custom callback
>> require io_cqring_wake()?
> 
> That's what I'm saying, it doesn't need and doesn't really want it.
> From the correctness point of view, it's ok since we wake up a
> (unnecessarily) larger set of tasks.
> 

Yeah your explanation that came in while I was writing the email
answered it, thanks Pavel.

