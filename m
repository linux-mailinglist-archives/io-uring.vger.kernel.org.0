Return-Path: <io-uring+bounces-11472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4992D017E6
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3E3D3081E53
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 08:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB2D33E36B;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rpG94SJn"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7063321CF;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857818; cv=none; b=hOwSAHOidZ0Jv5fPh2K24D2eTcnY6bzVcMc14xk+YKP0Tbzs7S0XLX1spzwWj3e++QlSr+WqrptQTyL3f6VinTX5VsWEGmOmCRnh9LgVng+IfiRDRXqnpwE7QXMqunaYAjOfaocLafKKAzetj0EWfdaQecpOHsuS5QuhZAzLtb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857818; c=relaxed/simple;
	bh=xKaH/NZFW5DN3VJir82hEz4CpporN5Oy57a9aSeWAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL3WC5Y6jPQHI9Pg5rWjXlmk2OZPt4osEZsT7Sm8ORtmOCx7OmqHmUBtS3U7MkyINvXyUVRzflSosbH1BCLTa+21KHUQ7S9cwoPhpjBEHHOp7663z67faMiEegPTEvWlVOAZ47zauBN5uUecWyaf44pignz3cjeFsfTnb4w8oZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rpG94SJn; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gaYRFNRfoRssLh/Ga6RL0HdpHSyeDiJIvDb89vnXUNo=; b=rpG94SJnWp41VKgpOulDr/KpQq
	aeZ3acfdZNeuzedIxY8oWGolg4tMBx041sgoxZWcHpx/RXKLCoTSTkJiTcuRawRn33IfrztCSVtIL
	Sq9/7CZ6dTr00JrP4MHKfrchIyuPB+p8GZZ7tN6AjfuEKcS8YulnnK3ITK6Ae2U8IUpzLgeI9OxJ/
	T3H25ZFn2XJg2RVIm1yWf3ydRzBGNB8yZJwv/wKWanZVodoFZLFtgBxKU+X6/6rIvWTBXbXjZ+eiu
	5v/vxkt9aosAFzWWDab0P4nl2vsQPEeKPniTDgxioKlr5XPP8+AyW2F3PmwhaIWaUFBw+IX8KlRKb
	KXfH1kFg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkau-00000001mmf-3kdx;
	Thu, 08 Jan 2026 07:38:08 +0000
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
Subject: [PATCH v4 28/59] do_sys_openat2(): get rid of useless check, switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:32 +0000
Message-ID: <20260108073803.425343-29-viro@zeniv.linux.org.uk>
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

do_file_open() will do the right thing when given ERR_PTR() as name...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3d2e2a2554c5..ac8dedea8daf 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1425,18 +1425,12 @@ static int do_sys_openat2(int dfd, const char __user *filename,
 			  struct open_how *how)
 {
 	struct open_flags op;
-	struct filename *tmp __free(putname) = NULL;
-	int err;
-
-	err = build_open_flags(how, &op);
+	int err = build_open_flags(how, &op);
 	if (unlikely(err))
 		return err;
 
-	tmp = getname(filename);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
-	return FD_ADD(how->flags, do_file_open(dfd, tmp, &op));
+	CLASS(filename, name)(filename);
+	return FD_ADD(how->flags, do_file_open(dfd, name, &op));
 }
 
 int do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
-- 
2.47.3


