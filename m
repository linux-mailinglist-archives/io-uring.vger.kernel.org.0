Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBD5B212E
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 16:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiIHOuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 10:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiIHOua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 10:50:30 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF13696D2
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 07:50:28 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id c4so14258070iof.3
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 07:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=2+OaBo72pMJNSBQYXNS+YDPCBT48jhi0Jw9AbEWtY6U=;
        b=NCo3id8hFYjm5E9oCtap7qyDZV2P202AU1/FlLpoz/B4AHi5MNm7kJaBcxTA1CWznO
         TR/+dNUh2Ov+/m+vV2J4ki+9HG+PWCv9tAdcLVsMZfK6hYgP0jsrbxPbx4i/Cq/1tKYM
         inxfFGmkMeqZmBJ0Qzr9I2raRigf5w5azzV2EgbZLdzDLI/ZD1eyAOag1pZNhmGuFpWN
         lx8n38xFdvnGrgO+vbup/Y1wqQXjlOcDHJ6G98A8EPDRCaxCPmeYoN76taUao6BUVe7W
         F4V75viqKFiZ/TbLkCRCsiePM21vnd5Cbpnhm+ppV0E6j6r7XaZvgj+Hh3mxs2unHFKq
         G3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2+OaBo72pMJNSBQYXNS+YDPCBT48jhi0Jw9AbEWtY6U=;
        b=E07YXDNHJujUxfLCMlISBLJxstTq4ZomK3Mlhvffy62MpJHSXBXu6OJU3Ht93miGcj
         PcTqbjmNfyEdMzKZckDrqrPBMt7nl+FGlvuPeKAlwxUVVvaysgN6Ub3/9tpKYBp7klHJ
         zkgqvz5TJI7UzFQQa7/RxsdbIa++X133uzB3u22ZGLCvMppIgepP5ui0cB53B9np67N1
         68DPEhpDh+pFmG28vMmeMf25PufEmFOpNEl6Uc6PzBsry3qoxviTYJzqJPVEQ5m4xorh
         joquitEOOsBON0V+2d3TO8at8u1YAlvVFgZUlc8O1povWlavq5X+cwX7RKENcd27LJ2v
         J0Ag==
X-Gm-Message-State: ACgBeo0KnQ0hLUQxX1sAkOM34n5oyZUIhE+N4d0/oVHlmTqhD0k0jXBK
        Cx6lWCiJDN6rlijLZbT3zubOuw==
X-Google-Smtp-Source: AA6agR6uieADTj+azZfP+uuQSQTzIi8TQ8lt8PcpWmPsm7pAgm3nZVD0XRV7p4pAe/K6Xu+8pflAgA==
X-Received: by 2002:a02:a784:0:b0:354:69ac:48fc with SMTP id e4-20020a02a784000000b0035469ac48fcmr5145680jaj.14.1662648627205;
        Thu, 08 Sep 2022 07:50:27 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u9-20020a022309000000b0033f043929fbsm8454141jau.107.2022.09.08.07.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 07:50:26 -0700 (PDT)
Message-ID: <def18512-bc31-6847-f099-8efea0beed2a@kernel.dk>
Date:   Thu, 8 Sep 2022 08:50:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH for-next v5 4/4] nvme: wire up fixed buffer support for
 nvme passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "hch@lst.de" <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20220906062721.62630-1-joshi.k@samsung.com>
 <CGME20220906063733epcas5p22984174bd6dbb2571152fea18af90924@epcas5p2.samsung.com>
 <20220906062721.62630-5-joshi.k@samsung.com>
 <26490329-5b51-7334-1e2a-44edfe75d8fa@nvidia.com>
 <20220908104734.GA15034@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220908104734.GA15034@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/22 4:47 AM, Kanchan Joshi wrote:
> On Wed, Sep 07, 2022 at 02:51:31PM +0000, Chaitanya Kulkarni wrote:
>>
>>> ????? req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
>>> -??????????? meta_len, meta_seed, &meta, timeout, vec, 0, 0);
>>> +??????????? meta_len, meta_seed, &meta, timeout, vec, 0, 0, NULL, 0);
>>> ????? if (IS_ERR(req))
>>> ????????? return PTR_ERR(req);
>>
>> 14 Arguments to the function!
>>
>> Kanchan, I'm not pointing out to this patch it has happened over
>> the years, I think it is high time we find a way to trim this
>> down.
>>
>> Least we can do is to pass a structure member than 14 different
>> arguments, is everyone okay with it ?
>>
> Maybe it's just me, but there is something (unrelatedness) about these
> fields which makes packing all these into a single container feel bit
> unnatural (or do you already have a good name for such struct?).

I think the bigger question here would be "does it generate better
code?". Because it doesn't make the code any better at all, it just
potentially makes it more fragile. Packing into a struct is just a
work-around for the interface being pretty horrible, and it'd be a much
better idea to separate it out into separate functions instead rather
than have this behemoth of a function that does it all.

In any case, I think that's a separate cleanup that should be done, it
should not gate the change. It's already horrible.

> So how about we split the nvme_alloc_user_request into two.
> That will also serve the purpose. Here is a patch that creates
> - new nvme_alloc_user_request with 5 parameters
> - new nvme_map_user_request with 8 parameters

This is a good start though.

-- 
Jens Axboe
