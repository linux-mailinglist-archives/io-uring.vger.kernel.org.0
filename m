Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B1E31FFFC
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSUuG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSUuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:50:05 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39272C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:25 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b3so10307018wrj.5
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glu44rg1OOADRdErC5akUzh9o2wGMoBEVEo0AFGRjVE=;
        b=W3H7TrrHxCwI4C+y4eVTVrgCgmxT3LexTlvn+vzVqScH2elRP8ruwXruzmaoOPcoUI
         8l8niCtPtkEuK7qpRLgB0LykrIlqeG46RJdp3e/DQIR+9v26s/zxbISFZ0IExe8vJ/2W
         Y7vQOkoKkT8rqOCYt75239zzkied3mBu+L3p0RBefjFe2hLiVZ0l3mdzolcVncPBfxe4
         fUeVcAG9IJ/yOBIvt9NRZHaSbiF/evc2BVmiLk6WB6L2KAcFojfQ6f92k5xaiEJVWGyz
         niAbZzeMr16bm0ryPdQzXzlLLx7mvDpXWEpWJajjUreA2FZsX+tlgA1UEu3yCBxs1PtB
         T5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glu44rg1OOADRdErC5akUzh9o2wGMoBEVEo0AFGRjVE=;
        b=NNdx7OGVTjNI7CmOyjNd/f4US6RkFslQvI28AjKG1hwXccxvxJD+emmqyffsrZc+qU
         17YMwfBagZ6oUhEstR9NRl1JrqX8uviFQnF2Ov1DePN4ZADtGpdoODYNWVDKAwV0n2wm
         kLR6Cmp3v4gJS06Dca3ffVCvr8a2qSz7HQSywYc/cwA+OVMjcPJw4740xmS12GPQulSr
         nIOA/eDSStnySerW4SMMhkhGc/KacffI0DIzjv6v23hWtH+viaYvsuxISMnNP1oqrpUK
         GKmbxF6QwlR933W32mKAxkd/t+/g0mmXP8Kt6wemcGHgUc+NNQz9zwuYAReLd7v7aYfB
         TiMQ==
X-Gm-Message-State: AOAM531FfCbek1ICKq3VHAsnZ8B4QNhwieZrl4cZFQdJOEC6XXcB1D6X
        UrS9kDjWL2M7ZnawDozgWlOvTLimOs8Q+Q==
X-Google-Smtp-Source: ABdhPJw/MMIVeNqwuVytdOKtAOZVkoD0aisoMr2tx7Rp1E9ut7lGeF+7EuPkx+H1GQ5qM1Wa2eYprw==
X-Received: by 2002:a05:6000:1208:: with SMTP id e8mr11059141wrx.131.1613767763853;
        Fri, 19 Feb 2021 12:49:23 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id l17sm3207298wmq.46.2021.02.19.12.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 12:49:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] rsrc quiesce fixes/hardening
Date:   Fri, 19 Feb 2021 20:45:23 +0000
Message-Id: <cover.1613767375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/3 addresses new races in io_rsrc_ref_quiesce(), others are hardenings.

Pavel Begunkov (3):
  io_uring: zero ref_node after killing it
  io_uring: fix io_rsrc_ref_quiesce races
  io_uring: keep generic rsrc infra generic

 fs/io_uring.c | 65 +++++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

-- 
2.24.0

