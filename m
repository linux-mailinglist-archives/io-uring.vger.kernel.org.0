Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950853FE64A
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 02:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242508AbhIAXkB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 19:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242439AbhIAXkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 19:40:01 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B004C061575
        for <io-uring@vger.kernel.org>; Wed,  1 Sep 2021 16:39:03 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x6so2039594wrv.13
        for <io-uring@vger.kernel.org>; Wed, 01 Sep 2021 16:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pcs2uA3v2ZlwxP3hsSQgJihSxmq1c0wOV/Hcs1dmhXw=;
        b=LIDv9PfX+oOjdlbhrENqadoegWt513c4tuDp1gc4tJh6eXag3aYuc+PgDPpcFGk8Q5
         NzoShgmkkoFeaI/tkJx0bBAKXS4WqAl9nZH5bH83tyd2zX7aTKypXtNwaolqDeU2LmKo
         XV0gcaOm7ROIoC16df/bKlN5bjXZoMMl8OIsoc4PUlZiTcso8cq4C9jw/MJB7+G3QNT3
         hBEUF/uJYy0avwZwtPtSal6h8kPcwERhnsznUHXTVsUN0mTT4Fd7OF/xSGBd6cRY6MFN
         MJoT74gRmr2fFDo7lEWsRYefmBF7VE9STUgdvY1PHYo4gOzTrDKCKDGomaF9LAE9zcro
         /roQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pcs2uA3v2ZlwxP3hsSQgJihSxmq1c0wOV/Hcs1dmhXw=;
        b=i48fxTXyJd9gr8ZLU/GusLbSm8SujxxXYxoX2q2cMzgSCJXPLfVCvHz+NKwOMi3PaR
         URH/vDHRq5YJVv80o7GaaMSq8uyQ4ofQkTtFYiH71I2AfIripTYhGP+7hgP1+bKmsjGb
         2K0JtK8P2vXMhumeUi2Z0eOcyNb4Rh7pcNzsuFWEFHGeKP5Uq9Lwp1mwLSbKSFpCW3FQ
         9FrAU0uhlJG9n28oPRchwuwqHH4sSCyAWk/QLuKeN+xKI95ywzGYGzVVXYZZnhPEa5w4
         nUZCfKzKSIhNr4yTaabkYrv8ohAZpTAezyjpB19CLwrS2t0wDv4mwBM5i7br+eLF8Wbr
         fAxw==
X-Gm-Message-State: AOAM531BpzRJ7GTZ0rZMDUJt2GKqfAzM7XYebBzsZC9w4Eo3SIyCkilW
        BY7qjiHwJ5Xyg9IknqMS03IHqhjP6PU=
X-Google-Smtp-Source: ABdhPJwvtLku9k+gShA1Zg+DxbboMux91B2gUduIjyZ/ZNRD93F1OAGNSv7Nn96swkgOs+zVayuK/w==
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr369287wrc.158.1630539542157;
        Wed, 01 Sep 2021 16:39:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id y15sm134912wrw.64.2021.09.01.16.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:39:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] small optimisations
Date:   Thu,  2 Sep 2021 00:38:21 +0100
Message-Id: <cover.1630539342.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I think it'd better to have at least the first patch in 5.15

Pavel Begunkov (2):
  io_uring: don't disable kiocb_done() CQE batching
  io_uring: prolong tctx_task_work() with flushing

 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.33.0

