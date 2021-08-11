Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F003E97A4
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhHKS3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhHKS3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:33 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D1C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:09 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q11-20020a7bce8b0000b02902e6880d0accso5122820wmj.0
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkEtYVOjtlod5JTO5yem2FaFoKspQnPilICbAQqsd4A=;
        b=ni/C7qqT1tIk9e8V0uVnqtLUA4VFt9FjJ6UGEiUhLr487r5EyTzIFRaoEoWRWGyJvL
         +6zZp0qomwXC109VWCs1/8smkJdKAn9NHz8vuguMyDsJFd48M8jwzsEm8ylIx7dVMxSg
         SQFBYoI1eHavrKQlR2AGNOzOYwHi2WMNEcPPLcCmOtKSO3/xoP5yWsWqzuzGBghfYI9t
         K5x0AgoXOlyhTBRps+b1oLZR+DEB3OXougLUOMoDrTNc7r/8g3I6PqzB1N6MMmnn9PYI
         KipXGa6oN6aMSyItBAFefS/bKd97iEzhmr6pUC83gMMRUZ3D5JQRtt3XeqzWtXknsab0
         GF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OkEtYVOjtlod5JTO5yem2FaFoKspQnPilICbAQqsd4A=;
        b=NQ4d1QJoZ7++d9P5TbCkRux+nHf6kZTL1tur0Ij2zly2wzQWpGOSn+zmynb7i9mEWn
         r3V2nxS+0OnjGQKtGZ/SV7YMgdZ+LzOe6ohHQppFyaPgiGj19OlbU/q7KNnHqo/j3gCe
         YR5cX5AwG9rrfEsIDdiWqSbI3ylQXQRNy3q1auOYViaRZqUAfB3If1c48YHylyCHHKdd
         E4KbbnPx4BU2IEtsg47Jzq6gKYgteU5nU2+0Km0S0lW8wSqwpvhzgZnyckNdFrkMtse4
         aWzIH4ODAabjPx1XTFc9hesA3RZqeCGVDyw7qgIXchefe/bNWvnvzYwgDzrelZkaqW9t
         45nQ==
X-Gm-Message-State: AOAM532jdCteRNgm3vFGTE3wgJiEw3MU1J8n0iDvt5ntTJWLFFA7aDxU
        ck1OwJz9qlrdYZgayF2V/FA=
X-Google-Smtp-Source: ABdhPJx+qjw/d3LL3NBWA7sTERCY+l2K+xwdKdeUTqLXG5AxwG+UDGeP6AG9niRjhD+O2Asxtg86Tw==
X-Received: by 2002:a7b:cf13:: with SMTP id l19mr11699745wmg.134.1628706547415;
        Wed, 11 Aug 2021 11:29:07 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/5] skip request refcounting
Date:   Wed, 11 Aug 2021 19:28:26 +0100
Message-Id: <cover.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With some tricks, we can avoid refcounting in most of the cases and
so save on atomics. 1-2 are simple preparations and 3-4 are the meat.
5/5 is a hint to the compiler, which stopped to similarly optimise it
as is.

Jens tried out a prototype before, apparently it gave ~3% win for
the default read test. Not much has changed since then, so I'd
expect same result, and also hope that it should be of even greater
benefit to multithreaded workloads.

The previous version had a flaw, so it was decided to move all
completions out of IRQ and base on that assumption. On top of
io_uring-irq branch.

v2: Rebase to IRQ branch and updated descriptions. Removed prep
    patches. The main part is split in 2: dealing with submission
    refs, and completion. Added 5/5.

Pavel Begunkov (5):
  io_uring: move req_ref_get() and friends
  io_uring: remove req_ref_sub_and_test()
  io_uring: remove submission references
  io_uring: skip request refcounting
  io_uring: optimise hot path of ltimeout prep

 fs/io_uring.c | 173 +++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 79 deletions(-)

-- 
2.32.0

