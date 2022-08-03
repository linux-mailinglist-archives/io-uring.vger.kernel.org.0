Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334FD588BC8
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbiHCMIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 08:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiHCMIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 08:08:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F404C0C
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 05:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659528488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4+V8tELYNgtjI+7Zs00Byby6W4ZoYTLzNtMInZdgoOU=;
        b=a9EoSEJTtMjmlhtBd5KoJXLFUpiVEKyUTnNjWS216lEyN0jxFzaTDk2F7bSFdSXbE2uVq+
        HkWUjBPi8fQ1C0/HrW1kQ/03rR1+mfGyXsWrVUobRBFQTIM6PTNqn8CHi35eXf6joxWS26
        eYZanZFVs3lV15QksOianqBhbre+JWg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-EmeuGEbRPnaGPN2lLkrfgA-1; Wed, 03 Aug 2022 08:08:05 -0400
X-MC-Unique: EmeuGEbRPnaGPN2lLkrfgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0E463C138A6;
        Wed,  3 Aug 2022 12:08:04 +0000 (UTC)
Received: from localhost (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA51F2166B26;
        Wed,  3 Aug 2022 12:08:03 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH V2 1/1] io_uring: pass correct parameters to io_req_set_res
Date:   Wed,  3 Aug 2022 20:07:57 +0800
Message-Id: <20220803120757.1668278-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The two parameters of 'res' and 'cflags' are swapped, so fix it.
Without this fix, 'ublk del' hangs forever.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Fixes: de23077eda61f ("io_uring: set completion results upfront")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- fix 'Fixes tag' as pointed out by Pavel

 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0a421ed51e7e..849d9708d612 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -46,7 +46,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, 0, ret);
+	io_req_set_res(req, ret, 0);
 	if (req->ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
 	__io_req_complete(req, 0);
-- 
2.31.1

