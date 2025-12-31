Return-Path: <io-uring+bounces-11338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C76E3CEB28D
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 04:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A8603004527
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 03:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5A421ADB7;
	Wed, 31 Dec 2025 03:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxBSPbm5"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BEBEEA8
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 03:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767150077; cv=none; b=J4dOnimmsZQEFhFX38m7k2el0MDInpO+qKpyMlwCiYfLhEG1SSvMuy7IqoB/GiCbyoXPK6OZnqLlLCC1uyrTBq09jpY6BWpmdsbRH6yT2VPDi9gXWp5iB0SPlT1dFSTsfP00jF5RetOiP4P9UvCKp8YZGLkBnO4iIJ0nLTdeLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767150077; c=relaxed/simple;
	bh=C2OHIemlX+5fmONcMPHO5uO582PcWpRSP4x6WdXwqv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CYYwAF99Ga9jswelMLRTkqpJ1wvLfGNIQqTYIbzs8A5pkJda2a+OlE9h0HzkeUSBDiHnGcCL5v+Sgdv78fWu5NWpxnqerChILnCUczrEb61jT8rXQcrKEYB3HBZ20CVbEGvNQXGeb9OGwRyvvCSSaMwIbP0SOd0Fe6PPAvz0fvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxBSPbm5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767150074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kpRq/1M9/wM0DlbC3ziYDPj1R3CzNTH/TXOERyiqeMM=;
	b=bxBSPbm5TpO4Xa/R2p3RRIp9p9mtmov/bd1cLPu49KHt0+B2gI81ztn/bUFb8m34Z5VKC1
	G3IyexWtCo7YLhZCDnp6wSemth/9JbEYVFMEpmZ2ZmEY6t4q6M+mo7ubZJCRtmWhNqWocO
	YKZKees4PhtHAoD/cVl1XomMs5ISWY8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-9FxY58rmPOG5COmnG6RnjQ-1; Tue,
 30 Dec 2025 22:01:10 -0500
X-MC-Unique: 9FxY58rmPOG5COmnG6RnjQ-1
X-Mimecast-MFC-AGG-ID: 9FxY58rmPOG5COmnG6RnjQ_1767150069
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65DFE1800365;
	Wed, 31 Dec 2025 03:01:09 +0000 (UTC)
Received: from localhost (unknown [10.72.116.52])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E1E119560A7;
	Wed, 31 Dec 2025 03:01:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/3] block: avoid to use bi_vcnt in bio_may_need_split()
Date: Wed, 31 Dec 2025 11:00:54 +0800
Message-ID: <20251231030101.3093960-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This series cleans up bio handling to use bi_iter consistently for both
cloned and non-cloned bios, removing the reliance on bi_vcnt which is
only meaningful for non-cloned bios.

Currently, bio_may_need_split() uses bi_vcnt to check if a bio has a
single segment. While this works, it's inconsistent with how cloned bios
operate - they use bi_iter for iteration, not bi_vcnt. This inconsistency
led to io_uring needing to recalculate iov_iter.nr_segs to ensure bi_vcnt
gets a correct value when copied.

This series unifies the approach:

1. Make bio_may_need_split() use bi_iter instead of bi_vcnt. This handles
   both cloned and non-cloned bios in a consistent way. Also move bi_io_vec
   adjacent to bi_iter in struct bio since they're commonly accessed
   together.

2. Stop copying iov_iter.nr_segs to bi_vcnt in bio_iov_bvec_set(), since
   cloned bios should rely on bi_iter, not bi_vcnt.

3. Remove the nr_segs recalculation in io_uring, which was only needed
   to provide an accurate bi_vcnt value.

Nitesh verified no performance regression on NVMe 512-byte fio/t/io_uring
workloads.

V2:
	- improve bio layout by putting bi_iter and bi_io_vec together
	- improve commit log

Ming Lei (3):
  block: use bvec iterator helper for bio_may_need_split()
  block: don't initialize bi_vcnt for cloned bio in bio_iov_bvec_set()
  io_uring: remove nr_segs recalculation in io_import_kbuf()

 block/bio.c               |  5 ++++-
 block/blk.h               | 12 +++++++++---
 include/linux/blk_types.h |  4 ++--
 io_uring/rsrc.c           | 11 -----------
 4 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.47.0


