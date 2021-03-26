Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E042B34ABEA
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCZPwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhCZPwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:09 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8A8C0613B3
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:08 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k8so5828575iop.12
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hMymc1XEJnHboewJHBELgaGAh0vm6Ei5t+AwJJuno7Y=;
        b=jtzZjkCkA/H6kRKeE68HEeSfq8vuIBht94T40JDSITJdp9qEpLwFkX+Qhcj+9j22qB
         NlgXpiRJqjfhZmX/hc011a+n91cZtsn2f+YqFMmgAryjmyQ/w9PjK4DK6TstMln0TvjI
         LenX1AuewIuMnv7MoT+B8mcBqVGuqDJvr/YbmEd3XmDulZGXSHINPnmM9mQs4tMWxFSG
         pkNWyf4fsYymXOA0AGJWe//uNHGkJiDgYdSXdguIIVtIrTx+lnvI7nVF7ZTIFfpe6UvI
         nrfEIpVxvR5IpJRJcL+uaXmWpLV/F90u123YB4LJefu32Gr40yWAQUiMfxZYTf12NaNH
         Q00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMymc1XEJnHboewJHBELgaGAh0vm6Ei5t+AwJJuno7Y=;
        b=BBJtQFTDZ1rfbEGvH+aKRg8gyxIyx0RrWjbS5dlUAOORH3frMncqMsZGW90BT1VmCh
         XIJ8XYM/eNAOf8lcIItxcDVrTIOrtOMRzfTxvOfK4O1PRersLTEY/1WCDHSmhVsiuGaE
         CnUNd1rfL/Hz9VMLG6PLoz0TZr1iD2zGpg41lcxxK3KRalBX/pRQrg/6vlPLXaShVeFn
         AIG5slscNDdjR7kDgEL4xEiybYQAh9jXin2Wg2DIqOE8Krs9jy7ZCi9Vef0ZJrjW3G/G
         431GP2y0rFJCJuAgRKYu9Tu0200tAwG9AdpdfEEKnkKwfeLC01EvU0nsVU8Wuj3N8JDh
         9p8w==
X-Gm-Message-State: AOAM53387BgzhTmWj/LWFPpwIFdyetRPOFHZ+j7TDmIhYf+dZy0+vMUE
        rVGht6+YU60uwjxpUYuZZUPtf2HPIGnu5g==
X-Google-Smtp-Source: ABdhPJxZ9jOtQE1q+sJuYHM/GF053zovfxLbtCUAhIwA06HgAEMFNk2Dgm6x9FtO61jESbjwU1RIuQ==
X-Received: by 2002:a02:7410:: with SMTP id o16mr12537133jac.37.1616773928109;
        Fri, 26 Mar 2021 08:52:08 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] Revert "signal: don't allow sending any signals to PF_IO_WORKER threads"
Date:   Fri, 26 Mar 2021 09:51:19 -0600
Message-Id: <20210326155128.1057078-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 5be28c8f85ce99ed2d329d2ad8bdd18ea19473a5.

IO threads now take signals just fine, so there's no reason to limit them
specifically. Revert the change that prevented that from happening.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/signal.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index e3e1b8fbfe8a..af890479921a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -834,9 +834,6 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
-	/* PF_IO_WORKER threads don't take any signals */
-	if (t->flags & PF_IO_WORKER)
-		return -ESRCH;
 
 	if (!si_fromuser(info))
 		return 0;
-- 
2.31.0

