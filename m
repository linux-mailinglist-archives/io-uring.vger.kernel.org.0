Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE20A4F0A65
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 16:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359086AbiDCOxu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 10:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243315AbiDCOxt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 10:53:49 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C8839B88
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 07:51:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o10so318670ple.7
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+eNrmaDd/ZDbML51HSAC8jpfHoQtdW5LvniIsFkdR84=;
        b=DT6vw3t5Qxro7EBw76r8K/aIQP3uWWpH4cK1sI0FhH33NnzJieFKzraxpf1ZanWb/Z
         6jdCOIWV3rRTOtCTMoBxIKTtK788PG/lQfllkHb0o49qzg8RoNZ12S0AZpqPR9pmdeih
         8Vd9NLSW1Vz21hIt8pmzaah1CvZil6CswPqLhG646VBBVeKIy4yXnRR3MSgBfWdBC8Xe
         ujmraW5nUec19Ht0aAyTiJNfbaJfYF7QyOK/I+aiWMmKtz397DlFGoAtuD9nuI5Q072d
         uyzFgLowhk37i+j6kRrTn/ZtIPSSTY8Tt0P6I+nHurSvLVjvFFAI+i4OCVSIFjFOyCex
         C6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+eNrmaDd/ZDbML51HSAC8jpfHoQtdW5LvniIsFkdR84=;
        b=50CB2bkuHBbtVbFJgOoCxGti7IycwLkKN1d5mm7DBwcTtd6NT689vAZWA13622XtjO
         229hogVwmvCIv3GFQZFhqiSAspo+tiMZRpKzBt6/ct6zIsUAtOjKjoU/9HQnoGbIe3eR
         0CwFCqMhZo+STZtbCRjJie/ts4mjrSoASUfrEalCcXB6Isg/WETwkMD3YCz1GSwT1jAx
         ut6/Kfxi1/vbpq8FCwmxfMNhlV4cQVnasqSuTwl9YtKngFKYaXVuQqUDxWrM7cRoj5zT
         g1h3EWElBv6GnBGmV1n7EywV3SnpZuKEaJloqeH1uBN8ZzOq2E5BEjNiQXUgRlvR7s79
         MuwA==
X-Gm-Message-State: AOAM532XKILH2Fvyj+n4BN7leDG0MT1hmGMdgDqRd3gUUMr/5GSwm2S5
        gLwegveNxWKwJrIqJBtNCpBB4iAZqVEzQQ==
X-Google-Smtp-Source: ABdhPJzMfc84gE/RaFZc/OixEpChXWOnTcipeOp7QHDp1VmasELupTjLI1W8dpIhl6VAOHEfb8JXtA==
X-Received: by 2002:a17:90a:8b8b:b0:1ca:6007:36e5 with SMTP id z11-20020a17090a8b8b00b001ca600736e5mr7305679pjn.128.1648997513527;
        Sun, 03 Apr 2022 07:51:53 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090ab79500b001ca3c46ba2fsm7266415pjr.24.2022.04.03.07.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 07:51:52 -0700 (PDT)
Message-ID: <5eb7b378-b0cf-83ff-7796-87a33517b1a0@kernel.dk>
Date:   Sun, 3 Apr 2022 08:51:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing v1 2/2] test/Makefile: Append `.test` to the test
 binary filename
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
 <20220403095602.133862-3-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220403095602.133862-3-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 3:56 AM, Ammar Faizi wrote:
> When adding a new test, we often forget to add the new test binary to
> `.gitignore`. Append `.test` to the test binary filename, this way we
> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
> test binary files.

Did you build it?

     CC 917257daa0fe-test.test
/usr/bin/ld: /tmp/ccGrhiuN.o: in function `thread_start':
/home/axboe/git/liburing/test/35fa71a030ca-test.c:52: undefined reference to `pthread_attr_setstacksize'
/usr/bin/ld: /home/axboe/git/liburing/test/35fa71a030ca-test.c:55: undefined reference to `pthread_create'
     CC a0908ae19763-test.test
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:210: 35fa71a030ca-test.test] Error 1
make[1]: *** Waiting for unfinished jobs....
/usr/bin/ld: /tmp/cc2nozDW.o: in function `main':
/home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
make[1]: Leaving directory '/home/axboe/git/liburing/test'

I do like the idea of not having to keep fixing that gitignore list.

-- 
Jens Axboe

