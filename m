Return-Path: <io-uring+bounces-929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99E087B313
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 848D4287777
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E307225AF;
	Wed, 13 Mar 2024 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvMeYDXN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E0520DDB
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710363420; cv=none; b=Y4MTvxT/j91I0K0/a+LeSrMhz7v3XxdvMSq/A6qtFzxuWHgTC3F9swM4eONI07YoUzBMkLl7OsnxXMTisl1MIbDw+pRLLCr61FWoV2ZtgCjOIza4O+9vDej2hqaWTboup4FUsH5jQLYkAa/9Am8Wi5z17DKcZ4qpcavZC5CFeYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710363420; c=relaxed/simple;
	bh=5zonFmIVdEdEEK7wCn1wPr+sgHFHVdvoz5aLqIfpRsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R2BYJeZ1fwZ9ciQOkzbqhNflPS0yhBs+3drS4QWV2H3gyXFPGqKXKUMkxLg021L8njS95TxECIW6bM+FhE6i+3eCL6bRzYDL4od2O3659AxQ/a3qj1BzB+8TDwgpPgUMcoo473YyFkrrK+no2SUYdGiF88nMp7JAaH1H43ZQgbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvMeYDXN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5685d46b199so397251a12.3
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710363417; x=1710968217; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cezbE8YARFDhiDtrZopN/deedx9KKe+ZDpTxyyNkFPs=;
        b=NvMeYDXNkrqe5Qb1hB/a55bgVuyefjiiuGPAO3JKS/Yn2Wi84KFmadukUhvs5mF4ml
         9niuOvQVoWkqUNbX+CPH5fMJ+ojPzPtxoU6HbhzcpkhFoqeQSMMbtkDAy5IeZ6rpPz5P
         MJp+jlk13+iygtl9w9ExkMBVrHHpKmjcqG6FJ2IFLHZ19zwDH8hSAn3h2z6h4OGh7VGV
         G6wwe0iscfcABQroSrvGJMXXWsnVMRHS7YJWxX3IcqcbYH0o1212bweIGP/0ffCjOTCl
         qB5wPXDnxwobHcs1wCEvG9N/m8s3VG+5fBRIVNeyZvY9noasTkCjAqNJtmo8IkrWXh5M
         xZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710363417; x=1710968217;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cezbE8YARFDhiDtrZopN/deedx9KKe+ZDpTxyyNkFPs=;
        b=FT0QM8pZFolIdLkwVf4G/TF3KetJWfpebRRKyKcYbWRsmmq/7X4AAgyaYSuLOZVptx
         O3Hnb1EU4rBVLfaXM/M/5XTg+T4pF4ejOGNyGF1q+rnq5/dl/G5vzarBo9zm3oozCr0t
         8/0zJY0l1K+7A/qn3OXO74XL6j8SqkTc2URlqQz7lEe4cAOdKNyKOTSLJkloPDabk0uU
         wPJltlLIYeQHaSRxk+wGaabaYHlcg6pbyR5W0bWhOn9UvafdJJQxFwUyCY8B31i2xSl4
         6EWRzcAv/ngAxlvvt4GConTYC2q+kLkQp7D1U70PSkAsiv7Lilqea61yVDfDnpIT5xuT
         J+Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVvcjlQQSEUspo3Zk3pGJRPjvaxG6bcuIrN8vgkQDXc0WAvefTFAFQDkxEsV5ggVZUOYv7NhvpfoTIJbGECED7Ola6A0raKTS0=
X-Gm-Message-State: AOJu0Yw6GijkuJckXAyTTAluU7kBS0du7lEjB9UfUl+L4/w7sxwstBaz
	BmNXax/b2tM0tnhjVq7PStHbU5qUCgIANJwP2K7Lj/LoNEwK0NnX
X-Google-Smtp-Source: AGHT+IFF0P7cgix2MSpoN5tEEHEHNZw9Wj6tVw1xvMM9lAAWCWTlChCR/QyFa5cbnzJ+Dn/sGwMVNg==
X-Received: by 2002:a17:906:3ac9:b0:a46:2874:ecd5 with SMTP id z9-20020a1709063ac900b00a462874ecd5mr5444572ejd.55.1710363416568;
        Wed, 13 Mar 2024 13:56:56 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.134])
        by smtp.gmail.com with ESMTPSA id jo26-20020a170906f6da00b00a45f63d2959sm6510ejb.210.2024.03.13.13.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 13:56:56 -0700 (PDT)
Message-ID: <c089d416-f5f4-46d4-8e6f-9ea773d44c20@gmail.com>
Date: Wed, 13 Mar 2024 20:43:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1710343154.git.asml.silence@gmail.com>
 <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
 <af4cc4db-b8f4-445a-9ed8-f2eee203eee3@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <af4cc4db-b8f4-445a-9ed8-f2eee203eee3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/24 20:50, Jens Axboe wrote:
> On 3/13/24 9:52 AM, Pavel Begunkov wrote:
>> io_mem_alloc() returns a pointer on success and a pointer-encoded error
>> otherwise. However, it can only fail with -ENOMEM, just return NULL on
>> failure. PTR_ERR is usually pretty error prone.
> 
> I take that back, this is buggy - the io_rings_map() and friends return
> an error pointer. So better to keep it consistent. Dropped this one.
Oh crap, you're right. Did something trigger it? Because tests
are suspiciously silent, I'd assume it's not really tested,
e.g. passing misaligned uptr

-- 
Pavel Begunkov

