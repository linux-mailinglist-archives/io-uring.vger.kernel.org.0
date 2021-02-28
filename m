Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7D3274BF
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhB1WJm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhB1WJl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:09:41 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1569C061786
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:09:00 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k66so12643059wmf.1
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csWrOz98LNbpQ2oLH80DoKGvwC6lnPuSeD4hiyRXp+Q=;
        b=pDh8oXm47sjlIdrI1U9UF0uoIDpn51rmoM1KQiDRl+HWIqa8TeeSs6EoSN9F7K3F/A
         TO8N30u7+2GKPoTfHM9iyZTV54Isd8Nd33hrYJDx5UfrZ7wNmjU+Z7tp3uaWDsTcu93v
         mPzSz7yZIT5cuMJbgBsuhoWKVyHdz9GhTB9ph0RmGez1mgb1JTgukd+ihISwCLZ8ysVt
         elEfFzRJmRTXDORSz4Jo1cMsSS/BUep03zC7YNyqwu08npNLkasKKFLOh7yz4Jd1VIF/
         /9iv7kX6LHYsfwB5N1lgLI07RGtvLwiPpnJFxGiUWDM5Q47F3/dIAt8rhh1wcgUwrIwg
         9yJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csWrOz98LNbpQ2oLH80DoKGvwC6lnPuSeD4hiyRXp+Q=;
        b=Lm/v6y9WkUlBn8FA1zAPPS6Z+UOPrQZJWF0Kmw4MNQep3n5D7itV6emoVm4niHtBAN
         ui6WMk+XkiWr/r/ByS2KVdfCCFMc60IWPX8H1pYuExdw86oIrAGTenokoduxTpgzxvIV
         85kvp2cPJDm9/7b4k5MjvnJWdsNTKyFk3N3OyrQKNlS7lOwJK57ySdBwV/th/82YA5No
         OOGx2YlmvR3fi4nCX5wW5ZsxZC5lQHuxdZUj33byTOkJ1EB33VtqWM7r7xxj8xGnSKtF
         G0VjJY4Q9G6D5nkIB95ZT9Bz5z8Ie6R8zCso5d3/vN1/leEjXa9ypfhvrzAmKohTkFYt
         XmtA==
X-Gm-Message-State: AOAM533x8YCH4/Rl8UMFt5jYJQGbgN/uReH/fC1dFFTVq0KipTc0kr96
        LCqMkIHQdKg/cnMRgVBT5bPoPZvtT45icQ==
X-Google-Smtp-Source: ABdhPJxamIzTGcCebUrQna+b3l61AKcoDxRCiZC2qHu7APIIUcB3L7wfRgvKKmIVD//iHjhnDXBjJw==
X-Received: by 2002:a7b:c92d:: with SMTP id h13mr7893709wml.96.1614550133427;
        Sun, 28 Feb 2021 14:08:53 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id w4sm19780396wmc.13.2021.02.28.14.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:08:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/2] task_work ctx refs fix + xchg cleanup
Date:   Sun, 28 Feb 2021 22:04:52 +0000
Message-Id: <cover.1614549667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two easy patches on top of io_uring-worker.v4, 1/2 is supposed to be a
fix, 2/2 is a cleanup was mentioned before.

Pavel Begunkov (2):
  io_uring: fix __tctx_task_work() ctx race
  io_uring: replace cmpxchg in fallback with xchg

 fs/io_uring.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

-- 
2.24.0

