Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B334B32DF39
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 02:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCEBrF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 20:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhCEBrF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 20:47:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D2AC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 17:47:03 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d12so922875pfo.7
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 17:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LshAGE6p6myQmD07uPQReOdZiOzqC1u3Ks1YbjLsO4M=;
        b=RX3AoJVlGThIWTGEThs+iA1tzEtrHJPFhrGhLxrvC3ncaoVoYjc6FVno1YxFnX+rIP
         TFJSnFr7hDaIaB4vKvvfwJlckW0/BhXoHJ0wZfnKa5lxi3eODiPc+0KRYz0oVucEtXN2
         8DPcy2X0tR4BLT4fXqJmC3HWOd0NtEY9RwlGB2l09FL3b0E2Zjyz/QG4MlOWMHtUhhs0
         UDRsn1xICsIyl+8WTIej6mcWq7r4v995F3I6tl5K7R/LkhhZS42nOZYJCyK5INeGHeAG
         XFgXUDx6s+WW6hdTja4sUJ7goZFwWm4ZKhh6G6ZCTaq7BoxbdCO9u1TULBOxated5HyK
         RQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LshAGE6p6myQmD07uPQReOdZiOzqC1u3Ks1YbjLsO4M=;
        b=k7sBWYdU1qZEk6WzOcbmH/dg+h5z+xahf70gn2yGkOjPKfWfycyOtVrn6ovJtJaizX
         pwHwxgwg/7HkS2Dnp51RCVbtSPHGKMnZtN77uQSOvzYQ2QCBuGF33r9t7DJQo2IDqIsi
         +ozw4idxLkGYTBxF0Eh6qFZp0YYzRo9ehPPd77DDBxxTOFICYomnpPNaIFXrObYF2AAl
         c3/Dn39c/O1cO/pOeOh+ekmhQ/VbzSzDKNYtUYwVpYPTW/n8leZNPyMzss72sdldkXbt
         /+MUo5jWxw8c6w+d/1/lPe42U4aihc+grYaddZ50OuLcgLQVqN0FeHa0q5cC7Jdh7YDX
         +9hg==
X-Gm-Message-State: AOAM5310yA9XVbGi0fXxdjO3nRLivN7FFmU7jg2/+fK2awolAm5ki6Ej
        yJ6en8JO0M79d4HNYOnLS0zvHw==
X-Google-Smtp-Source: ABdhPJz86LRvYlgNWtdeooxQLjUMnn2hKKPKVw3eiUAQxHw3GwyuLUh1EpuGmvnfw7GLPDfEDPBLPw==
X-Received: by 2002:a63:d24e:: with SMTP id t14mr5971182pgi.348.1614908823122;
        Thu, 04 Mar 2021 17:47:03 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id np7sm452068pjb.10.2021.03.04.17.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 17:47:02 -0800 (PST)
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com>
 <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com>
 <BYAPR04MB49656F0B96D7D1190B293C1186979@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <54a2df06-8dde-1302-1109-d54d38ade488@kernel.dk>
Date:   Thu, 4 Mar 2021 18:46:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB49656F0B96D7D1190B293C1186979@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 3:59 PM, Chaitanya Kulkarni wrote:
> On 3/4/21 03:01, Kanchan Joshi wrote:
>> On Thu, Mar 4, 2021 at 3:14 AM Chaitanya Kulkarni
>> <Chaitanya.Kulkarni@wdc.com> wrote:
>>> On 3/2/21 23:22, Kanchan Joshi wrote:
>>>> +     if (!ioucmd)
>>>> +             cptr = &c;
>>>> +     else {
>>>> +             /*for async - allocate cmd dynamically */
>>>> +             cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
>>>> +             if (!cptr)
>>>> +                     return -ENOMEM;
>>>> +     }
>>>> +
>>>> +     memset(cptr, 0, sizeof(c));
>>> Why not kzalloc and remove memset() ?
>> Yes sure. Ideally I want to get rid of the allocation cost. Perhaps
>> employing kmem_cache/mempool can help. Do you think there is a better
>> way?
>>
> 
> Is this hot path ?

It's command issue, and for a bypass (kind of) solution. It's most
definitely the hot path.

-- 
Jens Axboe

