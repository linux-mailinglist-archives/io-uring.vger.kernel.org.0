Return-Path: <io-uring+bounces-11902-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HugBz3Gc2lZygAAu9opvQ
	(envelope-from <io-uring+bounces-11902-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 20:04:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A849C79F3F
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 20:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 183AC3003D30
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 19:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E012223328;
	Fri, 23 Jan 2026 19:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vv9A7w+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CAF285061
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 19:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195065; cv=none; b=QZDVJcSk34+BmVdG4eDFqk/1q69T3icKGQZbAC3JcerwZu3TK06N5fSf/gsnSHavOqU7DfwGO+uv7paK8nbiPzvoRna5U2+207kogdttR279UVtcXKMyxJilegRFZeU5l4h1xeQdmJFwl5VGYQtaEr5rJaMBksYmJie8o4XUlQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195065; c=relaxed/simple;
	bh=u3py3F1mhu4GwSe+NVJr19M4EYXVtWbafecD+XarmAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GMVG/nY5jlicMpm/iYZDMilT76qxw7d9NVILf2fAWmChelPW42+53AYjjN89ExMKqpYtg/XpLK4i6dZ3NM616apxMO10zSxJwFbH0d13/Jvz913TbR6+5VAqpnWx0CL492yrs93MlHEBvnn5gJC0E0fZnVj5VkpyqMT3On961RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vv9A7w+4; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d148dd3421so911960a34.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 11:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769195048; x=1769799848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wrA4N+VrTEKky0RApZ2kyFMgcU3tlcES14vx8umyZ9Q=;
        b=vv9A7w+4C10tLJgJj5h7QSIkJuJEyC6hq3zTt+5qSM2Dwwrml9HqZXG1qXbBIRK+Ft
         WVkcTCFllumwLm/YlCWt5rrlAuo/83LDqyQK9vbEJaSUPmp60/pz4xSI9HiWB56AQVDW
         D//EQpSd1NU4OgynwCMRl8W0UyRF5AC5sfbk96fZIqYqSlFxAQTZYX7n2JuvbULyKsMu
         wXhQiw1D35vEVB2Q8PaZtPY63+lChut5PdMLCzwukxIzcrGlr8zg71Q1ufbCNZgXZruF
         ly6xbsl9vDYZnbOP45LUNWMAk9qnNU6NUx8BTkq4JYzIRvnSLA0AJhDJdE5frK7a0cSN
         QvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769195048; x=1769799848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrA4N+VrTEKky0RApZ2kyFMgcU3tlcES14vx8umyZ9Q=;
        b=Bv1Qa6Rdhk7l0OCZiQf1j89a9oQFYEVZ/086DQPJ+NDdbqeZOcQaT6m2QmFXE/6fTJ
         XdmUnHZDbpbwIHrN+wjX5NNDAKdhgCWNtgAZZ13kAE9mCf2U+CzubwnNGuN+fuKHkuzt
         EM0kNByDP9CVMeLiJqKruUpCVxv4wqzBITQtFx+HoAiSZUnpiWeYd6jpW8GCSmz16CHC
         P6PA4rEn6SfoSKuUazT3R1wxmP+12bO2OnMoZmph5p9cIF5NjgmoKO1lM3iHY64SdpGP
         6NAGRxJZ5rR/nPumoaAtp+Pih2g6Y46nccAOw73BdGYfDvk4j06Ks8tDyoruHKcM/O6r
         qoLg==
X-Forwarded-Encrypted: i=1; AJvYcCXLMPzsIHnL8mK4fFcb0YkYVt1reXAmgd102G2GZDbuOyNr7uVBZ67W3PtMTUb9FIfFrm5O9b51/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSXGV7PARBii1mukUMCsbm9xueBH0Eu3SR4+ktvoYCf9cHJcSr
	tDCdiLrMB/PSYf/qrLHlh60jfnte0ADSLQnjUfg0hojaiaqFNDHnmNfpW5eIrvs0IOCiCYhM4QW
	2436hFZY=
X-Gm-Gg: AZuq6aKWG88bqa8a2lJdUyk6M/lcGFb3cR6p6jhmgX7FIAcmbZDcwX8Cfc7eFNYZ55n
	EEHyIZ9lA6iRGNHVDjZdhikjN4tvt9PsJVYbAhv1gi4i7+X+kFPwt8fk0LlTA+FRuUn52acMCu2
	Hs9Y9XB89WtorOV6n3lzcFYSKJU4Ix7DCqp1UjZBETySq/wpwXvsorJo7Oc01BTupCJZ9AHXpiB
	hG8W5ZfiY+FuIu9satRT/Iy68R1f1WwD21CFvFS5KOuQd5zMMFN6ImUa6SsuqjOkTx0id4oIr/0
	PLwBm36a+HYMrKGrZumNiYCDMe189f7Y+rhC4R34HONWHdfZTwkWMOZ55b9kU07E2mgKU0LVrmN
	/vio1ZZDoY6baMAYg15nynLC93ZvT7pFfRB7y4UbQCfYmgSR7ryejhdVACUyIQ59mDmVeobuT2I
	tbSUEVQZgV3pAAmpfHex6m2MpIFGbkxlm2lA6STsAykNkJMkmCvudaZqcOt/jBPtd+bhm2B5DmR
	YwqlS0=
X-Received: by 2002:a05:6830:6116:b0:7cf:d4b2:d664 with SMTP id 46e09a7af769-7d15a5c88aamr2086006a34.4.1769195048598;
        Fri, 23 Jan 2026 11:04:08 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b3d31d4sm2316681a34.21.2026.01.23.11.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 11:04:07 -0800 (PST)
Message-ID: <2d2da3b2-74c6-4605-8d13-3f0cdc67191e@kernel.dk>
Date: Fri, 23 Jan 2026 12:04:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1769034107.git.asml.silence@gmail.com>
 <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
 <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
 <d106a68d-e981-4239-b0db-21a311ec03a3@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d106a68d-e981-4239-b0db-21a311ec03a3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11902-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: A849C79F3F
X-Rspamd-Action: no action

On 1/23/26 7:14 AM, Pavel Begunkov wrote:
> On 1/22/26 23:05, Jens Axboe wrote:
>> On 1/22/26 3:59 PM, Jens Axboe wrote:
>>>
>>> On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
>>>> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
>>>>
>>>> Pavel Begunkov (2):
>>>>    src/queue: Add support for non circular SQ
>>>>    tests: add SETUP_SQ_REWIND tests
>>>>
>>>> src/include/liburing.h          |  5 ++++-
>>>>   src/include/liburing/io_uring.h | 12 ++++++++++++
>>>>   src/queue.c                     |  5 +++++
>>>>   test/test.h                     |  2 ++
>>>>   4 files changed, 23 insertions(+), 1 deletion(-)
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/2] src/queue: Add support for non circular SQ
>>>        commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
>>> [2/2] tests: add SETUP_SQ_REWIND tests
>>>        commit: 346c063d16bda52f02d00feb744aafe35b4002a9
>>
>> Hmm I do think you're missing some spots though, no?
>>
>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>> index 987b28aaf99e..016be1e80ef2 100644
>> --- a/src/include/liburing.h
>> +++ b/src/include/liburing.h
>> @@ -1702,8 +1702,13 @@ IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
>>   IOURINGINLINE unsigned io_uring_sq_ready(const struct io_uring *ring)
>>       LIBURING_NOEXCEPT
>>   {
>> +    unsigned head = 0;
>> +
>> +    if (!(ring->flags & IORING_SETUP_SQ_REWIND))
>> +        head = io_uring_load_sq_head(ring);
> 
> The head should already be zero. Actually, sounds like the get_sqe
> hunk from the patch is not needed either.

Yeah agree, I think they are both false alarms. Might warrant a comment
though. Or maybe we just fold it into io_uring_load_sq_head()?

-- 
Jens Axboe

