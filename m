Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B260E2DFFFC
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 19:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgLUSiP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 13:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgLUSiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 13:38:14 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7FBC061793
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:34 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t16so12113507wra.3
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 10:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/lWOOquf8iU371RWDDo5gofL4UcT4kbNQL+WBMDLko=;
        b=th/IGGOMlSvqqJDaFr1iKDQW4VJ6sjuJbnBQ4HENaYDYxohPO1iXbnvBYM46l1+dRU
         aBIo+Y0bNu/P0VpP1Uf3yUNv8l/1MuL22CyZZikvuMHyQbL9jVp3Bhx6dEqTy/nl2GZ0
         Q7UtF2G4iOoGqyqA2FB9dDWpmxZKTai1SIAp+KUEqHuv+PYMUHvxQD+96lWv0BU5jz08
         HX75qow0UgtP+CQYyI5BCbqjfu84GvjoxgghVZgf4JjX+nFJTMgrfNKpQitg1P68bn9T
         /uY80hoqCEMHR3Y7SJPzZ/FWaPqMHG7B/Al12Z+AS01mDRXEwcFTuVdw41rFgJKA0nPZ
         g7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/lWOOquf8iU371RWDDo5gofL4UcT4kbNQL+WBMDLko=;
        b=K9Kltge3I3LCNRxHuestsxkGmSc4BwhwvtTr7ibC+L899uxg0FtFAmITfvoVemAyxX
         pX9GJ2rXCKJmnNY+czmrTNz4V5in+Tfa9j3LT6carqJuLlj0fAyBi/Ha7q/gAdTyzGM/
         y2I2XfA7gAOdGrRuhumUXUhaoPD9zg+dylHR6ahu6EVyBPSJ6wqP4S3FFXhNvKaG9IBf
         1WQ5oO9eQCRxgl7MvZ992rOzp3khT/Jbt1KxNjtMm4r2ohcTBtHWjsbRO1EEhga9QTbO
         OMCfV6lNpdN20tzfyLdt9PMzKtbPI+vCxNCkPkbFTzNGqZPU+A8evvlrgIIp516cNvo7
         sOYQ==
X-Gm-Message-State: AOAM531Cj/qAzDnKJT11x17mzOhdomum8ymwULqGHP5oZqJnmgiMcjZv
        64UmZZMtxo4wNBRIDTYx+WlWT5OISv0=
X-Google-Smtp-Source: ABdhPJwRe75Q6neeBEpfvC21xG98olwNiSw2MFC9TUZiBlT9aEfErH8r1yZpou4PPs9vz4iVS1REWA==
X-Received: by 2002:adf:f0d0:: with SMTP id x16mr20416923wro.162.1608575853059;
        Mon, 21 Dec 2020 10:37:33 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.158])
        by smtp.gmail.com with ESMTPSA id w21sm23551409wmi.45.2020.12.21.10.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:37:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] fixes for syzbot reports
Date:   Mon, 21 Dec 2020 18:34:03 +0000
Message-Id: <cover.1608575562.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2/2 is io_uring double free reported multiple times,
For 1/1 we may leak uring file references and miss
cancellations for the creator task.

Pavel Begunkov (2):
  io_uring: fix ignoring xa_store errors
  io_uring: fix double io_uring free

 fs/io_uring.c | 79 +++++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

-- 
2.24.0

