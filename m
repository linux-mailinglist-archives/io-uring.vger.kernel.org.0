Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41633A5B5C
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhFNBi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbhFNBi6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:38:58 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6489C061766
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m3so5900275wms.4
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ak44WWtrgS/GJdU6bJvo5n5G1GQMzZdMWsm+R+t831I=;
        b=ZTjaZKO95dxzANAJSYOrKON5/9QQqZE9PvlrziGPDKYhvArNP3o39or1aHeIBdH2ZP
         PFo24BkWxeRluS+wL9o9oPEXfHwX4zjAw/DSAO9wAClnRnJkMuIbsn/eWCR8XCPopZ6W
         Hw9oFFt5EF+pPDjVxMb1XT6tz5F6HigUfaxRveVwTj9Euv4QDlZhujpKjWaRARDeTNek
         OI6F4T6cv1QhZkkK8nn4L9jwidZBUto8HTVUnxtVkqf2QJ9hLC8SWcSPaIIg4LDLSsnW
         YMJExFK7JmMrVYzN0EGTQ0sb8NqjZyqJ5hayqE9bR9XqS7THHd9B7XDqToYL9fpCdNkj
         Vygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ak44WWtrgS/GJdU6bJvo5n5G1GQMzZdMWsm+R+t831I=;
        b=EUJyhCX2akxm7iatTgvYgYJgL6MgSRrzUOBtyy++T+HbTl6FNgFZMAJwXvOyVTaoBq
         Ahyd6i8atjs4fLiv30KnJ9oy8pIh1azlm2rI5mH7j8VXekfR9ofNclJVthOmpDHYchKa
         tQRtl4pFZJemRUtiWQVH1fV3PzFB5yUaVHYQh6aJn6P0tDSDmv+LAEMH6s8SKgmNMHfP
         b5aK8WKsPIuxfc9iPSqJmYBs2dyzlHd+yP0m92h+szn+2Ni+rbHVmptQRmqohIBhi3aX
         VStNVJBRzlaRjJPn1PXKh1Hml68sy6fRwku71C4gyWIZw43dZsq0+h4xLrlDkBDMqgCz
         AWsg==
X-Gm-Message-State: AOAM530ts2NP36nGzFxZo+7GtpGxCaht54x1Pd492nEjCclU2czC8Dwq
        SkFNYryNlJAgtt0SY4wAhWZljOXk721EOg==
X-Google-Smtp-Source: ABdhPJyzpYccHW2ZcOEFjOultPkUDbHqmmSuQzp1KAWj3GFzyM9n8oSY6untPZQ/t8t/9/6gogqNDw==
X-Received: by 2002:a05:600c:2054:: with SMTP id p20mr13768580wmg.175.1623634603676;
        Sun, 13 Jun 2021 18:36:43 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 for-next 00/13] resend of for-next cleanups
Date:   Mon, 14 Jun 2021 02:36:11 +0100
Message-Id: <cover.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The series is based on the 5.14 branch with fixes from 5.13 that are
missing applied on top:

216e5835966a io_uring: fix misaccounting fix buf pinned pages
b16ef427adf3 io_uring: fix data race to avoid potential NULL-deref
3743c1723bfc io-wq: Fix UAF when wakeup wqe in hash waitqueue
17a91051fe63 io_uring/io-wq: close io-wq full-stop gap

v2: rebase
    droped one not important patch

Pavel Begunkov (13):
  io-wq: embed wqe ptr array into struct io_wq
  io-wq: remove unused io-wq refcounting
  io_uring: refactor io_iopoll_req_issued
  io_uring: rename function *task_file
  io-wq: don't repeat IO_WQ_BIT_EXIT check by worker
  io-wq: simplify worker exiting
  io_uring: hide rsrc tag copy into generic helpers
  io_uring: remove rsrc put work irq save/restore
  io_uring: add helpers for 2 level table alloc
  io_uring: don't vmalloc rsrc tags
  io_uring: cache task struct refs
  io_uring: unify SQPOLL and user task cancellations
  io_uring: inline io_iter_do_read()

 fs/io-wq.c    |  29 +----
 fs/io_uring.c | 349 ++++++++++++++++++++++++++------------------------
 2 files changed, 191 insertions(+), 187 deletions(-)

-- 
2.31.1

