Return-Path: <io-uring+bounces-12419-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGPjCTYxn2lXZQQAu9opvQ
	(envelope-from <io-uring+bounces-12419-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:28:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 941D619B8C9
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44C1A301CCCC
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945D53E95A8;
	Wed, 25 Feb 2026 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VePKlV0+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311AA2C17B3
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040299; cv=none; b=jwDT0/OIdO2TO6nYfxqo0PXSdAkt3OMnA6D7erarUh7gQ4vkqFJ7Xkbk22JPs/RQdxoJV7YjIthoEy9Kz0yDg3jM6dV3ZcI2S/uBJLkhOdeextk+qQlE4kPXx4uTtVwT7CSf5lFQIJcgruLUUC49Ln8QyucP+25L2BkPQlRJ9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040299; c=relaxed/simple;
	bh=g694C3z1mR/MPBvKZfa01B9hP5VXTQlzidWBQncEwtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiUOeMKXv5f621duHRojpgyd0KQpscBreCQ9eJSoKfIOxQZZ0tOcfBG+SxTFNyB7WWWIHZcab3VQ94Rgpv5GUScqRAMRSnprgizPBN+5a9LpWFlJdGYHHJRNFwsIgJokRw8bSp958JhW7OuAzpqslYrO/OQbekgzmuIRHHaaufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VePKlV0+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48375f10628so100385e9.1
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 09:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772040296; x=1772645096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7U/idi/iRX4NdL63SBTaFSWz/IhDdcMvBGwU/EP3OcA=;
        b=VePKlV0+zgqjg6yPhFwoLomhZnimvPNMYc1Gh+MFT/TebIVnyOHM0Js7QxbUl5JpiX
         wUscQ77gvB3/bk3gm/4AVMnZrFDZsztsvR67ca6gfXU9QiXwBg9hgIemb4jWYWebdofq
         WC7H/ysGOW31Sc3rk0CKjfmcv3rasQnWdIp0tlprU+h2aRL1oFm0Zm89cOgMSOBCtOgc
         ErOfDZVuhbXIwkNSJ6BlcUyyoC+BNSsQcOWSrO8nU6MerY1obp/TiSaLGMSlkfYf7uvG
         Pb0DRBm7qPPndoahrPQNUepHeGqErZjCQ0ed1vtTJLxxpLuC9E4oqLTs+B/vKxYLqB9B
         cUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772040296; x=1772645096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7U/idi/iRX4NdL63SBTaFSWz/IhDdcMvBGwU/EP3OcA=;
        b=FQhxnAFi7TfEQxmlk8OleYRdUHyAZ7Pn2DxrUf13BdEOkRym5oSAJbuCqfLRwoEvSl
         pWKJNQP+vAXOteyc8XysvF0D0wq7WA81iShjBFppXro4g8034NVpJH83BQgnC/x1fmB3
         qLdYFdvw4uUYtCn5afAt5RxzChRMdU1kGdhAA1ZrrhfbhVJo0dfBredUsOU44uUUxvEb
         DOjnNz6r19SN6Ymw7Wlqu2DjrDWUiYJYpQKVyr6aYQ/zlD7iM3W40zr6cR4vQouC6xee
         c/kVZWDr3FTtwzrRzv/ViLn+6D91yKD/41zudpKPTBCCJ2kzZg16zAjz9jlleDjWa1O9
         kCdg==
X-Forwarded-Encrypted: i=1; AJvYcCVG5eJV3lvEOa62xI++i+Neg+D4zjXl6OjQyUOhN/L+kQk18NECXgda9ZUpYvDt+RAg/E0Vrj/EMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+3lDLepK5SiXOxLYRSNZBFVkIrRPTUDj4ZGeK4p612jlKczPk
	yCcbnuuWQhY2mCECd6M5thUc+A74mFojmu3eBZgNxdCWnnEAIISGhz5D
X-Gm-Gg: ATEYQzwq2YYfo32SC7GvT7US8gmUD6h7KytXP2JTJ1oEeKuhopIhogACn1fAtqPfH6o
	Dq5ezHNqEGw6Eq2Ynrm1dlQpfxTuM14qSoeKr+pzqp/W2x2xO2FKszOjuy/hEd0xrSzcnGeGpkM
	tKxesVQwzL219J4LRzVfNNAlbyRD/j2x9ussNOq0G8/FjAXcJzuB+5+vgKdKpna9boPnzkDe8F8
	UWDMW2BR2X4Ycw3geMT9pOULerGcSbJKvw3BOrlRA27fRE7vAmnOJoyu5cDqoxoS1iwB/XlJSbR
	iQSO0lVMy3c2XnAw+e8CoVtqdvdMkkO/jVIFOp+fM2xmHL6JEZElgrB8ZycydoonhA/Gr+WNfXh
	LgHLif6jUWqR6ucSDel3TZ2bOTdbHgFb+41oqw24WofnTMKlris7H/2HUeRibI1cwEhhRe8za/t
	M5xy1QYjOKLwK9fCZXTwfZVy7Ad6r4OYTcbo9M82WgowAVXnGjGjoC8C7lC5wFUZu+nUew9vEvk
	IxTKIVfCnY1ObmsnrRAhhd8DrRbpUrtbikwujAlz2q208uj7VL7EM+TphNJuaByiYas2aVEaU2e
	Ug==
X-Received: by 2002:a05:600c:c3c1:10b0:477:73e9:dbe7 with SMTP id 5b1f17b1804b1-483a9605cd5mr260176515e9.35.1772040296314;
        Wed, 25 Feb 2026 09:24:56 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb776dfsm28613875e9.1.2026.02.25.09.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 09:24:55 -0800 (PST)
Message-ID: <74553709-23f6-4e7d-a7af-b2a9e509cf70@gmail.com>
Date: Wed, 25 Feb 2026 17:24:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] extra io_uring BPF examples
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
 bpf <bpf@vger.kernel.org>
