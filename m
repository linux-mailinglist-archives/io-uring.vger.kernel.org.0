Return-Path: <io-uring+bounces-11651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9D7D1C5E8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86CA430751E8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7163032863B;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lM65CE7c"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37D22EA490;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365115; cv=none; b=FI4GH5+dA8fi9odl+SnjuhTwfX0SswbIowqQ9t6cDmjNtraLg6nkm6tFqWhpOBLJsYOUkWPwdcLuq0q1dzA+p0CaDsRkrM3CwhIW6A9mHq/uohJatiJ+DjCAsHJrmPbX2XjVgvJIHELM0Ani48nYnEanbMu4jy1Mw/J2EoE6OOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365115; c=relaxed/simple;
	bh=EuUwCQQ5BF9lk60Yi0hd6+MTf7hdbXocTKlNTfLdwWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUhBvwfYIttKrjtt2sNEtJs2Z5FohY/8hARNpIq+lnEy8hOYgp+/26u+/ApKSKJZIN/ceXwWOaUKOKJjSGOu1yex+HEHyleQiduYTJCP7F77iPyDPOODtZrrTrZbZA7riR+m1LzsyIkefBN8EaIAipAOpu+RjR9sOYwRgP7piCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lM65CE7c; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=21dhXbiMOp9FXvz5XDlj+D8KY3Sau8lovkfbiyjSc/I=; b=lM65CE7c/0Yc120Y2qzv4n4M+O
	ZCLL1wvEwDFCOmRyeYM2tBbqoNxbIobi+dFeHxjGzw0/y5ol17zLEr1K0QL0nGk/g8lMcy9Bm4acb
	7YE5wQCsQm+yIlB1Ucc4p1b6Iks1VcnjFrAF3vlRGRpvxzxIlTpZx0SQGtqJ+QACi/RcFJj5KTWBz
	DtiAn2/vik20KtuYQsw9OYFEOTSO6dyaYaeIXHMAyPbAw03SlLGfcASRd4+9hRBuyGS1Adu6rwu4l
	e0uBGBkqCt1SSHYz9Co0jo211nSnfhTmZjvc+ShWZweV/GikBgjEGVpGab+skKuKGWJddcYSsRnYG
	fo7cWYtw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZJ-0000000GItl-2VPy;
	Wed, 14 Jan 2026 04:33:18 +0000
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
Subject: [PATCH v5 47/68] do_open_execat(): don't care about LOOKUP_EMPTY
Date: Wed, 14 Jan 2026 04:32:49 +0000
Message-ID: <20260114043310.3885463-48-viro@zeniv.linux.org.uk>
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

do_file_open() doesn't.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5dd8ff61f27a..a4f29d2c2d3a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -777,8 +777,6 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 		return ERR_PTR(-EINVAL);
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
 
 	file = do_file_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
-- 
2.47.3


