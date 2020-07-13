Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1B21E117
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgGMUB0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGMUB0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:01:26 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB76C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:26 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d16so14816114edz.12
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0vWNLkf68BcGgvQRNS2gnqp3b1IAfvYU0+0/It5xqQI=;
        b=jEvDV0FRb1RaOGPnBzAbKJ/v5Op5WwogMOFSLQ9CMTPSYZPRQ2eZQ5UeC2eyasonAO
         4Q10AG+4mD031duhxNO0VAClHmvJFMeBk5FBZ/2PGpbSh+wuSuaBSz+ieaFoebWZOtwB
         3fmAzhzVIsQf1/h3AmHoMwE4bTQAjiWg+Erfn+akk6o5RbMKBqVZuZusNh2xKhJ8oYn7
         1PfN5Ujz8Uwg2YIvCKZ6L2ZzEb/2TR1hnbUpX+XBeMlz4PzAy6VmHEfGsY7sdSMbUNQe
         JUNK2zyU8u+uNi4Qjyl8KBqhDIAt33hv5zwJtynUnDGI8FVvCfQEO2aqpc0u5X9AMbjx
         vk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vWNLkf68BcGgvQRNS2gnqp3b1IAfvYU0+0/It5xqQI=;
        b=QVLzaIJV0qxJ3zqJCauLPMcB5vywH4Ji59vulIAwBDyaPCxwN3m71y54JzEuC6yNkX
         uP4LuGMSuNwWct0LalfrCDWvwErEeXroxILnNdVpcs2Ia0ikh7DXZX5d6cMtTXnAz+nj
         JCh7aGrqQUduowBw/Iji4+4iOZeXj/QTEyjW9BFSryhqmRqdC9XU9m01PQ/9HaDpOWt+
         xVNk7LG3Qd8kXHXks+s26ulBbjG+sZCNkXp8Na7hR2hGgTcr58yef8jRdhDgH1mt9dSq
         ZMDdf6QhHJJXum+EJ3Y82JvKjQhu4x3und8smEVNKZND6inyEBcjGA/vmmo/bntDqZ/u
         X+iA==
X-Gm-Message-State: AOAM5316S6Y++SF1Uy1y/p+MZEhmpzssoI/r6BtZ1tEYY0zFZ2lYnL8T
        9JQmYbNcAM1HQi/HEPHl/qOsUtvb
X-Google-Smtp-Source: ABdhPJzkaX1jB17QsN5/ifKkcklKN8TdJCVlLoJxquBkPe6iOwReAEEKQ9WsBq29eE68uuHl1w7qOw==
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr1007226edx.182.1594670485048;
        Mon, 13 Jul 2020 13:01:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm10520408ejp.51.2020.07.13.13.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:01:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: follow **iovec idiom in io_import_iovec
Date:   Mon, 13 Jul 2020 22:59:20 +0300
Message-Id: <49c2ae6de356110544826092b5d08cb1927940ce.1594669730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594669730.git.asml.silence@gmail.com>
References: <cover.1594669730.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As for import_iovec(), return !=NULL iovec from io_import_iovec() only
when it should be freed, that includes returning NULL when iovec is
already in req->io, because it shoulb be deallocated by other means,
e.g. inside op handler. After io_setup_async_rw() local iovec to ->io,
just mark it NULL, to follow the idea in io_{read,write} as well.

That's easier to follow, and especially useful if we want to reuse
per-op space for completion data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 217dbb6563e7..0b9c0333d8c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2739,10 +2739,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (req->io) {
 		struct io_async_rw *iorw = &req->io->rw;
 
-		*iovec = iorw->iov;
-		iov_iter_init(iter, rw, *iovec, iorw->nr_segs, iorw->size);
-		if (iorw->iov == iorw->fast_iov)
-			*iovec = NULL;
+		iov_iter_init(iter, rw, iorw->iov, iorw->nr_segs, iorw->size);
+		*iovec = NULL;
 		return iorw->size;
 	}
 
@@ -3025,6 +3023,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
+			/* it's copied and will be cleaned with ->io */
+			iovec = NULL;
 			/* if we can retry, do so with the callbacks armed */
 			if (io_rw_should_retry(req)) {
 				ret2 = io_iter_do_read(req, &iter);
@@ -3040,8 +3040,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		}
 	}
 out_free:
-	if (!(req->flags & REQ_F_NEED_CLEANUP))
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -3142,12 +3141,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
+			/* it's copied and will be cleaned with ->io */
+			iovec = NULL;
 			return -EAGAIN;
 		}
 	}
 out_free:
-	if (!(req->flags & REQ_F_NEED_CLEANUP))
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
-- 
2.24.0

