Return-Path: <io-uring+bounces-11470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 76841D01700
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D80553075F41
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE1F33E352;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="nZBBL76G"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CD633344D;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857817; cv=none; b=dgO5WHBktTmACVSA8zNFAbFjrZVxhbxK41EO+IrQCHN9V5WvEzeqmnljl5XJfJDofN04ytSv4oXjAu0v3ejDCe/1fcNWmpyNM8b2z/Zc2TweBVttfWeo4BcdOvx/Izcxk9d8w3tDcxl7z4OCn5pgDtfINtXDOHabdFtY8lCVCIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857817; c=relaxed/simple;
	bh=dKazOTpP98uEsD5tvT0eCFSPEKi73Z7M/OFRDrSl8h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKJklt+oQ3Z8JR+PjNw5uRc+lg8T9CTwDoPlSRI+QtxOkRp565cH3pGTuMyFmncbF5vNJ1AE4V/K8wNv9J3czbJkkCM8MJmKiyFhkB+SMc27mgiPTjAEQsJ2hwiw39emlBR6EtUiz3NeLGnsQo2Hksi7F/51AKJKQVdxb9FIVuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=nZBBL76G; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/taDnA0SgX1kjdBTGSIJQ+UnMnEm3NgXYjqO+SzjTkM=; b=nZBBL76GtI0RLm/jynkgoqC/Zk
	5MB+ajm7/TggBFVP0/ZLYaF8uqNRj/iznhrQ4BOX6aGhz63VmHCn9J9JNO3R6ZE13SPd0vj2bBcsC
	2wrqHkPq3On1/Taz1tJ9/303VDhF0SylQDES+50ufTlYpYdisC+EXxI2xEFuzhLb/5cdBP+pa6Oc0
	QNO54TgUH0sZy3D6CWjWEqXbJ+bKbhb8cV0VmDTbSo++GXF6HmCUSBJpIt+AV7fKcr2ipMpGFutyt
	3175Uv6PyxaFplRui1Ccjq0H9nwOA5rUfuzAbbO+aGafHqg/+PI8uba9FFht9dIjN+u9z1mBGanlF
	1CVcWk/Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkav-00000001mnf-1eHi;
	Thu, 08 Jan 2026 07:38:09 +0000
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
Subject: [PATCH v4 30/59] simplify the callers of do_open_execat()
Date: Thu,  8 Jan 2026 07:37:34 +0000
Message-ID: <20260108073803.425343-31-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b7d8081d12ea..5b4110c7522e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -815,14 +815,8 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
  */
 struct file *open_exec(const char *name)
 {
-	struct filename *filename = getname_kernel(name);
-	struct file *f = ERR_CAST(filename);
-
-	if (!IS_ERR(filename)) {
-		f = do_open_execat(AT_FDCWD, filename, 0);
-		putname(filename);
-	}
-	return f;
+	CLASS(filename_kernel, filename)(name);
+	return do_open_execat(AT_FDCWD, filename, 0);
 }
 EXPORT_SYMBOL(open_exec);
 
-- 
2.47.3


