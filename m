Return-Path: <io-uring+bounces-11690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C4CD1C69E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2D0130C4C50
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C32331A78;
	Wed, 14 Jan 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RJlzETtR"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C40A326D68;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365121; cv=none; b=UR8oN9UllbnL4WgWnaNVkAjavzzlGphqTorA9zD0pG44+hN98SBrgWLkNiDfVP7Tt2UHeatqJtM+NU+w8q+IHmXT9RI8FHriFiG7YZrNhk2u3DZ7XEqmTUR8cQRHN6YU3rTieHXXrEkZBea+TisOPK+hWaRfzKXRC8TYlnbOej4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365121; c=relaxed/simple;
	bh=JqqD6xeqUDj3nRwRtlOX37SQyfwoFYklo2JzhGSCFzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gv2etsrZKpmg+EOEoakEnlrmv+NCSEZmmlesqYCko7l7k1cM7HvQf6JlZrZ9ZVdhq+zFfeI0Nza5T+lnb4L+WAvGml651KqAtbgN5yy/7bI2yKL5Ab5vmhUJpqQMrEkWFjycaqJGwdT7MJhVc6C5xcp6wqfxvQ3kpcbj/rcexRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RJlzETtR; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KvYo9U9Xs4PTrMtECgI7ahcosY5DMnE4tqcTdGN6Z+w=; b=RJlzETtRM78ojvFTsE7/gP3g2w
	RUdV9z2sOCznXNdKqEebQwW0/oBa1szAe9Aj12Wt8RhU5kojl1cwuOuqcDQAKak40HdXwkIGO3xNO
	r2Ug1R6+NthI/atMpn5sEq7OL326qilpf2MHrQRAof7aIybr+BTemuFmkkKGJTcshOuBf2jXmFx/N
	fc6e5pw1fn3L+t2Uusz9wP0m1t1PEYrGgAB97uxK4de/vzPUfViP++kwzkQ3LBnvCH84Jc4NpVg6n
	rR4vWNOhbbjRV0FxHj6QomWeGwJ0uerodAIu7W4mOgJxwXPuVyHBO+FOdKjNslHJD8SzabFggkPKU
	ZmTFAbYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZO-0000000GJ0F-1x7s;
	Wed, 14 Jan 2026 04:33:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 65/68] mqueue: switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:33:07 +0000
Message-ID: <20260114043310.3885463-66-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
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


