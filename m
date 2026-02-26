Return-Path: <io-uring+bounces-12437-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ME4zAxNooGm+jQQAu9opvQ
	(envelope-from <io-uring+bounces-12437-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 16:34:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D3F1A8CCC
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 16:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C2B531D2C6A
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 15:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BD414A62B;
	Thu, 26 Feb 2026 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MOBxmg9K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5B13ED134
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772119012; cv=none; b=pIFJbCf4V+F+TdYRIPVJWgshPKwb6S1XJDPorjnZXpUvwMXTxdIJ6QteSKIGtI/Ss66X2Wm+zdkvvqnOo90EpokkZoQncfMjWPPhpKjU11GAGhHZwS7wsmA/yad5W9JnTLVqGAYT5c7x1yq6E2Sqp4UNCN2Xd/kHklPM/0XRTpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772119012; c=relaxed/simple;
	bh=g1fjdqMJl99LL+ZtXpSyFqF+rOcyne26mjLTrtBwL6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=brpWuexJheNPeehOgKKsf0/pGxz4731r2G8LB/Co3j+TDmjbEL6Yumb5+wfFc7ky1AX7HK0B2YHpRYvpsMi4XjZDl6Se8SG2kQ78X+deh8no4YmIe0cQaUwilqvdgDo0qB8VAdUj/RQbyYdLZbmh8mOqBnBXc6Hlf0w9diOqVxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MOBxmg9K; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d4c68f0e47so514963a34.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 07:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772119009; x=1772723809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=67qiLF8RIYVeh0A0wadEVhmj7fkJtJz/8wXIgwol/tQ=;
        b=MOBxmg9KgmXnYjIAwK/rVzRfrxNJ8K0BretPoSrN7o4OPMzRZdsDM9+n/DpRLqEmHW
         cKt0XLhZexb41y6k+7N+AmEeCpIejGeTiOzHL8/zSQ4nHK2Wbvjt9yhmtTVkklZeKnQo
         DKCmy4+aPRGlG0DNwsdWVDzI9LPk/P+wmHvjOqwlNCNlz9QhUK/aJ0Cdf3BFWPZz95VO
         WWxJTUFlsSz552oXrl/9JqaL9gKEQr4eLDo9XnmqZ9OtZEFGNg//W9f9je+cd814Y7aD
         y6MIj+p4VECNhNBkQ1uwhCaCZqLj+8Y1hUS5caOvV489Dzs3T8/OYNG36SE1GAcrLCkl
         jF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772119009; x=1772723809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67qiLF8RIYVeh0A0wadEVhmj7fkJtJz/8wXIgwol/tQ=;
        b=p8ZbQBxCVZAjt4UJgcbKM8oy5GhgXVeF2ry0dgnipuaeDtDDwi+BvQuUggKuhnaIlN
         Kk6/8N5G+aB3t6pa1SOvq1JV5ALm/bNIlLPQgkAOGMGYEQseW1+B+20dNMLupg2PRkZT
         FyyCQjShkzIxLOUOR0xtb4reg1um8Q4ysc2fJSud6i8L40C31kkcXnzcmLc+0nqfQL9A
         +eqw4w5DDc2kn8xpzFSMUwCnaOQpuqaX8r2DreBRSmBAOGs54Lv8u/c9N8xt40E1OLs5
         9NPs8U3cwHvX6bGqeZEl/Vmq9UOZV2SbumL2yqU1k9qfwJuysP5X/Qz/XqpSAkQe4Tjc
         uy7g==
X-Forwarded-Encrypted: i=1; AJvYcCUa8AZ8czs6h7jdIkjXMrt9NrlLenw4REfPAUP35enS8ZCs2LmAGj/VUO8VRPIwiKhdORtQBfS4mA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxG5kXqx/nmwra9OmOXxzQeFC/yZH64hKmRz4lRN8tDDFwnecv6
	Nn1tsePt1C/v8TB5FU93U7JLcqwrbM3AbyGlk4tLKthFG8JxfnDnN1YI9kAI7Q3b3Vc=
X-Gm-Gg: ATEYQzywre7tCz4oB3/4C3CTMvChELvM/aIpHYOvyqjeraSPz7gHh8GgLQjVK3ET5HQ
	8IyrHVsYfR56uealearh4KOQzVwxaipFtbxMb0Nz/048wYnj/1vrrIXTWnmF8b026VyagPP0ycJ
	mjkouk2Ihumqz1WrjCPsrSrb0KjlLdE4s/6+4QXmtdBmGlzqZolvSPd7p1Y7QNWGgZTh0xOmCCR
	b6XFZrNmZXD0FT3aKU46AeH08bNGgMJoPbpbVq4mwPPc+e7xS3oMVSK8WgRmO3c2Q6S3IZrNqGh
	6pcYJbqeNUl76DO97JPZ2e7hUGNDegTwsvASlKoeLoFulKyw+37545nr7Gc0PBUy42bCLbK+u2p
	CDVfTbFml1Iy2rRx6u8djqpAJuegEhwUjZrKRgIHdgd2xswLd/Az0jdTPts7r5KN0kRpmEOFdGK
	x7hP0R85JoenZnK82NTP3zxViHox6SRPxa4G2WKuqnRmhyXQDsviJJVPsG/+LxiBp7+CKZk+Si6
	ZSSiWYgmA==
X-Received: by 2002:a05:6830:3c05:b0:7cf:d119:8c1a with SMTP id 46e09a7af769-7d5829e5e12mr2434199a34.7.1772119008720;
        Thu, 26 Feb 2026 07:16:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586226d14sm2007312a34.0.2026.02.26.07.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 07:16:47 -0800 (PST)
Message-ID: <8b987673-33d8-4f0f-a13a-1c1f963f9afe@kernel.dk>
Date: Thu, 26 Feb 2026 08:16:47 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d718db45-cd6c-4d89-ac9c-8f073d31eaa7@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12437-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 61D3F1A8CCC
X-Rspamd-Action: no action

On 2/26/26 5:52 AM, Pavel Begunkov wrote:
>> Applied, but there's no documentation update included. I'm just going to
>> auto-generate one so we have it, we should not add new flags without
>> documenting them in the appropriate man page(s). Same old story...
> 
> Looks like you've been generating AI slop for docs, so I assume
> you're not against it? I'll try generating it next time.

I think calling it "slop" is a bit unfair - sometimes it does get
nuances slightly wrong, but it's a LOT easier to fix those up than write
it from scratch yourself. And the the language is a lot better than what
you or I can produce. The icing on the cake is that I no longer have to
nag you or others on documentation - though I would prefer if you or
whoever is the submitted generated it and proof read it, I think that's
the better approach than me doing it.

-- 
Jens Axboe

