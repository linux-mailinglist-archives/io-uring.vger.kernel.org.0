Return-Path: <io-uring+bounces-11071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC68CC0C57
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1DB63031346
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146F2319857;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="oQPE9ZHD"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75644312811;
	Tue, 16 Dec 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857294; cv=none; b=i0X6mPu/FoDq6Zt/hfFcGvrGeD+B+8GLf7Qta2LsZMKKyxYHYT6F+VQUqTPkPg/iGw3y9stcbOEAesOzuinSkCPdm82/ijv5ZPq3O2ybs0fNIEzOXwrCMCxDe5mT8jCKUPf/M5GkXqhK6HwI25iDCMYQKi4E/Lhb7XVSTZ5jzDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857294; c=relaxed/simple;
	bh=+1i0jwxyk8DGf0W2+2Zfb4jLSGnyQvm9v3lj6zBMWXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRBAgruQ1SqcTJYWS4zNl6oSeDXBzCRvl9Yo+qEGeLdcsPksknpUyPP5YoGa9bCMK7frhOzI+L+V12xxySQSZaZ07iEOF7rYxeMlFRqdNOtcKQZx6kloOILAgjCJyNVtQ8uB4c0skNiwQ686yqDLOoLQU1Hm5Jx4V1hPZKNw0Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=oQPE9ZHD; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6lhUcDw8YnPMZe9i+imJJtFRGzopLM7v6pMBLQdGXEA=; b=oQPE9ZHDJ9AauIKsUujkam7XOM
	ZazGGoN1eb3i62McV4GfVzaQAATceE+XQdEfgZLtnqKj8RYi+/t63UBWi9qEq6Jo/HWvB74KMdYFq
	OVipuyxhDYmZoPoUR+bvEVy67e2H/pyMlPbsfeVzmeiDO6Yr7X+cI/96k24BBQGATrn/EA4OqfQuU
	QfqArefXcSj9jAo17eU6Lq+9vCm/YdrGZZSTd1JQtj0VoFwDB8eWEkIUumgD3d76PWIS/2c3BkufV
	Ern4BYs6gV4/Paz5H1sRO/QRu/+ql0986ZDUZfinR/JWFGSHXdxtyKh9PCR1ohX/KEUC4u0rfW6YD
	HhBthSKQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9g-0000000GwJu-1jyS;
	Tue, 16 Dec 2025 03:55:20 +0000
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
Subject: [RFC PATCH v3 19/59] allow to use CLASS() for struct filename *
Date: Tue, 16 Dec 2025 03:54:38 +0000
Message-ID: <20251216035518.4037331-20-viro@zeniv.linux.org.uk>
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

Not all users match that model, but quite a few do.  No mindless
mass conversions, please...

Added:
CLASS(filename, name)(user_path) =>
	getname(user_path)
CLASS(filename_kernel, name)(string) =>
	getname_kernel(string)
CLASS(filename_flags, name)(user_path, flags) =>
	getname_flags(user_path, flags)
CLASS(filename_uflags, name)(user_path, flags) =>
	getname_uflags(user_path, flags)
CLASS(filename_maybe_null, name)(user_path, flags) =>
	getname_maybe_null(user_path, flags)
CLASS(filename_complete_delayed, name)(delayed) =>
	complete_getname(delayed)
CLASS(filename_consume, name)(filename) =>
	no_free_ptr(filename)
all with putname() as destructor.

"flags" in filename_flags() is in LOOKUP_... space, only LOOKUP_EMPTY matters.
"flags" in filename_uflags() and filename_maybe_null() is in AT_...... space,
and only AT_EMPTY_PATH matters.

These conventions might be worth reconsidering...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b711f46ba8f5..db0d89dd1229 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2527,6 +2527,14 @@ void dismiss_delayed_filename(struct delayed_filename *);
 int putname_to_delayed(struct delayed_filename *, struct filename *);
 struct filename *complete_getname(struct delayed_filename *);
 
+DEFINE_CLASS(filename, struct filename *, putname(_T), getname(p), const char __user *p)
+EXTEND_CLASS(filename, _kernel, getname_kernel(p), const char *p)
+EXTEND_CLASS(filename, _flags, getname_flags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _uflags, getname_uflags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _maybe_null, getname_maybe_null(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _consume, no_free_ptr(p), struct filename *p)
+EXTEND_CLASS(filename, _complete_delayed, complete_getname(p), struct delayed_filename *p)
+
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
-- 
2.47.3


