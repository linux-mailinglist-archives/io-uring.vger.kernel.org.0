Return-Path: <io-uring+bounces-10621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD5BC5B85E
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A01CD3BDBC3
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9E12F3638;
	Fri, 14 Nov 2025 06:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b13clXY2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2962EBB84;
	Fri, 14 Nov 2025 06:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101652; cv=none; b=FIbIuzkU7u2BcBn5ifYviGFaxCTnQ/LqtzPfgjB65DAb0ID/kQY3qEaoH3zxIH9JZhLWIvE9qMaQC8oph5MvpSVdyyKLLJlzM4erJzUT2t4nq2OLnnpI8VPGSZO2BGBKuOg4x6FTsUfOfrqqFp+hFGDpZRxN7OAt4PF/o/EAy6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101652; c=relaxed/simple;
	bh=6nEwg8Z5l1fbgqP7GAYosCx0xm1Mz+AmsycAo85y2ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA2JLNp/COZ4MuYHG35UEmCmAjLKEW+MsMvoe4MqQ5J8Z3SdQaQRXdmxXpc2eCYPySzPuBMurFTHItE/Sc4Oze1FKH5UTdrhOuEYpDKXZCepC3qfKsUrLqZyeUoD0fYT6CbhlNAKeYdnms5Uk9GdCrSPRQP9wkM+QeBhoikhzQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b13clXY2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sBRYd22KyqqgGRX9JwZohrgWZQLEKkxiYwVpg23RsGc=; b=b13clXY29CWLRde0AXGHcD9b4r
	qatr09GJEFSPhsi//4u/g/UlB6eK617z/wA/suH7X0m6W5Q2c7ICjp5bjHpuR/8nE2UTZ4tX3Ks6l
	eiGNb5Brh8NcIXpc/dFO4xzfJlw9ysrruCBA0A7gMfm7xWqMsCx8l7uK3jYgzsrrByXgCFOuoxH1s
	A3IYi8pj/QA0RdUgMl0LKG0oWjWrCDBv7kW9Nvf53Sxi4B1whj5nHBdErszEUpDOLQXEf6ilskwh8
	eJWLprbQFsaeBQOLkebyzjmMZ5dfuGLr9X0Ui9UzRHf78izO4r2SKdS1JCiK1b3obTZbzlXBykrjF
	9AsMYspQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHM-0000000BedG-3phs;
	Fri, 14 Nov 2025 06:27:29 +0000
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
Subject: [PATCH 06/14] organgefs: use inode_update_timestamps directly
Date: Fri, 14 Nov 2025 07:26:09 +0100
Message-ID: <20251114062642.1524837-7-hch@lst.de>
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

Orangefs has no i_version handling and __orangefs_setattr already
explicitly marks the inode dirty.  So instead of the using
the flags return value from generic_update_time, just call the
lower level inode_update_timestamps helper directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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


