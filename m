Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FD22EC908
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 04:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbhAGDUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 22:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAGDUB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 22:20:01 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023FAC0612F0
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 19:19:21 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 190so3998235wmz.0
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 19:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLNNLYTSZMoWSuRX9SU4m1+drUWOUYTBBqEJSnpf2l4=;
        b=DMPbqY4w0V9viSaJ3fZSGtkDXHuQ14rJvel0cQJJEUgsRFJYbiWLEJTM/vfTM2mHgi
         k3SODkvWtkof+xD/ZOLBvw1VfoLVtGf2vuaDftrjJUz+NAi0LnzgsP19O1O/3G7KuMu1
         tRy8tYhtehHQQMAP+y3/hKcr28Wqvbudyj3sH2/LTgvFfjxLnDlcaVEflSlWkx/jVPEe
         yrLK0dHIV9XyqirT6EUVKESeLAeyvbkbjKJrE2GodiPu6myW6RwQiriiFJ9MLi4XoIMA
         /WWPTHXe1lAjbdG6auk5BYlrTXKNZ+Eq5lGXMi/lCAUwNfoC/t5BLZ+ZwWZt+Fwc4KK2
         BQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yLNNLYTSZMoWSuRX9SU4m1+drUWOUYTBBqEJSnpf2l4=;
        b=ETL8DqbVuGVImJRfmTQkeRBVbf+SV+tDDjCIOov+hxKO4aH9hVtTdJflHeRT0b64rc
         LnRtWSvDoOFpV68VXsVzCJ90Sfv/F/Ufl/HueWu32WZNAraiFy82/aubTmqJAyiTvpWb
         dQ/rv8UC7zcC5xla6ciaJV2A0pHq+zgH1zVTfpd7TOjNG+rFY9lbFNNmhNmFO3kJqCHg
         9j1JEZof6pNnpxOXrO6Rj21HDx/pMxKCFnoAqr89S5EnernCjClj3t7Bec8VoUmNg0vT
         DQebkWw/wJTrmHrTrMjx4/zwuj2AccAeH2T8lC5Suc6guV0h4YRTu5hHNG1RsDUE35WD
         ob9g==
X-Gm-Message-State: AOAM531HPPrjpDVKSuvw7BUxEaVezi55iHszyuY62eT5wP9PO8OyiNQQ
        +w9ylKOG6XnaAfR8sC1g+7w=
X-Google-Smtp-Source: ABdhPJwWoWhRjgvkhP28pnYQlVqVgvRxJ/LkXtDUhlrIlyylA02kp6hjnZi885dcluDrJaxCaAeViA==
X-Received: by 2002:a1c:17:: with SMTP id 23mr5929319wma.35.1609989559783;
        Wed, 06 Jan 2021 19:19:19 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id t1sm6181430wro.27.2021.01.06.19.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 19:19:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] commit/posted fixes
Date:   Thu,  7 Jan 2021 03:15:40 +0000
Message-Id: <cover.1609988832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks like I accidentially didn't send this series.

Regarding mb in 3/3, I have a for-next patch removing
it (one mb less in total), just prefer it to settle a
bit so there is more time to be reported if anything
goes wrong.

Pavel Begunkov (3):
  io_uring: trigger eventfd for IOPOLL
  io_uring: dont kill fasync under completion_lock
  io_uring: synchronise ev_posted() with waitqueues

 fs/io_uring.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

-- 
2.24.0

