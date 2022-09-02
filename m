Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E395AAD42
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbiIBLOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIBLOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:14:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EAC60C3
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:14:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v16so1865614wrm.8
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=9oV+W7CYe23bQKeUrpW8Y+hm2diGolWA4x0xa8TPuak=;
        b=NiRYE5y4SPxxEK0pc2oiH8ADrQlPu4sfxHMGTo9qbtHSojHhNVepq1pe83BR6Ih5V9
         cdNQSPvjVZyGWDajQt4H2oNo7ZCbwGruHo7ZfkIzPPHtMcOgUNYiYNRwxmE/8eL1Cxwj
         K5c/RuoooCnO4MNT+5j7A7lOK1G7STjCNQD4bxsb0kxjfEr2mgIp+RJGNhjB2FvtFbCF
         +/lKmmhtZUmhIczR52Y+O1buCG80G7hSjq3j0TfhAUIy3Bh7av0lFfgNT/6xC1uIjjar
         s2OJfn1qDQ7jsaR2zsVJ+Si2538yqNTL36E0pue1kLvvTZX6WqXOdcPDMvNRbtGB/VCE
         275w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=9oV+W7CYe23bQKeUrpW8Y+hm2diGolWA4x0xa8TPuak=;
        b=8F9lUScqAWMx8crmxRrH4b0Q4C6qjY/5tt6yTuZji3rZXlDnOoLp39LmC0WzenIDA8
         ccyeZNtfBJm7cOidPOK1NecD3aclCoz7U9Ax60CH78JPn/AAyvPnc3iShCoas+INYCmR
         E6ZIRSjMD0f4xs/ohVobO+AciJaRL/lH8+Ub7NUWBLX7Zq2EClpyXZ1Xs3fLGeNg61o+
         rFMR6t/NlatlBTi3NRtceErFGtiT9nYkthc4AhRfijXlSM0V32HXFXFmU47nYTX4gB/B
         Cku/5kNu5y0VEjaYMDxYSHQFtchAqm7EyIONeTT8/iv/aGtlwSZuiwzHcj75DuTzAZfN
         g+Xg==
X-Gm-Message-State: ACgBeo1OA7lh6G+94mSOJGYLImWPUdtNQYx7nDdjBzJtn8Azrv4ugPHn
        8togNbuiC7OQwyS73ChitDgd+kiA6P0=
X-Google-Smtp-Source: AA6agR7nJtoOhWk5xVT9lIzTt2wWtacIyDvrkqt69IwNwfQ6F5pbaEe0PtcLyoA19Chyn+xJBDHfXQ==
X-Received: by 2002:a05:6000:547:b0:218:5f6a:f5db with SMTP id b7-20020a056000054700b002185f6af5dbmr17457744wrf.480.1662117287448;
        Fri, 02 Sep 2022 04:14:47 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a536d5aa2esm2087379wmb.11.2022.09.02.04.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:14:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/4] zerocopy send API changes
Date:   Fri,  2 Sep 2022 12:12:35 +0100
Message-Id: <cover.1662116617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Fix up helpers and tests to match API changes and also add some more tests.

Pavel Begunkov (4):
  tests: verify that send addr is copied when async
  zc: adjust sendzc to the simpler uapi
  test: test iowq zc sends
  examples: adjust zc bench to the new uapi

 examples/send-zerocopy.c        |  72 ++--
 src/include/liburing.h          |  39 +-
 src/include/liburing/io_uring.h |  28 +-
 src/register.c                  |  20 -
 test/send-zerocopy.c            | 667 +++++++-------------------------
 5 files changed, 178 insertions(+), 648 deletions(-)

-- 
2.37.2

