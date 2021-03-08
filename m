Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEE3314F4
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 18:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHRfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCHRe4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 12:34:56 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F17C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 09:34:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo4313372wmq.4
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 09:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABwLDpKCVU9SwqZWw/xLeaTpSVHqSeaWUiKEPCRg8B8=;
        b=REqV1N8UMwj7cMqB87J24IL5itRZlz9dbRtYPwpQ/A5u8wgwMGNPw0bHiABsIvPwl4
         rAERDhOHmDMaJenxJ8fXDfVWvnpPNLBY89/bCuU6xrZdYXdcmZ0o4dK5XVhr33ckh4BV
         4064CzQV4Ul41rZ7/nw1mqhRw4G1Gwp6hlSV1NherqXttiVQos0p2IondN5jAEj7uOae
         UL6knRD1rC4KuLAnQRmcrofcmFWqqrIDDvJza8uYWiMec4ruS5uHVDCcjzhUGZ/AIOfG
         m+fhS+k5Bt53LGnLOtiq9DXyyJ2XtoEseRQ/3lmpZY1Y+Rnl2HiLww8c2Ghn365nFYtS
         Uzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ABwLDpKCVU9SwqZWw/xLeaTpSVHqSeaWUiKEPCRg8B8=;
        b=PaWP0FW2wwH6gTX/CEqZ6jK8EeY/QIN1IHXYwu/Pb/B2wYerlJ0oIpUI+W2fWyPxbh
         8qe814o42tZ19DXDBXbBl9b6Zc9a28t1iFG8lT2ZCRYl36pjGuVRdpiD+CmPhGz4aPNx
         nRY+Z8NPPKrlwnfgshkVG40zYCSf4K0kwbX4ky6XDqD7yeWtlaJWZ72XrSu8pR1MFlq+
         CBpiXzu/V/qrLkJErZpYSEer6k2TGNNp9JmAjm3XlDLqPOIEDUv+YkPretVwQvrJuj27
         KWB1NewO406iNgC8sH6xrsI1D6s0/ZpEHvfql76da5SpKrlsapiGkm0omdh9mbbo5DO4
         KASg==
X-Gm-Message-State: AOAM530CHsNpebH48+aubDTuxW2i16gvHKfYW+iDEVqVnLN6WWumYTvl
        EXloq8Kbq1k/3TSBJOrfDllGd/uc3UJ/rQ==
X-Google-Smtp-Source: ABdhPJxQ+9mydLu1HGSv2S44kDEo3zklUIBmuAjuXQ+ALQgBIkRqp+wn5b572KrKDvfGTXtSzYYvmQ==
X-Received: by 2002:a1c:7c14:: with SMTP id x20mr22103493wmc.17.1615224894894;
        Mon, 08 Mar 2021 09:34:54 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id y10sm19466589wrl.19.2021.03.08.09.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 09:34:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: fix io_sq_offload_create error handling
Date:   Mon,  8 Mar 2021 17:30:54 +0000
Message-Id: <fd95d5cfe8fd8dada11ed009678fc2304d5d3f64.1615224628.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't set IO_SQ_THREAD_SHOULD_STOP when io_sq_offload_create() has
failed on io_uring_alloc_task_context() but leave everything to
io_sq_thread_finish(), because currently io_sq_thread_finish()
hangs on trying to park it. That's great it stalls there, because
otherwise the following io_sq_thread_stop() would be skipped on
IO_SQ_THREAD_SHOULD_STOP check and the sqo would race for sqd with
freeing ctx.

A simple error injection gives something like this.

[  245.463955] INFO: task sqpoll-test-hang:523 blocked for more than 122 seconds.
[  245.463983] Call Trace:
[  245.463990]  __schedule+0x36b/0x950
[  245.464005]  schedule+0x68/0xe0
[  245.464013]  schedule_timeout+0x209/0x2a0
[  245.464032]  wait_for_completion+0x8b/0xf0
[  245.464043]  io_sq_thread_finish+0x44/0x1a0
[  245.464049]  io_uring_setup+0x9ea/0xc80
[  245.464058]  __x64_sys_io_uring_setup+0x16/0x20
[  245.464064]  do_syscall_64+0x38/0x50
[  245.464073]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5505e19f1391..5ca3c70e6640 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7860,10 +7860,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ret = PTR_ERR(tsk);
 			goto err;
 		}
-		ret = io_uring_alloc_task_context(tsk, ctx);
-		if (ret)
-			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+
 		sqd->thread = tsk;
+		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
-- 
2.24.0

