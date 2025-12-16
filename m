Return-Path: <io-uring+bounces-11084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B413ECC0C87
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 04:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C98330528E1
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DE032143A;
	Tue, 16 Dec 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="FOFP/FjA"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E33112D2;
	Tue, 16 Dec 2025 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857295; cv=none; b=D1uWZ5PqMCvsJ2K+kSDVXJqMWBGUbD20jdQ/9QYJNcg0axQ/zV/DuRjShTiYUUxnvl3av8fUMD5GGjRs5JwLzhyiMvQkNpVYDWXuLguMsjD8b+YgJ2Mq5OBGia+tV9xARLljWuNA+VVM02p0mI5IhhH/s7+XYgGVBXtFJSC6O9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857295; c=relaxed/simple;
	bh=AIif+faRQeRaAqpK3WJa8jVZgeyvF8kX2QVOTCmr1Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXR9R5Bxp2Ret3K+qpIRpWcSI4g2rjjZpqxS72mxNUMvKqkM+aIQTcS16GKrI7ak3cE1WPl233UpfxiUQivx8sR8HJfo87DmfRMkOAP2weZmXs2XcBGbpK/E6s6OmzcLFCw3zE1EIGTxax+YQ9aTk/hV5lnr0/h/VkEkNLwsvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=FOFP/FjA; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZdeAiGVCfTu+ZLXJbm8zIQ/4MuEQJKR0dkiqqtUv5W8=; b=FOFP/FjAM2HF6mrhcSpCZNHymO
	c7TgDXtNry8POz3mw4K5+tHUE3G1J2+gwMYt2TJWsqziRTqJvD4UHfnuNdQtdGRqiPXFo5w7uNZ9v
	q2mxaQ0+kwEVMplIucftV0d/O7vlF0yDV+h8cRhtbJI2X6fWbHw3yqfzjIYt1Qkwc37b9QGNjXA5S
	iCBpokUPBchydGbDC6lqSRpmW2GhJIqYC28mhkmIUkWQVOvu8BpUUDnetUULh0so6BQ1HqD65XP6A
	fF7kmSkfrnpsnWNoTTk/09HaYlC8GQDJ23EHLgyFCKfxuK+JnS9Lt5DfcYvyxKzXF3voi32ZncuaN
	LjsU0LsA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVM9k-0000000GwNB-1nyv;
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
Subject: [RFC PATCH v3 53/59] quotactl_block(): switch to CLASS(filename)
Date: Tue, 16 Dec 2025 03:55:12 +0000
Message-ID: <20251216035518.4037331-54-viro@zeniv.linux.org.uk>
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


