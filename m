Return-Path: <io-uring+bounces-12911-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id LpoqCxohzWlWaQYAu9opvQ
	(envelope-from <io-uring+bounces-12911-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:43:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7308237B6E2
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5A3130A811E
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 13:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839413F1655;
	Wed,  1 Apr 2026 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bCyb6GPH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEE3E0C6D
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048891; cv=none; b=nw5Hk0+wRhDpoHDbdPpsgkqXBaOqiKGSjh60mXpHQGs0pK7kxJd9gtGhJwAeXeLMD43uDS+GG/4t3LOl4nEUc5GUGqErT5m7jcGOrShDkXKnNpaHpjyzGjRIJdY5IOnLCg+DRsqgxEsjndFB4wT5S0ofx7orcX1gftDgyY+1OJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048891; c=relaxed/simple;
	bh=/GQHHmcvd2Gvtjn4qmtdah/Z/7tdDNGz58YK3geWdVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GqDsGdeW/fFhidlRxM8FiBj2Ernc0IMDS7EwQnCGEG50godO+eaQfwmP80nmcEH1Qq2AbHulaBq4F4mSFeLWnq4N7tvbWY71uBjnvPnY0Tf9TeTMHisJ0qswlENkCN4lBeWyFyYemOrQQWq9FpjpPmRY0LVustclkQLvr1Hn4Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bCyb6GPH; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46703fb602fso2284221b6e.0
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 06:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775048887; x=1775653687; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G+YkBb3y1FhfbIlMBwRop0o59XtArawBc8sVxq8sLuI=;
        b=bCyb6GPH/ivXthYRwIAyB9iPcXz+5z8WCK4A1D6kLqdKs99W+YKW0+/UU2U4wuzqdt
         MxRd0Y82b6mtGnst7IsUwsK2TRQlSXD0aizaPY7Z6gtzA2VAN/Rm72osILRtQrW1UKe3
         C/aRhstaTr/wbM2nBdO9oP62urTzLoqj4NSGY+ehaFxNon2RySZaMrsJPJe+HEx6PReG
         SfhazxeXt0BWpJgkJrJY131UPa5+0fAzZJDANyAx+/5VMpFVCvubwEm+jTSrcO3yrMx6
         TqrbW4yKOIV40RxeI2aDtHfxpF6vgmpp915n40ALRuaShpM2khJvdVKX+dJesdRNR6t1
         z1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775048887; x=1775653687;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+YkBb3y1FhfbIlMBwRop0o59XtArawBc8sVxq8sLuI=;
        b=TxJzYfc8LWdaO4MthQ89QpobJlUTcaZTAWr7wsVkPLQv4qkMOk3rKRKQOLt89Y01sm
         4g3jT5zckZuPtZCWgTqwbJIUxJccbJzDHDTqct6zw64A92ApIHfcv0POYkim0Jr5EYwa
         M967vtR5mW2wIFvWfMUE74GpGCdPFzsx9pRG7XmjJOXs4YydMZsRg7879NvBBN9g1Xw0
         SyuHijJMqW15RVkiE8P+NqLBkaPmzcRUGYZaHiPnzeTm8YZAO/ILp/RBBuYt6eYMgo93
         +dP5fAVR/2E31hCz8hgEVM/60GVeZVJPuIl7xFCMUrGJYDTzgR4Hp1Y6MtX0gL2IUygG
         u2cA==
X-Gm-Message-State: AOJu0YwYTa/BmHtRn+1hP7EtG69vEDz3OQ1EhvNwePYBp44GXZOKmpQf
	bAO7hyp2Rg/WB4+h1k7tT2v5/+n4bolq4t9uf8T2q9IqTMsPXRugLpH4F4UAwomdj5qqyEomtjE
	jRo1p59w=
X-Gm-Gg: ATEYQzzFyIdXSQwpI2DSObAFrj9zV5RZyRbCdmao3UZYl4IKaAnvSn6wecoLi6LcTT+
	PttUGKSSBMG2kBvfNrnmJX3HZbtKUey75aH35ZDJRq1kcuqMwlspMh0SJ1g/BypgyEOVPo02QRL
	SIm6dP1ffZTm1gMtphc4kG4Gfm1ibsQKKbuz+fEG6H4F1gozdq8nHRQ21RIbY2RRn77vG/ziyF8
	5URezVEv3c6GouqHenfWRCOpmBOvdoSJQ4ZlwLE7Sg9jtiJMY57HKwTEwzr/TOJ8P97le+BDkUv
	1ptwOQBR4d1qXqJn5ICoVwBkuzXhdIEF8IQ5r9oIN9+7MgJCmMHw4VAEbqp+iAcG/zUuFCzsbSp
	GCKvTPfb8jZl0rlhx84F4Z3MqwWgROaOXSceF95EYLROckthsd/fnN53yIrd+w/89oL+LfNYK4M
	nrPc+BIHIWderiDsY64bYQSMAhi+fp3Xw7k7Uz9id4UhWY6sDa3loPY/RT/YeZLYFkM++IAJHEZ
	PA4TQpPadioOh9AVqCW
X-Received: by 2002:a05:6808:d51:b0:468:bfcc:11fa with SMTP id 5614622812f47-46ae023f065mr1653672b6e.38.1775048886878;
        Wed, 01 Apr 2026 06:08:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46a9fe94ea4sm9134644b6e.3.2026.04.01.06.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 06:08:06 -0700 (PDT)
Message-ID: <39f7830d-a77e-48ab-bc00-77591a1664c4@kernel.dk>
Date: Wed, 1 Apr 2026 07:08:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: use local ctx consistently
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260401022158.2327865-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260401022158.2327865-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12911-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 7308237B6E2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/31/26 8:21 PM, Yang Xiuwei wrote:
> Use the struct io_ring_ctx *ctx already held in io_buffer_select(),
> io_send_zc_prep(), and io_timeout_fn() for submit lock/unlock,
> compat checks, and cq_timeouts accounting, instead of repeating
> req->ctx.
> 
> No functional change.

Please check for-7.1/io_uring first, most/all of these are already
done.

-- 
Jens Axboe


