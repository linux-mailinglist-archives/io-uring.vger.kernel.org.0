Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADC32D9C4
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhCDS5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCDS5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:07 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C76DC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:27 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a18so20625773wrc.13
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lIDzf/d1MlRoOFca5AN7RfrNRaDuFaq4aM75ME/o3Vk=;
        b=h4tbQHCzzzyvPYjOnD4AwFTMKyYB4mZZwQxGRFo+zH3fYRA6tBkQOfo8Qi+o/EzjwJ
         JaWBSh78cCx+3ugJUl/n4WtjRA1l+QooXnIuBVctptemlbRe/FXXIMURkVQbBOdASQUB
         XvHDPkpWRmdzeVdC2h7ZLG7ybTkzyDWqcz10opLX7WrsOSvSR0nRwoNxVPhT53Y7d6IZ
         ym2VoMQnPdFN/wfY/fdXLOqTMC18JIfxKSrFa8Ke0hmFhlvUSTpzmqU8w3A07CRHwQYZ
         w0tLESH262k9iYBnKoDtuabmvpcFX/JGsu/7cXBLYNDAAKFvuYO+PNz6XoqphQ6/anpT
         hRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lIDzf/d1MlRoOFca5AN7RfrNRaDuFaq4aM75ME/o3Vk=;
        b=bbe+MY57w3x98G6rCXfB2CJtlOGxcSwAeHDqcTWqsqZhJfJ+EDJWWSqAaJxtUCOr9N
         nYYZ7dosVW8z1JMUR9wzN2tb/srj+vFK0zIxTsICVgOmsn6o1EMYKeK50DUStFbnP6nP
         CAZd8/KzhDK0HwmnRQUqAcR1u06TEDO+TTmIcoCvozhH4XxnCxeHoVmZWsv1OhcmVtr/
         Lu3KnFriZVOqy6/KKkC6XXujeILwwPerXM6UxS3ZUlPelgVyB1Sl9odS20BKP3OmMiP6
         RKE0P7LzyVy4wYdR9cZwOQQprtfiQm4iV4VNdAsyB5BcxomITxDWgnxQRDZ4iAsp1si0
         akwQ==
X-Gm-Message-State: AOAM532xqcIBZcQWcaIfLlZBvr5Ta4invGl7+GGgre60KON69eYXAkWZ
        9hqCu6mWtjaloerjI81UHFlAdeFdyPmSGQ==
X-Google-Smtp-Source: ABdhPJw7JYCAjWPXWDyfpV1lnAyK91InAtBa/DV0/ZPl4Hy06LydyxkmD8MlH1SvJNwMmpXHA4v4Ow==
X-Received: by 2002:a5d:6411:: with SMTP id z17mr5403998wru.119.1614884185750;
        Thu, 04 Mar 2021 10:56:25 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 00/11] a second batch for 5.13
Date:   Thu,  4 Mar 2021 18:52:14 +0000
Message-Id: <cover.1614883423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Easy patches for general maintanance, a slightly skewed to the
optimisation side. Benchmarked 2-7 before, which gave a slight boot for
nops(32) -- 22M vs 23M IOPS.

Pavel Begunkov (11):
  io_uring: don't take ctx refs in task_work handler
  io_uring: optimise io_uring_enter()
  io_uring: move setting tctx->sqpoll from hot path
  io_uring: inline io_clean_op() fast path
  io_uring: optimise io_dismantle_req() fast path
  io_uring: abolish old io_put_file()
  io_uring: keep io_req_free_batch() call locality
  io_uring: set req->work closer to all other fields
  io_uring: inline __io_queue_linked_timeout()
  io_uring: optimise success case of __io_queue_sqe
  io_uring: refactor io_flush_cached_reqs()

 fs/io_uring.c | 157 ++++++++++++++++++++++++--------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

-- 
2.24.0

