Return-Path: <io-uring+bounces-11619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D16D1B16F
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 20:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3932F3002877
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A48E036AB65;
	Tue, 13 Jan 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIVkepfR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2904035E527
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768333471; cv=none; b=L6XIyC+62C/pGsPCEgev9dCL8XLyrPY4vZAjMXWA1Dlil+ZcKCNFsBAUCbR8D0DsXnDx9CwuDAQBBubzU9Xe51xGUWsdS+MFUl0noCWfvozNN6S5sNvwJJ8n4MJX6sUykdGBvUnFRA9SkX91mV7P/PyzFAHN/475REr14WJaz2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768333471; c=relaxed/simple;
	bh=+5eNlG53pCnP2H6HkD8AFxk5fYZZbrZGswP+g2LyVEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hVWW7ogIXtr2wu7ZoGMQ9lsdBudr6stpBucVJhR99cN/UM4TrDCAOa5VT+qpyp67gLF79bLR12EdXYW+Sf2gOZw3/NP8ELLNp/2At6jdnLx9QUs99rYBAgzgGsyDBkH1qonH5bxH0Dxxgi9oWro6l8Xml7LO3rM7V1tcjyhlj0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIVkepfR; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so79893225e9.1
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 11:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768333468; x=1768938268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wzKJiDxWGZWZK58KulJ6Ai7jgCO+I4d2FOxBhj+H/CY=;
        b=IIVkepfRlSbS7/7rFiS+cOJV8Pt1kpWkQeE/8QvFhKwQgNfcBMAnc+2OHUg5kegxuQ
         C6I1JRmbHGn2ulDJxFvRTUjelI81AMWAecVT35Lgxh7oz4fzTeQ0pmtXY3ljju4/zLrx
         JXddVc1GxfgRkyfGKZZ33XrJ+6NcOvE8AURAH1s54jBzO7bcMVnHzgRz/0UA+xZCRd1v
         R5kkM2SqrPEKquLIatPG0EECBY+ECFaXcNZSNgxq/cCmPWlCHfj0YzQjU0VZjZt5E7CP
         HOMSfAgLagvjNhhmWmITe8w6wD+YEn32nMPMAxRn+0u2h45h/Zex+q0hM+dWN6gHAPng
         EIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768333468; x=1768938268;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wzKJiDxWGZWZK58KulJ6Ai7jgCO+I4d2FOxBhj+H/CY=;
        b=II1PZGfLZH+FLZNm+CHzgvTpMLzdYEhtiTsqqmfLub8VuTH88yYgczqbMFGcsh9/wz
         ku1jkOK9s7CuP8Myp4zTR5L178rCh/hPqEsNxLgj4f+3HoDn5Q9moSDPYRVRYCg1VAmL
         diwZ64O5tgw+/oa7iN3f4EPXGRTbxPk2a/yUkTnwAx9U5v0Z8skBJypQZ4FQwht+v1JZ
         hDog5kclNUTA1er2owHr8GJAO0wg4gpV7hprTzNJ8SOJWjO5R9W3Ar7D+D31N32oFGM7
         Hc670A04d+j41614tUTt7DGuidmeA29qjEuIJ6cxtIA8D0MDRKkz7MjpNV946egNnqKv
         /wdg==
X-Gm-Message-State: AOJu0YzwzzsRLj4rA+NXetwnl7ryGKwyI5itS+ioPg6T9zNIFSvJBQWe
	+FRkCSzK/Ug87HIF0cL260o0JTDoKC/LtamS1Xc2CtzxDlSsqp4qQyTY
