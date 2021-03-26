Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E220C34ABF0
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhCZPwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhCZPwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:11 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65581C0613B6
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n198so5910598iod.0
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=w3MnhLfaad+pxtWTS9BUynvM43dek2hPrehG0A67EVR1rdqR337c8VGQbQJXe+d7d4
         NKfb/nmFXDTyDG8qJ9zxBmNRj5Oy6ljtpG4vGJJnOz+tfCvq2C8wfSu4f1cf03k/2O8p
         smzW5qzuHl+suOCwHaNZxQzeTcAKCdCm4Hawb3gFePk6xAbsaUBZlbItZTw4KPJggPAI
         VEV6/N/Ma48ONPcmInLpENF6lruYjrBfFA7DKvVK6h8k48Wxsw7+RpwjCZa7/HFnOW/f
         x/2tD0wjalBfmYQKFSH1dS7eo6goFwrBZw0vw25/J24lTdbB+KkeEufgRuLDwZ1lJ9jD
         Nk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=qlFBiiFRl1FbQzYQ0ukaMcH1C/BtVtNMc2Qyk6f+JRKCeMSBySKdeCTlqkS+SLy2Xn
         OCWWSU6vt3EjPNRrbOGnSCVs9K4J/HLkGwXbsvpshGJeOei9tLLbwBs+JpNonRJwokqw
         ciRa09gxWzdDb5Ba2CD2ebQlj6ZHPbx9pxvHX8V2sp/htwvGM9DoQf/1VI3PsgkeZwqh
         5nmyV6hhTZDFAqG5GyCrtjR722rJpV8klQDAvTvZ8SbNrnCnWSzFBrfuZXsnMxjXOsHD
         DMLEAJW/X63lsERveuTISCWhuyd0bQNH/cCjpmR/kFStBOezSWBvZkLn1lbgbqV8uQrM
         HpaQ==
X-Gm-Message-State: AOAM530pZoRYO+JTOcjkthqifnuqy6KBQXv0gfpL7yvHm8PByi7WqwR3
        ncEmj8ojruv93wnT3t28/bXrrxJ9NxGXYw==
X-Google-Smtp-Source: ABdhPJwYVZi/SxQzTjGnoLoBUHwr0ZF6Iczqbe2lmM+C1+pIQlhCD4tQSkhWRReXMCe2Gqf9nxlm1A==
X-Received: by 2002:a05:6638:2711:: with SMTP id m17mr12635791jav.115.1616773930510;
        Fri, 26 Mar 2021 08:52:10 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
Date:   Fri, 26 Mar 2021 09:51:22 -0600
Message-Id: <20210326155128.1057078-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 15b2219facadec583c24523eed40fa45865f859f.

Before IO threads accepted signals, the freezer using take signals to wake
up an IO thread would cause them to loop without any way to clear the
pending signal. That is no longer the case, so stop special casing
PF_IO_WORKER in the freezer.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/freezer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 1a2d57d1327c..dc520f01f99d 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
 		return false;
 	}
 
-	if (!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))
+	if (!(p->flags & PF_KTHREAD))
 		fake_signal_wake_up(p);
 	else
 		wake_up_state(p, TASK_INTERRUPTIBLE);
-- 
2.31.0

