Return-Path: <io-uring+bounces-10684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AB97FC7269D
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:53:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 825B135581E
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E499E2F7ABE;
	Thu, 20 Nov 2025 06:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AlZCfFtu"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA642FF65B;
	Thu, 20 Nov 2025 06:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621421; cv=none; b=YRhdRINT6pyI3L+yg0dO09S455w89aLanXGUwoD/6wg7woZXOh8JsPKIqq3kAmylkrm+ic6Pqq4wZfFlZFMsEIRE0kc+JG2Sui+5A0Lxg+nqTBnOsGAOiofeP7me3Nnqr1PW7Coi2x5QHeU+KLBQ77rV0OiuxF9VC8ACrZKWMmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621421; c=relaxed/simple;
	bh=hJE1jEa7zDht9Oc9VO/FBLSlmRl63sOwADtAZPViZKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ff02ihDp1DdkFtH6zlPQYJpauiVmUEk8brqz3bLi9tcDWkUTpEQIU6TBqlq2WAb2PQn0anKSfVUsCpPvJZ8Zb2z1Wf5zRbXOQ+auHeRv185vK4aRGDCeo4/0fgpYac53cAdB+pqVdNAz/gTYF5uI+6zxOQdoZYqmFq5Y5M6u9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AlZCfFtu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tEeI0tc638dFSKAAj2z5BjrJifZxZGqVtriGgdsFiw8=; b=AlZCfFtu3Et9ZV+jSDNwl+SBi1
	cq5UuTR7/IDJRdItNSKVwwWlJtxRYH9jK9I2TU9KSlb7ckaRHTVmY7yH0BGxLS/MODGI2G5Aj4dS4
	BZ6xCkxXFDDaJeHSyWiMdOJabMctXq0tv2DxGLT5gcobWbkqv73VYsp/mlVehdnhj50IM2bN1zbNk
	YYK9SSZxN/9ax1ic95W+GHASCiTcO6Jlw3QdGAMsd/K1H4W1Md40wSfOUGuNNlxMjauy4+MPnYbb0
	fIiI8mML5+h5VprwOZVOMLUHCjlf9xN2mBa/9fLl8tv/ZxcJgAKCftxqpC/1+nUcDaVESjO5Tp5UG
	cohSVHcA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyUk-00000006F1Q-0Ta3;
	Thu, 20 Nov 2025 06:50:18 +0000
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
Subject: [PATCH 09/16] fs: exit early in generic_update_time when there is no work
Date: Thu, 20 Nov 2025 07:47:30 +0100
Message-ID: <20251120064859.2911749-10-hch@lst.de>
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

Exit early if not attributes are to be updated, to avoid a spurious call
to __mark_inode_dirty which can turn into a fairly expensive no-op due to
the extra checks and locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 15a8b2cf78ef..cda78f76e1dd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2110,6 +2110,9 @@ int generic_update_time(struct inode *inode, int flags)
 	int updated = inode_update_timestamps(inode, flags);
 	int dirty_flags = 0;
 
+	if (!updated)
+		return 0;
+
 	if (updated & (S_ATIME|S_MTIME|S_CTIME))
 		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
 	if (updated & S_VERSION)
-- 
2.47.3


