Return-Path: <io-uring+bounces-12532-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SD3AGbYLpmkJJgAAu9opvQ
	(envelope-from <io-uring+bounces-12532-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 23:14:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D06FD1E50D0
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 23:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BB01830BB747
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 21:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1683A331D;
	Mon,  2 Mar 2026 21:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BbEOyWiL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50009386C1D
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 21:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485719; cv=none; b=IJQcobh8WVZEV1tTudvA3F6f5tGiX1KjL9Mbnl0OkLBDtg+11bNkS/2p1W7ZeEVWatWb1TbvECDijYr7DUBRfvnA9ICfWskRCPUps6GgVbLL6J1hvy84T12xcUJh5PsB7Pe2uqdsjMEoSsCOM8bhGkCqh3348XWwU7JW1MH5of0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485719; c=relaxed/simple;
	bh=ysqoOf9ZbQhxBgmZKS87lN56YFBpubtILCQz9oFd870=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LTW592PEq6RVocZ3K64l+Nt+gAHbizO97oC09iPJD1TjcobQ4tRpSlWFw3JBK8zAfA/sgv9IhO1MOMYFhLph51tRtSTLvYwoBdyvTZuln+IfL+rPOdHNALD2dI0dMYCWwD03a/9uqieBqVnjYzBPHTxZ/S42Uvmo2OcUk7r8tQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BbEOyWiL; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40fb2789476so86183fac.1
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 13:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485717; x=1773090517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ygs76HGOCOFE6AYrjp/vjGX4ajg9/UeAQcATp86xukg=;
        b=BbEOyWiL9SXlmWDMeMM5M+soTjtWRORY/y6PFxBR8mAbyTdowDrltBKFMoPmkiuk/W
         jvy/LH5imbkFNhPwx1RajehBEbVtqjERQT4ekeq4Bv/+MqR8mPDJ9ozhzAytxNnWxlas
         6by3TdtcLfbfmBJ6VQfCDIsr5XMAavFGnyzcjeh477Wa1fPtKp2VnUCsl9bm92npKYki
         AMy7XLHaWcPphN9JeIQATtBmlna9l64iLqNccb0XSNqJhdb3XTHki3hASlybup9u1xAd
         Zm2GdEKhycX6fH+dnaGRB32KIIqgyuSSLSuOld8OI8lj8QfKjUixFV6PX1dFjcJBU+3B
         zyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485717; x=1773090517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ygs76HGOCOFE6AYrjp/vjGX4ajg9/UeAQcATp86xukg=;
        b=IGTSzzEfOwZw8UNKBh8iJlS5wzSTaKOcVQjNG19u7zjysqCrS520xRoYNmEMoWnV6f
         KgT7YA3nx24Q/CwI1UzSNyxS6CtjMNScNZCWZf1/00RYVnZrR3caUuiloGJAuLPhKfKf
         QrFOQiHB+k6Lyd+ElgWvsA7npnk7wmLR17zC7Ze8ywlQ8ePjVZ061F/g4uu72hb862oq
         d1hmCIqX+Er2C975fbN3iEguQ6/TUbxm/uHSmetNmzzy7jwdP9FruUSUCtF2fpha4yWA
         dSJslZL1W8Q+S/ihHlWtY6KqCX9fP2AVZ2lJKXOWWY1vEyB19fpDQ49Yf020fv7ah2Je
         jx+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWPw1oV56rObp50ga/apy/7B7ZagLanWV9BlgWXX4IOkT3efhJmiLLuBFDbYEyRs0qSYCQ9yM1QuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAdveUA8F0+qheBmw1zw+7iOE2bpiUlehR2ryzmSP5Ny5+OCnw
	K0ZBw37E7ZFoRrkC0TymRrXZLQqN0M5SMbpEpDz+Vm4hwn0Fb0RgblkRu+fFWwVPKTpzc91K8n5
	JzTQA
X-Gm-Gg: ATEYQzw7hktHOyWjBz8BrBLfA4gUToxZrvcdFQIl3d4wdJzNq3RBMSHxwtR7HpkRUQf
	V5lUe+08KjYDIbkxfC8S4dSaTqLUMlGH9WJaLo+mOg7GRLttGe17tEsNQnu5yga8/9yz162LMjI
	J8MoeeTnq1sasfTGyV1uYaLEGx1bThBIo1K7iCxhwCSys/gIyc0eFhIYp+4+KVVQSzoHg09bayU
	p9ZjkOMYnQiv6oAUEgFsQ9MYypbpc6IckPUuRkU5wjRWNnuYhfN2x9TnmbhAOIT+CUNpmTnFjU9
	zSrxrYc3duvehFkcjcrs5Q1GdgcHx7dEjMECyjXKn5fUb+qSK5+87Wa09oQk7V/YPXZJAga9Pyf
	/PU5bt4MkihYSJPt3DTnIuOqA5jj/A69rN8O3pR2VQkNKuxiCsiFrg02C70jpdb8KwZlwmldNY7
	M7Rxds0yv+jEn5cHM4v/lwsUrqE5wcfBQpZCnjTbk92zKpyY+mSoMJ1vgDPPkIaQBXpYLXR4X0u
	0heWdyicfyUHmakA+CR
X-Received: by 2002:a05:6871:7c07:b0:404:1abd:9798 with SMTP id 586e51a60fabf-416277931b0mr8215565fac.11.1772485717267;
        Mon, 02 Mar 2026 13:08:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm12342960fac.9.2026.03.02.13.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:08:36 -0800 (PST)
Message-ID: <02f9fd38-8062-4000-9198-723b98036c29@kernel.dk>
Date: Mon, 2 Mar 2026 14:08:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the
 configured alloc range" failed to apply to 6.1-stable tree
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org
References: <20260301014717.1711200-1-sashal@kernel.org>
 <eb41b6f9-08f4-4972-99d4-3340571830bc@kernel.dk>
 <8e84b6c3-e62d-4aef-90b7-a7a0e63d8a17@kernel.dk> <aaX2F5LGPcqaDXum@laps>
 <531cfe07-2a07-4bd2-be07-9cd78890e04f@kernel.dk> <aaX6AzNtFQ32exUW@laps>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aaX6AzNtFQ32exUW@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D06FD1E50D0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12532-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 3/2/26 1:58 PM, Sasha Levin wrote:
> On Mon, Mar 02, 2026 at 01:45:51PM -0700, Jens Axboe wrote:
>> On 3/2/26 1:41 PM, Sasha Levin wrote:
>>> On Mon, Mar 02, 2026 at 01:38:37PM -0700, Jens Axboe wrote:
>>>> On 3/1/26 6:15 AM, Jens Axboe wrote:
>>>>> On 2/28/26 6:47 PM, Sasha Levin wrote:
>>>>>> The patch below does not apply to the 6.1-stable tree.
>>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>>> tree, then please email the backport, including the original git commit
>>>>>> id to <stable@vger.kernel.org>.
>>>>>
>>>>> And this one also picks cleanly into 6.1-stable. Not sure what is
>>>>> going on at your end?
>>>>
>>>> Are these and the other "FAILED" false positives getting applied or
>>>> not? I didn't hear anything back on any of them.
>>>
>>> Appologies for all of this. There's an explanation of what happened here:
>>> https://lore.kernel.org/all/aaWWE5uQqz_eG69i@laps/
>>>
>>> These should be part of the -rc2 I did earlier today.
>>
>> Gotcha, yeah it's not easy to know when you don't hear back, either
>> as a reply or as a new "added to stable" email. For those of us that
>> do take stable seriously, I 100% need to know if something is landing
>> or not.
> 
> You're right (and thanks for all the backports!). I had a plan to
> review all of these again after the release, but I should have sent
> something out first.

Sounds good, it was more of a note for the future, should something like
this happen again.

-- 
Jens Axboe

