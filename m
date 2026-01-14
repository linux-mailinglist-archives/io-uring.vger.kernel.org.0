Return-Path: <io-uring+bounces-11691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE47D1C6D8
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7285B305EF99
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72153332EDE;
	Wed, 14 Jan 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="btDc3Tkw"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83B6328623;
	Wed, 14 Jan 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365121; cv=none; b=WWwAm7Uulw6hcR6WjmxT9Rob5hrkKLkxkZjdyJ2/dlMqDI6aDAkyq1Aho9ofqSb2ckC+TaFegUbi8hzbrVioSvvX23fA3mS6wCY7bkOn1sd5olgtCq3gM28RuUbKLvLMG4KI2LKuoBeDHDksTEs9CF1hKPjDO2Dfli+83S3gOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365121; c=relaxed/simple;
	bh=AIif+faRQeRaAqpK3WJa8jVZgeyvF8kX2QVOTCmr1Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gp9tnc9ctylsL6wWBh4MOMhzSLSQf537m88R03tfF6cJPMeuwmSpH33UK4FmVlSmqplsFKy5mqPOR56YWvmbgdVXjEzgu7zImW0GixUPnXJSu7ovomIT7Yq1svDBFZmFPd8YwXOZGYjk8ThQXrO+sFcx2w7tHKnB5k/jLwVZdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=btDc3Tkw; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZdeAiGVCfTu+ZLXJbm8zIQ/4MuEQJKR0dkiqqtUv5W8=; b=btDc3TkwQwc7Z1UBpQWNJTlEzi
	CFbocq1lVIPvFn0AHWDcPZQ/jxFloTv5dEzdu/CSjQsX25HqjQe0H3NxKuZb377CXWfWQoYlSrza6
	7RDu6hI7QQe0uRkIl4oAXdzD+1PDvl9JuqL+3BC7Hx5QOwfecViUEXSm2stVlGdpjvWMtqakHl0ih
	CO3ZIfYbgXGRZuC7CD8lCsnFESkyKZRNFuBsj2hKnHrEGBS3QyzyhJm0Gu835mPohLMm6UtxWYEWe
	3LhXDWtR1Fyf3H6IJUsdhyUB3zNRpu9bbWOEPdNPRo5UEsM+nI5nCLUvvlGBcaeiNHP5q40hh94rN
	EcjPW0sg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZN-0000000GIza-3FtC;
	Wed, 14 Jan 2026 04:33:21 +0000
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
Subject: [PATCH v5 62/68] quotactl_block(): switch to CLASS(filename)
Date: Wed, 14 Jan 2026 04:33:04 +0000
Message-ID: <20260114043310.3885463-63-viro@zeniv.linux.org.uk>
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


