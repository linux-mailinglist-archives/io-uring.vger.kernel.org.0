Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8837122CBAE
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 19:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgGXRJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 13:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXRJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 13:09:25 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E40C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:25 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so10681617eje.7
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=B6ovgEohgc4xgj6slWmwGKqbciBRxQ9cN8N04j7lZtA=;
        b=M2DvTWJcQCTb2m/R6RVdGH5UkgOLgHxSVuD57nX3AhN+gKYVdLMIbIE/YIfG5S+z7C
         8u6YliGbqcAk0lSIF8Fie/vSJJFjJrOLy3apr7hYxr1QJ6LBxlRP4swRvZgAosowtMIb
         2CZEpx55gqwlzZbwmsNCYURZ+3GfehnYGIrZyO5Lvlkz1zVXZU9hJTjsmimWQ6L/n2IS
         3mlGuFva8HANz11VRl2dl2yU+3QXPlT0PQV7gteJnD7AEzVPoih/OY+avpkeW9xPfB6N
         kZIFlCzQ+BCXhe9pRDru4onylEaW7Jq3tNZWINifmPD5cm7UeI57HW1vfs0URIqg7/1M
         t2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6ovgEohgc4xgj6slWmwGKqbciBRxQ9cN8N04j7lZtA=;
        b=f4Y9AErUtHd1y5+onYuhYuZvanZ+OkgNgMLZ7sBuMRnz3EZnoELpbY1fD1oL4is2WD
         22abLX8ImcJcUZ4fSeMvV01g3+PI+rNm4R4WHTmGYcVs2Z+/qtMtWqU7rxxuQm8e0fZx
         Tntk46ABNvLuMGROFOso8/cu+j6iNgaiJ6hzLKEMlu9HoaFg9wPHy874KydFH9CAAYCE
         Jiu6N33RIhFpHKkFXy+WLAqsElo3sz9sgMBtK9tOcz9WVvE8SF//XNmFAse6T/6lMQUv
         SNrSF4L5Whfvh2DjirsuMa8iDUJmOiPuSxZeUk06c6IEL+pEniflRDwHWNoPNVHRoCR/
         ewuQ==
X-Gm-Message-State: AOAM531pQyC5piomTetKiDx9eLoGmZDibnKug6OcRyPD+FzNpnPEQQq5
        D55cZ9c7lyW/G5EaCD9nm8g=
X-Google-Smtp-Source: ABdhPJxvhoc0PShYfjhDENDf6cc7ulpiIoh2cbvsojrlRZqPnfFpoku6c3DQgsdLf/ckVC5g6ZDlGg==
X-Received: by 2002:a17:906:743:: with SMTP id z3mr10066875ejb.216.1595610563793;
        Fri, 24 Jul 2020 10:09:23 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id b14sm1007832ejg.18.2020.07.24.10.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:09:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix ->work corruption with poll_add
Date:   Fri, 24 Jul 2020 20:07:20 +0300
Message-Id: <3aad8261c564462b78b96d79ff23b7ac2e253b41.1595610422.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595610422.git.asml.silence@gmail.com>
References: <cover.1595610422.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->work might be already initialised by the time it gets into
__io_arm_poll_handler(), which will corrupt it be using fields that are
in an union with req->work. Luckily, the only side effect is missing
put_creds(). Clean req->work before going there.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32b0064f806e..98e8079e67e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4658,6 +4658,10 @@ static int io_poll_add(struct io_kiocb *req)
 	struct io_poll_table ipt;
 	__poll_t mask;
 
+	/* ->work is in union with hash_node and others */
+	io_req_work_drop_env(req);
+	req->flags &= ~REQ_F_WORK_INITIALIZED;
+
 	INIT_HLIST_NODE(&req->hash_node);
 	INIT_LIST_HEAD(&req->list);
 	ipt.pt._qproc = io_poll_queue_proc;
-- 
2.24.0

