Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD15A46878F
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhLDUx0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 15:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhLDUx0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 15:53:26 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF13C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:50:00 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so7538979wme.0
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlsYgULYf/2hIIKqDVjSQW4xF7WYzwO5MT5GQmwL7X8=;
        b=OkFCjEPgXz8uFjbpz4TtLqtJMAGIzqUx4IgW99jf1UZeuqHQCnHS+9POxnQYIP9G5o
         VsFoMkyfiYyeWB/A6fgt3Hoz1LGUJkGoE/IKMeA66SFCYEM+lmDu7zhuQi1TTlHZwDHV
         UFYpIfq7I9RClYZdJnCD7zfg4WA2YtyE/r3aNwXBCpeP/Yukhbc7OlhcRQsMHfIy1ze9
         Un3DtzOdg2YeAgXEr8o/YPDdK84o8RuDeGuKRgMQ8lsYgcWKX25djfQu65Oi/h3tM/eH
         ldh8znvPkMay6myEw3BlNS4SJ8ISOBtdXEdado6wtlIX+p8bFsPujqnpSCiWSmIyWeMC
         cCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlsYgULYf/2hIIKqDVjSQW4xF7WYzwO5MT5GQmwL7X8=;
        b=R5/FWtQEjDU/J/fuWfAiFj+nVjUOyhKJ7jxU3ea/KQIba9NVXXXLmy3UcEfbKBhwqu
         fIkdS4/6f1Mh6G6ea1MatRuQV2myhbKAcvAvDa/U3eVyy5MhX1CLW5gxOlZNLZ+7L7hK
         izfzZ3JhGbE+wAnybQQBSMfo7skeYuJTzV3Nuky/bDAtzw0ewX5FkNWQcbywwnSdR8rR
         tjnwHQi+VtOJTHO0IRSZrs6zeEOCNDBUiyJEeWkiItjiEEuhYMzVQokrsFnVfRudiDVE
         IYrJ5SzxfzeakXTxfWdd9Yiy/wMD/z4KcgFTN7veVqNWzau0mjOFLr1cxXiJ4kqwwW62
         wTVw==
X-Gm-Message-State: AOAM531PBe2bZMgyDldbdnb0k+BM5L0ilygiSrlnfDmw/nayzKb/Q7Ps
        auWIih5o5AKITZt9WH8HWTxdEtlxG8s=
X-Google-Smtp-Source: ABdhPJxGfI/uLdmP3Uf4ZhP7Yydmg5G53AcA8KxHdmtQyEG4q45BjM033fN5bjHOKHujgZRepR/K4A==
X-Received: by 2002:a1c:a592:: with SMTP id o140mr25785472wme.10.1638650998391;
        Sat, 04 Dec 2021 12:49:58 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id k187sm8393143wme.0.2021.12.04.12.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 12:49:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 0/4] small 5.17 updates
Date:   Sat,  4 Dec 2021 20:49:26 +0000
Message-Id: <cover.1638650836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

3/4 changes the return of IOPOLL for CQE_SKIP while we can, and
other are just small clean ups.

Hao Xu (1):
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()

Pavel Begunkov (3):
  io_uring: simplify selected buf handling
  io_uring: tweak iopoll return for REQ_F_CQE_SKIP
  io_uring: reuse io_req_task_complete for timeouts

 fs/io_uring.c | 91 +++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 53 deletions(-)

-- 
2.34.0

