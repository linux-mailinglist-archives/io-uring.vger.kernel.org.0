Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B27342346
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCSR1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhCSR0u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:50 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83816C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:50 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so5646346wmi.3
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYnAwp7jWl4U1duppoZLeJ4z+0s7E0UKRIewwYNuC8s=;
        b=atbZjZJcRVWzzWkOAEYr38nw4PSIgsv0bLbKXE9l9/PTmbsGl2zl36dPN/it6qsHIf
         jQnWwrNg6OvpYlDagQwrLPm3/yYpFvO5TA0UDCdHJ8VdVMvvBn2trYYmsfyYcYewojjD
         1gMAYYsVIwDRrO8Zzs6tY5k2DVa/5eyOFZs+uUHSFmg76VoPte+SU7uDsCyCxlzFzE/j
         rXoqpYL9xMtAY76NBv6vJtcNhGnrlzZcacYaVlwcRTHFS+1V0W/CI2TIY7rkRGS5iPzn
         wE0zlCjmG9zC5sHZA0vXuxg4yRerI7uDHixGsakaEv/l6Xc6etdFg5u23nuhPYdh7Vvn
         Jdhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mYnAwp7jWl4U1duppoZLeJ4z+0s7E0UKRIewwYNuC8s=;
        b=qLB8gP6o9VDdtzKWBAR2AJdTEkXPxIuFdGv/Gah9ePDR9FXZqnXvNSPBuWQG7xA9Q2
         bnYgevHIFStBCcjaD+21J7vGnB0xed5mxuhc9z9QG/dsJYurImFId+N425hJt5Hxgp5j
         jFSyA1y7IrR+fZKXi1ZOmlc/6v2Lyy7oeclHZWOD3PiE4mC4B/JGbTdtVpuPxZ+IFSvX
         u1T7ZI8IXIpqpPtGD2yIMdq9t5FCjwCy4/8z3Oa4IVRRplymNs+ZW7sYLZo2loDE5WVc
         7V91D8wu1pFC3rH/vW9SNLZZHIIuyD8YXAi+fumSARvLPkAq1CkpZ/XI/umn2MHCmMlg
         z7hQ==
X-Gm-Message-State: AOAM531+jRe6+1AcRp3p+3CRDluPqKlQOyiiX4AjCDvKsdMLQQAt72YY
        U86MZp78uQeSsNpCHlGabvcQOsQ9YDbjzg==
X-Google-Smtp-Source: ABdhPJy1XY6b8MAr+aZVfNJKxm0/9HpQsBYTdexnfkHRgoPwZSO7YUHSdq4oVif3SQGTg5wjNZBZEg==
X-Received: by 2002:a1c:3d46:: with SMTP id k67mr4692509wma.188.1616174809334;
        Fri, 19 Mar 2021 10:26:49 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 00/16] random 5.13 bits
Date:   Fri, 19 Mar 2021 17:22:28 +0000
Message-Id: <cover.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Random cleanups / small optimisations, should be fairly easy.

Pavel Begunkov (16):
  io_uring: don't take ctx refs in task_work handler
  io_uring: optimise io_uring_enter()
  io_uring: optimise tctx node checks/alloc
  io_uring: keep io_req_free_batch() call locality
  io_uring: inline __io_queue_linked_timeout()
  io_uring: optimise success case of __io_queue_sqe
  io_uring: refactor io_flush_cached_reqs()
  io_uring: refactor rsrc refnode allocation
  io_uring: inline io_put_req and friends
  io_uring: refactor io_free_req_deferred()
  io_uring: add helper flushing locked_free_list
  io_uring: remove __io_req_task_cancel()
  io_uring: inline io_clean_op()'s fast path
  io_uring: optimise io_dismantle_req() fast path
  io_uring: abolish old io_put_file()
  io_uring: optimise io_req_task_work_add()

 fs/io_uring.c | 358 ++++++++++++++++++++++++--------------------------
 1 file changed, 169 insertions(+), 189 deletions(-)

-- 
2.24.0

