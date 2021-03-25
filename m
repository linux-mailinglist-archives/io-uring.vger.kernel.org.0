Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B028B349994
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCYShA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhCYSgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:36:53 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A06C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1737156wmi.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hnDYZY7O+PhT58XFGRZd4FXFf+mCDRCg/ICdtS/xx3M=;
        b=ClBghhn4yOMtXWjTCWkcqjq+v21WxnThoCUWxKFNaYRKpZVEQVHWXV82qkZ4cfgBZT
         t2/BtAHhawAUVHy0CuU+eE1J8gCMvnd163qlnS0Bd0ziHpZnkZ/6fPxb1qhiThgNF2sa
         yijFyo131apDfLueVRib+wPIAcuDYG8265n1kARwp8QLLyDgHd+OHKFzJph+SjkyahKl
         W9NgmZfE9CPlqAuX8iaVJhbZ24ttwst1PynBn2vs8wgD5+/SUgKSrkOQEmwLa8O5c7LW
         eOiNI/cNQlIAmUhn+7rqOI+Nrj1EvOawKWU/NTAHNFkt6IEXlZyxCEuf0N+uOffahJys
         nx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hnDYZY7O+PhT58XFGRZd4FXFf+mCDRCg/ICdtS/xx3M=;
        b=KHIDjzdyne9Hz4XbevZSsyI+gcY3p/v8Zhgo8XajeBkse5CBMHqLv8CNjquscO4ZJ9
         gZalx4DqFLVjVlIxHyawdxosu3ZiOAwnYK9eMsXS/ph3iP8O4K0V534qXz5V/P5oSj+s
         PlykOYAcNq6AbRhu7Bc07YeZ49/ewOTwL8EBxi2ONz2Wwx+63+iSVSd1fyLcvfmTnrcr
         Pa9W4ToBJ8ntET3R5Z9bV5oDKGXrVbjMtYa9v3gyyJRVoaIdnJqckx4OXP+sKPSL3Qph
         LsOCjzo4pCGKLCtGxblRiFLKQ2zXLKjE66HqdtRNAqd/yut1jUzKnmCqA3gT9/b7oimo
         xQbA==
X-Gm-Message-State: AOAM5329ymUYAv68J9QWnO9k5eynJeUIxkLMWTPIBTIkz1CZcquRuIQG
        2Ab6EdFQUkEm3HHgbV1hebSolNKojAp0Nw==
X-Google-Smtp-Source: ABdhPJxJ5wfy5wbnJ3EahdaTG6LXfw+lig0/Ezp9/XE4o5j/77LEvuQc46KtjXh2vSAj2qv2Lw32hQ==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr9251589wmo.8.1616697412228;
        Thu, 25 Mar 2021 11:36:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id p27sm7876828wmi.12.2021.03.25.11.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:36:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/4] cancellation fixes
Date:   Thu, 25 Mar 2021 18:32:41 +0000
Message-Id: <cover.1616696997.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-3 timeout cancellation fixes
4/4 prevents a regression cancelling more than needed

Pavel Begunkov (4):
  io_uring: fix timeout cancel return code
  io_uring: do post-completion chore on t-out cancel
  io_uring: don't cancel-track common timeouts
  io_uring: don't cancel extra on files match

 fs/io_uring.c | 53 ++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

-- 
2.24.0

