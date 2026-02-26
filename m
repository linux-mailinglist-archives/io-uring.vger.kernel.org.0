Return-Path: <io-uring+bounces-12439-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIDULLOKoGnekgQAu9opvQ
	(envelope-from <io-uring+bounces-12439-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 19:02:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A93771AD302
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 19:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 90063330FE8B
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 17:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A72368965;
	Thu, 26 Feb 2026 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qAY1DU/z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E34368974
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125571; cv=none; b=nvrUsUrihHDwNgQl20QJRHqLpEIkJoIc16K7b+0w4HUkb30gORlsSQXrqzKtxLvI/X3VbA4exIMejHKjgxy+hXpYwIiu6ZVW+eubtPZsLsHlg4nN60YiGpYdUijfJfTZ5OT0of89PPnk98XzZ0TV4pi/UKFPmrnHY/dyllgG4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125571; c=relaxed/simple;
	bh=uazO85FhNAa4AsaF6uY6C3NjckkHEOt0gviUPW35Axo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=huZJwanX9yIymlNddc2U/9t1lgpKGeJOu4/T1LmRyDRzlCKqQe4myAxN+fcY2gyXgcklQxiLF1dyNZsIfdJvJwgLm+80PbmoYBB1Ywqj0PC6M1hpCUVNh9EwGWXMXtZH3TZC29zjPmDRZ9YiHeoblkpzsXdkF74Ef6ephQQvJl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qAY1DU/z; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-463a0e14b4cso273582b6e.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 09:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772125568; x=1772730368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YXV3YRMDEZnxziGcAejY786zESSuj4VypKJKRKAmdEg=;
        b=qAY1DU/zVkWt07LQ6by0OFAB0dauDrJw/W/EtF4TKu+qhQX/1cxgGW9tFHGOtR9q3N
         7BQP9GohRyGMlIG+FOBqXtFNzlcjLtv7zDxbRZh7avpSYFNDY6w+MQW8lu7dpBWNPdiV
         N8JmaLUwzT1IFUEK2SYmx9CGIUhqajAszadYaGbqSj0Gj9FB4XcsoElySmgRziUkkufZ
         OmqG35o+evEBQGnl/L8dZog8m5t5qWH2pT0m5jl5VtKR9AxgcIIqFs8+BixbQDUtZ3FU
         hsQewCAA2iW6Ilhl4tDlAZRwfkIeTZbjZLkOf++8t5AhF5oaqRRv59d6IpxxACrvOAb2
         P9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125568; x=1772730368;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YXV3YRMDEZnxziGcAejY786zESSuj4VypKJKRKAmdEg=;
        b=c6cwyNB7P7pIifRVg5B8Y8pNEZQaIjk415TpaA4NzsBri+z1PJJ1xZkYvNww0R/uqK
         sjZoeqFKtFNCeEawz8UhAMLNzoRCj1Ic6svowD84ideVF4g2vtfcsRtQCAVWYreD65dD
         vECkwuf8S5hHXrXqr5uz5hNoygvi1glup5I/cA1UHLSNo+r7Akx0P8FAwTLn4bHsTWEN
         xeN/0MKrYvFH/gL7zw1KHuRQrQKhM7sjvOCoiwLY3QAUGyGYVLvfASsb6fd+8bbRMqMM
         1px9X9ojHwYZSeIOhsfqMkwYaupcTYw4TXA7YHhtkwawg8yJQ/PhpN/KcpQA2CFyUthe
         +N6g==
X-Forwarded-Encrypted: i=1; AJvYcCVGeaFHhVkGEssdACAgqSi6Io68mCDcrbuB4USfrdB7niTT9BFru7gfdIm0GJZnloIxGF4EdG7vVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvjU7prdA99QAcw26s6jS7s4XaGw9nA1E1CpWD9UDjpw7tS+aF
	c5som42jEMiW7QtJRduCOWJ32sCdKOfmjC+KrUxU9mTBr91LS8kApQEOlGyRv/d3HrY=
X-Gm-Gg: ATEYQzysLbn51kSFNRdfFv9A9lzrYddnYDR1v8VRaj5tw55L9lrOQnSsPOThwGXStcL
	TGBapkJ8NZmsJ8IsKKm3C3VfjagBfXEKsy4J4clRU0NtjLIcR+pQ5/1BDVuWNIezfmPSO1Vzpq4
	lFAZc4WIXrG/midwisT6mda6+O9NC4w6O7nhbZerr6LGUQdtjhw+yUTEX+zsjQxQbzvjgwQy8AF
	P/n9PYKMxWJsq6mrmQBroEdOoCZmAk6rLBS84Z/h0qU99KCNKKBNhlgdQVIAkEVFmWzvzNFDwZB
	VUY+CFE+OKuKTCnfwj8jcdLnQ8Jsl18Z8I+O5FDyb8u+vdyaMyTTBj7i3DopfpXmwjbx2KjVHcu
	szWgEbnilmfUXUktsoeqfxU2J+2mA55Q40lBPArW/FrDuzzu2RiY8fHFIl8tqAg4d1jF0ixtEKh
	soU1+qjjL4AuIaiZMEbTtsLDB0+ZnHocbPXxRgTW2UfLg0f2QpZ+svOhclsQrhujjxOtaLuagnt
	B/uKbH05A==
X-Received: by 2002:a05:6808:c1ee:b0:45e:f91f:9730 with SMTP id 5614622812f47-464a9597219mr1509273b6e.51.1772125568224;
        Thu, 26 Feb 2026 09:06:08 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb352592sm226548b6e.1.2026.02.26.09.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 09:06:07 -0800 (PST)
Message-ID: <4e3d774d-eae1-4243-8a6d-071f93bcf996@kernel.dk>
Date: Thu, 26 Feb 2026 10:06:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
 <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
 <d718db45-cd6c-4d89-ac9c-8f073d31eaa7@gmail.com>
 <8b987673-33d8-4f0f-a13a-1c1f963f9afe@kernel.dk>
 <981224e9-0141-4117-9304-41b72d11fc9b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <981224e9-0141-4117-9304-41b72d11fc9b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12439-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A93771AD302
X-Rspamd-Action: no action

On 2/26/26 10:03 AM, Pavel Begunkov wrote:
> On 2/26/26 15:16, Jens Axboe wrote:
>> On 2/26/26 5:52 AM, Pavel Begunkov wrote:
>>>> Applied, but there's no documentation update included. I'm just going to
>>>> auto-generate one so we have it, we should not add new flags without
>>>> documenting them in the appropriate man page(s). Same old story...
>>>
>>> Looks like you've been generating AI slop for docs, so I assume
>>> you're not against it? I'll try generating it next time.
>>
>> I think calling it "slop" is a bit unfair - sometimes it does get
>> nuances slightly wrong, but it's a LOT easier to fix those up than write
>> it from scratch yourself. And the the language is a lot better than what
>> you or I can produce. The icing on the cake is that I no longer have to
>> nag you or others on documentation - though I would prefer if you or
>> whoever is the submitted generated it and proof read it, I think that's
>> the better approach than me doing it.
> 
> Well, whatever it's called, I might just use it if it saves time
> for writing man pages. Does it require any attribution / tags in the
> commit? Some Assisted-by?

I'll save you a lot of time...

I don't care if you put the tag in there or not. For the kernel, and for
actual code, I do believe an assisted-by tag is required. But for
documentation or liburing, as far as I'm concerned, you can add
attribution or not, doesn't matter to me.

-- 
Jens Axboe

