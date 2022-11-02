Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE292615D9C
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 09:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiKBIZM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 04:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiKBIZI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 04:25:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8373EDEDE;
        Wed,  2 Nov 2022 01:25:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 128so15637603pga.1;
        Wed, 02 Nov 2022 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hRyHMgHaSqkNxbbATyAsbyQifwj1DbDNtGJlZ1TH0ZA=;
        b=glKaTqBbaso1cyJebYMm+yYb/7RCFfKIbT9tq16O+aXrjgnPNUFRWWSgB//ZsKgsJc
         Ea/4HuATjpvqm5DyXdrBS9IqpILxOl3zz6mozZ21zMQWpJ5CN7amfttuyRcVaXkzlnfI
         Z2gkcLyCfacqWqC1m1Mz1CONAs1A+o5liXo6Hd0sgvb77Jmp2S176+5sE+97QkSy1SKX
         BiCXJA1refmnV9+92jHvzVyaF3yc03RC4MbrRCEYl6QsaDyCvFFURYyZBqxMAFUSfoeP
         UvINmRnoRsOh7cEusj4tbJwhQ0vtzF5yhlpyRcFF9jePUrYwCJLKXRUHLRl76SyqHgyd
         McLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hRyHMgHaSqkNxbbATyAsbyQifwj1DbDNtGJlZ1TH0ZA=;
        b=J2EIk7Gl8QhXe7SxOPs+7sBEUgv88/DwekLz823l6MRqB8fd1JjALqLbjzT2zRNZqH
         W5FB3FKum/Aea9vBYVp8XE8PwM4j93cCIUflwJvvj2dwt5VNFGSg1xVkuXmAhti8Hrta
         kC7J224TCuHfNgg9tlY++9AG6ZowuZjhUU1N/rDShN8nY8u1VLSiRFzuoxXTGAH6eQKV
         ZWmdCg2kQszLQt1aAaxlhFKNcuJn9ljVvWcdxRmABWcVSv/MlQkAmaxQP+t/m22xbK7/
         EeGY29HK8dtpRtSnvhJb2bA5UR+Lpcapb01i4u7vPd1prALccM20cmcSkoZMTXVJiqpb
         UOjA==
X-Gm-Message-State: ACrzQf3q9FsOvgZYbgxrUvXvPVnw+cSNen65fV0Smk7UXKWMlDvi/wDX
        16S2UJAEVtRHtWQUYYgAtcDBAwrGiLxc24cg
X-Google-Smtp-Source: AMsMyM48TS22Xlfj8eNZNl6ciP8mJyynC2qRJitOTv4mebnMm9o/NmQ1UHUCrQa87jPY5HpLJ56pOw==
X-Received: by 2002:a05:6a00:1304:b0:555:6d3f:1223 with SMTP id j4-20020a056a00130400b005556d3f1223mr24104749pfu.60.1667377506878;
        Wed, 02 Nov 2022 01:25:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id w9-20020a17090a780900b0020adf65cebbsm907009pjk.8.2022.11.02.01.25.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Nov 2022 01:25:06 -0700 (PDT)
From:   korantwork@gmail.com
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] io_uring: fix two assignments in if conditions
Date:   Wed,  2 Nov 2022 16:25:03 +0800
Message-Id: <20221102082503.32236-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Xinghui Li <korantli@tencent.com>

Fixs two error:

"ERROR: do not use assignment in if condition
130: FILE: io_uring/net.c:130:
+       if (!(issue_flags & IO_URING_F_UNLOCKED) &&

ERROR: do not use assignment in if condition
599: FILE: io_uring/poll.c:599:
+       } else if (!(issue_flags & IO_URING_F_UNLOCKED) &&"
reported by checkpatch.pl in net.c and poll.c .

Signed-off-by: Xinghui Li <korantli@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 io_uring/net.c  | 16 +++++++++-------
 io_uring/poll.c |  7 +++++--
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..cbd655c88499 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -127,13 +127,15 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
-		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->netmsg_cache);
+		if (entry != NULL) {
+			hdr = container_of(entry, struct io_async_msghdr, cache);
+			hdr->free_iov = NULL;
+			req->flags |= REQ_F_ASYNC_DATA;
+			req->async_data = hdr;
+			return hdr;
+		}
 	}
 
 	if (!io_alloc_async_data(req)) {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..4b3b4441e9ca 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -596,10 +596,13 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   (entry = io_alloc_cache_get(&ctx->apoll_cache)) != NULL) {
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->apoll_cache);
+		if (entry == NULL)
+			goto out;
 		apoll = container_of(entry, struct async_poll, cache);
 	} else {
+out:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;
-- 
2.34.1

