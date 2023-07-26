Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D32076337C
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjGZK0b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjGZK00 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:26:26 -0400
Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [IPv6:2001:41d0:203:375::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F81E7
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0lbx0okQPpnQcTB5T0YEuJud2LpJ8hVugIPpSWDV7w=;
        b=OKa1Ghl3A+ogwl4hhQ2WP9H85sDGeelCB9uN/0woiPW2QDvC0n/UU+xX3ZCc/i++HBvMFi
        bYy/udIPlmg0hmu2H0RZAT3RvuKNrOVZUqAT9aUbE3aC9BJnMhjgtF4Ezi1urVgNun+wGg
        h1ajFNXPk7IAGlZa+Fh+WOWOxn7qvzk=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 2/7] xfs: add nowait support for xfs_seek_iomap_begin()
Date:   Wed, 26 Jul 2023 18:25:58 +0800
Message-Id: <20230726102603.155522-3-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

To support nowait llseek(), IOMAP_NOWAIT semantics should be respected.
In xfs, xfs_seek_iomap_begin() is the only place which may be blocked
by ilock and extent loading. Let's turn it into trylock logic just like
what we've done in xfs_readdir().

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_iomap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..bbd7c6b27701 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1294,7 +1294,9 @@ xfs_seek_iomap_begin(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	lockmode = xfs_ilock_data_map_shared(ip);
+	lockmode = xfs_ilock_data_map_shared_generic(ip, flags & IOMAP_NOWAIT);
+	if (!lockmode)
+		return -EAGAIN;
 	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
 	if (error)
 		goto out_unlock;
-- 
2.25.1

