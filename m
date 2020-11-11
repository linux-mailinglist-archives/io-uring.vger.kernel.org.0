Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C447C2AF210
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 14:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgKKN0D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 08:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKKN0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 08:26:03 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA575C0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:26:02 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id x9so2058773ljc.7
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 05:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiFFw8zZGY52pauMdMlJ7C+qqSJV0zI5XLyCjwLxVG8=;
        b=D5k7UaVqywSSmvD/aJjemhIHGRLKhwzTwArZY3a8JRCnWt6O3TI/ybqO4uxWGhARZu
         LyDlhC+IVa6fagWDDUSUjO1f/37dbZGusMLgDmT03aVPD0ss2ZHKWKV2Tu5STyZWJ2wj
         ArQwMdbhk9YpK/Sj7RafU7WT4k4lLLvXG8OXsjwvnK2NBf2zuT7mb4YVW7KFU7jXDnCE
         LMWv+ef9ov0F3bVtP89vnD4VBO5/BBMa0mjj/YPZL6ej2fX/dft80cDrockD+w7YVblc
         oJbA4jZYlDuoHTzzpD9cRadUaWJayeSPH2WEPSKuZ2HyDwMCbCYBlVWoT8GWtfYVONOE
         kNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiFFw8zZGY52pauMdMlJ7C+qqSJV0zI5XLyCjwLxVG8=;
        b=l+sgOTqvWNMeoxbENt2Ln+Dyy7Qd2ZsTswS1k2JYSX9Bx/vM13sWgE4QtcaTply2iT
         9EgHgdX7YIbLFxdmRoBh+BlumdsQNflGjvkkAh/U5b+MuezOJZk57F74NDBMxfhONoxR
         o8bXHsDcFT1X4rKNXxByRb87VQWQwVFQMfSNGjPtD3xYB0NqIKD11pXXRoTPDfDlOxz8
         xuTCEmk+gXm+oPoFLA55WGrC5FpatytOVQ7LERe0o8f15joGAngjmuPx0DN7dTUNatMm
         QS8oW7IrlsQQqBx6VxrVPRuesSUk4YE5hvrHUsCysPTY59PV71fTfTVuLJoVNAVpzDZa
         WwWA==
X-Gm-Message-State: AOAM5305D7IXRTzrU9HMuNw+285g4J0b602lIgaQV7R+SD1eBEUI5SXG
        1O+l+Bs4akbfst6IY7vDPGLZRAXax9IiEg==
X-Google-Smtp-Source: ABdhPJyAzShkZv8My7VuujBtL4sBDTdCe6OX++4pwrvFTqnOWS5uUgv3qwWR5pvvgZ7JIR8Osl8paw==
X-Received: by 2002:a2e:b605:: with SMTP id r5mr7662505ljn.346.1605101160950;
        Wed, 11 Nov 2020 05:26:00 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id m22sm222738lfl.14.2020.11.11.05.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:26:00 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 0/2] io_uring: add mkdirat support
Date:   Wed, 11 Nov 2020 20:25:49 +0700
Message-Id: <20201111132551.3536296-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds mkdirat support to io_uring and is heavily based on recently
added renameat() / unlinkat() support.

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

Based on for-5.11/io_uring.

Dmitry Kadashev (2):
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT

 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 20 ++++++++----
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 74 insertions(+), 6 deletions(-)

-- 
2.28.0

