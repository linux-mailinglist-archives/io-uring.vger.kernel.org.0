Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893F53F603F
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhHXOZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 10:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbhHXOZg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 10:25:36 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D939C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:24:52 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id f6so19020523iox.0
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K/gA9xQFNjycJb7Nn/wzF2LvkOEqDPoBYiecCC9OS2U=;
        b=eOjrXh2XWWdKoGmoDD6AaJ/RW3XU9w2ozsnrIHMLPuTO2BwBHEuRBKmBx1LyweiVJ3
         3y+zZwa3D+QHU+e0Leqwn4knyKNGYPZEHZEmqBxLW/OlIKnIOO7lmg5mOH5POxvlwIvF
         0hDEYxPMvvk5/bIpkEiVPnRbODukZO6ndb/JKeJsAplDspyLMaMDKkGDXZbi1+FADDt0
         53E0Xw4jJ+SrsxrF1pQbmJEHnX2fMXTt5Jsrzv+vE8o5AoARKujQCS4Bh3YIe61cYZXx
         Z4gg8RX0nJm3LSWqO46DxhW94bzRzFFClJGKITDl982DaiMBpWKm+OIlnJYcDVPVcNiK
         HcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K/gA9xQFNjycJb7Nn/wzF2LvkOEqDPoBYiecCC9OS2U=;
        b=OndtJvUmr0K94vz08jSBY+/SxzJHOLT2T2rpUzxwOmY8I/20qz7DOecg4LSY5PFUYh
         wOOEiv3KGuvTdC/cSSLJx4ezGzlEBnWLpMGcP7FUbrWWpZ90iAFJzjtOIcF1WU5yJ4Ym
         CJhywCCroD9FUoHziU9YaDFYpQYUxTaUl6QnMyQ4VA12qV0NO3LuAxj5un9j4oY64BCJ
         6EC/zlsk6Oj/yDnJWNOLJifkJ3L2SPmdGpMlawtErNUAOClWI9lEdWcAhw9POL4aG82Z
         YKktGWOahWRpYFf70YHyodPrln7lJ92s4ozCFjL1Y7y1oROqvhYryiUS1RY1IK7KKeDc
         vQBA==
X-Gm-Message-State: AOAM530z/MTxxFWmwpYqhCk6+8CUi6vVybQxuGUlDCqdpmYajzZY3duK
        P2y1Py9X1D/4rM3mjygaHbFvJwwIcCl2SQ==
X-Google-Smtp-Source: ABdhPJza2lJ0OLmpZLoQokXnkNEYiwmy8fqmul+yJls9QAVbm+ju5TPPlXZXT/gafxca1dJC1rxjWA==
X-Received: by 2002:a5d:8d1a:: with SMTP id p26mr32238958ioj.178.1629815091687;
        Tue, 24 Aug 2021 07:24:51 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u13sm10029577iot.29.2021.08.24.07.24.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:24:51 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH -next] io_uring: remove IORING_MAX_FIXED_FILES
Message-ID: <9d5c0024-9397-766f-c7e2-fde3aa92cf88@kernel.dk>
Date:   Tue, 24 Aug 2021 08:24:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we now just use max open files to guard the size of the fixed
file table, it doesn't make any sense to impose further limits on
the max table size.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53eb75cda745..054e13643ba6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -93,7 +93,6 @@
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
 /* only define max */
-#define IORING_MAX_FIXED_FILES	(1U << 15)
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
@@ -8036,8 +8035,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EBUSY;
 	if (!nr_args)
 		return -EINVAL;
-	if (nr_args > IORING_MAX_FIXED_FILES)
-		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
 	ret = io_rsrc_node_switch_start(ctx);

-- 
Jens Axboe

