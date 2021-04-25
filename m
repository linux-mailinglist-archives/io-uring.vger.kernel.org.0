Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8172A36A785
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDYNdT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYNdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:18 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAF3C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:37 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id y5-20020a05600c3645b0290132b13aaa3bso3629442wmq.1
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8nd1cjfWsqGQjxGLe1ZZJayl3SGcnb4UQlfPPvTvQJo=;
        b=YvpG4Ss02vhMf9NEZ18A2MmAjiApsCElMbvFH3rOrxenbTdEanIyCjurVcsREw3Hin
         kn+b++uPV6sfXBvSscenM6ZIeZs6fK+n8IIUAfdKTqZoLhTxo4ze4dxtK5nDSQI3lbPV
         TaTChG6sqxiOpBBDvhK1MflscgMBAe+GPROOdp3TESpQDJmzxUxwBwfB4vJYQMgN3KbL
         Afbb7eYc6QAjaxwdFO5hX9vyhJpn9ZsdtzIQFjdb80vSWrrbAq9A318TSO20S9Ysk+dR
         3ei0MlY2k8kWxLTd4xThD+2DpvUSPFBk2kVu3wqvDl1zs3UBmqIXmzKanE+K9ol1v/3H
         1aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8nd1cjfWsqGQjxGLe1ZZJayl3SGcnb4UQlfPPvTvQJo=;
        b=lmCQpPle7uElSEuGEIJbXH4hXKufCywFBxRndf0joZfXBy8cDzKJ/dj72FpRrELJNF
         Z9SnYfzvKiuRICMcogSxjinGcMGQBB+EN7rAt4ok/UjTA8s7/UN++291gEq80578mDKY
         LaFVNE/rgWtn1t+FrNIU3nsGwVjYDc8YlkGbh8rtxkT3mg2TuYxCXc14oPJVFi1v0d03
         v6V3gz/WGeT3Ekdt1VTF+Cl2S9lX2fCwxfgu/s8hle0SgYyOL3juS4/30vG0phpVzwse
         D7SyGkhNUOerZeZedyNrD/rpGcP2l/MnJ1fhPJlMtpU0jg7DHgzZ/s79CjkoNga8JLqr
         ENgQ==
X-Gm-Message-State: AOAM532rG8G7qFjO9vcfRqK7G+wBzJ0thwdHYs4pSM0LnbRC31jN6zdy
        g5YOWWYcODUSVGYU81uOMMA=
X-Google-Smtp-Source: ABdhPJy3BY2NRxTRDuNQ1aTnevLh0qQuOc+mMF/fY0V5jQMR0eIH9SuzqItiTb2ZumGMPxSbM9f+nw==
X-Received: by 2002:a7b:c20c:: with SMTP id x12mr14497372wmi.51.1619357556062;
        Sun, 25 Apr 2021 06:32:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC v2 00/12] dynamic buffers + rsrc tagging
Date:   Sun, 25 Apr 2021 14:32:14 +0100
Message-Id: <cover.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1) support dynamic managment for registered buffers, including
update.

2) add new IORING_REGISTER* for rsrc register and rsrc update,
which are just dispatch files/buffers to right callbacks. Needed
because old ones not nicely extendible. The downside --
restrictions not supporting it with fine granularity.

3) add rsrc tagging, with tag=0 ingnoring CQE posting.
Doesn't post CQEs on unregister, but can easily be changed

v2: instead of async_data importing for fixed rw, save
    used io_mapped_ubuf and use it on re-import.
    Add patch 9/12 as a preparation for that.

    Fix prep rw getting a rsrc node ref for fixed files without
    having a rsrc node.

Bijan Mottahedeh (1):
  io_uring: implement fixed buffers registration similar to fixed files

Pavel Begunkov (11):
  io_uring: move __io_sqe_files_unregister
  io_uring: return back rsrc data free helper
  io_uring: decouple CQE filling from requests
  io_uring: preparation for rsrc tagging
  io_uring: add generic path for rsrc update
  io_uring: enumerate dynamic resources
  io_uring: add IORING_REGISTER_RSRC
  io_uring: add generic rsrc update with tags
  io_uring: keep table of pointers to ubufs
  io_uring: prepare fixed rw for dynanic buffers
  io_uring: add full-fledged dynamic buffers support

 fs/io_uring.c                 | 523 +++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  23 ++
 2 files changed, 405 insertions(+), 141 deletions(-)

-- 
2.31.1

