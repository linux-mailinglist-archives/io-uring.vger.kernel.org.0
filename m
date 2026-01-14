Return-Path: <io-uring+bounces-11643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 983BBD1C5DB
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D5705306E2EA
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5592A328255;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NMYZ5IQX"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932F82D24BF;
	Wed, 14 Jan 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365114; cv=none; b=FPat7tHT1+W50BGxrHS+/mSkPyR3iDCbO5xmiK8cUukPU3hiqGSyWw3rz75d/Mi+NIYjmt71QxyG6xmvWshBqepaPbfCO8wLD+5Xom63jcfK4ztV2od3guSa6B597g8Vn56y54i3gKFjtkYFBY2m5KB0WtI5Q7sWhZKXKgAe3vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365114; c=relaxed/simple;
	bh=HNPcrjOGPdK+rUjKiP0RktSumxuu6OLS32qJgPhWCP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhgMLcUjACr8ULhtaK67I9+ciDZ6CiNrlG+FkmlhCXVETsXRa1cRk9aaBZEMnqIz1jAl/WzW/xLxgOV+Psfd0UUq6uSJsf9Qp5cfBk9wzSAXzLsZ9h0D7GwN5mz+q3sHm0gtw3v8y8BgCKHZvIrX+R7bTZ8L+oLXETtsediaHtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NMYZ5IQX; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Inog8S2asLcYt8rxshEj7Ck1jbPHw2VzSX4bDPUW0B0=; b=NMYZ5IQXEUUWx/K/EqR0NHO6rL
	+doBs0KA6SqrxGzmASQJfkrM7QJ8afyzibwapUJMeK4xdUqx7H5Z31KG3GA20B5TEN3SSZCOdqtf+
	bvzl0SDqlLFKoVtH5MyGpyNgL/9Sg0W9qXlEO9WuCQFZYMseOZThpbRsiromy7QnuYLGbUGqNI65c
	0tP3qjiGoVUK3RP1q3uF1uNtkN052MYkAeUCQo6Ha3A37UfYJgMgEiPc3sS7oyT41DpZQaP6qieGa
	MXtHj+8Atop1NFt40IFCg1IiEFHDb1CmHklaAZ/R5bSN9LzKZA/5cTB0qvwhGROOvcPp0+zTcQkrg
	+mXRmQ4A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GInK-3HTJ;
	Wed, 14 Jan 2026 04:33:11 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/68] chroot(2): import pathname only once
Date: Wed, 14 Jan 2026 04:32:13 +0000
Message-ID: <20260114043310.3885463-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
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
index 67c114bdeac5..6f48fa9c756a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -600,8 +600,9 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+	struct filename *name = getname(filename);
 retry:
-	error = user_path_at(AT_FDCWD, filename, lookup_flags, &path);
+	error = filename_lookup(AT_FDCWD, name, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
 
@@ -625,6 +626,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto retry;
 	}
 out:
+	putname(name);
 	return error;
 }
 
-- 
2.47.3


