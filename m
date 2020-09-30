Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E4D27F2D4
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgI3UAn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UAn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:43 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E220C061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:43 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e17so741421wme.0
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgH5RBOiGN9qLFKuSpGxs1OYwUZTqijj+krgkYSzKq0=;
        b=UJTDCU2y++jG4iVOnvEsN0d2OnrGG9te/MEPeZnQURoUJdqiHidJEl8zTG8/H6EFbJ
         tZQ4yuAk+nEIeJfwrcf3Q22VJn8FVMmTaaupGY4qn1MFpxeeUf90f7oQsSWDUq+v9Cn5
         89n27J1ym3IMGYktiheghGiDqlhloEC9uik3EKodiK+Q72WPE3O42WVgx21bXurbvDCM
         yf+TpamDbI4oG2Th7ZIoVgJCJklzpZxkpWTm13uEwCdvvzdH/klbZeEcxjlT0tk0vyrt
         sPKeCCv2D6Za9bHGSPVhrZY3iQhbp//MIXHR1WpGcFpbzxZZ701R89zTwiI8pNks+zfE
         +s8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgH5RBOiGN9qLFKuSpGxs1OYwUZTqijj+krgkYSzKq0=;
        b=jcNKeccwWg1lg9+0wfOZD9QFXSlo4S61WZCc9XpVXbcIUIvUX+4HA8SjmDi4ODuqjj
         X9NbLwxiN6YhLEm8iMRqQ15dABzHL5rPRnKZa/r/mO0QvtUSxG4S5u1eGhqW97ewTZHj
         lQhQkc+VSN1U51oBGNalDopuiRVeawq1BYIZxSTba8pMHsYK/fHJSdhaVEr1G4nVrT/L
         5Eiavxr5d+hmAvZBNBD9WytlnFQ9cpKOYSlrigs8ltDUkYwdgdorPFykWicmwQ1ZefGM
         UWo1EThP6sc42ns2MHfX4QFw5VIeQuBvUh+2EtPdIoH2mW1OTfwR13X0WFfPX28Kq6HQ
         PcOw==
X-Gm-Message-State: AOAM530vPktviLAXBhr1uemTP2xsfsDe6wHI/5KXETsOX906cXHko8Wv
        U9Bf1cmmWhpVNbs1WBm7Jr/PUti2ehs=
X-Google-Smtp-Source: ABdhPJyDH1OJeOdaq46cohya69D5jWzA7Pua6oYxgHeCDxzNZK6JBvAioY1bxLlGBLajN/PnaDaBLg==
X-Received: by 2002:a1c:4b17:: with SMTP id y23mr4631844wma.162.1601496041873;
        Wed, 30 Sep 2020 13:00:41 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id x17sm5127176wrg.57.2020.09.30.13.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/4] cleanups around request preps
Date:   Wed, 30 Sep 2020 22:57:52 +0300
Message-Id: <cover.1601495335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[3/4] is splitting io_issue_sqe() as someone once proposed. (I can't
find who it was and the thread). Hopefully, it doesn't add much
overhead.

Apart from massive deduplication, this also reduces sqe propagation
depth, that's a good thing.

Pavel Begunkov (4):
  io_uring: set/clear IOCB_NOWAIT into io_read/write
  io_uring: remove nonblock arg from io_{rw}_prep()
  io_uring: decouple issuing and req preparation
  io_uring: move req preps out of io_issue_sqe()

 fs/io_uring.c | 316 ++++++++++++--------------------------------------
 1 file changed, 77 insertions(+), 239 deletions(-)

-- 
2.24.0

