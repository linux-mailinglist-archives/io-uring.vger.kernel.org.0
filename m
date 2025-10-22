Return-Path: <io-uring+bounces-10107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F23BFC95A
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:37:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAD526E04E7
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 14:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2D934CFB4;
	Wed, 22 Oct 2025 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kn3BN3hL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9734C9BD
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 14:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143063; cv=none; b=T7u/JUVScPK3D+CxBp7LLVOuw8sZtwXVrLti7nI9Y4qmTYa/wJ6bmaFm798NyXqZdy2jPuSLquf56qHwoP6tBQt04vV7HWdJees4CKRu2EzgOQ3heDBw8Nhiw6AzbytQK90MH5Vh9Ad2PY8cFKkwpEQWJzPYEpvP+7KHMGKRF5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143063; c=relaxed/simple;
	bh=KiLb3Ij4kNTsI8p5dH+8PrPKjndGfKFXyCL4d4sUz0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqsUyZOgOXmZUqrZ0eu06O5+ldDiWSfJYu3sjUMbBR5SLMqC7x6qBsc1pfPW0Ke59e3Eg+JboeNpVpwPUsj0hwouFr453BXCr5bNnVhw3ApIjgi7dJnLYZeRlUM/06z0JNZblKTyuC25tFsCEmV99mg0z62k3+qVy68S5K7AKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kn3BN3hL; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-427007b1fe5so4623132f8f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 07:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761143060; x=1761747860; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cxCF3VSt3yJ/4Htvgm+f7POBa00pQ4DGvcpk5YYFwFI=;
        b=Kn3BN3hLjmTkizkKIxOxadJhSQLPWaoz05eSckFXqDqMMCmaNvPTl38yEbTFJGwvcP
         uyk4YABp+kCczzgYdW/EQcs9vHWD+LJyCRP9TjqwwK2lWsxbGK8cneHQU4arMJiTiLDj
         4vGOPnkYtpuAQnNrvGCX15PgTZXpyc0eLn40ztllaemrQ0XGh0C2z0t6ySmtg0wdGKBz
         4MrgajiBEstbQq40dGiPkyNuxVgE+dyqUhKZyi4FxHW7tYPg//zQEH5S8JAOuI55VwJi
         7wY1BJ7S9GYcw6Kr69i9fCKLd6f1dqSDWNAbTN2kQHoP7kHfd3NRBR8esXvYkA1exBP5
         L4sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761143060; x=1761747860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cxCF3VSt3yJ/4Htvgm+f7POBa00pQ4DGvcpk5YYFwFI=;
        b=c91Xxno5o8jaTav4XeuPQsT5a23+35acII1A8Fio/4E0+jmWX0e/agamp5FHzDi+Sx
         ZaAU2Zo5ZTSIy19xgHQT2Upji6SN5733P+YjsFcLEC8vipM1DO5q9Zpe+zEpk5T7fMaV
         ojhVMdHGonogaG6aCTciN4QC1Mo8qVARzR7gxXBt4fbNP+FhXW8g2eQWjh9CaeoEVPAO
         qkdg4B5+Hy5IVIXzIK4FFY1tI3J6/fW7g/6LXVlqeq0HZlbSnTy0N/43rIOrQrawfAsd
         49kWlzoWP0pBtdsV33dANuyoyeHm+sLr66JQi5vrVeTTwfW9/szoB36jHLlXLfJjNstO
         HEKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEClviNe3a/7ureu8Pgz+x71eVY84/sSdR6mtmRMYHA9UT9Lp9VsnmC/TMaJwZimcdGfsCNf+Buw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjbm4ka7f2rLqtCw+MNqc58FYmQB5zIoVvfnbKCSNYnWgzx0Z6
	QFC1A0paqxnWNvduP70legGqAVhn/c+i4ZKXV4A4vsvnlkAkQ1Zvs5bD
