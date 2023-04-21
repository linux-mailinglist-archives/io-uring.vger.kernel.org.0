Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B256EA997
	for <lists+io-uring@lfdr.de>; Fri, 21 Apr 2023 13:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjDULrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 07:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDULrB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 07:47:01 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F3273D;
        Fri, 21 Apr 2023 04:47:00 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-2f6401ce8f8so1016096f8f.3;
        Fri, 21 Apr 2023 04:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682077619; x=1684669619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyzO4zzg3fbvkoe5Py8PgbHJHxsStxtqkj+qewtTEyc=;
        b=b9vXnqOaKckCUIbuRtLA7cqza7hYMjJhBo+8BGTEQrUhYwkAccuvLjqCRqfMy74LCf
         i4FFwmcOPycDlbwFL5R/ZPzHeK8TmaMemXr5OzTrBOz/QQuT3RlJfr19bZBidt9y0YYz
         vEe6VdbfBhDjwT13E78gBjpC/2tjArWvZrDqt6GD0gnQy0Ne2Ffp8WsqlFRQ+UHVkyFk
         D9WCGqKnEMdOL8USf7m5XSkxUiCujZEGuWHCZ1ix9x9PYFSeNW3eNVpSTRALFHnUbDSf
         sIPNjIU6GYTkEBwUGzeOB3s2b7baTXGFfm+GRebC4WjuIz/SuX6MYuN/b26n+K7N3AxI
         z7Tw==
X-Gm-Message-State: AAQBX9cFunlaiWkAwlX90YvQCZejGOCZy0r70YwsBYEX9PJqrn+mzMWg
        rpv+JbpFbDAvjsZWHz3Z6ie0cQhACPryrg==
X-Google-Smtp-Source: AKy350bQy/d5cllAu41FyjxA49IDgFPvGdIXlivDwHh6nTQZvGv8ppizRoQul+g2+v4oeP92qA5o7g==
X-Received: by 2002:a5d:4f81:0:b0:2fe:c0ea:18b4 with SMTP id d1-20020a5d4f81000000b002fec0ea18b4mr3916354wru.24.1682077618931;
        Fri, 21 Apr 2023 04:46:58 -0700 (PDT)
Received: from localhost (fwdproxy-cln-031.fbsv.net. [2a03:2880:31ff:1f::face:b00c])
        by smtp.gmail.com with ESMTPSA id l9-20020a05600c1d0900b003f17eded97bsm8075706wms.19.2023.04.21.04.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 04:46:58 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, ming.lei@redhat.com
Subject: [PATCH v2 3/3] io_uring: Remove unnecessary BUILD_BUG_ON
Date:   Fri, 21 Apr 2023 04:44:40 -0700
Message-Id: <20230421114440.3343473-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421114440.3343473-1-leitao@debian.org>
References: <20230421114440.3343473-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In the io_uring_cmd_prep_async() there is a unnecessary compilation time
check to check if cmd is correctly placed at field 48 of the SQE.

This is uncessary, since this check is already in place at
io_uring_init():

          BUILD_BUG_SQE_ELEM(48, __u64,  addr3);

Remove it and the uring_cmd_pdu_size() function, which is not used
anymore.

Keith started a discussion about this topic in the following thread:
https://lore.kernel.org/lkml/ZDBmQOhbyU0iLhMw@kbusch-mbp.dhcp.thefacebook.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 3 ---
 io_uring/uring_cmd.h | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index a1be746cd009..743d1496431b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -71,9 +71,6 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	size_t size = uring_sqe_size(req->ctx);
 
-	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
-	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
-
 	memcpy(req->async_data, ioucmd->sqe, size);
 	ioucmd->sqe = req->async_data;
 	return 0;
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 7c6697d13cb2..8117684ec3ca 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -3,11 +3,3 @@
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_uring_cmd_prep_async(struct io_kiocb *req);
-
-/*
- * The URING_CMD payload starts at 'cmd' in the first sqe, and continues into
- * the following sqe if SQE128 is used.
- */
-#define uring_cmd_pdu_size(is_sqe128)				\
-	((1 + !!(is_sqe128)) * sizeof(struct io_uring_sqe) -	\
-		offsetof(struct io_uring_sqe, cmd))
-- 
2.34.1

