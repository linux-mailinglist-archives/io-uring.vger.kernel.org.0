Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F673F4882
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhHWKUH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 06:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhHWKUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 06:20:06 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C36C061575;
        Mon, 23 Aug 2021 03:19:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h13so25539008wrp.1;
        Mon, 23 Aug 2021 03:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6yDnLSIpYXYrIIISakMJ/pbasH+mpQMUOZLV1Lnsw4=;
        b=lj74Y5KPbqoe4ZwuOwXT8BOYIaKVexQv88j394iBmoyUjC9FRzDDJOuhly4WsEedI+
         KAWQtKN5wvb7kKJO160V9YfVHt9CTBc/KoBxtDbpHSytBFby5ejcjE0osDWpCyRoWMpc
         MBHyu9fPRo+XtXWl1dSatYLGZ8RMF62QjgVMHrIStqHUWDrnlX0VvCi1uhNDGAzQyabZ
         yjok/IUOg51xwAfaCi2MrWPwLgkAW5jHVYBRBiNQDIHmvyKNNrQnPjAicbUGUv9B5Ytl
         /O6xg3K2WsIFrMfgWFpYgauxc5EAQMiarGGE3539miFGNSJwKi17i+xPrsOePrXteTa9
         NwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6yDnLSIpYXYrIIISakMJ/pbasH+mpQMUOZLV1Lnsw4=;
        b=qMXaHs2HVM1arWV1NCQ+bxI0VQdz/ileuAXOXJwzfL5OmYIF2iK9vWclwti6scyo2l
         fODejdTlqwzb7dhomdTUzvCNG5GOlZSHCBdOMF2UqiuAuYiAAPSSxoja9+uWosDqjQXx
         Ej4zFo6uyB2GjJbtF2LTE7goubJCYH/ITU31+nI66KEL7LZfjcpcP7O2PY2Z2lKgQV+1
         Hs07jNLePGQaaA45TZnt2aQzoTjFDu0njzgNXBWTx+TxPQ7tN6+927rZoZXz2rbGnzGk
         GPvHcoFonL6q7R0U4cBzYS/0169+dQGe6WboG3/AnNOPicGaR8KA2Ccv2aEHXI60EZs4
         o3dw==
X-Gm-Message-State: AOAM533/es4TR+8GRHg+9fLaHGRX/4PqA32mpbjK/e7Gooy1x2XNF29E
        5XuOW0PV/gz+dn7PQyWZ1vczHMApDfU=
X-Google-Smtp-Source: ABdhPJz/L/7oncDFkyPzeeWSFNXLVjyTvyHDF/36ZcCWRetpjq2tVim8ZAvEdEStRXznQl66jA0+NQ==
X-Received: by 2002:adf:ab0e:: with SMTP id q14mr12875791wrc.171.1629713963063;
        Mon, 23 Aug 2021 03:19:23 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id l18sm20539922wmc.30.2021.08.23.03.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:19:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v3 0/2] iter revert problems
Date:   Mon, 23 Aug 2021 11:18:43 +0100
Message-Id: <cover.1629713020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iov_iter_revert() doesn't go well with iov_iter_truncate() in all
cases, see 2/2 for the bug description. As mentioned there the current
problems is because of generic_write_checks(), but there was also a
similar case fixed in 5.12, which should have been triggerable by normal
write(2)/read(2) and others.

It may be better to enforce reexpands as a long term solution, but for
now this patchset is quickier and easier to backport.

v2: don't fail if it was justly fully reverted
v3: use truncated size + reexapand based approach

Pavel Begunkov (2):
  iov_iter: track truncated size
  io_uring: reexpand under-reexpanded iters

 fs/io_uring.c       | 2 ++
 include/linux/uio.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.32.0

