Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010122961E2
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368791AbgJVPuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368790AbgJVPuW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:50:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBE2C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j7so3030251wrt.9
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0q73s/P2cLlb5CN+UnDLuRBmHYGOhXwMoBOnZ6xOr4o=;
        b=Mv2cvkPhLpYGFZV1cCzUTT0LmUBNj0p3DFlsNyzVneQMG4m+n6PQkpC4rekNh4WFyu
         RptqUlp2N32eSzWw4nG+rfqKTQ74CRxDS20CdMwbUrEibumpyKiPyhFVIXOmgN9bLByv
         ESAXd08V+UTLMjFjjsqZEHNt+PDZ8La3D6VcfSn6ZZnXS9pQXZsPc7ic9R7qwu7uM7UI
         LUSnfEvTnFcjxCSitbBYNoT8r0tPpd5g2weQ1oirJmW9V5nlQehV6fFCoSYysrN6j8WU
         ySBRDfF15d0kHU3BB2dy4zKtWS7NdEzI8SQQiko0V4nqt4TbCKu9cUIY6gf+ZqbCs+Z+
         0FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0q73s/P2cLlb5CN+UnDLuRBmHYGOhXwMoBOnZ6xOr4o=;
        b=pkSfZoFgVo2uftw1aJ1Lg50g3VH1Au4OGJIfxzPcqh0f/0Qdcfwy81G7LtdSBn8Lb1
         i1Qw+xAXep2rkRmsm+xWF/yvsy0NV/3SD6GwU0G1ZVL9Dpl+VQ448v8Q4UBPcBsW0yrM
         Pi46X/PeYTax6GqjSMLV9jMxZYzf31mK0I5jrf/WnuvQv1etVeZCJ8L8P2NVcwQ3vdY1
         1px+AdhQzFUhmFEXXglePHR0TZ0gHdqbFL4ZHKEIfb+m2c6mELUIZkUXWElJmEz5ll8m
         HGuQaWyHCdyZ+CVE7p0onjKjfxj8ZVT9QXf8jVVQllTL2+T8EJAufK8No4rYlqxoxjde
         QF1w==
X-Gm-Message-State: AOAM532gffJojKT69qEX3pbFwSAyRLimDXnaKN+BLEfjt/0vAQwS+WKi
        qu6+IAfvlletsBFm+avTAXrUSC5LBZhWOg==
X-Google-Smtp-Source: ABdhPJx1q/Uh9LJr0GrEJJUqg0s8vzJdfr47H8uwvJJXAzorCoYto2PvFT16ABVVkNcrl1yruYuGsA==
X-Received: by 2002:adf:ed06:: with SMTP id a6mr3296837wro.375.1603381821294;
        Thu, 22 Oct 2020 08:50:21 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id m12sm4448653wrs.92.2020.10.22.08.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:50:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] __io_queue_sqe() cleanups
Date:   Thu, 22 Oct 2020 16:47:15 +0100
Message-Id: <cover.1603381526.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor __io_queue_sqe(). Easier to read, hopefully better optimisable.

Pavel Begunkov (3):
  io_uring: don't miss setting IO_WQ_WORK_CONCURRENT
  io_uring: simplify nxt propagation in io_queue_sqe
  io_uring: simplify __io_queue_sqe()

 fs/io_uring.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

-- 
2.24.0

