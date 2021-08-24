Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A883F5FA0
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhHXN7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbhHXN7P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 09:59:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB16C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h13so31541827wrp.1
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 06:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HrtAnA0s28VPKXs7X4rLiGdzQx7TUkFShe4+1jQaCVk=;
        b=WFRCD6p1IjkAz48GJwcUO4hXTldvBu/+YiqGCOhi7L3ndwTGrHSRTo6Zn+qzC34ixx
         i/YwFQtpijfx4q8Zq16kfNc3BxRakyHgyQ2tJ7XozjQpsMdTUFpSmC8/MFQauJUjhHTi
         5ixZOyFtxgIyED0dqb9PPu214RqD1le8ie+fHE4AFBAGySrDKYo7ga0DYHAORKC5h6L+
         yYGmYO0wXTn3FB+xD3/mor5wIypv76X41uHrl0SFD97g46gNVcmcQ1RcNfEsvmNxxR4h
         QgCL2KH+B304hEq9GzGAxyEqac05/o78h4bVomg84ktnkwM3S8CMTy9Hoq+FsmmjPUfM
         z3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HrtAnA0s28VPKXs7X4rLiGdzQx7TUkFShe4+1jQaCVk=;
        b=jlD8ZHmEtKX+LTLlThWVKp6uI1v3TjkgDlXqAh9B6SQMk/A214rzs54vdOfA52oQty
         gMhNvhzsCIBQF69pU8ehEX2qbeHmYK96z5yFRPQ8RYYdtrF5A2uwSVbFPLb75It5C3uv
         ChfP7Qp6s/kHRho04Qy1Znkm02YcRy1yM8pnhuS6kcqeeSIKloLhRfEASSMMbmSi0PIB
         tSJbX5mCOv/ZkFR97BxLzw69sqKXIV0fpMqx64195roj+VT8I10duIp6TJv2rri9CNHX
         3cUpPjMPhcUHeQRxK8hBAhY5qNM+g7D4RmnPHg0s0I0WYezR5OGyuuBI/R5LdLvUYXm3
         AkIQ==
X-Gm-Message-State: AOAM532ox1aWnbx6MHt0AZ532BbLstlUVkxS0uRWu7PlFmlW8fdTnwTd
        EfbGZmmr3fpSyaagYtbK1GY=
X-Google-Smtp-Source: ABdhPJzM/Sn4GGUFN2SeU5/3Uu2nOgorr1HoZ4FDSe8OB7OCszGxXN2O0bzxPQ405Ff9VOFzWGSenA==
X-Received: by 2002:adf:dd11:: with SMTP id a17mr19487527wrm.132.1629813509381;
        Tue, 24 Aug 2021 06:58:29 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id y21sm2568622wmc.11.2021.08.24.06.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 06:58:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] non-root fixes
Date:   Tue, 24 Aug 2021 14:57:50 +0100
Message-Id: <cover.1629813328.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/1 fixes non-root rw tests, and 2/2 makes yet another
test case to handle non-root users.

Pavel Begunkov (2):
  tests: rw: don't exit ring when init failed
  tests: non-root io_uring_register

 test/io_uring_register.c | 8 +++++---
 test/iopoll.c            | 3 +--
 test/read-write.c        | 4 +---
 3 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.32.0

