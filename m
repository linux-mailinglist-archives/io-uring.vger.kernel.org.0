Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F8B2B3C54
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 06:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgKPFKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 00:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgKPFKY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 00:10:24 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4305C0613CF
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:23 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id e139so3940013lfd.1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t711Jhy7J+LzvfSsWarzgyRRjID1cHgUJaFkRTBjI8s=;
        b=Tzfrtb4qu89SAoHYLJoZobBT2n7HzFKjc+R/1aPxqhRPCOnUjAFXUXdwOUMH3VPOvM
         FM2fvdj81gSR4NkT6sBN2JyPYukHgAoyGTeN43L/sylcdJd6QTXMN48zdiHirFEiaiE+
         PL76cgas5dImZpB6Hr69PngHGzHkTdm9nxA0c4VRq9ZAj0Kx2FWuWddfPMOZgm/Wq/RZ
         uj/bqcQ7J9IhN5A8VWn14miaDaHGGYI0bFcJN39FNyHZJ6Igr+d8OT5lRQGAyNp+5NKo
         AatHg7SvDwCmTlOnWZd2aEcsZbSIxrW92SuWvAgOvdM1aeg8PPfqYLDIjy1gfSMiIx5X
         Gu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t711Jhy7J+LzvfSsWarzgyRRjID1cHgUJaFkRTBjI8s=;
        b=t5/yxMf+j9Kj/IWq3cYK+TrDfwiddTOJW9oCEcuIPo+i/F0M+Ms7JltTODibmrR/zv
         pvj4Jr7wNXyAdEmC634QiwQm6zdmXXKvTO6n+t9bjY2J7kctCrXYaCPVwATxdYb43aMn
         CW6bz+25OVjf4deZyY+HH/689L1Ky15GCA1thby8zJjP7qGF6/Z63gJ9uGz41y03BcP8
         HUU04fQWueTQfKL8jhtc4xvu0UNn7a58Jp7R08uOLeNBer2nb4tATM7nOK5OrCNPhhkV
         eaJN/dEke6ieG1YJ0pV0+vqj+eTnFzLgy9342zorjeOgmDj8QRuiVmrnnE2vWZqfUPM1
         yOpQ==
X-Gm-Message-State: AOAM530rl6CIfSxMzPDvLf2I8uMsKZsbs+J9yfBX5MGbZSwkth4NuFTG
        njxXfdGGw/vs28/KkLz/Q4kKfzlpJREkWw==
X-Google-Smtp-Source: ABdhPJyReqV8yDXsYZcmB7eiC71+mFsctBNylO9fGFK09hOAmnNtENZL2SsRmlvQOUJHP0+fS2Cjog==
X-Received: by 2002:a19:8112:: with SMTP id c18mr1773582lfd.455.1605503422139;
        Sun, 15 Nov 2020 21:10:22 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id b79sm2595909lfg.243.2020.11.15.21.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 21:10:21 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing 0/3] add mkdirat support
Date:   Mon, 16 Nov 2020 12:10:02 +0700
Message-Id: <20201116051005.1100302-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series adds support for mkdirat opcode along with a testcase for it
to liburing. Heavily based on a series that added unlinkat support
(commit: 44db0f437a2b ("io_uring.h: add renameat and unlinkat opcodes")
and a couple of subsequent ones).

The kernel side of the change:
https://lore.kernel.org/io-uring/20201116044529.1028783-1-dkadashev@gmail.com/T/

Dmitry Kadashev (3):
  io_uring.h: add mkdirat opcode
  liburing.h: add mkdirat prep helpers
  Add mkdirat test case

 .gitignore                      |   1 +
 src/include/liburing.h          |   6 ++
 src/include/liburing/io_uring.h |   1 +
 test/Makefile                   |   2 +
 test/mkdir.c                    | 106 ++++++++++++++++++++++++++++++++
 5 files changed, 116 insertions(+)
 create mode 100644 test/mkdir.c

-- 
2.29.2

