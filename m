Return-Path: <io-uring+bounces-12441-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2AfLGESGoGknkgQAu9opvQ
	(envelope-from <io-uring+bounces-12441-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:43:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B852E1ACB71
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26BA7311FFB2
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 17:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9303F368953;
	Thu, 26 Feb 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n1+DuIaV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF43368957
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125956; cv=none; b=dfI4GE6uvausCwDcvtZtxx1Hxcrs2DJfUV0HixgTXqAKj/XHoq0zRp6+JcvR+dst1DWImM5LyzCkBBt2Mz6ZQcLzPXOlb7cEuUENKPNIGjtUUXmm2/HrX6Ojl+yf7taMiWA4bciEHXV+Vn/zpHMEZof8cWm2XBZ5t6lFMCNoC/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125956; c=relaxed/simple;
	bh=mRK5S9Vep9wBwiq47eYVlF8MH3DEyaNezCTvLwK1er0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j8wtojOGNDtzhQOHl53xo4PdI/G8ajRUgHV8i7S7m32gYJ7MDv2aGGXITiT0AXMx8RXLf8w+NbIfuY5wssxgJhZCCV0LkSNCu2D56mZSRrspamLcZfE/wjrXICKy+hTUuC42DVFFw2va5eWTUC680PIoDKkYWmXz/FyCstq/Hho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n1+DuIaV; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-464bc03efd8so63731b6e.2
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 09:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772125953; x=1772730753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b9dNbM1c+OoITTeV6IbNomQuUIS761q1E0WnsmXt544=;
        b=n1+DuIaVJ98U2IT4nQAVfarnf/XLp5BhwgEgoKfmGfbwfLjcWBSZz4x4KcLC1ZzJHv
         woUXo6r/I804LWaQOAZC5sqnpY2u25veobubnzou1C7Ws9VdfopCQcd1b1V9796LOTT1
         iJwjqrcqAMNPoGc3/hx4y7uYWOIhVjaLcdJ+Rdh4udHBi15XlN/0D2UTi5uUElUUn1iV
         9yFuxTBNXu36nVQ/gJpYMbf0PqC8l5M4dQZzorfvm6N82JJZZ7IeAm+bEfygKkK9SW8f
         YX5J7wrC2wOaBTua8xtc1rscHwQQZPoPBhCF03by9uM/ZycnR/Ejhynm4OPCuMC8PXuh
         op8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125953; x=1772730753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9dNbM1c+OoITTeV6IbNomQuUIS761q1E0WnsmXt544=;
        b=GzbI4CJiD9lCBkqdnhgx6rXX8eUCJcouGikjL+h1jiLiQS5BbpFw06MWdwkCqFJyVm
         +YHVnVokog0r0vyezcpvDxgkNazhZ/hUItj0EqCLFVTGV+tnmhnHZNtiUFhpYG+wlsD9
         MXKhTa6jscYV0YmZZ9P76ulRyMQBv/dLo5a27oBOa9WghVEvIdJwCqGxNKHJVfV3+l8N
         nmMV5aBXluiD8JS603bltHlpR8qFTxwNQvojOFmmvb/YcSSlX29f5WDLHB6yv9Kbah2A
         3MW2od8jFzUPK8maU4KRB9JA3FJsNPsglvd1KAkNEiX7IZ7Kw4mfQbmK77H9QLP9dcXV
         bjDw==
X-Forwarded-Encrypted: i=1; AJvYcCWA7uSeWcS5+M+2+tQWXNJ9csWgtsLrI18JP/lBOJG50GMwu/GPtsUdf8sMsDvcQHEYPyTrBeOcKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YybN+vxLG3rdPUNm62Cpfq5JCWtLKdTweJ+0uIMySPx0iexqqDL
	/OQSlncMmhEx1uXkh1xIsEmu80vM3/58K+RNaRKcRyiYNvDrm2MZ8mhoOcdzB/yDOel44ItGIO+
	FWr4FP2w=
X-Gm-Gg: ATEYQzy9A3IIinrJcI+sx/fImjXVqjnXO1poyaR7OLsvQ7nuf+7lq40XI4/eyc7RR5B
	4NewHqoL9GhridA0R4chxGllCIYcqOZ0GeHhWkgXlNmV2ot4deDcq/I/D8diMsoH0nO8hyWa4LO
	XKzI7N873vU2o4k6QMhhGvMI9oWMfhl2dJXsr3QDabVFeQ1BU+8bZNU+dnskSiWj4X3aCYGeOfV
	0WPUigJRmBqyGFsgI06L7F9iQ5l3rSo1PromxsGCERhNyjvrQvrPmHRByboxjW7nMVyumTWQNNP
	glfC5Qn9wJdTHp7w8wDleKfowi9U6Ko1l6Ebg1qIncw29V6Ft4NRrxJ7K73nqWVMEOzoy+jQ5aG
	XmcdirwMIMMLPWvZnYg/HSl/YlX9+kR4wzVYtZjy01UUvr+1Gy91JViSmR1nYan/b2GKfskzZDS
	+OG009m5ifQWUASdN4814Nj/dkySwlBw8bPw/qq9RVhSH6IMaylw7fF3h2qmM9SzpTDbLiNQlZS
	YYy95453w==
X-Received: by 2002:a05:6808:1807:b0:453:860a:fed with SMTP id 5614622812f47-464a9544ad5mr1181833b6e.36.1772125953403;
        Thu, 26 Feb 2026 09:12:33 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb352720sm237183b6e.2.2026.02.26.09.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 09:12:32 -0800 (PST)
Message-ID: <0d21d5ae-fa4d-49f2-a9ff-a8a0600d0dc0@kernel.dk>
Date: Thu, 26 Feb 2026 10:12:32 -0700
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
 <4e3d774d-eae1-4243-8a6d-071f93bcf996@kernel.dk>
 <71202db3-1aac-4b0b-9b52-1f3d074ac41b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <71202db3-1aac-4b0b-9b52-1f3d074ac41b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12441-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: B852E1ACB71
X-Rspamd-Action: no action

On 2/26/26 10:10 AM, Pavel Begunkov wrote:
> On 2/26/26 17:06, Jens Axboe wrote:
>> On 2/26/26 10:03 AM, Pavel Begunkov wrote:
>>> On 2/26/26 15:16, Jens Axboe wrote:
>>>> On 2/26/26 5:52 AM, Pavel Begunkov wrote:
>>>>>> Applied, but there's no documentation update included. I'm just going to
>>>>>> auto-generate one so we have it, we should not add new flags without
>>>>>> documenting them in the appropriate man page(s). Same old story...
>>>>>
>>>>> Looks like you've been generating AI slop for docs, so I assume
>>>>> you're not against it? I'll try generating it next time.
>>>>
>>>> I think calling it "slop" is a bit unfair - sometimes it does get
>>>> nuances slightly wrong, but it's a LOT easier to fix those up than write
>>>> it from scratch yourself. And the the language is a lot better than what
>>>> you or I can produce. The icing on the cake is that I no longer have to
>>>> nag you or others on documentation - though I would prefer if you or
>>>> whoever is the submitted generated it and proof read it, I think that's
>>>> the better approach than me doing it.
>>>
>>> Well, whatever it's called, I might just use it if it saves time
>>> for writing man pages. Does it require any attribution / tags in the
>>> commit? Some Assisted-by?
>>
>> I'll save you a lot of time...
> 
> "_I_ will", looks like AI already replaced Jens...

Oops, missing a t - It'll :)

>> I don't care if you put the tag in there or not. For the kernel, and for
>> actual code, I do believe an assisted-by tag is required. But for
>> documentation or liburing, as far as I'm concerned, you can add
>> attribution or not, doesn't matter to me.
> 
> Got it, and I wasn't planning to use it for the kernel

It's most useful for documentation and tests on the liburing side. It
does a pretty decent job on the latter too, mimicking things like "skip
on old kernels" and that kind of thing. Needs a bit of nudging on little
things, but once dialed in, that part is a big time saver too.

-- 
Jens Axboe

