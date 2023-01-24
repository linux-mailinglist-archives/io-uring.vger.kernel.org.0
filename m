Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D649678D5B
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 02:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjAXBYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 20:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjAXBYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 20:24:17 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B7B59F3
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:49 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so11795112wml.3
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 17:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gUx1XUqb/OOSvzZwslEl18u9canagE/LwxVqFYuOHlM=;
        b=mcCfbYM5HjR/mn9NWe/37vWLy7uqoy3/yBW22eWQqlrDq/TabTvyXwdreM7y9PGpXe
         TeB5GLDTQ5pRXxQS5tCOzCQLeEwt5H6MiWyh1c4F7eNit2/Q34kG5f9PWojmVXJKkD2k
         R2ubeomOuX63UmStuYSu1ptLQFaWlrqLCn/B6/M0Vg050s2IhVE+YbcsYcEi1qWjgNIe
         b5STPA4BfubbC8cuxs6R8M/hK4PZ7xKQAPdDXMjDR7VWVSk06gWw3jkKVWSDtPq+WJeG
         QdVK3PzU1ma8wlP84q7veSTreBkdI0i/kOxl7SuP/mg62OPErQL+abgxHRQVh4DA3Qof
         SjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUx1XUqb/OOSvzZwslEl18u9canagE/LwxVqFYuOHlM=;
        b=TZjARYZET7lel+aCzVDOHrJObX9V2n5yGUiObFBc3LsM+AoOXZ00Ce+Dy6xW4SdKkZ
         ZXib8FImD3JCqXoLYU8uqkWKual/ffGkIz/hMHJcAR3FJPsjrCzH6XI+whxCiBRApZ1W
         zWx1mRv+kOlRj0REJ7gOekXjmOirfak7IV3Xpxj55kpLZde+7rDHSx30Mx5fazuYeuni
         CzSJxgJYw3mlW6z3HODtgCX436iafty/ID1Nm0w/1Yl7EjhpRDKWkMnJppOZQJnYnw8G
         DpXOTwNc7kOf6jiuWMmCNMRElGZPT4L+z4hhdSzHo2T88XYewvErPR2fwYdz+5AE3DOX
         lTSw==
X-Gm-Message-State: AFqh2krAHFZ06FuFYRUMHThdaaAWuxsgg1hfL8bOR485qghs+FoWk7Tk
        vQuriyk32iZooiwu8YWIL2x/I54NdKA=
X-Google-Smtp-Source: AMrXdXtTNrMIKPtAhMvb5bOrQJeiNex38bBqAl05RqjE6XoEMCCe4J5+0N1tXmcqF3pyXBE8fVxRSw==
X-Received: by 2002:a05:600c:46cb:b0:3db:1afd:ac45 with SMTP id q11-20020a05600c46cb00b003db1afdac45mr20664050wmo.7.1674523424774;
        Mon, 23 Jan 2023 17:23:44 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.37.76.threembb.co.uk. [92.41.37.76])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b002bdcce37d31sm712912wra.99.2023.01.23.17.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:23:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/5] deferred tw msg_ring tests
Date:   Tue, 24 Jan 2023 01:21:44 +0000
Message-Id: <cover.1674523156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Add a regression test for a recent null deref regression with
disabled deferred ring and cover a couple more deferred tw cases.

Pavel Begunkov (5):
  tests/msg_ring: use correct exit codes
  tests/msg_ring: test msg_ring with deferred tw
  test/msg_ring: test msg_ring to a disabled ring
  tests/msg_ring: refactor test_remote
  tests/msg_ring: remote submit to a deferred tw ring

 test/msg-ring.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 172 insertions(+), 10 deletions(-)

-- 
2.38.1

