Return-Path: <io-uring+bounces-4653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0510B9C775C
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 16:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBCC1B2528D
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31E041C92;
	Wed, 13 Nov 2024 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oylhxPJT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DAA70835;
	Wed, 13 Nov 2024 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511267; cv=none; b=savrhSaXKep6CQoTzDYPVJuP22FY+HR3rukRjBAHqsHAk0O6SlIavlf/NMZ8hlBojYhXsS8LbYIT4V7fq5rpla6+SjKENZVUOTj44qVaG7wZ71M1NjqGvkcsp+km0RcMezk5S3aIoP/P8UBoccg0bCGN/55ewk1PoDt6TqLQOSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511267; c=relaxed/simple;
	bh=bPeioBsaE6qH81Muakn2ZVbkdT0s+mE+xjcxFfZwlzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOAYX6s7DDYdvYV31NvtG/78MEe3hqZbiG9Zt1N6TP0GEmio17VpdSvIG5O7vKMsV6eoTqZVBJu4Dvq+0xlyNbJXae6oYAGFMdLpVv/m4ubcDes/IJG/G9TZvS8Khk8/nX36nO3HnwlSFZqzC9oPAagGb8QvN6m38l5mbsE1iE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oylhxPJT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aBCg3s5eYCwAXZGUfBTT3Ag4k4EUgvfCKCqQqYes0aE=; b=oylhxPJTcw2ykJptxW1/2UBds3
	/CkPQRieGE/CjHiHd39do4l5gIweQM5yisxm+TXWtWza5ii3bN/dblyixnQOnQjBJM8L0qgfwwoQb
	ofbu2mfNpoLjyRxsAEFOf2CO7z0XioEXWY9R1afoNc7dzJJ7RH7xRndMag36im59/K1V0RLfhZvHe
	U1mBTmKwX0QyyDTTRnYqaLfbGfpL7frnDBjLoZzBosd3WaDT+N7/aUFBT/1rnwFXoeBmFK7GBrxi4
	OZ3ftoNS5fvyBSM4PQqdTBYTyLsbgbtXlEZbcjdIp3wDeP1B2tYR/UEypEbMHaZWON7eB2K0bodCS
	NKVNVWKg==;
Received: from 2a02-8389-2341-5b80-9e61-c6cf-2f07-a796.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9e61:c6cf:2f07:a796] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBFB0-00000007HMF-2pt7;
	Wed, 13 Nov 2024 15:21:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org
Subject: [PATCH 3/6] block: remove rq_list_move
Date: Wed, 13 Nov 2024 16:20:43 +0100
Message-ID: <20241113152050.157179-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
References: <20241113152050.157179-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blk-mq.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a28264442948..ad26a41d13f9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -268,23 +268,6 @@ static inline unsigned short req_get_ioprio(struct request *req)
 #define rq_list_next(rq)	(rq)->rq_next
 #define rq_list_empty(list)	((list) == (struct request *) NULL)
 
-/**
- * rq_list_move() - move a struct request from one list to another
- * @src: The source list @rq is currently in
- * @dst: The destination list that @rq will be appended to
- * @rq: The request to move
- * @prev: The request preceding @rq in @src (NULL if @rq is the head)
- */
-static inline void rq_list_move(struct request **src, struct request **dst,
-				struct request *rq, struct request *prev)
-{
-	if (prev)
-		prev->rq_next = rq->rq_next;
-	else
-		*src = rq->rq_next;
-	rq_list_add(dst, rq);
-}
-
 /**
  * enum blk_eh_timer_return - How the timeout handler should proceed
  * @BLK_EH_DONE: The block driver completed the command or will complete it at
-- 
2.45.2


