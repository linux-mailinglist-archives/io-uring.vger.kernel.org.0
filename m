Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23B33A5B67
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhFNBkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:40:07 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:51768 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhFNBkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:40:06 -0400
Received: by mail-wm1-f45.google.com with SMTP id l9so11140874wms.1
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cdIZDc3JET6Wu7ha00xbZFE9xxbmmG8rXkmSyLd7DoA=;
        b=M7pFrl1OkRyAHNw+h4BkCn/b56awq4lOvg8GsheMRBT1sMYh4TZ+FSkQl4DXYYEl4t
         CQZw8H6YsbDqu2iD6uWL9+EoYF8sCq4z3fTtAYMpiaJf6/MqNv9NHre/Xals2d64cj6H
         7ZFPBhyoXgIW6co0b4FlRxO9aIzpbNkGMTkcMrJB52fR7n2m1FLycc+lOcRiytYrr4g6
         Cg7ImEEJDu6jBcs20OWhTLlGXkcvYfR0+mmIJZ/YzDak9UDcCuPKQ/tJe7KSEToeNr3D
         OJYYmQtneteJiLgRRhBLgY4kweozwUWjdj6rHbZRoPiDLKvi3jBXvHD/qCkVGy1l0QXA
         uhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cdIZDc3JET6Wu7ha00xbZFE9xxbmmG8rXkmSyLd7DoA=;
        b=luPHDOACjQdMx4/xgIZp5OF1ilJQ/c3w9Wgp0Ru7cciMkSxx+2xQIIzDsWch3XoUpf
         SJIIvJj5C4zbl1sGpYSPeqh4i6A4Jia3TZRKX7eLkpDFXUzfBEcDwGXZIYnnzR7Mfmn4
         Rlwzutgwbx5qqjiawTbIHrL5MVeOiECxk7QfJp6voNcG7SS7ZcYD//jEaXkv0jIGZR02
         mDBIAVAFF+o7mU2yOg44PJK//sJDEsqFV47B9M3xCQ95iwkRjFbQOHa0A2KBphZxHqyq
         xgnp9MehpcckWjykRbqqckmS7pL1ELtjzCGuENvIqYzmx5E5XH04Te32FekSo6F/yxXY
         n93A==
X-Gm-Message-State: AOAM533HuCOVBpVjoaVekGzEIBTDq/G6gnKts/j5KASywlj6Pf+TXjJv
        sH3/4U2wQEXi0qdCiDR4UPM=
X-Google-Smtp-Source: ABdhPJxkpMPHtkyRggJFVqoq4Q4EYf/1Q0k0yrAgFjpRdPDbJ+Fg63vSXkaVVP60PFTa9luelARY8w==
X-Received: by 2002:a7b:c346:: with SMTP id l6mr13484411wmj.109.1623634609969;
        Sun, 13 Jun 2021 18:36:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/13] io-wq: simplify worker exiting
Date:   Mon, 14 Jun 2021 02:36:17 +0100
Message-Id: <7521e485677f381036676943e876a0afecc23017.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_worker_handle_work() already takes care of the empty list case and
releases spinlock, so get rid of ugly conditional unlocking and
unconditionally call handle_work()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8c13e23d4a8a..2c37776c0280 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -565,10 +565,7 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		raw_spin_lock_irq(&wqe->lock);
-		if (!wq_list_empty(&wqe->work_list))
-			io_worker_handle_work(worker);
-		else
-			raw_spin_unlock_irq(&wqe->lock);
+		io_worker_handle_work(worker);
 	}
 
 	io_worker_exit(worker);
-- 
2.31.1

