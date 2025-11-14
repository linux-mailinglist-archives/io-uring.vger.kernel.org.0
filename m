Return-Path: <io-uring+bounces-10618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36574C5B843
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2886F3BC4D0
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973802EBB8F;
	Fri, 14 Nov 2025 06:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZnPit9C8"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7292EBB84;
	Fri, 14 Nov 2025 06:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101633; cv=none; b=ehgEMM0Z/SxMfA6cC87V3Ep4bedKrbHBaCH02OeoRAUKam04/6CUeMR2gCqn9nmuYuGsBYWQTASfweS9jONNha4bSS9mKvgyLQgG4AIaukueGuxQFulgYsffCVmVewxRiMXayUwWp7uXuZg0uu8AXybIGBdHVEG+f/17QVgOPjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101633; c=relaxed/simple;
	bh=FCjA7W8PAfQ5+Lo4wRnMAtRcjGux3+F/HAnipkKv+18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL04Yia5tC/4x6wgXov1wdYN/GT93XeMI+sTq+A/iFXuVDZjszQfXuygYJftbtylHoswFH4GSo8XnnE2tIHleVfiJNOg7ZVZ3utrBuZXSEvVrD2r4/VxzfESUCfTBpVjmn2KP/kuuOHH2rCVkInjWOeVn0HVb27/45kGITnIwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZnPit9C8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wD0wfE3s79Dyr61s6x9SoG5JyjqKeWCmIUR2MMGjSG4=; b=ZnPit9C8R7lrfhLOQ9CvMJDkRP
	QzMV2LPFctR/SLMN5Do/1AWJCbQ+dWyAS8MpmkVmK5kqvr4kd23GlmEZhsxW1LuckXue2HjjEVgJ7
	G57dB8+/xksLGwmBQQQRITonlvfdlnUHlPG7BD76c6mNWBPWKl9SQBC0Mk0y1FwjgMcLbGBNVVni7
	Bqc2L0KwhWSyF9BoUoY/D2oGQn4eZETziZ+EQr4AlOcVnGy48abS+KxzuJt8nlJeTxspdGPuRweWI
	URo/6rSY8rX2pPRfkFNeukKL07TCG8xkEdgM1wY0Px8HheXz8NUcXRwrga/4hpoBJfL/M4CIrQQiH
	gxw6JOVg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnH3-0000000BeSq-2FF4;
	Fri, 14 Nov 2025 06:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>,
	Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 03/14] fs: export vfs_utimes
Date: Fri, 14 Nov 2025 07:26:06 +0100
Message-ID: <20251114062642.1524837-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114062642.1524837-1-hch@lst.de>
References: <20251114062642.1524837-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This will be used to replace an incorrect direct call into
generic_update_time in btrfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/utimes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/utimes.c b/fs/utimes.c
index c7c7958e57b2..3e7156396230 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -76,6 +76,7 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 out:
 	return error;
 }
+EXPORT_SYMBOL_GPL(vfs_utimes);
 
 static int do_utimes_path(int dfd, const char __user *filename,
 		struct timespec64 *times, int flags)
-- 
2.47.3


