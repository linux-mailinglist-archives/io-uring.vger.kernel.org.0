Return-Path: <io-uring+bounces-4818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB169D2570
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01343283829
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D601CCED0;
	Tue, 19 Nov 2024 12:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HAb0b4GE"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED71CCEC2;
	Tue, 19 Nov 2024 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018613; cv=none; b=jY+2ifJCdgYgjbkVvKtNKj6vs/NG6HmQaYJwOjKqCx7K4BP7x4Dy5knu2YnzB2KjfpZBNwdOX/ug+g9em5XIMEQ7WuMSfWzV1K0UX+Vm/F4D5WBzMXXoUH0bLkV0tuUyLMvSg7juaFIJ9qAnx9Vbzfu78iiqEgo5GX6vt7Wrjn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018613; c=relaxed/simple;
	bh=vh3ZDsX1PAGo8R4dyemIuOJQPsP5FnOgULIbkZHlY14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoPdndxW71Iev4ieOvLC3P3n9Z82nbEnYcDx8HySgkK/Jj/vJXPLshY4X2gNFgCX5j9NcGWFg8eck7puQQyaiV7kn8NgWI5iOkWT7b4proRfGvy6oNGe4mEb1B07No6fqKjX3gp4hX5CLbjw65EXqMChirdKDOcefeBIzDMV1qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HAb0b4GE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QST484Rjm0qjanP7JHElr8kCM2HEOEq9yFeGtbndeP0=; b=HAb0b4GELjvYnlYTmThOOY94MH
	MVfGgThXUIOnJE6p1YPSrR1hZibMLHhedliUtfvesUvs7SQFgH3R2cu2KPm2pQo+oEXhzB6hgypnl
	db9ieeHMVdBCahGChdJLmK6pMohbjwYTjD+qa3iZAu/i09+RxjrDwKDNpDHzgQqF+vjO+7KEkTJ+H
	lSm7eQTBjhk2iwhJiCNC9EHioEuYP7RIDtXNIpcPHSP8mHaetvVvd/t2zNNxuhttFCMg8r3jj1wFo
	s7yKS6HYYsK2khBRovKXX1GBlN3kSjcvfMW+fKADnosjoav3wffSuQLPUrqla7/PPWD3Fzyr3Nm9E
	sfEu1yTA==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNA0-0000000CIv8-3seG;
	Tue, 19 Nov 2024 12:16:49 +0000
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
	io-uring@vger.kernel.org
Subject: [PATCH 04/15] block: don't bother checking the data direction for merges
Date: Tue, 19 Nov 2024 13:16:18 +0100
Message-ID: <20241119121632.1225556-5-hch@lst.de>
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

Because it already is encoded in the opcode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index e0b28e9298c9..64860cbd5e27 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -864,9 +864,6 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req_op(req) != req_op(next))
 		return NULL;
 
-	if (rq_data_dir(req) != rq_data_dir(next))
-		return NULL;
-
 	if (req->bio && next->bio) {
 		/* Don't merge requests with different write hints. */
 		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
@@ -986,10 +983,6 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (req_op(rq) != bio_op(bio))
 		return false;
 
-	/* different data direction or already started, don't merge */
-	if (bio_data_dir(bio) != rq_data_dir(rq))
-		return false;
-
 	/* don't merge across cgroup boundaries */
 	if (!blk_cgroup_mergeable(rq, bio))
 		return false;
-- 
2.45.2


