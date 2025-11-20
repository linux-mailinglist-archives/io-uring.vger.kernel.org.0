Return-Path: <io-uring+bounces-10681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A56C726E5
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B19A64E62F4
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B936B2FF644;
	Thu, 20 Nov 2025 06:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UqgKRuqn"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEB2FF157;
	Thu, 20 Nov 2025 06:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621397; cv=none; b=TafBpHWKyKrSY/pThWUsTYdR77HkTJZIKjHDVcrk3HiAePjTvRy16LO3AV1we925CVTpxM8LNnwhGL7mfxbA0UtV6eiUI8Fb+yOwJIU4cTKCEx6CNkMNBMsXX7Acsry7uoDEs1p/cTPvLoHRhbdzuoTK0M8dHOR7SDA5AFQhfpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621397; c=relaxed/simple;
	bh=vfDW63Le8EcppS2pf37992vDczAnrpDgYfgIL7aJt+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFOmeZcqwN2bUuavqcP3DXcnE7SPfstAjv+DkJFIo1N2zhMzTNHqTn8bDIfG2FPr6tPhPw+n68KF58ClnbS+1FWoKWpSmRCgsMGiHc92IhpHa2u01hyS6twC0TiicegcgnKZFU28ExmMV/UKqq/Xo3w7+jdS0nShW63yCJ5oX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UqgKRuqn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UooVhPf/TfxnNfPFRJ+7a7AbrnSdXkJJ32he+L3voJI=; b=UqgKRuqnwpNI82qoQXPrh2iQDI
	YbPVzynT98V/o+tT2iWLQjULm8s6/5Xict0FD9zrUKZl+hv9l+K2vMyWNWXJ4KSUwsknpTGLFUcfU
	4ssfaSHIWXtjWZ76Mngp1bvzIFv1zjUhETdmecVJpyo/xJl8RN7t7pTew/7OzkgeRpICFEi3+JLrC
	6oG+mdTGVqkQza5gACHEgnRD58CBlRR6owIwuefj3GWs3+rbBpXLHXDztw33iiIT86SFcwuGiPs+6
	VAbv+mTBS6xS2FP4jmRTv+mqf3c4Krk+97yH0DGbLqlF+kuYJkIksuFmD+gS1v0+Co3uz2+B0hmso
	fJHINdfA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyUM-00000006EoQ-0JMD;
	Thu, 20 Nov 2025 06:49:54 +0000
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
Subject: [PATCH 06/16] orangefs: use inode_update_timestamps directly
Date: Thu, 20 Nov 2025 07:47:27 +0100
Message-ID: <20251120064859.2911749-7-hch@lst.de>
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

Orangefs has no i_version handling and __orangefs_setattr already
explicitly marks the inode dirty.  So instead of the using
the flags return value from generic_update_time, just call the
lower level inode_update_timestamps helper directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index a01400cd41fd..55f6c8026812 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -878,7 +878,9 @@ int orangefs_update_time(struct inode *inode, int flags)
 
 	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
 	    get_khandle_from_ino(inode));
-	flags = generic_update_time(inode, flags);
+
+	flags = inode_update_timestamps(inode, flags);
+
 	memset(&iattr, 0, sizeof iattr);
         if (flags & S_ATIME)
 		iattr.ia_valid |= ATTR_ATIME;
-- 
2.47.3


