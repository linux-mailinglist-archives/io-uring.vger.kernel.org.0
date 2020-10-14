Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD728E785
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 21:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgJNTrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 15:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNTrY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 15:47:24 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AF3C061755
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:47:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id n18so449060wrs.5
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 12:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ne9WcZ5D8b0JpTnEB8b9oqQ/vwqKbFoU5qepORtJzyY=;
        b=PnY1nkfkhUdeKtqssYZC1oJfjCdIAmPBFVpCiNA/S6V5UcQ6wGg2jqZ5II8uZ4kl9A
         RzSgE5fHe2krbM1Ar/NZDK6m6Xr4n0qGSPpFCfZfW34ysUtSXW4oHlfaJvQBfLGRxyF7
         WOx3/717PmYIaH1ilGinzA6PKritJfiB9vvz2sOmEsivL8oMp2DJsvAclwi8kIMsCZn8
         7IC9UjWU6CT4upWPHiGS2iqoNOzyN1x9HtZGUq8bqZgY2RPDLzK8KkABciNiXmu4HBqE
         J9KDl8CyFoJbcs4Cq1Nzyuw3mlxvgzlHRvu2ti8U4FsBCy9y+oE7ghVunXBi5A9PS75A
         QHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ne9WcZ5D8b0JpTnEB8b9oqQ/vwqKbFoU5qepORtJzyY=;
        b=Gm/Exvn0Lt620krFQA0eigPvebBPzRaq6dLHJsolgzuFRkrV33YhCvibnt+KSsBuGJ
         b3E/wgKW0/h8r0kFo3zfSCSzb37sYWBCjlPBgybbocEyCyKUjJRGNsU/m5maNnTHnYUc
         YszMH19LlPR3J7YU70O5u7FAr7VBBeLM1OnIPTgOhhH7sSc+8ZoIdyn/0pX2Cfy+2Fba
         jeHtgCkYbRJxQgJ05YhprKVxdTcwILAQZ5T4DcjODJ0/deMmxdG/ZFL7z4iiWRq5g3Ek
         9ebCTqsj3zgjWEgXi4f+NVSQLJvvjPBijD28831FWqFvEYuCihcG5ZfY8jUCUy4g+zXG
         JNgA==
X-Gm-Message-State: AOAM531r/er2SRPTYkAL1akasZ/g+lZ7yuDtue8Pw7Ko3LS+sMdQjVxH
        yBFJCxVSXuCtAd1DFDUm6t8IPsS9P848vg==
X-Google-Smtp-Source: ABdhPJyHKHB2r25MezzoRBoZ5rc6tpL6iq9Si7VcVC6DpsmF+4s/HNaoMSMR+hDnCIk2PSdBK3FumA==
X-Received: by 2002:adf:94e6:: with SMTP id 93mr387253wrr.190.1602704842566;
        Wed, 14 Oct 2020 12:47:22 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id 1sm526985wre.61.2020.10.14.12.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 12:47:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] post F_COMP_LOCKED optimisations
Date:   Wed, 14 Oct 2020 20:44:20 +0100
Message-Id: <cover.1602703669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A naive test with io_uring-bench with [nops, submit/complete batch=32]
shows 5500 vs 8500 KIOPS. Not really representative but might hurt if
left without [1/2].

Pavel Begunkov (2):
  io_uring: optimise COMP_LOCK-less flush_completion
  io_uring: optimise io_fail_links()

 fs/io_uring.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

-- 
2.24.0

