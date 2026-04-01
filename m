Return-Path: <io-uring+bounces-12913-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKpsLPcjzWlkaQYAu9opvQ
	(envelope-from <io-uring+bounces-12913-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:56:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C246D37BA9F
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3B1903058519
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 13:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B746043C07E;
	Wed,  1 Apr 2026 13:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x/+HyAoh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E423F166C
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050757; cv=none; b=h+N7u27QTQiS0QmBVI01GvzYPVTjAnh11zFrXbGPj0yq3fO5ao8eBnLC7E7UaEQG3KsGbiPYM6tuhyqLL2yE90fjJJ+/Bc3h4gbQV7dea030hzlLRumMP7dKveb6E+ZWdizXAldN2eqM0rFXqs9ClEMrRg7L3bxvg7z5+V/rpMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050757; c=relaxed/simple;
	bh=1ljPcBHUpKghmYBDjcQ7vFiGArJBu8XIvRxwNG6nXvg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dGFpDsHccBB2AfEb2lFbt8/nDQDpe9Q0dMc7vx0YKL5fYgII40xsgEZm3p2tUp4cL0ZhuaxtH/DHqCqTSMBdaNhz8bq8er71jSERKDJ+6MSHZk4H033cSV4rFcrZ4ItN8g4nuvoJB8tZ4quSdaNOte6QC1cHFIjzXcZE5WpL2qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x/+HyAoh; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d7e9b97a73so608787a34.0
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 06:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775050753; x=1775655553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VoHr4CLXN0UV4KE+vq2SWwzywGwtYLEonF8ugJ0rIkc=;
        b=x/+HyAohjCYi+A4p0m4ieeIb1wgM1tW5OJRoGxkWoDOUM4A+My7gMZ4cjem6fCxKMB
         WinT2TUjbvFNk3uMMNzZH5VhF50uM3I6G0s6C6dcaNw9+MN/aMbUvN/1Gnryeekrrc6w
         em/r/4OsYGNGLOn9gP0DUUdhjKtKT/CpVfBl7M3gTHftoRKvbZSzJJl22IXKimi3IZG6
         Nsqb0F2WCimYzzW8DhjWygd4BGFYE95zV16ZwSG9ZsN5VaO8J5dMN4seRfHod2hf4U4o
         9ROxK8Hqz4aj6KkLK+3JDNa1ip1ZNXiCl4Fe2zwUufJwF2MKK3T4UN2cQr1Fkw+gDBKS
         u2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775050753; x=1775655553;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VoHr4CLXN0UV4KE+vq2SWwzywGwtYLEonF8ugJ0rIkc=;
        b=NpghHW2YyBwUlIkZAlqh/+UgMW3YwTSmdv+JyZi//SNCoBnZIoQxcGi44NcnjFx7Q6
         +z22BRw8lRQN/RnONbM11WwXYw+vVe+Lg1Xqljs3CFaIs9RgIX2j9vTgh+pyDspXWNRT
         AJWzvIgyiuOpwFBODCyCrlyhKcvkXAAcZH1scVDk5PNGCsHEzT3HNGiJxE/pmk2snhvL
         Ok8jFMhi1BJQhzfZxtpOsPnio0ODC5zjj7rWsaiVoIMp9ivK9XKMKZqmFpHZhpJwdu++
         gYMhTjx8u8BrW4PmC0iMEqE+NyFTWmvD9Q5Og1exeYByb15bl1FlH1ApzJp3eCm3KDit
         ymcw==
X-Gm-Message-State: AOJu0Yzqs0ixrk1axXHF1XOlw4QRP3yuSvtyj0+Yqxyj4czU3wvCHFYR
	E0u2Q1YQgkGQoQPwFuKJgbCuXvAPMTMfm7zHUABVwJ4Kht2PQsdUnuQ6SDgo4VrCf5A=
X-Gm-Gg: ATEYQzzfaxW6RSLhP4ARF1M+EC8apCbu7OpYncPZUnq1EsIdMh9Lp7bP2MP1hOkptlg
	rxqtmDQL/YN8rtjBaaTkmZGwWkHUwD3AUAtUrNNVL1sksvb5N+7xo7igTSaMVfRLVZXTmOU02Y1
	QPZzHgU1pc8Q4hBzmcqM+oexaiKWLnHXj0D9Peyv7dQ+hIxbeBpNAYGILnN5VhmYRaLTmTEkNkC
	XEKnbt60FYvktoSZHMYvXk8DGi7bXM3DxksSv8u/buM6jf9dvCuZuGN4OLHHnvJQLimbLUNSSmV
	M81BEC9bpM+SWO3ENPgn7nAjjdCjWZ64rHD50XPLf1ov02yz2Pg5pLzsq5E0HQ9gwy+fnXXsbpo
	nezUMvNJfYO5uOoTkk9lqIllFQYSmJDYvScG5x5xLH3gPjvRubPS4pywOb/Ubp/q5eH4FhEfYIS
	8oEGItLlU6HV9dz5Z4tnA9ap+qEgg5WUDP6ZfCGGyCcshptlAJd/4CM4xXk9j3jvuCeZcg3BB7a
	RON
X-Received: by 2002:a05:6820:221a:b0:67e:432a:9c9 with SMTP id 006d021491bc7-67faba554a4mr1689575eaf.31.1775050752889;
        Wed, 01 Apr 2026 06:39:12 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e23031720sm9598777eaf.2.2026.04.01.06.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 06:39:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260331232113.615972-1-a.jahangirzad@gmail.com>
References: <20260331232113.615972-1-a.jahangirzad@gmail.com>
Subject: Re: [PATCH] io_uring/cancel: validate opcode for
 IORING_ASYNC_CANCEL_OP
Message-Id: <177505075190.60447.5348191105763005353.b4-ty@b4>
Date: Wed, 01 Apr 2026 07:39:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12913-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.989];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: C246D37BA9F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Wed, 01 Apr 2026 02:51:13 +0330, Amir Mohammad Jahangirzad wrote:
> io_async_cancel_prep() reads the opcode selector from sqe->len and
> stores it in cancel->opcode, which is an 8-bit field. Since sqe->len
> is a 32-bit value, values larger than U8_MAX are implicitly truncated.
> 
> This can cause unintended opcode matches when the truncated value
> corresponds to a valid io_uring opcode. For example, submitting a value
> such as 0x10b will be truncated to 0x0b (IORING_OP_TIMEOUT), allowing a
> cancel request to match operations it did not intend to target.
> Validate the opcode value before assigning it to the 8-bit field and
> reject values outside the valid io_uring opcode range.
> 
> [...]

Applied, thanks!

[1/1] io_uring/cancel: validate opcode for IORING_ASYNC_CANCEL_OP
      commit: ab274887c2443f49d3a547a58a094787cd02d1dc

Best regards,
-- 
Jens Axboe




