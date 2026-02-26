Return-Path: <io-uring+bounces-12440-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMRiISuFoGkakgQAu9opvQ
	(envelope-from <io-uring+bounces-12440-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:38:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 35E501AC983
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 87E3731CE082
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 17:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E2036894C;
	Thu, 26 Feb 2026 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8IVRFH2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8A36896A
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125822; cv=none; b=kBzVKfQp+cBiLKePW1D3d/zUS64y1k1Xu/X8Wt4Gi+Xb+ZklHKGV3emuOzlbc6aFWTcL1WDhsMwQsnvj4SDy8JMTnFdKtgxijldx1qIdXerUmaciUZomhKtjJJiNpqm29gH3UII66riWIntSEeTGSLpLkZdKRuyhG1+8Q3HvNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125822; c=relaxed/simple;
	bh=WmTVseGn7Q74gaelc599wZhIHUD3ocuM+DDXDE9I214=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EWdKrZpK97kiUUU4AeTo4Dswu48LJ5prf+Gq0FkPKsW7sUX+f1s3R4riMGOrl5+PnjceU10DkRFmA+WHaqEBWCYFCJcadFxjfRAL2IoB0e8e/ykbZ9PJwsI8dvfow7SUGHV6k5egADeCLvr/ZDvXcGtUa5Mahu0uBC4omujDn2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8IVRFH2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so13682105e9.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 09:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772125819; x=1772730619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2LjD8X36X/uHCPmY0WJ8HtD4g2POaMs3tnVfiShEaU=;
        b=Z8IVRFH2eAQqMqjwO816qaZYpQ7Evqz/1KF5hgrV7WXTMUdWIe3nqoCd8JE/nWltNu
         G4LXk+UhfIxjIc0sN72KTfx/eyqZhkNaspr6h6nd3iR1+QyTtwT9cTs0c3Ul3zcrfYdQ
         glj6Qt6qkk+r3ZL7VthuYdcALgo3EV1tTqoF+m2tq/CWUcRpEPT9x541k5hydFxAfp9I
         Jm3B8DHeCnqa8ttCurf7uIRhnuesUNiNwBQQvfQZrYdhGg4nWn7OgH2TGhjQwZlX6Q+u
         EziqQJs5mqWzr1qykslCNki47quUVJdkSFbOEJib5yUA+PTKtlYvxIVrUl/J9X8BQrXZ
         Ox8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125819; x=1772730619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2LjD8X36X/uHCPmY0WJ8HtD4g2POaMs3tnVfiShEaU=;
        b=ZTnJU0zwi2XYVnFIbSH27b6CnsGN3ZL96LcSe7ggvPMqPMGufcuqeLQrHJWxN6gu3Q
         bv2aJjVHlPkAf4VbVnEhePdxcrIHRagLQaKbcL9Hrhh4Ld5BHTstMZbFhh1z+vxls8J6
         4ZKaCltOdcGl2o6ZWok/CvhHVRtTJ5MyekByNQxNPUVxaFz0hUNxeo2suYY//I4xWIj0
         hSx8dq25Ocinvhs5qul0xbkKma9q14N2PhOyfzT0lQM2ONq+xzKawNYveGtcP1mnxnpK
         g4C+S9HdcyNHBBI3CAVPZu4NJNCGypK+V//NRrSDvj8G23giva29CXgUdHGXWeTmm3br
         oAiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuHid0lVAy4VhoRLXWC3odX5t6vvhLWZCFGmpi1sjEf6PwPWNP8dPReLy1TH4BJgI2f6GqUl+z8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG8/L1uSyzMArfT6n4loZu+LGFPADLDcX9SyBxofmODZe6NqKf
	ThC3gmQacI7m8K0lbuI6f+wjSkPRZ//Bg+Qc6992yxgLNiVhcvY1RdxD
X-Gm-Gg: ATEYQzyNkZaSGuQMP6QAZ0jSeyZlY8sVfDLa9CZ3CoW/nyP59Dkd947VWJQOX/05OmW
	+tmLE77tMomlfT4Us3R1sEFkhHtQhRkK8X6H4ZQkd79zJM07LYdnvhLLzqe7unov2JlgGKGpvsv
	ooQIvvOyVEoExQHSRRL9ydkJ51Y1u1P4bvOsudVkeko8cqMgVMB9N9w2WJbeGVVQKmA3ODisNwK
	xrQvnBLVmgpxGMLX5ZBkCwF/B5OfHuJs6OZ4MFaJSZczMrdwcqQPnnvsX1nsIQPNrDlnUOV1kX0
	MT61NFa/tj1Agq8xWq/iKM7pTMP1VLQzC8ySMV46nE2Q9tmVp2uKEH/YNqO0VHsh1KvDEdGpUmN
	ldc+x6TOIxWhz4WX8M22c0T393H+Omo/T/opISUuLIJgGjjxgTNIfXHUwEk1jbYe3Qz7MK8It+n
	tX475R1r8Dy5Lia7eUXc1/ZCl6paqiH1dQcr+fEX3R1oq9J3lTzZLcCjqmftl4J3YEdKgfBfMSb
	fsQASY2PLJb+xR2XWna2PX7cEtbGhdz6TtdkomZ0Sf3GpuKiNQ1RuMrRNUMvo8+2JaiRyVVhZEY
	+A==
X-Received: by 2002:a05:600d:e:b0:483:c3f3:1dad with SMTP id 5b1f17b1804b1-483c3f31e15mr48462285e9.34.1772125819177;
        Thu, 26 Feb 2026 09:10:19 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd68826asm249850265e9.0.2026.02.26.09.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 09:10:18 -0800 (PST)
Message-ID: <71202db3-1aac-4b0b-9b52-1f3d074ac41b@gmail.com>
Date: Thu, 26 Feb 2026 17:10:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
 <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
 <d718db45-cd6c-4d89-ac9c-8f073d31eaa7@gmail.com>
 <8b987673-33d8-4f0f-a13a-1c1f963f9afe@kernel.dk>
 <981224e9-0141-4117-9304-41b72d11fc9b@gmail.com>
 <4e3d774d-eae1-4243-8a6d-071f93bcf996@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4e3d774d-eae1-4243-8a6d-071f93bcf996@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12440-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35E501AC983
X-Rspamd-Action: no action

On 2/26/26 17:06, Jens Axboe wrote:
> On 2/26/26 10:03 AM, Pavel Begunkov wrote:
>> On 2/26/26 15:16, Jens Axboe wrote:
>>> On 2/26/26 5:52 AM, Pavel Begunkov wrote:
>>>>> Applied, but there's no documentation update included. I'm just going to
>>>>> auto-generate one so we have it, we should not add new flags without
>>>>> documenting them in the appropriate man page(s). Same old story...
>>>>
>>>> Looks like you've been generating AI slop for docs, so I assume
>>>> you're not against it? I'll try generating it next time.
>>>
>>> I think calling it "slop" is a bit unfair - sometimes it does get
>>> nuances slightly wrong, but it's a LOT easier to fix those up than write
>>> it from scratch yourself. And the the language is a lot better than what
>>> you or I can produce. The icing on the cake is that I no longer have to
>>> nag you or others on documentation - though I would prefer if you or
>>> whoever is the submitted generated it and proof read it, I think that's
>>> the better approach than me doing it.
>>
>> Well, whatever it's called, I might just use it if it saves time
>> for writing man pages. Does it require any attribution / tags in the
>> commit? Some Assisted-by?
> 
> I'll save you a lot of time...

"_I_ will", looks like AI already replaced Jens...

> I don't care if you put the tag in there or not. For the kernel, and for
> actual code, I do believe an assisted-by tag is required. But for
> documentation or liburing, as far as I'm concerned, you can add
> attribution or not, doesn't matter to me.

Got it, and I wasn't planning to use it for the kernel

-- 
Pavel Begunkov


