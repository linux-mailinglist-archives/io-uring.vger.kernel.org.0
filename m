Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6237740C17D
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhIOIQE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 04:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhIOIQD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 04:16:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DDC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:45 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h3so1924858pgb.7
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 01:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmLE5A2RnNEhCbacAAzo2Gd539739vy1dg8dHxEv5AU=;
        b=KkjqJLbfIcELUEjcSUL7cce3isNatYajOQ8yOpWzOuTHtyquEXyyV11ajuLylbByTm
         dzAN5HmLGyNDhUFpQbrxcck+m9SnkYbkJVh9Bjs/rY0F/wTb/W8oJ54QkKiyqDa7BKBA
         YU9MX7kJWMjlKcmohoEXXH5kukZgdQw13xjQFwXC83/rgFuUIEXtOmH1xWQ3RQOk2Ua8
         V5m7My82veinrepnfQsI4X09OOZbLCQW83+0x9Ibmz11EyhdPc+8gHx+Y9uO1PYBmLaQ
         72ak23pXJ4bvJkhOR1byZwwQm21IBLa33V2cT/YaH/tAerW2BjTCqCitfVAb+mnOCYpp
         CJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SmLE5A2RnNEhCbacAAzo2Gd539739vy1dg8dHxEv5AU=;
        b=Mvz76W89ku/UTojmI1PCvW+Iopen2dkZEufMFPpZGnVaBb1jlxqQMx51MjaWtbV+5H
         nrNYfL6G8AVT/OZJjeg/fkVJhK6YFxRCdUJLaN2kgDcTUYRTPr7jqR3RhL26hpibWBn5
         brqF66uMWMWyxg4pS4Dd+3u7Q04fA2kICw6F2qWnSC0Xwkgh3SOELveFaPX/Ftg1stE9
         QzQC40/3sHw8U7fUB7Bw0lAHcLoI2YOiASW1nBD6gsRzcsQCbLB5BslQ4jAI5RSOATMe
         uSIj2lOwUyF3R41CcdGRqdV5sXGpJuVgPg1C8olq7Q2uFVR++UxB3INVUw3lwDO4e3qF
         hPvA==
X-Gm-Message-State: AOAM531ynIV5TW9BKabBIDa3a3ysbtv9yWM4VC7Uajc6zvC8I1eQo2Yv
        8eVSPbHcS1/Z5FPuwXXnjfDDewD9rwM=
X-Google-Smtp-Source: ABdhPJxyUGyIlrcOnW51M2HFDrxwE+FJtvB8gd1JPzXYxTMsAIsQ62GyzMB+FJC3/Z0d+8PhS9lqyg==
X-Received: by 2002:a65:64d7:: with SMTP id t23mr19073841pgv.237.1631693684998;
        Wed, 15 Sep 2021 01:14:44 -0700 (PDT)
Received: from integral.. ([182.2.71.184])
        by smtp.gmail.com with ESMTPSA id x22sm12643076pfm.102.2021.09.15.01.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 01:14:44 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/3] Fix build and add /test/output dir to .gitignore
Date:   Wed, 15 Sep 2021 15:11:55 +0700
Message-Id: <20210915081158.102266-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

- Louvian reported build error (2 fixes from me).
- Add `/test/output` dir to .gitignore from me.

Ammar Faizi (3):
      test/io_uring_setup: Don't use `__errno` as local variable name
      test/send_recv: Use proper cast for (struct sockaddr *) argument
      .gitignore: add `/test/output/`

 .gitignore            |  1 +
 test/io_uring_setup.c | 10 +++++-----
 test/send_recv.c      |  2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)
 


