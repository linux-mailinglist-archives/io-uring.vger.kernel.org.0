Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D620C74C
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgF1JyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:20 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429D3C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d15so10184444edm.10
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAvaLUDgSNezA2dsMKZbYHkePReD0sNG+IxSpe3iXow=;
        b=sKFPVmYIei8BlIm4yMdVLkCvdAx774bTNO0h0QtS8raY966qaHul46WFWB4/jm1o6r
         51uaSZ8NLLH/nhiM+gBn0vgw5q8uht0ZK+QQfrFEQNVvEO7xB9Hf58jWu8hCYF6/0Mik
         9wdaqzUOql31zp2zX1vdn5uq30/J+Mwk9gtI1xwtuuJtWdgDJI0BdGofcKarafdZwA0V
         fYsNEzFYJ9t5iBmCKJNH9yk9KMVj2FMfBMQ5SHcM6Unmu/CtMdMiwU1XMLK+2a+fdrDJ
         XjBM6iMvxBW/dDJnxieiKSQ3z6dpBYCkeF06LRWsrosOV1k9PtdiyVTZ41w9yk+ud6m9
         DPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAvaLUDgSNezA2dsMKZbYHkePReD0sNG+IxSpe3iXow=;
        b=adotfNQn8RE3U4Dd07m94FGXjOSHUdQk9r4f3/ir0tKYntPHSwkSR81Ev7aFpiFBJR
         F8mZN1UJHOmi3mgkEX1WLe13cuXKW0T9HUgBIpb/HRe4KfWvjrfGs4NA+0DERtQle3i+
         KABk349NStcTdeAmBWa78pTddthlkXsWBQBNmraV0fEiUWd6i3cUGK3XE8wzqal5m7bT
         FFYmwPv70vszzr65V5veXmJd4c1vew6gdOuIae2x5x0VcoPO5E1tjaYG5EhjGtq+NZD6
         T0ZsZH3MU/efPIQEs+qD432Qo31EYcwzEgkYNFGtTuz7ENRHNcuv8p5BQ6kn5Fn1To+G
         ivdw==
X-Gm-Message-State: AOAM532bGZFGIZ3Nn+9IjPq7TZ2smNBGQ6+XOvxQ9hrV/pQsvL06VF7d
        MjmMgdHiTkNU6aCnT+qBea9EYVjy
X-Google-Smtp-Source: ABdhPJweHx1/uRurh1JDnrqefqu5V2/9iIiih/GmcuEA9Wt+dzwxqRLdVwZh6CrtDsqc57pjc2lQrg==
X-Received: by 2002:a05:6402:947:: with SMTP id h7mr12213695edz.213.1593338058909;
        Sun, 28 Jun 2020 02:54:18 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 00/10] some fixing + refactoring batch-free
Date:   Sun, 28 Jun 2020 12:52:28 +0300
Message-Id: <cover.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Firing away... All for 5.9 on top of 5 previous patches fixing link
task submission. I don't think there is much to discuss so didn't
separate into sub-patchsets. Let me know if I should.

Batching free is inteded to be reused outside of iopoll, so
it's a preparation but nice by itself. 

[8/10] looks like it, but double check would be nice.

Pavel Begunkov (10):
  io_uring: fix refs underflow in io_iopoll_queue()
  io_uring: remove inflight batching in free_many()
  io_uring: dismantle req early and remove need_iter
  io_uring: batch-free linked reqs as well
  io_uring: cosmetic changes for batch free
  io_uring: kill REQ_F_LINK_NEXT
  io_uring: clean up req->result setting by rw
  io_uring: fix missing wake_up io_rw_reissue()
  io_uring: do task_work_run() during iopoll
  io_uring: fix iopoll -EAGAIN handling

 fs/io_uring.c | 157 ++++++++++++++++++++------------------------------
 1 file changed, 61 insertions(+), 96 deletions(-)

-- 
2.24.0

