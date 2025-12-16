Return-Path: <io-uring+bounces-11104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B959CC0D23
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AF5A304844B
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B3F32ABFF;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="c///9+Jd"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EEE313263;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857297; cv=none; b=RD46AhGXnPs2ZwvM4qjtRp30tqrjXu0NFRpDKCGlM4j0avaFVGHAsKp6sOnTV9+1CFN2szYCAeJj92BmG4Xco3OlUEDfCzbXawxm3JHvVANzMrIq2GGts8i6W3Gw6/DUplMFwvZf0x8LZyBfI8gSvazhFbAEssWA1Ft/DMRWo0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857297; c=relaxed/simple;
	bh=ntStfDefI1LSk8YKGruB1ETOnK4upEIT64zjyBPt37E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c31eisq15SiBd/9WwJA9cox8WMJsQv/HMwyRaNdlqQrqB4uMqNTiabijSGug0MMPKCuIjGdeHD//oU5ObtduKsrHUeQ4t0/0u1yxKwgjaeXRXdQEYR8QoTEw5U4kGbYarn9JKNLpILXOrKRHulZRHYd3MHASfB99yKvaVSo/+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=c///9+Jd; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qCNNGL7/AcB8NbftVI2+HUXdppTuzbETXECNk4eIw2k=; b=c///9+JdCXo834Tw7RNBqex6ET
	swOd5Fkyfl659SyC7qwm5a8toFXpQs5TrKcEOB2nERKjNAGExYcGUOoDdbGg0yTwbC+8RBa6kYDyi
	TfNlIybGV88m41Tn5tGE+he5EkVzrLYFimuL3iT3pU2jpHyVgK5vaVHrVStSc4WFPWbBHlwQFriPi
	/dmK3iZQ8PPgxB46rQgzsRVjyrcW7oWD/ZhaudUIoFDdZ5JX+TpWeqyODDg//NOb3mP0N7UnDbwff
	FgXJTjEWFPwayuNx3ApIBYold6irt5gpHxAyHbBZY6iknDcJRdzAWVQUnx3xHvChdfbpnAqbFgs0L
	YsB7EI6g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwLZ-0ogv;
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
Subject: [RFC PATCH v3 36/59] name_to_handle_at(): use CLASS(filename_uflags)
Date: Tue, 16 Dec 2025 03:54:55 +0000
Message-ID: <20251216035518.4037331-37-viro@zeniv.linux.org.uk>
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
 fs/fhandle.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 3de1547ec9d4..e15bcf4b0b23 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -157,9 +157,8 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
 		fh_flags |= EXPORT_FH_CONNECTABLE;
 
 	lookup_flags = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
-	if (flag & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-	err = user_path_at(dfd, name, lookup_flags, &path);
+	CLASS(filename_uflags, filename)(name, flag);
+	err = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (!err) {
 		err = do_sys_name_to_handle(&path, handle, mnt_id,
 					    flag & AT_HANDLE_MNT_ID_UNIQUE,
-- 
2.47.3


