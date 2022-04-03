Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338974F0CE8
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbiDCXRX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 19:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiDCXRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 19:17:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9127F36179
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 16:15:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so1313295pjy.5
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 16:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SM2cSDTSyohFDZyRxcQ1ghjghhAMTQ8Oj6Pfl+hoYYM=;
        b=HQandnubTZ97806VrhduZR62Qns5TARcDFGufdF3+3rhpljcruwiP3E9HV7aM2K3Ig
         7g+beOdK/5FQqNwMu65qwdDxk70w9eJcdbmNj6j+qDfknu+SKtl8vjqK1k3sEinQH3BY
         xwnJtXFl7qhrjbmn0tJmlxOjtfwPfZUDgTFeGRy6v7YLhixJwwViUPsSZ5lNPoL+UZXr
         0Buu+2hxWBKi8fvdMqpVTbwIf6emSxl7a2z+Fgr+9sefCDgzSPMD2Wspw5N8CokrGBZ9
         LIcMH6AktAie3YYotJFlwyLkNYJ6LsZlxH9PXRXAc/j0m8dXQ9Up63Lw4LQNYxA48IHz
         Tmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SM2cSDTSyohFDZyRxcQ1ghjghhAMTQ8Oj6Pfl+hoYYM=;
        b=3ps01cmnY/xM5EVGwutGnC7iIsVcLEtwbKBs85QyREaK4LuLKAfqfWiXYDIeFyl3yS
         NPCsi8546i78e3rhXOoFvbgxUkYj6H3uNe1I7xhnZQWLfwWTjKD2B3AhmEMGD33RZ545
         X++AZzEmcuNcYctGNqz/gDk9uqytlcyE2oOTB30woeAMw5e+LFGUS/hlWslFoW2wtVgl
         a9cU0kHrJo2btK+vbSJs76aHLrGbtGVfFM1sF77KaK+3v++lwAVEvZnZeJARHBeoKkyk
         WXDsuVPz39ZVKCdXXSwVDwVTewoAWU7vpub4nluXX5hGFOv81euSX25DKV0bJYTbRYxl
         VJ9g==
X-Gm-Message-State: AOAM531xcAK0xlHXcPywjJ5wV4tGbIACziFxX+JFuIC2YdbuL0M9Rr1K
        VV2Xpo8eP+ElchtjKsQVccj0tilMX1F63w==
X-Google-Smtp-Source: ABdhPJz5wW/7wxrmZX1bLvafLAU5zteOe1jWCPXoSPV5+iBQQM2JdlPjy5iycGNECJPz8uFmj6KmgQ==
X-Received: by 2002:a17:90a:c791:b0:1c7:26eb:88dd with SMTP id gn17-20020a17090ac79100b001c726eb88ddmr23264989pjb.218.1649027727021;
        Sun, 03 Apr 2022 16:15:27 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00170d00b004fb1450229bsm10489157pfc.16.2022.04.03.16.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 16:15:26 -0700 (PDT)
Message-ID: <edcdf7d7-c993-3dd7-1ed8-b6a713d0fbd9@kernel.dk>
Date:   Sun, 3 Apr 2022 17:15:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing v2 0/3] Simplify build for tests and gitignore
 cleanup
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
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

On 4/3/22 12:21 PM, Ammar Faizi wrote:
> Hi Jens,
> 
> This is the v2, there are 3 patches in this series:
> 
>   - Rename `[0-9a-f]-test.c` to `[0-9a-f].c`.
> 
>   - Append -lpthread for all tests and remove the LDFLAGS override
>     for tests that use pthread.
> 
>   - Append `.t` to the test binary filename for gitignore simplification.

Thanks - I have applied this series, but noticed that test/statx.t isn't
properly cleaned when make clean is run. If you have time, please take
a look. If not I will tomorrow.

-- 
Jens Axboe

