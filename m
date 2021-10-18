Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADE4319BE
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhJRMsa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhJRMs3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:48:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56172C06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:18 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t11so11136737plq.11
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPYz+7pV0Bi6Nxp8QeeiK6wdgcmJbVjrHflLCRyp1wc=;
        b=VYPSr9R2Tq9Xll97X+8C/tRMAEIkEEbN+TW9U8dM1fI2uRa9jtIj0A+QIg9d9iIHBK
         9UeHApu+tabqHMJDYwSrYF5K6AISpIh7FiaFoELEuBaMMWCrrMbOIR90TKos1juGH5yc
         K6mV5H8Ar94kvWWD6CikrFNXQisJjVysMoOGzDPKDRbLhQTWM7gpmCwIyXYC3DoeHJWf
         m3BJNfDmUIez2alQpV1RcxiDtbMmhk7Cr1AIF68jQ92i1F3lu+TfvlXcyZnojV5l1xyk
         mjahIaYI0ZVignNoRdGpbjIGll4pTPFiarqRQ2wyIm7+ou1NYFN/IaXI45f00w1ldPNd
         4HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPYz+7pV0Bi6Nxp8QeeiK6wdgcmJbVjrHflLCRyp1wc=;
        b=Ml456zbYju0kKsqkKr+f3LVqtoQ2h9TqScnnwe/4mo62xCOhucf3EVxYo9Dxl2Ot7g
         N62nQfRvuhaeV5ZhvIt5IAF5ANXHJEctPnWCRsl2h/0P7mZe1XEveNEgIivy+zt94huu
         zi5QnTaC7e/ritoje4xxcM4FYx/r3tAoDuqoOZXsn367papHVXwQXP8J2J2ojlPCuqxD
         04gdC1+zBcepdIdhxf9i1A6fQLMuEX+fvQ+Q4FIGbdwX/jtQ9FcGuUWMJ3SrHYs2fYZw
         I4LpDAfibRvaCdNnQrPZt3mnGEpuuSEvhzPTzDihxR4wMOhVU7rnvj5ewUD2uKTF2Wof
         TfRw==
X-Gm-Message-State: AOAM533yi8QQ/9Mh2D057J16YEFyVH2rus4XBiVtOYj5IYqvF3OZRe4k
        hZzmJFS0egzjIHm6voYcTnATv0aYoAZhl63I
X-Google-Smtp-Source: ABdhPJyWxEEArNlBiKax1AOK2PmEOqqeMy4WhOO8ZXAvCnP2e5NMQVmoA07/fg/y56Xzhbnuf1P5gg==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr47240581pjb.80.1634561177890;
        Mon, 18 Oct 2021 05:46:17 -0700 (PDT)
Received: from integral.. ([182.2.39.79])
        by smtp.gmail.com with ESMTPSA id l14sm20096041pjq.13.2021.10.18.05.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:46:17 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        zhangyi <yi.zhang@huawei.com>, yangerkun <yangerkun@huawei.com>
Subject: [PATCHSET liburing 0/2] Small fixes for tests
Date:   Mon, 18 Oct 2021 19:45:59 +0700
Message-Id: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

 test/timeout-overflow.c | 2 +-
 test/timeout.c          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Ammar Faizi


