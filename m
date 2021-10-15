Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8F642F7B8
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhJOQMN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241133AbhJOQMM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:12 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE7CC061570
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:05 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j10-20020a1c230a000000b0030d523b6693so3418619wmj.2
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGUHuYsJqAFrhuayEQJxlwW+4/wpslPvCS6hl8VoWO0=;
        b=bs5T0+xxPgHr7iQfwWW/xdhEYuA5eqto1Byj91bEpa8gJRYx/fwxKA/3RffcMuEEGj
         TQFI3K6pO8VbfiOaKIYKwQ+XpgxRfns6Jciyei2xjqFydR8TSiAPZDUChiygQc9huNpB
         ozHl+R2ccRXFuY8SQKFrkqs2uvDswb1fyRhCaKlFTubrFQtD+UjQ+wKlMoxc/JySNIDd
         mPobtB0mHXowN19ECrwYtdIqIIeMD8NhrTEirIxgbeohiTnSnWn++NATmoga8J2DG3gt
         AO+cHMgCmiaJEIq9l9TU1uM/kp3SCal8iNYQbt/NhHHzJtXimtQwKwST/T/XEJYsDm54
         QEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGUHuYsJqAFrhuayEQJxlwW+4/wpslPvCS6hl8VoWO0=;
        b=NOxJIf8L4CkqOsbAiDF/zPp3rSrBgQ9N0QZ42acj4lAaNnjA8tMSNpixaRDxmalS9K
         FWFy4GRcpUSm5ZhViZI8YGAHWShRMz4F2XerNryKUZI8yy+WZI3BnQIHcS6THxaGzoYJ
         2EWeU3EosJKvuxuFxZYg+385yHSo3mc5CwrcOTi1CDMbRUsAP22FvyuFZdEAGV2P6ZTT
         anwQo0S/htfg4Ta7WERBK/m28m3wV8XSDXOUt4y+1NICwf87K73jSO+MyvapomAOscv7
         yBy1B1GrlxbsjSFgRarJMnD2cMaC9qTRXUzYEK172wFXPTkGG1fQdd8zqlsQ975E5gn5
         qpxA==
X-Gm-Message-State: AOAM5328BYa14rs652OY7IIQEgNsOLxJAS3Njh5eEkE9ERcZnV/EE95s
        SszzwX4OaDgRVHq28D4brPt7EYf4CIk=
X-Google-Smtp-Source: ABdhPJzRpu6iGJU3OYRvtRhoDFFvYRjB26OexdBE1g8bxRyoIvTqY9LVHl6+h5LZ++HVHy0dGY2oKQ==
X-Received: by 2002:a1c:750b:: with SMTP id o11mr13538097wmc.5.1634314204381;
        Fri, 15 Oct 2021 09:10:04 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/8] further rw cleanups+optimisisation
Date:   Fri, 15 Oct 2021 17:09:10 +0100
Message-Id: <cover.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some not difficult code reshuffling.

Default test with nullblk: around +1% throughput

Pavel Begunkov (8):
  io_uring: optimise req->ctx reloads
  io_uring: kill io_wq_current_is_worker() in iopoll
  io_uring: optimise io_import_iovec fixed path
  io_uring: return iovec from __io_import_iovec
  io_uring: optimise fixed rw rsrc node setting
  io_uring: clean io_prep_rw()
  io_uring: arm poll for non-nowait files
  io_uring: simplify io_file_supports_nowait()

 fs/io_uring.c | 170 +++++++++++++++++++++++---------------------------
 1 file changed, 78 insertions(+), 92 deletions(-)

-- 
2.33.0

