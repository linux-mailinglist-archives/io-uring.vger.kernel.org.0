Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3222D71D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGYLoB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 07:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 07:44:01 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F9CC0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:01 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b13so6416433edz.7
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+mUdVTOQqqZWTRP93e5A5127kw4WzI5DtHj8g1uiJ8E=;
        b=mCB7WXOy1wHcBc7ju9hIWp6d/oCI3wE2lRTgXItGAyJjK/afhj9ZIrePtKB2qS1/MM
         S0sL3VwWDMSBzGiEbgyxAVzFZSpjFdvtxfcWyImVdJHv5NNsrBubj3/HKTbrWnT4etUX
         Huw7zyCSe/DQEdY3vJ4AadCj1iAtPPhT68b3VntLeEWb9aGN8qMmuvwPoKfjmZReUwHM
         LVmX+82j1DDg+ALPRsSDnd000a2woAjoaY8XitIOyXDdj5Sv24Vtu6JYJtrHspKqOYq/
         B0dmadOsLsztR5hJNpAcZZ2R+X0WU4GiAHxuW26YS6LjrtwGyZKiUgsJ6vsDyPSSIfc/
         hJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+mUdVTOQqqZWTRP93e5A5127kw4WzI5DtHj8g1uiJ8E=;
        b=ZnUyaCSNfaA6PTF48fTv/BuQE7aFods7LRuz15mjX9bbyixLve3NXCHNt3hyRUTtlW
         LrOx/zIyRhpVdzOnliVhcKTJu0igHOs+YvdT5snngSH/o+7zJwcWtNekbn4eKne7s2WQ
         eTe97Gle6hGtIapn2j50zQHa5vItBy0HHYNt0HTAvvM/Q998MYqa3DmS+Te3aTsP0An0
         eKPC/QrhOyQnzlLXUaIaWdJBrbDaKvIR5LkcfiGZFzzf3vErQgmBJCGUyori0lLlwZ4L
         4EBouq6P+j/jKXuPSC5B1gIEOcnl3XqUlIkyLUQ7oD7lR6sCe3QdLHkb6kn7D/EnQrh4
         kReQ==
X-Gm-Message-State: AOAM533435Ip6PEO2GPHSVj/9dvk1PqyoR7WqO7628qJ7UVg9qfilnBz
        3f97QY2iVyx7INwYEP30AQM=
X-Google-Smtp-Source: ABdhPJwpAQohUcUM28Mv8v2YWW8oUv7BK9tLN2/xfWAauwtWDJv+GJnpsFPwSCiNSzyhbRGQYbaGXQ==
X-Received: by 2002:a05:6402:1687:: with SMTP id a7mr12798372edv.358.1595677439833;
        Sat, 25 Jul 2020 04:43:59 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id i7sm2743601eds.91.2020.07.25.04.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:43:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: mark ->work uninitialised after cleanup
Date:   Sat, 25 Jul 2020 14:41:58 +0300
Message-Id: <95fc105c8a8cb7d04ae552ff8dd92e5d782e81b4.1595677308.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595677308.git.asml.silence@gmail.com>
References: <cover.1595677308.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove REQ_F_WORK_INITIALIZED after io_req_clean_work(). That's a cold
path but is safer for those using io_req_clean_work() out of
*dismantle_req()/*io_free(). And for the same reason zero work.fs

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7e8e9a1b27b..59f1f473ffc7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1141,7 +1141,9 @@ static void io_req_clean_work(struct io_kiocb *req)
 		spin_unlock(&req->work.fs->lock);
 		if (fs)
 			free_fs_struct(fs);
+		req->work.fs = NULL;
 	}
+	req->flags &= ~REQ_F_WORK_INITIALIZED;
 }
 
 static void io_prep_async_work(struct io_kiocb *req)
@@ -4969,7 +4971,6 @@ static int io_poll_add(struct io_kiocb *req)
 
 	/* ->work is in union with hash_node and others */
 	io_req_clean_work(req);
-	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	ipt.pt._qproc = io_poll_queue_proc;
-- 
2.24.0

