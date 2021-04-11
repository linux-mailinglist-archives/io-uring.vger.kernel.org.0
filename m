Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB035B128
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 04:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhDKCaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 22:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhDKCaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 22:30:20 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C122C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:30:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 20so604517pll.7
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8nfXlfcJd8x3koy0QkxIUBI/3ySEfUYaTWbgMYMwEi4=;
        b=dJHYlJ7FqFm5eqcBlUlNfgpXSJeuHP2PkOmppBTnbC2S0qRSEkMWuHR0ZSzQeueGpB
         oiHD9lxQiRHsWr9GTAbMTYcAhWFsDm4phvCaFOhySVnSFTb92AQL3ZBg4Lv4ttk10xcn
         bQdksgLB5nvHbaT/8fMGb+F7qkzdtITp3TUQnWBw4RBtAWzqI7TVeTCUFKDcDB6N2go5
         y5ScEzBXy3S+Wmd8FTmhykR8HCyIO+ZeZxYn6SqhMBapCMgkFjWIJCvzhdavWCvgf6yS
         zNbB2PqODj/cKfeG19RGEeBX1iemII7V3/Or3OdzYH2NBRBeBZmrgpiMJtm1SoVATGyR
         KgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nfXlfcJd8x3koy0QkxIUBI/3ySEfUYaTWbgMYMwEi4=;
        b=qqLe/6ZKEPvwvPm6tI/EDLqy8OHbDmRMFqGT3fatdOygoEiHT5u1KC+sBH1wrppj9o
         Xu74xnM54bzi9wBVpjspKo0hk9wdn11FIsQSJX7W0/X94JO8Baa+0eSQGRsPEckKsl42
         7BTMQMqFyT836JRGemx+P38UyfCs3oa2AVsDwU15l9D2Cqz/yr4z8F4LWftvQUI5ZX/m
         ffmNbmS2H5bQ/rHFURo7D4o/xZlzH30ScT3U932xaSix5hQDUubmE1ryoO7FK2KOcGe6
         IUDsaLhxd6S2KIp6a49w0/xvo2wZUCMO6r/on5j/WovozKxgoa4BZzkpWzvhkbn5HIwK
         zM0w==
X-Gm-Message-State: AOAM531IyHvA7amTTPS1szBT3RegWPLlmrP3y2uH24beNr4DFs+tgSvp
        zij72vp1QdokE1jvXB9rQ9LriMPjQ9pspw==
X-Google-Smtp-Source: ABdhPJyaTfgYA7YdTwCRPz9xeUxtVQCUMrk3Wi9YUzktpSMjwfczQOApzrxUdyiaJ4XfJH2kB5Dk5g==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr20953693pjb.77.1618108204295;
        Sat, 10 Apr 2021 19:30:04 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g80sm6066764pfb.181.2021.04.10.19.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 19:30:03 -0700 (PDT)
Subject: Re: [PATCH 5.12 v3] io_uring: fix rw req completion
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
 <88a1e893-b75e-8569-fc4e-3c6a54cfbcb6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0e98f786-bdb3-6dfa-bc26-b26ce2cabcd1@kernel.dk>
Date:   Sat, 10 Apr 2021 20:30:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <88a1e893-b75e-8569-fc4e-3c6a54cfbcb6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/10/21 6:31 PM, Pavel Begunkov wrote:
> On 08/04/2021 19:28, Pavel Begunkov wrote:
>> WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18
>>
>> As reissuing is now passed back by REQ_F_REISSUE and kiocb_done()
>> internally uses __io_complete_rw(), it may stop after setting the flag
>> so leaving a dangling request.
>>
>> There are tricky edge cases, e.g. reading beyound file, boundary, so
>> the easiest way is to hand code reissue in kiocb_done() as
>> __io_complete_rw() was doing for us before.
> 
> fwiw, was using this fixed up version for 5.13

Thanks, I'm going to rebase (again...) and fold in when -rc7 is out.

-- 
Jens Axboe

