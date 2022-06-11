Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1128E547479
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 14:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiFKMWo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 08:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiFKMWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 08:22:44 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E5E167F3
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 05:22:43 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654950162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvrJD9gksnnXOee+F5KF9tGQ2m10atYyWkwTq+1fegY=;
        b=XZ6P2GZIsWU117siu1q0vmtmAe2XR6Ku+hXSs/71Eg8pHIJvNiU9GEQEqBLZrGW50dkeHS
        P+sD8OSfbnHQ302g794/6UGzsBVcHxcjrWhFrIkOczIPyjGheOw11fMChwEh1BrsMs5YDh
        PtKghzz7owQb2w/5G9HRXRdq5n20AKw=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.19 2/6] io_uring: openclose: fix bug of closing wrong fixed file
Date:   Sat, 11 Jun 2022 20:22:20 +0800
Message-Id: <20220611122224.941800-2-hao.xu@linux.dev>
In-Reply-To: <20220611122224.941800-1-hao.xu@linux.dev>
References: <20220611122224.941800-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Don't update ret until fixed file is closed, otherwise the file slot
becomes the error code.

Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d78e7f2ea91f..cf8c85d1fb59 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -705,8 +705,8 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 		if (ret < 0)
 			break;
 		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
-			ret = -EFAULT;
 			__io_close_fixed(req, issue_flags, ret);
+			ret = -EFAULT;
 			break;
 		}
 	}
-- 
2.25.1

