Return-Path: <io-uring+bounces-12887-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPqiBfCFyWndygUAu9opvQ
	(envelope-from <io-uring+bounces-12887-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 22:05:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB75353EC3
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 22:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFCCF3003310
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 20:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E7937F019;
	Sun, 29 Mar 2026 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jJdGb52b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155918EB0
	for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 20:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774814663; cv=none; b=euaf0RYLpossntE4ts+cWpXCGNYZI5fBL4LBix1AWu+Wt/tI5Cs8S/r5d3OytyeVLSLYv4wZHuASJtgG5HvL1qq5Wdu5oYanRDaMRP7KH0bFVVY18QWxLJNAcILPTjwStLvSo8zxwCm5fcrlPxk/w1u8q9QPPxPM5PiU445TLGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774814663; c=relaxed/simple;
	bh=CmwSchGsQZX2RfJuqAQGtcnNGsikvMvEbXJsEzEhtH0=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JWsc/9kupQ3/bRJTQMr+ixTV/D0RLOz65YnSLkGKwXy4mepECJgJli7ImG3RoyKtn5ryPIEqU79A8nnR74mZc+qvjDvmBvFa7imO4ZrIcmRRxQz4rcVV0fMxgNNTcr7Ktjy9x/ziE0OdaAYXO5VEEpO4/zAtcDajW6nV2AJAMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jJdGb52b; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-467161c4b7aso1388447b6e.1
        for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774814659; x=1775419459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iX8ZNv3CdYCnsBtieJRninBtoFTcalSs17bW1TTH18I=;
        b=jJdGb52bHW5glW+/jIdQKAdqR8FvVofdVtgEkeaNVH/yUYt9vMmuI04nw7tv1xGoVG
         PY4bws0u0FauRu9FICsSbwvxiaR5mrXP8mXfOceTTPsmOc1s1pnAj2iSRSLfyORDYshf
         tZLInfpvXbwhh4+KlcTN7g17bxdIGw20kKJLSOoQvMyc2O/X3LHYYMfyOLqyRMhd12Aq
         LZWkE1l0RgllwjC6Grxu78Sc5n1nF6RrAeBWL6tdyL2sWUX3N0Pb8o/Vm9jAU8Gn9MOQ
         BgLtf45hL0hNljByprVAOYM7D7Bl0d0tnpufZI4ZSmfSc2lvJVYkzN2BJDLQie07uLLZ
         /9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774814659; x=1775419459;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iX8ZNv3CdYCnsBtieJRninBtoFTcalSs17bW1TTH18I=;
        b=DrpPVgFm5erAFOyI+udHZjKPRRSjavWZ5g/y+qnMuS4UMpQXlBdo6/7cEjl/YbdycZ
         GwFA4GnfN6ojVgeUWsIs0PuCnP0SROqPZ8ZtkQEuz2rw+4lbczg/mnYySW6EYM9ywwJK
         94iQD2i1d4PhiV7KVb3sbbPbsr+w0xqsefsxqWMJwcYeWlguyczPhW5u45g41lh/v+GM
         R3iRuA/JLECh1FaD44xfe8TvTUGTzK759CrlAANDUdfKHkabDSE9NJYgZBtLJ8xc2deh
         41yU7oSDwBLgQFPeSLZpbqFedYH5peKgvMUQMLq8F+cEOTm6JwggACxL6Gn/Ob8M3wjY
         P2CA==
X-Gm-Message-State: AOJu0YzQiYSCqAuyYNs9ODNK/AB98JeOTXLhLpED81a9uXoKdkunG2Lp
	wpDA1ZALdHf8QVxZsSEpqW+ywW4UX9k+el4jQPAVSmLduLB2y+/8XlE8kvj2AFlv/2fWmi7BQ0N
	cFbwg
X-Gm-Gg: ATEYQzyOpwkQN5nvdB7DpFSvfsljn3uXVP7SOoEVQD/6YsPTjZ4m8hYqMIxG6mZ1CYf
	6QlrcQHhMYpE2KTk0V4ApqKCkR34VFjFlOb4e4gtntQmHSDMCyr6uLPUXdYz60kCVON8pYncgns
	8Vz4cZ/C/XB5MsOAAbpgwpjoGxWokmE2vN2YXBgxmMOsbrYXb9J7cB8HtRThPDs2MOU4ze9TACo
	CyDxBqyRGrfoqNGkmaoVAilTKvRppSU0tQ/eegka2iwNqAaW8ukUzJthpw/5YIjwto5l+KTG7ob
	dOfINo0wvIgaRsZngeFZTKjn+XQRXhixNAojbA4Vx9QoR2X9GChVJTnQa0G/x78QyfW5xK6zxlu
	SSHQ60wl4irRRAi7rCCRjJrpmiGPf9VqEqBW94aPsy1ta1r33PTP+8Flalj0Y976CVEjoDrotBT
	mwPvuFMAJZo99KC4RKH3lZE6HbM+BmkPitaTnIejSiswWHdW5FWfHjEv+5yOtePAfdV6Ws0DrJu
	eLl
X-Received: by 2002:a05:6808:6ec6:b0:467:fd2:69e with SMTP id 5614622812f47-46a8a5d36bbmr4858956b6e.35.1774814659612;
        Sun, 29 Mar 2026 13:04:19 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03a9179sm3076174b6e.14.2026.03.29.13.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 13:04:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Junxi Qian <qjx1298677004@gmail.com>
In-Reply-To: <20260329153909.279046-1-qjx1298677004@gmail.com>
References: <20260329153909.279046-1-qjx1298677004@gmail.com>
Subject: Re: [PATCH] io_uring/net: fix slab-out-of-bounds read in
 io_bundle_nbufs()
Message-Id: <177481465815.564893.8584983065808740907.b4-ty@b4>
Date: Sun, 29 Mar 2026 14:04:18 -0600
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12887-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6DB75353EC3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 29 Mar 2026 23:39:09 +0800, Junxi Qian wrote:
> sqe->len is __u32 but gets stored into sr->len which is int. When
> userspace passes sqe->len values exceeding INT_MAX (e.g. 0xFFFFFFFF),
> sr->len overflows to a negative value. This negative value propagates
> through the bundle recv/send path:
> 
>   1. io_recv(): sel.val = sr->len (ssize_t gets -1)
>   2. io_recv_buf_select(): arg.max_len = sel->val (size_t gets
>      0xFFFFFFFFFFFFFFFF)
>   3. io_ring_buffers_peek(): buf->len is not clamped because max_len
>      is astronomically large
>   4. iov[].iov_len = 0xFFFFFFFF flows into io_bundle_nbufs()
>   5. io_bundle_nbufs(): min_t(int, 0xFFFFFFFF, ret) yields -1,
>      causing ret to increase instead of decrease, creating an
>      infinite loop that reads past the allocated iov[] array
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()
      commit: b948f9d5d3057b01188e36664e7c7604d1c8ecb5

Best regards,
-- 
Jens Axboe




