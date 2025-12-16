Return-Path: <io-uring+bounces-11116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BB6CC0EEF
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 11ED23152354
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1CB335078;
	Tue, 16 Dec 2025 04:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="hs6qjpr1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0569331A59;
	Tue, 16 Dec 2025 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858343; cv=none; b=DOXF7DEyYZDZi6vjAbwJEJ/NWajQqGlOjJnrL+ejj+Ywcy9HL4JnC9lMRpH3swNI3SKppk+vV3S5H8kh9adGhWboOXN0gNrOg/in3CN3d/cS97zF4tcomsFeB8AkrV4wNvF3RunRRysG84/dnUJ8H9knLE+2wQBZlC+K/TUELbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858343; c=relaxed/simple;
	bh=IEwc4LjzYb3QaEH4FRO9+PlvIEgn68jsUGPc4pkloaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tk2h+SJRLxmMJHqQqHNXYirRIG28+U+mQ/pcZITs1oGwUMEESn7hPcINUaXXzacVEKNSxcJMVbCKzzTFD4OfPKXn+Z48ici/nqyGuI8AcXEZ7usGF21GYjPSOIEa3mc2XIJ0b2LfsPpLsjub0oHpxDV2S6a1stNevuMQHr/5oSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=hs6qjpr1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0td7W8k2a0CvduT5vXbhzDJRTHjkjLYphit+shYJ9X8=; b=hs6qjpr1VEhMlQfG7kqhYbI77s
	ShjHFsHPKxWG7QGwlXia7q4EXa7j8blypkR5aZYgeNbvUUl4+0/RJYQby7NW8P2w6LsIEsy3ZniEK
	Xz0RQSYht/H3XWhqAKI8N+NLTdhzfsy6JhurmHlItbtiNnjJRM18IvEVUcfVCaLdq3G0NBoaivJmB
	OcZuUpEq1CCqpkyL4nhryA3M6x4tgxNVt7UW7NSD+YPJrbNk1I8H7EMms6bGhOcHdufTKB3aEUUr1
	8b4AGhqjpujCnJFOf+Zc4++aR36Xg4lsRiXw7O3IBZE1Ep3LDMFQqIbhgl+a/7rNO1xV2PcyRv4Zh
	vXKQJ5Zw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMc-33pr;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 45/59] io_statx(): use CLASS(filename_complete_delayed)
Date: Tue, 16 Dec 2025 03:55:04 +0000
Message-ID: <20251216035518.4037331-46-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 io_uring/statx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/statx.c b/io_uring/statx.c
index dc10b48bcde6..7bcae4a6c4a3 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -50,7 +50,7 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
-	struct filename *name __free(putname) = complete_getname(&sx->filename);
+	CLASS(filename_complete_delayed, name)(&sx->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
-- 
2.47.3