References: <cover.1771850496.git.asml.silence@gmail.com>
 <9c8d6af7-8546-4409-91fe-85f92a08f503@kernel.dk>
 <d808f483-3c0f-4323-8faa-0b7d49c539e3@gmail.com>
 <a7e1f667-04ba-4fe5-b21e-8c47e68213d3@kernel.dk>
 <b22117fa-84ba-4f9d-982a-bbaaae35eebd@gmail.com>
 <CAADnVQ+8VM8-G3X1UT8_t1tt5=62fxqknHPND40JNsQ51P_XVw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQ+8VM8-G3X1UT8_t1tt5=62fxqknHPND40JNsQ51P_XVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12419-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 941D619B8C9
X-Rspamd-Action: no action

On 2/24/26 18:54, Alexei Starovoitov wrote:
> On Mon, Feb 23, 2026 at 7:06 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/23/26 14:39, Jens Axboe wrote:
>>> On 2/23/26 7:32 AM, Pavel Begunkov wrote:
>>>> On 2/23/26 14:14, Jens Axboe wrote:
>>>>> On 2/23/26 7:11 AM, Pavel Begunkov wrote:
>>>>>> NOT FOR INCLUSION
>>>>>>
>>>>>> Alexei asked for extra more realistic examples. This this series is
>>>>>> based on top of v9 of the io_uring BPF series and implemented as
>>>>>> selftests. There could be more, but I stopped with 3 that should
>>>>>> give an idea how it'll be used:
>>>>>>
>>>>>> 1. A QD=1 file copy program that show cases state machine handling.
>>>>>>
>>>>>> 2. A BPF program rate-limiting the number of inflight io_uring request.
>>>>>>       That's a good example of what users asked for before but seemed to
>>>>>>       be too niche to be plumbed into the main io_uring path.
>>>>>>
>>>>>> 3. A toy example of how BPF can interact with registered buffers.
>>>>>
>>>>> Let's please keep examples in the liburing side, where they can be
>>>>> with the documentation too.
>>>>
>>>> I got you a liburing example
>>>>
>>>> https://github.com/isilence/liburing/tree/bpf-ops-example
>>>
>>> Right, but that's just the nop thing, which isn't really interesting
>>> outside of doing basic verification of yes indeed the kernel side works.
>>>
>>>> but need to sync with the selftest. I think I'll rather keep the rest
>>>> into a separate repository instead of adding all helpers to liburing,
>>>> which will inevitably do similar things but deviating in API and
>>>> internal details. And it's simpler on dependency management instead
>>>> of requiring libbpf / etc. for liburing. I wanted a space for
>>>> misc io_uring bits that doesn't make sense to keep as core liburing
>>>> anyway.
>>>
>>> liburing should have support and documentation. It's not that hard to
>>> check for libbpf in configure and either build the support or not. Once
>>> various feature support ends up being fragmented in the ecosystem THAT
>>> is a mess for users, I'd much rather have it consolidated and deal with
>>> it on the liburing side.
>>
>> What kind of support do you mean? Installation, removal, other BPF
>> management is all on the libbpf side, e.g. skeleton open/load/etc.,
>> and with it generating new structures for each of them, I'm not sure
>> how to make it into some generic API whether it's liburing or not
>> instead of making users to fill in the gaps, nor I think we should.
>> As for figuring out right helpers and abstractions for BPF program
>> writing, it'll be a gradual process, and I'd rather have it
>> separately, it's not like I can reuse liburing for that.
> 
> The cp and ratelimiter examples make sense to me.
> The 3rd one with xor kfunc is a conversation starter.
> 
> Since liburing already has "cp" in examples/
> I have to agree with Jens that "cp" as bpf prog should be there as well.
> Spreading the examples across github and kernel tree won't work well.
> We learned this lesson with samples/bpf/ long ago.
Urgh, that's the reason why I don't want these 3 to be merged. Neither
I was excited about wiring any examples as selftests, but you asked for
something that can be posted together a while back, and I obliged. Maybe
there is some misunderstanding? and if nobody needs these selftests, I'd
rather drop them entirely.

Ok, I'll copy paste the cp example to liburing. And there is no BPF
support I can add to liburing as it's all mandated by libbpf. But I
hope nobody says that I can't use io_uring outside of liburing and
anything and everything should be shackled to liburing, there are
enough examples showing the opposite.

-- 
Pavel Begunkov


