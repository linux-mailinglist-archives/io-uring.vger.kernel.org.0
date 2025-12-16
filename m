Return-Path: <io-uring+bounces-11115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1737CC0DE7
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62FCC31028A2
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37803328F4;
	Tue, 16 Dec 2025 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="hTy7562O"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F532D7D7;
	Tue, 16 Dec 2025 04:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765858330; cv=none; b=KP9QJWnEIajYLUb95GVR80ALswy73/PyP/bRyEh4TG4VLypVdPl7auQrF2wyoj45ZfgqRnY95squKiPauFI0KsIGBcbwk46kk3vs6iCtE6eqBrXSK+D6aR5gP7YP5CJRBiN/25Rzi/vhwsv8O7FEXlVXJMPT/CnUT59wp/lND7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765858330; c=relaxed/simple;
	bh=RbQB65NBhv+d/ko3uINWOA3g4XqktN9jP7J9TdhO/mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbD9A0zt9kigSLmkONbrREM0blzgXFc/eO5l4uuShptaOIeGCv61c3LwWuVBgAJLjrOTRSdcHp9WYepFrspxAJ28Ur9P9MnLnOLPlowJYCH00Iv5XWR72VOZlZNTPVETH8kVlklxvwOd3BeVFNa+YpcgrFPGuu0hM5jSTof9gxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=hTy7562O; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TYi40CUq0sVjg5FAyHsioxpwVkA0ao080tcS4BIudOE=; b=hTy7562OFb5/W2nnBFhhjTWSWo
	FTFyasVVX2t0SvyWI3c33aE/9qqdV3zfZRB3AwpDiyN0vZSCGVAInhYefzpoXgSpuPeueuSkxnF5+
	u0xS93xVczivfhVXwOHCVGmHQcsqIYOE3B6fEjQTsGGj50SSe+QNzHMh9XauaQrxdfCPrQegDSo5C
	pg/EISBDl+Fcz8JXaNDt1Bn7L9g/LfNRb4VUmp7+doBHc/LpRtw16sRgpYVw2q5jP/4G4H3eKDXor
	RyN7cO+OZSh2TvZcTC7hkzmni5QOYuhkrKwnGwWW2JwZvPOmM0/1l0Nu/jp9k9MTYStiCy0pf/qDt
	s3bwplqQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9j-0000000GwMR-1GOJ;
	Tue, 16 Dec 2025 03:55:23 +0000
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
Subject: [RFC PATCH v3 44/59] io_openat2(): use CLASS(filename_complete_delayed)
Date: Tue, 16 Dec 2025 03:55:03 +0000
Message-ID: <20251216035518.4037331-45-viro@zeniv.linux.org.uk>
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
 io_uring/openclose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 95fcb612ad9c..15da7f3aa37b 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -118,7 +118,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	bool resolve_nonblock, nonblock_set;
 	bool fixed = !!open->file_slot;
-	struct filename *name __free(putname) = complete_getname(&open->filename);
+	CLASS(filename_complete_delayed, name)(&open->filename);
 	int ret;
 
 	ret = build_open_flags(&open->how, &op);
-- 
2.47.3


