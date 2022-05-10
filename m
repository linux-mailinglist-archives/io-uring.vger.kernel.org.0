Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C8F521573
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbiEJMdG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 08:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbiEJMdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 08:33:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A562A3760
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:29:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id s14so16611375plk.8
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0mqM+Vn2EmZKarvnvapcYOpxk7HIDCq9WOkrcf2C2VI=;
        b=e23eahSKZf3cSlA8ujBRQ4oE2ZBCvr/24SddTvZCHb5yGX1IrFUzPZ+EkRdGPnVNOR
         wOZUgihNQBnF7jYq7lF9FvyMp15beHuOPSezIKJqgxOCHvq3xq9wpoM1NKkhIfQ646QQ
         6uBmVJr41Hut6E8YT1Ffehm0mxOGk6yURFDq5dlEXrW9eKuVz3sEKwpNsPb7U0REZ0yH
         gPycQU7kTl5p47VnPR0hxmrO0bjF+960fq2aX+kEEdbUNpIHoBKlvo1y2llp6GVYN8Cl
         JueiE+Bj6efMnMeirHtn2gQR82EQEYCWs5u81XX6CT5z3tdBmN3G4xszkWsGas7bbgu3
         mVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0mqM+Vn2EmZKarvnvapcYOpxk7HIDCq9WOkrcf2C2VI=;
        b=F7b6ot8r/MCPRXRB/pd3TtV44570amX0PEUUCZowjCt3Kh8yVV4eGgrgBDeQVIcSNF
         FFDluzsnxOVfVsVHNmyCmbrPolS4gVA6jYiF6S8lsO15Di+sNUbeT6fjA/NdtXy6MYJF
         FVJSYQwahLBb5BWLD+oH8U9n+eXPryHRhuidel4ccEEchGi2C7sQixyygTTOdC5m429U
         gn4d3VHjKPw11BGZ1bD0AOIJHLjOP1Wo9jXT6B17FOvsyuaeryGwapg3UiuJ7v+d8TlO
         mTSeVi6/7z97+OMSxdTkNaO6EeN9t6AWASoD12KLxdWgPJ35mfrqIk74W1Asoxd8RkA8
         UiUw==
X-Gm-Message-State: AOAM532zaUDXfdYsOhHMLJYoaBBBsEQPtstDGAuloNcYQZS+JPZSnnPy
        cViZ2Clu1+0hekQyRTee+6TT2Q==
X-Google-Smtp-Source: ABdhPJy36BsTH0DaztTJ6km0Y+7DkYSKAiup8qM4iZk1mIQOhEXup8q5DWS5wRyvPw4aWFkJSL+IOw==
X-Received: by 2002:a17:903:20f:b0:158:d86a:f473 with SMTP id r15-20020a170903020f00b00158d86af473mr20541356plh.92.1652185748582;
        Tue, 10 May 2022 05:29:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a21-20020a056a001d1500b0050dc7628147sm10281247pfx.33.2022.05.10.05.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:29:08 -0700 (PDT)
Message-ID: <2a09399d-480e-8b03-8303-57287f7b5c64@kernel.dk>
Date:   Tue, 10 May 2022 06:29:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
 <20220505060616.803816-1-joshi.k@samsung.com>
 <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
 <20220510072011.GA11929@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220510072011.GA11929@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/10/22 1:20 AM, Christoph Hellwig wrote:
> On Thu, May 05, 2022 at 12:20:37PM -0600, Jens Axboe wrote:
>> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>>> This iteration is against io_uring-big-sqe brach (linux-block).
>>> On top of a739b2354 ("io_uring: enable CQE32").
>>>
>>> fio testing branch:
>>> https://github.com/joshkan/fio/tree/big-cqe-pt.v4
>>
>> I folded in the suggested changes, the branch is here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough
>>
>> I'll try and run the fio test branch, but please take a look and see what
>> you think.
> 
> I think what is in the branch now looks pretty good.  Can either of you
> two send it out to the lists for a final review pass?

Kanchan, do you want to do this?

-- 
Jens Axboe

