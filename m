Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB53EABEF
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 22:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhHLUlv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhHLUlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 16:41:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76751C061756;
        Thu, 12 Aug 2021 13:41:25 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b13so10111912wrs.3;
        Thu, 12 Aug 2021 13:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUEhi4C0UJ18htQv3cTjB+vka8WwvW5+J/sHIo3n+bA=;
        b=cdpSLceD5UKGqt2v2miEWi/wfX6ej6vwlnVmLm58UrYQE/QwyYjf13pP1IUpnFk0bX
         9CUQ+NqSDCvImj7CgWHcWCCouoyfps/vGNXZIgXRhMFZsPCaofsua5v05j14oIBtsl/7
         7suYEVJMKra8DqyGmaxE4mpVZlWm7INMZC7hW7UOCg5Nl0P577EdEmiLoCqeRtiQvAgk
         ghDmUI5NgPhQnWm/HNDfkeD4NKpcKhiiBIF382U+uznLNezNVW5llcdGYVBB8sd2gMyy
         6EiP0LCnrIjXKWoo198aWG+sV0/zzdgaXyV1WwqTeXsdpXP94Bbw562XcZK/WJOzgh9+
         mRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUEhi4C0UJ18htQv3cTjB+vka8WwvW5+J/sHIo3n+bA=;
        b=aIdvBfJwh2Phc6Pw+ATN1CZMgq/wdw2JVL7qdi5pH2+TzXqCOqSy2+XL5Ge0y1Tsay
         mLxWPU3KY42/DItX+FwUfxqGw2Huo7yRnDxdLe4fxQFMnBNNr6tP8ER0c7CH1fibi67d
         EbE/pT8HEV0fShys2Af1NonSYKRkmz2pWBEDs0cAe/sHtWHBBj6Uvde76xh2TD3x4Lh4
         siA20gDIWuXaK1dijEK7Fecsl+kBiL0hdxvlHG9HfVozqjAkxYrSUBDLYxf4LnWDbYVr
         A3CD68QUhLqAwWv9bdolMRBOCsvylj0RzUpDdeqHZNeq0mx7Z3zzKIKJdqV0tyYZnGfl
         TM/w==
X-Gm-Message-State: AOAM530ozd7SsI6NdkizmN3xWOq/H9UYQ/ycFtBVKWdjf586GSiFyhIL
        vvul1xajWC6v2vfvCeKhveE=
X-Google-Smtp-Source: ABdhPJwiFcGrvKXYIh5bwuCV2cFKF7mj8JYiCtxqXFVJtUDntrzsWqbR0FtrlmEax9lNUU8rZ+v7bg==
X-Received: by 2002:adf:dfc2:: with SMTP id q2mr5985014wrn.13.1628800884148;
        Thu, 12 Aug 2021 13:41:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id i10sm10296556wmq.21.2021.08.12.13.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 13:41:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v2 0/2] iter revert problems
Date:   Thu, 12 Aug 2021 21:40:45 +0100
Message-Id: <cover.1628780390.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For the bug description see 2/2. As mentioned there the current problems
is because of generic_write_checks(), but there was also a similar case
fixed in 5.12, which should have been triggerable by normal
write(2)/read(2) and others.

It may be better to enforce reexpands as a long term solution, but for
now this patchset is quickier and easier to backport.

v2: don't fail it has been justly fully reverted

Pavel Begunkov (2):
  iov_iter: mark truncated iters
  io_uring: don't retry with truncated iter

 fs/io_uring.c       | 16 ++++++++++++++++
 include/linux/uio.h |  5 ++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.32.0

