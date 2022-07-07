Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D62156A52B
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiGGOOT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiGGOOS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:14:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1012F384
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:14:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y4so9956410edc.4
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gDneB9NOKIknUbXPQ7YIi9K5/V+TipzWvS+8NqKm9mE=;
        b=auAnrENgu/m+TyPQMa5/0MYvRH7JP2Mg7jWpr59csHIKfTIXtbY3ncdcfU4uS+or9G
         cvb1mXXBuYd4PM+3yrfzrHgiRU9nrwT+auyk++rXXnT+ftruImtStOC5jsXUjOsGuC0D
         nzJRg3LEX4es2x51Troiculzn9pnkeM2FBPmUDQ4QFIOxkXm6cvRY8obofE3ZYzT8bMC
         FyHoqhFO8QE8BvgJSK0qIUiKe3qEIVWG8D5Y01LLh5kUbFednWgM387OP+kCMgdVW0Op
         4LtA95B9beaLInIi4IppJ1YDUIgc2IVVARIaItMfJDi/s+nwCRk1SDZAlCnlUp2/UccA
         Rl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gDneB9NOKIknUbXPQ7YIi9K5/V+TipzWvS+8NqKm9mE=;
        b=Elyinz2uYB2YArWfGnUEH/Gw9dQlRXgp6DLg5tPStvoWKvPIaohq7xZmrwcXPxaDs6
         cVpfMJPONBySawJ1X1HDqvSSQt5eRJektnzM1hgoyBZdF0mbrsfxhe+K43jb0+COolrc
         WvLLiNN2kAjyzwTq1hl7PpmBDzbi0tWLfqa0Ht6LMmTCxT9FOSSAjZRYV2/zNFOPw6yk
         9WKgkR2LP6My83gRA4RFYikk13+rHILodccAoLdRNDmD2ggdDe1Y9PjwZRa0IZCprflk
         G1Ap/a0TY1b4VcxRfnlU+BG/HRhKZBKUwR3uK/8uNskFevMqLygejxloUep472pDaM75
         4t/w==
X-Gm-Message-State: AJIora87kXyHpil15fQk7uN4Fv1xX47aM3mZrQ15SbXl4fI97rQQv2QI
        7u8vK/O25zC9Qwwz9f2Q+zSuU+kOJ28cEZ2/
X-Google-Smtp-Source: AGRyM1vMZjJfe0pG8fNn0yeD8QqWCjAGe6hJCJQKTJv2Ysq9TnVTRWlHYWnnKj/0F/I5n+mMbktP6w==
X-Received: by 2002:a05:6402:2816:b0:434:ed38:16f3 with SMTP id h22-20020a056402281600b00434ed3816f3mr62695779ede.116.1657203256391;
        Thu, 07 Jul 2022 07:14:16 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:3fc3])
        by smtp.gmail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm28254125edb.75.2022.07.07.07.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/4] poll locking fixes
Date:   Thu,  7 Jul 2022 15:13:13 +0100
Message-Id: <cover.1657203020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Fix a stupid bug with recent poll locking optimisations and also add two
clean ups on top.

Pavel Begunkov (4):
  io_uring: don't miss setting REQ_F_DOUBLE_POLL
  io_uring: don't race double poll setting REQ_F_ASYNC_DATA
  io_uring: clear REQ_F_HASH_LOCKED on hash removal
  io_uring: consolidate hash_locked io-wq handling

 io_uring/poll.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
2.36.1

