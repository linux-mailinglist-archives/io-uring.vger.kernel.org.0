Return-Path: <io-uring+bounces-11504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF9FD02888
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 13:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA00A301FB40
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 11:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2DD34B198;
	Thu,  8 Jan 2026 07:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Ugi4x0Rs"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FF334105B;
	Thu,  8 Jan 2026 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857826; cv=none; b=SDt8krdIJMUntDhed3DevXF8ZiGMJ/Inza65L17QkeOHNXkBx0H6jQKhRrHdUf8QBDBVHUTI6M4OTI9iZam5pmEiX5LQ3Fl9hd8yJjYWuTqxv8b3IZT4xsNoXsJxZlyOweREy0N7Mqb+vVyW3TQyQKMRgpCvybJhkuUvZ/op+xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857826; c=relaxed/simple;
	bh=AIif+faRQeRaAqpK3WJa8jVZgeyvF8kX2QVOTCmr1Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCpAsmLNnXSXCpVWX0ylaF37UWbONu7l1a9HoRfM4bMOyEJrsUPWOiJW1jEg9iAcglJpdvnlY/dD6MH1XNfMTT3K4a/rcD11URq2q98psZNU+jZs/P2oWvOlTZbvWjeOFfmzIgTL5qodJtNsPRXIkddbM6c/PJTR9x+hrNsRByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Ugi4x0Rs; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZdeAiGVCfTu+ZLXJbm8zIQ/4MuEQJKR0dkiqqtUv5W8=; b=Ugi4x0Rs2waIV/VYW056LyfPwR
	I4Rp3M4XHQ1R+8EoGhsUiPpCHgUP+eG+LIbsvaR9Z4TXA1HQiTO8+LVu5/Yd5HBkvo66rkdQYY4+M
	UzpmeFjmCcIYhZUL6ySk5cKHIwnO0CzcMG2S2kF+dqiYrWds6E0epL95fZUEUgBS6n9lLcs4r7ol3
	I+j/zBJCC9NpbtIhDunlr1it7ZN1QPwKU0dnjBWNu4rzXMhZ99XYN0/8wyCHotekdcgElYpZRFuSk
	Z1j1RsqBAXwd5r4CydJJJBhiW9frXQJqlPiBil8fwjpyzVN7SMri2rnCwyo5uAWaY5hSwjOnQAODJ
	ENBT29aw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vdkb0-00000001muh-1dZO;
	Thu, 08 Jan 2026 07:38:14 +0000
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
Subject: [PATCH v4 52/59] quotactl_block(): switch to CLASS(filename)
Date: Thu,  8 Jan 2026 07:37:56 +0000
Message-ID: <20260108073803.425343-53-viro@zeniv.linux.org.uk>
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
 fs/quota/quota.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 7c2b75a44485..ed906725e183 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -867,7 +867,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 {
 #ifdef CONFIG_BLOCK
 	struct super_block *sb;
-	struct filename *tmp = getname(special);
+	CLASS(filename, tmp)(special);
 	bool excl = false, thawed = false;
 	int error;
 	dev_t dev;
@@ -875,7 +875,6 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
 	error = lookup_bdev(tmp->name, &dev);
-	putname(tmp);
 	if (error)
 		return ERR_PTR(error);
 
-- 
2.47.3


