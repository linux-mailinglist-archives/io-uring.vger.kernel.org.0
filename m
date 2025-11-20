Return-Path: <io-uring+bounces-10680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 763E3C726D0
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6F7054EAA07
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671AF2E973F;
	Thu, 20 Nov 2025 06:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vg+aMhXn"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA7E2FE593;
	Thu, 20 Nov 2025 06:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621391; cv=none; b=DR1B/oQHAvtlITgflC9K0TlKN9unWHVHqtJ+/tAF7LsVMS+wBLP+FIxpioIo1GYa+td6tR5uybAFJEKkutFlMogng14A7/6hkBKtrswpkfgsqBiefPhDFalnC8HJfgRr0VLNMCMgiugRhP1AnIieVBSmfXQgnT16q9TDA8wguGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621391; c=relaxed/simple;
	bh=pdAIHbraJ6EXqsCTIBZrLVFmmJxpWn07hoYTggw/weo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYt0kD2yItE3oIIjCya0pzItmpLup57oenFgftk9jfj/0HqILlguyOXpBksDdbt2sQ+txoZhXvBMZKoaZJG1xax9j7aOGQ1moGEHCNFLFVBk7mkpRonSWMzrMaNIQ+CyxUsWyDnhSLHQNK6PPhZkJzebeRof1vp3xq2wIXf4jPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vg+aMhXn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dhs8PtIKVyLpnG+sIknN9hEKQIAwVqFWAmbUQabCFPU=; b=vg+aMhXnyxddHec3x2uvmI2pLZ
	xktxpKsqXODKIwOofPcSCAuDP+45xAnGvrJAtzFOzLJJCdNS62Oof4N1aaYw9HAWTXXDJAQIsixxy
	gHGqErkZVGkyj8U5gNVpnoIVS9FK0k3YoEhbXgtwGDPRAQr9tLTur+9cHwai41T6J775qIP0l7xCc
	PCU9zhmXlM0qjvu/SZ8MVAcqmZC8BjnNQwvvTCeXla+t71n1qv8uUVnCpu5to+lM1bdq9ibbxR60a
	tGKP1sEgIvZwhpTjae9+A4kyBoZCG2qzzeZ9yQum3lzjtbLej0NhAgXlV005TzsKynJJrzRZQZJVB
	UWrCn2gw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyUF-00000006ElW-0NA4;
	Thu, 20 Nov 2025 06:49:47 +0000
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
	linux-nfs@vger.kernel.org
Subject: [PATCH 05/16] btrfs: fix the comment on btrfs_update_time
Date: Thu, 20 Nov 2025 07:47:26 +0100
Message-ID: <20251120064859.2911749-6-hch@lst.de>
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

Since commit e41f941a2311 ("Btrfs: move over to use ->update_time") this
is not a copy of the high-level file_update_time helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6282911e536f..05f6d272c5d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6291,8 +6291,8 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
 }
 
 /*
- * This is a copy of file_update_time.  We need this so we can return error on
- * ENOSPC for updating the inode in the case of file write and mmap writes.
+ * We need our own ->update_time so that we can return error on ENOSPC for
+ * updating the inode in the case of file write and mmap writes.
  */
 static int btrfs_update_time(struct inode *inode, int flags)
 {
-- 
2.47.3


