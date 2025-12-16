Return-Path: <io-uring+bounces-11066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA93CC0C4B
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 465F1302A976
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C403195E3;
	Tue, 16 Dec 2025 03:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Z7i2uaao"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534753112D0;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857293; cv=none; b=a+76I2TyIeVX2a827UQ7klrms0VqgRCBHi0CsuP2eHHaJo/yeEegIhJrDvCkdAlJTFLVcx2shUCMCBJBwDm7uo0b84XHXQeWKer/65af2Sa7aRXPCErCSuNioZgpkSbpMkqGns2rpge0WK6XAZzcBBHduNLcM6NRzKBRrbAJjSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857293; c=relaxed/simple;
	bh=HNPcrjOGPdK+rUjKiP0RktSumxuu6OLS32qJgPhWCP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHOEaGHCJIlGz6Q0wI4oap+cUVBctNKTVB6BnyDjCMVzFwbejUb4NXgk0LAogWk20SZhoiestwuCtGIyNy5H61HFP3hXSsyRL36tpo4RSljM2WNs02D8s3zXsc46DNORSGoxc1Z/VuzyH2dDB6B64wkODuLyPOm/5BEQn7Hq4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Z7i2uaao; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Inog8S2asLcYt8rxshEj7Ck1jbPHw2VzSX4bDPUW0B0=; b=Z7i2uaaoWgMeJXqqNZVpVdHmR+
	IFgoxFwnM04IqJ1V6l/5+FPlN1KfAhpWM42okwxlYcmoN6ILP38A1QC8kOWYAz7bR5TI5ME0aLe2a
	Ksq0zmto22pfU60GXrV/4qOubg2nfm1tLDiR+yfA0FK6+UU+AYqYhxt3x3eU9Lzf/W2LgGN9N8dxv
	PlzIhNq9c1LYUe+MMcPWH7gafiWlTEvINYu2kQ1xZ0XLE+pJqxr1Y6n3gxhLE6OE0IHDTkmkIaIvP
	VieW/AvQPKBZHpKCfi5yotV/4RQMG2mMKDwx7qq60GjR8GlhZSTwoDK5iQh8zbnEF7AhPU6Gv5Af2
	G/nK2Ouw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9f-0000000GwIz-0uFF;
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
Subject: [RFC PATCH v3 06/59] chroot(2): import pathname only once
Date: Tue, 16 Dec 2025 03:54:25 +0000
Message-ID: <20251216035518.4037331-7-viro@zeniv.linux.org.uk>
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


