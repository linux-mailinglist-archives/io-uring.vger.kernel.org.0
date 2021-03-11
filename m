Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCF1338186
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhCKXeR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 18:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCKXdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 18:33:42 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62219C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:41 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so3776036wma.0
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MY0NLcKhN3GBS8R3AGLwvY5gF9caWp30xKlLuOKORf0=;
        b=h8mNwf64HxlY0tFKyWFS6LWwXAJt+p7+k+vT/CadYx3TcKI2yOZ78kKAFS6iB2aiFY
         o6EyWkSxE9k9ujKE+4s057wVD0OihQlVv3PebNHWemYmGV3KzvaC6y/MHNa7vkeTDrpm
         kby0GrK/jsrcBBVS8UWS0o5WM/QDW33hFsLf8HvyHYGvqWpN5Ifyfu96VlKyV4+CUj+M
         nFDc7uLStpAH3l53erdwzRinFquDcYV7l/tAaxRmXc1JCXcplNEfCJiHaYrW3qI22HZ+
         r7zUvscYg2x7AN4V483GM+p4Lsa2lHwchfQXHuVEDilbDPWu9MPos4Zrqi6jk5ZzD43p
         LMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MY0NLcKhN3GBS8R3AGLwvY5gF9caWp30xKlLuOKORf0=;
        b=Co5l1SaAywALwmJodAy79VX/AjfdHeKx63grR4aOoHBmYMcZ1+/blrLkTdMw9GSnAX
         Ogb/vTzZMdEEV7KopEuKUPlKciigc8cpQ5KnNIzmm26hg0RavxsAy43P6yp48e+0Ot/P
         81D5zKl9CLM8w/HpPV4D3HUjC7AXzo3zk9zRI/TVT48sIY8TEqH1rvCXOnZM00TqVifw
         Og9lt9C5MDdNumpTugQt7C1DS29MgnX00ThpeVxFyr3mY7fS+WqtVVxulwRLmRECEfjz
         Miz8rU/Xk9AqeGaE17LeYZ4iUa0KxN/2sOr4rC9YPgllwrKbDsYho3lzzemQlly+kpot
         fHeg==
X-Gm-Message-State: AOAM532R0lQgt47Gee8S4wBP2wzpjq32YoR+nHJR/rkecEt+4C+Q1LGp
        jkThn7WeD8Q9s2Fyhx8Dd9Jfc0oZIopsjA==
X-Google-Smtp-Source: ABdhPJwvo61UGJlgpH6zecvGzkHPMQypk5WCmFLMXOVaZsPMIZ1EVZx0fQOh3C2g0nyVenshYdNfPw==
X-Received: by 2002:a1c:6707:: with SMTP id b7mr10672512wmc.185.1615505620186;
        Thu, 11 Mar 2021 15:33:40 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id m11sm5828062wrz.40.2021.03.11.15.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] sqpoll fixes
Date:   Thu, 11 Mar 2021 23:29:34 +0000
Message-Id: <cover.1615504663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-3 are relatively easy. 2/3 is rather a cleanup, but it's better to
throw it out of the equation, makes life easier.

4/4 removes the park/unpark dance for cancellations, and fixes a couple
of issues (will send one test later).
Signals in io_sq_thread() add troubles adding more cases to think about
and care about races b/w dying SQPOLL task, dying ctxs and going away
userspace tasks.

Pavel Begunkov (4):
  io_uring: cancel deferred requests in try_cancel
  io_uring: remove useless ->startup completion
  io_uring: prevent racy sqd->thread checks
  io_uring: cancel sqpoll via task_work

 fs/io_uring.c | 195 +++++++++++++++++++++++++-------------------------
 1 file changed, 99 insertions(+), 96 deletions(-)

-- 
2.24.0

