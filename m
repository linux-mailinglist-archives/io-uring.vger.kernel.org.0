Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF32528FA81
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgJOVO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbgJOVO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:14:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3EC0613CF
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:26 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s9so220384wro.8
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHqtO8oENh1q2xVi+JH9o/S8aE4QdTBaPJsnneDlO4Q=;
        b=L0RUIYItDKhRxyvHjmMyWPZiVC+lDtXg0NlgNZLujpYM4wM8eGHdka0Msz3fDf/6F2
         E4BYH8rvhELvTS9ZIoaPlGAb9Lt07J3uM0jPLg3aTDB8VOPZlJsJfB+FHbssqMhbaN3A
         DNQQcnWAMajmMfpuxYes57f23/nOwxgFPxWE2qSIRSC/aHGBCK6ZnJZGMeBgCNqSv0NM
         0evWpvXySKOD0zyvIJrG0nejf5b9LcRkKPsJOc/2VHcjF7U5QbKo7dmzZJubtdGnXm3r
         8nk7GHE2aF8lKtOdKQovIpeVQPEi8FCbdcrDz1w31uWq5QuSFQgqpaZ0uQoYEn+xqEcp
         J9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hHqtO8oENh1q2xVi+JH9o/S8aE4QdTBaPJsnneDlO4Q=;
        b=ul5dn8DeNS/a0ppYCsXFSneZJ52DFXmkDRw414/YaU7Erc3XhU4+ImFPPWMqA8JS/+
         Y4A475DVjYPjoehSaQ/oL26xWtvj3gsH7yaUwKXa0yENWu6XO8SwTou91VVE23UKvV1t
         v2a2pnwEprsOAu1hv58iTYufaz0u2YgkGTeHwI2CRpevXEoyQOqMFFA5l+POC3agAF+0
         5pLmrGEwuIpNvBvFq4ueWvBnSi7p+zhAd1EE56jAdxG8BhwIk3VTBjDLhKiXS4rmPGu2
         aZoytfCvUn9cCLrp0t0JGcycQe4gMD6g6kWqV94/wcAlOP26K3zbrgeEeMxs0q3E9uZp
         vNWQ==
X-Gm-Message-State: AOAM530aekJIRCM7F7qWW+tqib9d5TmDBEcNVG5nG4SpuDVgJ/Zy8QI7
        OULupxU6YEyyPsy8fNL1K39zZKMKyuqr8g==
X-Google-Smtp-Source: ABdhPJxBfIiyS8ByG18dfB5GrxLAqdsNzjHZAeuSzmHQsNOOyUxpAIxl1L/PBtcr0ICF1nvmY6S4WQ==
X-Received: by 2002:a5d:4c4b:: with SMTP id n11mr197073wrt.171.1602796464122;
        Thu, 15 Oct 2020 14:14:24 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id x3sm320865wmi.45.2020.10.15.14.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:14:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/4] singly linked list for chains
Date:   Thu, 15 Oct 2020 22:11:20 +0100
Message-Id: <cover.1602795685.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

see [3/4] and [4/4] for motivation, the other two are just preps.
I wasn't expecting to find performance difference, but my naive nop
test yeilds 5030 vs 5160 KIOPS, before and after [3/4] correspondingly.

The test is submitting 32 linked nops and waits for them to complete.
The testing is tuned for consistentcy, and the results are consistent
across reboots.

Pavel Begunkov (4):
  io_uring: inline io_fail_links()
  io_uring: simplify linked timeout cancel
  io_uring: link requests with singly linked list
  io_uring: toss io_kiocb fields for better caching
 
 fs/io_uring.c | 202 +++++++++++++++++++++-----------------------------
 1 file changed, 83 insertions(+), 119 deletions(-)

-- 
2.24.0

