Return-Path: <io-uring+bounces-10607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 597CCC593D7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 18:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5CD86540CCB
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 17:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0762BE04F;
	Thu, 13 Nov 2025 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UxStfElo"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E671DE8BE;
	Thu, 13 Nov 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763053616; cv=none; b=q7eJtXqQ7RNl4ap2hWSUYu4cJCpSbU0GDfnfyJk2tNK0m6QkthqjVybEVr1a97qjjx8MZmXK5qx6PX61r2pHgjM1Qq4TO+y+B7HbddcmAYjVmUtzVWCaKeQ5uQVzk6Zq6OpBCgL0+eg9nvgjLl7GPM6hK9Tu/XWZ6FLP4yYAetU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763053616; c=relaxed/simple;
	bh=zn4nrX+eiRmrkLIcC8nc0Aq+UvG3l1VT3TCjV5kpc88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOqS6pokzsqNHR2R0JFVlRsuYKfLtYkXfFVLxtctLsyzkeyLow9mB7KbbtdDC4WBMAsUnOfZIuUKPvkmW00DamgCT6YSG8B+GhJ3ByVJKXaRWBls1sedDsEiwvt4Hs0kIA83EMd6S1RYLQy37oNAJTlo6I+tjOzEQzTbiXHxL1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UxStfElo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fRoUPFFfWGqvwY2mq8Pt7nIKYxrkrIwi1TbB4EBaEWs=; b=UxStfElo7hZsrwIFqlOpWW3BKu
	DHBAkBwl1aKvXw1/3ZeIYJh3i87KotX+Y+wnA3euwsLwOPmt+iSArywQQKZ6oUamruR2SkRGZPhzt
	zv78YpfH1MqRvZwhSSTsOj4E7FwlCPQcrrlG2JKUlthaUS/o/M6JqBX+YiaGgIquSYDI9N3ll/oVW
	l5qLUVsvyK0TtGWzqoGFxmFbLny9OsOegdwbbOF0taGwr6FxPEVFxzQPY3brjpqhf2m1bgWPe5EFi
	AMPfO0nICZTDitOHjeVGELY1bXk84yFKfb3r247GWw3ikw0Hb4r1tf3ykU+FaTgR9HgJTUTSjsm2Y
	8vFRQb9Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJama-0000000AqNu-00QS;
	Thu, 13 Nov 2025 17:06:52 +0000
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
	io-uring@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 2/5] iomap: always run error completions in user context
Date: Thu, 13 Nov 2025 18:06:27 +0100
Message-ID: <20251113170633.1453259-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170633.1453259-1-hch@lst.de>
References: <20251113170633.1453259-1-hch@lst.de>
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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


