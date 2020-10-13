Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3528CA75
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbgJMIq6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:46:57 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA991C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id p15so20112549wmi.4
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euIx2UX332T3r/5PUOxmeJxPd3p9CqOhUzhE+3qHmTU=;
        b=JKQ18shufEfSjHo60cQijiiXIgkw0ZXe+mV1e5p+Jx5JTqk7qnJU6lV9pHt3JsLQMq
         hnkBjRtkV1tJsvtYZtiUlRppw4XbgAKqHwjPRU2JPzyJe7Z4s2KCzDjriDqbmic70Rc3
         PvGgMBWOu7Cccqz4RARHXgIf36owaKy3U6s5i2y6fHPyhKDZ4Z7BILNG8A3EHx89+i2X
         87Kif03t5n3H7HUyx21jazPxHyPwwVvSK7d5mitZFKxXWNdFbQqiAlVnMXgKEsnTMTLj
         onHtOWDUDshqArIYc9uw2NmkDDRLAp4kKOLSz2C0HY70v5uYR2AGtD7E1otYYipxEDIA
         chyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=euIx2UX332T3r/5PUOxmeJxPd3p9CqOhUzhE+3qHmTU=;
        b=Y9HKo7Y58QGFByFgbbPIhpW63fXSA7A7qpYhiFhLY+z6jtEevGhPgsIx5+nOvFjRPu
         6+C7gHsa/QdujWOOB+27xk97dly5lPWmQuJ1Rup9BB1dlUE191RaoTic6nxo3rindH7v
         RG0bTQSXYSAWKw20JgEJ6RFpzo5vW04KaoInh+S2dzzEPyAb6wlC12YwvxLQYt4pIlvx
         3FO/3GqYLwkgOMaLVEuFPdi9Iz8nOoMHAUfT71atvQkypszQWg0N9XJdrWy+AzZaE/iE
         Sjv0nGCKrSLRdRPDiyZjroE73SiStiEJS0+IVeZxbPiK0fTnKfE0g2RoVVZfvzWTldaR
         hfKg==
X-Gm-Message-State: AOAM5314aZRXHXjqMSqMDMBvw8/89Wwidk96RS7RRJqHH48DlPxyaBAM
        4r1piICqL1CvVOz+lGBQahE8SmrVUYs=
X-Google-Smtp-Source: ABdhPJzoep8S8qlPoY1losZRomFPb3z2SFYC74oN/fYCOsWLoG7f6K4KMwIAL1xrhw/tn6ylyVG02g==
X-Received: by 2002:a1c:6054:: with SMTP id u81mr14332030wmb.10.1602578816422;
        Tue, 13 Oct 2020 01:46:56 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:46:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5] fixes for REQ_F_COMP_LOCKED
Date:   Tue, 13 Oct 2020 09:43:55 +0100
Message-Id: <cover.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This removes REQ_F_COMP_LOCKED to fix a couple of problems with it.

[5/5] is harsh and some work should be done to ease the aftermath,
i.e. io_submit_flush_completions() and maybe fail_links().

Another way around would be to replace the flag with an comp_locked
argument in put_req(), free_req() and so on, but IMHO in a long run
removing it should be better.

note: there is a new io_req_task_work_add() call in [5/5]. Jens,
could you please verify whether passed @twa_signal_ok=true is ok,
because I don't really understand the difference.

Pavel Begunkov (5):
  io_uring: don't set COMP_LOCKED if won't put
  io_uring: don't unnecessarily clear F_LINK_TIMEOUT
  io_uring: don't put a poll req under spinlock
  io_uring: dig out COMP_LOCK from deep call chain
  io_uring: fix REQ_F_COMP_LOCKED by killing it

 fs/io_uring.c | 158 ++++++++++++++++++--------------------------------
 1 file changed, 57 insertions(+), 101 deletions(-)

-- 
2.24.0

