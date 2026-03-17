Return-Path: <io-uring+bounces-12728-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCpAFhmguWmiLQIAu9opvQ
	(envelope-from <io-uring+bounces-12728-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 19:40:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B76602B1086
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 19:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A2A130125CB
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 18:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44242DCF61;
	Tue, 17 Mar 2026 18:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dapNCNKJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9189837FF52
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773772624; cv=none; b=ADkDEJhHI516emOgRSWvI/wDQu6Tr4xkNQz2/tnJU4PVJsGEEHD9ICDvFiPSHowK4gJNO5aoCQlofi36EWorLygUia2TXKUl9fysDYSt0dEXRuQByxIDK38xD9ZX0C/pe1iu/Vmmfvu1hR77rn4TkQwEzIHC7fMuBm+Bc0fD7KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773772624; c=relaxed/simple;
	bh=SgHYwEy10WMrwo7Fo2YkYINsi2ZIznGWcmREYJcGsxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5aIw+z6PzT+6tq5cYVQB5iwnSLKjVoImSf8ATO3j/DXE0+ghDBpZGWT7Ewhr3TrniufMY+5tW/BCUJA3a0TXpieXTU6KQbt8AtBanDKChFERdNEoYRUh6F5C9UNOyBHBzqitzFqYLd5aqeO3d9wYkLe7JSVa0zotvfrMC/1oMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dapNCNKJ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439fe4985efso5402573f8f.3
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 11:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773772622; x=1774377422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SoJjf3gAvXMhb90rRGek41SVWMBcK1Nx8nSSPxZrFfc=;
        b=dapNCNKJwkIef+vb5opak/f+uQqiaI6mcq9xR5Kh33ko+TnnPxG+bNE8LON5eS6pm8
         noktyom+xa1VORjLSBKxYQpoUyRW8SmPW3xlAeWZiGyoXNBWW8X+LeEUGH15vzKvipg7
         KYxM4G+sdMhWNpw8EMGFmTj/2yEDrYK6IEB1Q5x05FXBgIu828XgjEctkUaAjMZI6f+I
         MoqoDTFmQIEQXNaX0J/X4iVHRMw3C5DOaozKwK+Q/Vvq3qS9RqOAGjmEOgYKMTPVjp7q
         LTRKGs+FcsRyZV6EOvjK/IE3oVjZ+zOhCut7wjKf7jHG1ORMn99po+VLvFKz8gKymKnA
         5UYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773772622; x=1774377422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SoJjf3gAvXMhb90rRGek41SVWMBcK1Nx8nSSPxZrFfc=;
        b=hrTdzD9jMcxlB22puaULWPOmDIilMUU5JR5sgbsAFF7lixhMwSaict9s5WFdjqL57x
         1H/hhh8zi+XM3CLFRjOPRnA8Fly6u4wp5Gen2tVGs8m8j5zy+W5PEEH4Z8+7nXKQo48r
         V0Y1t19zOTbcLIQDjgRiP/PFESeGp4bdfTLMjEopXFTRji7M1H2JDD0ZPJkl1Jd9QSet
         z5obuGHHMuEndQBF83TVk+xKnq7dpZmkuEvDI8SSLPkpzgP5cAwCDfvcZ+LzSFJeRdIb
         B024qSHxbFIPR47eIEEvcm0N848WDaVIKZRw0OXUDlQYa80TW+MVMIz5V1R13OZJ3Ah9
         rfqw==
X-Forwarded-Encrypted: i=1; AJvYcCX5A40ls9fUWXFj78g665nXj8cHmIcwg5fcq6s/TIkfcqQs/TZQ4fMIC+xF//7uSLEAd/bYXKFsmw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ykQPsqfbhheFUzpe1Mdy7wmbACFoGl96NeT9+Fos1sP9D+Jo
	vPV2mJ0NrsZo73r5KC5Tr9vhG5KYnN1P3A+m/xfnEQxM1FkC5Y67g6jnZyr96A==
X-Gm-Gg: ATEYQzw0MaJLKWZr5Z3pGGg8zUb/Sy/PV9WQupBe2kZQ99g9WBUVJdMjYdXqHbGDzvI
	m7t+xr9bv26yN4c+o3KQugTizbqtXB1L64vEdUEZ1+3JA09rcmYZ54AJeMWEIaGsBqJ3Y92BIHN
	R+fQ7oYcYp90N1ft79UbFnFmskLhD0nQnqDztRSfLhkm9ObNM2yKe59D0QT7D9gCDoFHLUE+hIt
	+mQG7cs32HdCndbjAHgCkYbVtXyEgfIfNQgZpTK3eeo+6sQJ9GbWGECoBGcgC4TljXwLKo/NGyu
	nhlZ/rmddNEFKk0d+XdKm/Hr2FqxO6BYTcsUyKRrlMbN7IjEVmZzQYvbgTrC9oLeXbYa8GdNBHJ
	GF6gSnoXG+l24guNcCb6blEbYvqnMF+r8WhZDsUhR42cFYF0yw7+6EWdYAIj/GP+N8U3wIk1zwo
	qt+Tb6Rum99wE91xJ+490tAQLQRtL8l2+MORuH4a/3HcpoSW3P9BiBwhUkohwxEq5+2ZwkMRBer
	fbau0ruhqrELt2fhoo23WcAAJQjgRRgd8stGriqNmcwHpxj0qYwroQAbwBSrBmMFspYbggEss7t
	hg==
X-Received: by 2002:a5d:588b:0:b0:43b:4a2a:2cd4 with SMTP id ffacd0b85a97d-43b5264f8c1mr681578f8f.0.1773772621734;
        Tue, 17 Mar 2026 11:37:01 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51852a64sm1173080f8f.14.2026.03.17.11.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 11:37:01 -0700 (PDT)
Message-ID: <1e05f8c5-0faa-491a-b62a-33fcf84b96c9@gmail.com>
Date: Tue, 17 Mar 2026 18:37:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Francis Brosseau <francis@malagauche.com>
References: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
 <06a8b8a6-2cf0-4d1f-835f-06f4070402d9@gmail.com>
 <edcd0d75-6877-409d-8350-915349395a7c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <edcd0d75-6877-409d-8350-915349395a7c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12728-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: B76602B1086
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 13:07, Jens Axboe wrote:
...
> Right, as per my earlier emails, this is what introduced the issue for
> AF_UNIX, when the INQ support was added. We read the whole thing, and
> INQ is correctly returned as having 0 bytes left. Hence no retry
> happens, and the EOF is missed. We could do something ala the below,
> entirely untested, which would ensure we retry for that condition.

static int tcp_inq_hint(struct sock *sk)
{
	...
	if (inq == 0 && sock_flag(sk, SOCK_DONE))
		inq = 1;
	return inq;
}

Assuming TCP doesn't work either, I guess I was curious whether it
gets shutdown but the sock is !SOCK_DONE, or whether inq=1 is correct.
Just thinking out loud, maybe I will check later.

-- 
Pavel Begunkov


