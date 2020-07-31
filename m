Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E93F233DD9
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 05:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgGaD5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 23:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgGaD5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 23:57:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3265BC061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 20:57:52 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ha11so6538968pjb.1
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 20:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FGZFpAs1Mr/q1TSVbIDW1RiYmckE6Ihjkv0RPPmRWvI=;
        b=dkaFZOXU0+LJ3Ydp0JibphmH9Wg7iD0mmAtZZgCD9DRJy5g2kxhFTufYA9umxBvpKu
         eUHwPsclyFd/EZ/g7PCW7y0MzIy1vIwG1w4nOH55SVz0Yal7/e3/72iredqUNLBn499W
         dDSSG6oUr38Ba90AnHHL+TfUa7SNsSidOrCofaNQwoTGEJNbW2l26OHih0huAZz//3Q+
         2R6cewzPO6z0fAKhpTy/5fWyDpWSSZ99PTJNYXq4453+wPJOHElu1pG3LN+x2gGqGuoS
         4tLhld6MWi07GXPBSfVSmBkgyIE6MxHc6UL2F462+YpUGyTg1LC82Ec6XDennTRfkKfK
         2dQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGZFpAs1Mr/q1TSVbIDW1RiYmckE6Ihjkv0RPPmRWvI=;
        b=bN+UHUAyIb7vmXbzN06pyznhGxhpn7qPjWJxiL2Jj3wDmiVZ4TOseUNpyBZ6BARbC1
         5vBKRerlxFsVByF+/64b3dCkJTJipvphf4pFT857jK3AY2Sn44O8j8RdveAFBUx/nzZF
         3b6A8MR553egREtBYUMuQeMfSLvbV9Zr4cNkvHLULScy4/6wAntwOQFBCbvqphtZ1D+t
         7mHbufbJpsU0jGxRBLRulgeCU04orPN9TCA7gpR1TAfeJmO8Q57Swg0FwfHu21pvD/rg
         +2l3v63yXSdRWVDyKYLJN0x68WkZ4covnKPoegue8HQA85X4moNQ1DqZb/4jXQDbEugE
         GOSw==
X-Gm-Message-State: AOAM53338De3CIvVAXgUyHSg02M4sKkOAoYFoWn4ENu3rJYt/27JvNin
        BKcrOZcNi09acTPkw1tzxoHWNGr2xKg=
X-Google-Smtp-Source: ABdhPJwr+NPBENIqZSdCl4da+AD8yZ4Ra35y9vYq/+QT1tlTVtXDBWwqMYg6QCyLrFgCOmQSwCih/Q==
X-Received: by 2002:a17:90a:c28f:: with SMTP id f15mr2239943pjt.72.1596167871304;
        Thu, 30 Jul 2020 20:57:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o8sm8161725pgb.23.2020.07.30.20.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 20:57:50 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
 <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
 <e542502e-7f8c-2dd2-053b-6e78d49b1f6a@kernel.dk>
 <ec69d835-ddca-88bc-a97e-8f0d4d621bda@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <253b4df7-a35b-4d49-8cdc-c6fa24446bf9@kernel.dk>
Date:   Thu, 30 Jul 2020 21:57:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ec69d835-ddca-88bc-a97e-8f0d4d621bda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 9:16 PM, Jiufei Xue wrote:
> 
> 
> On 2020/7/31 上午10:56, Jens Axboe wrote:
>> On 7/30/20 8:12 PM, Jiufei Xue wrote:
>>>
>>>
>>> On 2020/7/30 下午11:28, Jens Axboe wrote:
>>>> On 7/29/20 8:32 PM, Jiufei Xue wrote:
>>>>> Hi Jens,
>>>>>
>>>>> On 2020/7/30 上午1:51, Jens Axboe wrote:
>>>>>> On 7/29/20 4:10 AM, Jiufei Xue wrote:
>>>>>>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>>>>>>> supported. Add two new interfaces: io_uring_wait_cqes2(),
>>>>>>> io_uring_wait_cqe_timeout2() for applications to use this feature.
>>>>>>
>>>>>> Why add new new interfaces, when the old ones already pass in the
>>>>>> timeout? Surely they could just use this new feature, instead of the
>>>>>> internal timeout, if it's available?
>>>>>>
>>>>> Applications use the old one may not call io_uring_submit() because
>>>>> io_uring_wait_cqes() will do it. So I considered to add a new one.
>>>>
>>>> Not sure I see how that's a problem - previously, you could not do that
>>>> either, if you were doing separate submit/complete threads. So this
>>>> doesn't really add any new restrictions. The app can check for the
>>>> feature flag to see if it's safe to do so now.
>>>> Yes, new applications can check for the feature flag. What about the existing
>>>
>>> apps? The existing applications which do not separate submit/complete
>>> threads may use io_uring_wait_cqes() or io_uring_wait_cqe_timeout() without
>>> submiting the requests. No one will do that now when the feature is supported.
>>
>> Right, and I feel like I'm missing something here, what's the issue with
>> that? As far as the application is concerned, a different mechanism may be
>> used to achieve the timeout, but it should work in the same way.
>>
>> So please explain this as clearly as you can, as I'm probably missing
>> something...
>> I am sorry for the confusion. Here is an example below: 
> 
> io_uring_get_sqe
> io_uring_prep_nop
> io_uring_wait_cqe_timeout
> 
> If an existing application call io_uring_wait_cqe_timeout() after preparing
> some sqes, the older APIs will submit the requests.
> 
> However, If we reuse the existing APIs and found the feature is supported,
> we will not submit the requests.
> 
> I think we should not change the behaviors for existing APIs.

Then why not just make the sqe-less timeout path flush existing requests,
if it needs to? Seems a lot simpler than adding odd x2 variants, which
won't really be clear.

Chances are, if it's called with sq entries pending, the caller likely
wants those submitted. Either the caller was aware and relying on that
behavior, or the caller is simply buggy and has a case where it doesn't
submit IO before waiting for completions.

Hence I really don't think that's a big deal, and even arguably the right
thing to do.

-- 
Jens Axboe

