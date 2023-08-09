Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC50E7768FF
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjHITnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjHITnN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 15:43:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C232A10F3
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 12:43:12 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6873f64a290so23863b3a.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 12:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691610192; x=1692214992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVHXPxLmxfd5CWTOTrBfmptnMeO3orQcJQg34vrpu6k=;
        b=BuW8gzX2IVPME+eQoZrjHuxemw2dByucIImWWi4Y3OLhj8sePv4NAZUuFPXz9eCaWE
         +rz8y04w77xwCj9vF9yCh7D5i7OlRg/xyBxSPUU4y13mnwVH0ST1Sfj8leMQZmXPaH3y
         QboEvRQW+11++rtmgqMgF3Xaz6wjJZkafdAXp/V+yY8Mpxay2Ta2HwFDsJHw2wrKQLqA
         b0RMU1tfkS448sXWfzxN72hDeH1MQ+sen0IuHNi3KW3cQP5NzthR/MfpwLFlPK8XZUG+
         +ZFXSFsG+ext42TH59q5PYQGbFCHCMrE9sJ2GaMYC2w7jfR6nQmerI8FnVN4JJH+lGKC
         x+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691610192; x=1692214992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVHXPxLmxfd5CWTOTrBfmptnMeO3orQcJQg34vrpu6k=;
        b=aXG+v1ioNEBL4RuQrXNmqz91eIDvAZohAne+2RNBGEqn6NR8trHdtP30bCIRTLhmKU
         CkCRYDil/zxhm99eGv3DXKAgvT7NblEypse75u2s8fKkCLHlL/DSo9r4HIg36i/XBQFb
         qb24LCtk0Z42uOEP7S1k/Ismgn7jW5tMXTNjPDsm5Hq5L/6tIHNRgndmAjWcOANPRDcn
         VW1Lwh8CAs7gEiHAoYikVzT+OcVwh+ccsNfACgmbB0RGBjGN4XReaSrygNm7y8futZ95
         n0xqyUOf8dRKJn6Syj4dOFUYkH4VGcPlWddJOshukXF1Ovh9wY2abDnfRFYOmRnBpUAu
         +h1Q==
X-Gm-Message-State: AOJu0YwxwCqrMnsMZiAdB/9zEDgjgbuK+IcD/9u7UHJMmsJxvhsQWv6W
        GE7gv8LyDpFbHQyPQaAW1dlY3Q4D1v7/ojuTmiE=
X-Google-Smtp-Source: AGHT+IH5S02ZwEgRA6kg7g+bXpoVaHnAlRHNbHivQ0GffdbvDPd7jnKL3Bsp0ocH/Z+YFCAvdjoRTw==
X-Received: by 2002:a17:902:c952:b0:1b8:aded:524c with SMTP id i18-20020a170902c95200b001b8aded524cmr126993pla.1.1691610191800;
        Wed, 09 Aug 2023 12:43:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902eb1300b001b8953365aesm11588919plb.22.2023.08.09.12.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:43:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/io-wq: don't grab wq->lock for worker activation
Date:   Wed,  9 Aug 2023 13:43:04 -0600
Message-Id: <20230809194306.170979-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809194306.170979-1-axboe@kernel.dk>
References: <20230809194306.170979-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The worker free list is RCU protected, and checks for workers going away
when iterating it. There's no need to hold the wq->lock around the
lookup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 399e9a15c38d..3e7025b9e0dd 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -909,13 +909,10 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
-	raw_spin_lock(&wq->lock);
 	rcu_read_lock();
 	do_create = !io_wq_activate_free_worker(wq, acct);
 	rcu_read_unlock();
 
-	raw_spin_unlock(&wq->lock);
-
 	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))) {
 		bool did_create;
-- 
2.40.1

