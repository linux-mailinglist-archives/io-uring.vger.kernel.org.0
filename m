Return-Path: <io-uring+bounces-11460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BACA5D016EA
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72045305F396
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE0B33C518;
	Thu,  8 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RRIgk/ga"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F33329377;
	Thu,  8 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857815; cv=none; b=Vw4m8+KXRXABy2lhBsL8JaPxmnnjFVsW35y8iKzPSK6/QJG8oB4kuz/xqousgf+QgHXNz9jxsxfA8YjmF/4AiXr+3QIpsGBnJDx7TOWSFTQYH0YpZfTAucZt/41hpjyBlLGKh/a0tgVnKk8dm85l2KshFfhkmddKSRS5gixJF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857815; c=relaxed/simple;
	bh=Ht40MPYaxaAZbJgv0XEOHa5Itq6XzQoGLnJtmfQSU6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3ndx2GhvX8yHaldugN3jg43z69AfuEU34KNnsV1rvhJwMhFPlUCXp3+qpC5n3sRkGs3tAdwHTz1BPsZAuV6IQRksEZUNjjf+PLIfurm1+AKIGSYbR6lIJSwi4zcbrbF5gQUEd1nVL23FtwyTg1U5DRHMsrV5XYfDgKrQ00d3Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RRIgk/ga; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZDR9dpmV8LzFo0YU1af8ScCVNOIEjj2c+wxQMju+zIw=; b=RRIgk/gaBWheK51rZM0EICwpaV
	QJJTlo+rCNbX41biPaV/iE9fvyZVTyr2RjfBbwfFmv2LWTC//2Qf4yJKFfzAR0QSrCbriXk5zsvTP
	5yAYWImCkO4HKGGpdM/0blp59lvUpiYNUeyCjI/dP0IRQ9Y0aqmBdSyOIm/iE8gkPGZ9YWsHieXRq
	xCGyDnYS8pDCyuo8MJnsUU9RPaNGvvQ/8KPg16B843Ve9hU7CmkpJXNhPwMSdYg9lWSm++XWpAsE8
	kSqKGR1Rc0PdzqpZ+Pq6clplm97k/LUU2pxGsiEgizJZpKJmGbGbqQZDI6clOd/zhDEwcpETAQa4N
	6xdIJRmg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkat-00000001mkw-3L7J;
	Thu, 08 Jan 2026 07:38:07 +0000
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
Subject: [PATCH v4 21/59] file_getattr(): filename_lookup() accepts ERR_PTR() as filename
Date: Thu,  8 Jan 2026 07:37:25 +0000
Message-ID: <20260108073803.425343-22-viro@zeniv.linux.org.uk>
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

no need to check it in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 13cdb31a3e94..ddd4939af7b6 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -396,9 +396,6 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
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


