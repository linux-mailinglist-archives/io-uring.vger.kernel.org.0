Return-Path: <io-uring+bounces-9158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CBD9B2FC64
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B625C72701F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0946278E47;
	Thu, 21 Aug 2025 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pLBm2xGM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DBF25B1CE
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786004; cv=none; b=mYlEnqckX0CFI4Duxakbe6BOiYiCOxdQBgNGHsyQ+e32sX55EO0M/plu/KOK/2fF30rN6tWObOSxuOmd9EYG3wYxR9giN9U2P3ckG27H8CCoa11y91o/RWuRA4ON847bdWP2d5I8vJEsozudyoSwid0zJ7Hev52hQSccD+7pMfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786004; c=relaxed/simple;
	bh=z4IBiLzs1bvt0jf4vVMxRqFued76P5H1InjZeFdbp2c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VfN/aZvTc/pL119BHBxw23Bpjf5xoiqe6XwyJFmPOxajAwCdExjFiRKXZKLNMeLk3cW2ZTeX89Vz2/g1gZBPLR0DPsthfkstbSS0yc3cZzqGZIaacojyTGxUxJTEZ/rMVvuBBM7L5qYETGWL9Gxvj0lqFw+syHXwz+pb/W+tJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pLBm2xGM; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-74381efd643so269953a34.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786000; x=1756390800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hFqvCarEL1WJfBIDRu76lHrhwQiiMlMx60EYdMxI3as=;
        b=pLBm2xGMTqNxIB9y3GpItf17EdWaESo3Lp1VFXa7+sstvfOGE2tX6yFMbKeDyUFSjd
         qbxvBfmp84vKDiqhwmUuBZRe8jSe4WZYU/nrx3rkC+6lkep93j+3hNyDZL4Q+jDjZaZ3
         LwDO/pvGcMgnYbbrnfSLCNDURDJGwuq4hEQyKPEwBZsHST27SvUWU3NsM+2TyomwqAqD
         pt643/+0uQ4Fj8RnwMISvqwrR4jSDuQweDuYqXCSRETHsORV2AYBcAJn9fSU7KRx7Wv7
         8Uj6QEY9bE9b+BKtiRCLWqX6ess9xYEpFgzYOo5+FcyIIfcWR46i+W23g9o0KZURh/hO
         SXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786000; x=1756390800;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFqvCarEL1WJfBIDRu76lHrhwQiiMlMx60EYdMxI3as=;
        b=dKHqy7StuSffQY+x0dQJzAb3npyszWD01nVKYsU5J4LM397gRBiSF5di5MjH6KTJtb
         bYT2Tu1d2cE3wD8A9w0WGsLNrdlSH6TqSiO4ewu9Cjfxn4YVFRRAHL/zGzwjqzqxPeI5
         rjzVMXS9LzwaNDoH/+HYCRDiHAlWXFxOATGyyQFCiWBod18Z8uLuhmyYTIL8aXZ3Ebd/
         aDxFvjAru5Gp/2Xka5BiCS7n3JiEa5/sA/U+Ud8nwWxX0PQfYFQb+TxJyJvsqDuSRw81
         yvVFUslq7IB55/an5ptocfYaNA5KVD0OxG5zINni/04P5/PfrHGQ/G38UvLiStylLCd6
         N+wQ==
X-Gm-Message-State: AOJu0Ywfk3j5MF7GCvyIv+hThb2Nrz+lQsqU4iHlfH2fHPK8D/zprKQG
	W1w8iynLaVL5lpo9zZBISE9XSEE7F5GiFizly9DZRe8nmKKoLq0QOuumPF/ji6qf2uBCGaFEB7r
	VrDHj
