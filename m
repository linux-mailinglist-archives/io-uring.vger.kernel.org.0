Return-Path: <io-uring+bounces-11490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B29ADD018A3
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 035DC3063132
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388DB3446BD;
	Thu,  8 Jan 2026 07:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="GeVwNCtI"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395F933CEA8;
	Thu,  8 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857821; cv=none; b=DF5z+gQngMShxfDoYaXOXwnMlZfQO/PQRWzTfwmJeAh6id2emylybL+10WxUrr0EneF7YjGNbbs5evKIMRKkQ7HDEmrFlTITU7gLw7bgQaxoLmjEjyjLROgwYqbW6+5P4qUtNSkl7f6sryBe1rIJQrnYYCjdpXBdAaR5+5jgVhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857821; c=relaxed/simple;
	bh=Ln2QhD1+LiE6hrU8DCpZyq1Aafnjm0E3+Q2zcNTr2ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqvpccXuNQS12hYxM6/eULnk0oWSgkap+gQ3R54O6kScnASMS7U1Icm/EdcG/sjXmqmEpXqy96PSTR1v8QUHqANgIu7SsYMbVKk3RzpdEydAUXCCVTKss/MF9q5rYw+qrXzzh2TnFC9uLkwtBgZ5WD0jyHU9UIf8d/xMqnbxzfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=GeVwNCtI; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3DYt1b8jTHOd45/ui01BMEhPrHOrIWRFTqLRN9vGwUo=; b=GeVwNCtIbwv0nS5oGVA1ZMZPxd
	0vc0PvJAPQa9GaMcwIcxpr72VdfABOqWaPqdxvJwiEB38LTbJ1Oic2eTrhuWOERidEZUD0MM9KdZU
	QfSEJhcH55/cYC7vnAXlzSrUTOMC9e56ueb+vVGYGC9+RS1V+em0t8u2e3cCx0jVj0UG19vfyZsg4
	xH4ZHcn1s1wd5l3RlHgUDwoDH216xJJdvepRX6cHPv2D6EvfqhpZFgYWXNG2n9mBY3i7cTa0Be5IZ
	zbaFB4to7xF2Y0gYCmMmTAQaIoC/8KVs1Lp+OMYczSKfZWqfYzzGrLz3McjI8ERDX+C/PpOytOpjU
	PEq3DQGg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkax-00000001mr4-3OHW;
	Thu, 08 Jan 2026 07:38:11 +0000
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
Subject: [PATCH v4 41/59] do_utimes_path(): switch to CLASS(filename_uflags)
Date: Thu,  8 Jan 2026 07:37:45 +0000
Message-ID: <20260108073803.425343-42-viro@zeniv.linux.org.uk>
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


