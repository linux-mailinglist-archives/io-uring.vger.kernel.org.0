Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477CC50BEC4
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 19:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiDVRiW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiDVRiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 13:38:00 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CD025C4
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 10:35:06 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id g21so9294993iom.13
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 10:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=dkkKLQez0RttP8d5GbLCLlyt7TncuXdTZ/5/QB8mTt0=;
        b=L21iICAoPGV6CT6Bru2IEfKXEl5AwhorEGJOUgrXGE63RYfDA3eRAvxz9lq3ACPip8
         Ke71wu5IFLijW8HQnPdb+kN8dX62mexzEzo4bgHIX557blUuXDCzWDmFqphd1pNuOnnp
         UxDd2jnBBlsrUjHGRWhEPcVgaI+kerXCdSvyII0Bf6OLnWriV+QFXp+qVYC5zM32q4tD
         YoCAKho5dts8hnQjJXp07UU29SgosLzgfYiQqv1FTa0exG82WnuCxKS2J46cZF/9X3hk
         9Vhy7HUl2zQpvKr9iMPprRKPmjB3FonGSrOZgu/e5VTSoaA7/xcLaUQHLufwdbiicDIX
         8eDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=dkkKLQez0RttP8d5GbLCLlyt7TncuXdTZ/5/QB8mTt0=;
        b=pLRc1e9E4iLnA1VDSobbDnlJEEVLJv5Ia66CiJbhVW+ZOppHvVE4ZrV40KqpmoCngD
         xHsBTG6cRbPKaoDOSp0ZA6SeCCkCIyOeaTQvSr9rMougxuwfDmfVfy0VhZoLc7/s2SFj
         sfa7p+lGHWk+Qyr1jFvFBwh71tQmJM8+KLCBSrIydOeBg8DRU+mS2hM3hIU/7HKb5NJ9
         u+bAWQz715bNvyvAXqHrj1pwJzco5VKL1WiEvw3XjAQez5r7vqJjhWNmURvU0tOAmEP2
         5Doi7mqghAa4I34Rq9JqGIzQgHPV1gyhreUeopv7zNxGvZaBrHPrwx2ZxOmWEVDOWytv
         4Q0A==
X-Gm-Message-State: AOAM531Y76CJESsR5nrd/TjRY6/xeNxQZAtVWtlGL5dhcy0pITJK9zcl
        idtrRmQu3Yw476SGQ8lQNBabow==
X-Google-Smtp-Source: ABdhPJwMJtowd+t7oGPWNp8/ef4X7tqqLDKqpyS4oIO8vDyBu23zJ+bl2fq3YSIPf6GcdGp1EDfUlA==
X-Received: by 2002:a05:6638:dd1:b0:32a:b1ec:4d76 with SMTP id m17-20020a0566380dd100b0032ab1ec4d76mr1983918jaj.307.1650648649874;
        Fri, 22 Apr 2022 10:30:49 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p2-20020a92d682000000b002cd6c7ac991sm1642906iln.84.2022.04.22.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 10:30:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com
Cc:     asml.silence@gmail.com, Kernel-team@fb.com
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
Subject: Re: [PATCH liburing v2 0/7] run tests in parallel
Message-Id: <165064864924.160423.13308590069118209348.b4-ty@kernel.dk>
Date:   Fri, 22 Apr 2022 11:30:49 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 22 Apr 2022 09:01:25 -0700, Dylan Yudaken wrote:
> This series allows tests to be run in parallel, which speeds up
> iterating. Rather than build this functionality into the shell scripts, it
> seemed much easier to use make's parallel execution to do this.
> 
> My bash/make skills are not top notch, so I might have missed something
> obvious, however it does seem to work locally very nicely.
> 
> [...]

Applied, thanks!

[1/7] test: handle mmap return failures in pollfree test
      commit: 861c121c931d33dae4fbeeab3eac86544d856d9a
[2/7] test: use unique path for socket
      commit: 44673763e7467d49a1ef4bba8a641f9dd4c6ff70
[3/7] test: use unique ports
      commit: 736667aa9e31cecded9474d28f5666fa900d0b77
[4/7] test: use unique filenames
      commit: 16d9366b9f9ca44d2a4da7320663a06fb9df7a28
[5/7] test: mkdir -p output folder
      commit: fddf8e6fd0ec06ca84a1d6a769dbd891e7cdaf08
[6/7] test: add make targets for each test
      commit: 6480f692d62afbebb088febc369b30a63dbc2ea7
[7/7] test: use remove_buffers instead of nop to generate error codes
      commit: 473e16399327ff1a05cb58b256c9bc86b47561c3

Best regards,
-- 
Jens Axboe


