Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC163999FF
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCFcR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:17 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:41472 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFCFcR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:17 -0400
Received: by mail-ed1-f46.google.com with SMTP id g18so3642503edq.8
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0m90Pi2fsbiv7eIsA7PUIUpZ33Nb37UJWkVj3kI8hZM=;
        b=BWavu0gXZqEiF7uL1QXXKTBqmXnkBlakt9+LXlwHGibiA9fuzGxPoQ9VHWW8IWgWSc
         bNfIxJ8QaT2UGvn4nKqCw9gsFaoiptIXxswkdkZYHphmDg4nVOs+FIgaCMnh4Mr6/WFR
         42TnrAKWjCw2KAGqmtkS2Ouqea6uYhGUXH2RwERv/VNHyQYKdDBYvdiXfwp8/TQSSH3v
         E88u3yKkDLkzPr+NJXoHwsCYCY/ZNZwcu3hXH/h3m6+p8Xn7sscCH6fnWGrqIQucTgmB
         R5xydGJq5pFdkUYCSclJLrQB3l5KJuuuukiWRcbN2CUdjllJ8Fk6n+fHRb7JUd84r7tn
         l0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0m90Pi2fsbiv7eIsA7PUIUpZ33Nb37UJWkVj3kI8hZM=;
        b=anHEac9f0j+ZPNlSAx4UfBYrSOJC0bkTAyH4Wh/KGxhcJXlluwUBZowCrHE1Ij26gu
         vJ5i7+4Q6vMJBEmo6dbCZhA/cpvudcPZrlxjahyIgbUGX4fsqdYrJJO3a8TENlRjbYSN
         0E3ahLUQDiJU63uYj9oPZzp8R91FsSou2RdN95xLuM0LcLkqzDdTXIdq8X5RWnIgMpch
         eqsPl94ELH0rwAAlY09GMwT4X8yVLZ7JAKUZNLczrqv+8YH+UmZLVZj5brl+of4Vh5er
         Ax2LgOH7FL5RfKaflj70EA0Dt92H7ashLvKlR3ZzQztlb+x4UxvkQR/TyWc5lKD6e8sj
         dDCA==
X-Gm-Message-State: AOAM530FRHulgSxjAO55nZgaOwqAjXbiD+CejQ7XX9L5zo6RXcPFGYoi
        1tFO3q01rtrv8UtFA4l051I=
X-Google-Smtp-Source: ABdhPJwjKVu5jTe7AZ9hoaeEm2i7Lgws1cFxLhwNjcdY1KVJMsmE5ggm+zZSloAw+a94y25XyOIEow==
X-Received: by 2002:a05:6402:1d38:: with SMTP id dh24mr7823656edb.18.1622698160872;
        Wed, 02 Jun 2021 22:29:20 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:20 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 00/11] add mkdir, [sym]linkat, mknodat support
Date:   Thu,  3 Jun 2021 12:28:55 +0700
Message-Id: <20210603052906.2616489-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This started as an attempt to add mkdir support to io_uring, but in the
end more ops were added. Heavily based on a series that added unlinkat
support (commit: 44db0f437a2b ("io_uring.h: add renameat and unlinkat
opcodes") and a couple of subsequent ones).

The kernel side of the change:
https://lore.kernel.org/io-uring/20210603051836.2614535-1-dkadashev@gmail.com/T/

1-2 adds mkdirat support (the opcode is already there) and test
3-5 adds symlinkat support and test
6-8 adds linkat support and test
9-11 adds mknodat support and test

v2:
- add symlinkat, linkat, mknodat

Dmitry Kadashev (11):
  liburing.h: add mkdirat prep helper
  Add mkdirat test case
  io_uring.h: add symlinkat opcode
  liburing.h: add symlinkat prep helper
  Add symlinkat test case
  io_uring.h: add linkat opcode
  liburing.h: add linkat prep helper
  Add linkat test case
  io_uring.h: add mknodat opcode
  liburing.h: add mknodat prep helper
  Add mknod test case

 .gitignore                      |   4 +
 src/include/liburing.h          |  29 ++++++
 src/include/liburing/io_uring.h |   5 ++
 test/Makefile                   |   8 ++
 test/hardlink.c                 | 133 +++++++++++++++++++++++++++
 test/mkdir.c                    | 105 ++++++++++++++++++++++
 test/mknod.c                    | 155 ++++++++++++++++++++++++++++++++
 test/symlink.c                  | 113 +++++++++++++++++++++++
 8 files changed, 552 insertions(+)
 create mode 100644 test/hardlink.c
 create mode 100644 test/mkdir.c
 create mode 100644 test/mknod.c
 create mode 100644 test/symlink.c

-- 
2.30.2

