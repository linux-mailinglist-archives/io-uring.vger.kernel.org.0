Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFBB4BAD46
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 00:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiBQXln (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 18:41:43 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiBQXln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 18:41:43 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7E035A755
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 15:40:41 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so1499844oos.9
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 15:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=NQsmyQ/9VVtatUHacoNfOcmCWmfy80u0lRhwYZduMhc=;
        b=POuSHfCBEVMkzzEMp1tEPmQaj+cXIDkGrSLCay3YGaBls8GQtkjNhZmnt1UmhWJOJs
         tG1Fr9uCvpkOGKwko7Ec+OJ9MrUW3GsCxdkH9tN+IJjN19lEt/f+yCguduyywUA0srUs
         M+LP5P5aLyJYxydKE+rc3LlhGJlolkdvf+usMc1G3N7KKhaIQBjqSY8I9gYDnSoN1sYK
         hzj4k9MIgXiQrvzEbrg6wb0sD8moI7R+TLUBKyVy3qr4IodKQty+j15FQZSf4WaQxYiC
         agfrworywXTOP93TF2yEdmgk+YlDRwy9QUeMEkqSxTLZw5+yWrOOFz90uz2CHb79f/78
         fnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NQsmyQ/9VVtatUHacoNfOcmCWmfy80u0lRhwYZduMhc=;
        b=lRuh/wqf3oEB6VBcY2gnxAx6lnONLFpkhVxvPEtmS5r6MKnkj1MIcX6FC8B6PnQ77g
         0QExhSDvZfpYzZLDdSjwKILcbudyHTmJw2qkg9NcifMtOj27GL2KJH9zFL3fRJBeOGBz
         insFG9YliNjhu9AtcfVJ42oZ6QW9rnU5PLFjOC8QvTATJU3zIZTYFIocqQEBzfUU8TdO
         w91K9w6sVPfcI7tHMVExUNvt2oRPrX+3lHOk5h5eB+s9WupJ8gb334jfwq2sM8rh8v9n
         ChGiuihp/7Rcx2d+nIOuOdUof6KQqno3IT+ebs91B5Yirz6Z+tCgKBnPCck8z/ynebBM
         cBZw==
X-Gm-Message-State: AOAM533D4UwUu2ZiyxXd9JhzUMG2qOUsBj8wvc2rLpLRF4vyGQL3sLHH
        JIkRbTREFEYPo2uGi4yAg7WD2KaP4xVvDg==
X-Google-Smtp-Source: ABdhPJz7tqW+y7Yh0SNFH0QIwIVPOiSnFfvI8kJVrld/SqrxY4a/FGSkVB1v7/tmi+x810Rwezg7RQ==
X-Received: by 2002:a17:90b:150a:b0:1b9:b20e:ac07 with SMTP id le10-20020a17090b150a00b001b9b20eac07mr9544529pjb.105.1645140341423;
        Thu, 17 Feb 2022 15:25:41 -0800 (PST)
Received: from ?IPV6:2600:380:7732:3c3d:b8f:d847:431d:a3dd? ([2600:380:7732:3c3d:b8f:d847:431d:a3dd])
        by smtp.gmail.com with ESMTPSA id j12sm630705pfu.79.2022.02.17.15.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 15:25:40 -0800 (PST)
Message-ID: <3160fa9d-6386-4049-475a-5ed2c253f27b@kernel.dk>
Date:   Thu, 17 Feb 2022 16:25:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
 <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
 <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
 <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
 <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
 <0a9c1bdcedac611518e4a90c1921d1f7657c2248.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0a9c1bdcedac611518e4a90c1921d1f7657c2248.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/22 4:18 PM, Olivier Langlois wrote:
> On Wed, 2022-02-16 at 20:14 +0800, Hao Xu wrote:
>>
>>>
>> Hi Olivier,
>> I've write something to express my idea, it would be great if you can
>> try it.
>> It's totally untested and only does polling in sqthread, won't be
>> hard
>> to expand it to cqring_wait. My original idea is to poll all the napi
>> device but seems that may be not efficient. so for a request, just
>> do napi polling for one napi.
>> There is still one problem: when to delete the polled NAPIs.
>>
> I think that I have found an elegant solution to the remaining problem!
> 
> Are you ok if I send out a patch to Jens that contains your code if I
> put your name as a co-author?

FWIW, we tend to use the

Co-developed-by:

tag for this kind of situation. Just throwing it out there :-)

-- 
Jens Axboe

