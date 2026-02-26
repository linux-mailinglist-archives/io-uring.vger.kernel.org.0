Return-Path: <io-uring+bounces-12438-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEP3EOaIoGlvkgQAu9opvQ
	(envelope-from <io-uring+bounces-12438-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:54:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC0C1ACFF6
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 18:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EDBB43250C6B
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 17:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA815387588;
	Thu, 26 Feb 2026 17:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2PzgK5t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A128750C
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125429; cv=none; b=IIHUft9cxk/w1M2JkvjuW/5YF6JIemolm0OcRd0vuSFBaUF2t7YYbSpsJ36f043e12Ba3e19NTdqV75jiLBe6SYyL2KItTw3OpTJ5SV3GDqBdqCDULIvWYqgUTsPC7X0sOdpjsRwuVB8DnO0RhMos+ISEfrkGIyhjA8tr4vu6CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125429; c=relaxed/simple;
	bh=xITEBstCtnOQTT+cV2L2O05rjfmZ7EH2MfwP2PHC+iQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NDg29JP5iglYJ/hMgkMH8aMe9dNBOkHj3uC1e8vFkZNJFlq7nsnL88twGJFD0MnWsHGafsil/1ISrSdEOtsHA0m7VxgX6i1X03pXAaYObVbwZWHg6LO2klnLYwpClyiLmJXVjuuMSMjPujnvQiYJ3ZvFi5VnpNhj2q+t0woOBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k2PzgK5t; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4398e850783so788795f8f.0
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 09:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772125427; x=1772730227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=355oSSj7VP8telyuoPVvlsy7OWwF8jIDTynqvDCl3+M=;
        b=k2PzgK5tYInVum3r1dNR2gCeHVFgZf2tdalqBuxhT2NM2N8ozhTyjQifvaYRjRAGxp
         5YOcAZJRxJX48+NyUOxTv2zR5MBp7zNGqC8f1UTm921GltKjgASQcXRGZ63ZgMjtR4Ll
         jJtX8IAswm9FCiFJ1dpoNKN6Skv+yL1P1dNjH6TjBwaBZF/e7Akw4TvSD7SzVu6NjHgF
         XDj2rP84lTVaz+EgvvTEhxZnxdiWLxTT2+2E59Gyzcalsya9MNE5+lg2F6wEQRCyxYkO
         yzmMsEyqcpmcKIDPNMWXjWVn6hDviUCzATTNW6RneRK/z8lMaYgceYpn1b//AHvTQCEY
         Anqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125427; x=1772730227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=355oSSj7VP8telyuoPVvlsy7OWwF8jIDTynqvDCl3+M=;
        b=DOIHmUjeurzp7ArxmGxAlr1x3HnQXBr5eGWdEb5RpKFtvuW8+Kp5x1qOtZQqvOZRuM
         N+XI1/S/bsQLIqqFlzyok9mjMhKEqvcA3CDGjMgpq3FtBhOCPIQR0xbufznNU776yf2p
         ADzQS/FPA7j8IEKL+vs2gM+HApBARsFpMazxcdpARiS+92Fr2GoZnS6c9hznjM5IFAwY
         jzndutWh1Tb4QFfYrqP3dhMe1E6bh6Qmny3fjPI6k2z3EcBdwIgLGg8qKND42onkgdtX
         k5L/E9/pwfi+Gz2jVtBEnJc+bex+DMnTY3UW461l9Q3NbhF/PPkJwVODuROtlZsKAQed
         lsgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKFutW/iLhlXW1tMVSvcT26hBAPdtypd0raQbxALzG4XZwRO8aAp4O47oIRn7XMdUoMQG7fqQsdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu7Up7U1nyw1DoSDblba7y+VRMeg8ZpZgK24mSodqiDg+hF7a7
	/vnLJnYAkOLIwetXsCMt25A9EWXjISBuZA2R5O6WCc3usujmk3T3aptaVDlkWA==
X-Gm-Gg: ATEYQzwvu3x22Gf3mZCkbs91PmNZ9xrs3hEedPuCSC+kNTZiPUBLHJA5OrNg8Lj3Deq
	AGXevc/a6NLXlc6xu3rZu9C9IwheYT5cZEBpEVt5c8/FNe+bJeRQKJsrz8/m0YbDgWXuC6M40cc
	v41mTRCucK+hLoJRgLRsWoK3KwsKrvXN8KxfOQLVOuwatfNf3W4a+cWiDOXl9MOsr2aRSfqHGWp
	vR6ujXesyVvPgIM6CtzlgOINPNXAVerVs8lV3REP2KxxEct3T+pVqyqpAFcTu0+fEnzuQzPeh47
	CDDiMS2QdZjxZr6wTf8d0z9CwWCPd8l7l0aaDmq863v/3XWk4y8TwaLZ10DNjp1NAzNBG1q8Ccc
	8JAmv53mt98VeDxyhheaX0CT9MviQ3peOv/ylNqmdtO8YGz+4ZRKSZEykDc6HAaD+wIT4FrfH1L
	DUnVO7PryMAg/coB0YszD13Bmc/M6n8yrjQaVtRjskxkk9dQ5SbLWatUP9es/6YxseePNDmyaKm
	dQRDq2lcb8XTq0UWJUbIWpuaZEbzPskcbox3uVaHWpXyaDHOCLz0R7wnZ1h9iBd0GsiuUKmPveh
	ppoQyJgtbhI6
X-Received: by 2002:a05:6000:2508:b0:439:8f32:8668 with SMTP id ffacd0b85a97d-4398f32883amr13720064f8f.58.1772125426406;
        Thu, 26 Feb 2026 09:03:46 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c75b8afsm849784f8f.23.2026.02.26.09.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 09:03:45 -0800 (PST)
Message-ID: <981224e9-0141-4117-9304-41b72d11fc9b@gmail.com>
Date: Thu, 26 Feb 2026 17:03:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 1/1] tests: test timeout with immediate
 arguments
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
 <58b12176-0b58-45e4-840c-67fc2704da4b@kernel.dk>
 <d718db45-cd6c-4d89-ac9c-8f073d31eaa7@gmail.com>
 <8b987673-33d8-4f0f-a13a-1c1f963f9afe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8b987673-33d8-4f0f-a13a-1c1f963f9afe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12438-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DCC0C1ACFF6
X-Rspamd-Action: no action

On 2/26/26 15:16, Jens Axboe wrote:
> On 2/26/26 5:52 AM, Pavel Begunkov wrote:
>>> Applied, but there's no documentation update included. I'm just going to
>>> auto-generate one so we have it, we should not add new flags without
>>> documenting them in the appropriate man page(s). Same old story...
>>
>> Looks like you've been generating AI slop for docs, so I assume
>> you're not against it? I'll try generating it next time.
> 
> I think calling it "slop" is a bit unfair - sometimes it does get
> nuances slightly wrong, but it's a LOT easier to fix those up than write
> it from scratch yourself. And the the language is a lot better than what
> you or I can produce. The icing on the cake is that I no longer have to
> nag you or others on documentation - though I would prefer if you or
> whoever is the submitted generated it and proof read it, I think that's
> the better approach than me doing it.

Well, whatever it's called, I might just use it if it saves time
for writing man pages. Does it require any attribution / tags in the
commit? Some Assisted-by?

-- 
Pavel Begunkov


