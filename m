Return-Path: <io-uring+bounces-11094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0373DCC0CB4
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96C91306C70F
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B43326D6F;
	Tue, 16 Dec 2025 03:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="LHOHzXvl"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54A3128A9;
	Tue, 16 Dec 2025 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857296; cv=none; b=Z+slaSouv1VpgLkmuGRpfEnj8xiiBFmPmgEEOvmhngYqQr3H/UZQ1r2E0hNhMtZkO01cHnsZC4gyGmlYJO4Lyy49KbEzdoBw5baoto3iG5/FW6xTbB03OkhzNt8y3OJJkgQwbcL8iKX09AIdd2aO1y6mRaIPwukQNIzLEbHY99U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857296; c=relaxed/simple;
	bh=qFWWBZSWrxy2KDGSAaHiqUKXKRDjGyqp+DsZAn7I6ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPDPaErojWVlgAVsiFlxa7ZhkTC82LVoZSuOELsJzFYH1hYIzB6oExByMG6XxEydQclRBawzvg7hIKskNQfZASX94Gy1qRrLlz9OIPZzIb2VHQtM/Q2+pOuEeHMBsfwP8ZRVJT9KyIOPtufAhNYiNY3CEpxlDHtAazCZh8taINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=LHOHzXvl; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r9VUUYclQG2D+jKHTMll9hIsQ83a+DJ6bNwpaQUG0Fw=; b=LHOHzXvl4S23w1QVB7e0CLft+N
	cTJCb7ldoYckfskxmvZSXl5ruQoN8gTMHGxUZDIlEtKCOkFfzOEsuaSjDeiMFXJA+PnQFmqHe61A0
	4Or1oBwJv3rt2Razw0putSOEo1e0CZTt8cKXT88il+L7AA6imq8md56ngb6uo4dQq07ND9imv0NWk
	fj7K7wP7EeFiRcxXw167QoqJMlIEOB3NKK8Kw1+IGfBIM1+MPhHBLv9SJF7mOc4BGVD7b1fLP0euF
	FjaVgdXlOsmho1rGgJIV3s44rdvzjff/a0HdRugDgoZyGYRXhUTnkgfH2H5RVwfsWPYMpVW+4+Z/B
	FWIoeM1w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9h-0000000GwLH-47Kq;
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
Subject: [RFC PATCH v3 34/59] do_open_execat(): don't care about LOOKUP_EMPTY
Date: Tue, 16 Dec 2025 03:54:53 +0000
Message-ID: <20251216035518.4037331-35-viro@zeniv.linux.org.uk>
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

do_file_open() doesn't.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 68986dca9b9d..902561a878ff 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -777,8 +777,6 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 		return ERR_PTR(-EINVAL);
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
-	if (flags & AT_EMPTY_PATH)
-		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
 
 	file = do_file_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
-- 
2.47.3


