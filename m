Return-Path: <io-uring+bounces-10100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F13C9BFC282
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:32:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C37E14F62AB
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 13:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA64226ED3C;
	Wed, 22 Oct 2025 13:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g8bJ4ve4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A87526ED24
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761139071; cv=none; b=sDZ5uiV6YYsYoqiMW26T+4lDNqfmE34w4JCiUajHy/3Hb6EjJE/FD7Y7u3BpWemY26BPOMdg49UlCTZdI7OJqY7oE/xJ9ekZemFJSTXKX9mWh9inWxB97TlEJg1cJO2RmgbsJ5vOEVriL7kBDdXmSoE9A+UgzCS7iGyVsLbf5KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761139071; c=relaxed/simple;
	bh=bcHlOIBD3oxp4mVOg26FIl6pVq4j9LipEQCMx5XySDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXhws4XS/PsOaACgfBNVYlW0nOSO09xaB63PjAbGwwY0nOvyDq1eWvFo98OmMe5QKj5D+HhfBMvUdOzW3lDg/oMMGmasP88a3aKNohWPbtxEdIDZLCktNrPe6I5y+nk5CGTkBQfCA1CowfgWEV0/jAvw5rrqnjhkX+eUdhtfwAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g8bJ4ve4; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-93e89a59d68so179487439f.0
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 06:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761139067; x=1761743867; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=io5+b/Dl+rJ0SS6Ga9nnU2IbdWExfhLs1otAYNw8S+Q=;
        b=g8bJ4ve4V9ohSIXFB0RJhey2g4lW7qipKQQudvfzB8VySoMFuoMtTvSFcIs5MzT/RV
         duRcWpLROGiT8rLspXqwzfsKYTakWrTzndGj7rrlLeZcb2KtPYnRk89oVR2sxCQHRy5Q
         l+AuvYTvD06Wov7/EWGviz1U92UTwV/JZC55x8ZaAex8HVh8br7rfiJ3vofmA6OU/ryQ
         K3uDNxUMbaU1aX61GP0lrAVO8Blv0IQl/1sY6cEzcG6M7Rvt1R2iloodpd8oHlWpWYF1
         09AI3Ahb11cwQyEk3w5c+u5T/iiATEc1k27egIyaIqYqth5pOFCrq+x0LIEGC04WJL0F
         tBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761139067; x=1761743867;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=io5+b/Dl+rJ0SS6Ga9nnU2IbdWExfhLs1otAYNw8S+Q=;
        b=XbFani/uWcuvxoNu4URqoSsQbTgrI+qNTsYNLOO9mf5Xe7kIdNKmqQlnzRQnoX2cWE
         BsVFvWFZEuj6re89Pt+EYvAP5TnJl1K5gwB3EqSF5D3BGqQRUrYu18MrLogDyV700srA
         4wAWi07YaE+JbfkdyDj4SAWVZVCZk3lWlwfHGsp0PhuqQC5viYZDi1OxMRf4n0Nw8AsJ
         tXQxOLez9wf99JzkzT9Uj6koNXVau98pw1tiON6RcQKptpkVUIDEEvPJr/ldtQEkql3B
         xNCS/dD+2lbjmmWCvUWz1qgrnziGJHoYASSDkk8ZRdWAOyyndqRJ2tsxKX0ikMFUoXs1
         VHsg==
X-Forwarded-Encrypted: i=1; AJvYcCUYzIv9rMSxPaYQnz+8prlgCAysNcCOzZnYG9nh7GZXCouQThdVsaDL3yyAFM5r2oxI7plmdl9ANQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwS76QJBPuZIfB7E/fU0tCGyqTNrvRXycsrEsEnK07lIbBf5PXe
	gQM8AArPGpsFHA6CSSWLWtGgJ6/qZl85xw2mCz+Cr3bLsUQwzBoV19F0yxrE/0ptQ5s=
