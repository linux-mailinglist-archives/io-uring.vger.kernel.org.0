Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D810C2DC9EC
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 01:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgLQA2q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 19:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgLQA2p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 19:28:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A64BC061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:05 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id x22so3956940wmc.5
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9T/zaOUlj8Lg+4sqdWZpH1H/q6wXRVNtGYRUug5poUE=;
        b=M+qul0kjVyF1/zo7AtGZm3NzYVxhrn1z87JkE4y6NiZZGivn1Tx5fKIJrK9xsQsvQy
         5JVUcMfZl/+ES6aSb79Ys4Mt8qmBhaIrJ35vC3Bv5AYYBTFk5Nux1yIV6DTSlprn175l
         OE1nJfKISjq9TIw0nRV23huTIjJ7gNNXKgKjG/SmgePhuA82tNMd8Zb8fIGeuHYWT+q5
         5OdTkBN6KTZKFBgsrMLpcCVJgaCrMN+fYNdzx0kA+q7WSGhLfzrRI3byp1p3MosDiMZd
         yTFx6kpKswQd54XW0S1xUc3W+BS+6jBtf5mUwrkmrT31E0x6uwUs3PxuhYbgIX3ZIzx0
         GRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9T/zaOUlj8Lg+4sqdWZpH1H/q6wXRVNtGYRUug5poUE=;
        b=oNu7iXmU1I8V4GqyM6jOoMQy5k3DuwzbhJisqyptAkVjBgiuBZ6Wna/PKM2cXRxq6+
         gFpoDtL4/G/pxoHogjlvNSss4P/2NeMbc1UV8yEEwgR86DJq0HCVf4kgRVobJpVw8r7j
         +GEG6kmaAZewWzKBShaxhBZ3ivbIw6pwL/fsLlSKf+UADuZlkNeUHnOG/viuVNR6kxTp
         2Q/Y3JLx10V8Fdie5WvQHHc+qxtQRJx/MrXxC/EdM56RyKHrjAEqjJOU/7pHLuNeZUDC
         HGkgXNoaBeLTy6mamx1vfUKLSrmFmV4EZgxTX06leugV+LUsXRYfgZnBPt4Ob9RagAIK
         y/PA==
X-Gm-Message-State: AOAM533ZmuH2eFsa6tLyD84mIUnTSTUZrySJIuplc4LGumr6l0JwpPvI
        FgxYByiWXlFA+zRsd/5MMLV368RdPh30/A==
X-Google-Smtp-Source: ABdhPJzLkzhns/VMCJTFoe7vrMu9sxdpj4GhWJuOYSvFo+VeTw6dfhEjXvH8x1DI68OoIUN1eZSTGg==
X-Received: by 2002:a1c:4d12:: with SMTP id o18mr5845376wmh.114.1608164884111;
        Wed, 16 Dec 2020 16:28:04 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h29sm5711161wrc.68.2020.12.16.16.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 16:28:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5] fixes around request overflows
Date:   Thu, 17 Dec 2020 00:24:34 +0000
Message-Id: <cover.1608164394.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1/5] is a recent regression, should be pretty easily discoverable
(backport?). 3-5 are just a regular easy cleaning.

Pavel Begunkov (5):
  io_uring: cancel reqs shouldn't kill overflow list
  io_uring: remove racy overflow list fast checks
  io_uring: consolidate CQ nr events calculation
  io_uring: inline io_cqring_mark_overflow()
  io_uring: limit {io|sq}poll submit locking scope

 fs/io_uring.c | 59 +++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

-- 
2.24.0

