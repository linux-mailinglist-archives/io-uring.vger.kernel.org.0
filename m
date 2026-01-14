Return-Path: <io-uring+bounces-11672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD848D1C66B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73E7D30AE635
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5F933065D;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="uVSNCTrL"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD032FE067;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=YLAug3yCAW9lE5Ww4YlQuClsTr8kSelNtFsD5mw1qcMbIlbGw37YGknzA9icm3HHo7o5BeB2xGflv6u7f+v9R6apTumAGdgFpO3rKFko6FDe/DCnZoLTPTsKrVEGtbj+NwppVMmWJbF3SLX+fTG/zm4rTi0SRuxyJX4goDlrHaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=C+2EcojQwnwv5U/vpMob42+W8dy1bNTjOKNG9HnaK5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgRF70Oeid/YcnVcWcTx3LrmhdU6XMC1ck8/lSNw7s4YeuOcVKFbAEvQZGUPvRvM/IjG71sdoPi2VGpyA47LTfoSbyPrrX6JZwKqR98IEAz87/m8o7+mzwNC3LjxBXHglKE3FXPt2lEpQqlVHDxgpstnyqNJUXbYWH/wm+TC7GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=uVSNCTrL; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nX+MJLbNwZ93pbRcj4nhRonYJnvqZZukCpm52ExmhG4=; b=uVSNCTrLFhaYfQ5HVR+PX8GEos
	EufNCYDJdW2zSJHh8oRY9X9mCTms2wsAoozYdaWiHHKMwfiIsb2YPSJ+vlMaLYcxzIVAZW4H+wEAB
	uij1Sv7LjblS6eE982z20RdYSoghQv+deMQDBonkX2Utzu0BVzAHR2qRT9K4D0ntpKpAVTlsySVM5
	cjjWoDn1BbHvKKxIo0GRy2D3Zd6iAX0x4TkzqfQu9ntjKIbUU8MS8rGWlLZDCXFJ/SMvfHeXWxSYt
	MebWUKx5C4MXetUABrVPWc9tfrOOezaS+dfmkUpKkGCycoz9m1djOe2ItFWXBSUvVigcxGTyG9kJL
	FRb5EJMA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GIo4-3nc0;
	Wed, 14 Jan 2026 04:33:13 +0000
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
Subject: [PATCH v5 27/68] move_mount(): filename_lookup() accepts ERR_PTR() as filename
Date: Wed, 14 Jan 2026 04:32:29 +0000
Message-ID: <20260114043310.3885463-28-viro@zeniv.linux.org.uk>
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

no need to check it in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c58674a20cad..9d0d8ed16264 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4427,9 +4427,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	to_name = getname_maybe_null(to_pathname, uflags);
-	if (IS_ERR(to_name))
-		return PTR_ERR(to_name);
-
 	if (!to_name && to_dfd >= 0) {
 		CLASS(fd_raw, f_to)(to_dfd);
 		if (fd_empty(f_to))
@@ -4453,9 +4450,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	from_name = getname_maybe_null(from_pathname, uflags);
-	if (IS_ERR(from_name))
-		return PTR_ERR(from_name);
-
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
-- 
2.47.3


