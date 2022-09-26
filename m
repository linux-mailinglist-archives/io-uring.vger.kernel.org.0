Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A70C5EB5AC
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiIZXXp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiIZXX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:23:28 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4997C61735
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so4523567wmq.1
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=oWkjY+tGN3QWr4jewclVn0K9Oy6854mdgqncfvuLeDc=;
        b=DZdfhUALPDO+s0V9AH+WJo1ln2a0zyy3vM+Jt75xJ149/NqkpFHLM9jIkObZw3IrI4
         ZCO//g4MVqpWug5z9VRrPz01ntWOHizDZohdiAcxJXouvYordqkFDBiwMgimZdRj4hPn
         lIo52YU72LEkAKt+xwTaxPUmmnL2vBnF1pnKVJOnBRuqMfYv4c3h7seP250kgTTJJ1qw
         kQ6MDv7D7CwlV5mtAO/DSwXsdwMXYs5ewlZhoAgVJ5909N8aKezGpfmm/zzEJrpv9k2n
         sOm5MvG8sZApS2CK65p7h/UqLeU84goteYb4hJHEXqyv1FjKwUdrt8lQF02OASFiosza
         uznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=oWkjY+tGN3QWr4jewclVn0K9Oy6854mdgqncfvuLeDc=;
        b=oTTMmrDFiSirilPRhRgzrHB/A3KlzCu/veDUhuQHoExG0MuV5+jNoiniYEwXus5ISZ
         m7BhHkAKiUPx2Ly2paCwg4j9+gSWdY/iEIia6dZYbgDViJx8o1sHhEAS3GE1WN9M/ByL
         RQhFDwkVlSsJjN5bPlF4UjSSQYtSi51xT1Rg2+xFAiX7mdBw7TMQAc1F8oJDrc8d1PXQ
         dVptKWvp7inX+1v5FZvT9FlIsI3vV6t+rkiCvAk+ievej8SqNCfa3m78huujLK8fImn+
         y7Lgfwf8lu2jJk13hJjfVmaJ7sGEJM2SwItM1eH6pSwOoKAPw9fujFJ13l7C+88TAEyU
         g4xQ==
X-Gm-Message-State: ACrzQf2n3UJiAGpsPukx2XN3eNKFs1DQwqOfJgpJNJMNpvqGnjK6mx3a
        KHPHSatUh4KlXt6JiScymHuFnl0+UFQ=
X-Google-Smtp-Source: AMsMyM6RXZUAeK8b6M3FvSvLdAREdBGQJmbhK4sMVVnoOGT3wUfS2pwGdcDCXBIQXp9QqvnSf/UHaA==
X-Received: by 2002:a7b:c051:0:b0:3a6:36fc:8429 with SMTP id u17-20020a7bc051000000b003a636fc8429mr633112wmc.78.1664234498091;
        Mon, 26 Sep 2022 16:21:38 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id p16-20020adfe610000000b00225239d9265sm90616wrm.74.2022.09.26.16.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:21:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/2] rw link fixes
Date:   Tue, 27 Sep 2022 00:20:27 +0100
Message-Id: <cover.1664234240.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

1/2 fixes an unexpected link breakage issue with reads.
2/2 makes pre-retry setup fails a bit nicer.

Pavel Begunkov (2):
  io_uring/rw: fix unexpected link breakage
  io_uring/rw: don't lose short results on io_setup_async_rw()

 io_uring/rw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.37.2

