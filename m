Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF9757D4F
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjGRNWe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 09:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjGRNWO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 09:22:14 -0400
Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [IPv6:2001:41d0:1004:224b::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6447B19A5
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 06:22:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689686518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bF5Iku95d7KPx9G2a6PILxIMpzrwjVAV7d41dJF/jiw=;
        b=OegxyL6Sfw7AQSBUUS+3hx63S0xbG1s7n59HEuwueY5Dh7JxuM19q2TPW3Q5mCbChf89EV
        lELXbnWK45a/sBr7KxFGznOXUhdG/1Kj9esXPJ39JDVsdGQG/0IL+g4B/B6GBjC/2oh5mP
        89b0emMZgpIFwfJ+0ScjFvWVMuPRUbo=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH RFC 5/5] disable fixed file for io_uring getdents for now
Date:   Tue, 18 Jul 2023 21:21:12 +0800
Message-Id: <20230718132112.461218-6-hao.xu@linux.dev>
In-Reply-To: <20230718132112.461218-1-hao.xu@linux.dev>
References: <20230718132112.461218-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Fixed file for io_uring getdents can trigger race problem. Users can
register a file to be fixed file in io_uring and then remove other
reference so that there are only fixed file reference of that file.
And then they can issue concurrent async getdents requests or both
async and sync getdents requests without holding the f_pos_lock
since there is a f_count == 1 optimization.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/fs.c b/io_uring/fs.c
index 480f25677fed..dc74676b1499 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -303,6 +303,8 @@ int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
 
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
 	if (READ_ONCE(sqe->off) != 0)
 		return -EINVAL;
 
-- 
2.25.1

