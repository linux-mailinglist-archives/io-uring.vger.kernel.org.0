Return-Path: <io-uring+bounces-11744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08859D26444
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 77FDB300A2AB
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C612D239B;
	Thu, 15 Jan 2026 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cNyEGiHb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1163E2874E6
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497563; cv=none; b=P+ZDndbpfJdiDnK1IbkLqO+fhD0C0KIlneBGM5Bor2gyyv5OyjcIx3mD2UuW3/q5U80hfjd0ScIMrVHEAkiTb0JA9Ih24NDb3yPZ54ZaGnFzUmuMJPjtdkrHdJ2EPpfafYvK0LcsOtQ4yb/h7hUCTPanX6qbOsE69CO+/JwNs2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497563; c=relaxed/simple;
	bh=/He3edvB2blZEgQmgidZ5RsJlgwYL7egJ6e3i1o1Vr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goEr5FZw1LHk5bc8lBJztTHYMxBCp1LfqdXjaS5+psJZB4aak34XlwY7LiFfoDnxiuhG1+xi3GyCn6Ut4iVnsC3eZg8Y7ghBUkx2V/3kbcwfwv0+kO6fp8qX3/MVF9GQva9tMpdZmCD63tmTXmp/GzIs6P1LbNZt86KyhRnAzeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cNyEGiHb; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47ee07570deso9556315e9.1
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497560; x=1769102360; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fu73EEKGnenyt9XB8VRFiZ51ibtBjayhHUthCdYttXE=;
        b=cNyEGiHbpR2DLyh++pzoS0qbH/x11779ZFg/OJkCpVsCNnPZnHNvpb9QVfY/Br09b5
         dTOqsbt7Ha9XduTuyiswz2+EZmHtjnGwaEwkigbcWLSjMj8V3QHLFhmUIhgIlgGcuv5k
         2fBAUmosOcLv8SyC9hmLlAZ/6Crng93jFp15MGmgz0OT3g/GpeevEUtu3hI9diSB9YU6
         0z2kcB1f8qCow5WXtOOJdxOQS2b0nI+Y49aY28+kVIq3nmdfiWXODlU/YvCTL9y1JueE
         d1XI20gPKfSeWWLhQUga6QKTqc53b3Tw/mnx9S3hsWbC11JF3nDUlSJDd0SuOdHSV0WN
         YhRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497560; x=1769102360;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fu73EEKGnenyt9XB8VRFiZ51ibtBjayhHUthCdYttXE=;
        b=NpTSqOQCOn1lVZ+NZPsV9JjFnyhY7qYOFg1hXIw8J22k2nbV2GVlTAEw0Rqcee3baC
         ozzsBgDan0p1AwR/E5iRgIGn25SD+Ec5FsYD2tHU7PN6AJd9ouZXhlhlI6VqKizM2dXL
         JtQ2+NKgvKJYSgPWbtEQ3zfUSZSNIJ/o5ufOwHPunu+H48rkLz7Ve/XhWGOc5w+Aby/b
         vXaeXGJ7q7UGG7vhcwXGtSRTtfWkPe5TopXUAhWXAGriotYumh0JRNQfe0KUU50lDvrb
         wRbZuO4mLvfyvlepR1KgN0WevTARscv4CEDUf1JW733Y8Bi5scVYzO4VRp17ijah/kUP
         6GaA==
X-Gm-Message-State: AOJu0YyHTMg21pI/V+jVyNM9yGwvEatlQivMruEjT7AYZtdxh5p39pPX
	yeIEvhIW8eSHzVX7I571XibF3/imfbG6JcOhwWG+obO41sQys/d3YK41
