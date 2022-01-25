Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58049ACBF
	for <lists+io-uring@lfdr.de>; Tue, 25 Jan 2022 07:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349278AbiAYGx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jan 2022 01:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376458AbiAYGuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jan 2022 01:50:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19DEC06C587
        for <io-uring@vger.kernel.org>; Mon, 24 Jan 2022 21:17:58 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a4-20020a17090a70c400b001b21d9c8bc8so721696pjm.7
        for <io-uring@vger.kernel.org>; Mon, 24 Jan 2022 21:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ocy1f8e8l5tnDktp3A5HwcgpUMQpU1wPRyfhdTDw5M8=;
        b=VeHwN5GkQbTg4xXyCkEkUwiJWbtdR+uqWnLLC+h4ovZG0cDZTJcvgJIH2cBuR1bq/z
         k+hrJ7P+DlciIwsI/fEaKDEwZan3zTiRMxn5AE3MW2Kqp8OauhOn/pkI0mA1UjkWnTFm
         diE1GSsMVdImczBIfjkOnOLAiUiVdFxrWlAMOgJprfvVLmsaVyZD8LBDJp/J6+QWxfFA
         EEAqgOVm7jfqtvD5PS8JkwyHDco7E32xgfm85lhcGhUajCeP4FVyE64zuCKLKG7TytbE
         pYakrcdz72KFPOKsz1d3RJsonbFJVmLkvYDsdmqW4rNRDr20wfwybVVPUZsZUKe4TUfd
         gSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ocy1f8e8l5tnDktp3A5HwcgpUMQpU1wPRyfhdTDw5M8=;
        b=Ego7f2VElHA137ghPO+qrY1Xo7aQa9NX8VnOnDyqJ/u071ZjlMDBt+VW+m8NIVkgut
         XvTJgNKQ5t/5YAYHfPy5mG7gOx+B8U1hlrBAnY+VEwrKEyFl/DzUC8JTnHeeyQWGYS31
         BBnKp0mnDclHu0su/6bJD7Q+au1WhzWs0fIRDSiqDlBr2W1Rr/5vwaEMOQZVyNttwW71
         Q7oKwP5MxdAz1CWLCSkOA0x30XNSl370YkOplPPlLsDVYFF9JygO5HH9WeGBwD8uALpg
         SiRSNVFT/TqyX6zc/mEkCyzXWuRVBSNC57l1Q2GR0tIkaPzKOJgfoujUP68+SX6RTLpR
         pggA==
X-Gm-Message-State: AOAM532CxLDaXozSZjbzIC9lPu0/ZTYq4MSLHYqsy6uY4BrlfoHQ1A/E
        816WqAZKRTqO2YPnYlP7/q5vOeQvAABmJA==
X-Google-Smtp-Source: ABdhPJxe8AfKsCPhuglY9hr0mXjNrX0aldbMm31sCb7LADfE3npZOHRYWdmErVF1V2X6jR/3AHWfOJIeO4t9vQ==
X-Received: from shakeelb.svl.corp.google.com ([2620:15c:2cd:202:276f:dcd0:a2cf:ec4c])
 (user=shakeelb job=sendgmr) by 2002:a17:902:ab82:b0:14a:188a:cd1f with SMTP
 id f2-20020a170902ab8200b0014a188acd1fmr17395057plr.44.1643087878415; Mon, 24
 Jan 2022 21:17:58 -0800 (PST)
Date:   Mon, 24 Jan 2022 21:17:36 -0800
Message-Id: <20220125051736.2981459-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
From:   Shakeel Butt <shakeelb@google.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On an overcommitted system which is running multiple workloads of
varying priorities, it is preferred to trigger an oom-killer to kill a
low priority workload than to let the high priority workload receiving
ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
ENOMEMs instead of oom-kills because io_uring_setup callchain is using
__GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
allow the oom-killer to kill a lower priority job.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e54c4127422e..d9eeb202363c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8928,10 +8928,9 @@ static void io_mem_free(void *ptr)
 
 static void *io_mem_alloc(size_t size)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
-				__GFP_NORETRY | __GFP_ACCOUNT;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 
-	return (void *) __get_free_pages(gfp_flags, get_order(size));
+	return (void *) __get_free_pages(gfp, get_order(size));
 }
 
 static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
-- 
2.35.0.rc0.227.g00780c9af4-goog

