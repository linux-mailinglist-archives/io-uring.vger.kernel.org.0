Return-Path: <io-uring+bounces-11476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 51081D0180A
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 09:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A7CC30CDF1E
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690C434250E;
	Thu,  8 Jan 2026 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="p0YYE3vp"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5B33BBC6;
	Thu,  8 Jan 2026 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857819; cv=none; b=PVOqfmoLThFe9VWomVNLnK6DLxiDV87TFv+fC6ggJUIm1aVQHM6wgp9JQ+8zzVpSEKX+a/XpAZw1I3RKX2GSysutabKy7h1cRXscU6U0c9VJaQW/TIb7MpMJYaDiUHT62Ly45iuO+NDkVTrjYwYTF2Gw2J1G0nsX/Mv7fwJZQQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857819; c=relaxed/simple;
	bh=1T9eJEuB6l9T+/4WSvz0MwkQ6ZS9+2XOjVOn7L1MH44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB6o6l0YiXizzC+VL/LqHfvpq4thXsa8APK+lqgtiRZGrD2RxzB+hHxqGMx2y9U6/cUb+IBGYTj0HuLUKxA/mEOcYd86MrMi81MthWqUdDb73Sm4qgpRLTjBAi6haKg34Im8sGrG0bS0R9if1sb1tA4wlP3LVdSsOxKsrhrax64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=p0YYE3vp; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KpWOI8XMVeq41RdiPMuRug/lWmTpOFPv9An76fDH+Fk=; b=p0YYE3vpRqG1p2Bq/s+8iqSL+s
	WYyQWit/Ix+IOXG3jRJMaiA0wXcrqQbgfOI1t9Lwlx4IfazsLIQdMP3Gtg+jn4WxCJkHDLW7m987m
	K7Go/4T2LSqSGRLyvIUWs6xJ5lOIgy4HCfJ8xvtF0hkS1V1PqcmGvHlU0Kf99uSZjRhzE4BV80yIS
	aktXyKRWQ5RHjgpHobti4P8N7CqXDZfLZpvDxpRUEDhsuzFw8t5DUic55sjFFF4DphIMrq6JHziMU
	jC62wOTaUXwEm7+XHH5Ahkb0aFcqxFonBwf/ol9g939eV3EOcBdILxUfpn48So3My8Ni1c5jA9iyV
	+BI8z96g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkav-00000001moK-3eTu;
	Thu, 08 Jan 2026 07:38:09 +0000
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
Subject: [PATCH v4 33/59] file_[gs]etattr(2): switch to CLASS(filename_maybe_null)
Date: Thu,  8 Jan 2026 07:37:37 +0000
Message-ID: <20260108073803.425343-34-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index f44ce46e1411..42721427245a 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -374,7 +374,6 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -395,7 +394,7 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	if (usize < FILE_ATTR_SIZE_VER0)
 		return -EINVAL;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
@@ -428,7 +427,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 		unsigned int, at_flags)
 {
 	struct path filepath __free(path_put) = {};
-	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
 	struct file_kattr fa;
@@ -458,7 +456,7 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
-	name = getname_maybe_null(filename, at_flags);
+	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
-- 
2.47.3


