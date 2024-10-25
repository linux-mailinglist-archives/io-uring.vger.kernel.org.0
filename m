Return-Path: <io-uring+bounces-4029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B099B0501
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69C721C221E2
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5E91FB891;
	Fri, 25 Oct 2024 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H1Y4bVpU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E65745F2
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865119; cv=none; b=ZQZKn+ug5NYl8s9rYdqZu0h6rDR2pF/+vJZuvWyCKY1kj8drbn6VE0W4XYsPZ+MgzBvJRgaFM0THPTtYMdh4zzD/CckdrN258xmLbPV4AMP6GcYB+VHzvrOQs98FMDyFEsfNBycvB+Ckk5vwx31e9S8xRCJCDUtgpDmhevtr48o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865119; c=relaxed/simple;
	bh=r6Tv96pcVGSrfznOOcm6PkYvo0ArymBHkaJT8lCTEmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mbA6PEsNFTLXBuegTxzoQ2wxQzhBt1JGpyCC5LQcWc3MDM6eDukOg4FPRwgOLhUctZ2PoYc8soUNJW9E0SkNQwdkT7xzYJA6IFBYT1k9HPs6zYpt215WT5gVx8jqtIFBqSUd8r4gjloazy9PcxoK2nBy67cYy78r/5hKBN2ENcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H1Y4bVpU; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a4e40a1d7eso3597025ab.1
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865114; x=1730469914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8qjvb8HE6QQg1s2MCBEB7nndYgE74NGHfi7N2ilG6I0=;
        b=H1Y4bVpUeX9LaLaJXLH4ZHW+VgIxNZnhNffkGWFxe14ncLQ3wDINuYYl8UZuA8vjTu
         xeRZiBEKVA2uS22mFon//yzmb+25X1w6i4gWtdO/lmcj0/Gvb/50n/mZp44PjS3f9PIq
         j2Es9hnYFJC6XVJw1A91YfLXUc8h5CYR6Wub96+pYV/OMYFeAc49HdR1Br1cKRRt6e9x
         D5TEP9nEHF66kSGKYk58gmUWgsHLn13t/4Z3Na17ICd/drLQFr2CB5LlMYhGzR+IhyUL
         MT608wq07KEWtLbRIRaPmE2bY2jtTqVd9IhbMxDOrC9vPnYShzuC72mohUdjcfGkk1G6
         lZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865114; x=1730469914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8qjvb8HE6QQg1s2MCBEB7nndYgE74NGHfi7N2ilG6I0=;
        b=p2wWKWFEseqn+PCEFM59Nxlx1SAbmXs8q3h5qlRP01+fP12/Qf9gD03mQGMyWJ0+am
         qrwmHTKyxDg5BzkJSDKWgOlJlm3sJgvciIYDvWJG8VI/7b2IPY0rAQTIJydYbz5YG4v5
         awVXyrQZZvwvfGuZkHZOSUvfId17dL2n+Qa52iC7UKIseHwP8ELaR06DAX/1IyVcMCIF
         mV1068kkaWIxkENkSnKhBL1udlhs4p9aXxsLLrfQuGGdIK/Wo59HrdzWEHiOl/N/76Tl
         8TzIAFJzh3ulsg5M4VmTpGRmcoTHXb0iXmWriCfdLry13/ut8ql9Mn7t9ulVABnSar7d
         n2pQ==
X-Gm-Message-State: AOJu0YyOXFh750S2WgOxRaeXiLpPPJ9eKHGYkMRwr40cE+TSMc32AVbS
	QAJ4Wf+ezaR7Uu4oqrLCDJxMszi1ncY0eDmx6B76EWetva4EEF2NCWPQPtiKqcp2q7TwLdPwhX5
	S
X-Google-Smtp-Source: AGHT+IFhd6b0G7MSPQtaeaamnX4UPOTPjQNfx423M0wFolk/icjPeLT3MHsIiREMqy9eKyueFjD0FQ==
X-Received: by 2002:a05:6e02:20e6:b0:3a3:68bc:a16d with SMTP id e9e14a558f8ab-3a4d59cdac2mr100932845ab.18.1729865114029;
        Fri, 25 Oct 2024 07:05:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56641sm2924635ab.65.2024.10.25.07.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:05:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com
Subject: [PATCHSET v4 0/4] Add support for ring resizing
Date: Fri, 25 Oct 2024 08:02:27 -0600
Message-ID: <20241025140502.167623-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's v4 of the ring resizing support. For the v1 posting and details,
look here:

https://lore.kernel.org/io-uring/20241022021159.820925-1-axboe@kernel.dk/T/#md3a2f049b0527592cc6d8ea25b46bde9fa8e5c68

 include/linux/io_uring_types.h |   7 ++
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/io_uring.c            |  85 +++++++------
 io_uring/io_uring.h            |   6 +
 io_uring/memmap.c              |  12 ++
 io_uring/register.c            | 215 +++++++++++++++++++++++++++++++++
 6 files changed, 290 insertions(+), 38 deletions(-)

Changes since v3
- Add ctx->resize_lock, which is held across both mmap and ring resize
  operations. This prevents anyone else from running mmap at the same
  time as a resize, even if they are a different mm
- Expand test cases to test the different mm situation

-- 
Jens Axboe


