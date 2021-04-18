Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7D3635BB
	for <lists+io-uring@lfdr.de>; Sun, 18 Apr 2021 15:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhDRNwr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Apr 2021 09:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhDRNwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Apr 2021 09:52:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134EEC06174A
        for <io-uring@vger.kernel.org>; Sun, 18 Apr 2021 06:52:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so4539694wmi.5
        for <io-uring@vger.kernel.org>; Sun, 18 Apr 2021 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FTutip7RU0BH53TI7+q8Os9uFbBwhWD4czj1mwNQWo0=;
        b=g3HnXaeIz/0tuN5bdSyGMEBA9NEnfOCUJOyznGfEPK8TgqM/XTcRGcGdouTpZCXm7f
         8C1CRxAtxv/uC1gmhuuVwG/mu+7E25GtmdcUI6fKnpZvg0w2srkE/cn1LRMX1QKI4ivA
         RdXpzgs/6QAAwAEpHQVLmvQg3kz+mjXgIEBPn+YAv1QPc7P8b6fuL3cvg36UsGDeptMC
         nRFfhpmTm6/X1nTJrW+2N642gfe7VXUc21CxktH7IV+CZU4nGrIPQXhaAfYcczqXkmrC
         S5V1oA91u2ve4eck88Wyw00pZOYuoCyu7fy7mFkbK4QmeHbXITtR24a2ceJku4Jw+NNv
         S+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FTutip7RU0BH53TI7+q8Os9uFbBwhWD4czj1mwNQWo0=;
        b=Lj27FnnM9mPCCwr2e4fH+XpChgnTfz+PjTrUOI5uKA1hdpTbWTjfP2wTHpGpYYCroC
         pnbdP81iR61iVlnvuuS8yw4v7hhfpRzQi3/LV9hHtZmeUeFvG+2McHbAxx7OL6CiscO4
         +yolG1zAPuOQIWJ6gOJYj1+O/czE4fEEwRCM1rC8pBWmSFXl+sG4a2VXv2bU97s9IEeU
         ZKXMfJKpiBYwoxRawJj/yjB8dissTFVI2WTNfHrqETk9qh/5aH3aKo1RURdjCMf5l11U
         dEdZFjVZVvrCYQK0m94QmFyP3AM7fO6YM6HpMaIeDeUWtFwSm9reBK3LnNvz0lvnkhbl
         as/g==
X-Gm-Message-State: AOAM533MCiT4IPG5ZJ2VAldQrs6Z6PM7/RjIInDHjP1Wwz7XTVrqre9h
        cREvoTCfKjmUyKx93mx83P4=
X-Google-Smtp-Source: ABdhPJz+hHG+QM/yoAR6zhpC7nOjjmpY2ICn6zJyrucXl6BqDDz79PdRDUv9WBJ1s73x6/t7X9xAPw==
X-Received: by 2002:a1c:f60a:: with SMTP id w10mr6632848wmc.5.1618753937837;
        Sun, 18 Apr 2021 06:52:17 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.62])
        by smtp.gmail.com with ESMTPSA id f11sm16320397wmc.6.2021.04.18.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 06:52:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Joakim Hassila <joj@mac.com>
Subject: [PATCH v2 0/2] fix hangs with shared sqpoll
Date:   Sun, 18 Apr 2021 14:52:07 +0100
Message-Id: <cover.1618752958.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens' reproducers catches shared sqpoll hangs, address them.

v2: do full cancel, and remove ctx from the sqd_list _after_ running
    sqpoll cancel as it depends on it.

Pavel Begunkov (2):
  io_uring: remove extra sqpoll submission halting
  io_uring: fix shared sqpoll cancellation hangs

 fs/io_uring.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

-- 
2.31.1

