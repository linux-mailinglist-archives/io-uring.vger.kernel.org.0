Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5750D550C20
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiFSQjC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 12:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiFSQjB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 12:39:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB0CE34
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:39:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id go6so3410028pjb.0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=aNyX+fgSUloZ95IlRXcbILKvW0e96PXKvdoPhCpa1mc=;
        b=So/JSX+XFGazaRNTLIFXLMPXS9YDRAEhIefMADJqvmaGP7Du2mvl5X3vi/nGe3B+JI
         /4eeRjJh9JWN7QPBb3HPxJRuU+y9xom2S0M4/5iKuFvnlWXXn/plxsZfMn9576YpfHiv
         7Ha9RxSXWYZA/doFKK3Fa3PsQBBqRIfNP88Qf3l14oxuIDwmchtgpTZ1kGVqQpe7Ep5i
         FyfBX+68phLbSQN509cQuYamvL9GcRyhW3tBJm6dc5/KxGq1JS+xYi9emIIgRt4JzgD6
         pqdYPdNe7Z2/a7IXsPN6h1pEl/z8ZGTnWCPafSoUD5TWC89xtVq/ULXweRcLidyDAM0P
         UnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNyX+fgSUloZ95IlRXcbILKvW0e96PXKvdoPhCpa1mc=;
        b=RQSwG/slR0k87dWXg2MBchDk75GfqGBcERnWupwdt6mA+go2QGJYExly0M7DMNODcs
         NJT2WIWG5kp4+koY8xd30VrzDmA7spW6Y7QAeKODyhP7VmTt7/cvVySGYAJdDjX14AtG
         IWhTsov4HRrIrKEogP4HI2Y/ysQx+x9wowbNOsjwGZIVxKy2YWfX2AF+cs3MVozSLmPF
         PQPOSSuI3pa3jj/Z9jwTLxsZn/TAfmFvOEVMU01uxnPjOxVBNU4wjzwk5xmW30CqRkwI
         haOUQb1Vq56QIxvh4v4G8rGaHk4/atXdtw02nmodGfZZa/w9L7DNzPLSfLaXtg7m+GeQ
         hjxw==
X-Gm-Message-State: AJIora/NboCuyUB+kBkohYkvZl3V9DdUQDLMUkV+MVj910/aHPKSNNFV
        xdp6rhcQVnEBM2QZLDh6d7/s7A==
X-Google-Smtp-Source: AGRyM1tliJHoFmO91zIKb1x+tlZRG2g0W9OZrceJ0ScNd5S/3fL38+IBL2iEn9W1Zi33OoZ37mkXcw==
X-Received: by 2002:a17:90b:4b4b:b0:1e8:9e0e:c362 with SMTP id mi11-20020a17090b4b4b00b001e89e0ec362mr21692512pjb.187.1655656740057;
        Sun, 19 Jun 2022 09:39:00 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b20-20020a17090aa59400b001dd11e4b927sm8796985pjq.39.2022.06.19.09.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 09:38:59 -0700 (PDT)
Message-ID: <286b8ccc-2dc5-ed39-a38e-ad786ac29d0d@kernel.dk>
Date:   Sun, 19 Jun 2022 10:38:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 5/7] io_uring: remove ->flush_cqes optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <692e81eeddccc096f449a7960365fa7b4a18f8e6.1655637157.git.asml.silence@gmail.com>
 <1f573b6b-916a-124c-efa1-55f7274d0044@kernel.dk>
 <f42c7b8d-b144-434e-64a0-842209bdf31a@gmail.com>
 <17a15f3e-1257-3cc5-edf7-26876ca2a701@kernel.dk>
 <1b514266-94f5-aa5e-a382-18c28eecb9fc@gmail.com>
 <11f9a9b2-b6fa-cb1e-c4df-cc9201b4e61c@kernel.dk>
 <a34dfabc-69d8-406b-7696-8c3da3e9577a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a34dfabc-69d8-406b-7696-8c3da3e9577a@gmail.com>
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

On 6/19/22 10:19 AM, Pavel Begunkov wrote:
> On 6/19/22 17:17, Jens Axboe wrote:
>> On 6/19/22 10:15 AM, Pavel Begunkov wrote:
>>> On 6/19/22 16:52, Jens Axboe wrote:
>>>> On 6/19/22 8:52 AM, Pavel Begunkov wrote:
>>>>> On 6/19/22 14:31, Jens Axboe wrote:
>>>>>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>>>>>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>>>>>>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>>>>>>> high level of concurrency that enables it at least for one CQE, but
>>>>>>> sometimes it doesn't save much because nobody waiting on the CQ.
>>>>>>>
>>>>>>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>>>>>>> normal use case. Note, that there is no spurious eventfd problem with
>>>>>>> that as checks for spuriousness were incorporated into
>>>>>>> io_eventfd_signal().
>>>>>>
>>>>>> Would be note to quantify, which should be pretty easy. Eg run a nop
>>>>>> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
>>>>>> it to the extreme, and I do think it'd be nice to have an understanding
>>>>>> of how big the gap could potentially be.
>>>>>>
>>>>>> With luck, it doesn't really matter. Always nice to kill stuff like
>>>>>> this, if it isn't that impactful.
>>>>>
>>>>> Trying without this patch nops32 (submit 32 nops, complete all, repeat).
>>>>>
>>>>> 1) all CQE_SKIP:
>>>>>       ~51 Mreqs/s
>>>>> 2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
>>>>>       ~49 Mreq/s
>>>>> 3) same as 2) but another task waits on CQ (so we call wake_up_all)
>>>>>       ~36 Mreq/s
>>>>>
>>>>> And that's more or less expected. What is more interesting for me
>>>>> is how often for those using CQE_SKIP it helps to avoid this
>>>>> ev_posted()/etc. They obviously can't just mark all requests
>>>>> with it, and most probably helping only some quite niche cases.
>>>>
>>>> That's not too bad. But I think we disagree on CQE_SKIP being niche,
>>>
>>> I wasn't talking about CQE_SKIP but rather cases where that
>>> ->flush_cqes actually does anything. Consider that when at least
>>> one of the requests queued for inline completion is not CQE_SKIP
>>> ->flush_cqes is effectively disabled.
>>>
>>>> there are several standard cases where it makes sense. Provide buffers
>>>> is one, though that one we have a better solution for now. But also eg
>>>> OP_CLOSE is something that I'd personally use CQE_SKIP with always.
>>>>
>>>> Hence I don't think it's fair or reasonable to call it "quite niche" in
>>>> terms of general usability.
>>>>
>>>> But if this helps in terms of SINGLE_ISSUER, then I think it's worth it
>>>> as we'll likely see more broad appeal from that.
>>>
>>> It neither conflicts with the SINGLE_ISSUER locking optimisations
>>> nor with the meantioned mb() optimisation. So, if there is a good
>>> reason to leave ->flush_cqes alone we can drop the patch.
>>
>> Let me flip that around - is there a good reason NOT to leave the
>> optimization in there then?
> 
> Apart from ifs in the hot path with no understanding whether
> it helps anything, no

Let's just keep the patch. Ratio of skip to non-skip should still be
very tiny.

-- 
Jens Axboe

