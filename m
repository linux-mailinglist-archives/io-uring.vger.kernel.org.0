Return-Path: <io-uring+bounces-11085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65464CC0CC0
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 260923070C3C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFEC31AF3E;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="uUDl1K9h"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05D1312829;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=MsxvGVrA6asHN4LJjgU1dxWerKKSF1R5rd2mWfRz0/0aydgnVBCFiplRUfiuKTqAeEIS7oN0OMCPnnUnXQtR5dm0A4PDfRFh0NbDh6vSfReUamtcIMi5cKOXr8xAWXDGkDUxInuTdjLDGTwTyBhJIhz5mmRvrkIJd111Go7GVwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=va0PaN4mBusaBKHrjOmL/1eI/ypIV3NEfozekyfEnDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hama1K05p7tDCxC5fKZbTz9ZGBwUaVtQgKxJXb8fjt/vBUwAj6NPmrSEzYDVQU6VXCqUG4HGmHCPC5qqqI01yy2Gfnz77SKgqXLb5UjVfUksqzSctOOfkd5UF2GFwFJV5DqeWr2bDOk5GQlfS3p/nXSI2oxr/VRlDGFtVHqOF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=uUDl1K9h; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/5nL/BGU6SfQpPxyPgJp6vCw4GwTODv96udxuJvjpUM=; b=uUDl1K9hWn/qUy0RQMCq7DCh9N
	LYP3DerorUie34HZlDd4ii63mQD3ro37TTaac6p2wcDAUgyJXMthKE03cGj5+alwFb/KkdASTf0TM
	NFN1cWsWQe42Qpt0N6vxplNjOBRl/aUEjh6Vx4thKFRQ2W7DTTPkQXbvaMVc2m5IiUm/J9WRV6A4X
	pktNaRC/kFuMaoYTq83sO/gITQe+4YGP3HtfwzGnwmNAXAlpEElN2E7E6fzeCqnmjd4FiROJ9UfUE
	TOohXASYwVp67gLVIabr1k0yEL6Q/p/S8hba9hgbWJjJEzWnuNdPOnB9+zPnAR5UDMWW4244ucMam
	8vsSoMWA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwKn-1cm4;
	Tue, 16 Dec 2025 03:55:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 27/59] do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:54:46 +0000
Message-ID: <20251216035518.4037331-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
References: <20251216035518.4037331-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

do_file_open() will do the right thing is given ERR_PTR() for name...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3d2e2a2554c5..ac8dedea8daf 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1425,18 +1425,12 @@ static int do_sys_openat2(int dfd, const char __user *filename,
 			  struct open_how *how)
 {
 	struct open_flags op;
-	struct filename *tmp __free(putname) = NULL;
-	int err;
-
-	err = build_open_flags(how, &op);
+	int err = build_open_flags(how, &op);
 	if (unlikely(err))
 		return err;
 
-	tmp = getname(filename);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
-	return FD_ADD(how->flags, do_file_open(dfd, tmp, &op));
+	CLASS(filename, name)(filename);
+	return FD_ADD(how->flags, do_file_open(dfd, name, &op));
 }
 
 int do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
-- 
2.47.3


