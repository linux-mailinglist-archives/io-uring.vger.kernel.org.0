Return-Path: <io-uring+bounces-11103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2304CCC0D20
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:01:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE95530997FD
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED66F32ABF1;
	Tue, 16 Dec 2025 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Kuh/2CfU"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6219C31354C;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857298; cv=none; b=c+nYaygGn22cQW8tsTR7ePEP81hGLUXPeAzOjcvRjmGNS0tO3UfZUvDkiJUjGKvnT19+l3QTVrC7OKjeyBEOf0OSfGNVl6dkzzKA0PR3IMfk07EgEoew3ugG90zGP2bGiRPo4qTu6sZBVz/RNmSirhjb9fK/RZrD0spWThaOhNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857298; c=relaxed/simple;
	bh=JGIE1Xn73bLwFlYFa1TfmbrgYmGn/Qjf/OmTPOTQAHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hurM+OzPG9tWjxZjBwRdvLg/aClIEn/aCXQStZvhefFBgo1ZhW8LBUohjF0Mhc9SHzIfMEC77CVZzMRoSOcuU8egq6OQhR8z2MsTIm2o6GQ09BXLfnPonjaTywotkBolxYUNaSSB9+qrdZv1Nae7PAAKfgwTh5V10kiNhtCgOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Kuh/2CfU; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w+ofnS0NH5sbZoyF6cXcsB14QEggir0J8dBphBaxor8=; b=Kuh/2CfUwoiUu284tGUZuBhPHY
	Ad/LVfw6vcK+z1M1Ng8iW4RPsgKhzLRWEJYZYu50Bk6dfrQxpG/FKINy+KlTES9yw5OdelpMagMK2
	RKXQyld8czi6+OwAAMFMBclxo6z6Mq19q5rWyQmjBspEb4u5qfCB8xRSJp845yVpc3ZOkN7yD06X4
	xY3oMYpvSEOI9C0GV3YTd2KVBMubd+e7hy+nCFFPA8DjtGiq7CXYu5vpFQEUu2BfWNs3xZzfIrj4H
	rnvTm9qr6JfWmwXAJslVZ39sz3oOUZzTzTgDVZsYcAmiqwSm9ZpyHIoft5Mg5uSxX1VjBgwwxinQT
	na75Aizw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9i-0000000GwLR-0FPd;
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
Subject: [RFC PATCH v3 35/59] vfs_open_tree(): use CLASS(filename_uflags)
Date: Tue, 16 Dec 2025 03:54:54 +0000
Message-ID: <20251216035518.4037331-36-viro@zeniv.linux.org.uk>
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
 fs/namespace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d632180f9b1a..888df8ee43bc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3082,13 +3082,12 @@ static struct file *vfs_open_tree(int dfd, const char __user *filename, unsigned
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
 
 	if (detached && !may_mount())
 		return ERR_PTR(-EPERM);
 
-	ret = user_path_at(dfd, filename, lookup_flags, &path);
+	CLASS(filename_uflags, name)(filename, flags);
+	ret = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (unlikely(ret))
 		return ERR_PTR(ret);
 
-- 
2.47.3


