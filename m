Return-Path: <io-uring+bounces-3188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7854978657
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 19:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E93C1F266F0
	for <lists+io-uring@lfdr.de>; Fri, 13 Sep 2024 17:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485E48060A;
	Fri, 13 Sep 2024 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fEFffGBZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2E06BB4B
	for <io-uring@vger.kernel.org>; Fri, 13 Sep 2024 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246948; cv=none; b=DBjFba8UkhGaTIJI4w6uUV8iVehs/N+msLwuks4CNHN/bCcOzt9JhMfHo/sesiuyrJH4q6cPQzJ6KNd7cLXLwbUazgSGxoIwNcVuLetGvomsMJv6YjA5jaNGMRWOqDIfysi7R/K/AjkrDF2W2DE9Ba2cgEQDzNA6Q9+f/EXSl80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246948; c=relaxed/simple;
	bh=CFuPXgAIe9QRLf+Ar6dCe4hRfUvGMfzEqzx36oWQNuE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=LHAFIgL16WVB5Fz+qIUsM7T0dr0WD8qdteZZ0R2yvTrBkCy+Qa6s3T48K5xc3gZAW+EXbZx0JUloC8xpd9XIrkNpFKrlm7ZFT0CZp9vDrmhEomBbklRjTZwBFqJSKGb1kDHqUBO9EObL8awE5mVLAZY0grWDy0v/Uwe/v+c1pKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fEFffGBZ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20551eeba95so10733775ad.2
        for <io-uring@vger.kernel.org>; Fri, 13 Sep 2024 10:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726246945; x=1726851745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wHcWRluVBu2t0MwCnn6+MNkXe8NHF100vnq+e8LHzY=;
        b=fEFffGBZgI1pCLhHizA9kD92W4UY7/kjh7LGcsXxI1oIucNB6x07vrVPvFGFHmV51A
         HOFIQoQlLI0Icq4a5SZ/hFKVAeBAplP2w3nnMTDqLa2eGh/oBR8XwTOtFte6aBzKQFX2
         O8Vomrs8tFOPi96D2sZ+bV0X6Wt/usmD+RyPfAsdmInN+o3PIZtTP2L4PIqIQj+i9R+l
         jUQxVgjMZLCwSsSQLCudImk3ZcxMtj1FNInLOoB/7vtQ5IVvxuSJIaOlVsCWTe9o2u+W
         Fpim9ShwPgEZg5WiE5wmfpP3UU5M5tG8FWCyu4B1cmqc8SIryRFD/69rMBf4aR1n1UZr
         z2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726246945; x=1726851745;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5wHcWRluVBu2t0MwCnn6+MNkXe8NHF100vnq+e8LHzY=;
        b=vQnPlsKEGRrzZOpGrbywDg04sXkwXhMlO/aJQaSF73LxhSgR0cL6cY/7DtBxoM4QHi
         i2ULqGx3ZrYm+xr26WV4Nz52VmFrefb+MV9UDOR0zDXepYs0nuXHFxjkaaMoLiANYSAE
         e+3sdElrCYRQP4UazyaP0Ngh0b9vAI1S7OZFm3uXsDyrJiTBy/RL2C9hpW/flHvD3Hlo
         xQhdOBUOpKPhENv/NoV88rYmnkzf/3w0MWQ9WTsWYnnD8J+ekgOO2fj41wQhKCwTuXAh
         KdWB8EkwQ29heIdQp47LfiXGcw+pNiMMmeuvdRMjhPRNV3JSnW9J1d9vToGYd3ljBVN6
         bifQ==
X-Gm-Message-State: AOJu0YzxAOFPTmh9KKZ6HOlopU0uNrrERoCx57B1GxznubRAeZ3fUWaE
	+ww6snFKLCbktFKgShbgFzf9+/+/b6MGrrCn0dsP3Ety+MgaNtJ8aXs2mznhy/AwNuRGn7O79+0
	B
X-Google-Smtp-Source: AGHT+IENlOCjM20RDpY+OWzJ/HWe5rUvoLfHf9u/OTro4QCyOoFc+vp/pBwFawcx5uNM1zTuHeH3kQ==
X-Received: by 2002:a17:90b:1c81:b0:2d8:7307:3f74 with SMTP id 98e67ed59e1d1-2dbb9f31cf2mr4014757a91.27.1726246945281;
        Fri, 13 Sep 2024 10:02:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dbb9c7c7b4sm2031208a91.17.2024.09.13.10.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2024 10:02:24 -0700 (PDT)
Message-ID: <a672ddb6-a141-47a5-b7f4-f992b4dcbb88@kernel.dk>
Date: Fri, 13 Sep 2024 11:02:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring async discard support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

As mentioned, and sitting on top of both the 6.12 block and io_uring
core branches, here's support for async discard through io_uring. This
allows applications to issue async discards, rather than rely on the
blocking sync ioctl discards we already have. The sync support is
difficult to use outside of idle/cleanup periods. On a real (but slow)
device, testing shows the following results when compared to sync
discard:

qd64 sync discard: 21K IOPS, lat avg 3 msec (max 21 msec)
qd64 async discard: 76K IOPS, lat avg 845 usec (max 2.2 msec)

qd64 sync discard: 14K IOPS, lat avg 5 msec (max 25 msec)
qd64 async discard: 56K IOPS, lat avg 1153 usec (max 3.6 msec)

and synthetic null_blk testing with the same queue depth and block size
settings as above shows:

Type	Trim size	IOPS	Lat avg (usec)	Lat Max (usec)
==============================================================
sync	4k		 144K	    444		   20314
async	4k		1353K	     47		     595
sync	1M		  56K	   1136		   21031
async	1M		  94K	    680		     760			

Please pull!


The following changes since commit 84eacf177faa605853c58e5b1c0d9544b88c16fd:

  io_uring/io-wq: inherit cpuset of cgroup in io worker (2024-09-11 07:27:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.12/io_uring-discard-20240913

for you to fetch changes up to 50c52250e2d74b098465841163c18f4b4e9ad430:

  block: implement async io_uring discard cmd (2024-09-11 10:45:28 -0600)

----------------------------------------------------------------
for-6.12/io_uring-discard-20240913

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'for-6.12/block' into for-6.12/io_uring-discard
      Merge branch 'for-6.12/io_uring' into for-6.12/io_uring-discard

Pavel Begunkov (5):
      io_uring/cmd: expose iowq to cmds
      io_uring/cmd: give inline space in request to cmds
      filemap: introduce filemap_invalidate_pages
      block: introduce blk_validate_byte_range()
      block: implement async io_uring discard cmd

 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 163 +++++++++++++++++++++++++++++++----
 include/linux/io_uring/cmd.h |  15 ++++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/blkdev.h  |  14 +++
 io_uring/io_uring.c          |  11 +++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 ++
 mm/filemap.c                 |  17 ++--
 10 files changed, 209 insertions(+), 24 deletions(-)

-- 
Jens Axboe


