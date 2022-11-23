Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C76635BE2
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiKWLgh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiKWLgf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:36:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA011DA24
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:34 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id b12so15150931wrn.2
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LhlnN6mPPBlx40wSIxyTqZWVJPePFvft+PQGIt5NgG8=;
        b=Lqz/XMUC/vmsmVoPYiMWPcSbW1vmWjeRzaoXTdUlB5jikwysl2wIi96EJGFh1eoxo/
         Rb0RnxrUPlqhwi4UhIbAVgsS5GyBz/bah9bmW5qt502RC4igjYLV1aXjdVKiMKzEf8Oq
         Q1Jj3LPmY/Ry1nZMFxytTeRMIhLvOkdMVXZEbCqZ1fXpdKDk9pHJU/ta7VdYMkbl2r9P
         UCvfN+lm6O70yvSO8DU4C+Std9mgA8PsBBB/5lpmhE6tuu/YIAQWlpjT2+rzvdk4F0V6
         2ciHlBRaeGsfXZR7SypfJzE185n4+SGN0SK8+lq+JrNg1o1p7th63DELrqnGYqrOVrfl
         MFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhlnN6mPPBlx40wSIxyTqZWVJPePFvft+PQGIt5NgG8=;
        b=cVqjn1bAc/CtMu0Nzh5mTo8b3b9jYuTAjqixhAug8TFERWt51lfbYVZfjVmw7/2Foo
         EcMgAKZe/xW+atuOCmvFXDHseSEFll4ITqO/1V7fJOhL5Rxp7RLQwk7C9ctFoiObVXt0
         K91wY4UBg0q6E5A3cytUuYQAQFBpuWu+bTF2FwNjNc2nFXpnK0dvQ7mLWDRn7ynxqZ5x
         2QgwuvR/vJ4bWY7wnVogKK32SjCOzoDCqkOhmv+dRrKbpN/EKk50fJiiyDSEpMlsNuOQ
         6MoBZMX2Cg9ETk6mF3JU7fxjISNntrzNko6ZmsAOiehNSc7e3BMhCj3Vu+jmCMFJN2F9
         61QQ==
X-Gm-Message-State: ANoB5pnrD6KhSgWmbq8qNzP0mtziikcj+whu20SHgmM98zk0xjiDDfIJ
        hiUOyqvTPXlqefdDBqmwFteSjfWB/58=
X-Google-Smtp-Source: AA0mqf67P3169hHvpjms3lDOdTSaKme1WZItWLfIPCCQrrEm8GR1LwSDsCn4say02CSyUz6glL5oQg==
X-Received: by 2002:adf:f0ca:0:b0:241:d05a:73e8 with SMTP id x10-20020adff0ca000000b00241d05a73e8mr10289734wro.592.1669203392601;
        Wed, 23 Nov 2022 03:36:32 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id y9-20020a5d4ac9000000b00241ce5d605dsm10854508wrs.110.2022.11.23.03.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:36:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] test poll missing events
Date:   Wed, 23 Nov 2022 11:35:07 +0000
Message-Id: <cover.1669079092.git.asml.silence@gmail.com>
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

Pavel Begunkov (3):
  tests: remove sigalarm from poll.c
  tests: refactor poll.c
  tests: check for missing multipoll events

 test/poll.c | 146 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 120 insertions(+), 26 deletions(-)

-- 
2.38.1

