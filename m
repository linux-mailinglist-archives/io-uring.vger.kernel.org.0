Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8203FA728
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 20:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhH1ScP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhH1ScO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 14:32:14 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32D1C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:23 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so11650882wmd.3
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pvNLyBM9h6m0m+j4Y4bl1w7FX8JxzVFyuNW975j0QNg=;
        b=ntAo0T0kFU4kpLL3EFl8HBNd883p2cgG14TbRp1s2sNR+td/DB4iOOyoWg/ueaigYw
         z9zdDNPxAmpZmrS91qexGD8olOSvoy5jYC0YjyXbCaw7tLTCWGSBj1Jggr3O3fcZaDse
         1Ujgkk9rstrTaBGY8q9erQiH4VlCqPx4vbw/2bmLdhUru5IZeRiHrokrYNno+2Z8oztu
         MCG4AjuQtB67kTpfbXeAAv30aHd9n66iUoomxczxmMa2b34s5ObZSch28qrHIqziBWoZ
         IYNGjXIekux2rKcSQDNzqQC1jHLxJ7WFOzs2H98vt2RKV2B+X2mWVcD2RWpKXhigbamk
         qLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pvNLyBM9h6m0m+j4Y4bl1w7FX8JxzVFyuNW975j0QNg=;
        b=pn5E/kfBtlmXS56+3Vf7Uy1QLvSooqjeyJZgKcylOu4zrcvMaikXA5cta8PxFhJLhC
         WY+P2w55uKIf9iAlPI/A/ZzyukXmA7vqIgKI3zP26gU2zqsQ2twY5nVviLKSVkhl8mEA
         hvfFQ/zaq8WDRlUDAVrpjzBjldz+dqfijkgb0h2DYKkf5vHBndVRvZdpxbBPmRX0eEc4
         Lr0EDCIcLlPzb1PZsFUa8MQ6lXulglIWXuazFvYWGtVhxPA/gwsBKAJYHdBeWC0Oxkei
         f6dJT/1EiWLgYMeL98lKascBK8pa5l8yCY3Bu3catK/IsnpxWIHYqrxbBomk38Cv/px7
         HaBA==
X-Gm-Message-State: AOAM531RGPGy+f+jXYJkrBAJOF/foFcBW8rQx8+Xmfc/A0H6Vg9rSUyb
        Benm15tqe7phba+jF5r9QlmQeXmCyZk=
X-Google-Smtp-Source: ABdhPJxW+I3R+K1I8GnQzIpcYRp7ecHofRO6q5BYJvNkXw/ShuvILjOivN6LorLH0y+qdQnUa5hQzQ==
X-Received: by 2002:a1c:7f90:: with SMTP id a138mr14313273wmd.33.1630175482366;
        Sat, 28 Aug 2021 11:31:22 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id b4sm9939275wrp.33.2021.08.28.11.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 11:31:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] quick man fixes
Date:   Sat, 28 Aug 2021 19:30:42 +0100
Message-Id: <cover.1630175370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Clarify details on registration quiesce.

Pavel Begunkov (2):
  man: fix io_uring_sqe alignment
  man: update notes on register quiesce

 man/io_uring_enter.2    | 10 +++++-----
 man/io_uring_register.2 | 12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.33.0

