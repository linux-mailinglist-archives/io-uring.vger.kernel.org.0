Return-Path: <io-uring+bounces-6589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1456A3EBD2
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 05:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1806D19C4F15
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 04:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9BB1FAC38;
	Fri, 21 Feb 2025 04:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ih27/xgn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72BD3C3C;
	Fri, 21 Feb 2025 04:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112006; cv=none; b=NlDTHFJxZGmqZ26q4/GB83D5bqE0MjPxRrNwnJblkB9WjvB3IfWtrCxGp5IrtUt2R3jwqV92+8RO1AddKK9Fy5VKP3aK2xPjs7z/cXbfABn2SPTXWah0oyZ30sj7S1IuBv07pFh5FF6YoDdm8shUBeu6OErK9sIfdmkX38GIyy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112006; c=relaxed/simple;
	bh=XFV/SP4QiHl68Np0mNyvKmaNNyqAHUPH5bM5PHdrnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TgVoe34FS2BEfJiKckFU43oASdhNUuB6Oe19c8MZqLNFTv6sDQfELaICJSvbskEu1mfYYZNnognUfb5GaCx/M2xxbrozsJZ3QvFnjPPtGw0EnQmkLmu7waZgG4JDN4OQTJMJTqfMIikPJ4d6salia2bF8bcdwIk0sigh9bLqj7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ih27/xgn; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-220e83d65e5so32304105ad.1;
        Thu, 20 Feb 2025 20:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740112003; x=1740716803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cl118+tDqBsr/laKez/xJ2/lTkkdiJJ+pbE4kYk3uJc=;
        b=Ih27/xgntpVm0MJ+I6Q0AF0yf6a4FfnTVwseAEd+Ysxh3XjCcPYhj79KH4sgRxLdYx
         TvhpDEA/8Y0eIYqzCvb/8RJe8Utf+AWTpdC9VJLdIegHupmRwSnydUkIgO/Mc531jcfH
         ezL2jdsgAZueHGb301A1ltRTp7gpc4BBoHzMU57z+87rVjEMTGO4NtyD6U2irIdIjyov
         R9RZkJamPb4GqzG/bHO80NpJ2dpgcY2hGLWwlWGm2YZ2TZGUlND5jftnq8EFTS20HVGb
         GmFagJ3kJdBgPVscLjKyVqXxxHHBdxUw4gITEYdZ2tYKmAIwpSLk7YAOw6Nim2IGw1VO
         jl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740112003; x=1740716803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cl118+tDqBsr/laKez/xJ2/lTkkdiJJ+pbE4kYk3uJc=;
        b=YQ1KIva5EVbtgiLXz8MKS/kwKEG1A5zvwh9uBasRM/eWQsWrYted8S7+7QdU9m5ukP
         eCslSzDvqLbZyWoiVWaKK+LeMYarZTrSmwaCJUjaZDSu/H/IO8oRolMXSdhLTi/E5f1q
         LU49fnf9MuwQCC6IuT4QXq8aHmLKNhOMUMXQxIPF9ty8N5yY2vN88XgWLzAz0Zg/f0/Y
         4b694iHjHTWHuzqnmRmo2PCm0NwOLWHHMhILD0ghaakzHTGn5tsDl/y2w7IbKgwxvUOi
         P9544jBfDAb03Y76BtEU0yaa+HJMudFW6xHrI9Y39bgsY04lFSqJ4K8lUvt8kw93jeA+
         D9kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXozfcgKUhQfS4lFRdf2joYRHovaKGC2Cs2FDcvz/+XYy8lVfPzEzLDdqgO+YOkbu/qmkFBweTuMqcgVTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEe574A82p3XRRIQkWNr8prz5IuCYr6f5rbihM7E2FujpqRYvi
	9IKET+4A+IU4fYY81Wged8kWflzM9qEuYa5vShr5yuWsKVPiglkb0I3nDw==
X-Gm-Gg: ASbGnct+kcmsn1mvnSFosnrnNiauq3b3RCpfBlcFDSp7vSRY5c8x8v3Rnp7DSfC63S1
	qmgvudT3udzCKZsLMAX41ewJsiURNL/2/cDwuri+mfd9mXP3UJBkZaLi0AzTJAG7IUBrGJ+Hy4l
	ag/W9TYqfxVHHaagA3QUQ0GF7kELnHOS2rkYDTN9iJy2E+lmGFsNSHqFR4z33zMX2Ogk5Eie2sD
	AdRsv1DzMyqTsSZoHeqFbQcUWWCQHf/c8smB49GKkpKSyNGQdhSY06HzEStiV7BuKao47SnNoY/
	P5aywXu9awyr/ZmqU9BpDos8TisM
X-Google-Smtp-Source: AGHT+IE3NA2cuAsYEtzKH/wtJ3djirZZgaUxN83l/Ct1YyrcqVz9nmy1WX4CH3Y85mGmyDs3LvXTAA==
X-Received: by 2002:a17:903:1cd:b0:21f:93f8:ce16 with SMTP id d9443c01a7336-2219ff6e424mr25864215ad.31.1740112002949;
        Thu, 20 Feb 2025 20:26:42 -0800 (PST)
Received: from minh.. ([2001:ee0:4f4d:ece0:cdf5:64ad:9d8c:d0ba])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-220d5586080sm128162165ad.229.2025.02.20.20.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 20:26:42 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [RFC PATCH 0/2] Batch free work in io-wq
Date: Fri, 21 Feb 2025 11:19:24 +0700
Message-ID: <20250221041927.8470-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When benchmarking a echo server using io_uring with force async to
spawn io workers and without IORING_SETUP_DEFER_TASKRUN, I saw a small
contention in tctx->task_list in the io_worker_handle_work loop. After
handling work, we call free_work, which will add a task work to the
shared tctx->task_list. The idea of this patchset is that each io worker
will queue the freed works in its local list and batches multiple free
work in one call when the number of freed works reaches
IO_REQ_ALLOC_BATCH.

=========
Benchmark
=========

Setup:
- Host: Intel(R) Core(TM) i7-10750H CPU with 12 CPUs
- Guest: Qemu KVM with 4 vCPUs, multiqueues virtio-net (each vCPUs has
  its own tx/rx pair)
- Test source code: https://github.com/minhbq-99/toy-echo-server

In guest machine, run the `./io_uring_server -a` (number of unbound io
worker is limited to number of CPUs, 4 in the benchmark environment).

In host machine, run `for i in $(seq 1 10); do ./client --client 8
--packet.size 2000 --duration 30s -ip 192.168.31.3; done;`. This will
create 8 TCP client sockets.

Result:
- Before: 55,885.56 +- 1,782.51 req/s
- After:  59,926.25 +-   312.60 req/s (+7.23%)

Though the result shows the difference is statistically significant, the
improvement is quite small. I really appreciate any further suggestions.

Thanks,
Quang Minh.

Bui Quang Minh (2):
  io_uring: make io_req_normal_work_add accept a list of requests
  io_uring/io-wq: try to batch multiple free work

 io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
 io_uring/io-wq.h    |  4 ++-
 io_uring/io_uring.c | 36 +++++++++++++++++++-------
 io_uring/io_uring.h |  8 +++++-
 4 files changed, 97 insertions(+), 13 deletions(-)

-- 
2.43.0


