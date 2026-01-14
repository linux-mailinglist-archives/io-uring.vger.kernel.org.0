Return-Path: <io-uring+bounces-11656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF4BD1C584
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D5F3E3012A55
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0AD32AADA;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="HzgfdmGb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582A2D73AD;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365116; cv=none; b=mYgxx8Ltpt7rk0dmr6qZpcnGmEtCOCRH219T41Nk91haOb1DTQK6fywdZ45XZ4JvmcZAragV+Bg20Otx4JfEUzesIG0tebICp8e9ucjjzECtsVghITUKLhWGu8trZZfLWiILiJWblYsIZPfVZjwgjzw4uGNoICs7h5nk4e/K0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365116; c=relaxed/simple;
	bh=ejixYtbS5/J13hPkZAA0xbfFwhUsT8keMfQ9xW+VTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNI5ORIFvNHVBi9z7yU4lCba64c6g5yzWqAEcC+VKqbWaubjp15CZlkzjL/yoJH19MypKrdHmqbfkoT4BY3MQEg7MGr55LNWUjR/Y6FZOvdQFvS0YBXfrMc53Hh5zf1/gmdrISkZKYhrgxfJWbwTAIfsy/oPnufAWpUXsNSYaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=HzgfdmGb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtcntkzvfcdf8HXOy2/XIfUxX4DMLOCsDkWNa4rKvpM=; b=HzgfdmGb/uhuDBVCV97HcfpJLM
	zzjI0o1vwrwnV/vMWIWkFXK4yAPmYxJSyNQSHa4iOqoUlEU4PRbDnAmJOHoc2qbaGKDJ0rKyjCr5p
	DBdcRWcdNhwp3J+d/bUn6b4sAOp2BqIARuNSIfZ1x6Iu5RqsrRrIV++NUoimZP+/pofaitpp+/415
	ZJojbPR1KIW54guMeY5MmUGy3S7pTQbVyWjbUD8VCAa3CvT+Al+Faodj5SDiYh9TSXqnYlOxS1DdI
	dlFYsPh/N1JJ73VjULWMgXdAATK4JVe+xbVQsJr6eItkuXm/AYK4mwdst851ncq9L8qMncdajBg27
	mHSJmtSg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZE-0000000GInV-0cPl;
	Wed, 14 Jan 2026 04:33:12 +0000
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
Subject: [PATCH v5 14/68] do_readlinkat(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:16 +0000
Message-ID: <20260114043310.3885463-15-viro@zeniv.linux.org.uk>
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

Take getname_flags() and putname() outside of retry loop.

Since getname_flags() is the only thing that cares about LOOKUP_EMPTY,
don't bother with setting LOOKUP_EMPTY in lookup_flags - just pass it
to getname_flags() and be done with that.

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/stat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 6c79661e1b96..ee9ae2c3273a 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -566,13 +566,13 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 	struct path path;
 	struct filename *name;
 	int error;
-	unsigned int lookup_flags = LOOKUP_EMPTY;
+	unsigned int lookup_flags = 0;
 
 	if (bufsiz <= 0)
 		return -EINVAL;
 
+	name = getname_flags(pathname, LOOKUP_EMPTY);
 retry:
-	name = getname_flags(pathname, lookup_flags);
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (unlikely(error)) {
 		putname(name);
@@ -593,11 +593,11 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 		error = (name->name[0] == '\0') ? -ENOENT : -EINVAL;
 	}
 	path_put(&path);
-	putname(name);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


