Return-Path: <io-uring+bounces-6660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D332FA41F57
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25BF9188F052
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC258233729;
	Mon, 24 Feb 2025 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kbdgLh9O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBE123BCE2
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400894; cv=none; b=iPBzSSYbHOkqoaKz+EYNq6huJoVtsUINXIHx8h07YtdBPdUpIO0Pc8LVLyp5lIdY2v+XYMtAO0e9CwKmGZh7sqQybF7TUYtOsVMvIoatNch0MJU/OddpcytHkaxh09yBT82B+81U+7APJ6v26yctcxJyL2bRPm+Gs65xez2ll2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400894; c=relaxed/simple;
	bh=Z6GhwnI1e5BI7X2uP4tGgG0Dz/SOqEKZ7JzUAQ9mcOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ggSxd3muU8Pzv9ro3FEikYNxGSc3m3w7ZUUf+sZLnXJ0lTnDGR54cA539LB6K/e0fnzlc+CFdQzosFllr81OxPWHxBjuvjdi1JK6t22lc/g+y/2x27kc4vc/MvYaJbG8JuYA2RLTZv3GKHH8qt6UoRCapVOIDc//cbXco9JleFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kbdgLh9O; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5dec996069aso7026341a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400891; x=1741005691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8NUicT8rtkRKAK07gURqQEtoxj7wvnHRq0Vee/gbmOI=;
        b=kbdgLh9O3oDkOsY04JWft6KgoAe0xOd0FPZPOcNtrqPBhCBOGhFoZdLL/7jFF9i+AK
         1q2eB1i9YcQ+8XnXYbG+DezOAqmU+LZyD4xkF9Fghc5u8YaF9kMreyz45pDoXSvM4i1A
         9Gg5QxjiFtsmMOxJnqhkI1UF07o+e8+nnGVtkkc4fEBH99X8SXBzUOPEqJ8TCVIBUtYA
         95j58l+DMpSG8VmVORKKF+K3hcaegB5FP6GMMKg85ykY+1bg0MJFwRpbqn4wHF1r+AAO
         Myn69m3uWFpsJ5iQ9Jzu/bSKLeR8mnvfqM7zzMmxeykmKYRjWWa7Z+NphvX/g/f6RMWd
         URew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400891; x=1741005691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8NUicT8rtkRKAK07gURqQEtoxj7wvnHRq0Vee/gbmOI=;
        b=jYWoV1MIOA3oIjl17s4k8vTcP9kJaY+8UnMm4Ks74w+geihtFsw9K5MSJJNvNr/4Xv
         2IUEEJnRstLyLB6Ve0UjPILCi1AKIgLThLpaOBOsz7nAVXcI35lrM0jAJBgldvtUmYjV
         D0rbCFtx6qI/kyltNYSzjXs+LKKSu+wsxLXB/NoSsMRxnlDk7EWtMSmqmrwH6rbbQEKL
         rMHqmxJ5YsUyotYqT2fivTslQqhTO+JcKCTAs6c3dWp4RavkTDnIFC7jtx62KPk5N02h
         XPVLv5OHoEQG/lCXsoaj+vilu2K1JfMUho4KpDopznbBeWDbb1Zcybt1aRZu64QiEpeA
         h2lA==
X-Gm-Message-State: AOJu0YzbJTrkPTJ/s7KlyLuGYCQ5oRufNB/LSGI4dnNThnTMs8HO6aDZ
	0gBsKgE6T1hOlJDdyjtG5PgbE2JghIA/vroHpXqcFXGZcYkS2T6XO3XUeg==
X-Gm-Gg: ASbGncu8OzcM42GX8vReTEJxUM6k6Q6yvwuFYOELz/ElqHFNciCeSMNGy5/OICyY/qh
	mVp7O4+nbiFuDg76YTi6Q6JdVBx7bbNqUD+J1wDpP/YmQQBFJwPh9zEGuxD5ZbN12urytHLjWne
	7YM90liU3Yd6BoXs+TogcSgq9CES8ya4DLHWUPkz5Kn1oznplqJFLoG08qqwWOwCelka/MwC5mz
	dJAdkkKHcA1BtJ2rmZeNnJ6FmV/KLw8D0tFg/xla2wlOF8STsG5tHPvSVk4UQk3hfcKb1CLAzxs
	gK9G4I6PkA==
X-Google-Smtp-Source: AGHT+IHiWLoJ2RCCWZqZI29KmmwxLF+aXdlgx3761i/C9WlDaFyJWNeLuCN39JB8LSF+4Lf/N5E6BA==
X-Received: by 2002:a05:6402:5212:b0:5dc:7fbe:72ff with SMTP id 4fb4d7f45d1cf-5e0b70b5f52mr12481652a12.2.1740400890805;
        Mon, 24 Feb 2025 04:41:30 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 0/6] compile out ctx->compat reads
Date: Mon, 24 Feb 2025 12:42:18 +0000
Message-ID: <cover.1740400452.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some code paths read ctx->compat even for !CONFIG_COMPAT, add and use
a helper to optimise that out. Namely cmd and rw.c vector imports
benefit from that, and others are converted for consistency.

rsrc.c is left out to avoid conflicts, it's easier to update it later.
It'd also be a good idea to further clean up compat code on top. 

v2: also use it for net, cmd and waitid
    remove some of the CONFIG_COMPAT guards from rw.c

Pavel Begunkov (6):
  io_uring: introduce io_is_compat()
  io_uring/cmd: optimise !CONFIG_COMPAT flags setting
  io_uring/rw: compile out compat param passing
  io_uring/rw: shrink io_iov_compat_buffer_select_prep
  io_uring/waitid: use io_is_compat()
  io_uring/net: use io_is_compat()

 io_uring/io_uring.h  |  5 +++++
 io_uring/net.c       | 19 ++++++++-----------
 io_uring/rw.c        | 22 ++++++----------------
 io_uring/uring_cmd.c |  2 +-
 io_uring/waitid.c    |  2 +-
 5 files changed, 21 insertions(+), 29 deletions(-)

-- 
2.48.1


