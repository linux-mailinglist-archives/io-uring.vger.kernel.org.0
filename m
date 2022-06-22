Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0312F554E1B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358969AbiFVO7j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 10:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358911AbiFVO7e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 10:59:34 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04993E0F2
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 07:59:17 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z191so442530iof.6
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 07:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=auzUxr6Hb7ROPxQ3X0Z+O3FU1RGv809EDqVn2ucNvE4=;
        b=elIUlcBPWwfyH+WrfyOe+litCGnQ/vWucltt7MhnhULOi9bG+1S1jdhcgahSxXCDnO
         H90gzkz54fPbTDno2MTdNO//AGl2qPGccpnfcgdi9JQD8TjfBLlU5WV87yBEJlPpsr9d
         j5zOS6r1vNGXaMGM8uZQcklORBe/C3yaPYLcb56mgH7I2jS/6IeW2NPUag9bwk1FcmzR
         8yCAwf607sK2IIlV3n8Oz9UKyyVgNS1e+4xRjAuFDDKT2i9yQ+201YJpNAN1kCrj/WkW
         CLoWW5WC0giyjIIxXSa27aK8AukhsMBCBQZw8nN1fDmwxUkB/RqCo7kZKDHwtknMlciF
         za8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=auzUxr6Hb7ROPxQ3X0Z+O3FU1RGv809EDqVn2ucNvE4=;
        b=03gQkc6QHirC3OG0OGLPRDNLZ8jT9bI9RhOlO44N7q20+qMaqDbBajdiuaEhSIBcGQ
         MFStUCgj7/3mJ5/T7aOZiBQ0WU/Z88GvewEL/aq2+neLVoC/NsOngO4+boDO7Rqmlxwy
         wFxbfNwTtZGUm8gGUSKl4UOpPNCCc4S8L6Iby33n/CAH2FNlZLuPINXT1ElKxMVU4VgY
         DvHlq8m3D+fc1Hdy6OfxJ4oye0tA3GlBYN4MZF2wS94BTtSQQccays8KAtO6fB4H282k
         3gL96KeQtIY02ha9oFqtpClROtQpschgD9i9l9cAZARTUggU8xLWOt1P1qvD0iOKoF9g
         EBVw==
X-Gm-Message-State: AJIora+r2gSyMGq7IXhaJVSA+TYLXq1T3xRawLpZc1qwwJBnDaMnKRDL
        gPUCjSl15wZWRjVdOQxdU4FXoZc9qMyRUA==
X-Google-Smtp-Source: AGRyM1tG0a7JDQXLm5FV/jWILWD9ysMA3HCvnUCla655qFH6+99khpNhaj275E6EO4m4/IGIhNx1BA==
X-Received: by 2002:a05:6638:2404:b0:339:dfae:3cec with SMTP id z4-20020a056638240400b00339dfae3cecmr1379644jat.306.1655909956953;
        Wed, 22 Jun 2022 07:59:16 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o33-20020a027421000000b00331a211407fsm8599750jac.93.2022.06.22.07.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:59:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655852245.git.asml.silence@gmail.com>
References: <cover.1655852245.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.19 0/3] poll fixes
Message-Id: <165590995616.5527.499910142510012433.b4-ty@kernel.dk>
Date:   Wed, 22 Jun 2022 08:59:16 -0600
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

On Wed, 22 Jun 2022 00:00:34 +0100, Pavel Begunkov wrote:
> Several poll and apoll fixes for 5.19. I don't know if problems in 2-3
> were occuring prior to "io_uring: poll rework", but let's at least
> back port it to that point.
> 
> I'll also be sending another clean up series for 5.20.
> 
> Pavel Begunkov (3):
>   io_uring: fail links when poll fails
>   io_uring: fix wrong arm_poll error handling
>   io_uring: fix double poll leak on repolling
> 
> [...]

Applied, thanks!

[1/3] io_uring: fail links when poll fails
      commit: c487a5ad48831afa6784b368ec40d0ee50f2fe1b
[2/3] io_uring: fix wrong arm_poll error handling
      commit: 9d2ad2947a53abf5e5e6527a9eeed50a3a4cbc72
[3/3] io_uring: fix double poll leak on repolling
      commit: c0737fa9a5a5cf5a053bcc983f72d58919b997c6

Best regards,
-- 
Jens Axboe


