Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AAA22D720
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 13:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgGYLoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLoE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 07:44:04 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A55C0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so12489402eje.7
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cEWPasNSNjSKGX3kzgKTDV+j34rMNoUQbN1nMwRJa80=;
        b=XtGzvfkVyU8LW5gtpXyV/FgA05vQpsFhEhjtqS0FieFeA9I9L/844vdGXJustNneju
         Du9cAMrQZu24SeIMmwyLd3PtR0hPm3nee8m2vseE7LxA/dlngPhd/WmKJH3PVQOUT564
         zkBqzo1tWlLAPCnQSj7SH5WQw07Zcw/QcN3Ye22z9bqJJHpX1Idyn+Ke9lxo0KnjXR+c
         XXPcuWc9CrQ95pGzmyiFnd+wyjfVLTImuEBH3qZ2p9IVix1d9ql6RbqX/KVkg3KdfElq
         +dbDQlHF2qH7G96qJNJd4ry//TO4QLDybOk8VIjgDafqdUaTtwgpbSuZ4pGPOrSTCW5X
         k4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEWPasNSNjSKGX3kzgKTDV+j34rMNoUQbN1nMwRJa80=;
        b=t9uB8G0ZF3ejg4V19PlNXqI6CwpFL6r9pLV5Ed5U2nt2ZGsj/E/oHnj3AefHYNyU7D
         F4tEyXiRR2d7slaZpz93ULTa/2wtIUSYco8GL/Jcb3sXMq4y1ax8+rTiJoz9YJQ+SsRK
         U3JU+uIr8jw+SX0A+CVRJHH258P+By0NKZGGnytovHzG78diktC38nlLSP22t5+OR/gs
         FJ6fFO88exCjg8M+UyeHCI0h2zfb61ok/Pxu0Wilsw21Qa6O3JZqiujzGGt9/CeCndy8
         2BoHJ3GrpcCNz6PVyPW5V9149I22cog1UeGIbCK1O4XK3mPGkfIIOPY6CWsJ6Dz5ElXg
         1cjQ==
X-Gm-Message-State: AOAM533ZYnWFcB5d0COJ8t9j9ggypyxCIHXklmXYYNeRuqgO0qJk5wgZ
        R+banv4zWFnusAyE2XJzzjPpCi4w
X-Google-Smtp-Source: ABdhPJyiuLsgrTeslk4ZJNI8L7gxNdpv0oAhuY78tMzon61OKvFsNkkK+4gmw5393C2UPrl2vj/oHw==
X-Received: by 2002:a17:906:1104:: with SMTP id h4mr4142313eja.456.1595677442773;
        Sat, 25 Jul 2020 04:44:02 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id i7sm2743601eds.91.2020.07.25.04.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:44:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: fix racy req->flags modification
Date:   Sat, 25 Jul 2020 14:42:01 +0300
Message-Id: <0db13b23d17709d5136e0f517c9fed3732f4a9bd.1595677308.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595677308.git.asml.silence@gmail.com>
References: <cover.1595677308.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Changing req->flags from any context other than where it's executed is
racy. io_uring_cancel_files() does that for overflowed requests.
Instead, keep track of already visited ones by initialising the overflow
list node.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e406bc1f855..8eec2c5fbc9e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7873,8 +7873,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		if (cancel_req->flags & REQ_F_OVERFLOW) {
 			spin_lock_irq(&ctx->completion_lock);
-			list_del(&cancel_req->compl.list);
-			cancel_req->flags &= ~REQ_F_OVERFLOW;
+
+			if (list_empty(&cancel_req->compl.list))
+				goto out_wait;
+			list_del_init(&cancel_req->compl.list);
+
 			if (list_empty(&ctx->cq_overflow_list)) {
 				clear_bit(0, &ctx->sq_check_overflow);
 				clear_bit(0, &ctx->cq_check_overflow);
@@ -7898,7 +7901,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 			io_put_req(cancel_req);
 		}
-
+out_wait:
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.24.0

