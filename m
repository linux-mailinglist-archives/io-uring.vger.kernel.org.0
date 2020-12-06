Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C92D07A6
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 23:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgLFW0y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 17:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLFW0x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 17:26:53 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537BCC0613D0
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 14:26:13 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id e7so10932863wrv.6
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 14:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oro3mi3/ezGj+kUobgbNN2axELvVNeK0XLAPNMdpAi4=;
        b=JegjVeFUxyRJ6DDH5RVkcwnBorg3d95EyaqqjZtDR6rKBGgj1LIG3EgfIcCvc9wkC1
         Cv1bX1L0NGx+XQycKMCPU3nJVU/T9pQzNA+tt/xjNDXcg9C3tWfioVGdcuZ0BNwpeBRW
         sLXKWPuNuLcSKwdqMkZ3ksN8jzA7uBgZc/naGOx8fhK6mAkKbav7YmENtYXLRieIk4y4
         1Box6m1Yp2ovl7qZ4SHr4BrOu3sZnAektIoIC30ktGZy4+88U5hlcsFfma/pSwxapRQq
         k2OeeaqXir3Jm2VX5d8gfxRR/MCfRjzKZelTXRucyj6ns2Kkd/W0MeVBgR+nbj12jcVa
         cVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Oro3mi3/ezGj+kUobgbNN2axELvVNeK0XLAPNMdpAi4=;
        b=ivRMX3PDP4iIN0g4jd3NKFQz7iuTZdw48t9C1MLilSMNicLeos+TOeSO1thld2N2Co
         5x8HVNYbYFpUtrssNnGuOh8/eeF9LBErVkIc67D1IEHt3svQQLOO5Z9y3BXZB1QCLImt
         XdocCWVX5GFwZzU3aVkQkfnFuzF7Jpv/eey3MHyzfEnjlMXMZJzhCx6vPA67gam4/ayT
         4UGWZAlrDaBlsUtuqNqs0wmDId/+pVNYX2JgflgnXph2+SzToiRxcXT3Ao8RMyycK9LO
         kG/ElyLs4mbin65L0j2t8QaMRxlmbtqcmLt6eVQkGSJp6BlOeM5s0j8kznkPtjFNOJDR
         uPIg==
X-Gm-Message-State: AOAM530ZwjNC6A2FI8sAS/lvOUc4Ed4wtAcBnEOKO4HB/sC1qcFh0bGE
        zHLjuR1gY4Rk6Lm3dURXDtPu/ez+KN6D7Q==
X-Google-Smtp-Source: ABdhPJwcgbdR9axcdII1ezBFNIi6+1xDiHLrv/lWNElbBovxu+TtoUjp/2yMvx7VJiTb6oforRhY5w==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr16291442wrt.176.1607293572129;
        Sun, 06 Dec 2020 14:26:12 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.10 0/5] iopoll fixes
Date:   Sun,  6 Dec 2020 22:22:41 +0000
Message-Id: <cover.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Following up Xiaoguang's patch, which is included in the series, patch
up when similar bug can happen. There are holes left calling
io_cqring_events(), but that's for later.

The last patch is a bit different and fixes the new personality
grabbing.

Pavel Begunkov (4):
  io_uring: fix racy IOPOLL completions
  io_uring: fix racy IOPOLL flush overflow
  io_uring: fix io_cqring_events()'s noflush
  io_uring: fix mis-seting personality's creds

Xiaoguang Wang (1):
  io_uring: always let io_iopoll_complete() complete polled io.

 fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

-- 
2.24.0

