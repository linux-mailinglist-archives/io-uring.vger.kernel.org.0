Return-Path: <io-uring+bounces-13353-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPTmDwcqB2resQIAu9opvQ
	(envelope-from <io-uring+bounces-13353-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B01EE5511FB
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 992DA3000504
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74AE421771B;
	Fri, 15 May 2026 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="VuNC8V61"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACE047D93B
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853902; cv=none; b=C+64azoEa9+9obMnY7vEnHvWtTp43K2AkfNBo94QoUi9me4k17tuGEzIg6SJ5pDhZ16PIuMQ63yBGeOKOtej8H/YSKp93PY8DU4T6qPJMCm6qjqOasbSiDe/d1RGPA4aNV7U0/x6piHBq5VWZCS0kehHEixfbxa84+w5g3LapPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853902; c=relaxed/simple;
	bh=JqktXW/5n+RkTw2u+eeRD19Y+s9wECY+hNjunBA2ark=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mDVXVdYuZGYNSWn6bZvamGR8wK12mk+YYZBO1zuhM/e0cyQLiHP3EnR3+1xgsEr2L2hvVYhXjM6wqUlAQtaL61EjIDbi+yDvUV6Tw5p8gKLLs0EQEIxkN53ny9vVhIHWnqpImT+hG9rPs5CcBz1bn53TZs0vWLibaplmVcjXdkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=VuNC8V61; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e4de538f83so885339a34.1
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778853900; x=1779458700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qa5WkmLYfl5O5HePZG/1LY1cXG3nwQYMN7evwKBu/fU=;
        b=VuNC8V61PpqeQ5gBwmJCxSkCqyJy9b8tNezE+f5FHkZ9h+wsmXPkJSsJwk/uc5HDX8
         zg6BTNelN0v8ApnFAFUorZnWigE/IRQfT1tQ8DHixF6A8A+1GMSvsVwnJlrnpIC9BP+K
         +q69pAGI3roCy8SZEwP6tXQfDBx7mASY616BLp1A0ham3FjY9yswPSdj5Z9yJX/lCvM2
         3Fy3g4qYZHLl0Djn/U0jUBX0ajPMj4vMwErlw1NhGxvGCbjtndPAiZTBGXaFTruFelAI
         PNX1K2ip7s9BnfbjRaLahhtKqDXO3E0hkSP15KCNawsbdSyLBvEXEn17E5ZwzZjFnh5f
         OZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853900; x=1779458700;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qa5WkmLYfl5O5HePZG/1LY1cXG3nwQYMN7evwKBu/fU=;
        b=T6N7tyDA+J+XQ+KzD3ngCE9ajwxfQDAN1o4jlnsd8z3/85AiAWGQjOsU+lAbXI5K8k
         YVz7NP4poWk0GRulbIkdsV+AmV/laAK82PTBfxtWAucPHT2Qa9KYdXGYL+DZlvgM21kt
         OaYYvSLTwFPmNhIBNbNpuV4bDXokIYzClhq+Ur7xQKU05IIhmbAgzCHD1ky1YegAIsvz
         Mru1wid6WVRCvNqceGrjEZ5sxJ49yi+6tuQSkLzhjrZtSc8kotmUd1wMOeBuvtpC76dz
         75UIVLvuTBoGIKv/Pe7eAZbOE1NvFEaKbrK2eOamJY9hkbNASEJfp32TH4W1ccE5gq7a
         bYcg==
X-Forwarded-Encrypted: i=1; AFNElJ8o05JAcPFX5P8a71MYj+NI/St/D8lZjdrvBx3pQg+cbpvbOhR44nYUvQ4PXqjOWrQ09T0m12iOsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbydre8/p5TVqUTv4Zzofw4u+X0yXRuVjzf/Mc3d4UjuKp5sUs
	b7xTInuPNQiQt7/S/FKsT/gSuwx6k4Np+0+ts7tWFjXdPbXIkztghKrhAz1wUD05MGUcBDje7od
	+E4eV
X-Gm-Gg: Acq92OHhpkHz3ezTjiCfmJbvk02R+Eye2oOH0UpHVu7F+vSQfdx2vjHvZw2xA4PBUoy
	ZOYRMu0ux+4xq9Tn4brnyS5cJnCC/I/l/OmLOaUR+RdFSscpmmNlRG6s3L75kiMydSpNoxRjuEP
	JK/UsRAbVgMemqpdPeAiuL3bQ+/vSGMjByv1M5os4eaDb6a+e8H8iEjcoEViWJv75xP2P1xppGd
	KlcuQcMR4FLw2oZdUngI12GrQpmMu5SDoMmF+T2RpMDyPfdzW8kyJFlvqIejSFyDE/gjOz0oNsD
	aGSWRQ35FKZWVBCCengWrcOd0OapRLQqiQm67SDLHt/Js0L1xmIv0lUwhEFA9axBm6YeZSOCFb4
	bePTi2vO7cAwXnhY/+s5jgkEksZVhaK7uXoZydzTJ6ABP8sJ6aXJHJz5suQ/d4LX0X0wdCSYNjL
	0pSq9H+IUTPTw9UaMmZNN3NLqYEcvnw8aIjPsJlsSQifJRArnC3WJTG/ZYaf+nIHuQDK6esQvii
	IGNFArL
X-Received: by 2002:a05:6830:3c0e:b0:7dc:dd91:b5b1 with SMTP id 46e09a7af769-7e4ea032147mr2628097a34.5.1778853899533;
        Fri, 15 May 2026 07:04:59 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4983asm1319072a34.26.2026.05.15.07.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:04:58 -0700 (PDT)
Message-ID: <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>
Date: Fri, 15 May 2026 08:04:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
From: Jens Axboe <axboe@kernel.dk>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
 <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Content-Language: en-US
In-Reply-To: <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B01EE5511FB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,ntu.edu.sg,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13353-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/12/26 9:47 AM, Jens Axboe wrote:
> On 5/11/26 4:19 PM, Sasha Levin wrote:
>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>
>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
> 
> If you auto-pick this one, please also do the other one in the
> series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
> to do just one of them.

Hello?

-- 
Jens Axboe