X-Gm-Gg: ASbGncu/3CSiXeo0jHv/UYZqstTe0vKYJQ9+/5RRmMjPdVWaAue0nlyhSxL+81orr94
	73VqND2DDo+56iNfHJFpB8SZjqjy2is+w6iQuBJ1OW4hTXAsVtJv124s+H+TAsq1CMxXM8oqgpU
	LZbLcFLWhaSVbtZ/fgVfJa7aVIvC6uWj596L7jRIRggqZw9ujf5Z/wWwUWzraxK1eoAeve0rgqE
	w5MJhkCHvC8UkMAkDOs7QLKwESoB97bG1nOyWBx1w4/6J4xlugF/yoZwJ07fNId8tWm0pEBvDZb
	IHHFQwhXMxRIsWgJFZo1TAAxpe75c9i+ktSHS3sbEYnNPQOSZzoV/CU7fXkSj7Ua/jKd2a9FPAT
	HDWnQUXrgQ1XLlaU6
X-Google-Smtp-Source: AGHT+IEzUQLWC5Chls7SQclmVNOf2lTy5/Q6Kh3mCOmfGSG3thWT2LPhWImWCeDignwAplL/EpjjhA==
X-Received: by 2002:a05:6830:6501:b0:741:aa58:d500 with SMTP id 46e09a7af769-744f6932dfdmr1228278a34.3.1755786000028;
        Thu, 21 Aug 2025 07:20:00 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.19.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:19:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/8] Add support for mixed sized CQEs
Date: Thu, 21 Aug 2025 08:18:00 -0600
Message-ID: <20250821141957.680570-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently io_uring supports two modes for CQEs:

1) The standard mode, where 16b CQEs are used
2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b

Certain features need to pass more information back than just a single
32-bit res field, and hence mandate the use of CQE32 to be able to work.
Examples of that include passthrough or other uses of ->uring_cmd() like
socket option getting and setting, including timestamps.

This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
posting both 16b and 32b CQEs on the same CQ ring. The idea here is that
we need not waste twice the space for CQ rings, or use twice the space
per CQE posted, if only some of the CQEs posted require the use of 32b
CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing)
about this fact.

This is mostly trivial to support, with the corner case being attempting
to post a 32b CQE when the ring is a single 16b CQE away from wrapping.
As CQEs must be contigious in memory, that's simply not possible. The
solution taken by this patchset is to add a special CQE type, which has
IORING_CQE_F_SKIP set. This is a pad/nop CQE, which should simply be
ignored, as it carries no information and serves no other purpose than
to re-align the posted CQEs for ring wrap.

If used with liburing, then both the 32b vs 16b postings and the skip
are transparent.

liburing support and a few basic test cases can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=cqe-mixed

including man page updates for the newly added setup and CQE flags, and
the patches posted here can also be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=io_uring-cqe-mix

Patch 1 is just a prep patch, and patch 2 adds the cqe flags so that the
core can be adapted before support is actually there. Patches 3 and 4
are exactly that, and patch 5 finally adds support for the mixed mode.
Patch 6 adds support for NOP testing of this, and patches 7/8 allow
IORING_SETUP_CQE_MIXED for uring_cmd/zcrx which previously required
IORING_SETUP_CQE32 to work.

 Documentation/networking/iou-zcrx.rst |  2 +-
 include/linux/io_uring_types.h        |  6 ---
 include/trace/events/io_uring.h       |  4 +-
 include/uapi/linux/io_uring.h         | 17 ++++++
 io_uring/cmd_net.c                    |  3 +-
 io_uring/fdinfo.c                     | 22 ++++----
 io_uring/io_uring.c                   | 78 +++++++++++++++++++++------
 io_uring/io_uring.h                   | 49 ++++++++++++-----
 io_uring/nop.c                        | 17 +++++-
 io_uring/register.c                   |  3 +-
 io_uring/uring_cmd.c                  |  2 +-
 io_uring/zcrx.c                       |  5 +-
 12 files changed, 152 insertions(+), 56 deletions(-)

Changes since v1:
- Various little cleanups
- Rebase on for-6.18/io_uring

-- 
Jens Axboe


