Return-Path: <io-uring+bounces-11481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24487D017E0
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5F4C13009258
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEEF34252A;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="e6WIVynK"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E70333AD93;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=QbPGjvSxMc0qLgzO1kwBDd0wTBI59X5ZpDZgyJgPjm4pZSzDkyBkUwF8TuwV15AJ9MYiLK8x9Z5Pp0UV9w8ZmC7xSB7irURkdI+mF3VUbOzgMRrRt6XxvfURuV0XQ6tyNOAdllmAzLXBQ5r6oPOhC2Fzh16+LeUV0bLkcwJTqBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=ltTrYl7GN0DzsMvuK83DN/Ol0bNTuyKzVNTK64WoEE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=midgLE8KlvJWeAVtzQevMkpak7sC0SQGmGswmRbErzV+8eTn+PscYqU4jdIRBjdyeuiVfd2e9n0nvio1SXGsLyClqnz0CqdsNqOUyIoLylDA8o2TMOnaHfDIylMBmMS0luFoMuLcA6e9ctheLZ57ynZY/gCqOGG5C5K6wJrUTdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=e6WIVynK; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qwJAhJsvJ2SJYlVcArGg+7WWNzPWS5syBQcg8iMXPSQ=; b=e6WIVynKFxM+arGZ7DWjSFwayW
	M6bReEN0U4a6NoNvWwt0L9SmcilWWOKfaZjJfXSgOCmcWBxz3qKLAjQPiCTJOZvaVocYJtsQza9h6
	2b1+t4Jr6Vhcv7mf5ZKQ7iP6jnF5E0+MVC6djUWdVyMBM4TWYWrjVMbCSrKk6a8cVY/F4+Vg7bkVu
	f10jzwx3LInyv7WENeEGsPi3HBInvwsWAnRVFevQqOP4twYzD/VTg1632CCOEdwmp89766H/GtNe5
	c9SsokfingSlAMEMyvypoHiuqPbepGkqiy7wImtL1Hvr0tdM2q1t6LzHcZ0jqBxYHYDu1ztmBELEQ
	mPleW5FA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaw-00000001mog-0M7Z;
	Thu, 08 Jan 2026 07:38:10 +0000
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
Subject: [PATCH v4 34/59] mount_setattr(2): don't mess with LOOKUP_EMPTY
Date: Thu,  8 Jan 2026 07:37:38 +0000
Message-ID: <20260108073803.425343-35-viro@zeniv.linux.org.uk>
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

just use CLASS(filename_uflags) + filename_lookup()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9d0d8ed16264..d632180f9b1a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4978,8 +4978,6 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	kattr = (struct mount_kattr) {
 		.lookup_flags	= lookup_flags,
@@ -4992,7 +4990,8 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd, const char __user *, path,
 	if (err <= 0)
 		return err;
 
-	err = user_path_at(dfd, path, kattr.lookup_flags, &target);
+	CLASS(filename_uflags, name)(path, flags);
+	err = filename_lookup(dfd, name, kattr.lookup_flags, &target, NULL);
 	if (!err) {
 		err = do_mount_setattr(&target, &kattr);
 		path_put(&target);
-- 
2.47.3


