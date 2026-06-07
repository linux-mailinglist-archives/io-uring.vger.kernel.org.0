Return-Path: <io-uring+bounces-13634-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 85nONMjtJWpgNwIAu9opvQ
	(envelope-from <io-uring+bounces-13634-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:16:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C7466651CBE
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:16:39 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=yx878YQa;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13634-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13634-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DD85A30015AF
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 22:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC7C213254;
	Sun,  7 Jun 2026 22:16:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421184071C9
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 22:16:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780870593; cv=none; b=M4F+1g27Gn4/nT0+t0Gy+lMkzN7MnAN/qWOJiBHPhG/TnrMLaTdjHrc+IItewJzaK2e5qreLlRcZZfu5hH4cyD9dLe2RfGWkFtN7SgDgCmy9ge/XmIGPV2DZteXiCf5aVurNIe3JRkRtfeUFVLgz45JMyMaCHRWklNp47NVwnEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780870593; c=relaxed/simple;
	bh=qR7CBVfGLJ+l3yhncFwZwl2bA7rd9F5cfCualskyvn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hfm81bz+scmSD2Bhyx0tm40KD6wgeihDQ7UOLKuSta5+Mo1YBnTnGEWIYE4TeFY4tnr73psKZ6MneSRy1kxLUZO2wnTTVtDn8NwBG3bn+Ye1PKu55NYJCJbt41hfOp1mM6We3I2k7giBdDJ53kWfpQGv0/fyInc/0U6hdx3Zap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=yx878YQa; arc=none smtp.client-ip=209.85.167.175
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4864abba33fso2827695b6e.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 15:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780870591; x=1781475391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=psqd04aJkP7QA3jViji8W91dqePEua5iJRalD0aVCuA=;
        b=yx878YQasoUwNtvV+3rsQZ4opCqnIkkVIPqGaOo2TPkJ2b2M+fhGGEKZtIrjmR95Eb
         X+YDIXjpLgg7Z9qqoGatV391zURfR1OlDC3GIyVrta/vUO6g4LyCrxipzJmxKz7KF2Mj
         bAosA+An0lvhi27qw+cJTzy22f3E4X8ydm1EIMaZdqdMxGhXNs7txGbjexQrMJ3IwV/K
         wZNVqkFMsPFZl0waIHHdtlyj4xAfBzZK2I5s11lj8YJK8ZToaO1V8atl/rYUasWHH6D4
         3cwSJ3/cEq0onIPWhvoXCg7JQMw6/ZGNH5kBq6u/rvHalBneTaA05Qp0cVc8YO/cInZm
         UDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780870591; x=1781475391;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=psqd04aJkP7QA3jViji8W91dqePEua5iJRalD0aVCuA=;
        b=M4K2ImfEg7FoH3QA/WXzhkSiCmgLSYty56y8xC/HKO5QE6dsTUO6omt0c/xa5JLEax
         AX/JhjbjdYo0XWdyaHLFJmoNbxwk14+fV914Lp1n8w+m30W7XEgsNiNRQZUFcH1/QyBZ
         uYUar7oZ7Qvx5EgtaTnhQ1TSarvfRIBjcR8dQdb9/9jK6qF/ZGZvjIE41/pP0K3cORk1
         XOSI5azig9adIkPmGY5aMZ72Inm5Ry7EyuDhp16jCgcjMGX1TlVJphE9MeXYXRclT6Zm
         HzkGa0E2QBDCQ7ZN3gq2RNiifD9b9n0gpW2AWeVqfJ1eucBAG1XtKCDoXHnFppfVMQb+
         s1Jw==
X-Forwarded-Encrypted: i=1; AFNElJ/+yW/FIaHHF3HUgYINwN1cWPobJRjTqbTWEodEWISGU8W25jp5BFHz6Td/uV0W6jbKviGSf7ZAYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUCslhV9PMtxU8ScfokE9IxtO5WXUHlwemB4Gz1sTWSj0ZnhgZ
	TTSqkMmr9mBVzmCPUaXhfOEtGuQrpDrKkXD6br+N1VlxQcPvzA4ok+rt9eD6PtqB14I=
X-Gm-Gg: Acq92OHL82P7qlZGFy1wToCvxPEXuxr3D+cSwGcs+6ilu371+S9H50E1HCZ653B+M5S
	3Rmmg5gFK4gnoTy2sBzBQOXOiK2Q7YfHUrwkz2VSg0EjD9k5D6gmT+E3mr17eVUDp0hzeGMrXwN
	OjJEOgs6+f/4PJWLvr3vpg4Pf+0cyl3n9GHygPrOZvsuWi8ihBXz1jelg+cZJLjo8Jm/hNOypDG
	NT4VHgEGWAVGw/e2flWnft9HrjiLQvIIL1DGbE3MbzcjSjBVu51yn2Z5IdU/VYc69eo2V+Gdklx
	9PKWiX1Ipk7aiLnXNqZd61/DIhQTvFO0ggORLDam7nU+fVwD2tTplDXa7Wsj8IUTdP+VXvtoUw4
	hINsP15GzumlDShhQfLwYGVJlj7O1xikccAlybNPo6p86cmU9o68ExyvoyTKKM7bQmWkX9SLjoz
	fdEynw9EdxvT8ibkBBiocPzrM/dSmuMwxlNU1CnHcCiwLxA44uCa1b+oOQCT+q0RURhVpshuXbU
	Y4z9rB6WEcAOtSntb/X
X-Received: by 2002:a05:6808:144a:b0:485:7c72:bd08 with SMTP id 5614622812f47-48692f559c8mr4920542b6e.33.1780870591316;
        Sun, 07 Jun 2026 15:16:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e74696b7sm10900126a34.3.2026.06.07.15.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 15:16:30 -0700 (PDT)
Message-ID: <b5dd8fa7-4b6e-4c08-8468-236b6b2c59c2@kernel.dk>
Date: Sun, 7 Jun 2026 16:16:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] test/recv-bundle-pbuf-len-poison: add regression test for
 pbuf len corruption
To: Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
Cc: federico.brasili@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1fd2ea63-c128-4641-9565-dbafd97de612@kernel.dk>
 <20260607221114.135950-1-nyariboemmanuel8@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260607221114.135950-1-nyariboemmanuel8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13634-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:nyariboemmanuel8@gmail.com,m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:from_mime,kernel.dk:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C7466651CBE

On 6/7/26 4:10 PM, Nyakundi Emmanuel wrote:
> A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
> ring can persistently corrupt the buffer descriptor length. When the
> receive fails with -EAGAIN, the kernel writes the requested length into
> buf->len during buffer selection but never restores it on failure.
> 
> A later unrelated IORING_OP_READ using the same buffer group then
> consumes the corrupted length, returning fewer bytes than expected.
> 
> This test reproduces the issue as reported by Federico Brasili.

Thanks, but I already wrote one, which also tests the much more
important aspect of the kernel change - that the reported CQE
completion reports the right amount without truncating the
buffer length when no bytes have been transferred.

And once again, it's not _corrupting_ the buffer length. It's
shrinking it, which is unexpected and should not happen, but there's
no corruption taking place.

I'm dubious on how much AI koolaid was used in reproducing the
test case and report? That said, it is something we should fix,
as the kernel should not be changing the buffer length for this
case.

-- 
Jens Axboe


