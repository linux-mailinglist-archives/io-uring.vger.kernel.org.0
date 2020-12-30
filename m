Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203432E7CB8
	for <lists+io-uring@lfdr.de>; Wed, 30 Dec 2020 22:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL3Vid (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Dec 2020 16:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3Vic (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Dec 2020 16:38:32 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D326C061573
        for <io-uring@vger.kernel.org>; Wed, 30 Dec 2020 13:37:52 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r7so18626413wrc.5
        for <io-uring@vger.kernel.org>; Wed, 30 Dec 2020 13:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8qzfNmMZ6VsaLYdD2wW+EK66sTEejsR1NxI3D9QcYdI=;
        b=eCoNx6XXOjMFidNvyP5nkzOjg1Ehj7oJYi8RCjKmYgqAwrZpe+sEIuN+adch6w88La
         uzaqEvs5MEWdOUwglKmm2WtFRrCRU/3VcNm07sPFUtu6pIez1IpfjAqSWxum7EFQUnXX
         VHvjz9yUSEC2TxGqpqufLU/3ECmvCgmC3JPerzOiB6Ebk1RtnCxBSWxBoIEwR6aNzTPc
         hN3hxZ8rCkBTg/KfOr18eav3wVLEQy9iMj2YHPl+FFGHxuNwOMKjYwNlZRWeH9EsW2Wt
         6vFYnYHn9FyGdWQJ9yfiQPLYo5w/9YTXIEyaG2unRiuTjNX8bFuhUnk9kTLmjPd3Pg/L
         DySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8qzfNmMZ6VsaLYdD2wW+EK66sTEejsR1NxI3D9QcYdI=;
        b=dcWCT7hBEyxkme9JRizkr5guSNXmq39UuXm/Mo5UTXBOB8q/YW3c9pyEo68oTMhSaK
         l0rPKMUgdJSD11SSOe292+Vhodz2vy8vpfVrjsLpteNk0TMSXDTLQuFB3XcENfy1Q0iq
         jgOm1+35oJOxU/ZcAyiJg95M3SjsheKTeAcQyu6Ekc/D+kHvOyRtnblwI90iDEqwktwP
         UZf+VEZKYC1bjLJ+CfH698ndJ4lzgjVQSJas+itBUl8RudM4DwgRofhDMi0L4JzaDIiO
         M6p2E/v+y3VRT3BrfVYGoPx6jckIGhJvKPWoEbImeccs2/FBcOeAl2K1JaElFmYseMIT
         flEA==
X-Gm-Message-State: AOAM530yp1zYq0E4QpGk33j58AaEmkVcGfrkm+TfyiJnZrbPBrNIvs4G
        LWgcIWfeAQjIFl/uHZlUcaUks7nAHnY=
X-Google-Smtp-Source: ABdhPJxXha1mgD3s4jbUe1ILfI1A4FxfDfLHfDMtvuFiWE8RQ5L+Noxoc2HuqS84JwAjhmGryy0vIw==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr63185403wro.156.1609364271270;
        Wed, 30 Dec 2020 13:37:51 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id 125sm8823626wmc.27.2020.12.30.13.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 13:37:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] address some hangs
Date:   Wed, 30 Dec 2020 21:34:13 +0000
Message-Id: <cover.1609361865.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/4 and 2/4 are for hangs during files unregister.

The other two fix not running task works during cancellation.
Instead of patching task_work it moves io_uring_files_cancel()
before PF_EXITING, should be less intrusive. Was there a
particular reasong for doing that in exit_files()?

Pavel Begunkov (4):
  io_uring: add a helper for setting a ref node
  io_uring: fix io_sqe_files_unregister() hangs
  kernel/io_uring: cancel io_uring before task works
  io_uring: cancel requests enqueued as task_work's

 fs/file.c     |  2 --
 fs/io_uring.c | 54 ++++++++++++++++++++++++++++++++++-----------------
 kernel/exit.c |  2 ++
 3 files changed, 38 insertions(+), 20 deletions(-)

-- 
2.24.0

