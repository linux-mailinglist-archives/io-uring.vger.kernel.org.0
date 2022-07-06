Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7594C567C95
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 05:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiGFDlf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 23:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiGFDlc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 23:41:32 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAC11D0EC
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 20:41:31 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id u13so4172399iln.6
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 20:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZaCTlfv8CYfo2gbvGF88mH3M8Bf8zC5BCKJxkbs+Cs=;
        b=ZN/NVJ1Yo9SEH50AAF8RLQ5t9fH1Ex7PIrHPGpqO8EWkfdBUAfoypB4GE6VFUA8KT/
         U40pPLnjvOVosp6HauEpDiiWHWfrydqEhVfSzvElOOa+9AI25TaJz+wiGEEZTvG8H3iX
         iR/d32GDMmSYDfLhh11hLFQjqpLLLSqKHvxXpzUVXfWVdIl/S8EtOkXtzbk1VqhEEBkC
         2mAsnDTXlMUl0IttQXXAtzM/2O7c6dLS8ESBpQbAeB10yxFep0ZfUPV9YhVrFJ0+DsDC
         DLz++1kGLwh55LRa1FmU0n6igIlbaYrvRMS8mwfQTn3+8PyC2ileuzhETd1Lrpmv6c3n
         cRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FZaCTlfv8CYfo2gbvGF88mH3M8Bf8zC5BCKJxkbs+Cs=;
        b=ybpmt36gKNNCUWYqLfpwIE8KzeSo3WtMj0x9w4RDbE4wZEos+3Tgz9/SkGgf+uy3Sd
         qF94gNiFtTSCp4oSsNKpEB/AXIMtTervH5E50Iuwc6CaTsy2Yoq1zmbboCi7yylwSj/M
         y7z2LTOBd9fHC5HlAt8iPnQunfx4ht1DiqzoVkixqYs+Zri8qbd/Ig6KkOUQ/nCZY+ge
         iBsyOm0CkPeOOABWjfXgLs53INzdZB/QeiznSOwXVzBHGoguaACRIe9Y0FpD1uEgrL7R
         Sq78gPc3h/lxJATaFoE3S7yYS5udqRPUpKkDCtY1AmhseXrhnB20FViIuBqPdyULGVHn
         zetA==
X-Gm-Message-State: AJIora+2OuUdhgnj6hKeZFOy9m99Dzl2Nfa/XpFI+shjH7L976U7LpUG
        fXGgVQtDdTTtEZDH/LEgXLrlQTNoJp3W2RnI
X-Google-Smtp-Source: AGRyM1slKbrAKwehHvgtNzyCUJ3B+n/qp0xtVVP+k4Cczj+M6rhlo7GQvWKs2fE1ORWAW2O5bd6upw==
X-Received: by 2002:a92:c544:0:b0:2d9:57b4:be08 with SMTP id a4-20020a92c544000000b002d957b4be08mr21806217ilj.312.1657078890807;
        Tue, 05 Jul 2022 20:41:30 -0700 (PDT)
Received: from didactylos.localdomain ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id z6-20020a05660217c600b006692192baf7sm16427854iox.25.2022.07.05.20.41.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 20:41:30 -0700 (PDT)
From:   Eli Schwartz <eschwartz93@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/6] More wor on updating exit codes to use
Date:   Tue,  5 Jul 2022 23:40:52 -0400
Message-Id: <20220706034059.2817423-1-eschwartz93@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eli Schwartz (6):
  tests: do not report an error message when return ret that might be a
    skip
  tests: handle some skips that used a goto to enter cleanup
  tests: more work on updating exit codes to use enum-based status
    reporting
  tests: mention in a status message that this is a skip
  tests: migrate a skip that used a goto to enter cleanup
  tests: correctly exit with failure in a looped test

 test/accept-reuse.c            |  2 +-
 test/accept-test.c             |  7 +++++--
 test/accept.c                  |  8 ++++----
 test/connect.c                 |  2 +-
 test/double-poll-crash.c       |  4 ++--
 test/fadvise.c                 |  2 +-
 test/fallocate.c               | 18 ++++++++++++------
 test/file-register.c           |  4 ++--
 test/file-update.c             |  8 +++++---
 test/files-exit-hang-poll.c    |  6 ++++--
 test/files-exit-hang-timeout.c | 10 ++++++----
 test/fixed-reuse.c             |  2 +-
 test/hardlink.c                |  9 ++++++---
 test/io-cancel.c               | 14 +++++++-------
 test/io_uring_enter.c          |  8 ++++----
 test/io_uring_register.c       |  6 +++---
 test/io_uring_setup.c          |  7 ++++---
 test/iopoll.c                  |  6 +++---
 test/lfs-openat-write.c        |  4 +++-
 test/link-timeout.c            |  7 ++++---
 test/link.c                    |  9 +++++----
 test/madvise.c                 |  4 ++--
 test/mkdir.c                   | 14 +++++++++-----
 test/msg-ring.c                | 13 +++++++------
 test/multicqes_drain.c         | 11 ++++++-----
 25 files changed, 107 insertions(+), 78 deletions(-)


base-commit: fa67f6aedcfdaffc14cbf0b631253477b2565ef0
-- 
2.35.1

