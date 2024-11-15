Return-Path: <io-uring+bounces-4713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA279CD5FC
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 04:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00ED31F2228C
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 03:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D75740849;
	Fri, 15 Nov 2024 03:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mKOwiEV/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A01C68F;
	Fri, 15 Nov 2024 03:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731642547; cv=none; b=Qf+uOhoDxuWMcq+00txBY/9snyNHi0H5BdT+siDof4FtMcZ1hXqxD5JI38gdzvNEm631EvoTXnJTal933KcVhYxgc6bBi5T+IzEh9I+aB3YFmFW+UZC/6RDCW2Lw5aKHC1elqknB9o0HidvhBFst1H1N985eiRFKqQrxkEqd69E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731642547; c=relaxed/simple;
	bh=NZBHPDG1b/3QgDjWyqRAQyrsFe44fuHGVOED25MVeSY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OhCt5R0YPTytrAfFdq1Eyo/7otwq89f2uDSVNECYPb8BMeTecixNNtARDptC7dw/69bBVBst5TM872tq591W6E3A7WYMyJXhgv5ZBTge7YMhO7ElhE6nfN7sZN4HXBvn2OHo9WlNfxJtMxjosd4miFArQqJ2recd0kQKJkvpQws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mKOwiEV/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/vXJX/hn156eKe1orJYsSgwVcjyyd8SnfFRG42OLzRs=; b=mKOwiEV/HiqPuzjWABbK7mzPWt
	eO8AaR4DyzRs0MEz7US6Xoma1JhQ3epScYF9NijJCsA2XoZcxshdqsBRXoK0VxNg9ImAiAR5ttWGr
	9Kmp0i1RxXNPBFTKB0kVo74H7+QCrNs7gHFOwRCU9967Hu6GJ+Iyy2tuEK6ol4oH/W7enGsLtVzCG
	gNGndBWCtmEkD/L3aDJmiUHMjjmtCQhGeG+PQ4Oqagu/iWXRjFUME8DxVCrIwnJ7RZw051/TT7XhQ
	LazzCTJ2XVyLt//sw/1f4lUaRVeT1QTM+ymwSN+13f1LSHGSR7k7zcDVTyFmU9PZO10Lob5qK8GO+
	ofF8/4FQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBnKQ-0000000FB2e-0No8;
	Fri, 15 Nov 2024 03:49:02 +0000
Date: Fri, 15 Nov 2024 03:49:02 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] switch io_msg_ring() to CLASS(fd)
Message-ID: <20241115034902.GP3387508@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	Trivial conversion, on top of for-6.13/io_uring.
No point backmerging and doing that in #work.fd, seeing that
it's independent from anything in there...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index e63af34004b7..333c220d322a 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -333,7 +333,6 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
 {
 	struct io_msg io_msg = { };
-	struct fd f;
 	int ret;
 
 	ret = __io_msg_ring_prep(&io_msg, sqe);
@@ -347,16 +346,13 @@ int io_uring_sync_msg_ring(struct io_uring_sqe *sqe)
 	if (io_msg.cmd != IORING_MSG_DATA)
 		return -EINVAL;
 
-	ret = -EBADF;
-	f = fdget(sqe->fd);
-	if (fd_file(f)) {
-		ret = -EBADFD;
-		if (io_is_uring_fops(fd_file(f)))
-			ret = __io_msg_ring_data(fd_file(f)->private_data,
-						 &io_msg, IO_URING_F_UNLOCKED);
-		fdput(f);
-	}
-	return ret;
+	CLASS(fd, f)(sqe->fd);
+	if (fd_empty(f))
+		return -EBADF;
+	if (!io_is_uring_fops(fd_file(f)))
+		return -EBADFD;
+	return  __io_msg_ring_data(fd_file(f)->private_data,
+				   &io_msg, IO_URING_F_UNLOCKED);
 }
 
 void io_msg_cache_free(const void *entry)

