Return-Path: <io-uring+bounces-10527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF019C50EC9
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E0A13AD7AD
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 07:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D422C15BB;
	Wed, 12 Nov 2025 07:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Td54X2J8"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4E2C08D1;
	Wed, 12 Nov 2025 07:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932155; cv=none; b=NqPajnc+l0lNR+cdn0s/DdG6IYNCb0TKIqEgYNCU5rEwyMNNYG1PPuiL9outs8qLHOPGplfybJvEdcs8ypq9xkoFwzcFb5ITe6u/FK3VNdYPBuZbyTxua5gZUgYSVqEVIZFX5fXxV43WRVFaVGyzHconLOydd/UrPl9J3/Z1P9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932155; c=relaxed/simple;
	bh=MXZ7E3TaeeFFg4DOQi1odXMx6mD2cdh6NK2RJ7ROVAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjxINjYx0AizhsjC1buoIS3m6GA114k/dxhdtZUJR2b/zx7ytDS805LREM+E5Hxtwac16sBWzjbIAnMYuK/8xPzeEnCIUN9VRLVmmTrKSO2hXkhrLixL+fwZCWb3AHLNtqxBGfG1VkPwHEv4WhxhMaiPb7bXPennK+8TKzpuGsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Td54X2J8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rFYjyazSOhXAfpT/GW8ABdV+NmLLNHcTCEUF8V+KFMg=; b=Td54X2J8SrKQ3b0i3WA0U6drSq
	KNJ2w1/UValoVEED/a5uZOchZTsPdH8WOF2ttDZSWCfsWoAy0evcwI1SgYC6PkunnCawwxvHCSqa/
	cToQpZL9I/rorOtlckFJPbQFCiOC92fDdS10dSlbW7AD2menxxhcUtHu38wDzEajeWXsTlUuZ7qhI
	dKgzb5cDj5EhdPilUn2Lgb/zmVpZnT9yB7WqPq7vHV/kgPkim2GMVYnZAL9e5maCDCXKLKEzDJqC6
	s+cY8rS8VjGx/zyqHaJ01Xs9Yicu63EGtqo4mlRbPGfUfdAVJPUkB7ih0SuLIPU+bZxi8DR429lXH
	94Znn0YA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ5BY-00000008GkP-0CJ3;
	Wed, 12 Nov 2025 07:22:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 2/5] iomap: always run error completions in user context
Date: Wed, 12 Nov 2025 08:21:26 +0100
Message-ID: <20251112072214.844816-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112072214.844816-1-hch@lst.de>
References: <20251112072214.844816-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

At least zonefs expects error completions to be able to sleep.  Because
error completions aren't performance critical, just defer them to workqueue
context unconditionally.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 7659db85083a..765ab6dd6637 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -173,7 +173,18 @@ static void iomap_dio_done(struct iomap_dio *dio)
 
 		WRITE_ONCE(dio->submit.waiter, NULL);
 		blk_wake_io_task(waiter);
-	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
+		return;
+	}
+
+	/*
+	 * Always run error completions in user context.  These are not
+	 * performance critical and some code relies on taking sleeping locks
+	 * for error handling.
+	 */
+	if (dio->error)
+		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
+	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 	} else {
-- 
2.47.3


