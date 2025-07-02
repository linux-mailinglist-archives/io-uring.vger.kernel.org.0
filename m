Return-Path: <io-uring+bounces-8573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5D6AF5AEA
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F122A162B99
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086542ED87A;
	Wed,  2 Jul 2025 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DSYB0ftp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05C289340
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465880; cv=none; b=nlB2RIB7USx9ENufvGW/4/145+OQjt2/wOMawwZyiefsT+k1fqOMH+tPbKGBgxO8pYMBR+7ZBqNsfsaO7ddpfRKrXVrwaqQLEeUe1Ip/7KQBd9D5pZ5VEg5o1m2tlRwzNyMCivczhIDMn36/WSiggdiWoXWzQ7r7h28kzNSamro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465880; c=relaxed/simple;
	bh=ydMcyp5SS7kxhgCliLKrBOO7wIIsEALCF54R3ybP7vI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TdG/ySFCCnFWTIlh90TUC37moXi/ASv6uXJ9qs8llR9BWXtwMeepgVz784dzXbGYOUe4Z8zzShCnhfLZxdNcTRXvJwpgneLPCJZCt47HvIZdaa6JG50lKdnpzBKpPqY2vZSu4wbLe0KeSR/mII+WsV4AWKNKaiDOZ1aXRZUiTyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DSYB0ftp; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3de2b02c69eso26483395ab.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751465877; x=1752070677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfIYX3SmbgV1jRgSUvm3VHNg9uAW0Ihd8lm2wc1+tFQ=;
        b=DSYB0ftpubwmKiQkNJo3ofcaO6zqnkRJ0jfV1q+ttzsPYTULlTa/EhUuOW4jdhIFSK
         z8Z4dYFXn6+C641H7rVs+21YJWOJmYiMSizaF2xp85XrH1L/Qm+GBzlN68Of9hwiiWxO
         /szuNiCZG0NPXkqNAh0H+9B8whj+xTl2aER0G3Fj06yJP+ZGoPfFx7rhJxCBu/3gJQ2R
         cXDp6Bkvwx4XW7mZ76rDixrZHnOMc1UbimQBxCqwWfnD3HY0vuvtldfD2LrHh49F0fxP
         CpI3IJh4aCbwfAGveSXPskGQxRlOO8OqEzU+yA68RPy0enzERoz8Cr5chVDcYDP0zmls
         Tr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751465877; x=1752070677;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfIYX3SmbgV1jRgSUvm3VHNg9uAW0Ihd8lm2wc1+tFQ=;
        b=Jm2nZnPdzMivG+oZMNZSTJVUJ+KdPDEsr6df74BopOXMzJWsk/imSp0FdKtFPNxFsH
         2zPGqszK/CPh61MoE9i2lJzSPVzj/ek6fqZnDJoeAPAny42q8k5DAxfDCeEiOB2hTJW2
         hlqEWHDWX0q6+eymt4jtloBzooi+UtYNGi3oLqD5bd+RK14OXQDJD4masrQkhPfKoATp
         4U70jHjUOn0WTuTu/twwSg7RJdfDKcZVSM3hu1+zfzuo7AhOai1Vk1I7lw+zgp7FvJVQ
         xub+E/rJslDvOiaAZyzE3GHrdwLeVffgIm1Ppe/8y8533q9Zoz6Fs/FF1Rr2lb3Q27zC
         w7Kw==
X-Gm-Message-State: AOJu0YzBiCL9nJXjFag342/QyQLZhvltx9TDdABkFTlnWnB3LChsssKm
	tVP5GbenXeD8ZbvG2w0OjYJzA8e4TkV5sQ0niAwh7Ib4wCB4ukgTWMCBcs6XMrfQBN7c+RAJxax
	uTR0b
X-Gm-Gg: ASbGncspAVnMWCdvTi5tXFphejw/BZpsHze0/zeCbEqHtXG+U1CYCJFL2wZMUfnUjHD
	pGfz1lzKu9dNEevnhhtgW1UUFODLGa8F4enrfP8lrMkASorZDnbTNEF33IWB6RpNaTA+bnzHLdC
	mpunK9Z//sQxoecS8wymnwNqZ8BcV66yFMkC6h+wU0XztmrRLa4EHV8iIzx9ebw9odQvKgyS9rL
	ui//YFUwD9cNIRsMzf301OZZZ+x3a4KQaParNTMikjILvP3QTZqu1empgMlmJaXVdb4pjcXjbKX
	WmEX5Tz9/foNtKvPvM0KX7u3LD+//26HGp91aUPoiLTkIM+/YhgLtQ==
X-Google-Smtp-Source: AGHT+IEVa6wlB2UTzR2hcwWOv97vu1+JcYVNyekFH8AfJHyrlUk8jOI3sF1PdWkMjwe3TGTbTZn3Mw==
X-Received: by 2002:a05:6e02:b47:b0:3de:119f:5261 with SMTP id e9e14a558f8ab-3e054934c6fmr37501085ab.3.1751465877071;
        Wed, 02 Jul 2025 07:17:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3df49fed143sm35310615ab.22.2025.07.02.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:17:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1750599274.git.asml.silence@gmail.com>
References: <cover.1750599274.git.asml.silence@gmail.com>
Subject: Re: [PATCH v5 0/6] io_uring/mock: add basic infra for test mock
 files
Message-Id: <175146587641.459067.1856186279033829780.b4-ty@kernel.dk>
Date: Wed, 02 Jul 2025 08:17:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Mon, 30 Jun 2025 19:16:50 +0100, Pavel Begunkov wrote:
> io_uring commands provide an ioctl style interface for files to
> implement file specific operations. io_uring provides many features and
> advanced api to commands, and it's getting hard to test as it requires
> specific files/devices.
> 
> Add basic infrastucture for creating special mock files that will be
> implementing the cmd api and using various io_uring features we want to
> test. It'll also be useful to test some more obscure read/write/polling
> edge cases in the future, which was initially suggested by Chase.
> 
> [...]

Applied, thanks!

[1/6] io_uring/mock: add basic infra for test mock files
      (no commit info)
[2/6] io_uring/mock: add cmd using vectored regbufs
      (no commit info)
[3/6] io_uring/mock: add sync read/write
      (no commit info)
[4/6] io_uring/mock: allow to choose FMODE_NOWAIT
      (no commit info)
[5/6] io_uring/mock: support for async read/write
      (no commit info)
[6/6] io_uring/mock: add trivial poll handler
      (no commit info)

Best regards,
-- 
Jens Axboe




