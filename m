Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C225E548
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 05:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIED5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Sep 2020 23:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIED5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Sep 2020 23:57:54 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7ADC061244
        for <io-uring@vger.kernel.org>; Fri,  4 Sep 2020 20:57:54 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c196so177082pfc.0
        for <io-uring@vger.kernel.org>; Fri, 04 Sep 2020 20:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ufQ+zn58UoS4Ge2UHneLBrPOqBKyUDi745oYO2e2pn8=;
        b=Wf+4psyxmNRxWV35M2AbqLcRRV/100NIT0+VtNXm/U86ZiGi+wB0oQjt3b8ycinXSL
         PqMYgM0auchd86IKqRYuLyfvebEJDsp7WCKBz29Vdfxgu9WOz0SZ1ujNxYJ7dM1bjcgD
         89+J8/0vOFSE5HhcM0JsIhNY7i1v2axtyjfaQx7dSMjc4epexkflv72PHeo4I8RHKKgI
         I+GPWaqdBZUJpO9x0lxyZqyF60O7MOkiR7C3IkBD8+YfFAI86X1qMq8IPI5oENrjF9ay
         +Yi0PyDaL260p5c954KsxxTQ+2lbi2xrG+ZRWkwEnhzEpuhKs040RFY3+YV5+9SM/LBG
         ZfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ufQ+zn58UoS4Ge2UHneLBrPOqBKyUDi745oYO2e2pn8=;
        b=Ot6ckf2quL+ly+oDZCQ0qjymhg0KGEelNFBxS7iURcMVJ0Gu8KGd3LaddpJ3O8D+Ff
         tk/gAo/K8UQOitOBXH9h57+DL+C9ZrK9juxejPcdO43Ksxt82RZPKzhCX3+zLaSCE8T4
         MYPEQDYg73L09Ny5UtxOi6wokamYWBMMzSw6UfOoVyZtTTY0yel9iOMauBDCZqLtgDkF
         yWsjV5b2VxLku1n9gvY6RwhCXEntzlKd8Zv4QoX3y/1m5q+II3NbPCMYrxAv3GO5EyTd
         EXKRKsZQhVcnrrm2Jqnjtjf8WEHd0RC4lMD8CHaYZftWKXmUvwxvTE+mpiIUDtnoOt9H
         oICQ==
X-Gm-Message-State: AOAM5308KmNJhYdfnY/x3SjvW+MbwpLDON9/NjvZ1GF6btThxZdCggu6
        6ML8AgCMQHCjyCjtRu1jk9vmOpeeNpYGPxC7
X-Google-Smtp-Source: ABdhPJxGRYfwEJbUmThusj08uERRn85hPuA8jBrLCObbCCU59Mj83bq07TYEmyX6Y7uf9nTqJ9MYNg==
X-Received: by 2002:aa7:87da:0:b029:13c:1611:66bf with SMTP id i26-20020aa787da0000b029013c161166bfmr9888909pfo.10.1599278273028;
        Fri, 04 Sep 2020 20:57:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id bx18sm6350609pjb.6.2020.09.04.20.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 20:57:52 -0700 (PDT)
Subject: Re: WRITEV with IOSQE_ASYNC broken?
From:   Jens Axboe <axboe@kernel.dk>
To:     nick@nickhill.org, io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
Message-ID: <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
Date:   Fri, 4 Sep 2020 21:57:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/20 9:53 PM, Jens Axboe wrote:
> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>> Hi,
>>
>> I am helping out with the netty io_uring integration, and came across 
>> some strange behaviour which seems like it might be a bug related to 
>> async offload of read/write iovecs.
>>
>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when the 
>> IOSQE_ASYNC flag is set but works fine otherwise (everything else the 
>> same). This is with 5.9.0-rc3.
> 
> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that is
> very odd in any case, ASYNC writev is even part of the regular tests.
> Any sort of deferral, be it explicit via ASYNC or implicit through
> needing to retry, saves all the needed details to retry without
> needing any of the original context.
> 
> Can you narrow down what exactly is being written - like file type,
> buffered/O_DIRECT, etc. What file system, what device is hosting it.
> The more details the better, will help me narrow down what is going on.

Forgot, also size of the IO (both total, but also number of iovecs in
that particular request.

Essentially all the details that I would need to recreate what you're
seeing.

-- 
Jens Axboe

