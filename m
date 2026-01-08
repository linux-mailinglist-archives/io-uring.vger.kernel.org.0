Return-Path: <io-uring+bounces-11468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E94A9D01705
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 08:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C9D3077277
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 07:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913AE33DEF1;
	Thu,  8 Jan 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="CGJAzNUZ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9F7331A5C;
	Thu,  8 Jan 2026 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857817; cv=none; b=SmSe2U9w7kkY524XaDwhdHgAkwe1anPWtZ4mn130pRPjOU3B98EnUB/VFznBT0eNNwEX4MJUbuRKW89/yRRV3IfvKKA1DP8rwV/+LFtmC/KjwuDjUMYm1OZWGeXa8axvhmLgwaZS8eKYErZKD8zS4To0sgaFb5hcAJq6NnUGMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857817; c=relaxed/simple;
	bh=C+2EcojQwnwv5U/vpMob42+W8dy1bNTjOKNG9HnaK5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/05iK/6zeqLgc5Zyh9WTAUlkPwlAYhEPrGee7HaPe8BcA+6zBJe1G1y1wwx05Lp155brNfyx3Re24+0eTjTVQVcHmO/owkZyyNGmxY+MhHBkynR7Ffy1XEW0Txth6Dc62zxUt4/ZfmJNZaWHczRQpkDwzQhrxSu8vwpHzYrInc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=CGJAzNUZ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nX+MJLbNwZ93pbRcj4nhRonYJnvqZZukCpm52ExmhG4=; b=CGJAzNUZZBDNrgo/UgOr47tLtL
	ufOQhyFihJuBumEzy9ahv4tECoRxPf0Yddp1swELK2tMEouBX6YTAJNGS/33y52uWxcVPv19rrFz7
	Ry9JO6pdIRac64DHHrOVPabO4uXHs/oE6CuMzBnf3J1M0ubtr/zW+2Ik8L6Ce4nkEsXh4Vf8y8XoO
	NeuDCOnVphxzpUy4ffmyzzKVPJXY+qz/iGkKruw5mp3WKYVNR0i8GhWYEoPD5OlGNQC9DzhyMTvrq
	olNJYI9KqH4y3qbI5ZlRgGs/O4lD0SqSXMrNa9VBLebtaZpUSeGi8FSrFLM0lw21QyxDxe5JS9z5k
	2+p2nE5g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkat-00000001mlJ-4BVt;
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
Subject: [PATCH v4 23/59] move_mount(): filename_lookup() accepts ERR_PTR() as filename
Date: Thu,  8 Jan 2026 07:37:27 +0000
Message-ID: <20260108073803.425343-24-viro@zeniv.linux.org.uk>
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

no need to check it in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c58674a20cad..9d0d8ed16264 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4427,9 +4427,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	to_name = getname_maybe_null(to_pathname, uflags);
-	if (IS_ERR(to_name))
-		return PTR_ERR(to_name);
-
 	if (!to_name && to_dfd >= 0) {
 		CLASS(fd_raw, f_to)(to_dfd);
 		if (fd_empty(f_to))
@@ -4453,9 +4450,6 @@ SYSCALL_DEFINE5(move_mount,
 		uflags = AT_EMPTY_PATH;
 
 	from_name = getname_maybe_null(from_pathname, uflags);
-	if (IS_ERR(from_name))
-		return PTR_ERR(from_name);
-
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
-- 
2.47.3


