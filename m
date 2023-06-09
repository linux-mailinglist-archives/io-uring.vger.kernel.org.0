Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4487672A243
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjFISbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjFISbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:43 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874323A84
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:36 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33d0c740498so911505ab.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335495; x=1688927495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRFuYQO+GGntnur6QkOmgAEvI9IAoRPXEikEtEaQgPY=;
        b=xCeg8Ros7YbjjJT626pLIvGcaxRdub/hwwYnfOoLo0mpbMOEty68oWAs1pFX0BUIn5
         acIx8gPhaTut01q6OmTK1casdw9FSlxU05loZN+zDS0rTvKBo1N7XVHat+FfsH16v1XN
         O+1M18A9TIPKb4XA3aovBujsWskltYqYcMjD39CcTsJNHk7gSxwWurAf5gXo3R020A/N
         vmaWHMgUa7D6JVIfRl0e/0llXUESOha1CQBK5RgwW6FlcygREQeYKrRttDndEAcEc3Aw
         IL1G3Ram44rHERNryKZrF6y7544YoPhX+VBcbN49xF2n7T1kYZewD1usvhZ+IzL52Ubb
         MF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335495; x=1688927495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRFuYQO+GGntnur6QkOmgAEvI9IAoRPXEikEtEaQgPY=;
        b=PXoCTGSYpQMspgCaAVMiI/gXRue/MaXBNs062ruowOjyhYzNn9sGylkpQr6jxjtVTv
         u/6VntzfmBHt+HmEUa56qnTlNi1VnyBkCrmtyNCKjgHII3yY5KOYAslrtJ/xxdqf2QXO
         rtCO0OVwjpqvC3lWM49NuAHtxFpmex02Ab+WtzaWZuckV8AYf2wHuXkos7B/iKct4F7f
         7fV08e8TJDF4RSCSaPgWSzGvjYKKPES7KSbQHV21BTv4uRwlFp5SgKe+loKqJ/gGRNDo
         CX5ehSRosWS2Uhpsmcpkdm394+wIw8b/k0srWnVeubtDhV9S8kS6eGs7rTjpic/W6tnt
         te5Q==
X-Gm-Message-State: AC+VfDxNtt4UA1oQyiiOeBUVI24baYf+uJ9DLwVKkmMnGzltosivFnqW
        KOLdWMLP+4vp1K0QkmwmxZUpL3xRoArHzMsTxXw=
X-Google-Smtp-Source: ACHHUZ6K/g6dGq+RJ+YZKMDYTxy0K6ukZh5B9fgKwuF2awPZul2oN7ecfz3jO8pgZ0bvsRXHyataug==
X-Received: by 2002:a05:6e02:188a:b0:33b:583d:1273 with SMTP id o10-20020a056e02188a00b0033b583d1273mr1968012ilu.1.1686335494951;
        Fri, 09 Jun 2023 11:31:34 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] futex: add futex wait variant that takes a futex_q directly
Date:   Fri,  9 Jun 2023 12:31:23 -0600
Message-Id: <20230609183125.673140-5-axboe@kernel.dk>
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

For async trigger of the wait, we need to be able to pass in a futex_q
that is already setup. Add that helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    |  3 +++
 kernel/futex/waitwake.c | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 8c12cef83d38..29bf78a1f475 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -156,6 +156,9 @@ extern void __futex_unqueue(struct futex_q *q);
 extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb);
 extern int futex_unqueue(struct futex_q *q);
 
+extern int futex_queue_wait(struct futex_q *q, u32 __user *uaddr,
+			    unsigned int flags, u32 val);
+
 /**
  * futex_queue() - Enqueue the futex_q on the futex_hash_bucket
  * @q:	The futex_q to enqueue
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 5151c83e2db8..442dafdfa22a 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -706,3 +706,20 @@ static long futex_wait_restart(struct restart_block *restart)
 				restart->futex.val, tp, restart->futex.bitset);
 }
 
+int futex_queue_wait(struct futex_q *q, u32 __user *uaddr, unsigned int flags,
+		     u32 val)
+{
+	struct futex_hash_bucket *hb;
+	int ret;
+
+	if (!q->bitset)
+		return -EINVAL;
+
+	ret = futex_wait_setup(uaddr, val, flags, q, &hb);
+	if (ret)
+		return ret;
+
+	__futex_queue(q, hb);
+	spin_unlock(&hb->lock);
+	return 0;
+}
-- 
2.39.2