X-Gm-Gg: AY/fxX7Mha/+UoLgJKAs5bC1KN517UVCRlGqQLIGCwdpxkxh2egLCOgHeBS37o2ITr0
	q1/sHkTlg4e10XZFU3M4y0yeNzpgeGpgYjI6lRQrenGo2PFEO1SEHvnfYtDSuUEXVWxyhuWmzNn
	Gxu4yrN2535qKjK6KdB0HcKlrS/NNUdwiosgyIXm1/F30eRz/UNzO+iHDVNFZxfnqH1KrGzhVdc
	Z86wI7Qb+mgZLONU4iKxoPzRoTzfcvo8drSAvDlqi0pv7ckBXXwQxwM4NI5pW3EHnr/bChqejI5
	YyAWCaWaOHkNvPejeQCygkVDZy+aPZy3Q8aTDme7jCVUSyf5zBhpnRCIn1Ps7SLW1o/PHoPHzkX
	WIcHXueDvorVBMLFHUMl5NUfZFV6CZUq9n4WMt25NGjMNIhKln0QDb60OgEB3E96Qf2xHHJRyoa
	I5zqOXKcMj72UVwEFY7x5QN+RnhXXeFJq+sY6e27FWz0l2/4XChGk1XesFRoKNwVU7Vw+d+kbGY
	jfij20TZ+Nmgrk0YNxeiyme0DnGcT6rn0NNTv0WgSfb7Be0oev7f6Q6hMgvfJzbIA==
X-Received: by 2002:a05:600c:3556:b0:477:7f4a:44b0 with SMTP id 5b1f17b1804b1-47ee338ed50mr3080765e9.33.1768333468295;
        Tue, 13 Jan 2026 11:44:28 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ede7esm47023689f8f.32.2026.01.13.11.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 11:44:27 -0800 (PST)
Message-ID: <afe7d084-a254-46a3-889b-a136dc8f4fbd@gmail.com>
Date: Tue, 13 Jan 2026 19:44:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass via compound
 page accounting
To: Yuhao Jiang <danisjiang@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251218025947.36115-1-danisjiang@gmail.com>
 <CAHYQsXQzAWhpwzqSTGxvWgNXq_=g4V_nsmRGnYeKPumGgAmyXw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHYQsXQzAWhpwzqSTGxvWgNXq_=g4V_nsmRGnYeKPumGgAmyXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/9/26 03:02, Yuhao Jiang wrote:
> Hi Jens, Pavel, and all,
> 
> Just a gentle follow-up on this patch below.
> Please let me know if there are any concerns or if changes are needed.

I'm pretty this will break with buffer sharing / cloning. I'd
be tempted to remove all this cross buffer accounting logic
and overestimate it, the current accounting is not sane.
Otherwise, it'll likely need some proxy object shared b/w
buffers or some other overly overcomplicated solution.


> Thanks for your time.
> 
> Best regards,
> Yuhao Jiang
> 
> On Wed, Dec 17, 2025 at 9:00 PM Yuhao Jiang <danisjiang@gmail.com> wrote:
>>
>> When multiple registered buffers share the same compound page, only the
>> first buffer accounts for the memory via io_buffer_account_pin(). The
>> subsequent buffers skip accounting since headpage_already_acct() returns
>> true.
>>
>> When the first buffer is unregistered, the accounting is decremented,
>> but the compound page remains pinned by the remaining buffers. This
>> creates a state where pinned memory is not properly accounted against
>> RLIMIT_MEMLOCK.
>>
>> On systems with HugeTLB pages pre-allocated, an unprivileged user can
>> exploit this to pin memory beyond RLIMIT_MEMLOCK by cycling buffer
>> registrations. The bypass amount is proportional to the number of
>> available huge pages, potentially allowing gigabytes of memory to be
>> pinned while the kernel accounting shows near-zero.
>>
>> Fix this by recalculating the actual pages to unaccount when unmapping
>> a buffer. For regular pages, always unaccount. For compound pages, only
>> unaccount if no other registered buffer references the same compound
>> page. This ensures the accounting persists until the last buffer
>> referencing the compound page is released.
>>
>> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
>> Fixes: 57bebf807e2a ("io_uring/rsrc: optimise registered huge pages")

That's not the right commit, the accounting is ancient, should
get blamed somewhere around first commits that added registered
buffers.

-- 
Pavel Begunkov


