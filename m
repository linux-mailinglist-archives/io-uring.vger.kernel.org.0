Return-Path: <io-uring+bounces-11635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEE5D1C5C0
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C28D23044C2C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DD431B833;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="YR+W8c9t"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067D82E11B0;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=tZ75f+w3xfefzZsBOE/i4rvh93iClsHMtZyMjU/dEo0EqsLdZeTQDGf9sIIqfO1UTaxA0EAb/VsU6OIfUsRWtCliQLNpVjdj1jtXZO0u7EyIFm03/f5oMQz33uivV/Doc5Si0dA57OCyEvVcmYcZ3RERO77rySNkbkL0UWJp8xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=dKazOTpP98uEsD5tvT0eCFSPEKi73Z7M/OFRDrSl8h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMUDINPUGTMXskWYsMd1Bu3byoMne8YH6+GjMoXyibNx+g17mf5Oq8QniBZxUX+LjtUan1kvK1O/X/HTje7iaNp5fDNz9B7skXCu+znkUXGnHtBZJSXIs9xEJzjZV/LkTFvHbfiVpLjYVVUBI8UzvfKibf+mw2savn9AezYTV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=YR+W8c9t; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/taDnA0SgX1kjdBTGSIJQ+UnMnEm3NgXYjqO+SzjTkM=; b=YR+W8c9tc6JQbqqzjO+//SsLtE
	XTkVKnKd+lTyw4TSxKN4L287M8hDod3y6DqeqgFfgbcWCVc+I0pfdXaBNky6k5U15NZHpbzZA493Q
	/EsXwxR4NJG5S104VAMqKKYajwyv8/yemEuJXLOo06lXIlWHarOqoHZfw4WtTVJWYL50mO96oHfwZ
	1Ssyk9ZcoBXV/x2KygFTLlXvldeAzZtHPHhWWaxaLneFbaG8RfMcQqDIfJZsSuDCdNI4ZHuxEbCo6
	eYxiUKZDI0ah4+d+1LxaN/rJGQ51ff2ggPqDkgBWxcVib7u/lEBM4mcoSB7TsI8+0BM2KRcvn29Vf
	Oo0XReIg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoQ-2sj4;
	Wed, 14 Jan 2026 04:33:14 +0000
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
Subject: [PATCH v5 34/68] simplify the callers of do_open_execat()
Date: Wed, 14 Jan 2026 04:32:36 +0000
Message-ID: <20260114043310.3885463-35-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/exec.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b7d8081d12ea..5b4110c7522e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -815,14 +815,8 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
  */
 struct file *open_exec(const char *name)
 {
-	struct filename *filename = getname_kernel(name);
-	struct file *f = ERR_CAST(filename);
-
-	if (!IS_ERR(filename)) {
-		f = do_open_execat(AT_FDCWD, filename, 0);
-		putname(filename);
-	}
-	return f;
+	CLASS(filename_kernel, filename)(name);
+	return do_open_execat(AT_FDCWD, filename, 0);
 }
 EXPORT_SYMBOL(open_exec);
 
-- 
2.47.3


