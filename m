Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD834ABEB
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCZPwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhCZPwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:09 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC98C0613B4
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:09 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id 19so5431599ilj.2
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=n7oHJNJCUAxOzOa/CGB3u4Q7UE5CWm5TKevwGbzL3PRl8+GI6vh0c4qFK6r6FNlPm3
         ylHkElPhL0Xh++BcEfdRjU0EJa/IvxICaOUe/yWv7GojHTTqNv8bIZL7XEBPbBOfSWp+
         zQoBfYMqj62OtPnmh2UF+XJBfBnOeAguzP46pdRk7g/GmFcIXSCA8tmdW/Jp1wWGAOQq
         BvjCc6fIIjh0epHDbR2byBUoASCGIr3loqA+yqcBmEYsJX+RLdfCbRjOVJOnnN0bEZl+
         EFZAZw/QDIWEkqzUK1k20yY0WfL0X2Lg6pCFE+B8tzG1u3W2ixxnvkqkWpyE3gbjm7kb
         OVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=li3YfRJpVv71xu0WVsVssRzCMBArHCH1EvW6QYE1yT0=;
        b=oB7ixYfg+uuoFSmxXsYDN+tYBbrhvDOEPy08PoNWd/9aHvFPl5FDt47oWdYfA5UDBp
         eD4ZVeKCJwhjlzC/+6tLIVca9xsipFys5TgNMnr7kv8iycsxx30lccAKEr9P9yMNQdpt
         whQT78MVTIBVFTOjMpOk3T/x7olIIkpdfkm11HbtKaj3mZXT6EwjTQPDUczQNM69jfBL
         3o/Is35Jl9qrPwwfE0dX551AD/xBWInZJ2vQm59qzjNpMizGtzMy0t9ukiLvNDIEeatw
         r5OnQUQL8qlLiXD0Y8OjRlCJo1AvCaLJyfrIsHXmi5Jh7W14uahclfgbSo45r60J/hC/
         noKw==
X-Gm-Message-State: AOAM531uIliFr2lHl76u9neR6S4NS/MFG9Dat5QKvKgQTVlZoS4aroSL
        DaitGmbDixYEsp73NW1jXSubxpwt0NFudQ==
X-Google-Smtp-Source: ABdhPJwBwx8cRwQ7I43gdoBP66bssGfrR1P/zEt8f5ovURJegjRD93MoycFphMyp79wX/sfVZ5SbVg==
X-Received: by 2002:a05:6e02:219e:: with SMTP id j30mr10764366ila.196.1616773928942;
        Fri, 26 Mar 2021 08:52:08 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] Revert "kernel: freezer should treat PF_IO_WORKER like PF_KTHREAD for freezing"
Date:   Fri, 26 Mar 2021 09:51:20 -0600
Message-Id: <20210326155128.1057078-8-axboe@kernel.dk>
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

