Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E0536172C
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 03:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhDPBZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 21:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbhDPBZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 21:25:54 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A5EC061756
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e2so8794079plh.8
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O3m4i9LogWmsFWpLJgi7xq+/eMzdhar0Uygxg/85lL8=;
        b=YB7bZVwkzM3G5cV563pvfqB7ixHnnQXXVrL4ZtPEVsfEmTQJX/BwjnA85Fw3gyeh/u
         KU3Y0oTyfcClt/p2ahXJI19b0woKahjLHn17HWUVwGqhZaFSBzbln4+k+Ke5hYuphJnj
         KzPiY2NFSwgWixBHtaM4I2z2CC3Sf/VC1bGZeR9KUXGCJXHcVhGfgWj5HWLAz4L7+Rop
         eooiHED5ceVcow0EYaavbNOetLPHb1CXFWQ3PBJScVSWe4hbaWKLtBdlh9tkgKOHvrCa
         4VdJwPbqx/04D+rWcJkKoBS/sjfVVwi4oDiWoQqg1G1mQfMWH2JbAuJihd6y0ysQu2Ku
         2Dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O3m4i9LogWmsFWpLJgi7xq+/eMzdhar0Uygxg/85lL8=;
        b=XxFu0IaOsjUhxQZgE8WHnn6AJHHkovqkhOxVlyX90c3GbUjPcqhwWEEZADENwbJ47c
         BtTIys5hTzF7bgQoHquCtNf9jas5Gsov7GLhyn4ltH9psL9qjhEz3kX8HBqwpAkwYuYx
         Dvcx97yQAkeEBCrWlHEODFyEjG2eJJL9iYdrAuKHQ5ZL/NMD58Ob7AczkGybutDMQRi8
         tMhofIFf4L4i0ZwhA2zz1IdyxTwoNZHszyix9DC3wXptr4vElFOCmZNPlIit6gEjpN5X
         QATtxJliGe4m1KhaxXsS+gAar1viOSE5w7LtDjs/9tMY+13kUai9C76X7IlRAIUbN45Q
         AhnA==
X-Gm-Message-State: AOAM530SDGF3xkEegJ9UHybqrHSQ+evfzYnoV4zhwiUIS8i2I6V807q2
        Ogy7KFS2QlcqkDkwueubumjPQUFw24EkGg==
X-Google-Smtp-Source: ABdhPJwoOZ/wPX47yltO/3JOgiM8ObOte5PXXWYdYABKUlYNO19cvlV2kV5IhyQySTZIc8Tho/lAvg==
X-Received: by 2002:a17:90b:4c0a:: with SMTP id na10mr7144353pjb.227.1618536328467;
        Thu, 15 Apr 2021 18:25:28 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm3502039pji.40.2021.04.15.18.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 18:25:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: disable multishot poll for double poll add cases
Date:   Thu, 15 Apr 2021 19:25:21 -0600
Message-Id: <20210416012523.724073-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416012523.724073-1-axboe@kernel.dk>
References: <20210416012523.724073-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The re-add handling isn't correct for the multi wait case, so let's
just disable it for now explicitly until we can get that sorted out.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab14692b05b4..87ce3dbcd4ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4976,6 +4976,11 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -EINVAL;
 			return;
 		}
+		/* don't allow double poll use cases with multishot */
+		if (!(req->poll.events & EPOLLONESHOT)) {
+			pt->error = -EINVAL;
+			return;
+		}
 		/* double add on the same waitqueue head, ignore */
 		if (poll->head == head)
 			return;
-- 
2.31.1

