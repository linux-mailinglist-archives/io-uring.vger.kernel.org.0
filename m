Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C227346322
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhCWPlR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbhCWPlI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:08 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EFEC061764
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:08 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k128so8908731wmk.4
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9l3IfI6dp3Qp1RYffkrcM+IK8/BnrRYOMmJfLj1NONU=;
        b=EBWGvHxPlS8kdHIsmFhrp19uSPTt+SrvaVCFOOwm1Vv/JzbW0ATH32nEHvgy/75aiw
         7hkVs2+PPJQXcX3UILRb5fX5wmUNlGfdkCY8eLcH72EjVungz6MHlGLKeKN2YDvgSn/o
         5hBkdNuDwm56Pv67i0+Ck20EVmo5XNbFORBVx0uLThPnnrFjjXOg/cgpkS96SUs7qBhw
         KZE7QEOpzpaLwLm0aL3oXdsfBgqZwQPGeh//6jVJsLcHe/9tMr9iYfhMPM364RwC4Pde
         zfaPvp84j7KIIfm8wBcArKzWz8KPCBJjuVuI17cX2SwS5EHQTQPh7zhOEhJ8rm/XmgCw
         xTUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9l3IfI6dp3Qp1RYffkrcM+IK8/BnrRYOMmJfLj1NONU=;
        b=TyGQq6Oyl5+DkulO/F4ET4em7epDqEm7XoMbh5Er4t/KFKd33nJ1dVZYIQEW+M8vik
         3fNH0sujmFBiR7tgDtp/MYD0Q+cSrcSV3Pi4XFJM9rOZL4dnX/n9w8+LerORgP0uRUft
         EaphZupahBIhOjQFu7yj5huZ2Xt4lg0NooA/JIoCE1Rf8r04Rh8kN1SpEsHJZV75DKjG
         k/p7VdjRca33rCXdZF9r1jpUOBlz1K1d99DrYDrKnqo5oFhQ8dNV0LSETUgRoq04y/a4
         Pxh2DkcbIgtTbR/sBg0QdQ1Nd44hUDCL40cs1nyNdi0YXNjPGV9fU9QzR6Y4nAVHz6/m
         OmdA==
X-Gm-Message-State: AOAM533+vgZwMCTCNS3+L8x+EpEU3jM7miZG69CEr0t2LkcFACrEQU9O
        XSPJlPQXMXDhX4gmn5ujo34=
X-Google-Smtp-Source: ABdhPJxVT/guqDKRZC8u5teIZWLcqKHDpibGTVV4wtIL4DrwV91TzYZYudcJ/Z6DrzxRgYkeZtRd0Q==
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr3892161wmn.174.1616514065375;
        Tue, 23 Mar 2021 08:41:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 for-5.13 0/7] ctx wide rsrc nodes
Date:   Tue, 23 Mar 2021 15:36:51 +0000
Message-Id: <cover.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main idea here is to make make rsrc nodes (aka ref nodes) to be per
ctx rather than per rsrc_data, that is a requirement for having multiple
resource types. All the meat to it in 7/7.

Also rsrc API is complicated and too misuse. 1-6 may be considered to
be preps but also together with 7/7 gradually make the API simpler and
so more resilient.

v2: io_rsrc_node_destroy() last rsrc_node on ctx_free()

Pavel Begunkov (7):
  io_uring: name rsrc bits consistently
  io_uring: simplify io_rsrc_node_ref_zero
  io_uring: use rsrc prealloc infra for files reg
  io_uring: encapsulate rsrc node manipulations
  io_uring: move rsrc_put callback into io_rsrc_data
  io_uring: refactor io_queue_rsrc_removal()
  io_uring: ctx-wide rsrc nodes

 fs/io_uring.c | 237 +++++++++++++++++++++-----------------------------
 1 file changed, 97 insertions(+), 140 deletions(-)

-- 
2.24.0

