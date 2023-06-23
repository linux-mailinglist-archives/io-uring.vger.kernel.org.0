Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9373BD06
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjFWQsU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjFWQsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7619E2733
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b5079b8cb3so1764075ad.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538890; x=1690130890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAC7drXqvR4smhcm9JEWe7VO3fT7fkffLKfKJ9HzOJw=;
        b=ly+JwbnYLHTgdZuKmE+TyZjJZ2K0XgYNj8SPS+d+ZOtfwoN0lhTkheOqgAKk20+uC+
         ZiwNbDQsE1c8WWhP5ViKJOfBG/OSGkpnRnPWtVTeM4VIM9psmuyUB1BuXG0LWQL9+50A
         UAoguXH02Dt9CJdDPO1G2dMxShBr53EFFXNXgXoFbPG4VybZWwUXmQAyrytgZg9psTkO
         WS80jlmiHrsTznYffGKV5jzVFba3X0LcXPExwtR8uPBKXt+jMmUqdjRDMDSURHwXo+cF
         vn7ApeHU42klyXep6NF9t65J+yCC77A8RoSjZ+1GmPo9FGCPODGSbhWx98ZQgFMtgRf7
         xY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538890; x=1690130890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAC7drXqvR4smhcm9JEWe7VO3fT7fkffLKfKJ9HzOJw=;
        b=BpR1PwcSlnQKQz2mRmW3QBsKHpjFpUBuaFMUfRSzAZyHcRys864Ab+dxsQoV++k+Yp
         KwgU42WNil0r/f8liBNRCgcLjQgWRVvJ8tbKG8NlxrYC0lN1hIcZjOvMOI4M41mifvF0
         /IfcPsPhH2M+TwFjjpeym1qE1npoQbp+UNlZuvhCYxl+vAUshDx2+e7LSyCXn1IGGnd9
         WONzUGg5/2U7aSXBNgRM30WIFnOfiUnH7nX+olfjO1yOhIWUP3I+PeFhdej3EavPbpod
         Td3vrS8BMYfW54/fjACm9TV7uT+zb7l1ekonTxglqrT7ahjNFsZLfVRvTBLqBjOdw1cq
         r51Q==
X-Gm-Message-State: AC+VfDyDMtPd02+BpARGTzL5Rqpop68taVSu3oR0R7GUtub16nAKBMTV
        ebub8Tf1EiuGGOmGGRHgXNgFZS/p4FP+XlqW3FY=
X-Google-Smtp-Source: ACHHUZ6qwlLwyW2oY9nKPyNIfLgSxd8UmSsXp6cMhdg5AHLLwDLqS5zQnDWw0z4GIrIKQWe4NAhL3g==
X-Received: by 2002:a17:902:dac6:b0:1ac:656f:a68d with SMTP id q6-20020a170902dac600b001ac656fa68dmr26265509plx.4.1687538890441;
        Fri, 23 Jun 2023 09:48:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring/poll: always set 'ctx' in io_cancel_data
Date:   Fri, 23 Jun 2023 10:47:57 -0600
Message-Id: <20230623164804.610910-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This isn't strictly necessary for this callsite, as it uses it's
internal lookup for this cancelation purpose. But let's be consistent
with how it's used in general and set ctx as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index d4597efe14a7..c7bb292c9046 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -972,8 +972,8 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
-	struct io_cancel_data cd = { .data = poll_update->old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
-- 
2.40.1

