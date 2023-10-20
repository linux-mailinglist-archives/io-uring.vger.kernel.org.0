Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C0C7D109E
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377360AbjJTNje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377074AbjJTNje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:34 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2509DD4C
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:32 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso129873766b.2
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809170; x=1698413970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPvWh+kMxMBw+crBdqTX68BCRqpRuCu5+S8tdbJ+E7k=;
        b=D5JfTCa9hAnkyn2fq5wiJowtypyfDLVsIpcBi1QkRWMz5AgSkZcvYmWymGSP28+yGd
         2h1jGLdTf7HWyUST/dypXC3igxaVKWKQkHcuoKRG2Vcd1Kqzd0oeAM/BclqE/fXpGfA4
         fxOql/FiqC7kQeprhLjvYP1wr5EspfBPU2FEHtpuF/VoI/UxVbEa+V/qLYx4OCC1gPrA
         eyI0vGcTiVBEGabdFpvg4nBz9L8pot9s7PqNpxTjpQI+fikhhJ3V9HP+dbog+yI2AIe+
         /vItC0BH8nbOk0EKpjhaZOw0tv2CWZ5vWnQ44H72HuSxO7hEFmYce1vNL2/b8b7KsbJZ
         E6rw==
X-Gm-Message-State: AOJu0Yyvxu4+p/N3lopDDoMKXZMnnoRzEhMfEv7OnFTL5foi6kCgEeGm
        9QYnIkti9g36W77sDiupglQ=
X-Google-Smtp-Source: AGHT+IHoEegdAPZwCSmjvl8uMk4AnbxESzhe35wzC+mgr6chX67iONUumG/LtGIM1Y+DTTK9YOBVdQ==
X-Received: by 2002:a17:907:3fa2:b0:9ae:56da:6068 with SMTP id hr34-20020a1709073fa200b009ae56da6068mr1349387ejc.57.1697809170045;
        Fri, 20 Oct 2023 06:39:30 -0700 (PDT)
Received: from localhost (fwdproxy-cln-011.fbsv.net. [2a03:2880:31ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id 29-20020a170906001d00b009875a6d28b0sm1512427eja.51.2023.10.20.06.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:29 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 2/5] liburing.h: Populate SQE for {s,g} etsockopt
Date:   Fri, 20 Oct 2023 06:39:14 -0700
Message-Id: <20231020133917.953642-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
References: <20231020133917.953642-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current io_uring_prep_cmd_sock() liburing function is not populating
the SQE will all the fields because the kernel implementation was not
ready.

With the integration of the kernel part[1], populate the SQE with the
missing fields (optlen, optval, level and optname). This enables
the usage of this function to prepare commands that executes setsockopt
and getsockopt operations.

[1] Link:  https://lore.kernel.org/all/20231016134750.1381153-1-leitao@debian.org/
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 CHANGELOG              |  4 ++++
 src/include/liburing.h | 11 ++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/CHANGELOG b/CHANGELOG
index 42a7fc1..61199e2 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,3 +1,7 @@
+liburing-2.5 release
+
+- Add getsockopt and setsockopt socket commands
+
 liburing-2.4 release
 
 - Add io_uring_{major,minor,check}_version() functions.
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 1008544..84400ea 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1129,8 +1129,6 @@ IOURINGINLINE void io_uring_prep_socket_direct_alloc(struct io_uring_sqe *sqe,
 }
 
 
-#define UNUSED(x) (void)(x)
-
 /*
  * Prepare commands for sockets
  */
@@ -1142,13 +1140,12 @@ IOURINGINLINE void io_uring_prep_cmd_sock(struct io_uring_sqe *sqe,
 					  void *optval,
 					  int optlen)
 {
-	/* This will be removed once the get/setsockopt() patches land */
-	UNUSED(optlen);
-	UNUSED(optval);
-	UNUSED(level);
-	UNUSED(optname);
 	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
+	sqe->optval = (long long unsigned int)optval;
+	sqe->optname = optname;
+	sqe->optlen = optlen;
 	sqe->cmd_op = cmd_op;
+	sqe->level = level;
 }
 
 /*
-- 
2.34.1

