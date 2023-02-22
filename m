Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1872869F95B
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 17:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBVQyD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 11:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBVQyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 11:54:02 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014A12D144
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:01 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id b16so2849548iof.11
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677084841;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxcbKBbPSMdnqUJnA4zE8oYFFkyBWbuLaVHu00l9Ohs=;
        b=seaRGgZeKTrIToiwO3sHtChXvfOgWjvcfiqQdZH6x9YUxlv+Oqr8GWLhOc83+4VZyV
         kGpCt6u3L88vAHIcwROK6Y0ZdQTdoSLZYRDxPawwTKZGzicqm2xVPM1DApQzD6OTKrSP
         3fZ7eCdt2m6LQxdZkD9S9G0hpK11LQuh/cWH0vFgsWtmfKFUDW9EM0hpqnOwJARbE8rc
         bqp6Wa1h1yebTNhuOWK5HWAKNpk1b1SPr8By+/xy5Zgkr4YBKCRc+M4pspd/m3rIzPJB
         KRGjJGrAcUzxGtXBU/2Me0pbnp46QvcFs4h/D9ZUWlw0WqsSMe56Tpz3JBb5GO3rt0wR
         m5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677084841;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxcbKBbPSMdnqUJnA4zE8oYFFkyBWbuLaVHu00l9Ohs=;
        b=4omD1QoZgmsJdhm38YnUDxGMHV7dwQIY4KcvTw/4BjsDxJqEIIaiYTAcwGKgMXKG8F
         RI2iZrK5AIberqn4GCOmm5PI+gTx5PsvN3DxVjb3j9evhRgt0OlZtyH/N7wmdgqcoS7m
         DD5Rl4ztENV8MSoPyAjGfpYTD0+7c8x5B6CI5xJhZDAVYrZbPZrw9r6EjIkqhoJgooV8
         VGmU1A7PObh999GjkHPM61AD+CilQ67082bNF1ZxIKRGDJtbEP/5Y+N10GcF16KsPpuM
         0mjMPEy1csGOL+X0cI/fv3p2ufzHmgVZMW04IvOuXPI9KH2sDuQyRmCV9HntOK8rtIN1
         oZnA==
X-Gm-Message-State: AO0yUKUKjDseZpj0mvZ6i467fHhpGgtXPQ+Y3ongefIvTTvtAiw/+LzQ
        wOpPKPMSU/fCw67+w4y6Nbl26g==
X-Google-Smtp-Source: AK7set9a8G4Ih2pGqD/+FRh07s58qj7tojF1W7E5KCfLz/5bKaCWRxu9HzlsvqZPlzzWBpo4USmnkQ==
X-Received: by 2002:a6b:8d52:0:b0:72c:f57a:a37b with SMTP id p79-20020a6b8d52000000b0072cf57aa37bmr4332217iod.2.1677084841274;
        Wed, 22 Feb 2023 08:54:01 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x17-20020a029711000000b003a7dc5a032csm997371jai.145.2023.02.22.08.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:54:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Wojciech Lukowicz <wlukowicz01@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230218184141.70891-1-wlukowicz01@gmail.com>
References: <20230218184141.70891-1-wlukowicz01@gmail.com>
Subject: Re: [PATCH] io_uring: fix size calculation when registering buf
 ring
Message-Id: <167708484045.23363.7184504964007066401.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 09:54:00 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 18 Feb 2023 18:41:41 +0000, Wojciech Lukowicz wrote:
> Using struct_size() to calculate the size of io_uring_buf_ring will sum
> the size of the struct and of the bufs array. However, the struct's fields
> are overlaid with the array making the calculated size larger than it
> should be.
> 
> When registering a ring with N * PAGE_SIZE / sizeof(struct io_uring_buf)
> entries, i.e. with fully filled pages, the calculated size will span one
> more page than it should and io_uring will try to pin the following page.
> Depending on how the application allocated the ring, it might succeed
> using an unrelated page or fail returning EFAULT.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix size calculation when registering buf ring
      commit: 8318ba8fbd645d269f2e9a590f72f8bad8b5c295

Best regards,
-- 
Jens Axboe



