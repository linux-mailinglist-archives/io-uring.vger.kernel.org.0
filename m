Return-Path: <io-uring+bounces-13628-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id GW0wDCjlJWo5NQIAu9opvQ
	(envelope-from <io-uring+bounces-13628-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:39:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A2F651B8D
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 23:39:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=BoRmB7qH;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13628-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13628-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FAAF301E209
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 21:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FEB64A8C;
	Sun,  7 Jun 2026 21:38:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BED283FE5
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 21:38:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780868338; cv=none; b=Xj6Cn89EY7r4LTiwZKtyq/020PKV4c+1rpIyTuBMFpKfL5AzJUL9Bg7YFrrudKbaqb9+3x5TB0gjA8iaYPYDRGlFU0MNF2KfMfMar8aH0f7gyuJ+VW0epM5VPaAsqT3JujALHDjHNwX6d1YwuWzTRc2S7qXGhDwn+OQlSvu2mLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780868338; c=relaxed/simple;
	bh=RSilU2t/ZER4YCl5+tSWK0ZW203lZyAlex34mPOIeMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+zdtHE9wqX8Nm9zMzmuwt/p+WGwI2LdRnJpC/BvNS2bRUDNgcFPWEABI9gSnEEfSu2/AcPzOvcNbTP++5K0a8nVgKdXZBHO7M2euaw2QVwvRz1zw/O7ZoJwnb83vXDB7qwepzWnnMGpQlKybO5iDwQgiUNUhQYTw19gcatAUPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=BoRmB7qH; arc=none smtp.client-ip=209.85.210.53
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6e21c47e6so1590155a34.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 14:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780868335; x=1781473135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJ2+eSNrZVDWt0D+Gk83Gowj8MGt1KeKbFMXJpG6Hlk=;
        b=BoRmB7qHGs694fdS68DcXsWEsglUx7QnP3fi7EUrEUVTlESrbGsC9dFT+4s08nJDxf
         zrRE02FCDB6CkCoruHo5UU5BX9ZCTqpUU3shceL+MLhVYor2z0LgDCQwQ/xGO/zcuu1a
         A0ob3G5WDfSHyyjWCtkwMxd2pigfyZBsDMUGKYasAXgOvA0KSLvcdZ2zo9Zz/fdqQ66R
         YJVmQcLGsAI2jZUDwpRPJhKlVk0nvFagVmt9L4OJVmC+aFBSrET/TbmHKxca7eNa6Yfx
         VLnX1L6OgeuAthgGBqakj9oK3WwlUQGjlVhVkmeLXryhLykKUsvcjNpHCVLD3vELPKcy
         Khog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780868335; x=1781473135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJ2+eSNrZVDWt0D+Gk83Gowj8MGt1KeKbFMXJpG6Hlk=;
        b=flZLr8jZjHMOyVDAT0tLmKAk1HDKqEaSXuiB1Y5tGilGFS623sa3VveuHNUyD1/6PP
         IL7Yv1DJxfHgdoD+TpsDKZsFemquLdaQtte9PIfsmVa7CWycHXkI0Bto0eWZpi55jqMp
         blpDqjPGT2I+ugCzRKLpTvO9XyISIC48nTf921reKso91WdS65AdiTiM/RTB2dCr9yyr
         gWY3ECIkxmlwrdU7N3dIwYcfEeMWURpN1QBmRGnorZiB003peHXeHoh68uuPe4LjZcUO
         OxbleGs9xH/4Q2QyItNo834tV/yztrP3pn5p5K6PNcPua5iRIXFgQnhMTTg25Kmnk0PD
         9DmQ==
X-Gm-Message-State: AOJu0YxH6SkwPeiQAsuOPnKsB/qqBIcxBawLdJK14jZI0XmpCh0zkgbM
	ZA7cM70l8Rk9YbbZS1PAKwhZUF64WBBUQgwYzChztadsnPn7g8gdSjMRVx0vKfK0jWo=
X-Gm-Gg: Acq92OH7XRQBRpTBc0eEWXYFEJY0Po9iOlrWQ6OuBTsxk295ZkFJ2HWPEoi4bIRApXC
	/TO+EdAsSLneuP8yo6YCPN+5KpBOvr1CYDY2nB7KdlXPgiNBVsC+d6idFgAkbWdyd4cO+EgUevt
	dkmEluM/jC85nUw27K3owtdowx8oq/wOXcYlEwnB4btDtluZCS2EgppkNXzpn1DTkwua1nMe7yd
	BF+X+UXkezJyE2mnY+t9Yjkumrif8IzQM23dbJPx75E1HMtpZkEXsPMGBIMHG/ChPUTIDC3XpyM
	6beLuJVuxR2Qxuu7wuU25n43PXvCprYeYTu3JkUSrU8lMRh5FN9YJTLaNgZkyGBMZhecYtB1xyb
	6XCUu1ourCklJ4tYLIGsItN7OfujqvhhMXRjj37hSDJEvQDVPsBLkL38PYO2DI51/zyXah/quu2
	976a2xzGdUHxadHjhyoyOvotO8eA4v1hfNMN4TPYMrhOf6F2icqYvaA5tEVK4KamIWBWbn2OzwE
	OdhHVSlRfG9ehuNS+y+
X-Received: by 2002:a05:6830:6d28:b0:7e3:d7d6:a4b7 with SMTP id 46e09a7af769-7e70c6884e7mr7674159a34.3.1780868335552;
        Sun, 07 Jun 2026 14:38:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e746a50bsm10658361a34.2.2026.06.07.14.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 14:38:54 -0700 (PDT)
Message-ID: <36351bf5-fb6a-4712-ae27-5b907452bdab@kernel.dk>
Date: Sun, 7 Jun 2026 15:38:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG io_uring] Failed RECVSEND_BUNDLE can persistently shrink
 non-INC pbuf ring len and affect later READ operations
To: Federico Brasili <federico.brasili@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com>
 <71417fb0-4060-4823-8e4f-f216ce0235d4@kernel.dk>
 <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAEr8jZDdiYB2vp9VJzSqq2J-GssH8GhrLYYn_2W2KAjYwDzSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13628-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:from_mime,kernel.dk:mid,vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 89A2F651B8D

On 6/7/26 2:08 PM, Federico Brasili wrote:
> Hi Jens,
> 
> Sure, attaching the minimal reproducer and the output from my Ubuntu
> 7.0.0-22-generic test system.

Great thanks, I'll take a look. For the record, please don't top post
reply. It makes a mess of conversations on the mailing list.

> The reproducer runs unprivileged and demonstrates:
> 
> 1. non-INC provided-buffer ring with entry0.len = 4096 and entry1.len = 4096
> 2. IORING_OP_RECV + IOSQE_BUFFER_SELECT + IORING_RECVSEND_BUNDLE on an
> empty SOCK_DGRAM socket
> 3. CQE returns -EAGAIN, but entry0.len is changed from 4096 to 1
> 4. a later unrelated IORING_OP_READ from a pipe using the same buffer
> group returns 1 byte instead of 4096
> 5. a second READ uses entry1 and returns 4096, so head/bid accounting
> appears coherent in this repro
> 
> I am not claiming privilege escalation from this. The demonstrated
> issue is persistent provided-buffer descriptor length corruption after
> a failed/no-data RECV_BUNDLE, affecting a later READ operation.

Right, I believe you already mentioned in the first email. It's just
a bug that can cause the app to (rightfully) get confused about the
state of a buffer.

And it's not a corruption in the sense that something else writes
to this buffer length field, the kernel is deliberately writing
to that valid piece of memory. It just misses restoring it when
the operation fails.

-- 
Jens Axboe