X-Gm-Gg: AY/fxX5nuZl4kju9bolPc7K1YzIdvrPq3YezYqjfpE0xB5bm24cIn51d/b7wMgPoIuJ
	6+U3TdhjNQRlJ74R7MdAdP7PKOKC/WN4xhg4PXHrrTIB86Nulot2UFNvTvZsJzx4vLGThUFbQuV
	3h2pBiLGLSFy3IP/K1gDGrMY8O/6pFRAo1CtWgUcvyr1dNKaahYcs4eVCoqxFdDPOMJDz+EfTMq
	7xTlVQskznapV07Od8BPvv9AhZP3PLOICCPKilaspRW8zXJI95Cx7e6c9hAT+8n5d6HmCWldoHC
	1c5ux0tZczjVtJGLS5MJN3UttNfbC03W5NncshKoJZQB/gl8bWftVR9OkpqTcwk8i23DL0A2PBN
	o7VYYZrokSaZLyiqUcNE1qn+5qxYQMdEpxAuXdV+6XUvT9c69d/DSEneNly3r+MtQQjuj4t2KgT
	N3lrbW7WyJdM2TbLhkTXlNzRfBiko0oBXx1s64TtEJ+JbgN6GN++AzBo4eHjEoZhWRNwRj2ASGZ
	4jIUCaKvoe2y/PJT+TF6dbR01Q6OeaVbPPKw4VhKKtNRf/dj3PqRRDOScoOkqM8xEWErh6NwDkm
X-Received: by 2002:a05:600c:1c2a:b0:47a:8088:439c with SMTP id 5b1f17b1804b1-4801e34c7f7mr6141755e9.35.1768497560155;
        Thu, 15 Jan 2026 09:19:20 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dadbsm148771f8f.21.2026.01.15.09.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 09:19:19 -0800 (PST)
Message-ID: <4158ac4d-b55f-4eab-8e42-a89555d3b2e5@gmail.com>
Date: Thu, 15 Jan 2026 17:19:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
 <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
 <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
 <d8f24928-bcc8-4772-a9b2-d6d5d1bbca72@gmail.com>
 <988a3d72-a58b-45a4-8d98-8928de4f3ecf@kernel.dk>
 <53767b80-846d-47ee-a69b-f037a9a2d4da@gmail.com>
 <1c9a7c71-fc6d-4630-bfd5-f0e567d96e85@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1c9a7c71-fc6d-4630-bfd5-f0e567d96e85@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 14:14, Jens Axboe wrote:
> On 1/15/26 6:06 AM, Pavel Begunkov wrote:
>> On 1/14/26 23:53, Jens Axboe wrote:
>> ...
>>>>>> And the compiler is smart enough to optimise it out since
>>>>>> it's all on stack.
>>>>>
>>>>> Not sure I follow these emails. For the normal case,
>>>>> io_validate_ext_arg() copies in the args via a normal user copy, which
>>>>> depending on options and the arch (or even sub-arch, amd more expensive)
>>>>> is more or less expensive.
>>>>
>>>> In the end, after prep that is still just a move instruction, e.g.
>>>> for x86. And it loads into a register and stores it into ext_arg,
>>>> just like with registration. User copy needs to prepare page fault
>>>> handling / etc., which could be costly (e.g. I see stac + lfence
>>>> in asm), but that's not exactly about avoiding copies.
>>>
>>> Those are implementation details. The user copy is stac/clac, and then
>>> the loads. This is what makes it more expensive. I don't want to be
>>> writing about stac/clac in the man page, that's irrelevant to the user.
>>
>> Confused why would you be thinking about putting that into the
>> man page. I'm saying that it claims copy avoidance, but there is
>> no difference in the number of copies. It's also uncomfortable
>> that it's in a commit with my name attached, while the change
>> wouldn't fall under the "language edits" note.
> 
> Sheesh let's turn down the sensitivity. If you want it changed, send a

Not sure what kind of sensitivity you mean, but no worries, there
wasn't any. I still believe, however, that technicalities like in
this case matter.

> patch. I'm trying to phrase it in such a way that it makes sense to
> people without getting into too much detail. It avoids copying from
> USERSPACE, which is the expensive part.
> 
> I think we've spent enough time on this detail at this point, no?

-- 
Pavel Begunkov


