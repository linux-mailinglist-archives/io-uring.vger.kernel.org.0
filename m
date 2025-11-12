Return-Path: <io-uring+bounces-10528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8CD1C50E90
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 08:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32BB11897A7C
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 07:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58F22C324F;
	Wed, 12 Nov 2025 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZlBYqBSr"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3AC2C21D8;
	Wed, 12 Nov 2025 07:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932159; cv=none; b=ILOgaY0a/FrHl9AJvCl6t6CChoXdCydtnLxHecNJA4iDZRi9pLu4qO7puqAuyk83PaXwmsnPCL+9M30oZbI+m1PMhpsNqFl9pL/ibwQ2vCT/0bYiQO2Yvrcyugx+qY4vovuS2swLvsc4k9PEZljpgwd5RMyMYNXLsP/qe3Oi1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932159; c=relaxed/simple;
	bh=CYlvlOgRInF79J6UMI5yyZnpfEosbWfM1f6pk63ZyYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Ok7ACsTWaqTR3QvVp/Kf2xDwcicuHkWX1wvVTMF7My/qTqH9zx6tvUENmnhpRpzrckABrwfXG0tOXAR2EqZCESO9jT/Cxszi03+rwcIpWFbi92biHGkUXRhqQ51R6G4Tqp5ZUIZPkDMG/5aMtugrRzpknDErNAlIMwfSOa3vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZlBYqBSr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D5IRbijpBA5bWvCFFBMsnOXdYiBOGPsVa5vYBmjcbtg=; b=ZlBYqBSrwRIFAgQXLfrDBS+W/I
	sbgchZoAeZnckbZDpLwJZ1XEvU2aS6WAFUdmu+tj8zgWWPs5m7uKDPMR+DvczBf2DUpnRd3rgsds5
	B117emcPl+9eYtK6RzpRCdLULMJb1X5VN1oQJstYB7SYtt3FakfX4qE8uzCcQ6dXzV96puxAAsaZq
	fdlMbAffJJOIi1BR7IFiJcG+5ebTeKdPWFP3mGFx/KjzyQQZ/VnqMLpaXeXUcRiyA74091UEToUr8
	aVy+w797UIt9a2gy7Gwr+x235g4JaWihF89H7IzxzZNr7F6vbl8Stz647df8nxq72z2rACsHMGoTZ
	8w1GIP5w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ5Bc-00000008Gl0-1Lrv;
	Wed, 12 Nov 2025 07:22:36 +0000
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
Subject: [PATCH 3/5] iomap: rework REQ_FUA selection
Date: Wed, 12 Nov 2025 08:21:27 +0100
Message-ID: <20251112072214.844816-4-hch@lst.de>
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

The way how iomap_dio_can_use_fua and the caller is structured is
a bit confusing, as the main guarding condition is hidden in the
helper, and the secondary conditions are split between caller and
callee.

Refactor the code, so that there is a main IOMAP_DIO_WRITE_THROUGH
guard in iomap_dio_bio_iter, which is directly tied to clearing it
when not supported, and a helper that just checks if the I/O is a
pure overwrite.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 765ab6dd6637..c4a883fa8ea5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -288,20 +288,14 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 }
 
 /*
- * Use a FUA write if we need datasync semantics and this is a pure data I/O
- * that doesn't require any metadata updates (including after I/O completion
- * such as unwritten extent conversion) and the underlying device either
- * doesn't have a volatile write cache or supports FUA.
- * This allows us to avoid cache flushes on I/O completion.
+ * Check if this mapping is a pure overwrite that does not need metadata updates
+ * at I/O completion time.
  */
-static inline bool iomap_dio_can_use_fua(const struct iomap *iomap,
-		struct iomap_dio *dio)
+static inline bool iomap_dio_is_overwrite(const struct iomap *iomap)
 {
-	if (iomap->flags & (IOMAP_F_SHARED | IOMAP_F_DIRTY))
+	if (iomap->type != IOMAP_MAPPED)
 		return false;
-	if (!(dio->flags & IOMAP_DIO_WRITE_THROUGH))
-		return false;
-	return !bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev);
+	return !(iomap->flags & (IOMAP_F_NEW | IOMAP_F_SHARED));
 }
 
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
@@ -355,12 +349,22 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 		if (iomap->flags & IOMAP_F_NEW)
 			need_zeroout = true;
-		else if (iomap->type == IOMAP_MAPPED &&
-			 iomap_dio_can_use_fua(iomap, dio))
-			bio_opf |= REQ_FUA;
 
-		if (!(bio_opf & REQ_FUA))
-			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
+		/*
+		 * Use a FUA write if we need datasync semantics and this is a
+		 * pure overwrite that doesn't require any metadata updates.
+		 *
+		 * This allows us to avoid cache flushes on I/O completion.
+		 */
+		if (dio->flags & IOMAP_DIO_WRITE_THROUGH) {
+			if (iomap_dio_is_overwrite(iomap) &&
+			    !(iomap->flags & IOMAP_F_DIRTY) &&
+			    (!bdev_write_cache(iomap->bdev) ||
+			     bdev_fua(iomap->bdev)))
+				bio_opf |= REQ_FUA;
+			else
+				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
+		}
 	} else {
 		bio_opf |= REQ_OP_READ;
 	}
-- 
2.47.3


