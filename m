Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833B93CF732
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGTJKj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 05:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhGTJKh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 05:10:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413DAC061574
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:16 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t5so25276989wrw.12
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M1RTpKCYd4URLA4sc++d7smFqc9VrUe9jK4Ci/mge8A=;
        b=Tx3K4ob3I2JCcE5V09jRsdhLaA3RjRHql6qJblU8m5yYLZfsxRm77IYz2k6IPvUN2V
         odErlPwQvfYTDGsxJSISbD+c612wUtLtzA5tI1eGxGP1z+Ic58pgnNTAD9eikW9oGdGI
         Q96wS8knhD8yBRjAD+/38VbGDsme/DF06oSM8mB68tS6+6SGz6m5LukUO/OHm6YPzLeS
         oqanOc03tWigMcOmXbItiNa6Yls+/pJbl40t83KdX4/e3362lbVx63GelvRhgpWM4Z6Z
         ZrK3xYnH8Y1ncewyiQm8VPtyg/rkyHzrkpqWorUm7WDorkdVRgVznIURw3l/5Xrt7snB
         1sHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M1RTpKCYd4URLA4sc++d7smFqc9VrUe9jK4Ci/mge8A=;
        b=ErbDjYPevIAUUJkyGfEfqM2vS1yuYHsXDIZh1BVYUT/uBETGANc2TwZtmTfZ1mTJOW
         pTQB1uoGiSBVAa/TYg6kbwWxEdkrJmNJUGP7PVrpk54RwfBnsSaFjZFAkcStpGvDKJPD
         V71NO4cOZprTXrhd6dLqbB0NXPHHd81x2syZO42hRdTHdZf68fCq6xjeFu9WGZXo9wI0
         vIue4Qv8Hn8aNkF3DlSYqG2mi/vdUbFbvzFQBD6GF0K+sjmmjPWJB47mU+iCTrcebl+n
         cbKNxIuqUp3c2u0/8+e2fzrLkVpa6Z1CjgVJxrH8RAWx6UIy74Bmx3vsAeTJUyOmXkTq
         u6xg==
X-Gm-Message-State: AOAM5328UqIyxSDINsWUtirVkQoqCXr2kso8minEvpZaGJV8ztSrWh1e
        CjtedSUcB6QC9E9n61LtbDg=
X-Google-Smtp-Source: ABdhPJzanxVQZneDdpjm9kdtXWS95rOcd+x3F7EsTeJqfI+uzeCosWphb1Z5W9Hq4DndI9diMPcxPg==
X-Received: by 2002:adf:ffcf:: with SMTP id x15mr35312400wrs.76.1626774674957;
        Tue, 20 Jul 2021 02:51:14 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id p9sm22297701wrx.59.2021.07.20.02.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 02:51:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 0/2] double poll fixes
Date:   Tue, 20 Jul 2021 10:50:42 +0100
Message-Id: <cover.1626774457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2/2 is about recent syzbot report, 1/2 is just a small additional fix

Pavel Begunkov (2):
  io_uring: explicitly count entries for poll reqs
  io_uring: remove double poll entry on arm failure

 fs/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.32.0