X-Gm-Gg: ASbGncudkn9+E83jPyEzt7ALilmUxYg/Awx2GnGUtW1LANrSyBmgJ7X2VtVrJYUox9l
	bGtA2394TaRXBx1Qv6pGX7gEzENhPMrczKj4o5dF9cXia8SxxyLNMkxOeHzEQchMaPYOdFNAMAj
	uly43NZuUd2rN3asx6cR1tkFojCnikseGVGRsHBJFtkCes5BhHhJTtvrslrRsud9pZEERtsPW1H
	NpFnngLwovoTZj/PLthz83IqgMN5uZOaVyvpVDq51q85YCTPRY4LalvqmgHpBiTglUjn6FOoUvF
	+efMkLrRG54PjqSQZFDssurjQJqVotJXE2hqQmoU5pZM3Qmivzf+/5K3o3sMcbt9BKrvYaq9KrE
	ZYjT6FaRovDhf4eyJuoCcioraaHgiezn9KZ+WnDfZdRCQNT4CkeVP+6mh2ObvWeE2IzSVEWX4Td
	QZKWwAc/hYP7PukwuZ8tsJ9YsDG5djvd+J
X-Google-Smtp-Source: AGHT+IFkTw7szOwawIqv47HRGrQT8MYYw4EHyKoRoa8ZcG7xMhhP9wIMt2VXTQKAISRkcJMJnQVZ3A==
X-Received: by 2002:a05:6000:25ee:b0:427:62d:132c with SMTP id ffacd0b85a97d-427062d135emr11501252f8f.21.1761143059543;
        Wed, 22 Oct 2025 07:24:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b576])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42856e45062sm1965758f8f.41.2025.10.22.07.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 07:24:18 -0700 (PDT)
Message-ID: <3990f8ee-4194-4b06-820e-c0ecbcb08af1@gmail.com>
Date: Wed, 22 Oct 2025 15:25:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
 <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
 <832b03de-6b59-4a07-b7ea-51492c4cca7e@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <832b03de-6b59-4a07-b7ea-51492c4cca7e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 14:17, Jens Axboe wrote:
> On 10/22/25 5:38 AM, Pavel Begunkov wrote:
>> On 10/21/25 21:29, David Wei wrote:
>>> Same as [1] but also with netdev@ as an additional mailing list.
>>> io_uring zero copy receive is of particular interest to netdev
>>> participants too, given its tight integration to netdev core.
>>
>> David, I can guess why you sent it, but it doesn't address the bigger
>> problem on the networking side. Specifically, why patches were blocked
>> due to a rule that had not been voiced before and remained blocked even
>> after pointing this out? And why accusations against me with the same
>> circumstances, which I equate to defamation, were left as is without
>> any retraction? To avoid miscommunication, those are questions to Jakub
>> and specifically about the v3 of the large buffer patchset without
>> starting a discussion here on later revisions.
>>
>> Without that cleared, considering that compliance with the new rule
>> was tried and lead to no results, this behaviour can only be accounted
>> to malice, and it's hard to see what cooperation is there to be had as
>> there is no indication Jakub is going to stop maliciously blocking
>> my work.
> 
> The netdev side has been pretty explicit on wanting a MAINTAINERS entry

Can you point out where that was requested dated before the series in
question? Because as far as I know, only CC'ing was mentioned and
only as a question, for which I proposed a fairly standard way of
dealing with it by introducing API and agreeing on any changes to that,
and got no reply. Even then, I was CC'ing netdev for changes that might
be interesting to netdev, that includes the blocked series.

> so that they see changes. I don't think it's unreasonable to have that,
> and it doesn't mean that they need to ack things that are specific to
> zcrx. Nobody looks at all the various random lists, giving them easier
> insight is a good thing imho. I think we all agree on that.
> 
> Absent that change, it's also not unreasonable for that side to drag
> their feet a bit on further changes. Could the communication have been
> better on that side? Certainly yes. But it's hard to blame them too much
> on that front, as any response would have predictably yielded an
> accusatory reply back.

Not really, solely depends on the reply.

> And honestly, nobody wants to deal with that, if

Understandable, but you're making it sound like I started by
throwing accusations and not the other way around. But it's
true that I never wanted to deal with it.

> they can avoid it. Since there's plenty of other work to do and patches
> to review which is probably going to be more pleasurable, then people go
> and do that.
> 
> The patch David sent is a way to at least solve one part of the issue,
> and imho something like that is a requirement for anything further to be
> considered. Let's perhaps roll with that and attempt to help ourselves
> here, by unblocking that part.
> 
> Are you fine with the patch? If so, I will queue it up and let's please
> move on from beating this dead horse.
> 

-- 
Pavel Begunkov


