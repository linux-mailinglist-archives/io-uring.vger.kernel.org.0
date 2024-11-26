Return-Path: <io-uring+bounces-5054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 745859D9A16
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:01:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFD6BB26487
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 15:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1782C1D61BB;
	Tue, 26 Nov 2024 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MQLqb3BB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78961D54E3
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732633218; cv=none; b=b2tjWxnCnI+Bco1RuerHGBdQt/rU3grTHQHwK8gbwmDkKnZoUWxcPPgHPAmotux3SRXAvea2aaIuUmy8DpdoCDuzOhBaQAGUIdBOBeYxQFOKbF1sz+WmNx50ckRthpGJwgoJOnFuBA3Qtx4WFWSlnxpEYwAk5mRLd1AF1VN6Ztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732633218; c=relaxed/simple;
	bh=YkiGRdnVhlW7312v3oPy0Uf+imzBh4qpk/2n7nxrQxE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=H7bRHzbmC3KDR/UaXjJVct+rkps+y1IF5+ZuxZxlpYf7TemdQe9Ukifc2hjNAPxjIBR6vKIq7Y9HNUlE/7MHx4BL6NVx460l/djWyK0oMME6nHHqTIvqpEdFsTqSYHV5hPH2YmN53mK7Vdc7qoXFMMD1Vnbn5uKNYwHk4rhBatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MQLqb3BB; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-29654932226so2605140fac.0
        for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 07:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732633215; x=1733238015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBHnZHzwv+OEohp+SYBzRiV6gRmj7OTrPSQQTza3cM0=;
        b=MQLqb3BBs2oPbXwKjFdk1r+nzPVk7FZgTZjRhL2ftW71vIQJYhxnnp8ZPkYPYApbRv
         C2P+LS6CTFbNx/hXj3WE3H4ldgbkWiA/yF/wh9fvvW9+U6Hu+uRd9FXaLfq+JX+XRlwR
         ooNap4tR/V8S6jLSwUfUsxk4nK0snS33L1c+IaCcFev0Z36UZXe9INk1oiq+NFknIbe+
         IZJ93S3xx125rmO1rTismWcAQFI6oRC0R2qUnlLScVTIA4YDNgzX4mqHI059u0vSzdpQ
         yKR3tHPKDMu8lPgT+epJ1msBY9P+3c2dfOLbLC2/9QE5p/fLQBrE27DO0Es+BchgSLQw
         ogBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732633215; x=1733238015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBHnZHzwv+OEohp+SYBzRiV6gRmj7OTrPSQQTza3cM0=;
        b=O4whmowK4VUw2Aq+9ItS+SKxO0QOlPcGtpIMna5wKVoZ1zACwbqvZSCoObNV9XJepg
         CCcjyA7Nrez+couDSX6yk+4xRWISxq4+L7JiGF08KT7ugctchfSDgc84wkiBwfLw4zUr
         DAg7sw6peJYUAjLl/1onhivvtnsOIvglQjIB632H0erq5Blxf2Cpi5v7o/F0i5xXAi/m
         +zxFVEc1gKAIiSFmuPHi9ma6owX0UXCxsdeCttEJMWmuYmPRpwYqIURF63E1na2/9GZU
         OUWjsN6pnl+STBg/JdYPlyxwVqQClU1kl/LVqIan1SfIEAr+W9O046o89dUhBR6ZIXiP
         AdRg==
X-Gm-Message-State: AOJu0Yx9akqtX3cvHYAdaqnup6Kx2DvNBiTMKyjGK+dltk7LuoXWklFo
	+JEiXXEPtOrrPFulbiM7zKJE+IxJdRsn49FPB1aemlS29/qjSYS8L2NjX/6Xw9I=
X-Gm-Gg: ASbGncum4KkmRPCoOUY3/oQGV/3NsbOk4HcNuV8DTfXbKsUWDq0xQiv3GbRXZ+aeJyG
	F/GOrQk6B3cM2yFNJoOStmlA3u1e9hP7K3ngcW9ehMU8avbpX/mYjBSMYC1XHka31clcJIMuYtn
	Q7t+TDtYO3tOgFzeAr9dyMZNJ88Ec/BVF0o22qV+rpQ8y2tr+spahYZVymNsghMlFdHgXPfwl78
	2ZK0WYTKLxdtCLzYCS3AvWrlXDNon6ov7VWD+KL
X-Google-Smtp-Source: AGHT+IFYuSuguPdblsVVA42WBueXanzcnpLXJeRq2mU+liPwAncUi+sXUCQL7qVVLvhKzIpF9HVZGg==
X-Received: by 2002:a05:6871:e983:b0:294:6577:16d8 with SMTP id 586e51a60fabf-298af712279mr1521162fac.12.1732633214778;
        Tue, 26 Nov 2024 07:00:14 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2971d56cfdfsm3998512fac.5.2024.11.26.07.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 07:00:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
In-Reply-To: <1b7520ddb168e1d537d64be47414a0629d0d8f8f.1732581026.git.asml.silence@gmail.com>
References: <1b7520ddb168e1d537d64be47414a0629d0d8f8f.1732581026.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: check for overflows in io_pin_pages
Message-Id: <173263321276.43959.14162906343487265344.b4-ty@kernel.dk>
Date: Tue, 26 Nov 2024 08:00:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Tue, 26 Nov 2024 00:34:18 +0000, Pavel Begunkov wrote:
> WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
> CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
> Call Trace:
>  <TASK>
>  __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
>  io_rings_map io_uring/io_uring.c:2611 [inline]
>  io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
>  io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
>  io_uring_setup io_uring/io_uring.c:3781 [inline]
>  ...
>  </TASK>
> 
> [...]

Applied, thanks!

[1/1] io_uring: check for overflows in io_pin_pages
      commit: 0c0a4eae26ac78379d0c1db053de168a8febc6c9

Best regards,
-- 
Jens Axboe




