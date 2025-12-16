Return-Path: <io-uring+bounces-11070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC46CC0C73
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 754183033C9C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12274319608;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="hKJ/Kt9g"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53574311592;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=nQ5+HfvqeWJwmMhywb6Hg2GwV7tnDRDmPahZFJECLbKVaH9RfnXLWgzjm+Sw8V+JccNZHixHF8Vlt9nEXlY0BKa4rkZAOyyhIKkMBoiyNR5E/X3p0cDd6NUvfEalZgdWFwuGTjY/R0dvxOCPZZiiSARlHJsfvx5z6GkwO/kj4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=l5FHgW47f+Yj1iy0m1MGYj33Um71tv4luVBFCT40jnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq7Ul0XUXfQBG33ljoJ6d3q7WpPyurXFSqLSuoyjelxLv6YZGvjDo7H7w7xx5PJ8Q0tavkrX3A7EoPybh2edffdVyU8ioEYPV647O+MREhtMS8mlsVO4tll9uw1V1JwTfNC7sJWwDsIL0nXK2qsfAPtz8or4WNfH7tOqUM1IIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=hKJ/Kt9g; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZTmwRYazdVffyBhN86itvLOlmBSFDHLQsgXip1U1wEw=; b=hKJ/Kt9gmJPoxmZGdQlBlB7d2j
	tywDv/KGXWzhDrSBDE+TNB0zEIUgBZVHSIDsGqr8TzY+wXflpXt/pIcMdA2D9Wfj3zKe8YwmrQ9mU
	UPtZ37v345lvdBQP56hAPxJEvIAcqdHMpPNZIN9UcDR/LNfV0IPYkmYutxn2d1nW7VtxOssqBVK6C
	d2Ud4tNhbbcYDNUhpRfAca39CQpkpN0hXxujCCNbULOOCNurSxCBxZaZRw5NaRSZpL6jHSD9k2LP8
	mFaSRY1ll23sNbAXFSbri9eqMwFh/qJMO2i1Pku7crqh3Rc3rP15mXaCNpfgjObqNCowq+tpEmzcl
	8k0kYtgg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9e-0000000GwIe-3CjU;
	Tue, 16 Dec 2025 03:55:18 +0000
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
Subject: [RFC PATCH v3 02/59] do_fchmodat(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:21 +0000
Message-ID: <20251216035518.4037331-3-viro@zeniv.linux.org.uk>
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
 fs/open.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f3bacc583ef0..82bfa06dbfa5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -679,6 +679,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		       unsigned int flags)
 {
 	struct path path;
+	struct filename *name;
 	int error;
 	unsigned int lookup_flags;
 
@@ -686,11 +687,9 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 		return -EINVAL;
 
 	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-
+	name = getname_uflags(filename, flags);
 retry:
-	error = user_path_at(dfd, filename, lookup_flags, &path);
+	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (!error) {
 		error = chmod_common(&path, mode);
 		path_put(&path);
@@ -699,6 +698,7 @@ static int do_fchmodat(int dfd, const char __user *filename, umode_t mode,
 			goto retry;
 		}
 	}
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


