Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123CE3492D5
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhCYNMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhCYNMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:15 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026BDC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:15 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3061994wmy.5
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lei1Vp2rZLsZeBG1j38rlO8E89kA31Ge3PEj55dzWQE=;
        b=PhIbHTYw2OO1JoWyPEjPkvcC+8Tm9/eEA9GeJEE6/yHv4t5DZddHlUqnqy13XoWKND
         pZZaTEB1r93dGm0Hwo6z/nX60L+mVw7jkmNTLAl8V/kM4HZB1D1WP00HNArW2ItJGYLD
         u8l/WcEvk3h/0qheovfVsjhRn+SD16zoHnK5oeW5HXpsOs4oOdB4lD89+nbZgHb1NokV
         I/JnGKFNsAck4wBzTYnUbMaXTSl8aimfsq+o4SFHMabOKc/f+5bPrtAG0kRmKpIsAYV+
         5RfocEVAx+Ktg0CYmjDN0JSFa1HStG1LcsBnpBBSGwn0uctcOjxgem1uUyWfZX2l85/x
         jcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lei1Vp2rZLsZeBG1j38rlO8E89kA31Ge3PEj55dzWQE=;
        b=AgZokIsY6tr6N4rf/879GPHBh/R976+0g8ZulI5jMlevCXy4bOtBK+ktcD/VA8qECu
         2GMm9L8WrQJSQVMEghAi2AWGCQYahz45oefABUFxvllx9uAsUFALFnY0vmFdhh2//uzf
         xm58AbO/qLag5sl/AgB4ziCA+c6WIRTQuVOqg49Y0aAR6geU1LzsNqZuMfyBE7jkvDiF
         /hnvGOp0wAQMi7nnmxLIB4xNOeys7NZQ/HQ4MPfCPxw2RV6XJHYU3rZ0usSFkDfL+Gfo
         Y9Yba/KPH4oq2BnVcXu8bYU2fhpmJb2O5NC0VcCWtU/JgjHmPoG+ge0QlHLvri8VDPYR
         2YUA==
X-Gm-Message-State: AOAM530uXDjCEDyWp+KwKbCC09rA0qML2mdNAV2X8exXc0xyBZ+b/ZC9
        7FqXJPjeU6N1x9bU+YqkKMs=
X-Google-Smtp-Source: ABdhPJzVyvA7H4blh/Qp7k6SSLJgeZr/XhsNemvGwte432HypLGS4IMWrgXUxfbAF5EYT+3iTEPyUw==
X-Received: by 2002:a1c:2857:: with SMTP id o84mr7943056wmo.181.1616677933681;
        Thu, 25 Mar 2021 06:12:13 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 for-5.13 00/17] ctx wide rsrc nodes + other stuff
Date:   Thu, 25 Mar 2021 13:07:49 +0000
Message-Id: <cover.1616677487.git.asml.silence@gmail.com>
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

8-17 are necessarily related cleanups

v2: io_rsrc_node_destroy() last rsrc_node on ctx_free()
v3: add 8-17, 1-7 are unchanged

Pavel Begunkov (17):
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

 fs/io_uring.c | 333 ++++++++++++++++++++------------------------------
 1 file changed, 135 insertions(+), 198 deletions(-)

-- 
2.24.0

