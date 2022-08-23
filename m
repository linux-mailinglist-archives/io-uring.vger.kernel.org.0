Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB4F59E81A
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245628AbiHWQyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 12:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245345AbiHWQya (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 12:54:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6417A1367E0
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:23:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso17223943pjl.1
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 06:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=zqgEOt/TK3wL9wlmq1dIyUheKT1/TvyscS8U/UOxg50=;
        b=WVljkVoKoCDGdZ3EvIR47a3FVfptjEqMh75J0HuMzDu97524zwum4RT7h+6tmgAh/5
         sp69YR7PZ8RZx1/++gzHoNClG4UGCeURKfpEN5gnLI4iuf33zgW84boywVDt/ncFS2XH
         XyGOA7txzhB3ypg+1QudaN1n9h5k/Fx9LYcE3eFehu1yzjpIe75IjDUSkVALJQF+QVuw
         Ob7Iw9FicJShOGP0kS3g5nTvhMAXx2dHyJruNa9TZXudZvDAKUEFbcJz+ir7EA5EryKR
         WpxppYfqCNumpRXJms3lQHQ1mfgeFtktuAZhM2sUQ7IxNhaVSIiKYXU15jro3mYVl5Zh
         NDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zqgEOt/TK3wL9wlmq1dIyUheKT1/TvyscS8U/UOxg50=;
        b=mRLN7evSZgkNy/oIm7ShWm+xisqYuTV9+y2TiMHZfnYeoGvQnpQah4uFXiJTwm6zwb
         s/T+PZVdVa3UHC9XBkcF92/KM8Wcn8/xBijbiPfXlCXFet/PidCue6aqOkOT93pEANrx
         GA5IWORoFfYrinTnkMjGYNaHujGX2yO5XC00vt6N2bkBFd1hJu7UErJDF2QtxOidWziM
         4w7tIwA7kkDhiqcROi5LnqnlT1e8XaLlxl4J2e2RZPUtAWiDE0DhjpTdl5SySAodV7c3
         doHVRmbQE8S49176ttyaP+f37UNaZAAUP1YEarDZw4gMKGOrOcVrXdPrL8Wgpkx7saBR
         b9Hg==
X-Gm-Message-State: ACgBeo2vUZ5y7oT0y6CtqmX+Q9CehxF3gBE7j2G6NeS3MDebB+RaPioK
        MTqS/tpS+BOHy3aLd9D+z7iktg==
X-Google-Smtp-Source: AA6agR7WdzCoE1JL+CoVyUMNuw7bM5L56qez9WvHY4et7Hh19jpwj5T6mv6ii+vELcSSSw647qnKDQ==
X-Received: by 2002:a17:90b:2644:b0:1fa:e0be:4dcb with SMTP id pa4-20020a17090b264400b001fae0be4dcbmr3202423pjb.85.1661261022785;
        Tue, 23 Aug 2022 06:23:42 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d22-20020a63fd16000000b0042ae03134a0sm2037708pgh.48.2022.08.23.06.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:23:41 -0700 (PDT)
Message-ID: <63368ff3-d78a-5be3-2d38-5a9ff3cf7805@kernel.dk>
Date:   Tue, 23 Aug 2022 07:23:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing 0/2] liburing uapi and manpage update
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>
References: <20220823114813.2865890-1-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220823114813.2865890-1-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/22 5:52 AM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> There are two patches in this series.
> 
> 1) Sync the argument data type with `man 2 renameat`.
> 
> 2) On top of io_uring series I just sent, copy uapi io_uring.h to
>    liburing. Sync with the kernel.

Applied, thanks.

-- 
Jens Axboe


