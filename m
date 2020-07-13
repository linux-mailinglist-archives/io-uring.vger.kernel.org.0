Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4F21E18E
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGMUj2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUj1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:27 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCE9C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:27 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so18899040ejd.13
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=t9JLQxw5UNGBTelWqZZfzX+U4IzQOeUYDDEp9c25LLg=;
        b=CykDNZu2sd9kzV+J4NZBauIybtohaAUy70IwKYDDzJX4wxVve6yMTfSvEb5xLIYMMl
         hHCEhBFuHlsMSebh44yR+RGbU5D1wKdbkBeLG1muuIDDiS7pqwLYuhUdDaEEeyc9wNiw
         s/ANeyrOoEjXBm7jl8jJWSpRaxiNuswNgK137md5+BQj9BoXNhs1I/js9uFDM6MBl8q3
         OVLgDMEf/J7udWZ9+zx1qj3fe/TYm0n1WbREAwa6I7gnjvK4BhsjC7XgwvrDRnd0j00c
         rDr31iAY5varQwt4NcSIIrBqzQVjDV1J0Vze/tTicT1P9kkLXe+XfRbAT88wwtH5AKNR
         IVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9JLQxw5UNGBTelWqZZfzX+U4IzQOeUYDDEp9c25LLg=;
        b=ZeazrUdM3VwQMqYrwXzkpYo2/CjlVuhoHvxQ3qYgX9do/jsts4jWcjOOluuhuXk183
         L0ACTuSSnGzIf+vuJxaQTlYCaXws1kFWGI6Gs7wBzN9NGGaAkNFa0bNVt6jdf7pEJ3dd
         y5B6JoVqv9+HTmaDzfNDK74jh83DYH6GuXE53ngPgQKYzs/XaygRh3QuN+LDQBKPptvw
         WUURxStTsB51tzPN4OU8G0ugK7mYhVtdxK2n9wGf9EtxHpr3lSLPJwbRp5B5mhloCyw5
         1bnkTzuhf+YGNxCEn3PoANoxaRvbp0yd/anF6gel8cd3P/9XGr+yZDOA6DduuQReLK/F
         s8yQ==
X-Gm-Message-State: AOAM532RFdl4pj72DMQ18vCsOjaHp/a3mrKU7VqS75rL6wO7NlvdocPk
        EHqCvBo2mVwRJG5Iv0GBDcY=
X-Google-Smtp-Source: ABdhPJweWjmZphL2EB00vI5TT7D3Dl5NDLluMMWHVi2w2tukeNf+q2tWq01oOCs+5/Ja4TB0quNZMg==
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr1378070eji.547.1594672766262;
        Mon, 13 Jul 2020 13:39:26 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 6/9] io_uring: remove init for unused list
Date:   Mon, 13 Jul 2020 23:37:13 +0300
Message-Id: <6babb24d7b53798474f45838ac8e26a9a49688a4.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

poll*() doesn't use req->list, don't init it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b9bd2002db98..b789edbe4339 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4947,7 +4947,6 @@ static int io_poll_add(struct io_kiocb *req)
 	__poll_t mask;
 
 	INIT_HLIST_NODE(&req->hash_node);
-	INIT_LIST_HEAD(&req->list);
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
-- 
2.24.0

