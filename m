Return-Path: <io-uring+bounces-10617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A03FC5B837
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D72ED3BC292
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F762F12AB;
	Fri, 14 Nov 2025 06:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l1EMnPJH"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA68A2F3C35;
	Fri, 14 Nov 2025 06:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101624; cv=none; b=GbelwRwNn8xAFa/gAqHGvifs/+hSwZjKa1bJuu0sAmGhWOZGO0scAsBo+u84EYg6DS5VdpW6uDiDFFs1vDhnGxJu56KzdoDyM2aC3m+cT/K6nUeYNRJw3PoMwVISShE/DFqu2+M9GI9ba+1XPPxihbjbgO8V0yxeR+H8O1gjuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101624; c=relaxed/simple;
	bh=A6jrvLhVCuIDzcNq1IW4Aaxn4cS5WZ51zNEJDCVfwoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGuwCbXJpDJNhZ7hhBn8vVK+L9sUpd+O7c1LjIHTQ9BSY0uTnzq8EnjqSEhRt/qIavtIk6BDJEalriUtVr2xuQMvAkBmrz9qcAeG87kezBWfH9hSizAE0yov0qdO3Ii43ukqtgYH+vIUfWn6RQ6I5U0hj8HEFa2ytoC5YBSesmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l1EMnPJH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wV5iaBHtlaL8FryJcRGKwHN4hUselBaZYZFyzGT6rfg=; b=l1EMnPJHn9+MqgqdwDRfR9bTQV
	dMZ0tR2Wf6YSxTBuyEpSYXS4w/k+B8JuSg0TqtVcMwhqpEJx8S3oPVgpStk7fR31JYp0ReqHlEABf
	ONdT3LiFqJhoe6sospjZ4nkNlLV6WKOwVhmm7O6GFQoLKnVrxHdktNBoF2WNVwZfnqkxBMEIR8AJp
	oaSwVbYbU9r3KTGhli7uW4DOxL1+WCjdachArKEAGjE0EHbHJ1wG1Gtx1WECv0xeDDAZBGVXrBNT6
	PM9Qxd557xMkSBgQKQJ/uRFxjgKo3JaWe7g/IaGABNZmF2fceG5YtEQHprSGaoY+k8jJnsEIFxUiE
	0RMd7+/g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnGu-0000000BeR1-1lrp;
	Fri, 14 Nov 2025 06:27:01 +0000
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
Subject: [PATCH 02/14] fs: lift the FMODE_NOCMTIME check into file_update_time_flags
Date: Fri, 14 Nov 2025 07:26:05 +0100
Message-ID: <20251114062642.1524837-3-hch@lst.de>
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

FMODE_NOCMTIME used to be just a hack for the legacy XFS handle-based
"invisible I/O", but commit e5e9b24ab8fa ("nfsd: freeze c/mtime updates
with outstanding WRITE_ATTRS delegation") started using it from
generic callers.

I'm not sure other file systems are actually read for this in general,
so the above commit should get a closer look, but for it to make any
sense, file_update_time needs to respect the flag.

Lift the check from file_modified_flags to file_update_time so that
users of file_update_time inherit the behavior and so that all the
checks are done in one place.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4884ffa931e7..24dab63844db 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2320,6 +2320,8 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
+	if (unlikely(file->f_mode & FMODE_NOCMTIME))
+		return 0;
 
 	now = current_time(inode);
 
@@ -2391,8 +2393,6 @@ static int file_modified_flags(struct file *file, int flags)
 	ret = file_remove_privs_flags(file, flags);
 	if (ret)
 		return ret;
-	if (unlikely(file->f_mode & FMODE_NOCMTIME))
-		return 0;
 	return file_update_time_flags(file, flags);
 }
 
-- 
2.47.3


