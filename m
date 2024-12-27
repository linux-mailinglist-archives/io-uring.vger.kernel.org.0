Return-Path: <io-uring+bounces-5611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A28259FD5F3
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 17:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 409F7162EB9
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 16:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F5E1F1307;
	Fri, 27 Dec 2024 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZbLsj2Om"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E121885AD
	for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735316733; cv=none; b=kJgeXP4WzHUOO/IEl9aacH9BmqkbkKeey88jtnyyBrb3ua4lt6TjzYUNSu/hjWYzRCZfI67a78r7I04hkiKwzUYjOm1AYKQ5935uq79ZIkIp16eTgaXPWq7zOGZOGa+2xvXKmqf6kxUz3/NcRO1efPLD3iGgWuL4jVRyzrnyrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735316733; c=relaxed/simple;
	bh=1jLSA3ZnUdit9NodB2bR71LdxjGPyu6f6A4c7BxFVK8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZnPOUG7neE3XqNNbr02zLeUsAbRwoE8bXCDXFPrqn+zKc7DiCbn8RTucvqH4xbZ/dcQrZ4TKrg40dkFny+lQt9PkezzN8N+tNXozcQlFrIKbnBdg54OCpD43Lo4K/21yhOK3fdymBfSIt4N44ecoeo7PCF/2zHLhB3KkmrAiOt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZbLsj2Om; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216401de828so86662885ad.3
        for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 08:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735316728; x=1735921528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tV0dJLQpVdivyvkLA0k3mL/X8eZJ/ixWeqeH90nfeAo=;
        b=ZbLsj2OmlTwiVAe/DKBNINxPIKTH1CVvcRU5I7C6ZZGNG5PmGnAlG3EChtKjczf5v0
         mR2DGHbVbA1baMPXbSlVMkVxObhoo/l/oHWzfKyA5KaJJN6PmqJTM7YcuDOXlcgQnJX3
         qESqWysqJIie6BVn/UcwqDtzzklLiG6PETpGaNTjFvuWsH0hwSx/pBYjdvnG1m0VFYbW
         OLkKBcC2rPM39zPzjHewRAuAhvkHJ5WQGJWSs1bCH51P0/vgWzON7EdNeIsniPv8lR7f
         ByhmvJ89/3L4DJOsQHvgFdcwYcRqM6GdWGTdr7UBi2brb/RkUK1vlhbHYPzf8SivhLkR
         ny0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735316728; x=1735921528;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tV0dJLQpVdivyvkLA0k3mL/X8eZJ/ixWeqeH90nfeAo=;
        b=nOCgcb02Vm/wjfrCKlu2VtDuJ2yTEYubbQr7vIM2CSzqAuuMMwU/vx58JdCa1sHGKm
         KCFchLfl4wVvFy1c7prbeCIQZD9LEC2cYj7bwz7QHT2eL0NMko1u0QHyW4mVpE6EzhbU
         TGF9htdf1EL7GpQq4MhQyroT4s/5o+4UKd5Qm0hAqt59zna6nLWHyBEHIwGk4Bb3tllZ
         lv3JsfEglET+j8Tr+f9wngaO8zvGhBa3sKffxEEZcpfemjn2ckQOnmLNjGZpXaeat2cH
         b4d7kaZBl+9dErLuZKyrNfJb3GGN5VorvjQvEtTj4PVX7MvdSUrpHKlt1fKtx7t+HLU1
         JtiQ==
X-Gm-Message-State: AOJu0YwdnWJAzG/Yqk/w7v71A48ibl4ApUtd1o12XMPig8zuj+fKzNO+
	Kh5gO8l/FVTEnF0LQ3xjHr9zoLvF1xWGAWHHuCrlWj56JR0LPDKpl6CVtqWFz6M=
X-Gm-Gg: ASbGncuGaXOseCYQUETmp5xg2AmLu4fSW+Y0X8jjtB00cWzjGWjzKxX7OpSqs/oDjPA
	GLsTMBOjd76OpwL5pHFxKe+MEoBf0UWa3jl6lLHaNrRHmlZKorS879bIQffHr8HSjA649PMQ5ap
	0vnzLIjBbYGrP5FgK6Eplcwk5k2igTJkRhum6k+sZZuQ/b9N/PF1q61Qqet9aTyWAyCti/ZM3vB
	bcxKVCB6abskmhx5Py6eMeT0a+/uXeYBxdBt1xmWjCCy9g+
X-Google-Smtp-Source: AGHT+IGExBi9cOzWEdbOzr0lVCB35eGyhEKTkn9p0LvBvBU2ErxKa2KuonY0ottMpWvDt5c44MwQMA==
X-Received: by 2002:a05:6a21:7898:b0:1e0:cabf:4d99 with SMTP id adf61e73a8af0-1e5e046362dmr49587856637.14.1735316728549;
        Fri, 27 Dec 2024 08:25:28 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842e89059b1sm11410661a12.86.2024.12.27.08.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2024 08:25:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Kun Hu <huk23@m.fudan.edu.cn>
In-Reply-To: <0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com>
References: <0f2f1aa5729332612bd01fe0f2f385fd1f06ce7c.1735231717.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/sqpoll: fix sqpoll error handling races
Message-Id: <173531672725.183896.4912846570685827099.b4-ty@kernel.dk>
Date: Fri, 27 Dec 2024 09:25:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 26 Dec 2024 16:49:23 +0000, Pavel Begunkov wrote:
> BUG: KASAN: slab-use-after-free in __lock_acquire+0x370b/0x4a10 kernel/locking/lockdep.c:5089
> Call Trace:
> <TASK>
> ...
> _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
> class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:551 [inline]
> try_to_wake_up+0xb5/0x23c0 kernel/sched/core.c:4205
> io_sq_thread_park+0xac/0xe0 io_uring/sqpoll.c:55
> io_sq_thread_finish+0x6b/0x310 io_uring/sqpoll.c:96
> io_sq_offload_create+0x162/0x11d0 io_uring/sqpoll.c:497
> io_uring_create io_uring/io_uring.c:3724 [inline]
> io_uring_setup+0x1728/0x3230 io_uring/io_uring.c:3806
> ...
> 
> [...]

Applied, thanks!

[1/1] io_uring/sqpoll: fix sqpoll error handling races
      commit: e33ac68e5e21ec1292490dfe061e75c0dbdd3bd4

Best regards,
-- 
Jens Axboe




