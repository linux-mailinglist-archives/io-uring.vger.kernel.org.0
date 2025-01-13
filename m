Return-Path: <io-uring+bounces-5849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 422C0A0C4CC
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 23:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CD737A5011
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 22:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CC51FA14B;
	Mon, 13 Jan 2025 22:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nVLQx/Mw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294FB1F9419
	for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807412; cv=none; b=IBYT9WPO/x/5EikxQNUaOMPGdDHb989yi/g2/jC4rdVTbBZhMzTICmsFLS6MX9DUHAnOOinANcytyawV2qtDGr8hibsuIXYXkkbYvdMqgNLfSsYfpGcN0jpQbWLyrNyPH/otPQzqNVLgUN4cSCJHPUQPJm5yTA21ccw6lNVFapU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807412; c=relaxed/simple;
	bh=hUgEwdoHcBT26rlpizn+ruY8wmBwdO0kVUnA0F84F0w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JL7DDohonu770G66Ayy+Ypo1bVtGqRRfM+jc7VLZAzdltF+2seNg0SpMLWnysKZKJfPBJfBv5htbex11JQZvA+cEG3Lre/BdJHQ45xPgHZikjs7HUdaFzqTdxxEBH/ks6wmWrcd0AsXOL/45kuTh3WiEhM6yZWd0omsM2ZtJ8gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nVLQx/Mw; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso11861615ab.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 14:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736807407; x=1737412207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEtnQ2duiHf3hSpucZN3b3BFYLg18RCwSD6UbrLwQ40=;
        b=nVLQx/Mwb+j32c5c99r+XJXUJRHckAJGiJP7lexYDIZV9j6xtRVXgd3w9X80fJNAzk
         xqtXKYCHc+fRVDMZYA+w7OHHzF7GbmWBgiSVNgb8ejSmidr9nOOJQMqGV63v26f2CcRY
         xJ3kbPyymphljxBOzG1pV/MDERyHP4/sYq1do/LkZhV6YSmcA5vI8RD4e++uRb2JaU2E
         GdRRoI3g0xuWnKYbPIHRjlTIVpj5reGPBI6UU01up22mm77DOnyEaIfu6jA6ow7xBYPY
         PMaNrHFFHwlCNDgjrU3tXUnrAuoUoXzXZAdLwzf6bGd8vl9Fm6zelcHmog1kMCw6yRgq
         lffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807407; x=1737412207;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEtnQ2duiHf3hSpucZN3b3BFYLg18RCwSD6UbrLwQ40=;
        b=whmWB1tfuNslw1b6E0OFExKjeMcnTRnbL4PfR8xGSojmgL8EiRzYphCCO0NQmsMsNG
         9truBOqjQQ098knmHz9etVdeeUsdFhd/PmSFoaKi3JchsXwvlz4XedI4eXqJaWURa8uv
         Iz2cAmEm06e0xRXbCqsCqwUlLPjLZIE4SD8a4zV4nJJthh7GbgJzLKCLfVjiofBbQ0pm
         f4J+Dy05BgbbgTZqw1RWoLfuX3H2sjdz/KrM6tchyNnQbeMFmHXt2R1/L+EnuEFg/6Qq
         nVWDSTZjFG5soN8fP7a3rpowLGBjZk3+Mfkq+j/vl9rQHsBD8CFmKkDpuMio1Zp+hmHS
         2yoA==
X-Forwarded-Encrypted: i=1; AJvYcCVhYx3yyYEp7OZ484UkaFxhcwoObyR/7KjT68M8ZJmwFOgZUUZ9O5YocPnF90Y+nmgF4y3Q1GQHCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUS1c991JHRpsawsAXDBEGooUGU0R2k+gMe8tpk6AfYJ62djvE
	/kDm1FXB2uvKL9Q/lW9ikdMTApbVTsfgz1j98y4INIiQOPZDXag/YhE6SWu/evY=
X-Gm-Gg: ASbGncshrtezHP4Vp3JxUnmNqsOdMdDUOOXo/6iDdGkVcp/Vqew9y5Z29+yo88Qmxj5
	+GUB8hixSUeXv01GV2/9IAQu5o0ad6h0gjU9KtXFIWE61Hq0HYCeBMbtD25cnPVzmUYLIqAx5gx
	jJIqyvh39Sxh69Pa6LWeTAU7RO1DL4gZIFLHPSi4yvKqi8FCPmFx3ouwuHP8vd/eoADg57ZIR8j
	8c4MUkBc58grm6RgYZFhJqsDeybT1D2JwQic3uwIMYBWA+c
X-Google-Smtp-Source: AGHT+IH14nhDCfcE/VicXuUGkNCUwz79Cq5l77YJlqvmJudS4QIjKRZEFSv70F1oHkafS+cFB2okYw==
X-Received: by 2002:a05:6e02:154b:b0:3a7:e286:a572 with SMTP id e9e14a558f8ab-3ce3a86a535mr161533645ab.3.1736807407481;
        Mon, 13 Jan 2025 14:30:07 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7177e4sm3019798173.92.2025.01.13.14.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 14:30:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com, 
 Li Zetao <lizetao1@huawei.com>
In-Reply-To: <20250113160331.44057-1-minhquangbui99@gmail.com>
References: <20250113160331.44057-1-minhquangbui99@gmail.com>
Subject: Re: [PATCH v2] io_uring: simplify the SQPOLL thread check when
 cancelling requests
Message-Id: <173680740642.1193220.11121663333496197972.b4-ty@kernel.dk>
Date: Mon, 13 Jan 2025 15:30:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Mon, 13 Jan 2025 23:03:31 +0700, Bui Quang Minh wrote:
> In io_uring_try_cancel_requests, we check whether sq_data->thread ==
> current to determine if the function is called by the SQPOLL thread to do
> iopoll when IORING_SETUP_SQPOLL is set. This check can race with the SQPOLL
> thread termination.
> 
> io_uring_cancel_generic is used in 2 places: io_uring_cancel_generic and
> io_ring_exit_work. In io_uring_cancel_generic, we have the information
> whether the current is SQPOLL thread already. And the SQPOLL thread never
> reaches io_ring_exit_work.
> 
> [...]

Applied, thanks!

[1/1] io_uring: simplify the SQPOLL thread check when cancelling requests
      commit: a13030fd194c88961be4679f87a1380f1bda0ebe

Best regards,
-- 
Jens Axboe




