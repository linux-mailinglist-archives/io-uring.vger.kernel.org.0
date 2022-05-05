Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C5D51C605
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiEER0s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 13:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbiEER0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 13:26:45 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907BB5C351
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 10:23:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id v11so4171581pff.6
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 10:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=BJSV4JYZWcx1zjR32pKwL3AktNsdnj/1grT4sVoCQw4=;
        b=Kpdumbv5o2DcWbrMGSu/gMNglwsaAB+N/m/+05km5jMjuEycrqiEUqg8kwko1oTJ/6
         puR9hrnfaLsbA2/yV4bFxxfIhHCECm/Ga5YSIwWREzTb8IE6cYgYv8lWFLrgN9UQpQmf
         +DUkpbeq3uIl5i9LyxQ6g2o1dLz6vH5jhw0eUaJcXleUnGg6pAD1+xLRjhI1pYAuFEMV
         FnUCwrbhMMFOR0Ukpo17proNbW2av/3rVbS5O/kEPzg40ZTrRhtBoxtL4IMRZjoJbIci
         M1Y8WPP4AE2QBZ++5IktvLIsnRZsmBZhAvUHJLektsh8c1H3cbtvG+u+IS2u39m88I1H
         hkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=BJSV4JYZWcx1zjR32pKwL3AktNsdnj/1grT4sVoCQw4=;
        b=Hx0SU92F/VYKgzJxU9fkanETqTOo/vXnb2rXDL4fyOBW/RgYgy+yxBfVA8jRg57ejH
         dowlNgfZxdekKzxeltLH+2L1ciYnqTL6MERWAM5RQY+9xYa7r3XtyXSTDmGBeuHRH8pM
         Mha8evUnfIi+boVtuK020Q+ZQu6o4UiQczwURHdOsMW5smiwdryW2TCycooNcMc8y5fo
         rKatIoqD9Gqzb97D6x5z7jJmYI1jQbUpf/JHGjXdhtTz0hRgTCdSlcUIPLIEuUJ5wZiV
         6lgIyfxfR0zRL5w8urnkkkOf9zhqSb9H3/WyfxZgSwQluHsO40JXX619xIlqWRZhUVDV
         f76Q==
X-Gm-Message-State: AOAM533eAUSIyZgPYj5RHc8/A8+rRGc/FhN8/mkLyqlyWXNsYt3fin9c
        8CuLPH7xTxUVpbBPewx+TajXRA==
X-Google-Smtp-Source: ABdhPJxZGwbtsLOT1wzl9VWVtGPuZwRxSdKWSWtWmeZKgHmiNIannxbuqaujSZHeyjBp/+r7RAT+Sg==
X-Received: by 2002:a63:5464:0:b0:3c1:4930:fbd5 with SMTP id e36-20020a635464000000b003c14930fbd5mr22393253pgm.94.1651771383984;
        Thu, 05 May 2022 10:23:03 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090a931200b001d98af21128sm5566499pjo.19.2022.05.05.10.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 10:23:03 -0700 (PDT)
Message-ID: <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
Date:   Thu, 5 May 2022 11:23:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
 <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
 <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
In-Reply-To: <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 7:50 AM, Jens Axboe wrote:
> On 5/5/22 7:42 AM, Christoph Hellwig wrote:
>> On Thu, May 05, 2022 at 07:38:31AM -0600, Jens Axboe wrote:
>>>> +	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
>>>> +			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
>>>> +			cmd->metadata_len, 0, cmd->timeout_ms ?
>>>> +			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
>>>> +			blk_flags);
>>>
>>> You need to be careful with reading/re-reading the shared memory. For
>>> example, you do:
>>
>> Uh, yes.  With ioucmd->cmd pointing to the user space mapped SQ
>> we need to be very careful here.  To the point where I'd almost prfer
>> to memcpy it out first, altough there might be performance implications.
> 
> Most of it is just copied individually to the on-stack command, so that
> part is fine just with READ_ONCE(). Things like timeout don't matter too
> much I think, but addr/metadata/metadata_len definitely should be
> ensured stable and read/verified just once.
> 
> IOW, I don't think we need the full on-stack copy, as it's just a few
> items that are currently an issue. But let's see what the new iteration
> looks like of that patch. Maybe we can just shove nvme_uring_cmd
> metadata_len and data_len at the end of that struct and make it
> identical to nvme_command_command and just make that the memcpy, then
> use the copy going forward?

The top three patches here have a proposed solution for the 3 issues
that I highlighted:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough

Totally untested... Kanchan, can you take a look and see what you think?
They all need folding obviously, I just tried to do them separately.
Should also get tested :-)

-- 
Jens Axboe

