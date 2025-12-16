Return-Path: <io-uring+bounces-11092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E672CC0CA2
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B8493063F7F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D627326948;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MPl+U43w"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBED312826;
	Tue, 16 Dec 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=Fd/MTWGmgeVkjlJUDe7B8LxfLUSJ95UCt76XDY2R8AAksBB/c8RZ7OVvMRRCH7LDQPyhwzLwX4VRLqo5r+XVuAUseSOUt4jqx02cW5Yofo0tQrpoAUOhYfR++cF8XOFGRVN1nqCw2ejocQqskAeI4Fd0EyzHFkFqglUze/+Vdh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=Kv/ka8ztlHo4QWU+GzA5OuAWaTlbQ5jTKrvVj9cUrkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDG/DH+BSGJq6PSgYki2CtbnQaLHbtkqiA7uEH6fuvbYGfx7zFcV7o34QzUe0Qt6iujT8IWrWUHdQOMUq0V4uR0eHgHBO1vICuzRIFsa89s+P0RQ1EVfAnVwo+Li7NPtm3yVL0IW10C/Ry8JxiTh7eFX8k1L2hZr9kcthKWW2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MPl+U43w; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cPLZK8daWl7rtOGf8eSVSW0i863W5e2w+3ptgBoMjus=; b=MPl+U43wMStTUme9+KV/nOav49
	Ud+ungrcc8GCKx2ezu0pa7T/o+jkw8oVn7c1Kr7fkgDggf5mnA6fwISPWuygWwLdEHQNllQvaz+NK
	Bz0yDRj/cdd68a3Riiy3b956hMNqrdk353+Jphdv5dlCNR1J8dIgvmGxv5Y1RXP7AuDsw5j6sqROB
	3WVQvJVqr2avEL6qT+Yh+5Dmn6YdGFqpb7xkCimR/02QYMjrhJx8CwNKSv6xz/NQ8kjlEDOCQODZr
	VTqV9CZUhggz5sNQrc8QcBLrqW8YEjSo0rKSjxzgC/KcjYsJuHEWJAiNhxtpE2mtP0VM0Osp1yhFe
	ccFu+w8Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwJx-244n;
	Tue, 16 Dec 2025 03:55:20 +0000
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
Subject: [RFC PATCH v3 20/59] file_getattr(): filename_lookup() accepts ERR_PTR() as filename
Date: Tue, 16 Dec 2025 03:54:39 +0000
Message-ID: <20251216035518.4037331-21-viro@zeniv.linux.org.uk>
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

no need to check it in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 4c4916632f11..f9e4d4014afc 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -394,9 +394,6 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		return -EINVAL;
 
 	name = getname_maybe_null(filename, at_flags);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


