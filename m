Return-Path: <io-uring+bounces-11648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C67D1C58D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DB0E73013D72
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4763A328B52;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="cTfabC0o"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55792E2665;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=coPmPknj638gBZwKFvGmCFh3NnfXs93EiIr+5VgCaXCFIM6ieBvQ0+UuHNoCvFwVJsfy7aRlin+FH08katLbRgf5OF4PxvqCms+lhJKsikCTpb2/KuEtFioS+oSdbJF+rA8Se8hst53LqxyNci8q4n07CjvIrlIgONsOOE9PYN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=4oxuQFLk8YkIq/5mYSLl2XCxIvuC91NG8EaCN9dotBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdubSljC/TgkqZG5RbcOMLvGowq1fvRZUDYgaN9sraWvXeLS5SlHzaYbhBTtP+A8OYhRzv+eXuI9Jdd4uD/zu+Ql7Xv5UUFY3FSV+EcuBCALSomS8s+K6Y+oe6UhIsdI3EaYheWQQoi8tVcg/2zQtfgo/drCg0kIoGQxkQmC9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=cTfabC0o; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=12NAM8k9D9tYz7pZJw55n8bdiFp2kiCbLsvUoQCJquE=; b=cTfabC0oPIYKNK9UbJ4KjLGnOW
	TDqhu1f3WssBucHdUG+waFV2yZEUmsVEC/HmNwUQyqGEeVqzbblWmNyFPbh2NOEADQRHqIe1L46jD
	T6OcFfN+MvzOK+uFP0cEqMi5TickAh5fBFNGfnhK4FIwwradyYHIbcA5Vqu7EQGUECa4gEBPjyfJ8
	SPs0sK1yY8LyvmPonjdv2tqBOfCG154szM4ESHX83x3SKi0Frbdz52txwyPtJ3jptD6gOqsRklUEq
	pZ4Sp2vc2Ktz9906tmLe+uWyIFv6QiudkDmuMVDdIny5rdMvKekHC15KhT8xq7eqmIMtvAEZCyXv7
	6cNXT34w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInI-2w8E;
	Wed, 14 Jan 2026 04:33:11 +0000
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
Subject: [PATCH v5 10/68] chdir(2): import pathname only once
Date: Wed, 14 Jan 2026 04:32:12 +0000
Message-ID: <20260114043310.3885463-11-viro@zeniv.linux.org.uk>
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

Convert the user_path_at() call inside a retry loop into getname_flags() +
filename_lookup() + putname() and leave only filename_lookup() inside
the loop.

In this case we never pass LOOKUP_EMPTY, so getname_flags() is equivalent
to plain getname().

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index a2d775bec8c1..67c114bdeac5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -555,8 +555,9 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -573,6 +574,7 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


