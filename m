Return-Path: <io-uring+bounces-6676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C16A42341
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 15:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE84E7A2E39
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D541614A627;
	Mon, 24 Feb 2025 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nx65tdTp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E4C1514EE
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 14:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407748; cv=none; b=DhuVpuae+1ipRFRYamYABDrOpk5f6+VXIMeroOIu/w30Cjfba0AzNEnTv41PwouwnXK0N9uz+zmMz1WcJ1s0mR5vjq30S7FpWGbmPxUSFQPV8yhejaLimQYrDZeQ162RGfwvgJiWDu9Nz7uHEgdLiIGAgSuJTjkI4BQxASF2E5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407748; c=relaxed/simple;
	bh=fVzHiucMs29WQjkGX3NDHyZzLwjLUE3lLr35emomtIg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eKQ0qK7PEE9Ktow2CzzWvtoo9WNRnKVtz7hY+yhyCYk73NWbFjgdqbouE4uDgUbO4XNwKa8B2jj4Ht1FkEZRP9/68O0P35PJQ3wG5cm1RUoZAoFkVS5VaqqTuvpZJgQym+V9glFG4yhIK2Qjvi8V7ZlbsDj0KTVvHvaJv0cyOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nx65tdTp; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-8559020a76aso112860839f.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 06:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740407745; x=1741012545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkPQZoJHjJ5n8zO6HMcqKkFDlPqlVedvu6kpSAaZLuo=;
        b=Nx65tdTp4+6wSyrp7Fxs727DWYn9SJphkV/se6sxsdGQ0rX47Zmj+d0BUcAWV86UC5
         r2RNJehzFAP8l3vX/me67iRYtC5Ykn6gK+S7xD+MepXAKLIWWsVRRm4wat5XT5wFaARP
         Ue0DG89eMSW8Oz0+fCS8R1TW0uQN2HQjJw6RguBJdeG9EJ7nSmeCUkhCYi3cniH2hOuu
         xEAtgGrWRhdCSVyiP/GnN6PHS4xv87U/v1EwDk55jcnL0VU3d0FDdFLKI+QHNzFbFlww
         eaXVRER6DNiQSoaC3tAthDGiYn1Q9huMOWmW2n3xiJHXGlWcEJrMy0b7Bgj5htTFu0LV
         /d+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740407745; x=1741012545;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkPQZoJHjJ5n8zO6HMcqKkFDlPqlVedvu6kpSAaZLuo=;
        b=RpY9g03Ns8XUzjZjw4lFzFyVA9aFXOTgOZ2jzfYTK82Hvk1deXr66ir3yIfSzP6dsd
         uz8AALOsZ+VEMf2NzyYvvOgAtpE3XMBHCvOCUkHKeLupPsLacHILiIrvrFQtAbnusNJU
         W/TOl2WmPWX9M13t7PCAoyNBL/aqLavqkl8OmpMIX2UCFrx28kPycqkPu6YYZXI2tQ+e
         Lqtg5PFOfj3V7kNaUdF18ZoTV7wNYKV/vthyjC7Ei5UY73niok3jjBbwwJpyxU2d5Slv
         4lzm+D/kyCENE2SCoOGalSKRE7iXJFaCfR2gVp3IEIZDAFe3z4BNtC0JgF2z04jdfcVH
         ImgQ==
X-Gm-Message-State: AOJu0YzZUSpTsjfeGkNfyNy6/fySia4xdM88Z2busZ/MZuPKnqrCnp2I
	kT5vGdpLSpgfhJyNuPSIqV1b+YDMrMkSU8eaFclHg6kv3Dv4G4lfsqx/uJ/0Uhs=
X-Gm-Gg: ASbGncs3p81AD8OU+9xdMKj36ODe6ZYMObrG3SF58ldQ/kd+N5gbZAabS8OLekGSYhJ
	Vr4iBhT7q/BRUIq34O/zQ6FK+k2x2OLWsK3WrvrXS8I7aITqAZS3wqjYP/hZRctZxP6S50Fe4Xs
	145fevsFUF7ZGw1I3Nw+4n24S5O+lhPYmIBVYLM7hVF6CVJxK7ggvtPBcQjmil3PdKUZmfwnKVR
	hY8lYADMJDUrtGzrQYRvQwYLDy/1Cp90lh0LuyeVdUotvb1UOKdarWf5TBRr8+qX4igztvH9I/q
	VmDDv2MviCAck65bqA==
X-Google-Smtp-Source: AGHT+IEtM7W1iVaP9XgrbAzzHG3lugcDZd9sMzbhJijno+XGNTw2+ToSSWElZG+1tEf4V8OtWqtpSQ==
X-Received: by 2002:a05:6e02:1d1d:b0:3d2:b34d:a25b with SMTP id e9e14a558f8ab-3d2caf027eamr97564615ab.16.1740407743246;
        Mon, 24 Feb 2025 06:35:43 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2b2fb94d7sm27876985ab.36.2025.02.24.06.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 06:35:42 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj gupta <anuj1072538@gmail.com>
In-Reply-To: <cover.1740400452.git.asml.silence@gmail.com>
References: <cover.1740400452.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/6] compile out ctx->compat reads
Message-Id: <174040774212.1976134.16272080365132651493.b4-ty@kernel.dk>
Date: Mon, 24 Feb 2025 07:35:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Mon, 24 Feb 2025 12:42:18 +0000, Pavel Begunkov wrote:
> Some code paths read ctx->compat even for !CONFIG_COMPAT, add and use
> a helper to optimise that out. Namely cmd and rw.c vector imports
> benefit from that, and others are converted for consistency.
> 
> rsrc.c is left out to avoid conflicts, it's easier to update it later.
> It'd also be a good idea to further clean up compat code on top.
> 
> [...]

Applied, thanks!

[1/6] io_uring: introduce io_is_compat()
      commit: 3035deac0cd5bd9c8cacdcf5a1c488cbc87abc2d
[2/6] io_uring/cmd: optimise !CONFIG_COMPAT flags setting
      commit: 0bba6fccbdcb28d284debc31150f84ef14f7e252
[3/6] io_uring/rw: compile out compat param passing
      commit: 82d187d356dcc257ecaa659e57e6c0546ec1cd2d
[4/6] io_uring/rw: shrink io_iov_compat_buffer_select_prep
      commit: 52524b281d5746cf9dbd53a7dffce9576e8ddd30
[5/6] io_uring/waitid: use io_is_compat()
      commit: d8cc800bac886fac69cc672545eee89dbeb50bef
[6/6] io_uring/net: use io_is_compat()
      commit: 5e646339944c10d615b1b0b5a2fa8a4f6734f21d

Best regards,
-- 
Jens Axboe




