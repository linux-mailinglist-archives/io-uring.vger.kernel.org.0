Return-Path: <io-uring+bounces-11681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B605D1C67D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 21A9430B24C0
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B15A328634;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="BSwbAhqE"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA1C2FC893;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=BciTTVNnqevcedxZYrAgID6IgM8wnjJSb8dko6RntZx058ol/CTGNqmzjpLsLlKWDTEHgTiaI9r1OCVl9k47QH4tonnXXqD83eCARLcOMw3/LG3m2DX+nvKByARtnzqEM2sKz70wPBsOpjLqF8sxNHY2O9N9an191188ZGYw7DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=K8lF1SNuEKoMNQbK7dKMuZOgDMZYFst5w1ON9+Iq/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw6MINlnKGI9M73flByhA1cEqfX+sYqXdIwaT1aLqAiMHebWTRT7cVq+ekeuhgfBfs+K7N2WvkCADlXIEcbhE3QT5yNW6J02pHMhYXcu2E7EHhm4UEWqG61moMegU9dmsRagR5MVJw/jvmBlzVZP13il3FGJFMyWJWNCbFMas10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=BSwbAhqE; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6nZaYwIgSCv3EgxHBcGovvyRmlXqOp0P97wMYSPOq1M=; b=BSwbAhqE6ivAzYgcr9XHnXXgIl
	SNRlzYQWyfFTbMkANc/ukpUJOpo1WzcrK0LCJRrsdvnivyjj3nW2abIkknvLjns9vKxfQRjV8qj0Z
	WI7DiMEl30pI7d0hlMfQZMYZEauDGAuakuB73Q56MQ7OjrDhJ/JwjqJ9Jf/fxwzBzQmlPfKuXOwIx
	TFQ2EkIbP7vh2IQOCeT7i6FBZ+/ipJbJ79sK+pzS6nFXnn7peEBFxw0jORAZl3Xy+FkSvMIuuaueG
	/8e0lYouRbNdEdlCKxmdSRf7er2GoG7cXql8GjdzvJhrNjYHq7WuhHeWsrpoKGZ0aLzE8ZSc6o9Hl
	abEyGZ0Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GIo0-3R4T;
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
Subject: [PATCH v5 26/68] file_setattr(): filename_lookup() accepts ERR_PTR() as filename
Date: Wed, 14 Jan 2026 04:32:28 +0000
Message-ID: <20260114043310.3885463-27-viro@zeniv.linux.org.uk>
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


