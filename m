Return-Path: <io-uring+bounces-2529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA29C935273
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 22:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19BA11C20C11
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 20:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2783A143C54;
	Thu, 18 Jul 2024 20:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tdhoEoL9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E5144D29
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 20:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721334876; cv=none; b=AXi+YLgm2yuu5h9SM1AlkwKwxEm3OHgcI/BZMttuXzVlgAN5mZBMmhlb6ImLJaGjDTKeutoCvKe9R0nLn0aoaGTKhtlBwlFE7W9H1O0v00hIiTC7W3aJaKn4o5bEScFUGiLW2dSBj6hKf9meXoWczVVQJU3yYoiyF54pMWFMbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721334876; c=relaxed/simple;
	bh=AcZEU/t9N/ACz7uzWRjgxaPFH24UxbYW+PjW8kT7dAw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z2l6tkrTz3uRh2YBmX5yILM4SyMv5cHNvkKcrTpzR38u2Yk/f35ZOU2h0KYH6FktoBrTIEZNnTR0Cxq0fdzJen+kiExs+uiCmtHohA0/tZv/1oTVWXJv1G4iWl20j+vN5xAu7FwiAKewkit0eq6d+G7mpvzx5Uy1vZf2/9s8bQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tdhoEoL9; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cb4c2d13a0so97893a91.0
        for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 13:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721334870; x=1721939670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzmFoWayG9UQCU9QGqdMxoxqLOmGwHOfnqfZaompIl0=;
        b=tdhoEoL9KNkDlHHmoge9dTLsDEs/FiuVFim31ns+/pI/x7G1ezdOdOZ99M1k/57wEL
         VCV4BmGUA2dIlBxfVgAQSTM6NSWUhwZrQ9vwmO4zKZLq167cptlJI9MapoV0dQ0qnsnG
         v3R/LK5c+DgfL0RKF76VBR3nIOQzdZd1dKsDjls4S9j/exiUqyz1gHSOv/Krjt4ROBn7
         QFunCj7jcHmKO0e3XpN+f/xUZBRulaLH1EF+Re9ao3Rimm3HLRDmF29HOM6WeAwV1Fcs
         ZNQ9CzH4Wf0bKe2ebc736p9Ij+LbvKscy0rkIT2S+yaulB4R/XWIdqjRxoso8fsV9w01
         2ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721334870; x=1721939670;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzmFoWayG9UQCU9QGqdMxoxqLOmGwHOfnqfZaompIl0=;
        b=H+xmNJTO4DiLkUEmVyTV8Ynfvce+wUxGYVI+hOe4hqVrWK5+lm2jRUrKUrt8yC/+Ev
         7cjf/VUmxc0F2OciceMU43OMG0AHPggjGhFqGaarCEJwCc50UdmJEPjIDxuBO0/XXZkE
         8FMCJdwzpxZwa6gZTF/HWapAUHGx/YD6kktaC+GdaZP/mEGK7ZTi9L3MWRaCbTNRVw2t
         hJX3EmGEaLNr8Eo2fvSd4j7LRIIoTc3nBvu88rXipyfjRHQ+IvMocWQ6LSCblj0CrwY7
         Ov1IdFnHkZVZUPAutdop6H8/X12IvRI7qBpUuM9a+goX4JjE5CoB0CPa9t/kost03/BL
         InaA==
X-Gm-Message-State: AOJu0YyYSRabtt/asJlPzLjkHPyzM/kkzpcCItAvLr7+tP4QjtgiuEjt
	FU2XMOhDf7Gd5minWwQLzTt3diJlKC61BRKfw3rrVMZR61SFDR8oXaUx3nFEMGjrrS3TgStXVYV
	zLBO7eg==
X-Google-Smtp-Source: AGHT+IFuSzb4M9zNShrQq4sT2jQHS7qVLreY2N5f3GNVwQpCRByPNPL/saM65LLhbwb2HCanIQxAqw==
X-Received: by 2002:a17:90a:df95:b0:2cb:4382:99eb with SMTP id 98e67ed59e1d1-2ccef91eac4mr513281a91.6.1721334870011;
        Thu, 18 Jul 2024 13:34:30 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf7b30f35sm37236a91.11.2024.07.18.13.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 13:34:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com
In-Reply-To: <c5f9df20560bd9830401e8e48abc029e7cfd9f5e.1721329239.git.asml.silence@gmail.com>
References: <c5f9df20560bd9830401e8e48abc029e7cfd9f5e.1721329239.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix error pbuf checking
Message-Id: <172133486834.46273.15978838697580136389.b4-ty@kernel.dk>
Date: Thu, 18 Jul 2024 14:34:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Thu, 18 Jul 2024 20:00:53 +0100, Pavel Begunkov wrote:
> Syz reports a problem, which boils down to NULL vs IS_ERR inconsistent
> error handling in io_alloc_pbuf_ring().
> 
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:__io_remove_buffers+0xac/0x700 io_uring/kbuf.c:341
> Call Trace:
>  <TASK>
>  io_put_bl io_uring/kbuf.c:378 [inline]
>  io_destroy_buffers+0x14e/0x490 io_uring/kbuf.c:392
>  io_ring_ctx_free+0xa00/0x1070 io_uring/io_uring.c:2613
>  io_ring_exit_work+0x80f/0x8a0 io_uring/io_uring.c:2844
>  process_one_work kernel/workqueue.c:3231 [inline]
>  process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
>  worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix error pbuf checking
      commit: 77feb9505ce67fc609b1e7b6b27b41995370498f

Best regards,
-- 
Jens Axboe




