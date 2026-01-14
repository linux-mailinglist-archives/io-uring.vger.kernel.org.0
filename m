Return-Path: <io-uring+bounces-11638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA43D1C5AB
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15F4C305BD45
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE59F314B95;
	Wed, 14 Jan 2026 04:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="L9KdhzPw"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A502284B37;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=g/g/nRnMsHghXovC7sIN/AfDREWJ6wUZWWSRjMCasjUnNJhvnbyg0Jj4i7++HGadf48o9pgH5W/8JOWCvLfqOtoPsGoGGQq2S/AyI08MN1FdoDWUO71TJiocrhLg7tHUB/ke116bpHMCVjdW6H088j9tvcHtCeL7bXjO51E9wZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=VJR7OANqAnNeKsJcpMXd5sA1W1qzF/DrbRQlYMiYeY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3uZKexXqPyhKLvxBlvajczaI6cz5FpKvq6rUSSAwu3Huxv05beus6D+jyNt3e9wg/Ycl3M/qzS10OCL5ZbkZZmuULdduF3wom5exoReNn6HG6yKavsPJlF9GsWSfBjqbMYgIi/6NKNjFrZSBF6kEkDNpVOVYDUS7UHbPCTN+zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=L9KdhzPw; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nND/UTx2fHPWcfLy6K3U1k4zO8irk7L/OKSvicadqNs=; b=L9KdhzPwdOvy348vcbjIOFwFij
	5i2CPasJfG2+kI2wUp06VvjvqO1xE9aGpc9NeAugJp+PmiLzOEbQztw6oNIsSw4FUePQh5DKGtEnQ
	XiePniwC7k2K+qwTNEDizE8femZhIBGmINO1tEhrksY6I4fco7P14WrKq2LCkXCCX+hFuO6AarY+S
	emkJ1/QdBlQv+91fDkzUr19O7KGPtH4akWWLXwueBEGCkgRZ2GHdImeGk/gQAFAdx7HfF621Dxi11
	T3yoAjwstMbwAUOa+UsPSSMWzghzSsgt9aa5nCub0t9cgr9q7DdwetHY4K0dlmcyVtXuFAlLMN0m9
	fX3/9riQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInE-2882;
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
Subject: [PATCH v5 08/68] do_fchownat(): import pathname only once
Date: Wed, 14 Jan 2026 04:32:10 +0000
Message-ID: <20260114043310.3885463-9-viro@zeniv.linux.org.uk>
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

Since we have the default logics for use of LOOKUP_EMPTY (passed iff
AT_EMPTY_PATH is present in flags), just use getname_uflags() and
don't bother with setting LOOKUP_EMPTY in lookup_flags - getname_uflags()
will pass the right thing to getname_flags() and filename_lookup()
doesn't care about LOOKUP_EMPTY at all.

The things could be further simplified by use of cleanup.h stuff, but
let's not clutter the patch with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 82bfa06dbfa5..a2d775bec8c1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -801,17 +801,17 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		int flag)
 {
 	struct path path;
-	int error = -EINVAL;
+	int error;
 	int lookup_flags;
+	struct filename *name;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
-		goto out;
+		return -EINVAL;
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	if (flag & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
+	name = getname_uflags(filename, flag);
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 	error = mnt_want_write(path.mnt);
@@ -826,6 +826,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


