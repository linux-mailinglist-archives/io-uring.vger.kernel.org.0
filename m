Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72716AE2F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBXRzy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:55:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34527 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRzy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:55:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id z15so3141336wrl.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ngxgY1wSdfm4y4DBGgIruXRQLEHx3E2sfrac73XTzek=;
        b=AoG4vYmIE3WAppgEM/AIri+Nb6wSvWCGNq2SGxrcwZ5HxMOu34TyS3P0fG1X9C/fv/
         M9CuIeaPISZuXLf3HNjuzJHxYtg+VzKQLTdJkn4n+MdMeW8gwAzHwq/C8ttMje3Bjv/e
         JF4rVt2dnTwWhdC0g1Unbe/boHI1bSDV5L79o7BNR5Dmf+YVaD833sB0xHeYVxcbs9Fg
         B7ZDf1VxF92AREU0Dy3zeHeVAveQqG1+cvrm4lOA3Rpuce7Jd5HF3wfcNLnpqXLgaODz
         OhXv5FjWhTc7XkhjtXEyxeo0DIgrueGTe3ndZkDFmGskbWXXYNw5gvXQCa389cBLHBNx
         kbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ngxgY1wSdfm4y4DBGgIruXRQLEHx3E2sfrac73XTzek=;
        b=TkV7qgxp6rfReO9JbtsUJHUvF71agOTewdKkkuDqrllweT/iWfNIOqlrOnmftoJ5v4
         vowoH6hpzPnVpfNrjwoyBA/ZeSXHKXy8JMN86kwCnr5i9vU04o7LXg+bIQQcLfvXbE51
         oQ2PFE8+XY+yLKpok/Xu/RZP2OCMJOrpA7ZM+n+xe3wzM1Dq+p/NyiMwpbzEqmy//GjR
         rz4i+wP4zIxsxudQWErJCxH3hDN2r7HiMzjBZcYIqNkV6grqO8LYLAnCxH7spOZsXNfO
         Elhzqjl8o5yWW69ETn50/z7nrjjLZ9TkBu0A1HpN18a9omtOK5pe7yZAROcen+g1qdG/
         Bmmw==
X-Gm-Message-State: APjAAAXXcVe1icYyz1LkxdgM4wI5Tclaf0+uQgTmNeptrfExs/mroG92
        kkZdDaH3qKfE8rOGx6J3Wbs=
X-Google-Smtp-Source: APXvYqxKmV8zhAxhAyasLZ/FeZThrc52wHOZZKJsYXx21HIROCT8wdGMrAufhwuSbcnfmgy1EqLX3w==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr5407441wru.421.1582566952982;
        Mon, 24 Feb 2020 09:55:52 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id 61sm4001687wrf.65.2020.02.24.09.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:55:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v5 0/2] splice helpers + tests
Date:   Mon, 24 Feb 2020 20:54:59 +0300
Message-Id: <cover.1582566728.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice prep helpers and some basic tests.

P.S. I haven't tried the skip part with splice-less kernel

v2: minor: fix comment, add inline, remove newline

v3: type changes (Stefan Metzmacher)
    update io_uring.h

v4: rebase

v5: skip if not supported (Jens)
    print into stderr (Jens)

Pavel Begunkov (2):
  splice: add splice(2) helpers
  test/splice: add basic splice tests

 src/include/liburing.h          |  12 +++
 src/include/liburing/io_uring.h |  14 ++-
 test/Makefile                   |   5 +-
 test/splice.c                   | 148 ++++++++++++++++++++++++++++++++
 4 files changed, 176 insertions(+), 3 deletions(-)
 create mode 100644 test/splice.c

-- 
2.24.0

