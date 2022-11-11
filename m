Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7705C625FD8
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiKKQxM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKQxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:53:11 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2F7742CF
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 21so8399433edv.3
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ks0+qDdLovTIImx1AqyopwmisPm1bbetp8l6qji0LJE=;
        b=B/cx9kNE/XkmHkg2c6nvzQHisGc54hhhF+hq6X3qurOB+CWNV6yRZiorchQEann2P1
         waQ+JMDzvIDVJAEgttppL0zL+GZ4OSpOtZ9CvpPo+N+6gGsy1nZKzjWIrTShUrsw8Pp9
         Gdm4kor9WJPDmXo1r9TfY6etA8UsDtqvBjs99161/qU23p/HIIKz0Rcui4I1jETHMUDI
         jwg/eY/LiayWopGJm4lyb1GOGIPJhgtFvUpMG+/K1abb4G2wwgy1msb+68+H7y48gAu8
         9F7HUTxy/1E+pbZ9T5aHHqhJDoBx1h2fJIcXIY7gEZEvKgDDG3zUfrDvX3v2aBQ/wXV4
         /01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ks0+qDdLovTIImx1AqyopwmisPm1bbetp8l6qji0LJE=;
        b=A/nrwg+gcG0tKJZNaer4JcT7YISJOPVOlAGYWYkK9C5Slal8p08A11EkNlZG1zpexj
         nJppqTIL9Xq+AgAUauvqm75TBbyVDxYmuTCH03WGYCcfLWJhzc6LmkMavolp9tigZ/zg
         7HSnNQn9iTCgg8dJBVAnmCgJCGBy5ebrtUpAdkq6s4Ham5mPLWOuNfcm/jGacm2/VaV6
         /nd8j1ZHJt2W2kWrIWBRfRlJx3B7p8Eo2EVlnDDJyMSbFlyg963QIYEXDJCYdezaD4J9
         Fr/fqVABZAGVycwrr357JKKaoxRngcTM7sjKh1o90I5RcTLPAzSvshK5IsIV0EWM145g
         5+Ng==
X-Gm-Message-State: ANoB5plBIQ/gPBA6BFCMD6ka6T4TszZRQFTosvlnXyNyu8iSNbzDM/S5
        oqtAHr7nGViHGB0ZvVHTL0tERIEULUk=
X-Google-Smtp-Source: AA0mqf7z6KeRsPNa5LYe7hdXp2a8VzTNqUbZSrZVfmpdjHBj5WMDj9DmmLVB0jH8hcFgtVsCnE5OpA==
X-Received: by 2002:a50:ed96:0:b0:464:6485:419b with SMTP id h22-20020a50ed96000000b004646485419bmr2255789edr.382.1668185588716;
        Fri, 11 Nov 2022 08:53:08 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id ft31-20020a170907801f00b0078d9cd0d2d6sm1103837ejc.11.2022.11.11.08.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:53:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 2/2] io_uring/poll: lockdep annote io_poll_req_insert_locked
Date:   Fri, 11 Nov 2022 16:51:30 +0000
Message-Id: <8115d8e702733754d0aea119e9b5bb63d1eb8b24.1668184658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668184658.git.asml.silence@gmail.com>
References: <cover.1668184658.git.asml.silence@gmail.com>
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

Add a lockdep annotation in io_poll_req_insert_locked().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 97c214aa688c..f500506984ec 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -116,6 +116,8 @@ static void io_poll_req_insert_locked(struct io_kiocb *req)
 	struct io_hash_table *table = &req->ctx->cancel_table_locked;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
-- 
2.38.1

