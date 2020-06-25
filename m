Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2278209BFE
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390321AbgFYJix (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 05:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390025AbgFYJiw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 05:38:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A098C061573;
        Thu, 25 Jun 2020 02:38:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k6so5136410wrn.3;
        Thu, 25 Jun 2020 02:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zNxRmn3oXQvQPjB7Ch6b6fZQc7BLz4rLSsmoLTI2nPY=;
        b=lKS4Qaj/ub5XvLezXP8/Cf7sSxgPwayRDecrz8KS/oXtkNzg76sf2DQKi/nLG+jrhU
         VYUkpp+A1AGdumnH95OyRtSjkkPXGw5HTVA9qbeKUFmeEmGEbRbK4377de5u+a09+lSx
         zt/Pb3DJ64ugNI7N+eD1Bcllqsa05YSqY8q0+I1C76KL5A5pPoVNZ/2oF2hCKKy5zuJP
         jjO35+38GBSOdXlSrNMbzfKLrNSavV/WPvmyXDG3TJjcfR2DkQ6fAeulywR8zf2JJsw/
         Hx53gaQJAkAbOw3Ur4CNtpIVqZ65pHmk9kxuIzNTTTi/1KazDo/10Zm8Xe98wPKZhFFY
         yVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zNxRmn3oXQvQPjB7Ch6b6fZQc7BLz4rLSsmoLTI2nPY=;
        b=WOENfeIbPxXGnUz/seYmQMjxozkJwPV2M39Wt6cmXYo4l19fnj3LamoVpTLCOR2FXF
         XIvSYwG/E86LXOlpoSDaw+4MBhbH4zj6cq6QlnRMZFUj6FolCj+EmE2b9oB6RFNaoiAM
         nNEeS/Z5Wa21uVUJup/PSAn68t/xKqBwcb4u7dHw1qK2Wjm9H8HRqw3FT9LtbXgT4Fco
         jCXKPsaN/pWJHPk5NW1gsSpq1RZCMZ48flLoumb+zUFf/BOtCZtPUWWux7qLkbgk+qOF
         wiCVufqekBYDBKtlmgbnIF7o9UfOODaVZ9WYO1hisqvZ1VNl8MMM/vIDQioSE12bgivg
         2xUA==
X-Gm-Message-State: AOAM5319nqAFxmG+V99njp/yUNySlQglNj+9TNZjAWTmrcsjuSx5jwnq
        c1iXm3JvisGK4MHMBf5Kj/K+9kvA
X-Google-Smtp-Source: ABdhPJyJN0p/nEuU1WII1iNj+AWgc/Z7rb40FGTjyHUmrtQJYitIfj8xFBhzLKqlHcUiuWeN6cxOFQ==
X-Received: by 2002:a5d:6a46:: with SMTP id t6mr8911067wrw.374.1593077930656;
        Thu, 25 Jun 2020 02:38:50 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id v5sm11067282wre.87.2020.06.25.02.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:38:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-5.8 0/2] iopoll fixes pt.1
Date:   Thu, 25 Jun 2020 12:37:09 +0300
Message-Id: <cover.1593077359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split as requested, this is for 5.8.

The only thing changed is 1 line moved for easier rebasing.
Yesterday problems were unrelated.

Pavel Begunkov (2):
  io_uring: fix hanging iopoll in case of -EAGAIN
  io_uring: fix current->mm NULL dereference on exit

 fs/io_uring.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
2.24.0

