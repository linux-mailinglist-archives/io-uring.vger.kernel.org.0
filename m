Return-Path: <io-uring+bounces-8228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FD4ACF47A
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 18:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB93117313F
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3ED4221278;
	Thu,  5 Jun 2025 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DaGYuDM3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82802777E1
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141393; cv=none; b=vEn9lXfaNUSfG26pncp5gWO8Pehz4KusHAC/ThBOKgYWpuLbz4J08yX3+a60XfRtD5XzjgAK7f/ZYIp0w2Q9ineFiZbvUDZ48agIAy1IHivaxmZ+VnaeCBB+ApqDIQ6HKWpku9TknRiu1huC6jIZ7CFxwmrVUIOk2+gM2GOu56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141393; c=relaxed/simple;
	bh=RgdaBkCOPUHcXg0c9AwD8WMl0xLRv5vZyz4McgGM0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BkkwPz2zilmUovON6lxYMyqglNZhNGiJJC9Qn/6aT+1xwHwF9KjA1e6C5cYJMbWBI8MKSStbC/YSPYoeUQwzIVA5q8UbKQ1t08lp/qhC2mTFe5snPXVJbSPy+8Cxa3oYyKDbwRc0BegYa1GO1AVVhkEhoxfI3sYR1EvM28aVkVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DaGYuDM3; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d013c5e79so92837639f.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 09:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749141389; x=1749746189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rTWIWupal8+H+nPA851fiz+UAr3HMtOgdqUT5Ycjy6Q=;
        b=DaGYuDM3Fh4/lFdPl1997Yogqr359XWIo9mSGWa7O6n2Pn8bOk/n4aUI8vn1byd3sf
         ii962R4jxNH32HY7ZUsydeEpJ3RU1skK4Ba4VhYkWKN3q6mqGMGSkMpqIu3VFkpkN+5t
         0iMPNOCHWa8sDs88lS683hHOcMa/g+udSADG4gdVhN2PFIskjTXQUggmMCZsnOp7+AYB
         qxRb0OdKaQYVlLkSGPcV3WdpqiOh1N2DLMF0k7EQS7O8QjME+jod53/g85q/DFYtFKw9
         pURnM18vgAeCdkdPoI05yLNP9gcF4ZH3LoNf4YJm/yqTRbCHWV8d7FfbEgDQJbB5pFUS
         32sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141389; x=1749746189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTWIWupal8+H+nPA851fiz+UAr3HMtOgdqUT5Ycjy6Q=;
        b=XQBMl3KgwvwD1HLIXVXUmVGsF2808vwfaImgfohwoawTdHvYuZLthsGjLux7rgP2YE
         9pmKy0nze0xxRUlR8MVm0wqbqx+x8fnuu+8HCb0Gok7aV/BAjuz8LjVuzb24siC0wnrW
         mOEPVzL8Xdw4ze7/FZSwmYj0M2OEGDCBi6/jx00GnDLBdqmrIwORLXgXEmKxirLSDtEb
         7egV93KT8SV/uw0IVbMlU7tLdoDTzt3tZ4xUZGD3QDCU6FO3n5K67Z7ksANuA5Wk4pZ4
         djk+cXVIFBmsVU34kahiFovUj8HmUdlhGCoxck+qVKXn109P/0aNiJvtVQd+PoyupziD
         zNEA==
X-Gm-Message-State: AOJu0YzbLeIwwZ4V8THIlSgGGwaaf/XmVhmKvxNQFFtYDeM8CyUenmMd
	/DBQoBpH1l9u94JxMDiGKk3shy+c5crIyKtfey4VrY3BsjL9aDIPDploZ+ueTeL8hqTVHVOs9WM
	EpZ4c
X-Gm-Gg: ASbGnctjDv0rUXCw/kv9FM/8uw/lb21ainPJsf06nIaXWarrcRHO7Kn9ApEgU0guH+v
	0AI16kpRsLIt5AKSM4WCLeW7M4DuWG9GWrCS5EtNaORGhYXaFzlJZQhSPeH62X1oijV4+6U2veL
	HbKMJ9htFtuJ4hLTABGSY2GRSfKa5Bvz1BXkg9vbKLCKFje6zkYYLCZHdfdXTqZhDcrBd2jmdbU
	w2v3LVyi9aU0amDyRFw9zG/RCPXMtNbBbAaIxon8SQYSO4KZDclxytWR4YR+I/Ao4UCVjoPg7/5
	mCuv8OVTF89VYzRJbK0+Xmk4nNsPjDv3/nV6/JIYAe4WFHmqE+Xfn3PfHNW5eqXdUGfsMcewrjn
	D
X-Google-Smtp-Source: AGHT+IF0vRyfflXgDF8MsX960575CrP/rC4d5qQc9mMscNrovFryJkY5TpuVBPcSV4sQFE+LQeMymw==
X-Received: by 2002:a05:6e02:2593:b0:3db:72f7:d7b3 with SMTP id e9e14a558f8ab-3ddce410107mr102005ab.4.1749141389530;
        Thu, 05 Jun 2025 09:36:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddbee31f15sm10849085ab.62.2025.06.05.09.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:36:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
Subject: [PATCHSET RFC 0/3] uring_cmd copy avoidance
Date: Thu,  5 Jun 2025 10:30:09 -0600
Message-ID: <20250605163626.97871-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently uring_cmd unconditionally copies the SQE at prep time, as it
has no other choice - the SQE data must remain stable after submit.
This can lead to excessive memory bandwidth being used for that copy,
as passthrough will often use 128b SQEs, and efficiency concerns as
those copies will potentially use quite a lot of CPU cycles as well.

As a quick test, running the current -git kernel on a box with 23
NVMe drives doing passthrough IO, memcpy() is the highest cycle user
at 9.05%, which is all off the uring_cmd prep path. The test case is
a 512b random read, which runs at 91-92M IOPS.

With these patches, memcpy() is gone from the profiles, and it runs
at 98-99M IOPS, or about 7-8% faster.

Even for lower IOPS production testing, Caleb reports that memcpy()
overhead is in the realm of 1.1% of CPU time.

This patch series attempts to mark requests in the io_uring core with
REQ_F_ASYNC_ISSUE, if we know the issue will happen out-of-line. A
helper is added to check for this, as REQ_F_FORCE_ASYNC should be
factored in as well, and I did not feel like adding ASYNC_ISSUE to
those locations.

io_uring_cmd_sqe_verify() is added on the uring_cmd side to verify
that the core did not mess this up - if that's the case, then
-EFAULT is returned for this request and a warning is triggered.

Still not fully in love with stashing an io_uring_sqe pointer from
prep to issue, would be much nicer if we kept passing it around...
Suggestions certainly more than welcome!

 include/linux/io_uring_types.h |  3 ++
 io_uring/io_uring.c            |  1 +
 io_uring/io_uring.h            |  5 +++
 io_uring/uring_cmd.c           | 68 ++++++++++++++++++++++------------
 4 files changed, 53 insertions(+), 24 deletions(-)

-- 
Jens Axboe


