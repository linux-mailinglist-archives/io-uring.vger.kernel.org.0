Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71564F2146
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 06:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiDECmL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 22:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiDEClO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 22:41:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC72A2BA3FA
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 18:46:14 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so1119726pjy.5
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 18:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BsGA9SpGC6C7m8qECeJ8m+A/i3c5+5UCn2X5koLNZyo=;
        b=k+T8QEQxtJbQdYY3WgogiPQP0ZkSe/cx7Do42vf9DlLH+IxWXlWEcX2BlkD2vlUKDC
         /ZsfPGX8e5DLGCToa6vuFbigKzaaXrLxPvW/npxSRfzmLY4JljGJEPaDCph5vGaA7mgh
         W0RONcqPl5lPR3RqyP8BeYF6kCvbK7p6tHgotbeEGbDEbPse19nma5zmys3NWIOqRQEb
         D4DBMrZkFIrjDm3FsVjLCczN5m9/GLUzlrQhkVC74rwYT6keY28ZGPsuturkzZiQ1otT
         x/lYMnnOPx02SAqOz1QH3xo41z8cD9Hpf3i7qBP0Eega8YrexqqfZMfdzXA93ajgHqUv
         YAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BsGA9SpGC6C7m8qECeJ8m+A/i3c5+5UCn2X5koLNZyo=;
        b=A4j5qActof38x0QJvSWRB2C3oY1MUip6lD+EX0e1FWelMKu+EDQvy04dLOlmfLy2PJ
         l96zOp4nxl7Tpk10u+QTvihcYQaG39C1u+WtUrQ3dg2WSg2VaXPgsuEV6U5q+k4F4OWX
         mkSZn65PG59beAQauVcoSmXik5EHbDS2Xr+1967CzVEvhCB8qfPBja5BGJdPJ3fUhOGe
         oA39A3rCMzC0Y11GV4or+NEzw8MKqPkmal7Vcryhw/9vYabk5wkogFgSozPrgsp6mR4G
         881Z9hm3e6Zfas6BUmoR3/QIPZ1HbuTnu0CLIk001roIJtqppvcEkUgriMQKFi9dkCf8
         TTag==
X-Gm-Message-State: AOAM533sjKWQASXjfeIXborHmQ3LKq059pJFIsoRFXWQPCAlwtedCenu
        VCf8HOOhwNcYAunbnpnwX7mcts686fD5Lg==
X-Google-Smtp-Source: ABdhPJxd6Esbzvcpk1eYqC9eN1rkFZQhRHqfe86o/ho4si42UnURERytW3sGWpZUQb8YWL/y5m/b4w==
X-Received: by 2002:a05:6a00:2181:b0:4f6:f1b1:1ba7 with SMTP id h1-20020a056a00218100b004f6f1b11ba7mr798527pfi.73.1649116594229;
        Mon, 04 Apr 2022 16:56:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v4 0/5] Fix early file assignment for links or drain
Date:   Mon,  4 Apr 2022 17:56:20 -0600
Message-Id: <20220404235626.374753-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Most of this is prep patches, but the purpose is to make sure that we
treat file assignment for links appropriately. If not, then we cannot
use direct open/accept with links while avoiding separate submit+wait
cycles.

v4:
- Drop merged patch for msg-ring
- Drop inflight tracking completely, pointless now
- Fix locking issue around file assignment

-- 
Jens Axboe


