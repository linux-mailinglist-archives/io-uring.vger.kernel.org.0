Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873352FBA87
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbhASOys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394337AbhASNhP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:15 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280BDC061574
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:33 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a9so16303028wrt.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyz3VFs4aTiI7SNOFjPvb/ivy1WHVtVpgYf+xO6AC70=;
        b=iekY81YaDS2WgdPmljjqwtFg6KOCev2uCrb8N2ybKyVcsBFlB6p7hSrj5t/RTBZGIN
         8b7vybcfuFh3o7+WPT8aJoYQWLY3L2f5dI5Mmyl1U3bgUtApO8/VeLmNp15J4eiR53WD
         iCg4iyOdg7l0GBiisviD8IT8d3OlwksVBjp1RxGjSWDlQFJdmVj6A7WG3Jgu4duOXZ09
         y4NUDpUCXN4GWtXYnFt1LMSw4Ub6lWvt7nBsa9fmXwHB+SplKpWwFiNUuRdPBug4cknd
         NBTT6GvwrWDmU5WwqKLORc4H9zHxTrT9MUgirxVw3koRkz/JH42cdlQKJnqmrU16NB6W
         oVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyz3VFs4aTiI7SNOFjPvb/ivy1WHVtVpgYf+xO6AC70=;
        b=aYP5dgDXM5OvKseWG63Uv1wa52SJaJI01jJQthfSI/og6IsVdGJT6AZoTSxxCLHOAr
         iL4l9K5SyUEkRMa7W6UY8lFuh52jo3TiC/phkVGwT8cDulFMOc4iKZkpkukab0x+qoaI
         GvCjAWcBpkIRxgb9yilyvKPEVzCUC1uTiZl3bQBBS+HmyL7/xCzLNwHTGdR1NH610U0A
         9H04pDwC9XDdwgCBzujSMtTOmH9lMEkqcPw76+NimbM5mBvrxLMs+he9pZjoan2l5WSz
         MFDIWLCqa+HR8rDSXhVr0bH8irUWOID78wOhBFQ525WNYwei8B/nY1vTopSGNuFI8faA
         nBiw==
X-Gm-Message-State: AOAM530SI7cqgPiLjCNZ8T+O9GeNVTuGO/PkMWUTVptY3RdB9WeEDm38
        RWSMOWLm9AhgxB+8et3EkHU=
X-Google-Smtp-Source: ABdhPJyTBaJPKnaBzYXoX9SMHGS7mvFdMI4PWPPBq2kBwviyTl4sWqFVcBrT816BtHwe9aBymTT0+Q==
X-Received: by 2002:adf:f511:: with SMTP id q17mr1411403wro.264.1611063391981;
        Tue, 19 Jan 2021 05:36:31 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 00/14] mostly cleanups for 5.12
Date:   Tue, 19 Jan 2021 13:32:33 +0000
Message-Id: <cover.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Easy patches that should not conflict with other stuff, actually based
on 5.11 because it has more essential changes, but I'll rebase if
doesn't apply after rc4 and 5.12 rebase/merge.

1-11 are easy mostly cleanups, and 12-14 are optimisations that
may end up to be preps.

Pavel Begunkov (14):
  io_uring: optimise io_rw_reissue()
  io_uring: refactor io_resubmit_prep()
  io_uring: cleanup personalities under uring_lock
  io_uring: inline io_async_submit()
  io_uring: inline __io_commit_cqring()
  io_uring: further deduplicate #CQ events calc
  io_uring: simplify io_alloc_req()
  io_uring: remove __io_state_file_put
  io_uring: deduplicate failing task_work_add
  io_uring: don't block resource recycle by oveflows
  io_uring: add a helper timeout mode calculation
  io_uring: help inlining of io_req_complete()
  io_uring: don't flush CQEs deep down the stack
  io_uring: save atomic dec for inline executed reqs

 fs/io_uring.c | 222 +++++++++++++++++++++++---------------------------
 1 file changed, 104 insertions(+), 118 deletions(-)

-- 
2.24.0

