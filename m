Return-Path: <io-uring+bounces-11503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB2FD018AF
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07C4030EC231
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79834346E64;
	Thu,  8 Jan 2026 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vJHMTA3x"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D8342160;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857824; cv=none; b=iateVH/2DLUoX+fcEeEWouH2DGrtWf6PN/SYnS+AzwkzEQND/dB1OBNXb1TZB5BKuC1IsCz8B3L96/rwyYJnEQEDwcTpopNnpQ7ScAmVHg9XInthjZaALVEkElgu5FeEX40eyX9Fcnud/D8+mOJ/pPVoJsFsFdZRdSjGz6Pwylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857824; c=relaxed/simple;
	bh=ed4inkFbKg5gXwGxXVyNFfqCJTe0MbLbW/j1/GoDH1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6x/R/yjUFSGSh8B+HcOgiihFtBGZ1ubDrpua5ikbQqyb+48w8wTNgz8IVL7yzk1/TdMFml65viZciYNFbu31X1SNeWOJIbUB+djbDwzB7h5XsTVpLxuIVoOViTeQYYFR1Y4A2rEK4BuRky0Xb51rQOWIppYA1VAsu+etmRstj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vJHMTA3x; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sz/9K14xSZCaQltDnYlKvdLrLATpRcUYc8VoMWgUXMw=; b=vJHMTA3xnsNuazDLc/DOHAAF3j
	Ta+HXaPsDQ/4x+U/mxZZa5YnCv5+4I1kvMHHZaYXGqHGL/1J5NOFNwg/858K2Dz6Vt0Yp1eV+KAuk
	GXNuIyi/7RLioMk82m90OG3DI2MM2EnKqhL5vw0P+BGd6lxWhmFrEFHOigGhicdG3gpDw4Z4lKL0r
	QReD531Otx/gEbfEPX/evjOSkTiVmEnRJFgpo+LumXsdmz9BWPoCliBTr4RMOpSTISkhkXntsisZ6
	hl/kqJ+l8jGMi9dZG7n08058HMWG9YYSIumMbiIFBik5zffIJELl7y75nQXqyBFJA3sA7Ww4B9Gxj
	MsmwKAuw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb1-00000001mwp-3Ehr;
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
Subject: [PATCH v4 58/59] sysfs(2): fs_index() argument is _not_ a pathname
Date: Thu,  8 Jan 2026 07:38:02 +0000
Message-ID: <20260108073803.425343-59-viro@zeniv.linux.org.uk>
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

... it's a filesystem type name.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/filesystems.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 95e5256821a5..0c7d2b7ac26c 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -132,24 +132,21 @@ EXPORT_SYMBOL(unregister_filesystem);
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
-	struct filename *name;
+	char *name __free(kfree) = strndup_user(__name, PATH_MAX);
 	int err, index;
 
-	name = getname(__name);
-	err = PTR_ERR(name);
 	if (IS_ERR(name))
-		return err;
+		return PTR_ERR(name);
 
 	err = -EINVAL;
 	read_lock(&file_systems_lock);
 	for (tmp=file_systems, index=0 ; tmp ; tmp=tmp->next, index++) {
-		if (strcmp(tmp->name, name->name) == 0) {
+		if (strcmp(tmp->name, name) == 0) {
 			err = index;
 			break;
 		}
 	}
 	read_unlock(&file_systems_lock);
-	putname(name);
 	return err;
 }
 
-- 
2.47.3


