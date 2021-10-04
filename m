Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212784216E8
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbhJDTFi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTFh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A030C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:48 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f9so6316257edx.4
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jap23kQoz5CHhWzWcXOhiyLT2ocBHcvoiNbVzvogBpQ=;
        b=g79jOyTPX37ufdEHnsN8L5rXveVaF9CHOrfq5FB33lzdVd04btq9RoCjMX7ZInBzfw
         Ai97c0mHDfgDsvPsNgwHm9pYFuGsWqfE+ESDV2nLDRWkknalWSvX4LvIz52UQtdiBQ3K
         n0b+fGnFySRTuJG/JNqj4Q8I9kxIHMcDx9q9j2lPztLVXCjFtxSmUDp4PsBPxbrlFIH+
         pbzuqYhhpu9Svuz0sQ32w+NQBwV4g769SbnNXfUH0poBou2jC4wY98Vw1xKy26lFKHZH
         pXIgi7qsI4/oL1oxVKuh66INqw0mDBel8rM6sEibHHbRW07OS7Gvr46qIdoggOVejilb
         qptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jap23kQoz5CHhWzWcXOhiyLT2ocBHcvoiNbVzvogBpQ=;
        b=VOqdh5zi0X4oiDHf4YRELmvMPTWsjUXi+E8Knf9L5qQNlk3C6rETkE8bnAh2Gw3GhO
         fq4aAPzUD1h5L50FCUg/m8kvC9fbASNvcYC3kQsRyRK1P9VInd+YsOWRFFBMKCyZeo+3
         q3VQFIFkVfeQEGOKnQnwVQHCFUJhYUSm4+6agT/ics53uTsyBPIZdqREn13JK0Xp7Fiy
         Hhgs+ZpA2k/bo+GOh5BDTkq877iWmFWZkSWIo0TogkO8BEYezbGUCih7KK66m2FeR2c2
         EHZ88DMr+sAwiiiAlzWQwA3Ia5hjY72+6wJGi00boH+hATUFEZsAGN7lM34y/+BiMAKU
         cLJw==
X-Gm-Message-State: AOAM532VL1O/Jhi1Jnu/QG6m5gjnwVkkTHNhYU2sAxdaN3k36CI8FnRh
        kZAefWPVjVmB0SvQumGtLCWYyGeaXVM=
X-Google-Smtp-Source: ABdhPJx9XK10abQbfa3s6TBENFsBvm4aE0qN63QxkHK7SFzhkVQzKNSyTtsqF/bPqHECY8SE1CMetw==
X-Received: by 2002:a50:d8cf:: with SMTP id y15mr20491606edj.66.1633374226538;
        Mon, 04 Oct 2021 12:03:46 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 00/16] squeeze more performance
Date:   Mon,  4 Oct 2021 20:02:45 +0100
Message-Id: <cover.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fio/t/io_uring -s32 -d32 -c32 -N1

          | baseline  | 0-15      | 0-16        | diff
setup 1:  | 34 MIOPS  | 42 MIOPS  | 42.2  MIOPS | 25 %
setup 2:  | 31 MIOPS  | 31 MIOPS  | 32    MIOPS | ~3 $

Setup 1 gets 25% performance improvement, which is unexpected and a
share of it should be accounted as compiler/HW magic. Setup 2 is just
3%, but the catch is that some of the patches _very_ unexpectedly sink
performance, so it's more like 31 MIOPS -> 29 -> 30 -> 29 -> 31 -> 32

I'd suggest to leave 16/16 aside, maybe for future consideration and
refinement. The end result is not very clear, I'd expect probably
around 3-5% with a more stable setup for nops32, and a better win
for io_cqring_ev_posted() intensive cases like BPF.

Pavel Begunkov (16):
  io_uring: optimise kiocb layout
  io_uring: add more likely/unlikely() annotations
  io_uring: delay req queueing into compl-batch list
  io_uring: optimise request allocation
  io_uring: optimise INIT_WQ_LIST
  io_uring: don't wake sqpoll in io_cqring_ev_posted
  io_uring: merge CQ and poll waitqueues
  io_uring: optimise ctx referencing by requests
  io_uring: mark cold functions
  io_uring: optimise io_free_batch_list()
  io_uring: control ->async_data with a REQ_F flag
  io_uring: remove struct io_completion
  io_uring: inline io_req_needs_clean()
  io_uring: inline io_poll_complete
  io_uring: correct fill events helpers types
  io_uring: mark hot functions

 fs/io-wq.h    |   1 -
 fs/io_uring.c | 390 ++++++++++++++++++++++++++------------------------
 2 files changed, 205 insertions(+), 186 deletions(-)

-- 
2.33.0

