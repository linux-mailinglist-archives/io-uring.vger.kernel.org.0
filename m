Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA1351CA0
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhDASTA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbhDASLh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:11:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6A3C0045F1
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:16 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k128so1176037wmk.4
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ZbW0C79n1HBmope1KTocXF9fxmetWyzGvzNfB0znqY=;
        b=iPKiwSm+YHTsV/c7rcb1fqhr9uvumBBbXpsiGVtM8T7QtU0y/Z1ewdZT6Dg/76wfxt
         Fs9BituvxouSPOCkI29dTP+MZv9OIsmaLgQIAr1Hg/E+csT+ZZJDuGMggV8cJVksTF53
         8zPjkECdRZZ3FVbxFkhWE/QHPZLSCy8ydITgy4cl1Rf8SO08otKOhNGAIpsLbWBK45HL
         nPlRsnGODEUzU5zE30TE/BwXEPTSrjCtK75L1WkZX2L98qmPZ/u970zVuPZSnL2WwET7
         yrVH1nbD8FkV7ngGG5Gc2L92tWdAvp0FP+8bYew9dm5XPZizfb8Rd1BcLXk79/X8vQnI
         niZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ZbW0C79n1HBmope1KTocXF9fxmetWyzGvzNfB0znqY=;
        b=dmdw5oUoYvVtC5Cp4NZebVkUnKO0baKNUz4781GXSpZSIiLVeN2dJJW25B7CS2C7B4
         lWDYfKxNiQxE7Nu8Ei4VjXdpLV7eYJhbm/EOE0uvDMwQ4BwVVuWE2v2eQr0BGWyr3WDl
         7PF2qwL1uaz5LKyemRHMw2utiSx2NKaf6NV+681Nm/5K5P9ZlLtMtiU8HsqSXtQS2Inf
         uhyhivaCFLYoDkWgHZ6orogxExsgOWfr/EFrBp7Qh88xzaPjcqTMvSL2zKUeKnJQK3dv
         CFr613Ic9d9VtcwuTtG88oVvkiA9qCCuNEnLcezG1Tdu3S4eptV7phA6XRjA/yuTZ2RE
         neKw==
X-Gm-Message-State: AOAM533hdlUMmJ1F+t3hsu2yx5nxSrZoFP27pEAbs9OqVN7HPLtDUW0k
        Hrqq5c9DaRckMWQQ4o9lSgQ=
X-Google-Smtp-Source: ABdhPJyAEv4mIJy9W5YgoEtfad/BKcrbboVz4mL9fVW0ZUZfP9iQBF3XQRtS2LRHSAc+WJ+iIoL1Cg==
X-Received: by 2002:a7b:c1c9:: with SMTP id a9mr8245437wmj.145.1617288495163;
        Thu, 01 Apr 2021 07:48:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 00/26] ctx wide rsrc nodes +
Date:   Thu,  1 Apr 2021 15:43:39 +0100
Message-Id: <cover.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-7 implement ctx wide rsrc nodes. The main idea here is to make make
rsrc nodes (aka ref nodes) to be per ctx rather than per rsrc_data, that
is a requirement for having multiple resource types. All the meat to it
in 7/7. Btw improve rsrc API, because it was too easy to misuse.

Others are further cleanups

v2: io_rsrc_node_destroy() last rsrc_node on ctx_free()
v3: the series is growing
v4: keep growing...

Pavel Begunkov (26):
  io_uring: name rsrc bits consistently
  io_uring: simplify io_rsrc_node_ref_zero
  io_uring: use rsrc prealloc infra for files reg
  io_uring: encapsulate rsrc node manipulations
  io_uring: move rsrc_put callback into io_rsrc_data
  io_uring: refactor io_queue_rsrc_removal()
  io_uring: ctx-wide rsrc nodes
  io_uring: reuse io_rsrc_node_destroy()
  io_uring: remove useless is_dying check on quiesce
  io_uring: refactor rw reissue
  io_uring: combine lock/unlock sections on exit
  io_uring: better ref handling in poll_remove_one
  io_uring: remove unused hash_wait
  io_uring: refactor io_async_cancel()
  io_uring: improve import_fixed overflow checks
  io_uring: store reg buffer end instead of length
  io_uring: kill unused forward decls
  io_uring: lock annotate timeouts and poll
  io_uring: simplify overflow handling
  io_uring: put link timeout req consistently
  io_uring: deduplicate NOSIGNAL setting
  io_uring: set proper FFS* flags on reg file update
  io_uring: don't quiesce intial files register
  io_uring: refactor file tables alloc/free
  io_uring: encapsulate fixed files into struct
  io_uring: kill outdated comment about splice punt

 fs/io_uring.c | 504 ++++++++++++++++++++++----------------------------
 1 file changed, 222 insertions(+), 282 deletions(-)

-- 
2.24.0

