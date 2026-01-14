Return-Path: <io-uring+bounces-11652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 203B5D1C5F6
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15014307D56D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B7C329E65;
	Wed, 14 Jan 2026 04:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="MLR3VVof"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A57D2E1730;
	Wed, 14 Jan 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365115; cv=none; b=j10yEcIEnCaFHF6Pepf1Jkx4ssRDmUz4+IIG2K6Tc6MF4QtvaG9kB4Era9DPJMPhmm8lq1aoP+ADBRzEf5e3YMKTWj8yqhJ2hPfX8oL4tnLNKpZ+v5a4ColSHAJ8rup0qq/b1+A10dGibG3tNSl9pDvlPd6rZhr1ekrN1ABehEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365115; c=relaxed/simple;
	bh=PzRze4TPSn+FaF2mEY8QRRX+VOcGOgJmg+7Op+juS+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPMluAhRcrwtotMuIVT3Y4uHAfoqACdPaVQy86yS3d/XO70KP6oH+vyLcUw6cv5t+5bPxVNaml59OjI4zPa3vNbPvzdt95yZZql2zruisZXD3uYWEr00olXpnB9EE3plcPV1y0ip4RjiUdDuDO2xVA002TpWm1ozLSmEqUCxjs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=MLR3VVof; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EBeLYkaHE8Ff0WaLManhd7n2iZENXnDxfI+I0pv7fdk=; b=MLR3VVofIIFhWtDRS1+3JVbnDC
	GagS0+6haTcLRyh4Z9+ow/YqOiICdjVB6azhdOqBYymsH+epTaREsnuESupPO/KqNPB4A44CSVYcA
	5IsNiHVUc0Et7PWsS/HEDgjzkVydhmVQaO6UboLYRlWGkgyr2kSxFADwOnHLAnrhTMAUwfOGGxhWK
	Y84a1TGQaLL3Spw3Qs9AsALTpBZK3OPL5c68+G7Bps6VvpN6N8hBvfWzEUDEtaievaaAFj7WFa0Fi
	s80nVeqNDlKdAnK188QyEqlj+zf1amfBB20QtMCln3TABhmHxzpER1dY0gQPXDcZKtSdXEXA38FEI
	8vmQEcrA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoG-1FmK;
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
Subject: [PATCH v5 30/68] do_filp_open(): DTRT when getting ERR_PTR() as pathname
Date: Wed, 14 Jan 2026 04:32:32 +0000
Message-ID: <20260114043310.3885463-31-viro@zeniv.linux.org.uk>
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

The rest of the set_nameidata() callers treat IS_ERR(pathname) as
"bail out immediately with PTR_ERR(pathname) as error".  Makes
life simpler for callers; do_filp_open() is the only exception
and its callers would also benefit from such calling conventions
change.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index f4359825ba48..659c92a6d52c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4871,6 +4871,8 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 	int flags = op->lookup_flags;
 	struct file *filp;
 
+	if (IS_ERR(pathname))
+		return ERR_CAST(pathname);
 	set_nameidata(&nd, dfd, pathname, NULL);
 	filp = path_openat(&nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
-- 
2.47.3


