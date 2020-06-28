Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F039020CA43
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgF1T6k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:40 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:41500 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:40 -0400
Received: by mail-pg1-f174.google.com with SMTP id g67so6430737pgc.8
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c08IY3zSjYTj7b/pj7pCsFealSJeo/ZLfKoKC8/OIq4=;
        b=BnV6L8beim5g4Nd2oZnS9LUDf84EzjqfSo1SHX2cgyF3w1FZTQuGDaV1JynJ9I8ikA
         IZ+yC/VkZEN3clB7ydP+sNNSh52V4aEnQ/vpuOSB66oN7O5uouefxbuELm+M9txQtsfL
         xC6JXGNn53AvoD5Re4d7ew1+tgm9cvP3W33oOrhv8hrba8RhhRB4OO87hrZi8C+J9abv
         zSDOE4x4/KFbh2dyy5xJ4U/wz66j3KY1grZ8Guh2q0eSp47Gy+Hv0riN+P0SDDP4wAKH
         i+KEm2BCAk3blKtpLsBV8HavRnsjPnI7VGJWFEPNnViGQxqynYYCp1kICXdXJDyxtHKE
         wNUw==
X-Gm-Message-State: AOAM530lt+Qxg/Xx4jCDhAf2FDqTYpuOFGtO/QI72ZSQ0Dh/hx8g+aIb
        S5WarC4AbCBCaX9b8xlrdYs=
X-Google-Smtp-Source: ABdhPJxSRQdJioYOGBPVxSrnVDAmcdVZ7si4bPCVIZ4bzxXa+hVkYrh1Czltdj6U2A/VgvNYYLJAcQ==
X-Received: by 2002:a65:448c:: with SMTP id l12mr7358212pgq.234.1593374319615;
        Sun, 28 Jun 2020 12:58:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 7/7] .travis.yml: Run tests as root and ignore test results
Date:   Sun, 28 Jun 2020 12:58:23 -0700
Message-Id: <20200628195823.18730-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since many tests require root privileges, run the tests with root privileges.
Ignore the test results because the kernel of Travis VMs is too old for all
tests to pass.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 .travis.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.travis.yml b/.travis.yml
index 69da3c07df7d..e02fdd03392f 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -19,4 +19,4 @@ before_install:
   - EXTRA_CFLAGS="-Werror"
 script:
   - ./configure && make
-  - make runtests
+  - sudo make runtests || true
