Return-Path: <io-uring+bounces-11065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAA4CC0C3C
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B22730275D9
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5A231814C;
	Tue, 16 Dec 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Lbnc+pq+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED15311C19;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=BiVFWRARlPrG1gukInQ25dBGUSVQxj8DjxZR3lEH9BoZmk2XYBnP7SaHBJ9n7bUfrmgZZXS0YXTf0gAQJVjOU7UWHc+67FyYRvarDee86Ef4hOCKmIw5oSjzVlwDYh19MfjcIcgIj4K6AVNI1E9LpukAjWzsVWd+UuLX2P+CVKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=4oxuQFLk8YkIq/5mYSLl2XCxIvuC91NG8EaCN9dotBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfoJN6vTQIeMlCS+EobK2y4VwkZ65o+tkOOpBeeA8/TQN4FwQ76szCzVnL7hcKq9elgmQOkR8gfowzAqdeGLWTNCjR0jK6f6etYJS+O/CUZn92LbPcHTiZCE5PgA4MpzzBP6YSuBwsbNSAbbveN2HHKegRoiCUhXL2TfhkDaxyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Lbnc+pq+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=12NAM8k9D9tYz7pZJw55n8bdiFp2kiCbLsvUoQCJquE=; b=Lbnc+pq+S9fGV0nw14zpAbhCTK
	nJfi9fUZDCgDpQOnqlB/PQ8yEW5pllRCfhEYjuASm0yQi97LiAa6V29Wl7uMtXqdzbIxHLiZsJEN4
	iBoN+6nZOlKKCB4lGbn28g/lhzJYrF2sfxdOPW9yBXxqzqeJ8h+mEmc+VjR4sN1gZgeSavPOTUfZz
	hjcmoGZvj1Vzw8BRqoSyRcY2crz2H4Y/V8iPcTMQGrY6QtP2gwNakTFcyy7Vrc+FvwPb2Y+pWz+ZF
	1sIDKJuBSRmTAquHsMFpkKD/goSqOMInM0y7fpslDvKmLsURvUGiAAsrm81e4VQt56nRfNf8xPD+E
	obkz9fsw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwIt-0cyA;
	Tue, 16 Dec 2025 03:55:19 +0000
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
Subject: [RFC PATCH v3 05/59] chdir(2): import pathname only once
Date: Tue, 16 Dec 2025 03:54:24 +0000
Message-ID: <20251216035518.4037331-6-viro@zeniv.linux.org.uk>
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


