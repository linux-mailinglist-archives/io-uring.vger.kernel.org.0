Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC645094AA
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 03:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiDUBmg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 21:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383657AbiDUBma (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 21:42:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3638D1573F
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:43 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so3424259plg.5
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sE6MbuGzDdOmszMq7QI+E6tmyTZCupPhHYbF+23tiLc=;
        b=SGfz/0h/ihfU7lFbzLbQbrADMLuoJ1rH1czYowCBHK4OgSxmC/Ex8zDD6krLus3SYj
         5lfBVirGc2AF4m/jv3f9rZcv6MA56VoryxBuHyZYjZFsdRArYzCoiEG7+WeQgXGWmlBT
         cpR1BFBsNSVSgv5jnOq6vVnghjkexHSawGFqiQ7chUNvVK3gQxousncLJ8IOko2mf4xz
         UaM8M/Aq6SKYaZH0aA8NHCavP5nmK5LN1q9UuljkxDWr/eis00TR4EV8NfJjnEGbQYba
         lZBsy8ovBACfa01k4H5GZ7vbwTopiRnE8W5+07l/RrSnc2y9fevO38+a/SWIGZP4OHMu
         ZgKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sE6MbuGzDdOmszMq7QI+E6tmyTZCupPhHYbF+23tiLc=;
        b=TC5z72Lo6SXtE6R+G9AtWqY6RqPETcVvHErHK2wK+amYqXrDSsnf4UxNpXd3pGqYI4
         4hjUHav0+HBW8+9XbWuzkCzVw2Tve2+mY0bxVgKyPlIaDcg/JdP1RwL27OjHNrkaTo0v
         8WjNjiJFeiwZrQqnatZHGlXjEIbgUhuzlCYV/D1BLBlUqQ69GASFRIciW2Wc+PYAuWna
         Gpz/tZySU6X0Vg0L+79XhEAS4LM+tb3+x2u3T4uBdb+DeU3Kxx0N0UV0XDz6l4nTUNxr
         zbjctIguqQ44bVQVJ6m2bT2Y7vHeGvVjO7EihyKLGsL6+lfECp12IW8NO34T6p0B7O1i
         7FpA==
X-Gm-Message-State: AOAM531EWaUJh0tda6YUxDRlwLMG3hGvhVEi3+oZEQkKaWKYcuWJUcBl
        l23NPYQBdQHA6s7a32q5Z6jdlelav7lB2ThY
X-Google-Smtp-Source: ABdhPJykmmJdazCuqWOhqQvog2pbWF4c3MqHogutz0a5rqoWYL//76mKEv+T0jq4RAoWf/DgFIiaLQ==
X-Received: by 2002:a17:90a:d082:b0:1ca:be58:c692 with SMTP id k2-20020a17090ad08200b001cabe58c692mr7670111pju.238.1650505182483;
        Wed, 20 Apr 2022 18:39:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x16-20020a17090ab01000b001cd4989ff4bsm460115pjq.18.2022.04.20.18.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 18:39:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: allow re-poll if we made progress
Date:   Wed, 20 Apr 2022 19:39:37 -0600
Message-Id: <20220421013937.697501-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220421013937.697501-1-axboe@kernel.dk>
References: <20220421013937.697501-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently check REQ_F_POLLED before arming async poll for a
notification to retry. If it's set, then we don't allow poll and will
punt to io-wq instead. This is done to prevent a situation where a buggy
driver will repeatedly return that there's space/data available yet we
get -EAGAIN.

However, if we already transferred data, then it should be safe to rely
on poll again. Gate the check on whether or not REQ_F_PARTIAL_IO is
also set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f06c6fed540b..6a4460cad9c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6263,7 +6263,9 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
-	if (!file_can_poll(req->file) || (req->flags & REQ_F_POLLED))
+	if (!file_can_poll(req->file))
+		return IO_APOLL_ABORTED;
+	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
@@ -6278,8 +6280,10 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	}
 	if (def->poll_exclusive)
 		mask |= EPOLLEXCLUSIVE;
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    !list_empty(&ctx->apoll_cache)) {
+	if (req->flags & REQ_F_POLLED) {
+		apoll = req->apoll;
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+		   !list_empty(&ctx->apoll_cache)) {
 		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
 						poll.wait.entry);
 		list_del_init(&apoll->poll.wait.entry);
-- 
2.35.1

