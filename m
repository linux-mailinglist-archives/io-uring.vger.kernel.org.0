Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F0B3198C2
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBLD23 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhBLD22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:28:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB80C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:48 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id g10so6377299wrx.1
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0oQN2n3iWG+eWYmcQhS/4asaICT+W72kc0nwiIkGi20=;
        b=h1EL2Fqx2DaAggf0MzaJxKRBUayV+Zpd7tTSFYTuv1eh7HToBQjKNsjqXvUa0pkiTC
         sI2A1oj1A4gArCjRZ1VdVrlyKM5TWjNj8buJ8KD4Dbl975LnyzPIzWfKOTFkzpUIblpj
         3OEoLEp5HiUSBq4XuYSrMN0EqBhUJyutGqDD3clB01jBKhuy17UyPJHCvXJk4LMro0lr
         rGaFglFkISUT8AI1w30IWDmtufKZPyr+3tZ2bbRtp9525gKd7k23S2DXgFYNNz/FeKBr
         aeK8I6HhRymBe7hQczkoeDK2sEqC58AXQ/2YXNrfesTaXAioWQIZkhB0BSCFEP4kEQNz
         5Q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0oQN2n3iWG+eWYmcQhS/4asaICT+W72kc0nwiIkGi20=;
        b=Sx3bUIgMsxsvwuFYSnYSq38/s5YnI8ILpaohyUZ6u/R71IdjgIFzzdguvKuyfNyz0m
         D3iFlddQNHKjelqf39UmOQinuIwJ1wAgu9VDTGk+HjJpxjarPR7tNBdFisk9woNbCroD
         d5CQzkNwU9Ca5VnPlTrhewIQGP1DeP3fV50QDv2yB0TOj21SlfHSduPdufY+lr3ueMLv
         8AJsXSxf1Yw5+L4q22bno7C1fCdsjRab+ov9uRM6fbJtrbmcVaQI/Fw3N0ll/jfjRzgP
         KIYWaR9bz0Fti1clX1UQc/S05DP5Jfy4jkdgXLcRG4dpy5g3qRy1/Ue03hYsjoKUYHb8
         1IKw==
X-Gm-Message-State: AOAM533+kCm1cWf9kRsllJdLZkf3Yl65gkP/BKBWfmixNgL4xIqyGD7W
        goBIIFW0oyXYVLOmvYCP24s=
X-Google-Smtp-Source: ABdhPJyPaU3MmfqHtybL4ItbGanQeftd1OnbtLV2q96Hn16Chy3dlscQuvKpVyOufw/pdo2PEownJw==
X-Received: by 2002:adf:8365:: with SMTP id 92mr912886wrd.23.1613100466973;
        Thu, 11 Feb 2021 19:27:46 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5] another round of small tinkering
Date:   Fri, 12 Feb 2021 03:23:49 +0000
Message-Id: <cover.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some other small improvements with negative diffstat.
2-3 are to address acquire_mm_files overhead

Pavel Begunkov (5):
  io_uring: take compl state from submit state
  io_uring: optimise out unlikely link queue
  io_uring: optimise SQPOLL mm/files grabbing
  io_uring: don't duplicate io_req_task_queue()
  io_uring: save ctx put/get for task_work submit

 fs/io_uring.c | 103 +++++++++++++++++++-------------------------------
 1 file changed, 39 insertions(+), 64 deletions(-)

-- 
2.24.0

