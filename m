Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B456628FE
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbjAIOvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjAIOu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:50:56 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A63E85D
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:26 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id cf18so14360743ejb.5
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0S6r6r9QzzBn/AyEuj2Z7bjVykZ7wV5WwSY034ZXU2g=;
        b=ZJ9krmynMuu7BZJzk92K5smjhdbDOyQFNEBLECkKowsp09blRQJgIjbKYggv2WDr7t
         AhOIy6rzLYtfBkhfW/+aHQBBY/YCQWTqhl5YDGoqQkWvX4HqoWYuHnwTU6610IJkf5j1
         cds/+0QxZZvQv4zCOhdxRRDtpIx+bmFK3NY8JMy9eR0W/qbhYjJ+xuuhNDaQOEc+FygQ
         8zyZpdcpX2IFHq+6l2bZnnCTtU8c6LCmsd+ZlE8lfkJoaqi4zXqGNvOhWL79KM7m9thK
         S0G8PEkCiRGDex10EtfVne73ThgiOMfdIFNtSBdW0MeGN3LXIBEb6/YJCdicMTBLdQHq
         CoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0S6r6r9QzzBn/AyEuj2Z7bjVykZ7wV5WwSY034ZXU2g=;
        b=iBc78fa1eL5nk49yV8vhdAvIdWkF5xdaxtVtQfmRpAmOjCcHaxk5C7KX5FteYodDtU
         EOPXW1VdQ/j7VQoBoUZonbdUcxdsICxQigDaxwlrD1xdpr+6DfLy16Xi+s6SYbQvSgBP
         LHreCYzAdaT1tCr2MFE/VWVbHgyr0PEHIee6KU/da8BmdRTa2nhn/2NrgULk/byLOx7z
         zh94libwjCPeazUs6K1l2sfAP6R1TltLrL4bkWFJ/Yz3UrVFu73n40y1wiWKUDtqewOW
         zW/uFNuuvDCVX5m7Dpel3Hcw29TnDmx7mC3ljvYw6NMtvuArIJQ0DZROpn6jVof8td81
         6I7g==
X-Gm-Message-State: AFqh2kp+k405AYQMqvyCtECUWPwapvNzq1FbNAFJzdzFfoWb7p6Mu6np
        uCzb+lBFck3dlgR7DKE+wuLAN3fx+Wo=
X-Google-Smtp-Source: AMrXdXuznjrhgn7r/A4ufc7P2NhUzfGHGjTkIrZaDrARPf92e1ozfO5oNU1s0Ge04YXz2nOzNhxsPg==
X-Received: by 2002:a17:906:99d1:b0:7c0:ff76:dc12 with SMTP id s17-20020a17090699d100b007c0ff76dc12mr39747514ejn.2.1673275644813;
        Mon, 09 Jan 2023 06:47:24 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 00/11] CQ waiting / task_work optimisations
Date:   Mon,  9 Jan 2023 14:46:02 +0000
Message-Id: <cover.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For DEFER_TASKRUN rings replace CQ waitqueues with a custom implementation
based on the fact that only one task may be waiting for completions. Also,
improve deferred task running by removing one atomic in patch 11

Benchmarking QD1 with simulated tw arrival right after we start waiting:
7.5 MIOPS -> 9.3 (+23%), where half of CPU cycles goes to syscall overhead.

v2: remove merged cleanups and add new ones
    add 11/11 removing one extra atomic
    a small sync adjustment in 10/10
    add extra comments

Pavel Begunkov (11):
  io_uring: move submitter_task out of cold cacheline
  io_uring: refactor io_wake_function
  io_uring: don't set TASK_RUNNING in local tw runner
  io_uring: mark io_run_local_work static
  io_uring: move io_run_local_work_locked
  io_uring: separate wq for ring polling
  io_uring: add lazy poll_wq activation
  io_uring: wake up optimisations
  io_uring: waitqueue-less cq waiting
  io_uring: add io_req_local_work_add wake fast path
  io_uring: optimise deferred tw execution

 include/linux/io_uring_types.h |  15 +--
 io_uring/io_uring.c            | 161 ++++++++++++++++++++++++++-------
 io_uring/io_uring.h            |  28 ++----
 3 files changed, 144 insertions(+), 60 deletions(-)

-- 
2.38.1

