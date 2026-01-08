Return-Path: <io-uring+bounces-11464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FCFD016FC
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49AF8306C9AD
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7799033D6CA;
	Thu,  8 Jan 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Obdi9DZJ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C6F32A3C8;
	Thu,  8 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857816; cv=none; b=Q4s66Nbpx3ySfwIS+xEcX+QaAEG/gX+m5hDCZUrAx+kKQzwjMXRMX6kYjj9plC98s55z+8FmdP1F08PFtR/4/p3DJmHuRv7av0ssKORa77ZLY2zx79wLs/0TLSkdDRHlvw8ATq9rr5d3XCnVrFJkUjR0wVfLeL1bvIcncnv4ZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857816; c=relaxed/simple;
	bh=K8lF1SNuEKoMNQbK7dKMuZOgDMZYFst5w1ON9+Iq/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ker3dgRdV1/wHhhneOhgJSGF+kSnFd54UcJnJE5zC0sVAbHMv5buv0vJtJ2lphXwRy4a3rFY7iUY+AQBqSrbJ4xfmi9tWzKlqKXz8f+5MbOzajTFvuDA4C5a9jRpjHQtva7Q8VxuLr9H1j1R6xSF6DBnn6WKeSSZsnghQVxEIvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Obdi9DZJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6nZaYwIgSCv3EgxHBcGovvyRmlXqOp0P97wMYSPOq1M=; b=Obdi9DZJQ1U5/FHhkSIk9T95b9
	S/JU54qUamee88XrJlo1EHyupiaVbiyS6VZ5Mqo58skYDNm9/vOLcRbGCZ6+WE1WuIpUmZcrL0+a/
	EU3uPexNrPuqKb0W4XntQRd3ZC5Trz46jq+HYaMJjEN4I3L1sB8V2xUeQ/1FJVZlOTnDTSkKeP0Ga
	kfwkmx9cohb0w2XG6sM1+abFYu9ss7DMSJSKos9YR/56xGO3jDxV5YQey3H3zLfvdJK7YryarBdLs
	+SFtT2N4Y5O21H/+D1NiopE7Nr6Dde5IWHpUL3fcL5hSWYQzccuD68aqorgbLpaFXLxnX83FglUIc
	8+kD1S1w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkat-00000001ml8-3d6f;
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
Subject: [PATCH v4 22/59] file_setattr(): filename_lookup() accepts ERR_PTR() as filename
Date: Thu,  8 Jan 2026 07:37:26 +0000
Message-ID: <20260108073803.425343-23-viro@zeniv.linux.org.uk>
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
index ddd4939af7b6..f44ce46e1411 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -459,9 +459,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		return error;
 
 	name = getname_maybe_null(filename, at_flags);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


