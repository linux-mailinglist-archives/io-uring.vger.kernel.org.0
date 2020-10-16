Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC50E290918
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410534AbgJPQCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410466AbgJPQCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE69C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l18so1725360pgg.0
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oPKUWrhjBeYp8XpcYm9g24r/CleAtGv0U5icmbNhl84=;
        b=e76NmWdi7DQ3tML99cn3hMq6E3O/atims8CLC2ipR17RD9rjFn4usB8uak9FNun2+C
         hUDi+YURRGjFZ3fw8Jj4vO+O1vV6BOahOPNGhFb9P1kyElS7N7U5iqgmGLO77yFbDQUz
         wiP+AvbfGKZ6Ci8mtnTPdoKqKXbkdE4qC4bHcZ57l1NX9CLVJ/svZTjyE+9To4o90tjt
         +BYRCKihKgkGOYHMkELRp5+ZoUM5zl6GuSpWbd42ILBYSz31UOi/A+V0ZVGJ1Dh9Zf4N
         KQS/zjeEuNg9OAZsNIqiqcVzzj7sq+o1dR/VXFVDQ4gS39MZXeBPQmcYJm2zek73NzLG
         newQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPKUWrhjBeYp8XpcYm9g24r/CleAtGv0U5icmbNhl84=;
        b=FNY3c4K+Z5jXb4g1XdJh6CwII6gF9nqqMg5k3Y7rFIR+C/2mRICc3V6pDV2C1ufvow
         K6ff1NsRlDqLLaUYSIaNUVjmRYZEjrNuJ+KhV8G9MAuAFhm3uyL0p4xq7KbGPBKl3wfV
         0wlcY7hN/OyAJCr1RYsvIRgZlpRTo3OG2FGWuX3nTsWjvCTvozsTEkm+6Rnnmmgx0ASa
         PZOuvIiUPwYBCpW59SnBvkrInRG2T5AObNczhr+43Kqpn52Io01ak1TAkSvcQzEJptUQ
         DoZUN56QUpoTHxU2SSfnp8ZfbCaE/NnHP12gdPDT/fY5ORSdzsK76g7CDvYj/DZJMaAG
         rqOg==
X-Gm-Message-State: AOAM531+ICfcZdYcm49Q9rNhyYj/Lipi4T3LO5cDoT2QkI0DjbOGNZ+6
        eSy0YLYisi236HPTEvTf+ly1bnclqdwImtkh
X-Google-Smtp-Source: ABdhPJyOrmXsyox9gYDDMSKShYjDsz6sssr+y1e98Q7l4gQScCwkx1lQ/3kQinp7BK5GU8qoUnLZRg==
X-Received: by 2002:a62:7d4d:0:b029:152:1b09:f34 with SMTP id y74-20020a627d4d0000b02901521b090f34mr4527596pfc.76.1602864155109;
        Fri, 16 Oct 2020 09:02:35 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/18] io_uring: don't unnecessarily clear F_LINK_TIMEOUT
Date:   Fri, 16 Oct 2020 10:02:11 -0600
Message-Id: <20201016160224.1575329-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

If a request had REQ_F_LINK_TIMEOUT it would've been cleared in
__io_kill_linked_timeout() by the time of __io_fail_links(), so no need
to care about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c95e6d62b00b..60b58aa44e60 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1852,7 +1852,6 @@ static void __io_fail_links(struct io_kiocb *req)
 		io_cqring_fill_event(link, -ECANCELED);
 		link->flags |= REQ_F_COMP_LOCKED;
 		__io_double_put_req(link);
-		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
 
 	io_commit_cqring(ctx);
-- 
2.28.0

