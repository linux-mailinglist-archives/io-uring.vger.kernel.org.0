Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEE26E1002
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjDMO3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjDMO3E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:04 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A9AF38
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso3879524wmo.0
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396140; x=1683988140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FtT5o+ZLyLrRVDGXI3KV7UlkM+1pYjjuoTQeH9xE/mo=;
        b=E3/QhCRtDUsjv1eIFOXwoPLbIRoeCvJUDW9rB0ssmohjfg5DT4cmQlnlX4m4HiGuxK
         E9+g4RvH0ESxxG9U03tHzQj7IXmNRKyAddHhksnqPpcP6X/tVnQSYrdmCzB0Xu6kCpwP
         LtxPI+iBMh95UtmuVoZepCwyO57Nxyw/KqNrPz4NU2QPCkeCVezwQi4VICD6T8AlMW/o
         79ExQ4wYAnnjWOl++FsDd3ZBHpXBQthfIAN4b9T4fA1qJYkINIO6mAVASYyi/7LmchS2
         EEKqjfPCy7xtXOOuejxNnZT+YYVCMiWY7Gv5tf97plI4T4OwwBTGoTgGSshP2fR3WSXc
         YRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396140; x=1683988140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FtT5o+ZLyLrRVDGXI3KV7UlkM+1pYjjuoTQeH9xE/mo=;
        b=LhhOrFQpm/QFkq+mRsCZRu0v/jWsI2Ja2GHSyHmtox1B9GkkDNXdFuYzgi6+0UG1PQ
         J2CNJzjunRztKYWejiOaPa6gsHzhWa1LPoP7ynYYuq9YzrkM1DwOXD7Cs7K1t9zr8iIj
         HiKxnYgmXggZC2tsCNYzqIXMt9Fq1FRdKCPqYthSPuPDISObRVTryDQYZfvvcr+4BEIj
         xmHkVWeClukF6aG5ud19TDvEdeOZVW60FXrhCFBlhyQK+83vwq/ccvtNdbhEQqQC9oPz
         K7QPTEc2iv7T379Beenu1GhX7nPrtqnv8xqjVz7xxcFExBY4StdiBDh6guOG+zAnR9BL
         WeqQ==
X-Gm-Message-State: AAQBX9fP7G6jxPARUyyIIl27qu6UtICGKPsvX+NZAnfXjcKLTMJMUNh/
        vgdcCGGXWXdgHz1FdDxKQWGrg33niW0=
X-Google-Smtp-Source: AKy350ZlhrzeKUi1dlVPjA8siGRY47Cu9Em6kCwEY0RtBONycQj0ddVfphV8Rpc0HpvgYlgpoOUPZQ==
X-Received: by 2002:a7b:c8d4:0:b0:3ef:6aa1:9284 with SMTP id f20-20020a7bc8d4000000b003ef6aa19284mr1918330wml.29.1681396140089;
        Thu, 13 Apr 2023 07:29:00 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 08/10] io_uring/rsrc: clean up __io_sqe_buffers_update()
Date:   Thu, 13 Apr 2023 15:28:12 +0100
Message-Id: <77936d9ed23755588810c5eafcea7e1c3b90e3cd.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline offset variable, so we don't use it without subjecting it to
array_index_nospec() first.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index bfa0b382c6c6..38f0c9ce67a7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -469,7 +469,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 	for (done = 0; done < nr_args; done++) {
 		struct io_mapped_ubuf *imu;
-		int offset = up->offset + done;
 		u64 tag = 0;
 
 		err = io_copy_iov(ctx, &iov, iovs, done);
@@ -490,7 +489,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		if (err)
 			break;
 
-		i = array_index_nospec(offset, ctx->nr_user_bufs);
+		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
 			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
-- 
2.40.0

