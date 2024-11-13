Return-Path: <io-uring+bounces-4656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D02549C77EB
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 16:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC162B3DA4D
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DE015C14B;
	Wed, 13 Nov 2024 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AlIa+7s8"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3E70835;
	Wed, 13 Nov 2024 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511275; cv=none; b=gjhP5c/8wmYtWcJb/UY7BG92Eea6J+ewP+UrIEaTvdi1jQTvQILk+NEn5l277agnqbwo3eWTXfc7MUXoMMR2PKr5fORUuQZXof3JNeBqn+4IV+fDddAsAdrp2Weh5QY7JjctVota/tacrEwdaSP+eYXKtAvJaQuQzqJdTo0RKLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511275; c=relaxed/simple;
	bh=ecvWJqsRiB/VRI5B56crQpyOWmaLA93kDwgOG2jJ2ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlX81WjKAGX2nYbinF4jLl55ME2RwmC4Tb0E0jp2oKJZJhZasZQd3rvEqeKs7mvlYjRFla4529xWV5+hdX8TzKTWlBwz0bk2vK96yqMBPUxEwnJJeAlyon1RlpR0cSgDo3oM+Cq8IZbests2ZeX9gT7t6BHk1rfMmZJ9w2ev6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AlIa+7s8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AULfdb3WZgUO3JCKZ2NM+vw/f0W+uRYWQJj+bN/yryk=; b=AlIa+7s8bcByfyT4pi1KwnL8zm
	EyYjDJyy1S8BoGAb7pG0NE6DrmQhIVIngymlzbjZxbZOmFoWEEevcSRM25SrwCDGfibYKG6UG47ca
	nASGpl3qb3Mv5SBYhtj1Kj7QZVnBcv+Q8wPjaXDpnldK69NIhFtan7293NDNeOd5mbiOCutokx3D5
	vg5qSuHVR761erPoNGsVr21TWJ9avGW5oHqErUG/RjgXAZ+0F6WFs3e/Mk3F5sAZAQR4J6ADXiixP
	PuCwqkTtsxUdK+aIz+mMJ0xdEJ1qgHr3dfj0Uu3lpKHfkswLKI6oSJb3oUyI2d0r9HOdDACRH6/Mb
	5jkNDTgg==;
Received: from 2a02-8389-2341-5b80-9e61-c6cf-2f07-a796.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9e61:c6cf:2f07:a796] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBFB9-00000007HS5-2HE3;
	Wed, 13 Nov 2024 15:21:12 +0000
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
Subject: [PATCH 6/6] block: don't reorder requests in blk_mq_add_to_batch
Date: Wed, 13 Nov 2024 16:20:46 +0100
Message-ID: <20241113152050.157179-7-hch@lst.de>
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

LIFO ordering for batched completions is a bit unexpected and also
defeats some merging optimizations in e.g. the XFS buffered write
code.  Now that we can easily add the request to the tail of the list
do that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blk-mq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c61e04365677..c596e0e4cb75 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -884,7 +884,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	else if (iob->complete != complete)
 		return false;
 	iob->need_ts |= blk_mq_need_time_stamp(req);
-	rq_list_add_head(&iob->req_list, req);
+	rq_list_add_tail(&iob->req_list, req);
 	return true;
 }
 
-- 
2.45.2


