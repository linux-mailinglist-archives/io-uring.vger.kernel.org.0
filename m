Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE571603C9
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 12:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgBPLPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 06:15:39 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44119 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgBPLPi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 06:15:38 -0500
Received: by mail-wr1-f50.google.com with SMTP id m16so16156584wrx.11
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 03:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXJXYlgp+gZ/gXDwL+/LHuf44nc/yMeUlmVbB/JcP9k=;
        b=LhY/BC5zVPAll0KmaHYuKWN5pNQJRxCkarxTm8sakcVQYVo/DMSqCHu8RD9n5k5VxN
         Er9swysB0ranT4r/bl6cDMeLbaHNynDcEQyZfZF/YX004Oyn1vIRBr+E2i6I73KxseQZ
         vDjAuP4Us7IIS3Gdpmq+KJA8PyGitkPrr+szJmmmehVjurhNyVNlcV7ZqTfBopX1kloW
         ZTC9ndKxThZdlbbTyy9yq/06s4vqToWiwdSZq7BryULYm1QjFqYe4Tx5UD6X7FE5lC07
         6j0UN59BKjBc0EQyTmdf4OHNtrGJTJuxuiyPJsrgc2WR7LqChpMum/xVjIh1dx7ZkOnS
         SZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXJXYlgp+gZ/gXDwL+/LHuf44nc/yMeUlmVbB/JcP9k=;
        b=qob5G/Z6ZDnh6o/NuHFBB0IUmn0ScDQcK2SuluzdkCZBWlTavc0SgWN7LukCUz0xGG
         N3uIBcNjFCdKVi8Ct++XCm2DN/qJCkurVLoV3gRlWAt8p87hs6dpJmE09l3rsa4KGdPY
         OPvIILSftyR97wxPzG4ZDTa4xDhc3r+yH/9oygtMifdfTl88KBkPsc0Le52R8topLKoj
         YoD9WNdVP9xiW79/BQb755W+Narh33dfg/tAaXAs/+KjfuiwQx/w0PG7yK2xDm+VOzbk
         LmSuuEHy3Sv2+DQTCtLUk+bWE4GvYtJjX6f9p+MV776ZV0Y6tx7J86fEPDNJIEJfNZJd
         /FYQ==
X-Gm-Message-State: APjAAAV6L/ddV9/bzW4GPHOlbRLLHtkeW/3OWVXrWw6Vukg5J9LmjNLh
        e1WSBjZY4cfeVuvsFHDhMesSpX1X
X-Google-Smtp-Source: APXvYqy2BS/9UjzN9fsiSxUDxLINLwpwXnZljRdYqNNOF4/dOgPY0I2DbTJ2XTdiBquQBx7Mtx1jAQ==
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr16487298wrm.394.1581851735085;
        Sun, 16 Feb 2020 03:15:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.140.114])
        by smtp.gmail.com with ESMTPSA id 25sm16232033wmi.32.2020.02.16.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 03:15:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/2] splice helpers + tests
Date:   Sun, 16 Feb 2020 14:14:39 +0300
Message-Id: <cover.1581851604.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice prep helpers and some basic tests.

v2: minor: fix comment, add inline, remove newline

Pavel Begunkov (2):
  splice: add splice(2) helpers
  test/splice: add basic splice tests

 src/include/liburing.h          |  11 +++
 src/include/liburing/io_uring.h |  14 +++-
 test/Makefile                   |   4 +-
 test/splice.c                   | 138 ++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 3 deletions(-)
 create mode 100644 test/splice.c

-- 
2.24.0

