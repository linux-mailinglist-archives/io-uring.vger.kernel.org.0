Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4D788B3C
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343599AbjHYOLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 10:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343691AbjHYOLC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 10:11:02 -0400
Received: from out-252.mta1.migadu.com (out-252.mta1.migadu.com [IPv6:2001:41d0:203:375::fc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3135526BF
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 07:10:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692972277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCdpGKioQF34weG5w+z0/y3PF/fjvtNNI35yO4EvtLk=;
        b=cYsDGPpjRbWUMOTIPyMO/haz1FlbbiWizE4L6+4KiNimBQndM5dbyTTkg9jBA2egpwU6Cb
        fkg5cTnWwTpMK0RxO73BKMbVgecaeb3ZdD5hvh5LwNn8nQIo0z4wNaoOSgDtnANIdxLDF6
        nhdxpWfLei5X8co+EkZeZUy0T4PzeHk=
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
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 23/29] xfs: don't print warn info for -EAGAIN error in  xfs_buf_get_map()
Date:   Fri, 25 Aug 2023 21:54:25 +0800
Message-Id: <20230825135431.1317785-24-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

-EAGAIN is internal error to indicate a retry, no needs to print a
warn.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/xfs/xfs_buf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 57bdc4c5dde1..cdad80e1ae25 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -730,9 +730,10 @@ xfs_buf_get_map(
 	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
+			if (error != -EAGAIN)
+				xfs_warn_ratelimited(btp->bt_mount,
+					"%s: failed to map %u pages", __func__,
+					bp->b_page_count);
 			xfs_buf_relse(bp);
 			return error;
 		}
-- 
2.25.1

