Return-Path: <io-uring+bounces-11076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A20CC0C72
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2BAF930335A2
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC2531A547;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ClIMu526"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE03126AF;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=ffQ+LO5jyZWaj5J2SWIMuE/8p+v8uPVgWoJ5SzgXJQc6jg3hzQPWDf1XpTqqGMrUcRVp9GIP9yZrEvEqWHFyXMRpcfsmHExHHzLH/eLFQ4N5bML1K9gLHbSmrAq0azubNWqYEud129mjkfxAqpr2TrahRspJ7j2dD770NHg1+r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=JqqD6xeqUDj3nRwRtlOX37SQyfwoFYklo2JzhGSCFzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4HtL0+xSQ5t9hM7hc9dlKieprnoCpp2RdMir5nAas8C6HWzkb0+fts3ln9YfX9ZnZAtAyeowNz1g9repiUsfk/5QCSF8J4pK65kFwtjp/yLcHpuF4XHslGR5nRjzfdqgTNXOvnL82Lp9tZ+4lihOXCabQg94bkhw1b8wutP43k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ClIMu526; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KvYo9U9Xs4PTrMtECgI7ahcosY5DMnE4tqcTdGN6Z+w=; b=ClIMu526cgeJ2lo2thXM1gLmhF
	0BgTHgDSvpndVxX/TrP+rQtSIVbv23Vxw3uFLh8xqw71l+ZDqwkbPL5GDxKm8+Mk0Yb0xyD7ksl4v
	m0aNnslX6dGtWzWj9AeKdPj+mBJDH4urD7ksufRwW3wcwVEKzWKETFNE24zOgz55toDmpQmiqHl1Z
	9+2P/1yitl1K1olAPk37vs6djPBo5yHDXSDxwy+utj5h3J2dK91HLT7wwwgYumhK8g9sM1eDHbTRJ
	ebBNNl1O4yaSNCvgowHi5BDa0vlC1oKSkAB57PNnhz/ixWLOZdbxky1gRQ20JOHT501luTEZxmgA+
	71t4XHog==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwOG-2akA;
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
Subject: [RFC PATCH v3 56/59] mqueue: switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:55:15 +0000
Message-ID: <20251216035518.4037331-57-viro@zeniv.linux.org.uk>
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


