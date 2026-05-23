Return-Path: <io-uring+bounces-13489-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCpdC/u/EWoNpgYAu9opvQ
	(envelope-from <io-uring+bounces-13489-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 16:55:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FE65BF7CD
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 16:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F2AF30038F4
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD0C305E32;
	Sat, 23 May 2026 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Moo/DtEY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50C305968
	for <io-uring@vger.kernel.org>; Sat, 23 May 2026 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779548150; cv=none; b=cDbQa5VCJlV1ULSqiZA6qsl7lqwQ28w+IAYZC+gVwDIAD6X1WC3ocnnzbYP0WW5Kijd1DaMSo0llpMbYsrPvubZP59pekYfxPlbW9MQt8R6Uzk4AxbEueYyp/hMDADK56etWzXieMxt099us1bhSBg0Kv1IVr+V9GK6PpVT/SRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779548150; c=relaxed/simple;
	bh=MOtTruu7oCpPtDhl/HWaJcw1a1JNAc9mlPuGoIepHx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gieu0SEsT4lNRiNwvV/2wDiCFebuoR1BIOs0K8MOKY6gm1Bygxt0SwKx9mIYKCLwjGG8ehcED6XHZeEIMNZ+DKfSMyXsRJ2hBB9o6bJF42P7/US+a8gTDd/5UWgUYQlmo56eGpsckRCHBaOCH3a6BVLvk9qH1+H0Qbo2rFb2HMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Moo/DtEY; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e61e251966so171358a34.0
        for <io-uring@vger.kernel.org>; Sat, 23 May 2026 07:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779548146; x=1780152946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GfL9Mnhn6RS/dK9GHgYTlaEa86j6tsYvdObuz5oD1iU=;
        b=Moo/DtEYzp432jVgesyu+21Tih+zq9Lh+pZhqKVcgkAOBZs07TFQw3s7FmvEf1E9gh
         JOiQL4t4+eFeMLeDHvjZsED7tlmP1kO8AZtUQcK3zPHlGvkythlzSfgNZg6EO5RBlKfz
         T/XDmGQCkMRkLTpK7O491b+pQdxXG5fawYEbN/I4hQ7ERxa7abWD5/HAKOr/BjyYQ2+f
         snDrjTOs+4etr2Smtbo30CTpu4MXTVP7dIQasgzovrEHOtOs1CLTikLiAv2ra5HkU4Oi
         BhMKiUNqL17JLzyZ6XxjZ2wtTxBIt0a4ALavTNXyfwqSlgHhZ32ps1VYoGrZ5lBD6wVF
         GI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779548146; x=1780152946;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GfL9Mnhn6RS/dK9GHgYTlaEa86j6tsYvdObuz5oD1iU=;
        b=CCW/nL0xvjejfck2Bbez2OpyoOx+zEhaL7vSdoojS66RXG5MjEppP01pmedL+WSIR5
         HsUN9eGYPO1Fg2FZx8kO8sMlH7fZH64b2d1Gfg455Q1tEWWo3aHhscb3B/Fup42SH6A5
         MRyqecUrRvFlWccfiZERUpyizFMdNpEToDb4MMGVcbSKNoyMhn/7CMVA76E9KxhDy/10
         ajymLXKsntwhbVvzw5DqxWXCO1EAmAcXOJ7ZG3yah6B3DvAJVRe2oNms9tq3C0LPEbNJ
         s0iJ0RXtAGp35Dr7ZZDEwP1sPD6KGJ8mrDGD/7GUlPRbB3+p+Hij4dbl8NG26jUi1YtM
         Tuow==
X-Forwarded-Encrypted: i=1; AFNElJ+GfptyAWEbtLwH00d2uxZ837VcqUXxjyYcPJYNK+lQ34T8H3BY5DGzxY5d1VX3nS0+vGdRUiYdmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbO3DzXFnl2tFyMpeS60L01j1S8/ja/s9kmOku8PS+FJWcLOzr
	NCq94lAWlBsaoz9XBxlCEgxwNi1ITX2Td7VYgKqDUQ8J7W/VeEjy5VvtG8rNkStDORY=
X-Gm-Gg: Acq92OGSaOvBG9bmfweuOgc+9xhYh2IMExWOQs7UdVivofqyl+TE0jRJBb8mG/nrC/1
	mwv0I9nBiO3Zxtw54vyBd0GqbHfqnHWViuxt7xdGEQPCgfinaQ20OF+Z+/B+/d3JeLl/IfakTm+
	BZ9rwi/TBKKlt6dc7J/mz50Bx4/fjHq7/JeIGfZe80PDqswgnchpzJTvyVgqiaIt8GckqYptrkv
	bbGUXr9EyJcMLJZFshFbZH1SZKjTnyj3OGuKIiW+kpNAJa5EXxE3yLG0RzxmHFPL+lOJ0P1M2iz
	61PK2qVLPTzHz9vdcKEyx+88/SUtv1Wfk/Ncoz7nkxr8wKBinP4plgz3x/KYS7xIUkFhqJYuZiX
	bbujpV3vlTbERYPJY6wyWM3MwiyN7YGhHuQSE2Ioj6oWqpA8HIVMJsEbHuzOVV0eP912vG3bg0E
	602RfDVQYa6z+njJ3+hwzBhP10uC07Wr96v9vcQeTvIvyRWMWK9se9Zqhe/cLhq4hxPHbfipMzu
	u2CfVWX1A==
X-Received: by 2002:a05:6820:180e:b0:69d:6696:846e with SMTP id 006d021491bc7-69d7ec2609fmr3926788eaf.29.1779548145739;
        Sat, 23 May 2026 07:55:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b62e4211fsm4959511fac.0.2026.05.23.07.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 07:55:45 -0700 (PDT)
Message-ID: <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>
Date: Sat, 23 May 2026 08:55:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
 Maoyi Xie <maoyixie.tju@gmail.com>, Pavel Begunkov <asml.silence@gmail.com>,
 Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk> <ahG9meYUQ-YLDwHN@laps>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ahG9meYUQ-YLDwHN@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,gmail.com,ntu.edu.sg];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13489-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 87FE65BF7CD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/23/26 8:45 AM, Sasha Levin wrote:
