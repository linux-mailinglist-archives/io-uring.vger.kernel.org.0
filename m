Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F8552DCC1
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiESS2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 14:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243893AbiESS2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 14:28:30 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8130DFF46
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 11:28:22 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id o190so6612937iof.10
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 11:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=ND7f0vx9pZeDMhgR5d9yPNpUzi34XU/+i7olrPBQCuY=;
        b=YV/qjkXoecsS2oe33P2wBJVytQp5MTWs64Kic5Q17lfWu1L9Ak2YJdLZ4P4iuiad9K
         COZ9O9ZvugCVGcREEHB0hxB9z3MAuj8zBelSYydaU8xvHymcbQ1ApvBKgSBQsOlLECp0
         LYV+rwYq1hkXaaEcaV8VSICXBFJu5tSmpai+xnirfZDpxVIzdK3jJqPAKQ/E3Tw9ggAR
         gTnZUFQ2xP7XxJWZzk3rG1QNNhxPxCtifvpPdxDKQSp/N9TD497gJv6/8ryHh8wAlkOd
         j2HUGsAoaXnlzXFdWDuKLeu5u86cfsLci1M/EILpIz6ABcmTVZ58cg4Y6ousQOO8+45E
         OtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ND7f0vx9pZeDMhgR5d9yPNpUzi34XU/+i7olrPBQCuY=;
        b=PaQ9p7+8Ch0mvnEhSibGFUOuzKWrP90p+QIklsvHGDEQEBZXc3MksYFAYQFPNNge6q
         AAR976b65Nx8XLTMFzBkhdkRqebW+fSwd83Czxpn2qNyZmepEzFJ9wt1P0kSyE3EhSZV
         9v15F5thlk3w/kfjOE2uvfcBWjXvOJt3PRnB5mmQdHswtZUEhYEXXjHJDR2e3Sr4a5xS
         DLcng0JTMpoZWs5zTuGsfe1igpIkqql9VMpE33UiGZthGJL2JC0DxotQRV8QgoaWMS5A
         Tm/ptlOzqStDiYuYwsCTsNB/x5iAVINtmakAOnOYuwwu6bWULyHJi4Eb43RIiRvRGS87
         BttQ==
X-Gm-Message-State: AOAM531fCGSLU4/AmjF/0mLMZl5M0SwmB1xOfbLtOo3CILQs4EnVX/RY
        i/eISf8lA/Am9l70bntt1N/UcQ==
X-Google-Smtp-Source: ABdhPJwyRboO1Ja53YC/vxYKpauz0w2zyTeorZnthVC36rGlGpNJwpzh4MC7zHK+OQbTjKDzNmiRGA==
X-Received: by 2002:a05:6638:d87:b0:32b:abdf:5867 with SMTP id l7-20020a0566380d8700b0032babdf5867mr3348125jaj.216.1652984901976;
        Thu, 19 May 2022 11:28:21 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s15-20020a92cb0f000000b002cd7dc16ae4sm1481072ilo.1.2022.05.19.11.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:28:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     hch@infradead.org, Vasily Averin <vasily.averin@linux.dev>
Cc:     rostedt@goodmis.org, kernel@openvz.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        mingo@redhat.com, asml.silence@gmail.com
In-Reply-To: <6f009241-a63f-ae43-a04b-62841aaef293@openvz.org>
References: <2eb22fb3-40cc-48f6-8ba9-5faeae0b43ff@kernel.dk> <6f009241-a63f-ae43-a04b-62841aaef293@openvz.org>
Subject: Re: [PATCH v3] io_uring: fix incorrect __kernel_rwf_t cast
Message-Id: <165298490113.98310.14692453666034246336.b4-ty@kernel.dk>
Date:   Thu, 19 May 2022 12:28:21 -0600
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

On Thu, 19 May 2022 17:30:49 +0300, Vasily Averin wrote:
> Currently 'make C=1 fs/io_uring.o' generates sparse warning:
> 
>   CHECK   fs/io_uring.c
> fs/io_uring.c: note: in included file (through
> include/trace/trace_events.h, include/trace/define_trace.h, i
> nclude/trace/events/io_uring.h):
> ./include/trace/events/io_uring.h:488:1:
>  warning: incorrect type in assignment (different base types)
>     expected unsigned int [usertype] op_flags
>     got restricted __kernel_rwf_t const [usertype] rw_flags
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix incorrect __kernel_rwf_t cast
      commit: 0e7579ca732a39cc377e17509dda9bfc4f6ba78e

Best regards,
-- 
Jens Axboe


