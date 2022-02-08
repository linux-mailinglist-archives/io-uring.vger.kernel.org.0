Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90F24ADEE4
	for <lists+io-uring@lfdr.de>; Tue,  8 Feb 2022 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383683AbiBHRFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Feb 2022 12:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244599AbiBHRFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Feb 2022 12:05:36 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D94EC061576
        for <io-uring@vger.kernel.org>; Tue,  8 Feb 2022 09:05:35 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n17so21979530iod.4
        for <io-uring@vger.kernel.org>; Tue, 08 Feb 2022 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YrbwA7w49P/ayldPQKuq1ujonQ58L1WsBmQ08lrY2iQ=;
        b=Zgoc6h2umHM33fsgQ2fullwn66laDNY98y2Xow3aHclFHEL/riBavdFOgPxY6OhdJT
         9Uz+SnRYgbG7c7p0pbHarWI6mAiMZkny4pii0sm1HI2lKwgFgLJWyqsF+5lvZRv0VyQV
         rS0AxD8Mgusdwmf9VKvHeq0U3luA6DlbjkrvycPP9072zKAOYXVHIFX0Z9iHvqVKf+4N
         n7QBh2uCT9jJyLVuvtKlrSR8yUbFVHyj8h+x/4UhbUxJRz+Mg33zPtgJaLl15Q7fezoE
         g6+yaDHtlDqKralSglmuhNvAKXrSplbxqWvCZvdetDB2VALhFWtDIHfF/kS4rNNzkphV
         Pc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YrbwA7w49P/ayldPQKuq1ujonQ58L1WsBmQ08lrY2iQ=;
        b=rPe68E+y/+67wz/VUZlLurH1XQ69Nv12tMgBNc+cG3GBrI2gjUWckZGXzVwuY/Pnai
         adIevj1/bgbaqLDnod4rRmB/RRDNTCXK402cLDoLpN+bR4fhniFdOvunal9XYqEkZMae
         U3nYzNziTkdm76zDime/UEbZnPl072FEDfX6ltajunVOWdqctSBiW5gBqJgdGuvMO+6q
         7cSmlVOKU8aDCZ9UBPkasot1k+bvE9NUP1aY5yPMHbLbtI+Zk7MmC1BfVmt5kGD80NWH
         wZlTxZCuNVpsu9JEMA+v2vuL/HEowJk3A0jSKvnCBeOpnqdHxOZEV0W3sjMuqxwOBz20
         g+Qg==
X-Gm-Message-State: AOAM532gfY2mEOeOvpRhJKq/1b2ZQoojdNFyLVpJxqQ5e9n6AsLdHI3b
        ZePBTM2djAlJDSU9udXI1faANlxfMeRrJcZz
X-Google-Smtp-Source: ABdhPJyNyrDI4684GVch9GjnXeoNU3SXudGsgSPsuuAkO306/NW1GYSTbeBbx19v1IDKBpolsSWFGg==
X-Received: by 2002:a05:6638:272c:: with SMTP id m44mr2550873jav.111.1644339934533;
        Tue, 08 Feb 2022 09:05:34 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s10sm7398394ild.84.2022.02.08.09.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 09:05:34 -0800 (PST)
Subject: Re: napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
Date:   Tue, 8 Feb 2022 10:05:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/22 7:58 AM, Olivier Langlois wrote:
> Hi,
> 
> I was wondering if integrating the NAPI busy poll for socket fds into
> io_uring like how select/poll/epoll are doing has ever been considered?
> 
> It seems to me that it could be an awesome feature when used along with
> a io_qpoll thread and something not too difficult to add...

Should be totally doable and it's been brought up before, just needs
someone to actually do it... Would love to see it.

-- 
Jens Axboe

