Return-Path: <io-uring+bounces-11067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCBF7CC0C31
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C6D15302834E
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FEF3191D3;
	Tue, 16 Dec 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RBYsS4H1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE2312800;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857293; cv=none; b=CQwCt8EboDlRl0BjpOs45C3zWUpEsAbWVyHwiGWnShzw2Om/g4YZKWZDk+ysftsRyp+aasR1CxRLUgDd3yCFa1AEBqUEo2i4Iun/ZB+N+2D292fAZBj4U/+OSuyL4rARO4LpCRjvn8WHZ29Sjt2YLgqdLASUvi5bMJ7yw2wvvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857293; c=relaxed/simple;
	bh=RZMRszjUY/fIM2JLm9jks2g6cg0EVOixOwmn11+9ZsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skZ8MWwa4Q0doBbDhFIttjetIUErSEgkK+uBCBBVtd2sNaRUXhQhCkISlUKGIg3EaHIstkBnBUcmoqtkdgtqWL9+oRJGbwC2xU0mew81PS424nM3fIKwe1BbBNBKoR5w64geUPbhQcUbqKbyNcqmf/hEJr/u15A1FuenmB0WDXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RBYsS4H1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2HkCXtuYG81yDH2ptlOKycPDQQLzNXbW/SGw7cqaL7M=; b=RBYsS4H11aDEviOHeGZjIRWra6
	2WxaO9gH1DJ6RX8zcVoH4gdJw7bnVKg5D4gddF5fCkno9/HYPFoBkkxy/0WsyItzIEpjLHGen+fMa
	GHTtYogR1om174Ma5pqEOZaQSHe4UUOuoqKLI0FjtRg/EbOj/m2YOgWN6pyunbeNdiJzHgX9ADNWD
	TMz/I3zF4nOyl41z5fHotclLYcodbYCjkx5HncfcktQLKZD5hfPK02teCms5md5n/rQFNB5zkNlPy
	t64AiGnynf1j1575i1y9e3UChmsAHspuxTeZq1bOR391Kqlj2IqpTlYJ13iWgFIMZRjgPGN6WIOa6
	BmIXVlRQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwOP-302h;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 58/59] alpha: switch osf_mount() to strndup_user()
Date: Tue, 16 Dec 2025 03:55:17 +0000
Message-ID: <20251216035518.4037331-59-viro@zeniv.linux.org.uk>
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

... same as native mount(2) is doing for devname argument.  While we
are at it, fix misspelling ufs_args as cdfs_args in osf_ufs_mount() -
layouts are identical, so it doesn't change anything, but the current
variant is confusing for no reason.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/osf_sys.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index a08e8edef1a4..7b6543d2cca3 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -454,42 +454,30 @@ static int
 osf_ufs_mount(const char __user *dirname,
 	      struct ufs_args __user *args, int flags)
 {
-	int retval;
-	struct cdfs_args tmp;
-	struct filename *devname;
+	struct ufs_args tmp;
+	char *devname __free(kfree) = NULL;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "ext2", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+	return do_mount(devname, dirname, "ext2", flags, NULL);
 }
 
 static int
 osf_cdfs_mount(const char __user *dirname,
 	       struct cdfs_args __user *args, int flags)
 {
-	int retval;
 	struct cdfs_args tmp;
-	struct filename *devname;
+	char *devname __free(kfree) = NULL;
 
-	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		goto out;
-	devname = getname(tmp.devname);
-	retval = PTR_ERR(devname);
+		return -EFAULT;
+	devname = strndup_user(tmp.devname, PATH_MAX);
 	if (IS_ERR(devname))
-		goto out;
-	retval = do_mount(devname->name, dirname, "iso9660", flags, NULL);
-	putname(devname);
- out:
-	return retval;
+		return PTR_ERR(devname);
+	return do_mount(devname, dirname, "iso9660", flags, NULL);
 }
 
 static int
-- 
2.47.3


