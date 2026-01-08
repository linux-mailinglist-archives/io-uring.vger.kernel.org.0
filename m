Return-Path: <io-uring+bounces-11483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74914D01888
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 609FB30ED9B9
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68041343D6A;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="pjqJFXxr"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6D328B6A;
	Thu,  8 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857820; cv=none; b=pnkbDkJKUlUq7UuUUKMbRJKBrCE/Qk46QpxUmd/txsxgsZlsb4erq0KA31F9Qa8exZXwLcXtzl+hmpUUaq7UlWgV8QtbVV4EU/ZdSjEAsor/coXNBy+gS0LJqQb062/Zo9L0WdWRs41grdvNgq1e2ke9pC8tTafmyVc0NaxRdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857820; c=relaxed/simple;
	bh=Lw6fkolzG2z+rslNz1/IkWVTRMaQxHK9deworNvUlPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hua7ECkvvgnjraHx/wF4Eyu4MBX2JykyQ4DaQ+K/zok04ic+snD3EROZeE2iNYO7DFpAeFaedl+Zn/z0OoH0kwqEi6h2S3CiNayNDMYtEtzx1+fV+4Ipezyc90awwy3h0CcyW9/DWlrEmhXjikyNUuh7XLcCvc1b+ObZRlFaXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=pjqJFXxr; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XXA+defR+SzZCm3KczoEbpd9A4VhKcPk/m8STTG/ds8=; b=pjqJFXxr3U6maPKBqwZblsmDK2
	dCDVfMRVThN/71vCW7e28QX2GCoL2IpZYERerXnd8edSnDxXYJVw9XhHlUliAv7XQwCRhWThnFRLz
	L6Kq7vWgJVgDLX1UJWzudMXCL9JKHARzP7/v6tg65MuDe0bXGvv46WQW+bkhsc0GpO4qeUQ6AEp+7
	8UEQFOLrkZGK8b0ANSWQejIPyGOUs2pzG5b6GQKJj5J8LWL9Qx84shbTtLeq0VmLDz3hvqgF14p28
	9uqE7dL94oJJ/YxeTKBCM7zT80/gvPmKWUDOJ1LqXDp3In3GWcxhBZ6hiqRxNd7ibIEgg9DVmBd9G
	1b9NqXFQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkax-00000001mqG-0waR;
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
Subject: [PATCH v4 38/59] fspick(2): use CLASS(filename_flags)
Date: Thu,  8 Jan 2026 07:37:42 +0000
Message-ID: <20260108073803.425343-39-viro@zeniv.linux.org.uk>
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

That kills the last place where we mix LOOKUP_EMPTY with lookup
flags proper.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fsopen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fsopen.c b/fs/fsopen.c
index f645c99204eb..70f4ab183c9e 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -181,9 +181,9 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
 		lookup_flags &= ~LOOKUP_FOLLOW;
 	if (flags & FSPICK_NO_AUTOMOUNT)
 		lookup_flags &= ~LOOKUP_AUTOMOUNT;
-	if (flags & FSPICK_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-	ret = user_path_at(dfd, path, lookup_flags, &target);
+	CLASS(filename_flags, filename)(path,
+			 (flags & FSPICK_EMPTY_PATH) ? LOOKUP_EMPTY : 0);
+	ret = filename_lookup(dfd, filename, lookup_flags, &target, NULL);
 	if (ret < 0)
 		goto err;
 
-- 
2.47.3