X-Gm-Gg: ASbGncsw6jwPznEC/G9Zl+r68p29vVfPXn6Xjvf1Uvjad44xd746iWHlb5mnoWp72WE
	BtaAgK1LZKddH/AJgGC1ULBC90bMhpJy3AWcfa4xRmuriu3PVXy5xq37CVKQJfwJqIYExp4zT0f
	aZ3TFqM3xX6WzznsMQQgqoSNZeJc9WglrV4VXT+AsDhkSN9b9pKHSLxb+r8hWTv1Fjnv6hVBsYw
	N/FbGC/6aC+ls7el/qHx16Yx7za9xZbrQLA9KOXJfcmpatbmiqyM7L6yfvS/A94q1RpEmi6m8vW
	3ZRq9N5rWXABjpjBuLCVR6SU2UUAjIQRElG03gqI1NKFjwlxcI72M3ATF9X8tVecpy/W6ICqJ1Q
	XZI2uxrP0FzkT8NlhVL113ByKvpJsB3ZrT6K44wPfhBg6BkqKdihkmVD7bahPB62D2WAJxGP4Kn
	B/nSlJWE8=
X-Google-Smtp-Source: AGHT+IFxN/gtR5CCRmZKybvHgMrdakXUkYxhb+HjCqrJbjodILVkGXRUicgJOreSS8VpLkI4cMUplg==
X-Received: by 2002:a05:6e02:1d98:b0:425:7526:7f56 with SMTP id e9e14a558f8ab-430c5204a9fmr243210645ab.5.1761139067095;
        Wed, 22 Oct 2025 06:17:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a973ec13sm5035688173.38.2025.10.22.06.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 06:17:46 -0700 (PDT)
Message-ID: <832b03de-6b59-4a07-b7ea-51492c4cca7e@kernel.dk>
Date: Wed, 22 Oct 2025 07:17:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
 <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <60d18b98-6a25-4db7-a4c6-0c86d6c4f787@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 5:38 AM, Pavel Begunkov wrote:
> On 10/21/25 21:29, David Wei wrote:
>> Same as [1] but also with netdev@ as an additional mailing list.
>> io_uring zero copy receive is of particular interest to netdev
>> participants too, given its tight integration to netdev core.
> 
> David, I can guess why you sent it, but it doesn't address the bigger
> problem on the networking side. Specifically, why patches were blocked
> due to a rule that had not been voiced before and remained blocked even
> after pointing this out? And why accusations against me with the same
> circumstances, which I equate to defamation, were left as is without
> any retraction? To avoid miscommunication, those are questions to Jakub
> and specifically about the v3 of the large buffer patchset without
> starting a discussion here on later revisions.
> 
> Without that cleared, considering that compliance with the new rule
> was tried and lead to no results, this behaviour can only be accounted
> to malice, and it's hard to see what cooperation is there to be had as
> there is no indication Jakub is going to stop maliciously blocking
> my work.

The netdev side has been pretty explicit on wanting a MAINTAINERS entry
so that they see changes. I don't think it's unreasonable to have that,
and it doesn't mean that they need to ack things that are specific to
zcrx. Nobody looks at all the various random lists, giving them easier
insight is a good thing imho. I think we all agree on that.

Absent that change, it's also not unreasonable for that side to drag
their feet a bit on further changes. Could the communication have been
better on that side? Certainly yes. But it's hard to blame them too much
on that front, as any response would have predictably yielded an
accusatory reply back. And honestly, nobody wants to deal with that, if
they can avoid it. Since there's plenty of other work to do and patches
to review which is probably going to be more pleasurable, then people go
and do that.

The patch David sent is a way to at least solve one part of the issue,
and imho something like that is a requirement for anything further to be
considered. Let's perhaps roll with that and attempt to help ourselves
here, by unblocking that part.

Are you fine with the patch? If so, I will queue it up and let's please
move on from beating this dead horse.

-- 
Jens Axboe

