Return-Path: <io-uring+bounces-11484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4874DD017A7
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0795C3062908
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B6734320D;
	Thu,  8 Jan 2026 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NzBwocGV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A833C530;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857820; cv=none; b=MjTwrys9tAtzxzFqemz3tL3nELSYNnE/pLTIAKfN8QyRxnX0ekV74fwSUdMGKYj9SSstl+vMo1FH/9ihIuxi0irU+wfVqYM5AvzgwcPE0nbpd030TpnUJpVAKuwhcaVclzj2NVa8sTTjvl3qn695C8W1kIl3qR7JdIuRq3/Exqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857820; c=relaxed/simple;
	bh=qFWWBZSWrxy2KDGSAaHiqUKXKRDjGyqp+DsZAn7I6ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5aXOOfLhGu0qM189pxYM6j1RJmr5pZZkbvU0If4BTIKrVyjDpAwvCjiZHPr6wMp437sCSjpaQMU/lJuD9rED+CeWMmEciv5wSRVSK+GueQrxrMw38m3D037zaxw4w8PeemkB2MPau5obdeLLXl5m4juAq6hBBx5njDnLeSQb/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NzBwocGV; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r9VUUYclQG2D+jKHTMll9hIsQ83a+DJ6bNwpaQUG0Fw=; b=NzBwocGVy42tugtMKxspFD0eZC
	SMLSSFffb7eK83op9AMOA5xqjTgxEOW88R22v6VPpkUlI0SWPFZVMpygTzCPv8aifuT7LIP7sKIjt
	S3sjBUJkkQeltKdjv2l+NfbyXGtuVMkE5OCQI7+pa02vQMNCyNJGIxy0nxq75EMlUp7lOkaazijjD
	9BdZ/CCo5oSDDc7+0BK/b2t3qXlFo3iNf7ZswmsAqaExQhyP2RTWIZQhbkUOUFdGcMN0Td4i+pKiv
	acNJt7m8La93Sh3PtnUHZQLvhSKLPahCp+L4U6/IkOMCaNg3PuZ8FvcIOcXatbZc/5nIr8QjPZSEr
	oI6LyvWA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkaw-00000001mp8-1xb7;
	Thu, 08 Jan 2026 07:38:10 +0000
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
Subject: [PATCH v4 35/59] do_open_execat(): don't care about LOOKUP_EMPTY
Date: Thu,  8 Jan 2026 07:37:39 +0000
Message-ID: <20260108073803.425343-36-viro@zeniv.linux.org.uk>
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


