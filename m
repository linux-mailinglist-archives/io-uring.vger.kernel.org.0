Return-Path: <io-uring+bounces-11450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C9ED016C9
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F1698303BA9E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A5A3321C7;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NikCwtMM"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D230103F;
	Thu,  8 Jan 2026 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857812; cv=none; b=Q7yus1o3tuYFTTnT0o7LwZuGMliNXqUK2uuu8G2TwHEcyFxgtvkWfbJdW7GjrjqtUy6yF9+wsjZOm2g5dnKFTt37NrWzuhj3SRgtB//bZAT8iK67S6zVuiNVoz8P6Mc6bhQqO5lFJvKraJNeSAqo8hU2RlDUhiN3l9b6EhSf1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857812; c=relaxed/simple;
	bh=HNPcrjOGPdK+rUjKiP0RktSumxuu6OLS32qJgPhWCP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bei2bchIkos06kKgkO4ubc4fiHM762J981qZ/rOL2C89in2kiwvhdIMR55OjBovB1Fa+W0Pyfn/tWlnSw81TpzV6co0RHTCHwcc7gLG/ZHjUSVY/5NUyO4I1btpOC0cTdg/QT+JZ5R2Y7NqI+EAJS9oWRFgV9LxJqklo5DeQocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NikCwtMM; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Inog8S2asLcYt8rxshEj7Ck1jbPHw2VzSX4bDPUW0B0=; b=NikCwtMM4rVzePgqTV6Yt32t0+
	wM7ANV0KnBg7f2v49t0nWM8poqHMCK652fQ9hfbs1QTVo11XZ3MWpA64XLqXnfRTUZ2hbKOze+ZbZ
	jaQcKa22dkCIcn0qcM/9nc6ymVuf2Ev5zd97u2F8vdjNv2/2HVTqRDSZtG3SWoz5O/pCa/o07Xyc/
	p1WqCRfmh/8YrXJAWmM26WlqMMoUGoAnf0kZ4Yb0iODh5DFpnNFf7V2KnyKERa/HN5h0OSUxyYxIv
	hmhpfwvkMS67RIjoqYUNHHWr1HpbdRNXmvCZqQBBo9lnUf4T9HO0KpLtJQpYphHk9TR8zNBRV22Zr
	gBIiHUDg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaq-00000001mfM-1ubp;
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
Subject: [PATCH v4 06/59] chroot(2): import pathname only once
Date: Thu,  8 Jan 2026 07:37:10 +0000
Message-ID: <20260108073803.425343-7-viro@zeniv.linux.org.uk>
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


