Return-Path: <io-uring+bounces-11454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 886CED016A2
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E9E103007505
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444DD33B962;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="oV6MBTgi"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C97F30AD15;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=rahsxF4sQQJ7n9wXsvBMe1m9Zy3P0BXPTFhoV+9WDCvawIp07Ehr0j56jhOsX05GbObnzQH/Jdz9D7Eyy2DFbxggARZHpo7FH3JDfH9V8ZRgonnuB+2KM6o0+D+ptD+WoaX2d7tCroc/EGO3Izwp0ZkiMgq50kZqegBYN261Mj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=4oxuQFLk8YkIq/5mYSLl2XCxIvuC91NG8EaCN9dotBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSvFY6aPq5XMNw+KKGYXQ+9Wibx/y1g2X/isBfzhfqKbCfzWgfA1WJxzNEl1pyZWwXmi0bigY7GVvzGLdVsyZyoER+Cb9CWjoH8ClYkTCS9onPlg8fUP4lBjmCAppAsn3KPS7psWjI2mp+1NfeR5t5H/hXcLRPUcWcg83zUUy1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=oV6MBTgi; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=12NAM8k9D9tYz7pZJw55n8bdiFp2kiCbLsvUoQCJquE=; b=oV6MBTgi4wQfX66d7QfiUJeoy+
	dD1jr+JyR++m1somxxmFwHKAHWuEzckiluOByD8KgCeV6iEdrZzJg4/20ZXr3JdMAJMU8zu02xKh9
	QnY1FUSt8YGh/eJo9De8UU8PCxQQY2DZBOAeXAAJF0QS4V2yATReCtCdg3fJ9RJNGbTlO+EiP6c5r
	DbZq97JM0xkxwfL18z2P8IEi2sP40/qBXQAiFOPbisNTXdna5wd8q6MeCBOpoPLl9p9J0HB1MzzEe
	OnBLZp5f1U1Ux1l4B+p8oj3UndmdLfID3PTzTr/OnfAQz581v6n3qCyOBu/a8+SefyeS8y7Jy+qYe
	rvqyu/rA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mfB-16vu;
	Thu, 08 Jan 2026 07:38:04 +0000
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
Subject: [PATCH v4 05/59] chdir(2): import pathname only once
Date: Thu,  8 Jan 2026 07:37:09 +0000
Message-ID: <20260108073803.425343-6-viro@zeniv.linux.org.uk>
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


