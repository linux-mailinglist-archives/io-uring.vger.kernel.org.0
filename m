Return-Path: <io-uring+bounces-11679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D252D1C686
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5A1D130B589D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F57D32861E;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lLJYzHu4"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13F12E2DD2;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=DpSwwZdW522iPgQN3rwmMAWnkRf+tk9qUxysxNHlalb+2ZRUpX2Q2DydofqdgcnWAjHnbdXLxO7NzHuSfVVX50tu4zCYINnFo+tsLBOqmtlS6OCprVpEBqgVBvPfa2kBpQWfDOvxu9qKepj/oL8pAiy39SdfqVuOgGoXDoGPhcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=Ln2QhD1+LiE6hrU8DCpZyq1Aafnjm0E3+Q2zcNTr2ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLE5BONQ2DpLVJ+OjDm8NPWKV95dE/HT9lTlUGeRvWqWF4hFkfVfsxzBOYZzXtZB0HX/7Ti0fbMKVcl1iRIgSlrM5n7Pea7vNNo+d24GQMf8c28UtLovuJtaOOR0DQPFFDQnGjcB1QQry+wJG927v3KFDvKgnlkS6FaI5L1aMpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lLJYzHu4; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3DYt1b8jTHOd45/ui01BMEhPrHOrIWRFTqLRN9vGwUo=; b=lLJYzHu4dxQMl90dUuKtwEtrj2
	M9pobuv3AiJIy8Z8irYkAbd1gM51rip2wbbhpEORnPTPis4ODKYMR1trRzhOB6ygBWv7J6rGemLaF
	uBfQSxxnqwtRvdmjFCkcpiCt+pKtgm5L82Ss5i8d/zdOGjc7MveY1mnpya5+hsjrxZVxSoecX3ZLF
	cA3iUB+2mTTYBBvy5FZ7F+0MVaM99xC7D9kurSZw9Cy9CLwLUYowEQRERNBnxLPyYsvnPc8pdH7pH
	LXNjHFe73RbI5fK03IwZUUbktXNFYV9sTWGF9ftUs1iTZzUrtZBqcP+qSnJ40+2lvQaphu+ASNGJr
	oKJ1am4g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZL-0000000GIx4-2tf4;
	Wed, 14 Jan 2026 04:33:19 +0000
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
Subject: [PATCH v5 53/68] do_utimes_path(): switch to CLASS(filename_uflags)
Date: Wed, 14 Jan 2026 04:32:55 +0000
Message-ID: <20260114043310.3885463-54-viro@zeniv.linux.org.uk>
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
 fs/utimes.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index 84889ea1780e..e22664e4115f 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -84,27 +84,24 @@ static int do_utimes_path(int dfd, const char __user *filename,
 {
 	struct path path;
 	int lookup_flags = 0, error;
-	struct filename *name;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
 		return -EINVAL;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
-	name = getname_uflags(filename, flags);
 
+	CLASS(filename_uflags, name)(filename, flags);
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
-		goto out;
+		return error;
 	error = vfs_utimes(&path, times);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


