Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F555AA1F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 14:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiFYMtE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 08:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiFYMtD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 08:49:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E84317A96
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:49:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so5224904pjv.3
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=HKleyuyrQhrb9JptKZ5qXsdqeoqftjUetNXNKwm786A=;
        b=ez/XgHvB6JuEESwkwz+X22aO8kx0w7jy5jmx9Dj9+QHigOa75rE8+rqm1OfhuYpgAo
         jX2qlI8av8w+BBnnIkomah3B28AQp6C7+gFdtg3RqoQzqYZ0ycHDEPyqEuVe5Ek3Bme/
         yKAHTB2mj2UVm45CXebVLUQHfL6awzn/h0HRRjY829vHf9IJHB1UbGq7/RH+/Oeckp4k
         YeF2MaA9X49JNqZrGvFtLHPH5DXj+3Oz5UGfIxOEtTWEWPhhOv7ukO0uiawN5Y08WmK8
         zsBtG7KLIf1tEiOQlriu1XrmiLrT+akcpi+SUbG5BYAc3NmHnMXWOpIdm4O/3tLilo3K
         0JRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=HKleyuyrQhrb9JptKZ5qXsdqeoqftjUetNXNKwm786A=;
        b=G26q/wRtTcD1qj8XYf6UEy0L4Sz+fZTRZYiwFU12LbIw5KhGXhbiFwjeRePwlIrVA4
         2eBcyVwdYNXOCjVOl51c4lq1Vzk13X/MGc4Zgf8SVe6QWQyM9cCQ4DpjyV5KLwzeOIon
         RYoVXQJ26o9jfalMct0OAkhB9cC9u0eeVdeGw5n4uhukAMGBcGKVwJFEyqGetlePFt/a
         OpKwKIGpIwj8FinLRLs1U9mMMfOZyuBjb7AefVIDETmo9mjn0fmptXYcZRzC1zU/lEyg
         vooqPkZYmnoXtmlz0A6T2YQsrbs4cCQ+2xEawIL/pf/BYFJZn9ffSuLoauLRBuAiZezV
         xiWw==
X-Gm-Message-State: AJIora9POnv7IE5tyGyRauqelZdLa/07zhvA4Q7pv1f4f8m8OG3bsk90
        Lmgw39MMWNpWfu/kD2mvMOHkeDLOItZWmQ==
X-Google-Smtp-Source: AGRyM1vGzTOIlhZiN2E1qgFSetjZPQUetLiI1B1Ra84O6JdZbcWhzoabNGa+wRhL/gnDySg2Fvng3A==
X-Received: by 2002:a17:90b:3804:b0:1ec:fe8d:8705 with SMTP id mq4-20020a17090b380400b001ecfe8d8705mr9667745pjb.103.1656161342766;
        Sat, 25 Jun 2022 05:49:02 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090311d000b001636c0b98a7sm3622057plh.226.2022.06.25.05.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 05:49:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/5] random 5.20 patches
Message-Id: <165616134213.54362.15436139962140796967.b4-ty@kernel.dk>
Date:   Sat, 25 Jun 2022 06:49:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 25 Jun 2022 11:52:57 +0100, Pavel Begunkov wrote:
> Just random patches here and there. The nicest one is 5/5, which removes
> ctx->refs pinning from io_uring_enter.
> 
> Pavel Begunkov (5):
>   io_uring: improve io_fail_links()
>   io_uring: fuse fallback_node and normal tw node
>   io_uring: remove extra TIF_NOTIFY_SIGNAL check
>   io_uring: don't check file ops of registered rings
>   io_uring: remove ctx->refs pinning on enter
> 
> [...]

Applied, thanks!

[1/5] io_uring: improve io_fail_links()
      commit: 149e51e72cc0d87b7eb452e928b29a906501981d
[2/5] io_uring: fuse fallback_node and normal tw node
      commit: aacc96447edf1ea1f057fb5dd3c53ee495e21487
[3/5] io_uring: remove extra TIF_NOTIFY_SIGNAL check
      commit: 8b5e7937ac521ff33c2bac66e3c1a0385ad7087e
[4/5] io_uring: don't check file ops of registered rings
      commit: 9c59698445f94fbdf208b3f50286e4fbfd295571
[5/5] io_uring: remove ctx->refs pinning on enter
      commit: e8584adba8863d531cb25233a650fdb9b50c2e2b

Best regards,
-- 
Jens Axboe


