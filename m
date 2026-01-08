Return-Path: <io-uring+bounces-11500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 225FCD017D1
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 190443024E79
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA8A346ACC;
	Thu,  8 Jan 2026 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="k4DADIi4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B2B341ACC;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857823; cv=none; b=cnKSFO0KAasNQExRQxO4dAs0TumbWsnqaEe6IvVGbuIOeTaih2TvZDi7Wh62kCnWPFZQmjPeMYH9+Bun1uc9ycUeJz2WyVZ3aZ65O4nQ76c8smTefDN55NMhkGdjbWp6WHiJYYK3PiPu85N8xBMXqO8Oibfkw8MlKsGmehhI61w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857823; c=relaxed/simple;
	bh=JqqD6xeqUDj3nRwRtlOX37SQyfwoFYklo2JzhGSCFzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7GG4Sm4ZZ39b+phezRyBnfk3PC3sIg1xPNl66UoNXVmjClSFtl8zJm+STctuyQ+V7UpVP9HiW5K0qQuxYcJ+ct7+p+XeH7Pq+tMQwaAO1Quuwj7aDya4+qOxuaa0o9b+KBLhgT3aV9u1EpBvpBk6sktk+ggI/5dR6tvevsjjF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=k4DADIi4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KvYo9U9Xs4PTrMtECgI7ahcosY5DMnE4tqcTdGN6Z+w=; b=k4DADIi46xpKURBHPT2LJp4QHL
	rV6AmOPsF0HHFLl3vWai/pFieZK9J0To3rELN1dtnZcjxkdWmuTEaVC6n5CcWKIWjAWfGjZZrDpN6
	XbaeoHM28BeTmsj/RuIhC5HTi65bRR9Ht4OcNqjXkkWLQIQcfvbwCS+d5uCc9auKjZqWuGNcgbYod
	GSJ4E/ytpG/CtdwOENF4L+1XMnpumFFgsDABXlHG7hFXPd/CVMTpF93owaxRefUTWLqbLzQKrAHkU
	vC/QT9RUT9BTmzRpXH+rv6BfBxZfufpBhekGjxOnqVvz0r2WZ7bWsjvS4qQISDJCAVMzEODs9LLKN
	1zHr0ouQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb1-00000001mvl-0Ei0;
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
Subject: [PATCH v4 55/59] mqueue: switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:59 +0000
Message-ID: <20260108073803.425343-56-viro@zeniv.linux.org.uk>
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
 ipc/mqueue.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c4f6d65596cf..53a58f9ba01f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -912,13 +912,12 @@ static struct file *mqueue_file_open(struct filename *name,
 static int do_mq_open(const char __user *u_name, int oflag, umode_t mode,
 		      struct mq_attr *attr)
 {
-	struct filename *name __free(putname) = NULL;;
 	struct vfsmount *mnt = current->nsproxy->ipc_ns->mq_mnt;
 	int fd, ro;
 
 	audit_mq_open(oflag, mode, attr);
 
-	name = getname(u_name);
+	CLASS(filename, name)(u_name);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -942,20 +941,19 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 {
 	int err;
-	struct filename *name;
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
 	struct vfsmount *mnt = ipc_ns->mq_mnt;
+	CLASS(filename, name)(u_name);
 
-	name = getname(u_name);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
 	audit_inode_parent_hidden(name, mnt->mnt_root);
 	err = mnt_want_write(mnt);
 	if (err)
-		goto out_name;
+		return err;
 	dentry = start_removing_noperm(mnt->mnt_root, &QSTR(name->name));
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -971,9 +969,6 @@ SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 
 out_drop_write:
 	mnt_drop_write(mnt);
-out_name:
-	putname(name);
-
 	return err;
 }
 
-- 
2.47.3


