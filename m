Return-Path: <io-uring+bounces-11062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9852ECC0C39
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5147B30239DD
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5534F315D2B;
	Tue, 16 Dec 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="be72XFVB"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB94311C15;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857292; cv=none; b=iuiaGFpDPiwKs0XJG2qq+Mvhst2csITyaoI+Jx7EQ4J0N8C0L7BtCT9th7dDE9ONsOH4iPSntPmBbAHiZFRFkpsj9vqCcv4oZBdRzyWvGwThQR20arrsqhlFuQQ5+78dazZno3f2eO0e2tKeWhiMKZuXK/gzifLCiP8TVXCK+8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857292; c=relaxed/simple;
	bh=ejixYtbS5/J13hPkZAA0xbfFwhUsT8keMfQ9xW+VTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=demtMCJ1BUEvNkgR5E+SkpXvohxW7xf7rDxTl3LpYreYECNkTRzVWE75eU+FILZKktcT7YwSVEpx3+XopxnvGqhj2MiahTmayMn/nSx10fHZs28wwhSkwRWphMaxEgA+HAMD1W9Jmz/7GKKzYQB6j4HIeTWqNnuSTWkaNgdRphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=be72XFVB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtcntkzvfcdf8HXOy2/XIfUxX4DMLOCsDkWNa4rKvpM=; b=be72XFVB7ZOfD0uyAW3SN0AJ3K
	6XOuPn5PSVCmrK/RQPq3AgmZolOzeiGdPslZt9es/OEC74utg2Xa5cV2xSSXmGN4X0R7xsOi6wj6u
	9elxarioWCQgoQbPlw6DJu5rtOtNX++UbWete+BufWyDcZ/QaOS2g8wj949zSRtlAK41rsxZvZC8U
	wCyfzJ9a4ssBmaTyq3iaswkAB8FRb0al1atA3VnOJVUS7jNmvIXSxW8emPJnGfkTLg0kTssrPh3E9
	rK8FRFzUgrl0cqxT+V2EK4VUxqBMp0VzukoE0ViUrBFqwWh2b7tsNlM4USXaekCbU2Kjlo3d4knno
	o+vAsqLg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwJB-27tn;
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
Subject: [RFC PATCH v3 09/59] do_readlinkat(): import pathname only once
Date: Tue, 16 Dec 2025 03:54:28 +0000
Message-ID: <20251216035518.4037331-10-viro@zeniv.linux.org.uk>
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


