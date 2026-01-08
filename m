Return-Path: <io-uring+bounces-11501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB6CD017DA
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3D09F3026A44
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E973346AD5;
	Thu,  8 Jan 2026 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="aNKdbbg8"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E434252D;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=KoVFUwY67UXJw3ZRuD3jgV2XeZ/KJnWfKUaZ2YvkZcui3EIe3QudmhSKStP4wFsQp1QiKkgg6vWkTMqC9xfFseTkItoHvijp0uxdjZokcCF7b3luTs/Ba2Rf0Whwb2s5uv3svIqAORmGSh0TC++eUD4OfLlmJ/pakvhqZMwgoeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=RZMRszjUY/fIM2JLm9jks2g6cg0EVOixOwmn11+9ZsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQkC6bLUY3iR6K6aNDV8x/VXErswGzRHCdT4VA2FmZaGDxiiCz3wzP1TTZRh2NwU1mB6ge1IEWS5EEtEf3wgux9f+GPBu+krivdkJc62ySfAivAyOh/FI43PqHKilYLu5sr2qbY7UOKLXrnaryP/IxqklK3wzxmo3jVKtuhzLBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=aNKdbbg8; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2HkCXtuYG81yDH2ptlOKycPDQQLzNXbW/SGw7cqaL7M=; b=aNKdbbg8F69mg+KVqWmYxsUMii
	OGUdUuFdxW+gfU9rBY40iGTrbghF66bOZnpU57JHPYE3+NsODfVEWCDJbYvEWznEyNVhMghAeLnXb
	lltqo9DcbD00xcQf6vC/7h+2RmTqmLMkaJtO+AQNx0W6nUsfxDVn9wwBHk0m7b3LzLuS4ozEgEt0n
	5Dk8sYO/UDe5A4ZJAv4Ys92N/SqANBXb7SyU77RpzsMsKlsaSrN32ZnSM3Esnj3+p6+WxCf196hDm
	RSQ5tV3t0E9czwAVYL2kbda2E1aVtAjLmZHANVX6L0Gu+Cvd7VXl03qGltUxNbr+h5gDy47egWmUf
	3lofgYsA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb1-00000001mwQ-2RQS;
	Thu, 08 Jan 2026 07:38:15 +0000
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
Subject: [PATCH v4 57/59] alpha: switch osf_mount() to strndup_user()
Date: Thu,  8 Jan 2026 07:38:01 +0000
Message-ID: <20260108073803.425343-58-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
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


