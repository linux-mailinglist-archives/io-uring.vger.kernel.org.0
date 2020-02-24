Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D272916AAAF
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgBXQEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:04:45 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38106 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBXQEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:04:44 -0500
Received: by mail-wr1-f46.google.com with SMTP id e8so11025175wrm.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iLdotcjDNyWf46l8Wal4PDAwBusWxOMOhDEH628CtEs=;
        b=QNPtIzLXM0vHx0htu2tZP+s0YzHxYjaEFvNYqGOKgzYlzd6sv7xIw1imA2LO5wlQXx
         Ddl2KBNEy/WMR4UlT9LGE+J+voaihdbEtxSdkVhFm834xuMuDuDUCgmMOrGue7OUIo7x
         frVmJ1pgHj2rQ8cX7w4ZJwm8KHtRbhzVU7KYR66ZZtl32nLeR9+TaWQn0h8XG7anazoU
         aQ4AdlUlDpXjr1qjx1XYjg6W/18Xcjz7/Q2ZJS5LFy5zVKby1fvmNEsXerAj6HdgzEDq
         f3n7DxUvgitE6URoPBM/STpSI94gw2aN3FQDpUhqXxoTT5YZS7F2efZ8hh6RLVOXzElh
         NAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iLdotcjDNyWf46l8Wal4PDAwBusWxOMOhDEH628CtEs=;
        b=XtzBrkR8Ohm1bFzG747NSgf3PeV3A4sfw/63sD10N2S92m33H7UrzqsVPB7miy5hiu
         aPTo2u/P1mCGwuPLAW4YQxlWos7+ZaGyVxmDoCGc7/w6njknJU8NCFuuxq82m2WSLECl
         BZFDzN0D2pP0AdEaK+Hf3QrKzuOgJlhbJiDk6fylGRQSjIkNnzAZhDK8uiwE3olDItBA
         wi6mvh4waRXUteb5mRqkUQlLe1S0kqtppRQWCh0M3Ap+RcP8+ksQlnB0clYj466akL5h
         Q9YY4ixwf2IUcoEI7laOPbAzM8cGxRyxGsgaxU8nh6zLSzsmnf6XgZ5MbISbF1dvi2R9
         562g==
X-Gm-Message-State: APjAAAVO8kJGMp8+oXSnQ/HBKGHmpPleMrBZcvuJmluIfQE0C9mG5a0a
        0vAJHo0+4Xlf4BLhW6McshYHHk1P
X-Google-Smtp-Source: APXvYqyo6G3tr+nXAfjr0zFrQEJAhWwSZDqewlDK05p+ngpD8er6fDZKi74cDlgCrYj45LuMeDSyzA==
X-Received: by 2002:a5d:66cc:: with SMTP id k12mr65838090wrw.72.1582560282645;
        Mon, 24 Feb 2020 08:04:42 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e11sm8600608wrm.80.2020.02.24.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:04:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RESEND v4 0/2] splice helpers + tests
Date:   Mon, 24 Feb 2020 19:03:48 +0300
Message-Id: <cover.1582560081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice prep helpers and some basic tests.

v2: minor: fix comment, add inline, remove newline

v3: type changes (Stefan Metzmacher)
    update io_uring.h

v4: rebase

Pavel Begunkov (2):
  splice: add splice(2) helpers
  test/splice: add basic splice tests

 src/include/liburing.h          |  12 +++
 src/include/liburing/io_uring.h |  14 +++-
 test/Makefile                   |   5 +-
 test/splice.c                   | 138 ++++++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+), 3 deletions(-)
 create mode 100644 test/splice.c

-- 
2.24.0

