Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54B750C42A
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiDVWYH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiDVWXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:23:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639881B3064
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:15:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q3so13512510plg.3
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6ayklLmQ4uhHFQZlB2DyIHRJVFJYB2QCvbApc6TxQyQ=;
        b=KVy5ODlMllAPxkoeH1IZNbqSCgOCXxs1fkKvnaa+oKejWBMKKOc0ITbG/iH+3T+WCY
         1qBg9A/YM1TixiGDP97fBTzyulfXWhm6fWu3xl33sbdaCaMBjY6x3cdkcbY6tILag3US
         Afwnc9Ykc5QtOoBkCtPqwSMTZbRCRktYB4InPMQVyhHcsGgy+6ZXX3rn271cYgVnup5t
         ZALDC7JZ1wCzgWJW5Awyi4cxWQiSBw5ZB46gI3MtX1p+yy/d+WfZL3hQaCSu9huwNB4e
         /a91lN+UxwsEV2b4b6WB5I3p2PAXb+D0cY/zjMJBpd6RFn8sDMrmL/pZpzQ9bGhdqcBF
         Q1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6ayklLmQ4uhHFQZlB2DyIHRJVFJYB2QCvbApc6TxQyQ=;
        b=kdNJf9xOeBVoCBghOrNVIA+lDiabu4MGKvLHC3DCX3vZ3PWm8QH5ORUj31QbhcTnBh
         dOi3mILh3QgojKeexG0Y1P4Xuh/riAB/SqUi0J+vhD5CgFzj0wBQmEyXSiGyuAFTT87m
         IlYBWr0fU+DxhFfPZ0csMvDnoHgBND9xfNKs0/fIUHQoI1Rp7z4UF3DBDCcXJSElW6Qi
         GpEkc1EDlXbrAJ3QfT9eEZ7QXUPzdrPGgTyuCBCdbhOocZtUgO1LQiuUuKo58WyujBRI
         rzz68iUFLuikxX6b2aP2aKHa+xGUAJSN6owU6oxkefKvgPTE+xoXau9DmTu9QR4Gss/K
         CWgg==
X-Gm-Message-State: AOAM531MJm2X+++RcDfgTAzkxxTKW1wbbL4VyljDtjYM9F7FNwaDwnjt
        1xf4p68GPlDzdSK2rSdhgpt0enuJWsKEy3lb
X-Google-Smtp-Source: ABdhPJzZEGYP9DJjA8dFGo1VAZFFJS3w+7ND6evFh/Am1wlAKMfBkuQYiR7TKLBWgaQCpfntHT64jw==
X-Received: by 2002:a17:90b:4c42:b0:1d2:8eeb:108 with SMTP id np2-20020a17090b4c4200b001d28eeb0108mr7590145pjb.113.1650662157783;
        Fri, 22 Apr 2022 14:15:57 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm2848778pgf.17.2022.04.22.14.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 14:15:57 -0700 (PDT)
Message-ID: <351cdb16-2991-d182-426a-89c9f1c05ee7@kernel.dk>
Date:   Fri, 22 Apr 2022 15:15:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing v1 0/6] liburing fixes and cleanups
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 2:35 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> Small liburing fixes and cleanups this time:
> 
> - Patch 1 and 2 are a fix for the recent updates from Dylan.
> - Patch 3 and 4 are a Makefile cleanup.
> - Patch 5 is an update for the GitHub bot to build x86 32-bit nolibc.
> - Patch 6 is a workaround for random SIGSEGV error on test/double-poll-crash.

Thanks - applied these manually, as email is being a pain in the...
again.

-- 
Jens Axboe

