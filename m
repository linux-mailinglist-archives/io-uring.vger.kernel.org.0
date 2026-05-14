Return-Path: <io-uring+bounces-13342-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GE3VOLzkBWoAdQIAu9opvQ
	(envelope-from <io-uring+bounces-13342-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 17:05:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86791543B55
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 17:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B28333003837
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4268D36A349;
	Thu, 14 May 2026 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="b0V9uGIP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF713DD85F
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770977; cv=none; b=EPua/p30KWpFzbqBUY/CUc3eJ5hWo+TXiVU7AHTAjVQk1oVLzLDP+QoxTSXhYiLcbOpUTe/hNeWgAUdiQ0rYgVR8gaA9PO0E3XTDfO4COZOyJsEL5aHpDZJcdFlKawhX7RSWfVZBuc8U5vX7yMz9bdbyDwvqZenVpKFS28vR5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770977; c=relaxed/simple;
	bh=4dRNdXs+ZbQFEh7HdvDlQ5kzm8ECZphIE9quhtvh/Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xi0zvn451nH43ehE+O9p0NUYOKdr/0L33FpSRtRgZIqScq57AIGu5twyFwB4VNSWIVgvLapoGuDdYGHJHdztpN8eKylEtz94MxNmMAkcUZqTXxTMOMyhlyt6iZFxFyroN5R+wGrnISSOe/GnxQ13HktTmJsYnkJmlPs3IvBB3gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=b0V9uGIP; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dcc9b506d9so6578677a34.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778770974; x=1779375774; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2N4XpQFADIiuS69Z9IeM3b5dxgYX03EusdjYgIUxuV0=;
        b=b0V9uGIPzD0oxeHs2BM7W0iWwjfLqX9O77dcEb5wLx3R5ZmI1scyoRw9PL5hwYiSQs
         25KlnotJBxssuf2cOQq+gfr8442xcEGfqEQWyO/0xxwn231VPjFH32G39eXgCSNL+DT1
         kxM3xbl6bPiA9i7ribk9BfwDeail8Dh/GdeRPBBQd8rTeAa/1yeKSJfe3wsxbVLl6NdG
         Ayu3O4cwgN6PZmxeFhJNECc6GlEUt7EpJ0KY7ioDZdiP64D55ZJIVukOf0Mo9RPsJ6mm
         WKinhQeMYoFiAAofOG+7k/73sVICojY3PJ9Yr4N0mbt0wLMPGWcfe0lioq/lnu1cLq1K
         H6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778770974; x=1779375774;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2N4XpQFADIiuS69Z9IeM3b5dxgYX03EusdjYgIUxuV0=;
        b=UljOGrmmYVzT0yiZEklVmjBv1AJHHDjpovoT0gSa/E2XJ8+G9qAxeeLZ6eZB3wsx/G
         jTUcGKhyKewpNrD8bV1HWELApUuyE1A8NxES8bLNTaMO+Krq9N7ewXUtIliNftbHwXpf
         +Ko2pKRB1RttApYDmWQRCHqbkDSVPpU7qg+7qTP8JI83318WNS7g+QGmQylu+81ESNPl
         pwaahBLY9OBucQBYd3OmqkF4klalo6KXA/KWGUpcak9FfXLNEnBbeV5FhyB0Tzog3XJf
         BmiCtI+iGWflqUwyW4PATVCCs633Rt0FfXMwDquj+WDNay7xStNsD+Xq7BNLLcsCuhx3
         9aVA==
X-Forwarded-Encrypted: i=1; AFNElJ9Zt8Wl9Unm+6hnuFpLTJdKAL5yztDHZIr8S4XIrUSEPx8AQ28s+xkke4tPrR/ce87mSVhOmiC5ig==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4l/nIsKs/6R/z5KWCC4pLPi1IBb0bRRnsT+BXNOu2egob9qBy
	DebC99S7Y2bFrtTrKi4rr/ClxQqQpv9I7y7TU4LXVLKbu1QXrtT2Kd4noGxlGWfThs0=
X-Gm-Gg: Acq92OGmJXS/Yg4mY6pnMAIICBzD8R7GOBg9uQ2SpF4wGiE7JcwaCMk+QM+nTDz+0Me
	9egYDTaM0Lifeyqs018gNooolWPqs89DbBTxIRD7A5XKP8tFPRxD0O6fMzQnd4RK//KUfBw4bDJ
	zGLSW8/LrfTcijPKpzlERy9T9vgyVgA+CHJaJumICcRKhx0cvOcw1RX06pNolDEt4rz5W0xktAb
	ztMsH48JSnAtKd640N+pbzgYwQ2JgeGtN5CXTjGuAi54JesoSRi1UWG+PXCG5CK8ASw/D5Tv9as
	STKyRaG5CPf8/Jl+j9SjMgbr7vZCn5ul5XFELe6VdLR3pHwOWmoVcwswnktRiCsegrLsAND5+13
	3ak8hBM8OTS5FEyPeEjYwWUxBDIa+fLkq7iL2hR/byGrwx2JBdxT55QrXVemdRg65xchA5EUud+
	/gN8xg5Yjvl6lvi5vNBlOtrmZwxWKf6pU4dOBeuutsR0dyY+v5ZaTaEArttzoILbSmGWy+JdpXl
	PjGgtyw
X-Received: by 2002:a05:6830:7306:b0:7dc:d0e3:5bc1 with SMTP id 46e09a7af769-7e3dc8bdf30mr4665585a34.13.1778770973765;
        Thu, 14 May 2026 08:02:53 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e3f38189e9sm1933844a34.5.2026.05.14.08.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 08:02:53 -0700 (PDT)
Message-ID: <8f10cb2c-a61c-48c1-9b90-8685d9e7f531@kernel.dk>
Date: Thu, 14 May 2026 09:02:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Yi Xie <xieyi@kylinos.cn>,
 io-uring@vger.kernel.org
References: <20260514083443.203387-1-xieyi@kylinos.cn>
 <CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
 <49a10373-f2d8-4813-b9d6-25cd2a0f2fe6@kernel.dk>
 <87a4u2597v.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87a4u2597v.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86791543B55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13342-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/14/26 8:58 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>>>>  /* Mapped buffer ring, return io_uring_buf from head */
>>>> -#define io_ring_head_to_buf(br, head, mask)    &(br)->bufs[(head) & (mask)]
>>>> +#define io_ring_head_to_buf(br, head, mask)    (&(br)->bufs[(head) & (mask)])
>>>
>>> Is there a reason this can't just be an inline function?
>>
>> And generally I don't like cleanups like this, but this one
>> at least made sense to me.
> 
> The annoying part, IMO, is that we/I look at every trivial fix
> wondering if it really is just a parenthesis fix, or if it's the next
> CopyFail/Fragnesia fix with an obfuscated commit message..

No kidding, trust no one these days, it's mostly all LLM and suspect :/

-- 
Jens Axboe

