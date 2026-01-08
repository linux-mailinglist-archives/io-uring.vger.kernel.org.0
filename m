Return-Path: <io-uring+bounces-11478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F86D0187F
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B423130ED609
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6901E34250D;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="EYx527EW"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161B33BBD4;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=SowtQfm+43WDfknPLboLG5n74l/IsUJMsDiTbnyAZr0ySNhlPz6/xA4wT4bVATCzLTps//VZVbnpV+dykYfw5PTo/fvViS2rJOy7E8tqUI60y9XFaOVPJ55FTmw7Qv5D13vQ7dFkneFWhtIn9p1Z2Nov15bN5zIlD+UVjM41X2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=urAa3ZS6X7nMsa9ZRz2Pqn/hpkIvLTL3N56s9umZyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJq6PGCRD5wJB9cuFaOSW2UatwXNE1WSVBvb5Fu9D3IyDHSMxdIXTF4fwvc4xH46gKxJjgazrg8YkiYoI8h5LCgS2PiY8SqIlF/IN4xXspfGMzxLzw4l991O+51hiHSM/Pl+sFsn54SFaC8CsOyuGls3LHOQVjJzYsx1RfZVp0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=EYx527EW; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5+CNfJBBa99USZB4Xzhgo+c1jKCiUr7CLOmJPPMy31A=; b=EYx527EWbEAbefEoNdISMxGVtB
	wi0OQbuGL7118gpfZPZNJ3mk7kmml02BmLsROpfqnn61uQNKAjf1p6JCAYh4W0YYh115NwJyvIziv
	noLJO+QRMOepgRbUoMjBqxsDu/Vx7+9DxpR9VeTvOg8TbE5UPGvaJWoo3bBJQa4ENbjj29qH80PqF
	tqm0iv0SfI9iFnc63B0ZeQ0HlrRAA3XTFzr9QhkO1NhbxcMLe9HIdZSD5uwdOlS6AlYE11jXJ5iG5
	CPM16ry6YI6iJMGgXmz385PV41nzwC6IHwos0EUFDvTqpTrhSLaIxWNGarssscuK6PnAa8OxFcblP
	scRsp0ZA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkax-00000001mqr-2QCD;
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
Subject: [PATCH v4 40/59] chdir(2): unspaghettify a bit...
Date: Thu,  8 Jan 2026 07:37:44 +0000
Message-ID: <20260108073803.425343-41-viro@zeniv.linux.org.uk>
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
 fs/open.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 425c09d83d7f..bcaaf884e436 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -558,26 +558,19 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
-	struct filename *name = getname(filename);
+	CLASS(filename, name)(filename);
 retry:
 	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
-	if (error)
-		goto out;
-
-	error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
-	if (error)
-		goto dput_and_out;
-
-	set_fs_pwd(current->fs, &path);
-
-dput_and_out:
-	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	if (!error) {
+		error = path_permission(&path, MAY_EXEC | MAY_CHDIR);
+		if (!error)
+			set_fs_pwd(current->fs, &path);
+		path_put(&path);
+		if (retry_estale(error, lookup_flags)) {
+			lookup_flags |= LOOKUP_REVAL;
+			goto retry;
+		}
 	}
-out:
-	putname(name);
 	return error;
 }
 
-- 
2.47.3


