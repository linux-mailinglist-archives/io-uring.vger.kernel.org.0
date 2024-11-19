Return-Path: <io-uring+bounces-4819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 959369D2574
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272BF1F238B6
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DB61CDA0D;
	Tue, 19 Nov 2024 12:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KNLOE6Xn"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D636F1CCEFE;
	Tue, 19 Nov 2024 12:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018615; cv=none; b=ohkWzUFK/4iijbsYJjH6lOMRmo1vhAHt7joZ3cLe4A2LixXvLcrHB2TiJ7pGEL8CTDTq43JKLu+WN7n9RaRtv7btauIDrZ3TIiNCLEpV5pk33lkKenJVeYliFpIdwPNG3SMJQTuqnW1TCrsig450gdA0ZJSjXOHTb5wSKioGuDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018615; c=relaxed/simple;
	bh=dLdNBF4zfIru8AAjimD/fY61DLdpN6M7CqjtOUNFGUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyRx6s+giHdzXRGHYvAYKFeb3W/qFiWEbj5UZVv0B00RgGiNYrZgXsKzNOT2ZkoDd9jUN6KQ+ZsAdZ3iHLAeY9pUJWMO2HcDnbAY0xp4VxU4YNOLf3gh0hlr91GfM9y9kZMbTfxuEu7vwVjNUvlC7mcybsb6CY5EgS28MM5Zj4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KNLOE6Xn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UMJbKREIuMD5uCy3FOcLgHhasA9Umujy7x7rg1JjQ9g=; b=KNLOE6XnZ6ADV10pQg6d7nWP2r
	wino3rNcbnJm9lOCM8+aySOrFKN5yHudGsSKOsPX3sKtJqZSowYs4KtuvtwLGycIbVUc8SeT8gwIW
	gneceFxUaIgzSWpJOaexV6AMA+/nbADjVJ2a9pWDi8AP/HqJCC0FfQQEVtGAn/7yUS4LgMARSzM5E
	icjQPrMN69BCXX5sLkOMMW0z+8q6iguaqVd8DtLeWqa9AWNSNmbswHP9Iu40ZlUlIcvC050CR6pfz
	EE7TXZWy0vaAJZMagWfUZYon37HtGNJAvnlcFrzPIU5FxBcT1jMhTaDqbrx9R1O6AHRvU1sFZCmk0
	gWJEbCeA==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNA3-0000000CIwW-20Ae;
	Tue, 19 Nov 2024 12:16:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 05/15] block: req->bio is always set in the merge code
Date: Tue, 19 Nov 2024 13:16:19 +0100
Message-ID: <20241119121632.1225556-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

As smatch, which is a lot smarter than me noticed.  So remove the checks
for it, and condense these checks a bit including the comments stating
the obvious.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 64860cbd5e27..e01383c6e534 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -864,14 +864,10 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req_op(req) != req_op(next))
 		return NULL;
 
-	if (req->bio && next->bio) {
-		/* Don't merge requests with different write hints. */
-		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
-			return NULL;
-		if (req->bio->bi_ioprio != next->bio->bi_ioprio)
-			return NULL;
-	}
-
+	if (req->bio->bi_write_hint != next->bio->bi_write_hint)
+		return NULL;
+	if (req->bio->bi_ioprio != next->bio->bi_ioprio)
+		return NULL;
 	if (!blk_atomic_write_mergeable_rqs(req, next))
 		return NULL;
 
@@ -983,26 +979,16 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (req_op(rq) != bio_op(bio))
 		return false;
 
-	/* don't merge across cgroup boundaries */
 	if (!blk_cgroup_mergeable(rq, bio))
 		return false;
-
-	/* only merge integrity protected bio into ditto rq */
 	if (blk_integrity_merge_bio(rq->q, rq, bio) == false)
 		return false;
-
-	/* Only merge if the crypt contexts are compatible */
 	if (!bio_crypt_rq_ctx_compatible(rq, bio))
 		return false;
-
-	if (rq->bio) {
-		/* Don't merge requests with different write hints. */
-		if (rq->bio->bi_write_hint != bio->bi_write_hint)
-			return false;
-		if (rq->bio->bi_ioprio != bio->bi_ioprio)
-			return false;
-	}
-
+	if (rq->bio->bi_write_hint != bio->bi_write_hint)
+		return false;
+	if (rq->bio->bi_ioprio != bio->bi_ioprio)
+		return false;
 	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
 		return false;
 
-- 
2.45.2


