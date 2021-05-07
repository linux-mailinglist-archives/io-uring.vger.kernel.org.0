Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64159376B09
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhEGUHz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 16:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhEGUHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 16:07:55 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3172AC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 13:06:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h4so10402814wrt.12
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 13:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1geqpU2/fPa7V/1vbFToVK25NfEWCKOUkga7LS3PbA=;
        b=Na17MT5pyhBSDBGaPe6qyuJbIHcXpWzo6qKuF0jYtOyYAYLJVaD+W6wSAR4pV7D68C
         YqfeHOeh5eS4IKCXBab6bW9LHkNC0BAeYjaWpb5mG0Q0QtvBCxMvzRkW3/uSfWKu/72g
         mAgbIX82YvoKJ6I+ek20FE9V1eeAkjtO101HKyvaC/jbGVCt19AfMruyUrTvMvL7bLCv
         clwERp0mUYdhCMTdYuDHvg3QWPujNQHxh73rfVdjhM7e9EoqsaiHyJC8ma/bjxE1G2Nx
         23thSUPvBs3l6Is06e/g8pplaskJ2VjBQArgOAB1TLRWA0+sDFt562RPHiKhH1lcZQg6
         cTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1geqpU2/fPa7V/1vbFToVK25NfEWCKOUkga7LS3PbA=;
        b=JwJwDcB7mFm2BOq7px/NkEOdZjbtVrrHUK2wGd1qe/HbyGfhMIL6nMq2Ej2o+ziIr+
         KiTNk2QWxlMIAUac4E4sY0pidDoDu832ZcyFqb4/GZTNUoAz7IiuuNNAusQ+pX6J37Rh
         0BFmicBrFFL2DBZSkPMWElZMyEWi93mED5Xx228e8aPaFHVzdTANjIuWJPZiFRKuT4be
         +1F2u4LDXKTIACrYp3LL3nxAIO3HbxfFZ0s0TN1V3sEDHU5MAq5D21yu2vG//mXIU7Oc
         92OZ9kbUDhOQXDJiprVlIKf8nNdfAP1KvZQDmGoa71Iyub3aE3cj7FjzxkLHEfjCar48
         eVvA==
X-Gm-Message-State: AOAM530cRdPEMOyd8bqvmOnrUsevUTE07IxaYmNlS6/5mKnk3/f82oq8
        1LRYxmZr6hcY1lFl8DOhp1E=
X-Google-Smtp-Source: ABdhPJwlQjkjSrX24ytbZVciK7mxYjFkjNX9VzJUxzu0Dqx/3+4QWdn+48QRjIOPNfZsi+kkjxKsLA==
X-Received: by 2002:a05:6000:504:: with SMTP id a4mr14821378wrf.51.1620418012902;
        Fri, 07 May 2021 13:06:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id o17sm9125645wrs.48.2021.05.07.13.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 13:06:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix link timeout refs
Date:   Fri,  7 May 2021 21:06:38 +0100
Message-Id: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182

io_link_timeout_fn() should put only one reference of the linked timeout
request, however in case of racing with the master request's completion
first io_req_complete() puts one and then io_put_req_deferred() is
called.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

P.s. wasn't able to trigger

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f46acbbeed57..9ac5e278a91e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6363,10 +6363,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
+		io_put_req_deferred(req, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.31.1

