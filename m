Return-Path: <io-uring+bounces-4000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8B99AEF6E
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25C821C21C7B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA691FBF50;
	Thu, 24 Oct 2024 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9ZQU5lX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2111FAF01
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793551; cv=none; b=LTSG7hxeElHqb82F2SBKPqhujfEgldha5ZlszC9g5/IzSa/eyseoTeoyIXjuCpu4HgQDpNDzdQE3GxlryGLI1GKUerWo/VMSG7HfklKS+ZyATZM0oHbfEl70Tqz0oUPz/wAiRx2xovKI0sWRhlXfGlvLfV54k3C/HNfSzOLPT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793551; c=relaxed/simple;
	bh=Q+Bw7hQONj+Dbs5SIHh2Y4cSVQlwh5y0/u6+D2VWqmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OHR4Gp0SZ5/KehyaAAnmy9ue9sLNTPFaTJNiMdFehxCOzVkuHen8flSFX0rQzFHVBnSqLfUmN//E4bluapKjWWIMAdfeRKRq+mcbu0m4g0+vSkU+2IQ0Ys+MbokYwM1oCOPXRQflaIJe9xu7/KcsUrR5rbMCAXANaWQSSStVmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9ZQU5lX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so1464100a12.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 11:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793548; x=1730398348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hrv+VJZS/Ks1U0fLfzI3RLhVyIouJtfRh+hn+/6kUeA=;
        b=i9ZQU5lXn3AnK6ZnbLwaOhcn5BTfwscmmerHbl3vJRAmkp3XLKYV+x9pVKuv4ZYgfH
         9wL1XHxLz4D1VQFlUh1So7sqiSL3SkYx29kGuR4ESZs5avNyoIDtHQlPbdWij1MktQ2u
         B3vr4H8rE0R0+W+fcqIRBx5sjDiRgT0hDfG3QxkYECnxSCI3S1KWt4TNR6G0Uq8aVEC0
         CIa1sREeL0dTgmDnHyp2py5r2kh/Q3cgMEvczSacvwsuyMUggJAjW9G0Hqr/cSGj7Hl0
         5QEG7+pENgtwVevw2X5x/oWxK8I6HXqnjn1vVwQaF4yGixe0Z9Pz1dki72W2CaGoIQSi
         NV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793548; x=1730398348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hrv+VJZS/Ks1U0fLfzI3RLhVyIouJtfRh+hn+/6kUeA=;
        b=rvLuRO5UaYPeC7wlprpNTTmTs3bqyehhbd/82YWKXXG16k29kF2FT2LFejonPgQlwO
         BIGZFYsQiNibaZDgp1QkdmEvnPIBdf1zB8HSPwFIKAvNvcLywCvsUnSiKH7ha8oNg8/G
         eEVb5cd81H1fCkly2C+YDoaOGZSEWdxwEMT5wWS/J76FAqpGAfIbLFynEsOEiyTfmRmP
         qS1qrVS5qDvXAE7qLDWt35we5EjDhLA86w4dURsNEb4ZBFBRnm4vyU5ttzD3DmBD38XY
         Lf3asG/08/sjwgpG0MYzbyd1XVtDaszA9WThbNOu8xBwMVtVtFF+sLJlk7ahLpqVUn7s
         xWhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsfdP5jzNA7b9B7EVJn4nqsKPYUWnrv6AjKNvYVf1HA2155ukzxX5cRHxc9oHXJv7zYlzYcf9TuA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yymn/nRpbD/B6lI1c506EZJyOF2CQsolpvLZgsP/F68aL2Kgcy+
	1LrNk7/9rVaWPqTlCoJsw2xbjod2dvobncKuTLnFI0JV8IgQEJzMofOI0A==
X-Google-Smtp-Source: AGHT+IGc54G9dGH8gu4y5e0hYxrmBZ4pgi5N67K8h1fTcAm1QozfjfWMf5NDugjwp5dSzIVkhaABjw==
X-Received: by 2002:a05:6402:3810:b0:5cb:ad37:4f60 with SMTP id 4fb4d7f45d1cf-5cbad37540amr374256a12.26.1729793547873;
        Thu, 24 Oct 2024 11:12:27 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b4f5sm5983713a12.7.2024.10.24.11.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 11:12:27 -0700 (PDT)
Message-ID: <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
Date: Thu, 24 Oct 2024 19:13:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
 <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 19:00, Jens Axboe wrote:
> On 10/24/24 11:56 AM, Pavel Begunkov wrote:
>> On 10/24/24 18:19, Jens Axboe wrote:
>>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>>> On 10/24/24 16:45, Jens Axboe wrote:
...>>>> Seems like you're agreeing but then stating the opposite, there
>>>> is some confusion. I'm saying that IMHO the right API wise way
>>>> is resolving an imu at issue time, just like it's done for fixed
>>>> files, and what your recent series did for send zc.
>>>
>>> Yeah early morning confusion I guess. And I do agree in principle,
>>> though for registered buffers, those have to be registered upfront
>>> anyway, so no confusion possible with prep vs issue there. For provided
>>> buffers, it only matters for the legacy ones, which generally should not
>>> be used. Doesn't change the fact that you're technically correct, the
>>> right time to resolve them would be at issue time.
>>
>> I'm talking about sendmsg with iovec. Registered buffers should
>> be registered upfront, that's right, but iovec should be copied
>> at prep, and finally resolved into bvecs incl the imu/buffer lookup
>> at the issue time. And those are two different points in time,
>> maybe because of links, draining or anything else. And if they
>> should be at different moments, there is no way to do it while
>> copying iovec.
> 
> Oh I totally follow, the incremental approach would only work if it can
> be done at prep time. If at issue time, then it has to turn an existing
> iovec array into the appropriate bvec array. And that's where you'd have
> to do some clever bits to avoid holding both a full bvec and iovec array
> in memory, which would be pretty wasteful/inefficient. If done at issue

Why would it be wasteful and inefficient? No more than jumping
though that incremental infra for each chunk, doubling the size
of the array / reallocating / memcpy'ing it, instead of a tight
loop doing the entire conversion.

> time, then there's no way around a second iteration :/
> 

-- 
Pavel Begunkov

