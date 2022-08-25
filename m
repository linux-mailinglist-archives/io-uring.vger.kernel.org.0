Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959B35A0D9E
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbiHYKNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 06:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiHYKNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 06:13:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6063AADCE8
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 03:12:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u9so9573700ejy.5
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 03:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Gz4zdfcH/fm7eXuS0+g9vJyGqd48yzhL7ftHLrC6etM=;
        b=buZhHZnLOVF8KDzEKPP1z/W4sn2JBBv1xt4paWAvog42NGmi3RVeGYxjPer8wGze4z
         SRpO4II/Q0SCX93xSFkfeTI0UQ9G5zShdVo+HFzg+rcAjGV6T0pIiDwQVvb/eKWJWyt2
         OoJZ3cNlvEBtLmQPgVfH5m4nTTpMDp8Vm0//K8lSVxxKVAop5wAhgIpO+rMN9c+z7hZX
         DVnoPCZEYoPS5vAw2oCKr5TZLO56F5IBmUtpseUYRLSK9sKqTm0KuHmKWCZajdbsxEwv
         qrLDsBnks/T6d6jQvmLL8cxjpGWkgKoPAyZFdItgHU6aVC3wK3aVQgD0AB5jPffgaHyj
         ru1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Gz4zdfcH/fm7eXuS0+g9vJyGqd48yzhL7ftHLrC6etM=;
        b=JhAeXJDkREcsFOCA9Qnb4FDlTpiKZYIxVGq/8bT3AfKe552negWDpXECW3ZryD54/T
         MHnpFFK6Wz72eZ25xNX5qAvKK8wdeczTP5xW9KS/jcxdKiQXAo1f7kKsC/ionLI8CPQE
         dvjCTum6okB11kP4MqGmReXgsdSuGNOY7A8GzOnLLOT2pp0RmTWC2/hH4rJRqLEceoHZ
         qV5QOpfRLloLVuMRyFPqqpSK81b6Wkkbrtk/8LdhTQSuXh8kTQinUHRb5Erl2YEr1UYS
         SO3K/Vf79u3ng6hJnkI6KZ+/fgRZ/X3gESS0cwbCfrVkcNwKxYVmQlMlQE034Q2UzYya
         emAA==
X-Gm-Message-State: ACgBeo0U+Mmyoxay7jqeurFTto8fHaidT68WxchW668RKit0V6zDqzls
        L2aOGzMf0A5wVMT6C+yvFnt5xeNK4APiPQ==
X-Google-Smtp-Source: AA6agR593m5R8owVZGfl+uNVGs0m2gYcu67S0tt53auCC2ZWbqnIPB7vm2kCgH2684HS3RUQw70yZA==
X-Received: by 2002:a17:907:9814:b0:73d:cb9f:c0b8 with SMTP id ji20-20020a170907981400b0073dcb9fc0b8mr1990737ejc.648.1661422377490;
        Thu, 25 Aug 2022 03:12:57 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:6d47])
        by smtp.gmail.com with ESMTPSA id lb11-20020a170907784b00b007307d099ed7sm2217696ejc.121.2022.08.25.03.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:12:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH] io_uring/net: fix uninitialised addr
Date:   Thu, 25 Aug 2022 11:11:05 +0100
Message-Id: <52763f964626ec61f78c66d4d757331d62311a5b.1661421007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to initialise and set addr in io_sendzc(), so if it goes
async we can copy it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4eaeb805e720..0af8a02df580 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -975,7 +975,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct sockaddr_storage __address, *addr;
+	struct sockaddr_storage __address, *addr = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 	struct io_notif_slot *notif_slot;
@@ -1012,12 +1012,13 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		if (req_has_async_data(req)) {
 			struct io_async_msghdr *io = req->async_data;
 
-			msg.msg_name = &io->addr;
+			msg.msg_name = addr = &io->addr;
 		} else {
 			ret = move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
 			if (unlikely(ret < 0))
 				return ret;
 			msg.msg_name = (struct sockaddr *)&__address;
+			addr = &__address;
 		}
 		msg.msg_namelen = zc->addr_len;
 	}
-- 
2.37.2

