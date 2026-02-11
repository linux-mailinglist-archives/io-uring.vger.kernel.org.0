Return-Path: <io-uring+bounces-12164-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6A9RB2rRjGk1tgAAu9opvQ
	(envelope-from <io-uring+bounces-12164-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 19:58:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C56126FAC
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 19:58:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6DCEE3002933
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 18:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3C334FF47;
	Wed, 11 Feb 2026 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATcBO3ZQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B2413D638
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 18:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836325; cv=none; b=KvUbz0+WuGIWTXGvYZn6TscdIunPue3RKfrFvFFHdsvt/encAxeMbxmhBR6lChhj7/EYtW/MqNqkJyxDeaKljWcx9A47XIRD6wUynhybUO7BcsCLDpkIBLUgHD340lqgWLweZKpAzc7v6LYGCXvgYZZK8zI/w5zGMeFVZ07yABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836325; c=relaxed/simple;
	bh=TYF0LNel9Dh1kqeyOAurV7Y9kXCPZcqgn85QIwoot8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmG15f4BxBLx3C6rAFGgWkJWOoW4RXRE1hoR6pnK1XmdknIqvQDc8Grx8/kKmc0Q9m7KXSuCZGfII7mPtgMIL2M3gr0W9X+O+dPPltckaYmbm6Mpn3SHHCi52s4rJunSps+tC6w+EWB3VHfY+d3IxQgB4TtvgfZQ+LQ5IfPnFDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATcBO3ZQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so28276375e9.3
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770836322; x=1771441122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rS7ExVQwY7zAOHUgSx6QZkP4tbXT72iphOSjIQmbqWw=;
        b=ATcBO3ZQ6qFreRdDHWOaM8QqpmeM8aUmUWhQzPgv/BMB0GJupuewTQnHIQqAmm68kX
         0y+12YDK1XKx1y0fSE9DiEtaXw3T3QpmtQ+zXhHGcwh7ctTcMuF8jZXR69ErIPNF3rrx
         gCeVkEXbyx3l/IZicuk4hVMXByXDL2+PCHFgGphvqJewRB55vfMkHmppU5T51Fnwv8Iz
         RPtGE8DSC9l2iuVBJbZWuoJrtXSMnalg6Bdd+93RzURj0iQoUhtaO7d9ZmqS1f4oEUZB
         anIIkQrBF+/gvHqPIDp/mjt7OkZJ7LjV8FTyCmVs9YBTxEK9sgdlN5CaZ0Puu4mmpLQg
         Ec0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770836322; x=1771441122;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rS7ExVQwY7zAOHUgSx6QZkP4tbXT72iphOSjIQmbqWw=;
        b=vqbvH7IK/FfP7EGQ4qjYYdaCuFx/YxMRT1tiGElTcsWwlZXs1JEt02GEzieISX0JFZ
         +OkbvB/o70M17QBCRx0oBini/LgVbIV4Jf5Q4xRKcnLmPiZqKho+ymoq1qOHoSY4ZQC/
         rJhXyAm38vKW36F7gv4SToiIUdmLRWf6MgkFb3s+/IIQNNmkYB84vvBp7U95t6aRrtDv
         zRHQjFqr8IpFJKQzIVFbQ81sYT7K7JTvEdcGrnHrwHanxcnpSeYVVLVSEGIgjRWdawKC
         UBIyGyDX+0sLtulJy/+UVWTE6Xmb766qN3PaRpjSu4Dt3FEYlCY/Sz5QVduIMnDvWZuS
         8O7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVavIwro079r4HbWNd/fix2quESHwbT+ttcHu/aggM5ifCJRbxrqkbv/zOOWYYTNhGpMAB00tvChg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7tEEY5WiN/bASB3xWFdaKEF2Xw0j8T6SDZqG2c67YvurYttcd
	gxrspLugYicmDC+P9kSXtdKOE+eZytBwzKV1rTCemUmaIqXdSNENyIVS
X-Gm-Gg: AZuq6aKVPk9meXozzX42Xe9kEmBYM+mrethrAjgDxJuHh8ki9d2i0x8ZArJEk58Pqr1
	/XMgLsuQrWYJdKkV2Ie9sRNvcgaBW8x3c2E0jnl8WLlADfMko72bFJrIxUsTcDLI0hjwYG6WDSl
	l6sTq3bhCbZYNGra1jOyqnBYWMKALvqntAsvEp+2wfs32dhz50BghCmb1H7N7HTndWxl3L4PE7R
	/c4bgaE+XGzcHXuCTlzScxAvNz0ed6ZSXGLU9n1ze9X7dOGAkekpCIJzP3oGmrxU+Q1RyNYpNRn
	VbklGGBNn4cUiR5QPtLPNTuA1A6kiOV85K+BNlPaWOtSU1SaWelDUnpav9D6Tmt93yHKNT1WGDT
	YoXBouT8ma46AMrOOvThy8QkNMbSUXrDE+SwY9xJetbyJ5d5XXw71HUsNUJuTjKvqsD9RrfMX2l
	QytVHvBlXuzLnL3KsPsr8VQWP2LGiZIlIsc4cYc8UWM5Mn1yQqKdOMs69GRP0r7ChFBMalV+NSF
	VG98m56QdRv97n1I0gS8I53tFdyDcbUh4+fseSZZoqoo/H6YP9XDismmPp7hM/qeJvVS2pIV7Qw
	q5KmvgKROQcK
X-Received: by 2002:a05:600c:548f:b0:47d:264e:b435 with SMTP id 5b1f17b1804b1-4836571010fmr2027805e9.22.1770836322271;
        Wed, 11 Feb 2026 10:58:42 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783e0196bsm6653831f8f.23.2026.02.11.10.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 10:58:41 -0800 (PST)
Message-ID: <1e797bda-a74b-4873-9bfe-f7a6a6263dd0@gmail.com>
Date: Wed, 11 Feb 2026 18:58:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v5 0/5] BPF controlled io_uring
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
 <90c1f09e-9334-4036-a6be-ad7d2f91bfc7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <90c1f09e-9334-4036-a6be-ad7d2f91bfc7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12164-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 28C56126FAC
X-Rspamd-Action: no action

On 2/11/26 15:24, Jens Axboe wrote:
> On 2/11/26 7:32 AM, Pavel Begunkov wrote:
...
>> It might need more specialised kfuncs in the future, but the core
>> functionality is implemented with just two simple functions. One
>> returns region memory, which gives BPF access to CQ/SQ/etc. And
>> the second is for submitting requests. It's also given a structure
>> as an argument, which is used to pass waiting parameters.
>>
>> It showed good numbers in a test that sequentially executes N nop
>> requests, where BPF was more than twice as fast than a 2-nop
>> request link implementation.
>>
>> I've got ideas on how the user space part while writing toy programs,
>> mostly about simplifying life to BPF writers, but I want to turn it
>> into something more cohesive before posting.
> 
> This looks nifty. Do you have a repo on the liburing side with some
> examples to play with?

Nope, it's all in a pretty dirty state yet. The selftest is pretty
good in that regard, it show cases a fixed QD workload. It's easy
to convert it to reads, and that works well, but I guess I need to
add something to show how to use the memory region to pass
parameters, e.g. iovs to readv reqs.

-- 
Pavel Begunkov


