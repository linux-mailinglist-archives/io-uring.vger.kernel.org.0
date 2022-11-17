Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2690762E481
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiKQSk7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240609AbiKQSk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:40:58 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0A786A43
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:57 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s5so3821744edc.12
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ju/CVWnAm8zmEcIMZIhWD1MpWFBOPwgLeffGOW3E2Bk=;
        b=OX1msDEjJgS7dhw8TgWU5fWedj3dKg5iMx/c1q9bKT1AB5xRqj4+u3B/wqoHUAi0Rn
         pQVBCICgrfHFX/9uHj5RNnXuNgA1eR7CfF0YKRJxxkW1h+ViYCtAH/XggrZfaUyTSVXB
         EjTFJ72GnlowqkS2fNOXNEfedc44ywjS2JZ7kxNUPLn5scbBwlhLRRrezf3E5jhY6HLZ
         sAg/+NZTu3rj48ZesUYwZNU5O4+2ZydIh10QKAnC2vCtt2B+fRVhHC4LIoZ+d6Avvf5e
         ywI6IOpf5Uh8gSMO8hxWZxo2dgbOUog7NaP4YG9FOVkZhpIPyZa4ywn8YnqHWSkd8Ocu
         ZEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ju/CVWnAm8zmEcIMZIhWD1MpWFBOPwgLeffGOW3E2Bk=;
        b=0jySWrNCZrESZylafJir0m32KvElu2W9RE3gm7P1MkTMYQNRvrOoIWQempgTsG7QTr
         s98yyIWOoNlelVFLc9t1qKCyTJQhPmmKaEAircepY42wMEFEQn149al3o0G9DrsvpRde
         EmXHfwOXBKx+G+TPIR7GHcjsnjprFibpgAZTo0Xlxg2xxAvWd3WoNSEac4fnl9fp0yG1
         7VgRKtWzu4HdLGA3kCuDJkX7M+P/f+bqNxIhISQxzFCrYQ2MtH9mTL9YslJsRZFh7Dde
         +ls4e8qKrxLgClEhgBttD3fWvQHNTojLOE1MZ+BME7mKVoqWdEFnhre6FuaBJaYFoDit
         ++iA==
X-Gm-Message-State: ANoB5pkrYOHGcuOv6D9CrTC69V/dk5GWbTkP+WQOmZkeNhiJ6nbmMAjn
        +uYHxNIhcykTatkb36vDITJTzyJMxyk=
X-Google-Smtp-Source: AA0mqf719iXY/s6e3hCltf/YH2JxlnFsJXFncv7F9i9anGdOW7kCfsmLyJ+Lf47I+SD+/fZP2LVqQg==
X-Received: by 2002:aa7:cb8d:0:b0:467:bc1f:ca16 with SMTP id r13-20020aa7cb8d000000b00467bc1fca16mr3339870edt.269.1668710455279;
        Thu, 17 Nov 2022 10:40:55 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007838e332d78sm685486ejc.128.2022.11.17.10.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:40:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 2/4] io_uring: fix tw losing poll events
Date:   Thu, 17 Nov 2022 18:40:15 +0000
Message-Id: <00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668710222.git.asml.silence@gmail.com>
References: <cover.1668710222.git.asml.silence@gmail.com>
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

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 90920abf91ff..c34019b18211 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
-- 
2.38.1

