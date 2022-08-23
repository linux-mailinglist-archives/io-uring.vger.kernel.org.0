Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A9159E84E
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245701AbiHWQ7W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbiHWQ6p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 12:58:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D0D148D36
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:30:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo17217315pjd.3
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=yF5+dYKBU6/4lRvxr1wWHug6uDsrIoBvHUiDQ9KN0sc=;
        b=4m4xoqRENdvVcEoTLkvlxnqT0MkDmoAMBP2aL/mtYVuuytoONX+B6zDLu3kFXyFNjZ
         YQGSGUXjotMr8ZxRykNeeNeVkC3NkrO5JeTx0F2ROxAZiFrYhuvIK14PNuOr0idk51Ow
         rVwe3qTfsSku9y1/PVzEHmjkkDxoX6BTFEsxJbiBFPhDCZrChP/jtF/OVOZzRIx5mXfp
         /PbC0YQDesdy+drd8eNw+1TdsutscLUF9DYIIHgM/bHH6XKtvRHVy1ukx/UMbuZuyiog
         lAkYd0vjEsO4Qq7xbXm0QZbrM4DoIuU79czAAJoSpkOhbGcS3y4trzNZCLBEim2nnLGX
         52+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=yF5+dYKBU6/4lRvxr1wWHug6uDsrIoBvHUiDQ9KN0sc=;
        b=yi02BrgTsNpG2OgEMKVCGzKyKvf/a1MQilYUP2114mFPOZ9C6Sp8u/RVrkQetpIrLS
         H+BqiJAQcxYTEmg3bPxxFTJ7x2Fpt8cuan6DMuPbLE+H382w5iCw9DcLtR+eOFToOIo+
         iQdzq5F7v/sHDoCl5PXwr+fjaQ50JRbDtc/L2Klnye9UR8lf2N0Zn1cZ7aWVLT5a1OgJ
         K1omH+y6PEghuu54MlbRLdyUp18LtjvR2SJhRIq7B0My9o67jhAMe3o7mei/ifmO9kDl
         yGoF7BqmT8D6J+pC6OlzhcRxz4Bd76jjA43/uURwti9IYQJzwrKuwq3HfM6DgvzGE2Jf
         06Zw==
X-Gm-Message-State: ACgBeo2cSR98uYMV+5i6yHHMcCCFhoWEnEdxAqNnK3aYYP8zknL8KDyW
        QJ8FazZa3rd7o1JCyRysF3Xfw0v2vfVRKw==
X-Google-Smtp-Source: AA6agR7l+omYTZds48ZXq+vI/zhMaVeTD0fkVBCp61V49sWitHpqeJ60UJLyqygmN4AQy3o9QchG1g==
X-Received: by 2002:a17:902:f64d:b0:172:d004:8b2d with SMTP id m13-20020a170902f64d00b00172d0048b2dmr15850918plg.14.1661261399350;
        Tue, 23 Aug 2022 06:29:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c138-20020a624e90000000b00528a097aeffsm10767912pfb.118.2022.08.23.06.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:29:57 -0700 (PDT)
Message-ID: <b8d73db7-f25c-5651-6dae-4f087f45fd22@kernel.dk>
Date:   Tue, 23 Aug 2022 07:29:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Luo Likang <luolikang@nsfocus.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix off-by-one in sync cancelation file check
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The passed in index should be validated against the number of registered
files we have, it needs to be smaller than the index value to avoid going
one beyond the end.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Reported-by: Luo Likang <luolikang@nsfocus.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index e4e1dc0325f0..5fc5d3e80fcb 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -218,7 +218,7 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
 		unsigned long file_ptr;
 
-		if (unlikely(fd > ctx->nr_user_files))
+		if (unlikely(fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
 		file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;

-- 
Jens Axboe
