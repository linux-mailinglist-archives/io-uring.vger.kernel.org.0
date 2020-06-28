Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED0020CA3C
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgF1T6b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:31 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:45203 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:31 -0400
Received: by mail-pl1-f174.google.com with SMTP id g17so6238768plq.12
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H1GOitetxnXRP3GEEkeLen/uGuYY7XLoz9Pkt6yABYE=;
        b=ofTEq2+K+jxGA1Eoq8iRhyEKY3sobVSRmf6/wqS8JFcamphZh4AsW8Xt2I/LLKGnqk
         iYyH0Sqj73Y40qNQ6Frm1+UQBwkaCjlRKaxbri7CAaGU4Wsqq138QEqerqN7Xk6dCF58
         ILcLpIYg0tXYly/JFtHE8VP5zQls90iZiSM029ZMODxSXAQ0cYLkGaI969yFGYubLzCT
         fjcLvQw2lNWvCrYNtVIjrIuHR9j64PkOvfGuQ0V/zZytDha/2PsqvM36iZavxzBJumub
         PB3hGBE3PRlGZeah7KFGQKdEwqLYTjhO1Lshc8F4gVrvy22011A+49BjcZoLMWAX1mmz
         kkLA==
X-Gm-Message-State: AOAM533cGH/tKl+ooc+mrQH81WWIZMZ4kLdK2D86a6gNf1eFmL+29Gp8
        8HG7cMUCGw3cwhMd2pChYme/464R
X-Google-Smtp-Source: ABdhPJxp7THIomVzcywRqycKo7UclwP/T7ziCZ1SIHaKfHzWlJ/p+gX9fZuXQAyNOa2c+iBT2gzjBA==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr8512933pjn.127.1593374310945;
        Sun, 28 Jun 2020 12:58:30 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 0/7] C++ and Travis patches
Date:   Sun, 28 Jun 2020 12:58:16 -0700
Message-Id: <20200628195823.18730-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This patch series includes patches that restore C++ compatibility, that
restore clang compatibility and also that improve the Travis build. Please
consider these patches for inclusion in the official liburing repository.

Thanks,

Bart.

Bart Van Assche (7):
  src/Makefile: Only specify -shared at link time
  src/include/liburing/barrier.h: Restore clang compatibility
  Make the liburing header files again compatible with C++
  Add a C++ unit test
  configure: Use $CC and $CXX as default compilers if set
  .travis.yml: Change the language from C to C++
  .travis.yml: Run tests as root and ignore test results

 .travis.yml                     |  4 +--
 configure                       |  6 ++--
 src/Makefile                    |  4 +--
 src/include/liburing.h          |  8 +++---
 src/include/liburing/barrier.h  | 49 +++++++++++++++++++++++++++++----
 src/include/liburing/io_uring.h |  8 ++++++
 test/Makefile                   | 12 ++++++++
 test/sq-full-cpp.cc             | 45 ++++++++++++++++++++++++++++++
 8 files changed, 120 insertions(+), 16 deletions(-)
 create mode 100644 test/sq-full-cpp.cc

