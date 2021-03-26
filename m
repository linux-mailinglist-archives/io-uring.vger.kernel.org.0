Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08A349E28
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhCZAlT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCZAkw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31926C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:52 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so2318840pga.11
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=MfWye79Yf8JWfCDBBSFadlq1VPdjANsXJAzdqkMvdiVSDZCz9cXBj2JkqY1WSaF1Ll
         GFkmQZbdvIMTar7P5/42xpyj7r4DVGVw6T62NuYIg25IkGyAiOqAcC2XDngdeSz/HAQw
         mpxTed8upnVFPUuDX/zAH/tujDhzrUSkgK8mEmdhjlA919CzoIs3nJ1oERKTnJZzPcbI
         MUHpbunHjin+H13LdXiKTesoqaQewfoMp9HBY67SLK0wo4MWJiDNSRyymPqMJO5QrTm/
         hI945ZIrVEtQrMfcD2aHatE1AK5mZbOtHt70XwutTxBytslCr6PmK6LG3yX5N3Gy/sNP
         +dfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=jghxAfHEBqk7YffY/2vJ8WD2rvBxEnDrjsc2cv2aSzWrYwb/9PNJ1ddAQUknD/ZPwr
         tESjOsWBbPv9baRbHmHxSDeT3/nv28GfZR14/mIyy797NqP4As8qI4FnN+LMdbDxxeQq
         xl02LPRgh6K2wubgKxKvq81wJpzKCGlI6UYTtntiPo8nd+Ee4/7VHt2VzTazvEl1MfnC
         Hh/Ts4qGIB+YrhCJT6141crAyB8I/O9KT4ah17+QY4sz+8CQCUbVLAsKZUezeIztAxoz
         LWpfF+rjYQj83jHTDn/o47GDqigWWmuKtnXCpbxciTJ0rN9ePXx6Ix+BgywzIGydVMfu
         M9Xg==
X-Gm-Message-State: AOAM532pLirrv/MZaR3Rir/QdzEgzC9PWy5MSQjtpEo5AFc+tX8cWCGN
        b0U1XXmqSXuv+LcxwkjGw4sKV70f/NDHLA==
X-Google-Smtp-Source: ABdhPJwY3NU6GsrSvtT2o7cvfU5oDMdkRCWF/omROwCnq0eok2ylfvU+FVNQNvKEIGXmHJoAfYbEIA==
X-Received: by 2002:a63:e42:: with SMTP id 2mr9886459pgo.100.1616719251568;
        Thu, 25 Mar 2021 17:40:51 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
Date:   Thu, 25 Mar 2021 18:39:28 -0600
Message-Id: <20210326003928.978750-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
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

