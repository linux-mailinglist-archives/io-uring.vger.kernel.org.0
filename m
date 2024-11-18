Return-Path: <io-uring+bounces-4775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0109D1518
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 17:11:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 668981F23263
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200DB1BD007;
	Mon, 18 Nov 2024 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2/P9YN+d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6731BE852
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731946290; cv=none; b=hrWqpn3fPfpkNZIh+rhjjCTGUjt1jIAgi8/FON+kVtxmBvU5Rv6Q8NA9EleabAzu6XBa+0jZuIT6fJCQaoqaUuk/cBYHnzzFnJZd5Z5Wtzo/hjCCWj8XsTUvgR4Er9AEVt8XQRb3XvAdfo3DUxNH+hcRDG7tZsMHlUKa+x3FJ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731946290; c=relaxed/simple;
	bh=MEZtMWOTC8LH5U9NWXknvK8AvYQfMrGRW3Jf7gS8GeU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cn4aRkuoejvH4EMZHCqQ2r48zdFCqwkZ12XEKKl9gKGWpLj6iRVSix2CE3Ujr5X9cX901IVCilGrSlRWLAFTrLP/boG5imNhRwIuw2U5q97UsqOvwwCdUUYq6dA6niq8ZzUYhfX01wAZsoqPjxn9ofKjrtMcsCKuE95NCbkT+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2/P9YN+d; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2958ddf99a7so3926376fac.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 08:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731946288; x=1732551088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hx927jxmz3FzeeynBMUqbGfE5ZfNnKTLMES4MqDBXQ4=;
        b=2/P9YN+dZEuBbgzgSfIMHGczqe5sAo+/4+mVyj7fFfeNWIj7NzuPfKzS1bXnTUeyoi
         kmUPVw4hKIWnmSdOZ5luUmnRJ7IQFaxldio51BDXkQ2V9Ux+LBwGi0POSZSNDfjuHDJ4
         vyTFsP6wQyoRQTv+g9rQYsZVucmNZ4EifX6LoWnByHvY+nFR9CWCbzgNM+xxVX52wDHR
         KQailpGkDy3gOxMe9sPbyQeQG3OrcRb/jUla0cPBpV+p7KFiuT/Rq3phlCAlmjLavFyl
         CRthY92ahDCSXmXMV0lJPobEj9QJt+SI8aOvb+e0EFYL6/fDkJWDaP2O0Jl6yBOI8y/5
         QqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731946288; x=1732551088;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hx927jxmz3FzeeynBMUqbGfE5ZfNnKTLMES4MqDBXQ4=;
        b=bxTvS5++R7RbnwJjq1GzBWzyGLkEQqPlxnw/YuCR4w8xjH8lUAvE0KTnyd7Nm+3tmK
         wAxGuiOtNlzvNGZyJFo6z3NQ7ggEEeeJVnJ0wJU21WMiavCYaNVFxXkS94cPeXDc38Ox
         lAELUdVeW17cDUZwn/pybtWZvfHqtoBNvxIdWmo5LSIezDSforsAXeZj/tzab6U2e1JY
         ZO8GcCHWcyw8mFjkujgmIjULVT253JGdUMFEhxkYGQZM5284oHFennpxUm/CXmPhEmQS
         4aMyh7qmtGbXAfHtO6Xe8UdTnoxmcnJNy51PWVCMKYZEl6ZKlm1EoFdeUFTJ8T8109+S
         vOQw==
X-Gm-Message-State: AOJu0YxRwy7E97COEkwODb3U1Z0dxkKqILZjAT7tPNrRJFKX2jVUjD0F
	QygZ+XSOp7IJL0KlNDGH5jCXrsTsidbv4pLyD/ADv74iaj+sVy32be/IVjFZDC8=
X-Google-Smtp-Source: AGHT+IEbpFEs/qwiCU3a3z5mY47iign3X5haO7YuouqA3ZnUkL4kDKM7PhQ33zrCyJS0cw8J2He+wQ==
X-Received: by 2002:a05:6870:6122:b0:296:994c:e6db with SMTP id 586e51a60fabf-296994d6731mr2522945fac.16.1731946287798;
        Mon, 18 Nov 2024 08:11:27 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296519331c1sm2676223fac.23.2024.11.18.08.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 08:11:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com
In-Reply-To: <8233af2886a37b57f79e444e3db88fcfda1817ac.1731942203.git.asml.silence@gmail.com>
References: <8233af2886a37b57f79e444e3db88fcfda1817ac.1731942203.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: protect register tracing
Message-Id: <173194628682.10763.16149276183212711183.b4-ty@kernel.dk>
Date: Mon, 18 Nov 2024 09:11:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 18 Nov 2024 15:14:50 +0000, Pavel Begunkov wrote:
> Syz reports:
> 
> BUG: KCSAN: data-race in __se_sys_io_uring_register / io_sqe_files_register
> 
> read-write to 0xffff8881021940b8 of 4 bytes by task 5923 on cpu 1:
>  io_sqe_files_register+0x2c4/0x3b0 io_uring/rsrc.c:713
>  __io_uring_register io_uring/register.c:403 [inline]
>  __do_sys_io_uring_register io_uring/register.c:611 [inline]
>  __se_sys_io_uring_register+0x8d0/0x1280 io_uring/register.c:591
>  __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
>  x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> [...]

Applied, thanks!

[1/1] io_uring: protect register tracing
      commit: e358e09a894dbcd51fdbbcf62bec1df249915834

Best regards,
-- 
Jens Axboe