> On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>> On 5/20/26 5:40 AM, Jens Axboe wrote:
>>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>>
>>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>>
>>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>>> through io_parse_user_time(). It therefore does not pick up the
>>>> time namespace conversion added by the previous patch.
>>>
>>> Once again - If you auto-pick this one, please also do the other one in
>>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>>> do just one of them.
>>
>> And once again, no reply. What is going on with stable these days?
> 
> Jens, as I've mentioned in the previous mail, I handle the AUTOSEL
> mails weeks after I originally sent them out for reviews.

And you think that's working fine? I would suggest that's a terrible
process. How are maintainers supposed to deal with that? Patches x and y
are autoselected and an email is sent out. Maintainers react to that,
either saying "no don't pick X" or "if you pick Y, please also do Z".
The expectation would then be a reply that says "ok, doing that" or
whatever might be appropriate there. Instead, it's just silence. And now
I have to follow-up MULTIPLE times to ensure the right thing is being
done. We're about 2 weeks into this particular incidence, and
hilariously, I still have no idea what the state is on your end. Did it
get dropped? Did the other one I asked for get picked up? Nobody knows!

At least Greg actually promptly replies for the non-autosel stuff he
does. Which is the ONLY thing that makes Fixes tags and CC stable
actually work. The AUTOSEL stuff, it does not. When it happens to pick
the right patches, yeah all is good. But when there's a problem, the
process is terrible, as evidenced by this particular patch.

> The volume of mails and patches makes it really difficult to give
> prompt answers here. I have no idea if
> 9cc6bac1bebf8310d2950d1411a91479e86d69a1 applies cleanly, whether I
> need to ask for a backport, or whether I should just drop
> 45d2b37a37ab9848 until I sit down and get to this batch of AUTOSEL
> commits.

If you can't handle basic replies when running AUTOSEL, then I don't
think you should have that process in the first place.

> If this process doesn't work well for you, I'm happy top skip all
> non-stable-tagged commits for io_uring. This is supposed to be only a
> best effort attempt to catch commits that slipped through the cracks.

Please don't do AUTOSEL for any patches for any subsystem that I am a
maintainer or co-maintainer of. Until this part of the stable tree
process can be improved, it's a net negative.

-- 
Jens Axboe

