Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652DF319257
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBKSfB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 13:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhBKSc4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 13:32:56 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE5C0613D6
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u14so5193707wri.3
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k2YiRsuD0JK5NDT6TyGvjGtnNFJ/ejb9qhxz/sdvtkw=;
        b=sATntBgtJAcib+sIYQzytZaiIKfeUKWkqi++YJ5RYNuTM2Ua4c9E8MzZ77lFUg4iLN
         H7+GV/uMCpQc4Gf37q/Z9YKDcP6ic8ejMoaFCVuQcu1G9XuNxz8TaY9fHZoYNsoK58dQ
         r14A6lohcmIxGi2Iait/mAfbFUSWkGZfhpAJ2N9elDD6vTqsU7opP2F3FR8fm5Ot+UxO
         IRNCIeJMdydQLb1U+yLNbC+m+4Chuv0oQOoGWSyn8PnUS1GJCAWOGGv+nXtK4Z9GTyPa
         1n61G+aV2D/IaHT1vZXc/UCgrubWA0Fnh8fPfw6Yf4qhq+YEVlIOTASfACxpIUzoIOsK
         IGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k2YiRsuD0JK5NDT6TyGvjGtnNFJ/ejb9qhxz/sdvtkw=;
        b=b3R7gcprRRIMy/i8oWyhrrrrweUZQVG6fccyPSBaSsRip8ki2zuWNMbtk9UYFOU7O8
         +PC1wP6PS4Gp9Y0KdIiXaGFOx8viPoM8o2qzLyvj4aIvb1Oj+WyCfDV3udoIENXifHc4
         tlsAFlPp4oTWpIR5ywpIIHVEIsuhLcVP8Ve3BcRWUGsdVed+afQ2L6ozvRva7Tm4gB3M
         HG1kNeWm9vp+8w4+rbcdu+fAfAgaeQGj58pA3X2L/I7i+maNxNSVZdtYIowJyRRdbHAH
         2v6BDHNasQG1iGFKAaFOZQXbEvCRxP3KTDWIw5wsPC2yXDfN1p+PVr2bY9yBJkABrBnp
         kZ2g==
X-Gm-Message-State: AOAM531tyM1exL+WDj6T7XBrIU1RpFcMv7LvkdYjo0ZjZHEICpIhRwgY
        YnwE723O/4xf7TJG2Ka9knOpKQjwVTtXkg==
X-Google-Smtp-Source: ABdhPJzm6nxqtgUVKVS5MIshq6zFSCVJDU5ta2UzFMz/ihjpGMCnqGOkwmGypfFpletBa7UupwOx0g==
X-Received: by 2002:a5d:408a:: with SMTP id o10mr2005334wrp.427.1613068335326;
        Thu, 11 Feb 2021 10:32:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id a17sm6501595wrx.63.2021.02.11.10.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 10:32:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/4] complete cleanups
Date:   Thu, 11 Feb 2021 18:28:19 +0000
Message-Id: <cover.1613067782.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Random cleanups for iopoll and generic completions, just for shedding
some lines and overhead.

Pavel Begunkov (4):
  io_uring: clean up io_req_free_batch_finish()
  io_uring: simplify iopoll reissuing
  io_uring: move res check out of io_rw_reissue()
  io_uring: inline io_complete_rw_common()

 fs/io_uring.c | 67 +++++++++++++++------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

-- 
2.24.0

