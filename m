Return-Path: <io-uring+bounces-4354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 277809B9DB1
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 08:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D366B1F22B64
	for <lists+io-uring@lfdr.de>; Sat,  2 Nov 2024 07:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A98816CD1D;
	Sat,  2 Nov 2024 07:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JCfrv4ka"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA82155753;
	Sat,  2 Nov 2024 07:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730532715; cv=none; b=RvVonE77g2ePfi6WKufk5IBcu7POD6MjJj4hTGWKRHFjjDX1m8rJOU2p6kPezcTRZswMki1hskbDO4nianBygrAJuEGFOtNM0Iog/KDrCe5Act307xK5FuAjegTdsiWSsk/xjOubVQXh0h75gUK2tvJGaD7ysg8iv2AYwgw6SDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730532715; c=relaxed/simple;
	bh=CJ8G1bPsyC/3Aia3l1WvbrclINRXhGnBiiRPsulrqts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEPN1RTTprXhPcQEeqjn3MAsfHsj8cJI0qz8Ekb/0i0mw8orEoZttatmVYJNRa1PV+3BBsfsbNPN8QGc17EI1NcdB8/DurxhsOtHUXKY9vut8QdjVA0on8pqfbiO3Jn1jy/FzLCPWcOLSZqH2FQLFGkUun2MNfG1j8UaRDw43e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JCfrv4ka; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/hP85QEGJwGor2x1uEYID+Fvy/bJN990nQDhbDJ138E=; b=JCfrv4kaZ7t9bpea54PUAO6yQj
	1szYnhg2jToINbFYrXEufBzHXclIOeJWjXq0Zhw5wEOl8hToUw54NXPsVIfctCSdL/jrlJoWz/uFc
	uNa+VaZfNgOjN1tXhv/jYWLr0B2osrJCqPNhv/FxyNA1wRgAj/NWDmm9nRO2Rgox3C/hO18KC93oc
	8fUxi6qwY0uD1KckBnea/nXSO0Nzsqz2wecjkhQUToxR3c2Nzp44cLyd40ozFae6ZTPbT+YI/r87o
	yziTzm8H9K1bPvyG7bcTXBjb6kh3cJ0MoG5/j1Tv+hDulEdbrC+NfvihpeNv+SmDhf353Jk2nTmVr
	w2heSYng==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t78bt-0000000AJF8-2IHw;
	Sat, 02 Nov 2024 07:31:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 03/13] io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE
Date: Sat,  2 Nov 2024 07:31:39 +0000
Message-ID: <20241102073149.2457240-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
References: <20241102072834.GQ1350452@ZenIV>
 <20241102073149.2457240-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

From: Jens Axboe <axboe@kernel.dk>

Rejection of IOSQE_FIXED_FILE combined with IORING_OP_[GS]ETXATTR
is fine - these do not take a file descriptor, so such combination
makes no sense.  The checks are misplaced, though - as it is, they
triggers on IORING_OP_F[GS]ETXATTR as well, and those do take
a file reference, no matter the origin.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 io_uring/xattr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 6cf41c3bc369..4b68c282c91a 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -48,9 +48,6 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
 	ix->filename = NULL;
 	ix->ctx.kvalue = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -90,6 +87,9 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *path;
 	int ret;
 
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
 	ret = __io_getxattr_prep(req, sqe);
 	if (ret)
 		return ret;
@@ -152,9 +152,6 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
 	ix->filename = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
@@ -183,6 +180,9 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	const char __user *path;
 	int ret;
 
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
 	ret = __io_setxattr_prep(req, sqe);
 	if (ret)
 		return ret;
-- 
2.39.5


