Return-Path: <io-uring+bounces-10845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBB5C94543
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CC093A54CE
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6027D3101A2;
	Sat, 29 Nov 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Gio+yLzZ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D0D21CC59;
	Sat, 29 Nov 2025 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764435701; cv=none; b=OstUXOsXJGj8hwiSLnP+X0pV1n9TbSOi7htrVeLMcplQAQEh7Xa3zNZnaKJ2hd/t5vyINmMboYIzww0j39mt9Hfq2JfrSoEquGH5YPOJ0o4QnFjkDSCkntT7Iu9p1wSb5TBcq93Yd+Tbawejs5j9cklMGzAqB+ZygGGK6c+DXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764435701; c=relaxed/simple;
	bh=ejixYtbS5/J13hPkZAA0xbfFwhUsT8keMfQ9xW+VTHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8gQcjWVSZsRxg1xRLquEBFU1WMVV/DAY5+Y0/LjtLdYQOTX4IRTD3IebwhNSUM0eKFQ1xkD+Zk1I/3LJW7uQT70NNrLnoZHH8U37gRcZExrnnzwx90SVJ41NzCEZ+qMvfYpz8iRenDUXRzdpCOWz9gqaUEUM8xRLG8UW2D0Coo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Gio+yLzZ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dtcntkzvfcdf8HXOy2/XIfUxX4DMLOCsDkWNa4rKvpM=; b=Gio+yLzZFHVe9brRzmM7OPJ/VO
	iJdn3iRudqYVaC4VyzYPvqy6XfMb/N3kQhnfde1mNtPPIrGnNGYy6Fmwl/X1W94zkCG9OfDvok9DB
	WCMp2ixrektSTpHAygKds3+6yDI2EZ4jwSKSQXY/hwqdPWO5dntOdhVBuifrCnnPhqUxogNAg0osb
	NVJYN8asMuRH/evGvvDclv8sJ/pMvseY6tq5XG4vAjNy4syUY28kAFxgm9CFJ3ICawdOCbZPajqGs
	CcSju5R2Ne/xcFlwZ6r6ZZ7WB89qX2l9LMJbd6+M0ajJ9ybebeTyQ5Ur+NKEqCr60WQnqIq/oJ9df
	7n1aX+eQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPOKN-00000000dCv-1wCw;
	Sat, 29 Nov 2025 17:01:43 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	mjguzik@gmail.com,
	paul@paul-moore.com,
	axboe@kernel.dk,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH v2 09/18] do_readlinkat(): import pathname only once
Date: Sat, 29 Nov 2025 17:01:33 +0000
Message-ID: <20251129170142.150639-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
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


