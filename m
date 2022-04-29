Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972C15153E4
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 20:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379854AbiD2Soa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379081AbiD2So3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:44:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1496A40E
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:41:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x52so6062709pfu.11
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=I5B99e4UlEvBuoZrNBuQhuxFl4KIICwxa8Q8wYXmdgU=;
        b=epgTJJFlxCD8+xZS0OKm1bVYOlyAX+K8dxPtY7CsgXeQn7bzRZouPAv/wmGA0zS77u
         WAN15qCliR+lSKrQynG0qVP2OQR1Feypi9MYnOzATvIGl959UY6rjvGf6i2+xIvQPbK3
         V64AqymY5RSdcHe4xQItPzIKTtvr2YxLGN5vB/bmkFvMfYGaAVusVrDKuzgVUfUZzWpY
         /MS2GGg4A3w72R+lolF6wgRjVdUVRve9kIdGP3KMnCYOXBReqNTUA7M3x9ouKzZIzW3M
         mX0qnVw2G1qd5GEzgHXL1gbqLygEHP2hTcKT5ESHnVXufhD9IqM7ajVhMVyOrpNyQO0d
         qkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=I5B99e4UlEvBuoZrNBuQhuxFl4KIICwxa8Q8wYXmdgU=;
        b=x1fGE/RmoUmhB7w3g1oHOzEB5q7eEOZRTo57261WmsY7rfZnao+W1ko1D57dUBD21/
         bznXeaDPq19kLWzyFNS55JwxlSP0ddpya2P9FHkFRbzO5TJmn22jUJQWptztEr6STZCa
         XVCn/4XlTocKCdZkBwRorz01dpNh+qJNqsEW9IJnQaS/DjR+3xVJ3LCwIiH5uJ8F+zjB
         fehA9ekoP/fk6+GVx/OedNiSdwDi3kOi2A2WTmec/8kmdhuNKqLdjprz1GQvD1Qpg4yt
         jHIs0YFdwtMeOCvzHTvNC+7YV3Cb6MVELpNLMawGhZmlW579Vek92XUwdlueed01CmTy
         fKLQ==
X-Gm-Message-State: AOAM530mvEXDi1xx3hgoy74FslYuFnPRLqdFrooD/C/QX4wy+IeDOfPb
        XSgRKIyOVV2D/3Y8lpkOiggq/DB8PeX1tQ==
X-Google-Smtp-Source: ABdhPJxJcxB9DlquLfajLFKr5kGv9YG30Mz79oIKZuQL/ftFmrgCzyjUBIYCSGLk9fa24ITD18CPPA==
X-Received: by 2002:a63:80c8:0:b0:3c1:8351:303e with SMTP id j191-20020a6380c8000000b003c18351303emr541940pgd.307.1651257669637;
        Fri, 29 Apr 2022 11:41:09 -0700 (PDT)
Received: from [127.0.0.1] ([103.121.210.106])
        by smtp.gmail.com with ESMTPSA id p2-20020a17090a0e4200b001cd4989ff40sm10734748pja.7.2022.04.29.11.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:41:09 -0700 (PDT)
Message-ID: <cc44706e-a249-86b6-55f5-38683ad110af@gmail.com>
Date:   Sat, 30 Apr 2022 02:40:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
Content-Language: en-US
From:   Hao Xu <haoxu.linux@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220427015428.322496-1-axboe@kernel.dk>
 <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
In-Reply-To: <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/30/22 02:31, Hao Xu wrote:
> On 4/27/22 09:54, Jens Axboe wrote:
>> Hi,
>>
>> I had a re-think on the flags2 addition [1] that was posted earlier
>> today, and I don't really like the fact that flags2 then can't work
>> with ioprio for read/write etc. We might also want to extend the
>> ioprio field for other types of IO in the future.
>>
>> So rather than do that, do a simpler approach and just add an io_uring
>> specific flag set for send/recv and friends. This then allow setting
>> IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
>> will arm poll first rather than attempt a send/recv operation.
>>
>> [1] 
>> https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/
>>
> 
> Hi Jens,
> Could we use something like the high bits of sqe->fd to store general 
> flags2
> since I saw the number of open FDs can be about (1<<20) at most.

oops, sorry my bad, (1<<20) is just a default value..

> Though I'm not sure if we can assume the limitation of fd won't change
> in the future..
> 
> Regards,
> Hao
> 
> 
