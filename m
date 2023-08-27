Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B83789F5A
	for <lists+io-uring@lfdr.de>; Sun, 27 Aug 2023 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjH0Nfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Aug 2023 09:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjH0Nf0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Aug 2023 09:35:26 -0400
Received: from out-251.mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A111C;
        Sun, 27 Aug 2023 06:35:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693143308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y42FYySYNsis5G3mORomW/nSivl81IaFtk7YSUfz0Jg=;
        b=S4P5Lis+5UgxAXsbIFEQ0bJcfwW5bp3gD+5EV25w4Odl6XRzUJpaJGVaokRckJ9Hpyff0y
        QCMWQ876jzpmtvZlXQ4fdJDhdeygghENaAwk2aokCERTn3SKcsNlbNr+KPD/7nkWidZUEs
        LZ/LAlKjzWeA2HQHZTdX8ZHXdvIJ060=
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
Subject: [PATCH 09/11] vfs: error out -EAGAIN if atime needs to be updated
Date:   Sun, 27 Aug 2023 21:28:33 +0800
Message-Id: <20230827132835.1373581-10-hao.xu@linux.dev>
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

To enforce nowait semantics, error out -EAGAIN if atime needs to be
updated.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index e83b836f2d09..32d81be65cf9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1970,6 +1970,9 @@ int touch_atime(const struct path *path, bool nowait)
 	if (!atime_needs_update(path, inode))
 		return 0;
 
+	if (nowait)
+		return -EAGAIN;
+
 	if (!sb_start_write_trylock(inode->i_sb))
 		return 0;
 
-- 
2.25.1

