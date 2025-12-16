Return-Path: <io-uring+bounces-11083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9866ACC0CBA
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8CE23070166
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62E6320CA3;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="O2v3psPZ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC69311C16;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=fgR5xVkSv/i4FCHKlsrzppBTKoFVzJOjePUEK5eAGRI1Kx8X0yTQBswDHvqXxACmdnq09hYYQ7pEPOVeurFQO0F7VJrZ/P7asp31zbnbDXzk9omryuORGlWOgnZ90Ll4eISnOova4vIs+IB50XOElVRBvU8zK1cie2HnuJgO7/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=nTHKXw8UwcLMJ53XI29POh8UPZpmRIfzCZ6jAwlP48s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iup+E23RsDKNeteoPyRRgC7ZxPvnT4loKhDJiD1RfMaiKONRqaAkJRSSRcrNLkN17utMQZ6nKvXa29rm8kbOWuiFGmBCF7uVIundzj5hlub9R0NFTB3TBqqp/aHSePNd5OHAR1EYlil8V404ChHUIwuHl/Ft6GM1FRCUBePcF/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=O2v3psPZ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FD17jUCcWuTCEQI03eM0GnSRloJ9zIEZc4eT9v4ubz4=; b=O2v3psPZo0G07tMTjss+1fCOSD
	exDzuUUagV6b2tu/ODP3mdnd3Xcvxn0MLzK6cL95GUx+JYZRJXNbbZr5pjISyz+JeY1teEZisv36A
	RZhAJdNMqjxk2z55ycPcbE//54iL/f8eiMgy90gkHDGd4IAEi9sa3kF8ZoNJIOhC+vrxzy6ft3R9Y
	Ei4I85bqw3R+OC2B/8qfg02WAMhxYMhbKjmcrtIKxMLBinONTNqk+8pe3+dTtcD154VS1ZdqaLuXZ
	KbM568By4EOxNdriy7xtRUnKocOmUqVMwwBfSS3fH0rilha7BCx8RqyobnI3qrvNh23NFHGGGaftC
	AGXohAqg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwN0-0rbQ;
	Tue, 16 Dec 2025 03:55:24 +0000
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
Subject: [RFC PATCH v3 51/59] move_mount(2): switch to CLASS(filename_maybe_null)
Date: Tue, 16 Dec 2025 03:55:10 +0000
Message-ID: <20251216035518.4037331-52-viro@zeniv.linux.org.uk>
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
 fs/namespace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 888df8ee43bc..612757bd166a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4402,8 +4402,6 @@ SYSCALL_DEFINE5(move_mount,
 {
 	struct path to_path __free(path_put) = {};
 	struct path from_path __free(path_put) = {};
-	struct filename *to_name __free(putname) = NULL;
-	struct filename *from_name __free(putname) = NULL;
 	unsigned int lflags, uflags;
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
@@ -4425,7 +4423,7 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
 
-	to_name = getname_maybe_null(to_pathname, uflags);
+	CLASS(filename_maybe_null,to_name)(to_pathname, uflags);
 	if (!to_name && to_dfd >= 0) {
 		CLASS(fd_raw, f_to)(to_dfd);
 		if (fd_empty(f_to))
@@ -4448,7 +4446,7 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
 
-	from_name = getname_maybe_null(from_pathname, uflags);
+	CLASS(filename_maybe_null,from_name)(from_pathname, uflags);
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
-- 
2.47.3


