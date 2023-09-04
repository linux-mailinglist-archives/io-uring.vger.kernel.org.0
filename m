Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9790F791B75
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353279AbjIDQZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353298AbjIDQZg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:36 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132E0CCB;
        Mon,  4 Sep 2023 09:25:31 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-99c4923195dso251581466b.2;
        Mon, 04 Sep 2023 09:25:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844729; x=1694449529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gptGKutv8UrS/zDN0Qmum7MxSe9eEjLIE1n6bMLfanE=;
        b=PPiJxb2qVfCCL7JplmxT7GpqZWbDxxtRVA6QNPI+6ywvM8txikQnwDWRJyP40ZS86d
         n20kb83lAiRu/OCx45n1nOEtaQL2cZUPSSPzyHguYVzWN35NNQnRwaQGvJc0MaD5AtK8
         J89j60/uh6p93PPIq4nbp1J9Fk6koEU5MOCa0NjYwaHIEVCQMVQfxL93DSvipAIfkyYp
         K1Eyb3pASZDPnvoojD/O+cbAQq9arYFNpSQsPmxZd/VUtEJd15sKpvNzjfXHNvqDhNrH
         a5VezUoT36IVGNVgM4PfXp2lbEosv3zHlol9FgwWhvHuDYfh8GHqOduz5NGbKtiXrfQ5
         UXwg==
X-Gm-Message-State: AOJu0Yz/UouvmosxcTvpkd7W1i4Ozljt4hkTT2PpMJ50DDUalGrShAjr
        JLfFTQfLg2mje+lpt9b87ow=
X-Google-Smtp-Source: AGHT+IFo6xxnSKt/kN/bp1HywJmCyJh2XEsoJurKM5LSZG5dZcn95+mnh9oQe7tD1zkAgGEtZ2MM1g==
X-Received: by 2002:a17:907:d690:b0:9a2:2635:dab6 with SMTP id wf16-20020a170907d69000b009a22635dab6mr8211523ejc.47.1693844729572;
        Mon, 04 Sep 2023 09:25:29 -0700 (PDT)
Received: from localhost (fwdproxy-cln-000.fbsv.net. [2a03:2880:31ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id se22-20020a170906ce5600b009a1dbf55665sm6365416ejb.161.2023.09.04.09.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:29 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v4 05/10] io_uring/cmd: Pass compat mode in issue_flags
Date:   Mon,  4 Sep 2023 09:24:58 -0700
Message-Id: <20230904162504.1356068-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a new flag to track if the operation is running compat mode.
This basically check the context->compat and pass it to the issue_flags,
so, it could be queried later in the callbacks.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/io_uring.h | 1 +
 io_uring/uring_cmd.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..bc53b35966ed 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -20,6 +20,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+	IO_URING_F_COMPAT		= (1 << 11),
 };
 
 struct io_uring_cmd {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..60f843a357e0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -128,6 +128,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
+	if (ctx->compat)
+		issue_flags |= IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
 			return -EOPNOTSUPP;
-- 
2.34.1

