Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5526622CBAF
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 19:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGXRJ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 13:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXRJ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 13:09:26 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD2C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a1so7504881edt.10
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+1tVdkUbI4Vv/xtQmAn8sNuvJ+ETR0DF95iD9AK08eE=;
        b=E+nf1ijl0nNVjO0sjY3D8m2g9BMkBpSoRf1kmfK1Ey6Br15Tp6oSr6jaIgBC6h8Sae
         w7IvUJ5x98O48cu9uY9yb7Twxv379nHiaFRs8arfEELx8fQx+WlMmS0+em45Uf7fiqhC
         WxJXM49YPawbFyFXCom3yEuDTXceKW6tvDEWCeTvR/3hKPuiLcobtohtEExPN5rTrpER
         MOUfbtRPBBTLjuzy7BVFO7OtBrZymxyXOj8ubIi3YD3ndn0cuAsTLeBrU/6aGMw0yuIE
         zS+tODt4BhBgMz63aKcbQsnE2NgVbLp9S+Tmo9GxmeJymxCrKomijOHqDnh5og0XxcT0
         UjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+1tVdkUbI4Vv/xtQmAn8sNuvJ+ETR0DF95iD9AK08eE=;
        b=Q4EEBbedt103djWUopghEC5c6CBeaVPAwoqRXt1fwXWoBNnpmpo44MqkTWY9wPBmJG
         EAcVcG5QOPR2Jvw9KSGdzYO3sAg2CyJn0IYm78Q2nAWCWQdyFdTitXhfwSX1SHvtD4CM
         Xcq3B1DkZax++ADtGXMaUdo7LiKioIRfoYi6i+mi06PdJkqh/QE164hk6gztmmC9qMlq
         MrYJKnKabDBpcUvhV+zjpjMEWuj9wHbZJIX77+MKuVqN4YyoY08avrRJBW11BIC68UWv
         oytm6fv+et3rtr2QGGRnvAUQVSb6fasvazW0GKMTYy6qwIFJqo8WrSHG4c+OCgqvBBO3
         kFFg==
X-Gm-Message-State: AOAM531LmIxCpis6zxmXhdo/cg+L36amLvwFYUDfAHVREy2FpFcKhzCb
        lfDWmJdpXvvBTlyTlfl8x9M=
X-Google-Smtp-Source: ABdhPJwGouIgJpLpVDUbn7nrujd8tCGtpDugZ6IWq5WK+eO2NwerCA814tItDQSFNsetY0uMmpbv1g==
X-Received: by 2002:a50:c402:: with SMTP id v2mr7492533edf.166.1595610565206;
        Fri, 24 Jul 2020 10:09:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id b14sm1007832ejg.18.2020.07.24.10.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:09:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix lockup in io_fail_links()
Date:   Fri, 24 Jul 2020 20:07:21 +0300
Message-Id: <83e0a9c08acce807764b6f86a31660963ee2e367.1595610422.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595610422.git.asml.silence@gmail.com>
References: <cover.1595610422.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fail_links() doesn't consider REQ_F_COMP_LOCKED leading to nested
spin_lock(completion_lock) and lockup.

[  197.680409] rcu: INFO: rcu_preempt detected expedited stalls on
	CPUs/tasks: { 6-... } 18239 jiffies s: 1421 root: 0x40/.
[  197.680411] rcu: blocking rcu_node structures:
[  197.680412] Task dump for CPU 6:
[  197.680413] link-timeout    R  running task        0  1669
	1 0x8000008a
[  197.680414] Call Trace:
[  197.680420]  ? io_req_find_next+0xa0/0x200
[  197.680422]  ? io_put_req_find_next+0x2a/0x50
[  197.680423]  ? io_poll_task_func+0xcf/0x140
[  197.680425]  ? task_work_run+0x67/0xa0
[  197.680426]  ? do_exit+0x35d/0xb70
[  197.680429]  ? syscall_trace_enter+0x187/0x2c0
[  197.680430]  ? do_group_exit+0x43/0xa0
[  197.680448]  ? __x64_sys_exit_group+0x18/0x20
[  197.680450]  ? do_syscall_64+0x52/0xa0
[  197.680452]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98e8079e67e7..493e5047e67c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4199,10 +4199,9 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	io_put_req_find_next(req, nxt);
 	io_cqring_ev_posted(ctx);
 }
 
-- 
2.24.0

