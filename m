Return-Path: <io-uring+bounces-1645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC208B38AF
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 15:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C66EC1F236F0
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 13:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223AD147C89;
	Fri, 26 Apr 2024 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vR9Qfkd/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C011F956
	for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 13:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714138854; cv=none; b=fwyb1Raqc5jBAvcJoPb9jQC1dA5DHui+kV/AV8aTkukhtdpJKufMGQij/+Y/Wx/2FJPnEg2ISgnutb0bpTcceKi7Ez7ORF1Ts/H5PEYHHMS55hWTmuNsPNkUk5NoEa0ZeIvZrhAlZPg9mGdQfzihjJkG8JBxf8R1SMJ5xmneCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714138854; c=relaxed/simple;
	bh=JCJDTBds+a3tbNd3ShHOf/AGk6tUWyo+qW7RdyRA9F8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OZUp7YVwASI6Vm34crwydZpiHKYDulvIe7CtqAroFazQEXWBflLiZQmy8MYqCWQtrbENz3f+M7TsWB0UYDHGIr/xUlpXnf20x83sn1rz2w47gIn3pU4Qt70Hm6P1wOf6ka/BeLWg/aouT+V0N4xrFifCrgntt/OCzaSx3mTvPsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vR9Qfkd/; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7dea278262aso11245539f.1
        for <io-uring@vger.kernel.org>; Fri, 26 Apr 2024 06:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714138851; x=1714743651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQVjNTLjf7VGhqiwo6xWa81d5ljtfH+fLb0sr9Vc0PA=;
        b=vR9Qfkd/CNfgMqdHA6L1fuVG/Kf179E/6sjmL1tGBGt5/vA6kbfgcDIMBXZF4SeB1V
         xAiLL0o5yMNjR4sMjl4/n4XdvAbpv/HQGoZMhDGNui5VtrXP9ym0xOVUcigS7bzMM3KI
         B/hVa9WsyFukuxIX0Enqc/vhqJ4ZkKb6w8dv+GfqU/2+sJl+RBXjAcq3A3vgutfiqk1b
         QM3ig9HI7PYleDeAa5nZaRzJp2xB7rfLhHgXlp+cgN/XeJcZ3UFNBJbOomQgksG8lJwV
         cZr7ipv8+9tLOEvjb/zg4FbVGWAwOSH0ZhuxMrSNzFvqgUgUmEpGQokIRnrcoveEE8ei
         TR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714138851; x=1714743651;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQVjNTLjf7VGhqiwo6xWa81d5ljtfH+fLb0sr9Vc0PA=;
        b=LQ6AMQO4E0ZIVmyidAnLfko9fp3Sv75hucyLAMVhaKzB62C1Desr11DXG5L3GRhlWk
         /u5uA8p6XWqCeZBcBa29OWijgoDg4hFr/OtgqzNQuz2a2rAKF/FLVhcvtuGRkP+QAxp3
         QteOIt57OZ8QVAJWv4Xn0cwxXihbH4rfdmmV+O5tM/VkTJgvLEINJvqITMBHN6bcpWLv
         NUmVdvyIzREkGTBzVC5CGaBp92xrquGX1U95Lx4LFsSyntiP1CLzO9jvHQEbu6Tzsq6P
         uyFcV0DzGvTnTqpAfBFSAKqjPPH+vswNwzFiijT3HVNqGfGTs/+qtbMJQ7jnQAsW/2hV
         UawA==
X-Forwarded-Encrypted: i=1; AJvYcCWkShCIbtJm+3rBqckRXFljUTghzpos/Z7Pv0RieefvxptDhwkZeV5JkwWk8s9iUWhp1Nymt66HrK/wztSacW3pQvsMSOzkh/k=
X-Gm-Message-State: AOJu0YxOLfdS5/KhOIqsaxuAuy69Ixg+z/5uClnDhAOw9O60eYsAWf+s
	13l2btHIXHW6Cc6BztfYxXd15gM3bRdngyuAF+SyBD2FoVi17yf+Yw3clYra+ek=
X-Google-Smtp-Source: AGHT+IESz+VVFibB4v7kcRuR07qQ5guc4rVZROLiXv/vGQeFvCRzC594gVmkjdesOS1PumJnF390fQ==
X-Received: by 2002:a6b:c503:0:b0:7de:b4dc:9b8f with SMTP id v3-20020a6bc503000000b007deb4dc9b8fmr263925iof.2.1714138850823;
        Fri, 26 Apr 2024 06:40:50 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j13-20020a0566022ccd00b007dead4fd0efsm255275iow.18.2024.04.26.06.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 06:40:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linke li <lilinke99@qq.com>
Cc: xujianhao01@gmail.com, Pavel Begunkov <asml.silence@gmail.com>, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <tencent_F9B2296C93928D6F68FF0C95C33475C68209@qq.com>
References: <tencent_F9B2296C93928D6F68FF0C95C33475C68209@qq.com>
Subject: Re: [PATCH] io_uring/msg_ring: reuse ctx->submitter_task read
 using READ_ONCE instead of re-reading it
Message-Id: <171413885012.211722.950447967094465539.b4-ty@kernel.dk>
Date: Fri, 26 Apr 2024 07:40:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 26 Apr 2024 11:24:37 +0800, linke li wrote:
> In io_msg_exec_remote(), ctx->submitter_task is read using READ_ONCE at
> the beginning of the function, checked, and then re-read from
> ctx->submitter_task, voiding all guarantees of the checks. Reuse the value
> that was read by READ_ONCE to ensure the consistency of the task struct
> throughout the function.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: reuse ctx->submitter_task read using READ_ONCE instead of re-reading it
      commit: a4d416dc60980f741f0bfa1f34a1059c498c1b4e

Best regards,
-- 
Jens Axboe




