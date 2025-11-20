Return-Path: <io-uring+bounces-10678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DE1C72607
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 728372A006
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F012F7ABF;
	Thu, 20 Nov 2025 06:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a1ZG2hP8"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003172FB094;
	Thu, 20 Nov 2025 06:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621378; cv=none; b=JQxllPFz/WkUdZkJ6CT4I5H4rAGgyCxySUhW8bTpfEAPYETVXi/elF5VZFkNvlwpl/kmiFWYVeqxMiJvhvrjksKB+wCzhjhC/ZhEEcZbECoyccjxnIPxLZ+DK2+F2kZ+o4aQC088ZY/7eKP6ysGQJ+6HDLZkF5Ocf31mLDzVqEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621378; c=relaxed/simple;
	bh=1TRV9639jjAK/yyr7XuFpYWgDfy24YDf6ESYkkGqWKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtEycfMFXhZQz5eWEqNwcjdo+NX7oHZxcqNq44es5yd0fg8+BHmxX+OiAlzsyocXEDaxDBi+AYaKtWVb0DvrQeTFVymhuQxIvEvEXFqjZoyslAheSSwerXZwtuDARSTI7MVpqxvrnWxh0sc4Q5OEmO2waT3roAC4VE1FefPky2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a1ZG2hP8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q1k0Rdu+B2oAEqSAkLXPS0Z5inNZsTh7a1kdLbTnVX4=; b=a1ZG2hP8T+sIwHDMrQkSvZLIgz
	Tjm+B1bsfNEhrmg3zkSKFj+qpRp150/gfubPM5XCOsWyFhbbKh24RQJyW2u5Uc9vucPRs5KFj+nlD
	g7guvqsBVbElZusgbrVVvtt2w4tLDLXHoV5nutj3tTipTaEctngw6jHzthi/DF8Qb7qjw+pw3ysoX
	lfvwR7orazMq5OZheRZY1uGsRofcxH38Ae58WdrDdSaomI8YclOgolBnc12qdglMZAvuqfzbz6zAm
	gH4pss0xV/S5/kL2YhHhVXT3Ze7uflClR5eMWC9hswu/cTGQD5+d+/mDbIWbyzKjrp1ZUA+APIUNl
	qVVrxmFg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyU2-00000006Egn-2OMT;
	Thu, 20 Nov 2025 06:49:34 +0000
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
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 03/16] fs: export vfs_utimes
Date: Thu, 20 Nov 2025 07:47:24 +0100
Message-ID: <20251120064859.2911749-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
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
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
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


