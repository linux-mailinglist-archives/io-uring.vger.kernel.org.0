Return-Path: <io-uring+bounces-11630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD26AD1C575
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 652823008DFE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AF82EBDD3;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="EzGmlcSk"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83592DEA86;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365111; cv=none; b=oWeZ+BlrIjxHv9hPGgTxUsEh301Dcbpe/1Hndvg58Fc930UhsTwf1SwWHmX5OpSLfdNUAhVXisB0RbK1roJBOmsUsOa7dIvoQ/fqRD+ShLWzVlZ/DgZTFMVg9QAqN6D1U5S5BsEh2Ee8uKoMitrn5fuxTkfMmJEAkeaOTZFIcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365111; c=relaxed/simple;
	bh=nduInwyXK1O/hLg8VI7EZgIaVz1ezaGJYEXVgU8opJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/daMgRyAv/ykaW+4m3vZv427FSU8tPEyNeICniH+GomExiU7Ka8g4f4XfS+VRXa/xtW/qOnXz0M262MnhdjwvmPhPcAzJvgwD/fC3Pb7Lg4R4x7/wGLsDb5KXQq/u8dSN4/11+hq9AAC3UTtVSmM/2R0BBbG5sXONZ9QMyoJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=EzGmlcSk; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=723KmsOQntt+Z1P/JXUg9Rp00cs102h/CYn5O2iaKHg=; b=EzGmlcSkqHdR0PWx8zE/F6NtI4
	JLg6vgfavTxxZaRiG2Z9Cdolp6P+W/Nvv9P6QMkS+/clNlhs6hkC6PBNyzs2n9BpqnuBuBWT8OFfc
	kA8t/G3ollAwBHaZjGn6SUzwCPYb8CWA0IPMahZ3ZH1YMr7fgwyS2JaTvcNG2vAjUSILjAPWYVoqZ
	Hyx+4W56Pq803hzH2BF9WTd9EvxJvtWe1/7TPY78kk9oBr82o5YuULuItV0ngVvq796oP9rfg/VCU
	pAe2XQ9IQJea54HzzB6LDCwV0pjC3bH7AUf1EgFjMB2VJaMOHZrD4E0/xEu1P4px1Wj9U1I0Lz2yg
	lmE3dw9w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZD-0000000GIn8-0hXF;
	Wed, 14 Jan 2026 04:33:11 +0000
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
Subject: [PATCH v5 05/68] allow to use CLASS() for struct filename *
Date: Wed, 14 Jan 2026 04:32:07 +0000
Message-ID: <20260114043310.3885463-6-viro@zeniv.linux.org.uk>
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

Not all users match that model, but most of them do.  By the end of
the series we'll be left with very few irregular ones...

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
all with putname() as destructor.

"flags" in filename_flags is in LOOKUP_... space, only LOOKUP_EMPTY matters.
"flags" in filename_uflags and filename_maybe_null is in AT_...... space,
and only AT_EMPTY_PATH matters.

filename_flags conventions might be worth reconsidering later (it might or
might not be better off with boolean instead)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5c9cf28c4dc..d49b969ab432 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2517,6 +2517,12 @@ static inline struct filename *refname(struct filename *name)
 	return name;
 }
 
+DEFINE_CLASS(filename, struct filename *, putname(_T), getname(p), const char __user *p)
+EXTEND_CLASS(filename, _kernel, getname_kernel(p), const char *p)
+EXTEND_CLASS(filename, _flags, getname_flags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _uflags, getname_uflags(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _maybe_null, getname_maybe_null(p, f), const char __user *p, unsigned int f)
+
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
-- 
2.47.3


