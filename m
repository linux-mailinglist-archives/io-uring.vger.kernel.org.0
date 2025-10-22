Return-Path: <io-uring+bounces-10133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A04BFD9B7
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A9404E044F
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CC835965;
	Wed, 22 Oct 2025 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IKmdkMIP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDED2155389
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154527; cv=none; b=sbmbEeDK8+3OtCQc87emaqrJqCpoZ5w38nSqtOtZzddfRyf9a2yaADMWtBDqK8SIe/wtL3qZdiwouDuXHh2H3S6d9DUS4HNOY8ZhAtly5D07nclcj7RznlKXnYE6r6k1P2h3kCZPFcb122N7uLMircyqlCFTZelvcA7T2stjBxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154527; c=relaxed/simple;
	bh=J4k9Ps19GGO7Cpv2imQYL43/eFe8P8sW6fOHxrGkC1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXZBv4RDCCEvoFRAPx1TwiCUKbb4n0VKOCgqL/gbyBFZXm9XG3tYUNwvAbeszUXZWRQxvlcx8qDioeA1itCWYvHjHl6utPCeuSj9xBwHq0iKPc4BtZHHPyTmI8/yRpMYGStsPn+U96H43ikEnc8Y7HOt47N0d8cKi8TQXcuLUhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IKmdkMIP; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-430e1f19a1aso6470125ab.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761154523; x=1761759323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYo53msEy7+ayuC0ehl2eLu5KRocjMamwydlKV7RjdE=;
        b=IKmdkMIP1SdQcvWYKRAALKX8Uavp1mHw8o6IU1ZjVlWlcIOpzBuMK7KiNsf1wsN74E
         y9qJu3DLAFleGMxaQObAmQ54ozO5U38Uh792P8QLd0U+YUN1IVa9eZ0Wn64Cu0ydbTC1
         a8sVlQto1JR0+cv9xZGrhFTc8QYUduxZkieWW9qI1JasWMsAyZxl/7R/C1UsBi9SZXxc
         KyZ4PSQ0oI+OMx4VscUwx393yzRWA9Y9wCao22W34pMKOWx48EWCF92sdZ52FLMa6YSA
         MYi1fLhT5qy5Fs1lN0tJWosXVgXLqXBtumorh8a4P99x0P8/YHV/DFTAlg4cqO01cUw2
         4bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761154523; x=1761759323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DYo53msEy7+ayuC0ehl2eLu5KRocjMamwydlKV7RjdE=;
        b=NGle0R7nPZFPbYpJkK4ru/idzPhtTgtbxmd7ql5xyyV5eL9DeMTSY0STDmlCJN9kR3
         hsLlOlmdP/ZcZkABNKt4zjZ3zTSu9YjVrxeAhPZJxuHSxRphf/aF9EaRIuBJEx99EJQp
         Ps9PMB963DaFIy82k9oXkJi/fJNclA5dIpNWPlmEQgTYEXN8XKNT+Xt1fQDxI24trlQ0
         0c4jw7pw7m1oJPC/VXL5CFhI3HGb/679OfoNitUBpq5zZPZmW7x/FK8/DCW/Z3D8tNkl
         j/99MCj2bd5zQU//3YSxq0sxWQL0DHsX9SvxB09aEUgjbRWZcHCXXWIEHaE7OPhMcx+h
         1IyA==
X-Forwarded-Encrypted: i=1; AJvYcCUb7f6q4YN4fy7P61smnZf9H7Mz/fE+laJjD616g0ZmhhncCaRCPkDieEScdPY2CZmK3FcAzkfI0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOtkTVzfpJMPIPyQXVHbapKoc4ciY6SxmcTNceH9TNBdKKim0M
	DBVrAVDhNtGK3Qj2n76KPqyM3KBzC2g1Dv1rItk+PzX9zl/p2O0DSbBaIPErdxEjLLg=
