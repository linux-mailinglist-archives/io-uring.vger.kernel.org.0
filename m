Return-Path: <io-uring+bounces-11207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4388ECCB31A
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 962BD305A3F6
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6927C2BE63F;
	Thu, 18 Dec 2025 09:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5jGWMfJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D0CA6F
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 09:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050333; cv=none; b=KcuF3xnCKjmXwe5+CONAQDARiNHV9XWxjhLAo3OOtDko4J2XmlgJ1tMxvYHDDI8X5upBef6Espq/BvZ0zIfD8eXHNA+02IFYHXfcvTyBKvf3pv213ZjM/ecMFG1ljxsz2tqnujkdFYt2SHdrLh9LpqDkDNTnmJ2ukqkNt4A4s58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050333; c=relaxed/simple;
	bh=IdRcDpymma6N6F8dtuqdSt8YmT37EkxmSNM1+oAiC8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLfymIfTQjOhT5MgK5dBfuA8AMsmbGEtjKSHuRl3HAAMI2VqZQSi9M6zrOXcpADGhQWtPY75dzTdyQAFbwAWe6fOvlnxpN6sDn5ZSIpQFX0QoRDJhW5aLGvqaFX2ixC1F8Tphd/8mMM4JWHxIlt8Gn9tDyHWRt7aZSZ7eSGDLtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5jGWMfJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766050330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNkyTWOD+S575iw9P0hzXyCCOpPN/9Hm0dKWctpArho=;
	b=b5jGWMfJa0I0kI7o7IfKQMEj6RlkL6YhRA1VMF79tW8Zfwo8viFOehllol+hmYMHQQRhRb
	pKXfbdNu7xXXmWy5Rd8syyB47rsEorAi6sbk+hC+yvgniAeodUKi+ArMGqi2k5nLvI/T8v
	MdE4dDdLIiViHkR8BTBuIf34RpzkPUM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-MggMEd7nOWymbF3Lp5tl0g-1; Thu,
 18 Dec 2025 04:32:07 -0500
X-MC-Unique: MggMEd7nOWymbF3Lp5tl0g-1
X-Mimecast-MFC-AGG-ID: MggMEd7nOWymbF3Lp5tl0g_1766050326
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7969A1801216;
	Thu, 18 Dec 2025 09:32:05 +0000 (UTC)
Received: from localhost (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4483D19560B4;
	Thu, 18 Dec 2025 09:32:03 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/3] block: fix bio_may_need_split() by using bvec iterator way
Date: Thu, 18 Dec 2025 17:31:42 +0800
Message-ID: <20251218093146.1218279-2-ming.lei@redhat.com>
In-Reply-To: <20251218093146.1218279-1-ming.lei@redhat.com>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
passed to bio_may_need_split().

So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
checking with help from bio size and bvec->len.

Meantime retrieving the 1st bvec via __bvec_iter_bvec().

Fixes: abd45c159df5 ("block: handle fast path of bio splitting inline")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index e4c433f62dfc..a0b9cecba8fa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -371,12 +371,19 @@ struct bio *bio_split_zone_append(struct bio *bio,
 static inline bool bio_may_need_split(struct bio *bio,
 		const struct queue_limits *lim)
 {
+	const struct bio_vec *bv;
+
 	if (lim->chunk_sectors)
 		return true;
-	if (bio->bi_vcnt != 1)
+
+	if ((bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE) ||
+			!bio->bi_io_vec)
+		return true;
+
+	bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	if (bio->bi_iter.bi_size > bv->bv_len)
 		return true;
-	return bio->bi_io_vec->bv_len + bio->bi_io_vec->bv_offset >
-		lim->max_fast_segment_size;
+	return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
 }
 
 /**
-- 
2.47.0


