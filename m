Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91FA3B30FC
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFXOMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOMo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA5C061574
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l21-20020a05600c1d15b02901e7513b02dbso960854wms.2
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ogqmxHOfecDeSQlTkhRc2yVLpQRwHjyRSbv6CJs1q4=;
        b=Zk/Z2nywcRAKGuG3cLV5HZHFpmjKAO0ef1EkrA7ahU/nFALobEiHYLIeRE6U+rpwEK
         NkYuPOf6axP18r3+V6WDpku6TT99yzq0TajanxLAnoRDVoteKNO3wfIaGgi96YIHTvOF
         uNm0mVtXs3ljWFJfVeetaLmn43JdAuKWAqnA8tXulSFQpTIwzdEVbyJ+JmaON9Zt3y/s
         axsvNNHfP4HBNRgQXIA7+mcJtptRWtAiLIRtWCIALdBYJn/aUMkd6lpKFo/TOymfxJRw
         6ogzyFp6iDt020sX5R/zqzNnJ8lKJDcAznDFEMix1WUtrWNFvWq+mUxZbRnHWe2mEvaJ
         M7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ogqmxHOfecDeSQlTkhRc2yVLpQRwHjyRSbv6CJs1q4=;
        b=nFhKw9e/UVWqr8njgIXM6Im5+1ggiw5bGG6gFvJHFtxTUtHsNfUP+ybmaS9ldingF/
         yxCgefwIjqYPZb/uzCfmyamgjN7GFcs0c8ufGYMsSc7rNU3P1M0Kc5Wc0XczaIh7OHjA
         AF/fo23WXPZAsBRxqggmYEJr0/1RL5U7qfUew75Gccc8oHIfMzN+iKpTAxj4onu2n+aa
         rg7PVUpg792fHywoIIPxzpg97jT7rXneETRQvrUcBCVtsKBaVkp7yFEvuZZMsOire+3e
         sWFnM2xXiuZsk1hVUNa64c4iNb7QrthIWQzSPQ6kf9W3Gl3MxL7OBpP545CJLW2HHLJy
         TjiQ==
X-Gm-Message-State: AOAM533xUAkC56704tx1zThQiq6zaNzBElprMyA0F0zaZL77ce/twxSo
        mAnfDpxjdhJCBAR66dI/lLk=
X-Google-Smtp-Source: ABdhPJzqQSWkgZI5Boe94z54W68/kvSPNH/OI1q5ZD8qY0E+IqfrP+qxaj5JbJPhmxFL0MngCh7b7Q==
X-Received: by 2002:a05:600c:2293:: with SMTP id 19mr4534793wmf.175.1624543822746;
        Thu, 24 Jun 2021 07:10:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/6] straightforward for-next cleanups
Date:   Thu, 24 Jun 2021 15:09:54 +0100
Message-Id: <cover.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On top of 5.14 + mkdir v6 and friends.

A bunch of small not related b/w each other cleanups.

Pavel Begunkov (6):
  io_uring: don't change sqpoll creds if not needed
  io_uring: refactor io_sq_thread()
  io_uring: fix code style problems
  io_uring: update sqe layout build checks
  io_uring: simplify struct io_uring_sqe layout
  io_uring: refactor io_openat2()

 fs/io_uring.c                 | 67 ++++++++++++++++++-----------------
 include/uapi/linux/io_uring.h | 24 ++++++-------
 2 files changed, 44 insertions(+), 47 deletions(-)

-- 
2.32.0

