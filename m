Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6AF328B25
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhCAS3J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 13:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbhCASZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 13:25:33 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE07C061794
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 10:24:47 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id u125so148432wmg.4
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 10:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8VXP7XAmXd2dg4/V83JGeqjGlkaQ+44tsIJSwWizss=;
        b=GCoLknZmhJe9ckqwvtI8yi/nxPxuvF1390Yr2FgnQPH1RZzAm0MrCP+K3x3M/kZXgt
         BuQz6EXaCj3BDwdYl5yXXTvmjZeZ37Z82wFEQC2eUB5s1KMEaZKS9PcOBRhrDRi62WUm
         TijjEl6QoXe6dK/H6Dp2ebAmuREtUOn/ct1Wr89+kg8IeOWtr7bwaPsMQgRvJ5h00IDE
         ojJH826QDWQUQrVc/TkYbuYz6W1s+vheS/FJgXIbNuXNjAtJUwh+HxwKlWY1jnbgRr22
         sEbkc1OiDNSiB1ta6g+0HlLh++Pl1E1s5PAbZcxmf3MK87q4n0IDldTwho+i9343gSCJ
         /t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8VXP7XAmXd2dg4/V83JGeqjGlkaQ+44tsIJSwWizss=;
        b=b6foUffHKi0NZFnxBKqkMUZsojxxOxb020Dvnfwc5F7o8hotS5lcOt5kDhgYFA6dWP
         +kGvVUsyP8Vbx5ef+ibpbgeIxoMfGGRY0hmnsls2fwg2MSK2gj6iswPcGGO+B+T423hx
         Jma6GHqutKLKTfPBoXMurelcjBJQDfOnS0xfaeEZyB8mwTE9ON8ejUTIEkUpdnMXusr/
         WOhYMokWZW2C8dmrSThiCsQwjVJZcizoWePumoRo1ns0zlikP8LrwRZf8UIGoSYnrs3y
         j8MRlvSDXpN/7vOEdBj3+P+v01/OoNve99AxKRW5jzwIH//Q0OEvMSUvzni6eKidRSjd
         8xeg==
X-Gm-Message-State: AOAM532yTg5BknhiWFt+zKNk0AeAEEw/8Zcr1Es5+/vfty4aA5p6pmv8
        ujL5tLmm6tDFN02bz/3bMIgmSL83rxcU8A==
X-Google-Smtp-Source: ABdhPJy/jGUEfTXLNMVRyoVtkiFqJByNGkXJC7Fz8ge1oH9SgMMsQjxNLOkAL9v6I67m5rCV0wW+og==
X-Received: by 2002:a1c:1d14:: with SMTP id d20mr211364wmd.36.1614623086233;
        Mon, 01 Mar 2021 10:24:46 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id q25sm125146wmq.15.2021.03.01.10.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:24:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/4] random 5.12 bits
Date:   Mon,  1 Mar 2021 18:20:44 +0000
Message-Id: <cover.1614622683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/4 is a fix.
Others may make slightly easier looking for ->io_uring usages.

Pavel Begunkov (4):
  io_uring: choose right tctx->io_wq for try cancel
  io_uring: inline io_req_clean_work()
  io_uring: inline __io_queue_async_work()
  io_uring: remove extra in_idle wake up

 fs/io_uring.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

-- 
2.24.0

