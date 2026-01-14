Return-Path: <io-uring+bounces-11668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF9ED1C629
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 95A983054971
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4279332D7F0;
	Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RLXRx9v/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B8B30ACFF;
	Wed, 14 Jan 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=DJ2FlcMreRtEZKTt3bClr6hBzEXZYr9mNZ2Ic34JFLXdCWiwSlI52BMu4+OEQqRlK7WXw6x5U/TU81f7OY3PToKQP50qjivPtYWrL6HZIGyxlyiKOa6XHwcYEZutkUIqP1E8XKHXN8OP+kkRlEoSwvuhGIKQBxtDS6MNfouhOqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=ntStfDefI1LSk8YKGruB1ETOnK4upEIT64zjyBPt37E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnmZKpgmqpuPnrgGOqU1SsU/quGkSI/7npGKLaEPrihEI7fFdkBkiHFiVmijiKQAjT0hMYdupysdwD6YV6M8Xkwxi/Pmx18FERnspuALpaTW74L3PdPWuy2fuM6VDMw1vEvOwwMXwGjmYNCZITwEU4xpPdDqknJlv3KknMUKxKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RLXRx9v/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qCNNGL7/AcB8NbftVI2+HUXdppTuzbETXECNk4eIw2k=; b=RLXRx9v/uGWkFOwyu/GhtIXT88
	czqDMQ70ZjGDDs1aYJY+OGOeksI1VdaXlF8d36saAO7nGgin2aj/A86HozZIuafF81qiK1LF+D4fY
	CB2Gyf2ibj5GYNLH+9wIB+dJcn0AEUwXafwHug7I5TwDpORSZbnhg8JSsamU0AaaRXH7lObEu2e0U
	h0mt9AxKAwHPfLtxqjgw5EsuNG/L0nJpK4i0vT9kD9U0bRDy4gJCz+ocUhosLjUolG+7DDMcKVMTB
	LZIa8Tb5UAoZrV6lrlNwwLmYB/UdgWBLd+tvUlmNpv2c7MM0My5b/x4YrK+GZuS5EN2bDqL/5pqMJ
	RU1bhjFQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZK-0000000GIvD-2h8V;
	Wed, 14 Jan 2026 04:33:18 +0000
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
Subject: [PATCH v5 49/68] name_to_handle_at(): use CLASS(filename_uflags)
Date: Wed, 14 Jan 2026 04:32:51 +0000
Message-ID: <20260114043310.3885463-50-viro@zeniv.linux.org.uk>
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
 fs/fhandle.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 3de1547ec9d4..e15bcf4b0b23 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -157,9 +157,8 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
 		fh_flags |= EXPORT_FH_CONNECTABLE;
 
 	lookup_flags = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
-	if (flag & AT_EMPTY_PATH)
-		lookup_flags |= LOOKUP_EMPTY;
-	err = user_path_at(dfd, name, lookup_flags, &path);
+	CLASS(filename_uflags, filename)(name, flag);
+	err = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (!err) {
 		err = do_sys_name_to_handle(&path, handle, mnt_id,
 					    flag & AT_HANDLE_MNT_ID_UNIQUE,
-- 
2.47.3


