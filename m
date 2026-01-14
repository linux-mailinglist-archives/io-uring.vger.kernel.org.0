Return-Path: <io-uring+bounces-11636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7E8D1C5AE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07112305DE46
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0108B315D30;
	Wed, 14 Jan 2026 04:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="r2CFTjOb"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81CA2DCF57;
	Wed, 14 Jan 2026 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365113; cv=none; b=EKaWBUGlWiC7gA2VN2ZT9vEc+JCcSdKCW26FsogbveseV0UUVwX1plcmqIf/EHe4JRuh6TcTjkcANmoNLih3zUHDuinX+m9gv+Vj7uhu5d3uJppHWqDqZ2liNTcSwPIjdE3T+llAK7juRrJ57UFNZJGNG1faeEMYeB4809+XrKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365113; c=relaxed/simple;
	bh=rYNiXERMORELD3rtPdZULgbnCI+3YEmNF+Hwi5pTBHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TioWhAx70B69cpi+82jcWLNIf/9riut7k5CAN3GP1oNssPRxGLUdWcBQX7hVnqPhwqhk+HGT3VqAFaNDD7pfhd5kCkHzcpNHC06uWrhu37Rn9hpQawb1JqSl+F/eAos2Qhnj+7T5sucFBn9z1oBX8CSWcS4Icr7wpknKUO/IwmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=r2CFTjOb; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O3vCMEIcJ6QDV68ynljSAAzPvL85FljOJrW2O7eAqj8=; b=r2CFTjObWufo0qMU6F9uUguivd
	SMJLG/fmXOotEHrVOKHMWtaZvdt0NPkkSzDm8oWB7fWo1BG/9CoUNTHBvar3sic44tQnXnTvtKOE9
	PQtHae6VyJiMnrxMdWwCwFW8DkhgPaKdxYDpcvY7hMR5WYy9kqfr37qsArWRVar62d8QwQNNuMfqI
	4b7hh/BnxpBo7o/eHRQoTUKy38xeXyM/5b0lXJ4MyYUMEHnOhJs1SG8cXYmTL/6iK+E+eW/s9rafT
	S22NO7oVIvUiwRrOTJwWhgnEWXeZak7+5SzNbISSjC/cG1ByHXAFtaO52emKYpdKey3ARXZub1qph
	981aj2Rg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoD-0n2S;
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
Subject: [PATCH v5 29/68] ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Wed, 14 Jan 2026 04:32:31 +0000
Message-ID: <20260114043310.3885463-30-viro@zeniv.linux.org.uk>
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

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/smb/server/vfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index a97226116840..30b65b667b96 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -674,10 +674,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		return -ENOMEM;
 
 	to = getname_kernel(newname);
-	if (IS_ERR(to)) {
-		err = PTR_ERR(to);
-		goto revert_fsids;
-	}
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
@@ -737,7 +733,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	}
 out1:
 	putname(to);
-revert_fsids:
 	ksmbd_revert_fsids(work);
 	return err;
 }
-- 
2.47.3