X-Gm-Gg: ASbGncvnfSBFIWJHKg051rY5HZhZPIcPk7bl2/kXvhedQTEQ+3QGF/LynaD3Rv4WGSG
	0RqvIwLdK1UwxIogk5hHjU5xje7yKcMy256AbrzVdAJa52NDpAjDr8D42Y0i7ANDbzV3hDawI8l
	eb7CohXYEDBdltegPjOZ7xaYAEb7nKfyqM1ZeuH0gFryiAAmDtugLG+bppAWQ97tXM1n9mql5of
	lNC6MoGLdE+SLbfxKAobVGbdx12xznIeI+5nuF5gg8f2FtfzRN3xV2HpPo3TtqIYDNwRndyBZHw
	p+DtX3j3yFblbXTnoO7pDAQ255nNrdc3FimqoPD/jjULNtDACDX6Wr1uhgKS5ACeKzOHudrcmMC
	FYp3hrcB+L2c8HIZTB4LxpsvCpMKzzagZ6xAw6/FNp2zVoAs1DzQmHxHVDVDvmVNla10aWjD6+g
	30htmqnFQ=
X-Google-Smtp-Source: AGHT+IHJ24ngpNO2MYCTj7jMIO4rhSN499N7arC+yShfkbxc+5M5WODrIj7P1YvEZA59PMOMpSDclQ==
X-Received: by 2002:a05:6e02:1aac:b0:430:b467:1af8 with SMTP id e9e14a558f8ab-431d31906d9mr55008085ab.2.1761154522863;
        Wed, 22 Oct 2025 10:35:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d07b4372sm57594605ab.32.2025.10.22.10.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:35:21 -0700 (PDT)
Message-ID: <4a6dfe74-0152-407b-987e-12befd319303@kernel.dk>
Date: Wed, 22 Oct 2025 11:35:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 2/6] Add support IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 csander@purestorage.com
Cc: Keith Busch <kbusch@kernel.org>
References: <20251022171924.2326863-1-kbusch@meta.com>
 <20251022171924.2326863-3-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251022171924.2326863-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 11:19 AM, Keith Busch wrote:
> +
> +/*
> + * Return a 128B sqe to fill. Applications must later call io_uring_submit()
> + * when it's ready to tell the kernel about it. The caller may call this
> + * function multiple times before calling io_uring_submit().
> + *
> + * Returns a vacant 128B sqe, or NULL if we're full. If the current tail is the
> + * last entry in the ring, this function will insert a nop + skip complete such
> + * that the 128b entry wraps back to the beginning of the queue for a
> + * contiguous big sq entry. It's up to the caller to use a 128b opcode in order
> + * for the kernel to know how to advance its sq head pointer.
> + */
> +IOURINGINLINE struct io_uring_sqe *io_uring_get_sqe128(struct io_uring *ring)
> +	LIBURING_NOEXCEPT
> +{
> +	struct io_uring_sq *sq = &ring->sq;
> +	unsigned head = io_uring_load_sq_head(ring), tail = sq->sqe_tail;
> +	struct io_uring_sqe *sqe;
> +
> +	if (ring->flags & IORING_SETUP_SQE128)
> +		return io_uring_get_sqe(ring);
> +	if (!(ring->flags & IORING_SETUP_SQE_MIXED))
> +		return NULL;
> +
> +	if (((tail + 1) & sq->ring_mask) == 0) {
> +		if ((tail + 2) - head >= sq->ring_entries)
> +			return NULL;
> +
> +		sqe = _io_uring_get_sqe(ring);
> +		io_uring_prep_nop(sqe);
> +		sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
> +		tail = sq->sqe_tail;
> +	} else if ((tail + 1) - head >= sq->ring_entries) {
> +		return NULL;
> +	}
> +
> +	sqe = &sq->sqes[tail & sq->ring_mask];
> +	sq->sqe_tail = tail + 2;
> +	io_uring_initialize_sqe(sqe);
> +	return sqe;
> +}

I did apply the patches, but can you add a man page addition for this
one?

-- 
Jens Axboe

