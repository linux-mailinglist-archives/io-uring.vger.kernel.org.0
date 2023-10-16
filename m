Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7F87CAADB
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjJPOCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjJPOCN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:02:13 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A68FA;
        Mon, 16 Oct 2023 07:02:07 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso738058566b.2;
        Mon, 16 Oct 2023 07:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464926; x=1698069726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+1IratzCwRElqGveWEFhyqeH/oYCw38flsead1Kukk=;
        b=odDokHQE8P3E56FUu42jksy1Av+ieE2a5YsXEPWdEfrvsUuECO6AEFHt/MYSpIGS/8
         WhAx7yPgdZG2M7OgvKC4d3GBXgHl1ydlDnNKsJIvpN9nTgJ3C2L1aPUZYxpbGBH+pPQH
         2ORS9iRAW5hIC0rHMiXvhylhDlh2pFfORu4/Q8eTpjHGncwrHUZQlQcpZG2KuYA8mU5s
         pF5GmTD43sEhy946ihSEmjauGL2a9r10rNUAN14JXLoQx/lxLh8UHt7XF1corsBKmerz
         8i1Bm2Y7MGWAvOc80zZOt+5niJVXCPTexTTs0W3Uj+7EyTNbNsXH1cep53gsWFXhuT6H
         oI4Q==
X-Gm-Message-State: AOJu0Yzotkr0i+58a9kykLK9Ea5Vl+Wu0Uf5J7sZ/7AhwQi21Ry8+BRL
        /69tHX/Ym1Zm18LArKrkgTc=
X-Google-Smtp-Source: AGHT+IHIsRRPxvGmUNafNTdOb4Jjg58zUoVbjH0qpqprTYNhKgJKU32t1NuqnNL7u1YlCPcJp4oWBQ==
X-Received: by 2002:a17:907:d24:b0:9bf:697b:8f44 with SMTP id gn36-20020a1709070d2400b009bf697b8f44mr5817823ejc.6.1697464924186;
        Mon, 16 Oct 2023 07:02:04 -0700 (PDT)
Received: from localhost (fwdproxy-cln-017.fbsv.net. [2a03:2880:31ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id jz28-20020a17090775fc00b009ae57888718sm3997303ejc.207.2023.10.16.07.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:02:03 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 08/11] io_uring/cmd: return -EOPNOTSUPP if net is disabled
Date:   Mon, 16 Oct 2023 06:47:46 -0700
Message-Id: <20231016134750.1381153-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Protect io_uring_cmd_sock() to be called if CONFIG_NET is not set. If
network is not enabled, but io_uring is, then we want to return
-EOPNOTSUPP for any possible socket operation.

This is helpful because io_uring_cmd_sock() can now call functions that
only exits if CONFIG_NET is enabled without having #ifdef CONFIG_NET
inside the function itself.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/uring_cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4bedd633c08c..42694c07d8fd 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -214,6 +214,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+#if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -240,3 +241,4 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
+#endif
-- 
2.34.1

