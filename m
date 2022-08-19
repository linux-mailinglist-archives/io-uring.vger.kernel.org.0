Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530F1599E4A
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349577AbiHSPaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349501AbiHSPaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:20 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9773100960
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660923017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BaOSqMP3kdrzOOmzv/EVzRkvK1ACxkPU8HvJac4cKRs=;
        b=KS0m+wFy1HFNHLpuwsKKezC8pkR4Kk02akrucJdscxWwLtaMbVJhdeEdCVBFpJnUlULJiN
        4MFyK/faxpXQxfn4H96DMq0YCi82Lgl+Hw6mRAbyITge1hnl5eNPis10TvtfLe4ZNnrriG
        qrPfMBXbb+xxdCifrI/Cpwoj7k0zoxk=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 17/19] io_uring: disable task plug for now
Date:   Fri, 19 Aug 2022 23:27:36 +0800
Message-Id: <20220819152738.1111255-18-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This is a temporary commit, the task plug causes hung and the reason is
unclear for now. So disable it in uringlet mode for now.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bbe8948f4771..a48e34f63845 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2171,6 +2171,7 @@ int io_submit_sqes_let(struct io_wq_work *work)
 
 	io_get_task_refs(entries);
 	io_submit_state_start(&ctx->submit_state, entries);
+	ctx->submit_state->need_plug = false;
 	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-- 
2.25.1

