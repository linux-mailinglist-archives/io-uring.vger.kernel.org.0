Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A3114ACF4
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgA1AHl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:07:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52519 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AHl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:07:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so584892wmc.2;
        Mon, 27 Jan 2020 16:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTXjr8tVOQkfJHSo0XVMrHJqxoUMxLgLf0oJacyLO7A=;
        b=jtfW+GqMm/Mvc/t2CEymMRh5dGbQuxyxifXIfOMTYelP5m+D/2VolhId6Su50/h1Ja
         6DzL1xOgWy8KHf4ckuBH8Gx3GqPkLtYnT0ypSac/sCJyyVOn512Bfxg9dTqRtEFTM+b2
         xphFCgTiQX8r+TDvfBQZwZDN647xrsVCQ9aSEUlwQNsbW6lKjjSJEBH2AUAm4o/FfdON
         ye6H7cVT8KBYhrmkdAHlZ087P2IAnYgfZTqz6u6hr4892C2ss2FRp+uecjhUw9uj2nKt
         z+3jKhS0kYx5Xlai6Kl+P4OnhQ2g7HEmr6lN4XyWQp93mOhzQKu1m0rGsrnas7qqFTUY
         ECNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTXjr8tVOQkfJHSo0XVMrHJqxoUMxLgLf0oJacyLO7A=;
        b=H8wk1oK4Gu4FOzmcnBP1cAI8ovGErg54AsiRL0RN/NruV3Uk6LZGuzf7TxOrp7La3N
         oi06vy7mb+sExXcYCgRciOlMjsBjtKG8sBJ+jdOgwU1WqvKD6rVre3ZVDzSl8fT4tv2V
         cvK7P6CAlEqNv6xmqo13d6pxkvbJDcB2aKA68ZMnVjBkVOYWavr69iNab8AqiahgbhXy
         eKplTB0e3MnRei48lzTz/t5x9i/YfaNSEmLRN2mTh+6sbIPiWP66UYjg02u82fhJr2ND
         t6wm8mF2fNuABA/lhwPNq5aigpOD/q7OkZRh9ZW32djW5IjMooEX6QSa/3ne42D3v5s7
         YFeQ==
X-Gm-Message-State: APjAAAWsS7OZ2y2rCgCYYid8iMfjauOy23d78U5XqHqbqA3P8lNBoJqT
        e0zCX0REE64IOBE/oQMZGWg=
X-Google-Smtp-Source: APXvYqx2UKoDfaskogAMKvMcI4rOKS1mQc/PBTe02SfAoz5FVpNjyJLR4KTxhg9pyAJYK0M2GG38/g==
X-Received: by 2002:a05:600c:2150:: with SMTP id v16mr1163280wml.156.1580170058994;
        Mon, 27 Jan 2020 16:07:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id y20sm577193wmj.23.2020.01.27.16.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:07:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] io-wq sharing
Date:   Tue, 28 Jan 2020 03:06:50 +0300
Message-Id: <cover.1580169415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

rip-off of Jens io-wq sharing patches allowing multiple io_uring
instances to be bound to a single io-wq. The differences are:
- io-wq, which we would like to be shared, is passed as io_uring fd
- fail, if can't share. IMHO, it's always better to fail fast and loud

I didn't tested it after rebasing, but hopefully won't be a problem.

p.s. on top of ("io_uring/io-wq: don't use static creds/mm assignments")

Pavel Begunkov (2):
  io-wq: allow grabbing existing io-wq
  io_uring: add io-wq workqueue sharing

 fs/io-wq.c                    | 10 ++++++
 fs/io-wq.h                    |  1 +
 fs/io_uring.c                 | 67 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  4 ++-
 4 files changed, 67 insertions(+), 15 deletions(-)

-- 
2.24.0

