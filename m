Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2175372A240
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjFISbj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjFISbi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:38 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F83A81
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:34 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7748ca56133so19063139f.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335493; x=1688927493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58rvLYLUk8/S4pLP2TEKpTK3rfvG+0uSTMDF12Jv7EE=;
        b=V2QKKykZPPVpCqP6Tp+YZ3SHnKkz4Y9H3rEGXl9Ktf9gXRaOWgqD44erKTwbs5ACbE
         YixYWeybo8NvNoFHs8gy9hfvShmazIr/epu7G4w+eANKaclmioyZWp8QZ21TEuLroud+
         cIXm1o02Dpm3Ra63sgANhSn8kK3WPUmjnXUsD/ggGswAt0h4c9Upjc1sPBJqsdvogCgd
         f0I3Cj3uvS/PWDHWe/zr0+XQXlfmp6AysD+hf2kk5DeBXPnYEUwzQFaO2lIeVWJGtwD8
         MR8vTLY1FF5eohByBIgeNqaiq/96TeHtECIsOOnbwRQxXvRBdWbhzJ1BH9BKN7XDKhls
         CTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335493; x=1688927493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58rvLYLUk8/S4pLP2TEKpTK3rfvG+0uSTMDF12Jv7EE=;
        b=M5JrCgltzUWCM+9QSJjvJI3o360ZLdpTgvoDV3Ed4ggJmH9m6kXmfv2FvNuZp3LI/H
         GTGxC4Yiz7qIUZiCqQwp29M9v1DLM1NM9ddk94ltAMJYcX5j3ZZPYJQxO4gQTlbkFeo3
         kre/Rx/6kVmoHQi39zdAL2riIoaJJzLCaYwS+ZUH4djhnJfEXhEk6vzvDc4ZoxZPPN+L
         X0oMPMFmVuT5URoXHeFxDOztH7gPIwAPBIOTK05sJB7gZkii2nNgT4YJeBMGF3j6Zq1G
         iSZdMKnr1xKeANY34ys+wo1FAVOgEYstQS2LorvJ/1cc7PoKBAr9/3rGG7RF/McIBcIj
         y91A==
X-Gm-Message-State: AC+VfDyQibWx3zd27gwlOuBXGMsGQee6voZJXhGF6UzsdmSK+Icawgc7
        kcQvujTgcvkQCepcG/LX71/A/q/YJhAUuUr59RM=
X-Google-Smtp-Source: ACHHUZ62X5wmEsLFwnn8/vPAqNcIZVDyUcrTecrKXLRAgcCSPCCgUKrvNqo/wmDqMJqVdiWjJgADeA==
X-Received: by 2002:a05:6602:408b:b0:777:a5a4:c6cb with SMTP id bl11-20020a056602408b00b00777a5a4c6cbmr1919989iob.1.1686335493619;
        Fri, 09 Jun 2023 11:31:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] futex: assign default futex_q->wait_data at insertion time
Date:   Fri,  9 Jun 2023 12:31:22 -0600
Message-Id: <20230609183125.673140-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609183125.673140-1-axboe@kernel.dk>
References: <20230609183125.673140-1-axboe@kernel.dk>
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

Rather than do it in the lower level queueing helper, move it to the
upper level one. This enables use of that helper with the caller setting
the wake handler data prior to calling it, rather than assume that
futex_wake_mark() is the handler for this futex_q.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/core.c  | 1 -
 kernel/futex/futex.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 6223cce3d876..b9d8619c06fc 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -556,7 +556,6 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
-	q->wake_data = current;
 }
 
 /**
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 1b7dd5266dd2..8c12cef83d38 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -171,6 +171,7 @@ extern int futex_unqueue(struct futex_q *q);
 static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
+	q->wake_data = current;
 	__futex_queue(q, hb);
 	spin_unlock(&hb->lock);
 }
-- 
2.39.2

