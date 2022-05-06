Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D86B51D1CA
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386459AbiEFHEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386846AbiEFHEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7284B4BFF9;
        Fri,  6 May 2022 00:01:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k1so6565338pll.4;
        Fri, 06 May 2022 00:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4H/ujLwZkevJ+kG7X3STChb0etd+nfQjZIW+BhHkzQ=;
        b=XUsDqZyOfidnyER7oZHobTEXif6iB2Zft2CeI23d+NqfP7AG1NC3Q9qji6BUQXINFE
         QohXu3VmT9LU1s7SIpVl0+Ba6hsNs5aqTVpjh5vu+YLUmM8PEB/eCUx9Mg96hY0lQ7d/
         6ZE/dynGBZxGrgwV+EHrRkjWiQ5Kkbw6u4IApJcB5foRF1/4iHX3o8+LyiMGUmtXeNCl
         eF5E8W+HRZg66Nck4WYi72+f/RaaWT18oUZduypAKU7neKgBZJm3k20gu2L4dNzpr86p
         VyInWAHDZnLRR9XHOLzxfnKQ5aClNHbWfkPsr8PB8l8UNIJpEZixUQpQmrJoCanoVp/U
         r0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4H/ujLwZkevJ+kG7X3STChb0etd+nfQjZIW+BhHkzQ=;
        b=6VT5sy9MQjlGH+D4lw8dWnUNpSfuaXDICjchufAYrH9E1G8id1QRwkE54JAOL49Mpx
         RMaZlq8uqIAL952+0a5f7YMRx/6OZhGSTAZP2FQTJrGgoPZ7wSm8wmHivGa2Qot8ky5W
         vl7BPsKS5Bg0a7ujwBhkXWUrfz/LlQcSiN3aja2uRKgva9IyFxyb6kkoqf+yTSWWEZSN
         G9cjVD1WMu0clUd3Tu6qJ6y2f+9nA7vUg98Kj1OGpgYYmK2P2p95Y6/1f3B00tXTP0Us
         8ZnSVY52Wu6QDj21LNQsdD2lud093bMqh6Yz/B6EPRTnl987fNjYMxXsYQqS0oJXFzUh
         I8Tg==
X-Gm-Message-State: AOAM531kILJOTUOtHVulRpXoda+J/vqyXphNjRxp85A/PQxENNnrrA+h
        nzTbWa0pdzpMuj+NKy95x9ytRI0Ujuc=
X-Google-Smtp-Source: ABdhPJxzWehS2TRMetLSpGJsTjNE4wMqT85i9y24tT6h9YxGwkCmceawoI5H+G7TlsEP1yGpa4tpCg==
X-Received: by 2002:a17:90b:4b4b:b0:1dc:8724:3f75 with SMTP id mi11-20020a17090b4b4b00b001dc87243f75mr10602435pjb.178.1651820461859;
        Fri, 06 May 2022 00:01:01 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.00.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:01:01 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Fri,  6 May 2022 15:00:58 +0800
Message-Id: <20220506070102.26032-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
support multishot.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fad63564678a..73bc7e54ac18 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -213,6 +213,11 @@ enum {
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 
+/*
+ * accept flags stored in accept_flags
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 15)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.0

