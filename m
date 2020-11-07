Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D853B2AA550
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 14:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgKGNXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 08:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNXu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 08:23:50 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3747EC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 05:23:50 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 23so4104198wrc.8
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 05:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkpdlXcGYEaNRjptIir5cDfMmyzwZZ+QBhcyxaBw5j0=;
        b=uIVDo3oO9kcLEf6bglgurbDGjEb1CL5yatnAEDbClOgPic1KWa8AWtMCD2/0b4z1ZW
         eBgabd376EXvfWdpm3fgVnBRkNvtS+B7cW1vdP+EAMtsJpYpFHykEU8JXhIRYsO2OV33
         WpqnRRwkUo+rrSHAT3waTib8jLwHAUexPK4wRMkk57VKtYCKQnnHEmRwKVysoB1SsZct
         cFKgkAPacl6wySOUGx+Pa5lhy6x4J68JO7aaglqJ75C4aA5EZQNAXtYntk77uzdBYv6w
         SfsvEqzlDFEWrMoPk0VkDINeh1eVzL2v8itZutj+wLCLKj5NaDYHKDW4s++YQcUEZ6vz
         rtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkpdlXcGYEaNRjptIir5cDfMmyzwZZ+QBhcyxaBw5j0=;
        b=X0Biv3kP5wutwlMPG29e/4IBEyYAx8Tn0mTMrryZOkmVAc6fK5ZmUN65lBHFiVWwdm
         nubdTFsM+YW0XQ23yYSPtQ9qZn61LdlPjAZ/HW+pHleJlOAowr0cCTWC7a9voJ+Nbnv4
         q4m21Z8KHEMM/5ytT0NlJ5At7KvOhYpuwp2+0xRG/NsdMp/8QQd0C9shdoSA3Ps5Y3y9
         GpFlcLC4uqFaFbgDj9xW0moSq+U0c9LTwUBxXiYvLX3GN/uP91DRW4W0F09RcEIcEXAP
         TEUX5Q5jBskHDisCbK7KCXHnjHzjcy9/LNdjR23tGx3LHmVPOO5GEW8P4RxNEsCxqFGx
         W6Sw==
X-Gm-Message-State: AOAM533NFrF4ofV+65dVWtExQqktAMh+Rhe7kzQmd6Pyqheb3OgR81iv
        cq/ZvJ20zMhKKbE2zDBJktE=
X-Google-Smtp-Source: ABdhPJweL/rvwW0ayw26LdFJ10SkZr4UPjPDiK5tVDSfCIQ4e0Wc9ImloSRt0kn7q965fuE/88J4CA==
X-Received: by 2002:adf:ee92:: with SMTP id b18mr3741054wro.104.1604755428851;
        Sat, 07 Nov 2020 05:23:48 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id n4sm6408739wmi.32.2020.11.07.05.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:23:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.11] io_uring: don't take fs for recvmsg/sendmsg
Date:   Sat,  7 Nov 2020 13:20:39 +0000
Message-Id: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't even allow not plain data msg_control, which is disallowed in
__sys_{send,revb}msg_sock(). So no need in fs for IORING_OP_SENDMSG and
IORING_OP_RECVMSG. fs->lock is less contanged not as much as before, but
there are cases that can be, e.g. IOSQE_ASYNC.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e435b336927..8d721a652d61 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -849,8 +849,7 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FS,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_RECVMSG] = {
 		.needs_file		= 1,
@@ -859,8 +858,7 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
-						IO_WQ_WORK_FS,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.needs_async_data	= 1,
-- 
2.24.0

