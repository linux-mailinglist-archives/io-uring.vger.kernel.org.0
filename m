Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58832C990
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhCDBJu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345919AbhCDAap (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:30:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B581C0613DE
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:06 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w18so17535680pfu.9
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rUlDKm98LYnvgifuHwaKtoVeZS21r8yakiJTkn1tOQU=;
        b=rG9wAOUqKjWEwDvvB31DPxlS3QwmLFTEX2Vm+G2Rv1sK1qTA27R4SzNnl6GFnXlsMu
         +gwWI+MlX2aSi3qxn1/WI6TSH7Q3re55mt5ahn0blUyZcDOUc+UQe+tP+9cacnJXkXQr
         CYeYOKG6Ainir5Wx+7yEOkOtwixNU0Wuwmj/P3cudelCZ2Gt3GAnl0oiKlQJF8LxB8GD
         kU/oI3ylbe1DrpIIk3X3shfetHUpLNIdMNl7Vx9iWaYjOWZ9M2CDuORAzEXTynNB/VKy
         97/LlHrbKuat0ZfsayfHzt+P+Sr8PT+a9VeEqBOgeCCuf8lnIN6UM3I4ZAy/HtTUm3GG
         ln9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rUlDKm98LYnvgifuHwaKtoVeZS21r8yakiJTkn1tOQU=;
        b=f5W7XSGDu5rL3jdxkzd/CHdcpJmNfj42/5T25Y577TyAxNi1MnSSxGBP5WYoz7N5CK
         0Z/zplnR7AKNK/0JUgUY6Ns0h7XM3ekCqW3bzyqxorD0XJJ7mUJbFybC2069UnH5LZQz
         4lhS1DDDLXXf5Mr1Smqj5eeQdlT8/nBCxGUjM2z4/bFun5UzvejeSqFfOH14nySQxe3M
         Thv4jDNjnYuutEHE/HnLZYsQydfgnmlAmVxebNwXRZ9bXDdmgEXHgoMmDpeJRQ8a3GdS
         0fyjC7gurSb5A7gB/cQryc8uRRJhtwnjeBdTL5ZrJDHjMDgLQgcFj7SdGTps3ZvywSRS
         yKKw==
X-Gm-Message-State: AOAM532h7WhHPUr+/EQIw54PwrvF3UUYhyDZ9o0JChnVguczLuklGGYJ
        Y9H07wo6RGR/m4OW0XBU9+tDsMUFYwvglGey
X-Google-Smtp-Source: ABdhPJwQpbxEX27glscqH7yxY17xM44xIdoAjjjk2CZS8JswBAiaIaQQpFP00aWurgjqPBKEOd8YzQ==
X-Received: by 2002:a63:1505:: with SMTP id v5mr1386980pgl.95.1614817625451;
        Wed, 03 Mar 2021 16:27:05 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/33] Fixes queued up for 5.12
Date:   Wed,  3 Mar 2021 17:26:27 -0700
Message-Id: <20210304002700.374417-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is what is queued up for 5.12 so far. Mostly cleanups and removals
now enabled by the worker change, but also of course fixes for that late
change.

 fs/io-wq.c               | 158 ++++++++++------
 fs/io-wq.h               |   4 +-
 fs/io_uring.c            | 400 ++++++++++++++++-----------------------
 include/linux/io_uring.h |  11 +-
 kernel/cred.c            |   2 +
 kernel/fork.c            |   2 +
 6 files changed, 280 insertions(+), 297 deletions(-)

-- 
Jens Axboe


