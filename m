Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DA575FE71
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 19:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjGXRsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 13:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjGXRqa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 13:46:30 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00602737
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 10:44:42 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7748ca56133so37823739f.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 10:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690220674; x=1690825474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bzU5lY227HowVnhs3Ok5Y7xSQf1WHlO84hYRZwMfQfs=;
        b=tP/A++YN/DGIb6hYUjW13jD4aw+ICMtkRZ9UZ8ClUkcULbVQOVoUTjkxG2MjRh79lq
         F73Mo/A5kBKCvYa7Ls7ti7dEUV5klu9UW+CRtJ0cWXe+lmt9WsvHzszxkR73VTfi49Br
         PXT4tQhO7dTWkG+hqGMUMCBpzw/4BBXHUJcBACBuVDGOPJTTd/tAWNC8aRs1lxRWsN3Y
         Iz7Ndze3wA9iL5c0LlZYwd4QfJeWUcdtsIja8a297af1q6SXvErtmiLiZR/1W0mb1gde
         6mJvVCYcrZnogfauU01MPJ2vOCLI2qOF6iolWUXBTrDwXjtqDC7ryPXmiK5Cime+jLYc
         Xaxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690220674; x=1690825474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzU5lY227HowVnhs3Ok5Y7xSQf1WHlO84hYRZwMfQfs=;
        b=YcpiQquLPGGxdxxS4g5p+lqqIeaJnp1mFcYyUYNdVNYWH7ihL6oS1iDVNuxfCF2Ypz
         m2CoYzJ4r/KCdWqctSsStcUMI353S0ab+MyPwn/8wdltHmC5eOiC+fESgWHsnPaHVKTa
         iMjCdIEP1N6RVEQgBmGwnutXGxv3wfnbBDR6kHXbJsai+u0wCWmNj5l5sHZp13FA16Rg
         Y6zp7cGJ0YCDMQnGZ5MDSsbSlHndba5Kl0Z7fjbvHKnqdWQujkNrBpkwptdwuYRKjC7X
         fzTPX7XYFyd4zN/AIDyOcdc04FfJGGBaLclQfdJzmLKYopMrjpwHX0RXOsvRJPUTPF7J
         +Qlg==
X-Gm-Message-State: ABy/qLbi/zHlwxcBZ3/EkW/+hA6g33axGl0een67VNSxiBBm+tfBj7KF
        xMVYrxZk7gdMwXqir0ua4+ZrTA==
X-Google-Smtp-Source: APBJJlH0TUd0xWGbYo8TQIl7EDf3lSiyhqH+eIbnJYDen6yrBU/R4ToeCyzg2u61OOMCThqfezx3bA==
X-Received: by 2002:a6b:b4d5:0:b0:788:2d78:813c with SMTP id d204-20020a6bb4d5000000b007882d78813cmr8387563iof.0.1690220673775;
        Mon, 24 Jul 2023 10:44:33 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i21-20020a02cc55000000b0041627abe120sm3003902jaq.160.2023.07.24.10.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 10:44:33 -0700 (PDT)
Message-ID: <5f303931-40d3-2133-9085-62440f8b0666@kernel.dk>
Date:   Mon, 24 Jul 2023 11:44:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>
Cc:     Phil Elwell <phil@raspberrypi.com>, asml.silence@gmail.com,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
 <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
 <20230724172432.mcua7vewxrs5cvlg@awork3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230724172432.mcua7vewxrs5cvlg@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 11:24?AM, Andres Freund wrote:
> Hi,
> 
> On 2023-07-24 09:16:56 -0700, Andres Freund wrote:
>> Building a kernel to test with the patch applied, will reboot into it once the
>> call I am on has finished. Unfortunately the performance difference didn't
>> reproduce nicely in VM...
> 
> Performance is good with the patch applied. Results are slightly better even,
> but I think that's likely just noise.

Could be - it's avoiding a few function calls and the flush, but would
probably have to be a pretty targeted test setup to find that for
storage IO. Thanks for testing!

-- 
Jens Axboe

