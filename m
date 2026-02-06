Return-Path: <io-uring+bounces-12077-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IdRJI8EhmmyJAQAu9opvQ
	(envelope-from <io-uring+bounces-12077-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:11:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0053FF85F
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07BD9305F7E9
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 15:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEE1279DC3;
	Fri,  6 Feb 2026 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8ZJSo9v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56B279355
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390374; cv=pass; b=p9/zmKOLcGHF18CAoJUOBrTpaJ+rwnEoSUFJDiYnein6LdP1AEOdHQowz5c1CXXA2zYfeYVGFIo2OxebkcetGtInDTE96xzUclhbrpRekTn3RR/OjdU0APs8aYAHugQFo3ZJVlF0Hq+DwLxEv6avSsQ9m8C/9gHMuNTeQ91F77Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390374; c=relaxed/simple;
	bh=OufKA992AHTujMMKlyMPMaSNXhGWNlCrvEQi1Oda2p4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEirPZvWYTNEmJBxvBZUMT39n6ePJEOTDZcslrJtVsmeCz1tPeU0+AuXy2szmB6xPV5YvS5s0JZzuPIJE3oeKGQ0EyOXRm+QCD0Kl5RR+DxHH69KMRnBwWipImd1xOcFl2XwfqKQZR8mHwORhV3820hAjMYeyTr48zZXFhrBzBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8ZJSo9v; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65940221f7eso3705069a12.0
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 07:06:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770390372; cv=none;
        d=google.com; s=arc-20240605;
        b=EPODjlc3SP4XiFthVgY+i17P0WgZuEL1wLXshkRg82bcdEY/4fHwNzLqjwbojW+xDF
         ZhX9AuAPBQFvGkNbVGg4YougdnfCKbL/nc5XJZkTzWqgCDwmML6dR53Mi217sTl74cyc
         /0HgDVXa3aav6YgnBm9n5TizuvXD5lCTX7rYz+BWdixClJ7c96p+iGAmdRvG/f25MV3M
         1EAb6kmmOPqjpA2G7Cf/5WsHv4HuRfiUhNL/9Ryc6W07aadbJFFkx7/ruHf9GLNlyhlM
         ktwr50N8EtAM1BrG+wJDmzg8kkb/Hfc91fIQIH3wgHsabWjZAeZgpUMXPw3pPwR+wZB6
         VMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hGQBxRDZvTlf47Wu9lDxdnyR2cqQuj+x+M/+cDeQX7w=;
        fh=VUlkhZQG4kKF46Kot5FoH5kMeW2f51BwYOZOMvHIeT8=;
        b=KihGLawPFmHtqN95B7BJLXAJdxW+KJ5AOy9YjZqvYRCQDe/qLQVWR7MAA0daU1P9xf
         61zx5ist2l4G45c4c4gotc/cOmisfwsMyKzEw32UE9vy775KDakEGO55yE7Im2aarIqj
         XQn+ED0CIaY9OvMECug8jaoo2s6mMZ+dZRbvM1hOJyDun04qHSPskuAIhTXEdBjNVrne
         FVbuDy98X1+bxV90/23xzYzR/UPpqK/7Gxiklf7AYsglVahdgwn9UsBLQ3BjKzULgNzh
         4dIwmU3HEhlfeYWveLq7ejMEcAXOMQHFaTqrPOi6J38UFlWTv1Ge6unMfNNQgs030RUZ
         24qw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770390372; x=1770995172; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hGQBxRDZvTlf47Wu9lDxdnyR2cqQuj+x+M/+cDeQX7w=;
        b=h8ZJSo9vlSS5hxQXXJL2q2luhnxCw60rmiHlGjAP+CKSS8DdsC2VK0+XVie7uqk+fH
         NUQ+0I13UPnygzD19MWKJM6ld6u2hnrDDLxr3HQn5EUl4xn6E2x2WuDUcCGakAouh2i4
         prDofeb8LjqBtqHIbJyq8XM6HlDKY1kCDh5HalVtOE3FvDv0c6G1+Q1ndPVrP1qaRaZ7
         bHvsjFftiFbNHfJYASqwwg6YD36l1yJXjXYp/UWYCHsg9RbsJNTMI9AGGxfL96ngTqkx
         hYgLF37th3uZaWfJD9Ios4F9Wocsg6I7ozYacy5Cl6ZkqhwwzkeZb/oywNGUDaGze76e
         8MTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770390372; x=1770995172;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGQBxRDZvTlf47Wu9lDxdnyR2cqQuj+x+M/+cDeQX7w=;
        b=qRGGjMBtJ+XukO8BCxkmYa0lrZb6QVralYpVR9d+MwRzQc7Q/FvgM49koXiSeUJIGq
         xLkcAkME+qCQHk6nFOVLSFbPN5/6TqQ8mwMZGE9eHvteJaRKW1r7eG41Yq9rntqBsjK1
         cdoUQhtishdp2pswvhKvd+SHao87+ELm0/cTRaF3Vx0v1KQ5ZMqDFlhiv6WanKFBpFdT
         HsNtxA0kIr9NSYsoxMNvhT2mSBFBNDQk8IPlw1yXZhIJ6+AqDc32EOBT1mehY+78xw9n
         fmXr9cW3hqScuyrcrF4AWwREl3JDAvLOLE5DnHW4WI03mzVpilqgV6UXXcBgaJcNsp6F
         uREw==
X-Forwarded-Encrypted: i=1; AJvYcCV5U632D8KPzuEwPmawsvmxnXFrP+dYm8fZdw5e79j8lvgwta1EzQkY+QAZmovdy8Uoc+NeNVcNpg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5jk+FBwHAcrfwB/YupagJktrbhYVB9jz+qliEbsPLaiVjc8L5
	eo6fFo2xon9fPoS2rhv9YCiVjJn6dcm4lMZxgxuJbeO3hat67spIATYUdQU3RhzQlebx5VcWPmX
	pr+EOerwOEWF7VRlV+5UWt2nzBUJSTw==
X-Gm-Gg: AZuq6aL2vVp6A06niUw6iot5oCdcuK1pjvv50gt85bECl0gaYqhjx5ZXJMONJEIymwg
	Rkfv6gNGlGoHmb2iWF5J+DtmD3wZnkSfDWGbTP4IYA9HWUd5xpdpdEylkbqEUCChEfIZJ4aJ+X5
	kxMoiF3LSDF4n4KOmHYxdnvS/Nb7p5ft4eRs5lDIw+BVpH7O3W3DVu0LVq0D127smRvtkoRdjww
	uDZggZXj6EyaMZj5L24TgDzfZDzEn9RYF6ydMYrNDt95xyq01k3mAT9lb8miKdpVOsrhiW/KbsG
	SD3BHQA1Dcf0d+1Ts+0Lyzy1TzzygXpQ4dp9kgfsWraGBZHcjXdiKgGzSC16ebqOdmZ4
X-Received: by 2002:a05:6402:5113:b0:658:dbf:d1a0 with SMTP id
 4fb4d7f45d1cf-659841a2f31mr1582224a12.30.1770390372219; Fri, 06 Feb 2026
 07:06:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763725387.git.asml.silence@gmail.com> <12530de6d1907afb44be3e76e7668b935f1fd441.1763725387.git.asml.silence@gmail.com>
In-Reply-To: <12530de6d1907afb44be3e76e7668b935f1fd441.1763725387.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 6 Feb 2026 20:35:34 +0530
X-Gm-Features: AZwV_QhZUfBhtu2huNeoyo9GkYijd3hbyMiyHPwiXwArHA1o3azl0x64XYjc0yI
Message-ID: <CACzX3AuNL0g_VvxMSbUu185rvn97+NpZqOVj246-9q9hAVPa9g@mail.gmail.com>
Subject: Re: [RFC v2 04/11] block: introduce dma token backed bio type
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12077-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.975];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F0053FF85F
X-Rspamd-Action: no action

> @@ -328,6 +328,29 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
>         unsigned nsegs = 0, bytes = 0, gaps = 0;
>         struct bvec_iter iter;
>
> +       if (bio_flagged(bio, BIO_DMA_TOKEN)) {
> +               int offset = offset_in_page(bio->bi_iter.bi_bvec_done);
> +
> +               nsegs = ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE);
> +               nsegs >>= PAGE_SHIFT;
> +
> +               if (offset & lim->dma_alignment || bytes & len_align_mask)
> +                       return -EINVAL;

bytes == 0 is a dead check here. Probably you would like to check the
length of the first and last segment to match with what the normal path
below is doing.

