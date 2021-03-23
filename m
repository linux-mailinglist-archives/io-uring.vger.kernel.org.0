Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06932346148
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhCWOSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhCWORa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:30 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8C1C0613D9
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:26 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so10914509wmf.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1lgdxUViKuWWIDdG438HIIaVZgn63bsbSOyXiDdZOLw=;
        b=pnIozRJj7hXcR19UmWchyA2R+u9B6zF2fxCSYNRUqKc2J5z4+MCVQHrUbn9FwKJgW5
         4PieCv4WMIfSQ+WhCnXCrgY032ViGbkk3RTVihlAU6oFphx410wU7tH7PQZkQLKPA/Er
         dw9ZMDffFbIHEPIhMSydy9DGwCbUEPjaR5fXKDOo1jkF1LaTH+4Txv5p+ekUxv/zZxg9
         r0w2/wamz8JqdR0e5CfILDjaxj6RMWHXVmV578LDhX0hoW3Q/vHecHGVKKGgLnENINZI
         vaHWdcTWEYKR+ozz6GE9FaHZsd2cEjNxo2lWqc0FVrk6tktJ+tpFqUlsNDtfhElHeUwe
         5wvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1lgdxUViKuWWIDdG438HIIaVZgn63bsbSOyXiDdZOLw=;
        b=OIxjZB41AMedGSiMRpKpQL6qTGfVwvomOXH7F4vDXO2FOjbcyhD+Md9u7K3dfY3d4M
         oRj4bFxoeS4PA+K08XYjnrwD/5SUDM8iT7vB4PdEVvjGlSO8spijBHhgrw54NjwACgGj
         r1gaXO7ef/XxJW8Ver658FnZn+5dp/r5TuV750AhHIuhjfqwfBgMurLwZhYy5QvCHoiZ
         aOL1glv6axQtxreALdekli+J3+IDEamvqPd86p+WWeWUEk3iVWQ+UOgWJ5b2teY0s8DD
         MNxp/X/NFlIFh0DzY8yWLXD4DBlJ573FHe1Cx0XiVhFFhu3YsEVUIpw3nX0JH/0UiBu6
         Yp2w==
X-Gm-Message-State: AOAM532KOd5JH9GHJudJvvZtvDZK6DLeLT0uAMaVm6HR51oVPkZVfPgU
        VNfFspKpKMgKX5kminj3vMhhXo49JXPQlQ==
X-Google-Smtp-Source: ABdhPJw6uHbGHSBXkkRSrRGokqHHIoS1ERqeOG11WjR9dgy3CdH7J1RVt8es03pP/+r6Ez7DEm9IFA==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr3729090wmm.115.1616509045366;
        Tue, 23 Mar 2021 07:17:25 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/7] io_uring: simplify io_rsrc_node_ref_zero
Date:   Tue, 23 Mar 2021 14:13:12 +0000
Message-Id: <b589ce62c73cd9a65858ac8ce4e2e5846b43ec0e.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace queue_delayed_work() with mod_delayed_work() in
io_rsrc_node_ref_zero() as the later one can schedule a new work, and
cleanup it further for better readability.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ecb21ba0ca4..8c5fd7a8f31d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7448,7 +7448,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_rsrc_data *data = node->rsrc_data;
 	struct io_ring_ctx *ctx = data->ctx;
 	bool first_add = false;
-	int delay = HZ;
+	int delay;
 
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
@@ -7464,13 +7464,9 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	}
 	io_rsrc_ref_unlock(ctx);
 
-	if (percpu_ref_is_dying(&data->refs))
-		delay = 0;
-
-	if (!delay)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, 0);
-	else if (first_add)
-		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+	delay = percpu_ref_is_dying(&data->refs) ? 0 : HZ;
+	if (first_add || !delay)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-- 
2.24.0

