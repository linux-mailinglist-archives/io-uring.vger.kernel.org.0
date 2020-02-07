Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E35155786
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 13:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgBGMSe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 07:18:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726901AbgBGMSe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 07:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581077913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pxrUa6yYHA3zJIHAlCPUQ/AE6W3gc0p6oLCPdoOC3gQ=;
        b=LBThMkc5zW7kLnBnoI/xm1SgULQvcJASU7GC+UHZDFi8M7I/P6qwxZj3B+vtbn5GGrcRy3
        /uryysOvXa8wdHWYzdxr0i3r2txgzQJ5nEIilswm3Qo7T5/VUGoB2u2ea1esg5T/qtzgmc
        NU74H+Fdma7zhUSklJM5413FysmUE1Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-m-Mwet10Nv6oWg--vU_FBQ-1; Fri, 07 Feb 2020 07:18:31 -0500
X-MC-Unique: m-Mwet10Nv6oWg--vU_FBQ-1
Received: by mail-wr1-f70.google.com with SMTP id u8so1164793wrp.10
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 04:18:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pxrUa6yYHA3zJIHAlCPUQ/AE6W3gc0p6oLCPdoOC3gQ=;
        b=lgGBKBXsrfv0o/4hSl7vLhPKBMFOt2VCje6J+hA2jHCAjY2xcYNy/Ci5/UMyLuYRNn
         3DCWW2cAonAPSmVouxWMsMv+aT4OD7ZMiuJ9TsZ4ZpSuBJW5qtX98OHf4TmiuAuXKnhf
         f5HSx414A702NxRJtJmabYs+d2PPQ/TdU/O+GGJHuFhL2wffiH0owPsxoVHZQmeTzX9d
         TbOfBwmFihvYUDUCWi5icUB7xFdOj7cS6px94zP6Y+qhjpq8zIYEkDzucK9N+NyqYMe4
         7xbPxmdHcFlsfQJBjFgtnzywomvJ11/21v3xTN0rRaaW1oji9QDaqql9UzYFIjMknxwU
         sH+w==
X-Gm-Message-State: APjAAAUB+axbgCELTGjvxq8oBoE83xtgq7d/gEUW4exS/5t3xh2EC7aq
        KdgeBoPPQV16tb2/b+8yjQLgaEtaIwYb0Ebyk5/KeYPLvzf/V4OYlqstxRzt9K50MHUQdsTadoB
        sq22Qcj6uCAo8uAa/tCI=
X-Received: by 2002:a1c:a796:: with SMTP id q144mr4298676wme.6.1581077910044;
        Fri, 07 Feb 2020 04:18:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzKEXxdDxWJyfAf+c8pu5kIy5L1/FnZRZqZlI9Kr7rf2JhF89b17yHm9fzoIeVW9ACTo+FORQ==
X-Received: by 2002:a1c:a796:: with SMTP id q144mr4298656wme.6.1581077909819;
        Fri, 07 Feb 2020 04:18:29 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id 4sm3103789wmg.22.2020.02.07.04.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 04:18:29 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org
Subject: [PATCH] io_uring: flush overflowed CQ events in the io_uring_poll()
Date:   Fri,  7 Feb 2020 13:18:28 +0100
Message-Id: <20200207121828.105456-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_uring_poll() we must flush overflowed CQ events before to
check if there are CQ events available, to avoid missing events.

We call the io_cqring_events() that checks and flushes any overflow
and returns the number of CQ events available.

We can avoid taking the 'uring_lock' since the flush is already
protected by 'completion_lock'.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77f22c3da30f..02e77e86abaf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
 	    ctx->rings->sq_ring_entries)
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
+	if (io_cqring_events(ctx, false))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
-- 
2.24.1

