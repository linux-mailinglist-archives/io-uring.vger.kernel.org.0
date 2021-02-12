Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE931A4AB
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 19:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhBLSp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 13:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLSpz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 13:45:55 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F16EC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:15 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i9so554150wmq.1
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 10:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sZR9nDL0NlKjoMn+/OL9WrUQmLgnFwKV9VX4gMGbv3Y=;
        b=bBNGHH/fVAijJEQcLUez64wGJ0aNcXyLLAhc8qbtbEwuXGZmFKfAyZh1E6rleKDXE9
         25SH4JeUD4+ee1uzj68cjLGuRxbVOr1AsbggcIunYOmN0nh2a6osJ26z/6mQ7iywQbol
         WG+cCY/c8i9jh7XO9bCIRSUWR1M0Hu4u7z5XsNQnK+7x17QZQA9vLjA/+JtGTCIE2xh7
         p2406MB91INQUGzgI8ffOTOxtpU4EAAPOiXzpFnFknmN1CvkAziGF9GsoybOCKhnWmNr
         g9ubSd68VJC6yBl/xsY5ckFSpG++h/WlpMtGXMJCFnYwtlQ1S8vXqH4mMNSd9H584UBq
         iXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sZR9nDL0NlKjoMn+/OL9WrUQmLgnFwKV9VX4gMGbv3Y=;
        b=tu2wLOKGrWDb7l4NAisw4hP3Ss9GnivvTswhqXdzfsXF+FrE/nUZt2ZX/v5VJKRMUn
         4pp7sjAFg3Mcq6iYyuPz0iqmJkk4GVgCfroNgyNcMRMl+0k0EfyCEjLX0429ArcWAZYa
         i2zhSthtYcwW4FdLVZjxOBjIG73t7VLyGaFhoWotGPj7YfTRG4eStCVp+M8Oy9S5n6Gy
         Q4q3hdVjJxRZDrqAXkzWE57WldaA2p4mHTwq0PCF5qgi3FIbb6OYaTk8+sZehXchBF+P
         5SegtMbBtnZE9aQplL1RCIRSQMUIjzWWjIr1ETF3Te5RWuI1YynEgaD6RF5HAO2EFrr2
         vbXA==
X-Gm-Message-State: AOAM531v7y7kWHDgD/lwJyrPCPkE0S99xUINH8pTjFgU1y6021Lhm4OY
        m03vnVBH4WNvCCP0oqU9aPk4E2FniGH+Iw==
X-Google-Smtp-Source: ABdhPJwpM/3mu/e2e31p5SorkyhYfnrnEB7+PYJEB975XlcKeLddbl4QqnqFswKRUO0M0JRyCrbpvQ==
X-Received: by 2002:a05:600c:4fcb:: with SMTP id o11mr3875106wmq.88.1613155514041;
        Fri, 12 Feb 2021 10:45:14 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id e16sm13452830wrt.36.2021.02.12.10.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:45:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] small cleanups for 5.12
Date:   Fri, 12 Feb 2021 18:41:14 +0000
Message-Id: <cover.1613154861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Final easy 5.12 cleanups.

Pavel Begunkov (3):
  io_uring: don't check PF_EXITING from syscall
  io_uring: clean io_req_find_next() fast check
  io_uring: optimise io_init_req() flags setting

 fs/io_uring.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

-- 
2.24.0

