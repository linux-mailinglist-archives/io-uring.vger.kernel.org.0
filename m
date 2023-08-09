Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B17775EE0
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjHIM1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjHIM1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:27:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321ED1BDA
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 05:27:36 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3178fa77b27so5518111f8f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 05:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691584054; x=1692188854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SuRg991TJ2wYE+eGSyR4YGKW76NTvlszqBgxl4KFE2Y=;
        b=PT4gDTNkK+MDv/sYwsioomkH8W9XuwD+LFwKGKU7uytrw0ufBXez82RsP2nuWML2nS
         L2rsnswDdDQn9LUrf/YKICRKuU7WVmoyrAAodWHhT6na6koE0oZZfbCGPJ5yNJU5Ho7y
         GAMmFzkzLNEHDJD9tFGatSU0UbGGQWjS9xAQZcQCTHLsij5pAkeQubE2sNNjRRM4O1ex
         +cI2kieue7bFQ0Qb+SReW3xpdkPBpA8A18RqTdUTQQWJi2oOThqoF5tnoDr50zyo4LEc
         T/U0TXU2Tr09E1CnR4aQcNC6ZIVtqkYnrmNmtITccrljjLaty6uO6L2P7tqcL8XD55Zt
         8G7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691584054; x=1692188854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SuRg991TJ2wYE+eGSyR4YGKW76NTvlszqBgxl4KFE2Y=;
        b=H/801Z07Lr+9IY9cC2dHnDkfJ+Q3pn+5N2Lv00J8EcHMubi2+rHjmP1IO8yzZRTfTo
         j7CsWXE0Lm9szNKmiHLw/5QeQbw16JQQJq6NKdElMXktgYx9Ul1IJangEAM1HwHCQZgb
         F4Y4RsVgLsBGe94eCotVyH1D3KVLDbhoRNOFDOOh0ab6cfhV/kQZymFYLc9+0faauYLo
         VlQc0y6LEKpOsuYH1E9RPFOnuUjC8itdj5ynyKw/KdJKCZNyNhiY1356/ruvajCYcO/1
         f52oekD1KMuQIN09MWVFCIs94Ci6JV0hLC8pLUmYCnq2Unj2hyK4kO2zb1d8yHJQm4py
         O31g==
X-Gm-Message-State: AOJu0Yx1gGSqTsypwgL69i8DA8lI6IqIJ9zMOyJWfvh3SsEN4tEjybEy
        +8lkZzgs8fsr43Pjvx7Te92U7fVbqww=
X-Google-Smtp-Source: AGHT+IHRZ+b2nVSh6xmi+K1boLNRhwrIk6wIoyyue2xuutOTZBTIdJ/N6h0DGqgecAlBDH5yc+MwCQ==
X-Received: by 2002:a05:6000:547:b0:317:7271:3275 with SMTP id b7-20020a056000054700b0031772713275mr1453950wrf.38.1691584054385;
        Wed, 09 Aug 2023 05:27:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d4204000000b0030ae499da59sm16558111wrq.111.2023.08.09.05.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 05:27:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] random for-next cleanups
Date:   Wed,  9 Aug 2023 13:25:25 +0100
Message-ID: <cover.1691546329.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch 1 removes stupid dummy_ubuf allocations.
Patch 2 cleans a bit up io_run_task_work_sig()s return codes.

Pavel Begunkov (2):
  io_uring/rsrc: keep one global dummy_ubuf
  io_uring: simplify io_run_task_work_sig return

 io_uring/io_uring.c | 13 ++-----------
 io_uring/rsrc.c     | 14 ++++++++++----
 2 files changed, 12 insertions(+), 15 deletions(-)

-- 
2.41.0

