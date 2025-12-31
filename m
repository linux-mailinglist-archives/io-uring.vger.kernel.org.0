Return-Path: <io-uring+bounces-11341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1288ACEB2A5
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 04:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA0DE3029BBF
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 03:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB1CEEA8;
	Wed, 31 Dec 2025 03:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SVwZJH6W"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3503623D7E0
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767150095; cv=none; b=d/pWIl2yTw2mGRSQTKLWM8lbaG4bVTsmPkEnQ2LOsTLxouEd+MgsQlhNGB+OmqWvi8r1LOY35OCCowjzbYdlMq9nYG/PT1rrefDvnVGUBfuUvewkpJiEBxcqhnqWpJcvmFeye17xSEfTvD54h7n4CJaF3tPp8hsouFsMvDC0I0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767150095; c=relaxed/simple;
	bh=Adc/gGOQhKQ7iKHAIQg0d2G/OCsfV4g86heNR+UaMz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVROkE1bx8z9jbF7IYZIDvA/jfurRU9h0qzUtzrLrLbfmzh+GWAMVM3nKJ6fm93t+qYuW376SeSDcarod1I5HiHDXkYlN0uY8SS1tQ/l57jJtO9UPNVnUQjCIn/wpd42Yj0ZHa1rCaWuUE/pnoZhE+bhHXMneXViDUkyV+OccFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SVwZJH6W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767150091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSEBKVXerWmpVQLRf+Hq5xLIOFc46hGGm9aUmXEaGuk=;
	b=SVwZJH6WnQi2N3KtMOWSUTqjW5/RreqP3Wbhm6ACfN7eOq4EZUuZM8ckKJREwLoUbQp3OY
	Cyicj9DNsdfc1ObJKSnzH1ePSO8cpDHC5d0Vx0afEhDlh1EWCR9+8mh2X37PH4ip5H7+c9
	q9uVXiOQEtll7ELHwxpUSsOINZkhBA4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-qPkN10iZPmOTu4kKbsCcnQ-1; Tue,
 30 Dec 2025 22:01:24 -0500
X-MC-Unique: qPkN10iZPmOTu4kKbsCcnQ-1
X-Mimecast-MFC-AGG-ID: qPkN10iZPmOTu4kKbsCcnQ_1767150083
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EB4818002DE;
	Wed, 31 Dec 2025 03:01:23 +0000 (UTC)
Received: from localhost (unknown [10.72.116.52])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51ADE18004D8;
	Wed, 31 Dec 2025 03:01:21 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 3/3] io_uring: remove nr_segs recalculation in io_import_kbuf()
Date: Wed, 31 Dec 2025 11:00:57 +0800
Message-ID: <20251231030101.3093960-4-ming.lei@redhat.com>
In-Reply-To: <20251231030101.3093960-1-ming.lei@redhat.com>
References: <20251231030101.3093960-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

io_import_kbuf() recalculates iter->nr_segs to reflect only the bvecs
needed for the requested byte range. This was added to provide an
accurate segment count to bio_iov_bvec_set(), which copied nr_segs to
bio->bi_vcnt for use as a bio split hint.

The previous two patches eliminated this dependency:
 - bio_may_need_split() now uses bi_iter instead of bi_vcnt for split
   decisions
 - bio_iov_bvec_set() no longer copies nr_segs to bi_vcnt

Since nr_segs is no longer used for bio split decisions, the
recalculation loop is unnecessary. The iov_iter already has the correct
bi_size to cap iteration, so an oversized nr_segs is harmless.

Link: https://lkml.org/lkml/2025/4/16/351
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..ee6283676ba7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1055,17 +1055,6 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, count);
 	iov_iter_advance(iter, offset);
-
-	if (count < imu->len) {
-		const struct bio_vec *bvec = iter->bvec;
-
-		len += iter->iov_offset;
-		while (len > bvec->bv_len) {
-			len -= bvec->bv_len;
-			bvec++;
-		}
-		iter->nr_segs = 1 + bvec - iter->bvec;
-	}
 	return 0;
 }
 
-- 
2.47.0


