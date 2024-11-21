Return-Path: <io-uring+bounces-4932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CE89D5044
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9915C28297A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20355156875;
	Thu, 21 Nov 2024 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2+yvJvs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA01132122
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732204783; cv=none; b=seR3VGIc26KNfjDr238rhtu5/49YGaTZG+Ir+Zb9f2+MQOR0HDBxblAEaQz8xRDrnsTMYnTGzW0MqFQXGy3902Bpd6lSi8It2vSKOmJ1CoAdUCXAFkRZEPvUNSCX0Fh6dnUzbWF6dABKDf3WnyNIB/eCXfAMOnvIkwxizX5CRk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732204783; c=relaxed/simple;
	bh=OsvJyLq+73hEs88UDpI/9w9HQiej80RjHwprvnALY5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CiPnwQ0sqSLNTEMbBKe2GZQajup94k3/jL3cjSlCXKLdX+UrwCY2RloA+T/sOmFlZS8x8XmjPzLETjxw+VD6Q+WxQEaEb35I8HNlQjr/VVUolL0cFghiVruPOcJVIkJcpzcTxpHgSlvZpe9zSLiqtRJW3Iq9SUpKtgFI+y/8oww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2+yvJvs; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so20295451fa.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 07:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732204779; x=1732809579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nKczFFnvjQfl2oczClmsZdIAWLlFm5IvR6BHU4jiK98=;
        b=i2+yvJvsNqEX5gG85zhhdYhD4aFD71UI8/b+RB90Due/JKqKHzWF6AkSK26ecupwGh
         flvQomanoLW2yQJMMyRe4ItvcHVJm86G4s5x6I8HtB3s01ggCwNqcjC6p1VFTcKfHDZu
         CAG9sz2GEI1CsekyffzlU2YX0u1eYGfaiyckap0Lb+a1xISz7pTCjVANo2pYFcMQZCvR
         T9JU91FsyngQCWMRk3b8xY6iidMDTdBwAn4cWqw1OFcxQb18D2wshaUFFFnzYYM1/UqF
         B02vwadMsBo0H3IpyWN2KBxYHyP20DGeYYoRdtXSTYlfciC1kgX9nxeZE7/3p6+c0+Dt
         PNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732204779; x=1732809579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKczFFnvjQfl2oczClmsZdIAWLlFm5IvR6BHU4jiK98=;
        b=lz0zYtVs1d3I7r71q2QS+QcaG9xT/F/0PoEVq2JvMTkUviBTEZzPWvUamu9Rkmtq0s
         5F3KCO0IJDyysg3wgnpkEdu98Pc5wnJxhmWp6BR9UDvN8VMSWXub/z/5giEnNhORhDFa
         zdVa9o5cKue7QGwxldUvUUhMU9MHpROADS5KNKyqYtKv4pU5NaE+pBfQH/vGEHefHS2+
         ZIZ55/Zg21ulOQtagzyYplkU/6Xt4U445Ag2CZUuuI0B1mEz4eG/bHCTqwEf5PcJlfR+
         Qxn2relOttd24OspX+WpdBMoWhXRcY1Cx6FPHwpyRaxXesFpf1cdqOeXxqa6kj4sYTL3
         FQ0g==
X-Forwarded-Encrypted: i=1; AJvYcCWrEXoV/5dfZ9oVI4eR+F16Q89PIFFV5qSgkrRl5Tyml6hbA6fi9raX8zYH6HW+sLIptgjMdwDisw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzCukoz+ShypqcNEAChJ0ZuERb14R8bP686uWQycZgeI76WzKR
	BWAR9beVVf1bK81uchhPTWHODP2EVvJw2S9nLZsZ53R9v0jn4QMRdDBtkw==
X-Gm-Gg: ASbGnct0qY5QtttlPzaKPu6bDElE2L8iSj8rqS9VC51HKxf+zN+Gi1XPSCS7au6o3bI
	Cd/wJu11y+rZNh7lwADixUyNYFFM7RXxt7t42ysfgsGFfJZX4cO81YT5ljH0bcthd96z2cxjw6A
	mMElqWhG9dKnVZE12X5SMPVWHt7+fbokvPSum2j3C8MkoJ7vtfU8lpqpQT3j+AtQqquSyB/DuZ+
	j8gF9yJcfZWJhO+qbZHPskQtENR41D1Uhjfw+w+WQ5hnaT7W+nKZHqwjyugDA==
X-Google-Smtp-Source: AGHT+IEcWIg5neQYRZ9eKANboR5y5zZyE0ijd2Bee2IMREiHoI3r9/BGEXB272UgrmXl9nNmihuPEQ==
X-Received: by 2002:a05:651c:909:b0:2fb:2a96:37fd with SMTP id 38308e7fff4ca-2ff8dc7631fmr73975601fa.29.1732204779136;
        Thu, 21 Nov 2024 07:59:39 -0800 (PST)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f42d48d4sm94064066b.119.2024.11.21.07.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:59:38 -0800 (PST)
Message-ID: <e0753760-2a91-406f-8b06-98528cf6defa@gmail.com>
Date: Thu, 21 Nov 2024 16:00:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 15:22, Jens Axboe wrote:
> On 11/21/24 8:15 AM, Jens Axboe wrote:
>> I'd rather entertain NOT using llists for this in the first place, as it
>> gets rid of the reversing which is the main cost here. That won't change
>> the need for a retry list necessarily, as I think we'd be better off
>> with a lockless retry list still. But at least it'd get rid of the
>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>> to this topic, obviously.
> 
> It's here:
> 
> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
> 
> I did improve it further but never posted it again, fwiw.
It's nice that with sth like that we're not restricted by space and be
smarter about batching, e.g. splitting nr_tw into buckets. However, the
overhead of spinlock could be very hard if there is contention. With
block it's more uniform which CPU tw comes from, but with network it
could be much more random. That's what Dylan measured back than, and
quite a similar situation that you've seen yourself before is with
socket locks.

Another option is to try out how a lockless list (instead of stack)
with double cmpxchg would perform.

-- 
Pavel Begunkov

