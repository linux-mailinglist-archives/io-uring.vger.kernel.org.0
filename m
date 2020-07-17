Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB0224675
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 00:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgGQWsE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 18:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQWsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 18:48:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32A3C0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 15:48:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b92so7033596pjc.4
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 15:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YuCrbTtg+4/4jwLQo/rrB2hRR+AabfWdWom2PU4Fsgg=;
        b=Q8WviYuUQyec2462D9oVcatXqm35JlSF+oCTI/p71rHhJSenPpAAZnLl7B1eeR+pF8
         zBm1O+Nn4b17Oi5GvZJQyT+rtb6g+B3u+KGhziwljopqOmgGemq/HxSVdyW/+ridTbUy
         CuP+9fbuMC9CulA1/KZUXmDLWTmlgGUrKwWb/lgm+NGAy4zaFmyd+6Pha4umtRhdRgVG
         mRclDJw0J6pgzkkFFPnt0BWshCwqOUM+SQi33FwQN4rqReTKGikv3JqW6+Ad+4YZ8r3g
         EUfDCkGgDwkcRhggVAmejdVNfpwRhwMwTUGcet4KE/lk94kVaggvzQAMkZbhDSCf6lgQ
         Vgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YuCrbTtg+4/4jwLQo/rrB2hRR+AabfWdWom2PU4Fsgg=;
        b=LupxGUieMU2cUUnJ5jglJrxgtTSgsiGIv20wesjdq7fuOOuNDtxrtiFkQZFqc7YNQv
         syv9hJ1aJBuQ5NK1u1squdyem1xyTV5ke6ThJrfD+xWaWr9HxunodQxXxUCjY3sTfgbF
         o6tKuIQyXZTyyvh9L943EU8vBEQrmxLzd6PyaRcR0ZKrVbivJVfsuqtS+L7m6ljVlubv
         cH/et73OPPrpbcxRjeenpBrgznlz3ZOMtIWGzS+VcvHVcnEJa6sOKu4WKOT2rXDn1s5Z
         qmFEPp+VY8lcNmtPkv5aC5EaRKsvPaCqgoOHWGzVJLIAO1+gCGoIFuoXVuBjraT/BZ+M
         9qFg==
X-Gm-Message-State: AOAM533gNkFKS68zu8mu5VDQ7ygUsfe8/DvpHlw/7dYAEP9UqH5WdB6P
        nuJeitba48JuxT6nE4+diLxhBYhGsaxaaQ==
X-Google-Smtp-Source: ABdhPJwCLYuTeTmXOFiHz536HHUou/p+t8sfAGriwgB5ekrxoDJVAv59ymXDUQ/t6mmLgQisyouCtg==
X-Received: by 2002:a17:90a:a887:: with SMTP id h7mr12261283pjq.0.1595026082598;
        Fri, 17 Jul 2020 15:48:02 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k189sm8517941pfd.175.2020.07.17.15.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 15:48:01 -0700 (PDT)
Subject: Re: [PATCH] io_files_update_prep shouldn't consider all the flags
 invalid
To:     Daniele Salvatore Albano <d.albano@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAKq9yRh2Q2fJuEM1X6GV+G7dAyGv2=wdGbPQ4X0y_CP=wJcKwg@mail.gmail.com>
 <CAKq9yRiSyHJu7voNUiXbwm36cRjU+VdcSXYkGPDGWai0w8BG=w@mail.gmail.com>
 <bf3df7ce-7127-2481-602c-ee18733b02bd@kernel.dk>
 <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4f0f5fba-797b-5505-b4fa-6e46b2b036e6@kernel.dk>
Date:   Fri, 17 Jul 2020 16:48:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRhrqMv44sHK-P_A7=OUvLXf=3dZxPysVrPP=sL43ZGiDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/17/20 4:39 PM, Daniele Salvatore Albano wrote:
> Sure thing, tomorrow I will put it together review all the other ops
> as well, just in case (although I believe you may already have done
> it), and test it.

I did take a quick look and these were the three I found. There
shouldn't be others, so I think we're good there.

> For the test cases, should I submit a separate patch for liburing or
> do you prefer to use pull requests on gh?

Either one is fine, I can work with either.

-- 
Jens Axboe

