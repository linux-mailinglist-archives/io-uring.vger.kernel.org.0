Return-Path: <io-uring+bounces-11599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB6FD14C83
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 19:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BB0493005ABA
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 18:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1404B364036;
	Mon, 12 Jan 2026 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Abfj8vcT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8E92DCBF7
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242893; cv=none; b=LdW9KVWR5F06DR7c/o6ToAQEDzFntuUeAY5WJZo6aDubWWTKkuldZAQlEqCAwSyTcn79ZRVc1SS2GunoO23CFVpgenXIn2x3wQPfd+h0N/ulJLfCqSOLqskUYwag9Zw1bzeWrkVzuyIu1vvVdCItZUODhtcSEMPQS4P1pgDugpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242893; c=relaxed/simple;
	bh=ZH1dX+pF+DdfP8/u9ZZrRufX4ga1/hIn+m56AgJXFXk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J91dSrZ74RwAGe5I+iDl/GFMocU1yvb6XAMxT11b3Gd+7pGkio3Pg4JqBHkc2Vv3Ga2y8T+XBHXsKMdNjK1ut87IBECgvUVR4NRb0u3AwEKQBefMqfryF4yzDHCLoNSptkHDpzNAySatZ1q5YlBfTP5DXDRPa8cho2iJTu970x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Abfj8vcT; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c7545310b8so3841289a34.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 10:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768242890; x=1768847690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3iE1nriphS1IiiMKNKyYmW+UJaAPy6/CYl7zzGYWYc=;
        b=Abfj8vcToOPSwsPCkBmS7LoqoJlAp4i6MWnvpWqdWz3yHp7MNj47hfz/4ofI1dUf3h
         MBBu8Pw6PFPDwdJxLi3bvt+usg+mpeK4Z6TztDtLiLs35nFIPR6jbDaxKbcCGEEvN2iF
         u3nyUcsodcKop1kZO1f79Rxq6FAMZ4b5XgA34yb7gM8ar6fdLWs86RONXOpPj+SyxAdx
         6eCtt99nih4p+2gS2+FSJjw9HX6JbrR8NlqtARmeVkdOeHvNHPTdzP5man5wY19uwMe7
         bvbVleTIl6I8TtZlzyEeJiXy3AXAxxwS0CqSCHNLY/kGLxsxVXgTlQGvqK+xcr/RJsTc
         C2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242890; x=1768847690;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+3iE1nriphS1IiiMKNKyYmW+UJaAPy6/CYl7zzGYWYc=;
        b=dKweG8IAo1MJL4yPTSP90dDA3uQivm239DAoZBeUcIp/Qo2c7rFb2woRfWgTwrBsfq
         gpzG/28LvICUpUE8wvJaSV3ZXZytlz/rZNNR5gLeyh0HuieN3/TcROamXFsGeJG7eWWd
         BuT7sbtFVz1D4gR+QoBgX42lJtNSJv+0B+rBDzpokbEnuN/FMic8ebYM0Y+tV2VIL6/H
         FeX87I6uwtn024NSIUGr8fyNFHx01OeoD2Bg/4KHvJqRUf+P9YMSxh3mapojGyent3EI
         Z2zk7mNsV7H3twjQ/9/iH5AEMaO01uEakOFzvaDGWZWSH539L1hmHldLEctQLFoB6BLB
         lybg==
X-Forwarded-Encrypted: i=1; AJvYcCVzRp7JTriAaqs/6C+pSAaHGkn/gfUSESmBHgsztwDosioLBpkg3D8KjJakZDYjE1JjWIIIjiKyGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFi7R09b7xgJuiAJwvO/UlJBIcXXCz5tf6s2EPkWhcGk4EOJP2
	rbWpF4Q+J6Kewd4QgHp3kpemPSuguV6EZX7lGWAa6yS6/vsnbMnS/q7CFlqpULBm3EG2xlvUvge
	CZbx4
X-Gm-Gg: AY/fxX5WCKmzj055Mw1zXnS6MtYP42pEMX0s8lPb8SW/zV34TdKG5IXPh+Dsw4poKrv
	iCVesJRVbvtPBpf7Xz0feeyjVbd0XTzZMsi/XjW9NEM9dOf2acwWhdXct13AvmhiH0WHcJPU6Oj
	kTdxF4zQGZ8Rxo6oOuv4aM6U5eZHtPGwOUBEnGDAVQlznuI/eKAf16HMgYSJ52dfXsWuomJl4XD
	mGtkRoT+nUGMEkEOzbiRmadUCpcvlmMuqKDJQvflJSq+9MOz2GemNBsInFC1Q+RBHVUyAOvtEoS
	Su1Q4zJOWvU8Sk11QL7yFQm45BceFwlg5vNumSt/hts1U1MT/1q9+7HgjnEK+KiHCisaUia6WDE
	CRKi2BbPJ0/QDahkDng43jyFbiWEaDFe3JeTsO1ONQXIUmA6i9Qaet8o+444fGkNmbL28j/Nmuj
	SrFQ==
X-Google-Smtp-Source: AGHT+IGv/gWQ+VMEoo/waYfcmeeggseg7BHlxKdZScPoAkHa+beBxRMVCg4VfTKteOt0+SHqmO8P2w==
X-Received: by 2002:a05:6808:229e:b0:451:4da2:47d1 with SMTP id 5614622812f47-45a6beb4254mr10809279b6e.45.1768242889982;
        Mon, 12 Jan 2026 10:34:49 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm8250460b6e.4.2026.01.12.10.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 10:34:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260105210543.3471082-1-csander@purestorage.com>
References: <20260105210543.3471082-1-csander@purestorage.com>
Subject: Re: [PATCH v7 0/3] io_uring: use release-acquire ordering for
 IORING_SETUP_R_DISABLED
Message-Id: <176824288921.224398.7954184265686389953.b4-ty@kernel.dk>
Date: Mon, 12 Jan 2026 11:34:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 05 Jan 2026 14:05:39 -0700, Caleb Sander Mateos wrote:
> io_uring_enter(), __io_msg_ring_data(), and io_msg_send_fd() read
> ctx->flags and ctx->submitter_task without holding the ctx's uring_lock.
> This means they may race with the assignment to ctx->submitter_task and
> the clearing of IORING_SETUP_R_DISABLED from ctx->flags in
> io_register_enable_rings(). Ensure the correct ordering of the
> ctx->flags and ctx->submitter_task memory accesses by storing to
> ctx->flags using release ordering and loading it using acquire ordering.
> 
> [...]

Applied, thanks!

[1/3] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
      commit: 7a8737e1132ff07ca225aa7a4008f87319b5b1ca
[2/3] io_uring/msg_ring: drop unnecessary submitter_task checks
      commit: bcd4c95737d15fa1a85152b8862dec146b11c214
[3/3] io_uring/register: drop io_register_enable_rings() submitter_task check
      commit: 130a82760718997806a618490f5b7ab06932bd9c

Best regards,
-- 
Jens Axboe




