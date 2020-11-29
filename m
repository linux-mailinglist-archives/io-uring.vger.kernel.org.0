Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23432C76F4
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgK2Au3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK2Au0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:26 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BB3C0617A7;
        Sat, 28 Nov 2020 16:50:01 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t21so7391894pgl.3;
        Sat, 28 Nov 2020 16:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pLO/Dm5aFg8h/isH2BDIjhNLAvIImEOy4o6l0iht6RI=;
        b=Uq3Na5959zjHT7zlMKGk03UxrU8zJxP7eRY742Q33BmNMujMif/ZsQnVVaWeZE8I0B
         TUUMUVhsGOUUj1IGJAY+A/VqbT330oGghAQqZbr8EQMFzkYwpGBecRM4VkBfAKEVNY/D
         50xUF4uQxyWN0SG+snoLEuPHMi/X9IEthoWmsLGlC4stOdIh+Z+natl07aqHeaDinAsE
         K5nkqAOIB+SPkEIpZgkC1B7573INdvewtxEmAsrPOEmqxtjD22S9S1X1VnL67PFle+ei
         CY8lCbvTZ223ZsuxSU/4XsGE3qjZZY30qHZ/yg9AscOe6JQQjzdjjhKOIgFBj2fR17cM
         gjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLO/Dm5aFg8h/isH2BDIjhNLAvIImEOy4o6l0iht6RI=;
        b=iNVMfBowZOLhi/Dt+snrtAPPa8gYmYUhVB3UyJ1yRSaXzgUiImIniVA8D40s9RqInF
         om1rsPfNlZk6DEfThioc68h1vx/255faGVF9syUwZL0ZpZ30ZA6jCEjKm9w8RM9XvqLL
         doe9IC38s6xipeUX0Kg7lJN2nHoTHmuQ3w9/U8BdVHAWYARp3+ldkgcS/hfn7Y8hvaK4
         9TcEid6nLO06Yrw/0/Xt+FsEOtNjzEtAM/XQhDHg60WPuLvqGIYHBmzKWXIITqwjD1f/
         Te4qATtRPCLSoNkRZkyd9MpKWHRCjJrn5x07d/Whl9o5mdOkRXUeQ5YT6SfOu8dXCN+J
         GgwA==
X-Gm-Message-State: AOAM532DJZ5ewagMJrY0ujV24+YDNuGXCQtJZeC61A1Lf4y5PsSR8s4c
        Bi0kw3VZiHKSaqCEP0+/otMdPcwU26gSNQ==
X-Google-Smtp-Source: ABdhPJxaY9DxLDKGnkGFs9A9oqkbO/fjTGIBVHcLBTu9hXYx/XXtNjBNR1mCzr6//0a7w+5LsYbWMw==
X-Received: by 2002:a63:eb4b:: with SMTP id b11mr12181060pgk.351.1606611000280;
        Sat, 28 Nov 2020 16:50:00 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:49:59 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 04/13] fs/userfaultfd: simplify locks in userfaultfd_ctx_read
Date:   Sat, 28 Nov 2020 16:45:39 -0800
Message-Id: <20201129004548.1619714-5-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Small refactoring to reduce the number of locations in which locks are
released in userfaultfd_ctx_read(), as this makes the understanding of
the code and its changes harder.

No functional change intended.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4fe07c1a44c6..fedf7c1615d5 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1039,6 +1039,7 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock(&ctx->fault_pending_wqh.lock);
 		uwq = find_userfault(ctx);
+		ret = -EAGAIN;
 		if (uwq) {
 			/*
 			 * Use a seqcount to repeat the lockless check
@@ -1077,11 +1078,11 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 
 			/* careful to always initialize msg if ret == 0 */
 			*msg = uwq->msg;
-			spin_unlock(&ctx->fault_pending_wqh.lock);
 			ret = 0;
-			break;
 		}
 		spin_unlock(&ctx->fault_pending_wqh.lock);
+		if (!ret)
+			break;
 
 		spin_lock(&ctx->event_wqh.lock);
 		uwq = find_userfault_evt(ctx);
@@ -1099,17 +1100,14 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 				 * reference on it.
 				 */
 				userfaultfd_ctx_get(fork_nctx);
-				spin_unlock(&ctx->event_wqh.lock);
-				ret = 0;
-				break;
+			} else {
+				userfaultfd_event_complete(ctx, uwq);
 			}
-
-			userfaultfd_event_complete(ctx, uwq);
-			spin_unlock(&ctx->event_wqh.lock);
 			ret = 0;
-			break;
 		}
 		spin_unlock(&ctx->event_wqh.lock);
+		if (!ret)
+			break;
 
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
-- 
2.25.1

