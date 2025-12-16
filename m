Return-Path: <io-uring+bounces-11096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3D8CC0C9C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3D14305D986
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEA2326D65;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="VBTEZYo1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED73128AD;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=NcbqCD/OHqZ72Hzll5CXdHKmh4B4RKisag474y99nwufipX8hWU7SWlb+4GYYe1B/kl42pEiIzGFH2DksHG4o0D5KUAPYNtrWF+10bAMHDovnd8MT1fF8WLQ6nxbSgPB6CLXlAdjD03cjRe1/14H17iSNATKq2JSicagy0A3l7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=Ln2QhD1+LiE6hrU8DCpZyq1Aafnjm0E3+Q2zcNTr2ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8I7YBwCNTet2Eeg90w/FDqBeVOOfTcYGUCLbzhhT7DOMcpbxhiRKx+NZrz9ndnjqd+XBGAW52Fnaiq5/Hn8r+dVj8shUZPghuLFLVqqSNIeqAqXYK/zINwIR6oNtH384JhOi2TXAJPlPZsyXe0ewqW4n/XuzNCtrOK9FQuVeCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=VBTEZYo1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3DYt1b8jTHOd45/ui01BMEhPrHOrIWRFTqLRN9vGwUo=; b=VBTEZYo1NH+mUmxfk5oRfZxlnm
	gaeS3e2pqv6gMSQ+7eJuDRPklCcMlD/nXx4HEdv679P6lnTzXqk5tIblypDV0ypV5t6dCfQeVYVZt
	QNy3UCtipYJXx6FRT2ocL1gUhJJc5K4YlotahegkXvUXr+cvHvv/tZX++TE0tkWdRG+0PVpFyDtI9
	Z/IgqooeK2jJvC0ArUoGjyQcYng4U26sWlRT53IThYCt3bmDGtNISYLGhu/0n0Um8pYUalKO2dWu+
	68IaBORL+F/cOqvKyf0NUSiRmtpAx+hIGXAnZQS8lcDyLiLAGundEqVv2ZzqIL7TaZgKr4c5cq5Ba
	zou+mlng==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwM2-3FOl;
	Tue, 16 Dec 2025 03:55:22 +0000
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
Subject: [RFC PATCH v3 40/59] do_utimes_path(): switch to CLASS(filename_uflags)
Date: Tue, 16 Dec 2025 03:54:59 +0000
Message-ID: <20251216035518.4037331-41-viro@zeniv.linux.org.uk>
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


