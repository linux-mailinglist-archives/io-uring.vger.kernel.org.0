Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5832B3F294C
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 11:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhHTJh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 05:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbhHTJhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 05:37:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB42C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 02:37:16 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso7011273wmc.3
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4cczGF+stmml1fk77Dmn64t7T4N9y6xg8DyjR/GayjU=;
        b=UsfbjDdAnrxOgJZylTzRVsIR6Fk9QkCiws25fW2FhUQIhS9rLwKYUtpCX/B8zOLcS4
         +u6A6PD/oCZuaRytoz52OF1JSQAUsyEpUV9WYROasLAQwOqCJbQpAD9qL5nONkgbs+ZY
         X6s5fsIv4F2uGdf57J3cGiYz30bO8A+o0A2mVKSYC6Eb1lv9++UijPiHXxaODGNV5QQP
         X3qa6acjSlLJV6GZE9BZrHcJ1luLjd9eLv20UmFzFmduITG1t1h4EUhbOzlgp1d3TUgo
         wgb0SoZj6vusUB1FLJ0BgNbkJEFFP8F8+htBWLl3BmzcKzoUOpDdX2ngAujoZKKQztfG
         jTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4cczGF+stmml1fk77Dmn64t7T4N9y6xg8DyjR/GayjU=;
        b=pUyoDjkRA/Em7ZM5GXO/YHjcdby1JwWL+e5UrCgrcRtGT4Q0msP1vTzjbA+E7LAvrl
         SqHMN78jxvtdinK7kuFVQ86ED8ElOsNiUkuzvJtgzjszEJzThJ/P/oL7bqsHEJvwO/1p
         nK0Kr67DTJGVrme6UmPZzjffcXzWip5sKv1AjGrwFhkrWFxSg/dMcrIVj76kcp2ND7DZ
         f6Rs9nd8OJ+4CZSXRUYNlqjpzI8D/1HdcSffG5lUEYJG4tiLqONk94f1YwBT2p9xlsDG
         ooDFotauDuKUZwBlBENPXL1EmtikSOQkJfkAY8kAFSdDYS0ue+dp28yxnCYZ8d6ozhHd
         3+dQ==
X-Gm-Message-State: AOAM531+3ls1SS8gUYaengDR4olpWJZEL9rAFavKdMNdRVYrf0/z9PBC
        YhH8+udI3A2WTCdduyuGaVM=
X-Google-Smtp-Source: ABdhPJzjgiin8eQr0+tLRWH4GTpuKvozdshUD99wNHGjSJ2HUpA3Pfyy/UqaU0gi74IvRHSF7AOmVQ==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr2945749wmc.21.1629452234824;
        Fri, 20 Aug 2021 02:37:14 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.190])
        by smtp.gmail.com with ESMTPSA id z7sm9693402wmi.4.2021.08.20.02.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 02:37:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] changes around fixed rsrc
Date:   Fri, 20 Aug 2021 10:36:34 +0100
Message-Id: <cover.1629451684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 put some limits on the fixed file tables sizes, files and
buffers.

3/3 adds compatibility checks for ->splice_fd_in, for all requests
buy rw and some others, see the patch message.

All based on 5.15 and merked stable, looks to me as the best way.

Pavel Begunkov (3):
  io_uring: limit fixed table size by RLIMIT_NOFILE
  io_uring: place fixed tables under memcg limits
  io_uring: add ->splice_fd_in checks

 fs/io_uring.c | 61 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

-- 
2.32.0

