Return-Path: <io-uring+bounces-4816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 382369D2568
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E47AD1F2346D
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D641CC8B8;
	Tue, 19 Nov 2024 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZIZ28wZf"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8671E1CC8A9;
	Tue, 19 Nov 2024 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018607; cv=none; b=sKKvVHzDDGPxuquUVreHHPi7tcVMvASBLEF6E4oR+2IkeN6d+mMbnsnuR8Rg+0tUUaTWP9As9YOmp3CNEOeUnKDikT9ODqhm4Q84c3WweF/LTMzk8zZ5NTuUg6cT/oC3inqSAaMlV2Xd8HIgmsekdGqw2ZX0rKkt9XlmZRUnEBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018607; c=relaxed/simple;
	bh=ItiR6s+X18KllvRMLmnlAHOdna3YMLpNb2rSIE4I//o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYWWkMRC6UokSf4DfUPJqD9pP7G3vswXkzM0kwKmKovyNH2BLhUw0EfpYdFfeY41yuPexAisCfHxcRHFK0b0qjenQQ71EaHNBnksop1+Wmz/kZN8cNF3bV+o6WajN/Jf8v7e9k4IqPmf0pVlBDrtgJqWujiBQ4fOf+Y2oj7zrgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZIZ28wZf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JRKFVYldGi+Mip7kGl2nMr3ub2NZztZbmnBFCrNHiBg=; b=ZIZ28wZfARIuXO6AXci/O7w4RX
	DhGMKs7mln6OqKLTL2Xlfhrw3g+3DrPFXymnRkx33jsRU0bHfM7qdZWjgNu2dVrYNR8ugc06+CIxp
	BYBVT+dMcQkhUn1/8eP3dwAUvGrnUnFrEtyajGTkcgQlXoD7+SFf/HaeC9AyhU2pf4PdfNibNFRgr
	BCXovDAaehBrIKrZ2gg6yaj+BtguGw+LSaEwc7rrk2sVlS5ViGFjxIfJrTmx5K7renrIVgLf9CZcE
	WNapHKxDw50aq0eKADFasHnAXlA2Z++AHm40+sfd4XF0s1mofVWHxfksOhw4x8gGj/Wt/BG3qys1H
	eub5kN/g==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDN9v-0000000CIsh-1otv;
	Tue, 19 Nov 2024 12:16:44 +0000
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
Subject: [PATCH 02/15] fs: add a write stream field to the kiocb
Date: Tue, 19 Nov 2024 13:16:16 +0100
Message-ID: <20241119121632.1225556-3-hch@lst.de>
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

Prepare for io_uring passthrough of write streams.

The write stream field in the kiocb structure fits into an existing
2-byte hole, so its size is not changed.

Based on a patch from Keith Busch <kbusch@kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4b5cad44a126..1997be247b6c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -370,6 +370,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
+	u8			ki_write_stream;
 	union {
 		/*
 		 * Only used for async buffered reads, where it denotes the
-- 
2.45.2


