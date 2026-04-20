Return-Path: <io-uring+bounces-13071-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PMkHRdp5mnBvwEAu9opvQ
	(envelope-from <io-uring+bounces-13071-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 19:57:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8ED43253F
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 19:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ECA07300D0C1
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2026 17:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EC238757C;
	Mon, 20 Apr 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zqbU66y6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A243612E3
	for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 17:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707841; cv=none; b=PrDBlwRyfsnSlgF2Bp2CKuUsJKh0kkUsKUv1B/ApvngfsOR9ovhRnFaKGNg1uX8GzEIeB6h6YsKEK1xntO0mIbNh/ik3GQeNSA86aZKgekljMDAndBBpBj4LHn6A96rVno275qdtkF0oi8EVM4/qNMY6y/bDIasjo2keyeSatPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707841; c=relaxed/simple;
	bh=SkBhTRDDrEOmdspg4btj9NoEZsGlK6JZIc3yfsxXCwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZOyHMJsjrT8sUkF7eXjs196nVHBrSKEQppg3aCvzvjK1FbOZMY3+cpBDXeJGEDxrNQXSCSgQBk312QOsfxzzK3mj2nwKWCfwPQBhl1RY8IRVXX2P8YWyYpNRiOlQXAitmS1IjlVJChu2PoORqqtTBPM4CaUQRRIPSkSRdq/j5+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zqbU66y6; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-479e4835e26so274098b6e.3
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2026 10:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776707838; x=1777312638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZWeg/2JSQHauR+qqyWnEpq9DlLYHVnHIhMylNyacPY=;
        b=zqbU66y6CVzu7/m8MT0KENxZJnEa5Qiv1C65ErBzMwzh4sOSlGOUrpMas1AZPto+3g
         CZrJa8FVJskTxRTL5bk6Hjvrph9UqfAH8bWuUP7ljZCn0GPoFkwe7GWusp8mLna1l/ky
         0nd2GjX+SOlXGNm4kc6hV39YI8kMFfW96iSWKCWsVjLeybmxKvEmVV1vKN3l8Mszxz+H
         64gN16oraYa7Aeii8g41CWjxGmRHuvXLWf2C0Q+Yjx+xhMhtonog+LLuxlkSxNhvy4T+
         mEW9lgwfIOi4GlsJ4P9DH9wAGp3oIauNWI3zMRwJWTl4yn6+9BMwQDpXtPDxVsVJy3vs
         Fx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776707838; x=1777312638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZWeg/2JSQHauR+qqyWnEpq9DlLYHVnHIhMylNyacPY=;
        b=ivwiEbMFkdVVojN4uTeBYRTB991hZvqbMLlM7FM1T8eyFsNcHGi27UQAgBdL8wHRCT
         d3wHwDXuLViLnetQtjkXvCr/xvikjZseC1c342LSYwtxoYg8fuzHFNyjmT627EGAIHUw
         jYqTBcFAn8kN+FFKchtFJexDGbshqp7tsXVixcoZjO+pJd4/IzzEhDfMImGWiYnQld7H
         x01E+K23BSnxGys5nFnCbX3vUgzfXOyGuaGlqjXtG9apeIkzv6bqcNoRZPEBNmqtUpZl
         kDVKedWZBCR2NrlBC+j6VEiy1eCyAUyN8o9ZW9jiO5uy1WKNPr96yCiKFsVl1LvU6WOQ
         SMNg==
X-Forwarded-Encrypted: i=1; AFNElJ8vbxihjVw1gGSz9oXnaSohxoc8EdHB+LP8w9Djbg5QgrMz1aPayP4qtQ7S2jwLTjkOn0cxR4veZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+r1wuDbe2pbt+MEafCAgLXSWapIoct7zmVl5WMAABqMubehm9
	gv+W7gNS37KYg1/wAiXPFf/Z8SmRp/9Ay+pZSZlmyNv0zgWxPGgJRsr0Ibyy1TjaNxDCrmUougY
	eqFmTbec=
X-Gm-Gg: AeBDievM/D/OeJjJAzuOIc72Piagj/9pT+CNbzWYHuh6hrnhoq2UGXwIao5t/vulyfi
	yBjXyxZVYYzYOUCEhmx5G2dbXdrz3K0Ofc0aBUdygAncS7E4xQGvFZXY23HUJx+7Eg7vYlNN8c1
	MpCdCh93C/PvomBozMZd9CCTaVw1RSLem3NchtclyixfeYKHaA7TmomY0fVBSIDfaSxdmzmKeJ5
	ER1fepnYH8Kfn3OLeG00L3cmxeoEdcOeksvhQr6b04cHtiVbAobOLOd/KUW5LpgGflJdcoPtzY8
	vMp+28qzXy/xx5FSODeUzoIu9gFRdsGR56uU24EQKyEkOGtsiYThe6q+1hREp1EVtnpKPwQLUoe
	DgFVOr1SRFKjwtU3+q5+Ose7f8DHocTaCBLdelU2kutzniwCWUcTTEz6hdEgsYwRvumXIC2sCzJ
	CjUr9HHrp3c9k1B9zbvHpWOEyLUDp9wtniU/sigjIFXf68oMmD9JYjmXKpG7gtZ7Mnf2ctY3nto
	NEOckIEDyrAVSW8RSY=
X-Received: by 2002:a05:6808:8888:b0:479:ca20:2904 with SMTP id 5614622812f47-479ca2031a6mr1982866b6e.40.1776707837786;
        Mon, 20 Apr 2026 10:57:17 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc892c515sm1992681a34.21.2026.04.20.10.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 10:57:17 -0700 (PDT)
Message-ID: <15db596a-3f21-4e0e-98cc-b4d2817273e8@kernel.dk>
Date: Mon, 20 Apr 2026 11:57:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] io_uring: multishot poll stall via EPOLL_URING_WAKE
 (apoll_events not synced)
To: =?UTF-8?Q?Azizcan_Da=C5=9Ftan?= <azizcan.d@mileniumsec.com>,
 io-uring@vger.kernel.org
References: <CAM0zi7yQzF3eKncgHo4iVM5yFLAjsiob_ucqyWKs=hyd_GqiMg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAM0zi7yQzF3eKncgHo4iVM5yFLAjsiob_ucqyWKs=hyd_GqiMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13071-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A8ED43253F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/20/26 11:50 AM, Azizcan Da?tan wrote:
> Bug Description: I am reporting a logic bug in the Linux kernel's
> io_uring poll subsystem that causes multishot POLL_ADD requests to
> permanently stall.

This is just a bug, it's not a security issue. And don't send binary
attachments, nobody sane would open a binary attachment sent on a
mailing list.

If you want to get credit for finding a fixing a bug, just send a
patch for it. That's what I told you to do, not send the same "report"
style on the public list. A patch is something that can get reviewed and
applied.

-- 
Jens Axboe

