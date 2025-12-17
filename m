Return-Path: <io-uring+bounces-11149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2A5CC7A43
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 13:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B4C03009FB8
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 12:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CDB233D9E;
	Wed, 17 Dec 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NV2/et5N"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F6341650
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765974745; cv=none; b=nWAqGlvpZzeqW54yR7N4QgMiWnnwnIMER+Re1eGEzff5fQuk5t2J/Gnr9tJo2TbHwLsv8316jKHy+ZB4mMSKKj/puY2iwdFaQjsWsmlLFCjo5e/NxECGO+dQtiKRoghcX8GQ6P8FT4V174krMefGbJE+gf6T7lltiGt1llFw5tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765974745; c=relaxed/simple;
	bh=PBM2i5Rn4bZoNGq+r9v1APX/YYGk68mdSyO/A9CA4rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eil5HcZvfPZN7nZLsvIsJh9n+SN1G7hsFGYMF+41W+BjX8KgWY7VZzaBabeIMCp5Nqruwi5j02kcHu7G/c2ButoRmcC+HCxVmvVt+7hDJjlrZKEW06yXr15Igv6/htoDcnUfJCdvgZdRGZ2g6ZfV+fO5/9FRuaBeip40QAFtS4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NV2/et5N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765974740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jbqhe7Osb3FDE5B2k48tS1OnCycGlH5+0bsuiL9kPds=;
	b=NV2/et5NbIrVaoQfUDjYEIAlezeg2KynyKzAEkiwTHxQVqJZ330E9oXtG5A1F+AuqXn+gX
	04HrO9yXjS2KpKiSIvgiBbOAu4E5Q+GbfqdzX4o/hI7y5fr9gXY2VM01sy3L4ePcMrQmJp
	XmqJ9SEc0OchaXmJkjaEiifzhq6ar38=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-0NzhjT9pOAqkbaPRZP3HnA-1; Wed,
 17 Dec 2025 07:32:17 -0500
X-MC-Unique: 0NzhjT9pOAqkbaPRZP3HnA-1
X-Mimecast-MFC-AGG-ID: 0NzhjT9pOAqkbaPRZP3HnA_1765974736
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51F621800657;
	Wed, 17 Dec 2025 12:32:16 +0000 (UTC)
Received: from localhost (unknown [10.72.116.190])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A32D1956056;
	Wed, 17 Dec 2025 12:32:13 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	huang-jl <huang-jl@deepseek.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use single loop
Date: Wed, 17 Dec 2025 20:31:56 +0800
Message-ID: <20251217123156.1100620-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Replace the iov_iter_advance() call and the separate loop for
calculating nr_segs with a single unified loop that iterates over
bvecs to determine the starting position, iov_offset, and nr_segs.

This simplifies the logic and avoids the overhead of iov_iter_advance().

Cc: huang-jl <huang-jl@deepseek.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..f7ee146d5330 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1051,20 +1051,38 @@ static int validate_fixed_range(u64 buf_addr, size_t len,
 static int io_import_kbuf(int ddir, struct iov_iter *iter,
 			  struct io_mapped_ubuf *imu, size_t len, size_t offset)
 {
-	size_t count = len + offset;
-
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, count);
-	iov_iter_advance(iter, offset);
+	const struct bio_vec *bvec = imu->bvec;
+	size_t iov_offset = 0;
+	unsigned int nr_segs = 0;
+	size_t remaining = len;
+	unsigned int i;
 
-	if (count < imu->len) {
-		const struct bio_vec *bvec = iter->bvec;
+	/* Single loop to calculate starting bvec, iov_offset, and nr_segs */
+	for (i = 0; i < imu->nr_bvecs; i++, bvec++) {
+		size_t bvec_avail;
 
-		while (len > bvec->bv_len) {
-			len -= bvec->bv_len;
-			bvec++;
+		/* Skip offset bytes to find starting position */
+		if (offset > 0) {
+			if (offset >= bvec->bv_len) {
+				offset -= bvec->bv_len;
+				continue;
+			}
+			iov_offset = offset;
+			bvec_avail = bvec->bv_len - offset;
+			offset = 0;
+		} else {
+			bvec_avail = bvec->bv_len;
 		}
-		iter->nr_segs = 1 + bvec - iter->bvec;
+
+		/* Count bvecs for len bytes */
+		nr_segs++;
+		if (remaining <= bvec_avail)
+			break;
+		remaining -= bvec_avail;
 	}
+
+	iov_iter_bvec(iter, ddir, bvec - nr_segs + 1, nr_segs, len);
+	iter->iov_offset = iov_offset;
 	return 0;
 }
 
-- 
2.47.1


