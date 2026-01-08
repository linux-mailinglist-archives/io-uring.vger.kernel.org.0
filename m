Return-Path: <io-uring+bounces-11459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A660FD016C0
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 96042300647A
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E39033C534;
	Thu,  8 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="IXMdZquV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7ED326958;
	Thu,  8 Jan 2026 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857815; cv=none; b=IIydXKF1FnNhtPo0nxwmc155GjWveExMhtC/Te50yWemflBYhMTsfX2TgRFj7lM9aqZn3M5fBRmBGZAiMxnQAm5KImUjSMaBRTE3405bwfNkoyJFMqgLorvPnNixaW4DzNTnzdmiYNb1oub+k3qTMk8oUza1YP2vDU6LlYW6bu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857815; c=relaxed/simple;
	bh=itjYXpQKRnftlsHN61BFl0sIC9dUJc8OiluxzowKzEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JinGM7qfY5ne8vBBJ2VKWS7wp0WaOnX6PLQUfVYGmNgrPi0EPlllXMdTBfUjs3DLnhsDGqayuLGQAs2TNWzzzLo2+EEY8QRJYfc+DuVDslVSuSN+hPycMrc6HRlDhCgJDzlPBa8F63UvgJin/9RY7bxpt+MOBXD3OP7QE7ZVREw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=IXMdZquV; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aD3+Ie3SLvtsh9GPL3oeza5QcNbuEOf1fbgUgR9ntDA=; b=IXMdZquVE8CjudwsS86xBdfV/y
	lSQEUYP+zRZjc0c600/JlxVCBsWK6kHE+vW95NyFBpkUTMFOCY3UvD1G/b+dN4x6rznfELzoa4aSE
	LnEwkhsRyD9ij3iPPv/OVdMPhjNvl+JfCL86aEHuIqFQ6XV+Ur3gss/GysrgVLctsN0/JZ1guc7Wu
	moSeOPCnRYxwoZbOhn6BTQdepx/q+amqH8gcKkOjsvZ2NhuM9EVklw6WfrovM7LJAwMmiuSzwq3yS
	y1CYZ+Kb9eHAtaLNC+/QFA4kguFKr78LzsmTsqb0XW4ia/cq0GlxKazbUxFXCU0SfOe7WVAl1CYSr
	4rGnRSZg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkas-00000001mjd-3vGm;
	Thu, 08 Jan 2026 07:38:06 +0000
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
Subject: [PATCH v4 17/59] allow to use CLASS() for struct filename *
Date: Thu,  8 Jan 2026 07:37:21 +0000
Message-ID: <20260108073803.425343-18-viro@zeniv.linux.org.uk>
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
CLASS(filename_consume, name)(filename) =>
	no_free_ptr(filename)
all with putname() as destructor.

"flags" in filename_flags() is in LOOKUP_... space, only LOOKUP_EMPTY matters.
"flags" in filename_uflags() and filename_maybe_null() is in AT_...... space,
and only AT_EMPTY_PATH matters.

These conventions might be worth reconsidering...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a74ffcbe8407..ed16644545db 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2522,6 +2522,13 @@ static inline struct filename *refname(struct filename *name)
 	return name;
 }
 
+DEFINE_CLASS(filename, struct filename *, putname(_T), getname(p), const char __user *p)
+EXTEND_CLASS(filename, _kernel, getname_kernel(p), const char *p)
+EXTEND_CLASS(filename, _flags, getname_flags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _uflags, getname_uflags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _maybe_null, getname_maybe_null(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _consume, no_free_ptr(p), struct filename *p)
+
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
-- 
2.47.3


