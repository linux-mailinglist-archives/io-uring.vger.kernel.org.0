Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D47344DFF
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhCVSB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 14:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhCVSBL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 14:01:11 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E01C061756
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:04 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z3so14901851ioc.8
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBH7wU4IlnWC2HiHQ+T3Z4EjDCon/J1Q+9uaSfpYYh0=;
        b=szekHwVb8JS23WCL9EHLgmMp5jRQdtKCNDGhvLpOUHgyumVXFmGaACXD+Yq+PnpIxJ
         UXK2bRfYo+jxb6uv6iw8ikpDIKyTaK7gvhoLBd4XFmsNTcZtmGK7FvpTkXV8hFjJD7RH
         1l/dyA3NhfmgjTNx4p5Bk9KpY5cQ1dqr4ytrZtuWxvR4f7uHjHSAMibJbG3dyzxWzc8t
         vyEhEiMDa1js7ZuC20LMDKDkKyr3BZoy3kYz1A2CVmNqia9I2C/jcmac0p3uUTC7LMsW
         6+El5NX7eDEiOVNMaNCbeUlxsHn5Fg11nV/ZDn0q0HUfqg/wSFe/58htHg+2hrn+L0sL
         Ed/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBH7wU4IlnWC2HiHQ+T3Z4EjDCon/J1Q+9uaSfpYYh0=;
        b=NiO9dLEDPkOGXy9niF/xU8JqB/N0cekFmscQPXZa9hLp5/UFtSm/psHTIQ5j+C4yzF
         75wqIDFn7Mbq3ZgVBjKJJ71MTXu3Cz0MorLZuwuIb+kAkAvJrbar+5JPfrnmMWzRf5Ct
         W4wRXTu1YI4AUm7loxsB48A95BHAlR8+H5PVbucQGJlWoVRwk/pAcCBOla/OMAfEM77e
         xuZyc2mTjt5TakcQBPZrj2tZ7Nb/vujrqRGPjKYsaUSfU3Rp20WYnOKVN5HRA8wAlg6p
         PTxgbPHOwsRHbjChe3mvNP4CYs+oGQA8ZuMtjR/xA4wSwY1lE3YUHAA2+YfZPyBoyXbS
         R45g==
X-Gm-Message-State: AOAM533WrzunEWwtonoy0L/SblDQTzQLv6YQue+tziwGDKQyw7sIeT9D
        Zp4VoziTu909LYYb+vEL8HmhZTtTGXDOEQ==
X-Google-Smtp-Source: ABdhPJzMTzQROLHwyaPSGyHYa22k0Z0M7wGqf+5yLw6suMQFmXdZ+J0Bjl9mkBR+ly2qkRUOmjMcxw==
X-Received: by 2002:a02:ccd9:: with SMTP id k25mr540712jaq.43.1616436063422;
        Mon, 22 Mar 2021 11:01:03 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r12sm2903562ile.64.2021.03.22.11.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:01:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] kernel: allow fork with TIF_NOTIFY_SIGNAL pending
Date:   Mon, 22 Mar 2021 12:00:58 -0600
Message-Id: <20210322180059.275415-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322180059.275415-1-axboe@kernel.dk>
References: <20210322180059.275415-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fork() fails if signal_pending() is true, but there are two conditions
that can lead to that:

1) An actual signal is pending. We want fork to fail for that one, like
   we always have.

2) TIF_NOTIFY_SIGNAL is pending, because the task has pending task_work.
   We don't need to make it fail for that case.

Allow fork() to proceed if just task_work is pending, by changing the
signal_pending() check to task_sigpending().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 54cc905e5fe0..254e08c65de9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1941,7 +1941,7 @@ static __latent_entropy struct task_struct *copy_process(
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	retval = -ERESTARTNOINTR;
-	if (signal_pending(current))
+	if (task_sigpending(current))
 		goto fork_out;
 
 	retval = -ENOMEM;
-- 
2.31.0

