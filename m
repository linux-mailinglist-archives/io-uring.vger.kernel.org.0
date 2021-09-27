Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA7F418E65
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 06:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhI0Ej6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 00:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbhI0Ej5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 00:39:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2CCC061570
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so10698244pjb.1
        for <io-uring@vger.kernel.org>; Sun, 26 Sep 2021 21:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VB/zGx6Jjv+TMqGHrLtjb2NfJvB0jHNvPpw8TCz8BTA=;
        b=VbL3TqXlRJUzZ7HQYu3HYs8g7Qq1mPVvmZAFMSm2KP45/hPo162kGt2C4te5znpPr+
         DpqW8htkm74w8SRjavyK8EQY4zQkCX2Us8YNT7SIUz0LgrIu1N7/cMzQokf+joQxPp5i
         y4l+EF8tEeV0+U6xPZdgO1fp7QP07gpnc2SQPG5h6NYu/YpqFeBE98d0zPsEA67n5As7
         NAw1Ii1T1mGfSoHy0UKxrguKVnGkWhJuXoG+fnp5fLwMTJYe+ksHzcrz9r7rFKgUOBsi
         8TAO+PQXbvMdEzFCZz+JuU0lbZvPHQkZ/vH+krJO8K0kKoE4ECuxWRwORkscqiLlvmsK
         nePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VB/zGx6Jjv+TMqGHrLtjb2NfJvB0jHNvPpw8TCz8BTA=;
        b=D0AXEbveyyUt/RvFfq01BHh/0DRCec72iUsWXqwQkyA/k2k9LPPCBK5HQ9Uvh94OvX
         8Pji75BJ1sMSnakMMb5nb0/8XyZKUmZma+JcJ8Oo9jl2HydZSy7K4Dae/wrHyFruu5TK
         NK3ObMpg4Rs1FyoJrFIvsrzM1S+9LkWLYW4uU6kuV9mgytA3hqLO6V6ejn+H3VgzeNt/
         +csulo82dksLqEW/O3xjUT/AhDB5xaqKCpp8/DRhi7fcn6mtvAIgetAFPAc5jfNQS+K0
         mlaca5v1YKUk5pa/kDIzJOSTHRcOcZIgEAaAqYbx0FfY/zTTbL1cTd+cpzyceCghojrj
         ZtxQ==
X-Gm-Message-State: AOAM530w5hhWJyVF3sPOm/E/rVnyF9goXmieyf0OS4U4ydPhqORVIyXb
        RRgadg9qe2M80rBtCYWu34fnVnHP9w/4yw==
X-Google-Smtp-Source: ABdhPJzUy8SEkcjrDjGfABq3KiGVp9XXkCpjYri0a4PoxdT/Vt/oABHO12oKPL6vn5mkPURz1oXrtw==
X-Received: by 2002:a17:90a:5a86:: with SMTP id n6mr17340488pji.3.1632717500205;
        Sun, 26 Sep 2021 21:38:20 -0700 (PDT)
Received: from integral.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id l128sm15623040pfd.106.2021.09.26.21.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 21:38:19 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] Fix endianess issue and add srand()
Date:   Mon, 27 Sep 2021 11:37:42 +0700
Message-Id: <20210927043744.162792-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

2 patches for liburing:
  - Fix endiness issue (from me, suggested by Louvian).
  - Add `srand()` before calling `rand()` (from me).

----------------------------------------------------------------
Ammar Faizi (2):
      test: Fix endianess issue on `bind()` and `connect()`
      test/accept-link: Add `srand()` for better randomness

 test/232c93d07b74-test.c |  9 +++++----
 test/accept-link.c       | 14 ++++++++++----
 test/accept.c            |  5 +++--
 test/poll-link.c         | 11 +++++++----
 test/shutdown.c          |  5 +++--
 test/socket-rw-eagain.c  |  5 +++--
 test/socket-rw.c         |  5 +++--
 7 files changed, 34 insertions(+), 20 deletions(-)

---
Ammar Faizi



