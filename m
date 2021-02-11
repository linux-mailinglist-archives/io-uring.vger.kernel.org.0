Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA575318DB9
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 15:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBKOyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 09:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhBKOtQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 09:49:16 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DBC061788
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 06:48:32 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id o15so4290330ilt.6
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 06:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4iXUIW2VXqPMi8hZcm5kKautQwHDx7xjji2xkUMoQ50=;
        b=ZTOCExYX6KB6yQjudJCANQMb+TQ8f411bnrORmErFbT/GxUC6KLbIkTBQUZQoiI8Fy
         Uoq+GaOeNaHQ0iyIalyaM4jtERRa2a30K6SacE/XaFmCVtU9UiXty8TyXQ0l4zAI00pX
         M8SiuSfXKulL+du6VGGLNOqmLyr5h2XECKVtmzFh+BSbv4CQ3hPf95R1+44A6ea3hFMs
         JDutfQ3j0Fo+LarZJcVoaurAXZiwbMEorSijeAxXT72Ezc+HBTlmYNMDkF21d51RsqMg
         nS+JsD2oSU7sjMteTPW63UsllNLNplVcQcE9j1bTxafJtbn7xFg2kM/O5YzpsuGYyR1z
         1MYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4iXUIW2VXqPMi8hZcm5kKautQwHDx7xjji2xkUMoQ50=;
        b=bmRKGk20XZn7Ub3ZoxPilVZmtF8E6ZIHIMPjtoQWXuvFQEMTHyvDyPzoZ9sTrsSsUu
         1p7ClkA54iXUtyE9g0B/gAZIkDWQVsRSAY9qqPyQ0w43e7Vr6syImawcJyzDuz+tRbtL
         ecl3xNyR3j5PW4xnOp386LCsP3aNvZQKXd68vvSUZsmZc4o8A2K2rAfh8NXeP4erOrsj
         Zx/uZAlmssVFbIqEe9DdP4kzdIR17XzSQwT3extNA6T49vNBG5j4e1K8aYEBlO/kkCOT
         EAp1Ui1HZQBz9MP5fXtOgxTmWeOXDywFo9WclmaoVr1Eb5YLmgzLCEo4sFA/c/+AAHKN
         UYDg==
X-Gm-Message-State: AOAM533/Xo3e9jRkEZCqOeJ5dXcxIUo/knaNZZihILqVFh4UB383ut5r
        9LV0sg02jJxhdb67nY+8/oNhHLB8NcVDITPh
X-Google-Smtp-Source: ABdhPJw3dHzt2+mxfsw1buGIPhMySDr5rgp+By4B6nQLbBZb+SbOrjaW0ve8ayw9PWck/1I3AYGj+A==
X-Received: by 2002:a05:6e02:1c0b:: with SMTP id l11mr5772815ilh.187.1613054910202;
        Thu, 11 Feb 2021 06:48:30 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g6sm2694396ilf.3.2021.02.11.06.48.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 06:48:29 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: assign file_slot prior to calling
 io_sqe_file_register()
Message-ID: <78296772-9b33-0ad7-d0d7-ccc0304dbb20@kernel.dk>
Date:   Thu, 11 Feb 2021 07:48:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use the assigned slot in io_sqe_file_register(), and a previous
patch moved the assignment to after we have called it. This isn't
super pretty, and will get cleaned up in the future. For now, fix
the regression by restoring the previous assignment/clear of the
file_slot.

Fixes: ea64ec02b31d ("io_uring: deduplicate file table slot calculation")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f730af32c17a..cd9c4c05f6f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8112,12 +8112,13 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
+			*file_slot = file;
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
+				*file_slot = NULL;
 				fput(file);
 				break;
 			}
-			*file_slot = file;
 		}
 	}
 
-- 
Jens Axboe

