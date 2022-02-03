Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC2F4A9070
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 23:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355676AbiBCWHj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 17:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355674AbiBCWHj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 17:07:39 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E9EC061714;
        Thu,  3 Feb 2022 14:07:38 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j16so7635116wrd.8;
        Thu, 03 Feb 2022 14:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VgFLORR4v1ez4B6LMIcDycEWtW4pAhoVBiVCyzb5WgM=;
        b=jEgbO/JvCr5a80SQ8kHQXwPRi0hsbwshS721x37C04F+7AwLexMUIcFUW5dzoOe/n7
         S4W4thd/mlO7tzdLq17PUC4hkIo4DE0f58u6YuGPk8IFkiL2no+9ESEPcKLrxH1gp1xU
         E14lrKxHcKUoQX4hK6fhOzM2JVjN8SR1HqarJ/8zqDXutEtBK0hYrGNuKS+6HsJDFpdg
         EKAD2Ex5Y4ROhUXAHmYfS0LWrecA4DjtPDThLXae0t3RhseM2muww8uAuSdwUnyYR4dF
         VENcgl6dMlKyMl0op1IsxdL3isLhFiouSlbyjomQa9g+xrkA3BJRa+SZ/keNPxPONlmW
         +pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VgFLORR4v1ez4B6LMIcDycEWtW4pAhoVBiVCyzb5WgM=;
        b=ktGAgKaGOzjvK4y16eaCrg5euW2pbKgCqyJb4p0QIsfB0lgTJmCSjgHJg/it8IDY40
         OvTg7NMESqMBKnH951wzLXNb5QuUXCFv2N2wgWtlSdkkGqQNd+tLpJw837ELi0P2kT58
         xxhSbVNkUyEJoGFRwXgAwQb8FVv4VeVuVAcO/eRiDD62d87PMkdhhNzoVRvNQ44q/Zze
         F5nCcJeNpT7taQ6UQq0dnn74KeD/qj8NQmd5+p/I3APgjtH1lBt1ztG0Zvq6DxuXVfH+
         J5zx9825k5x6Nnl13UaPkdRGk9GFvDSMbJP2y1VDD7L23UJgpruNil7Yu1K0RBkTx/CJ
         MD4Q==
X-Gm-Message-State: AOAM532pxKtzzEgdp/s6jP7lpGCNClDPi4RF5PCHXmcynit2DzzuCL3C
        675USNq6adVA+3XcVbcn9rNFMxJ19ig=
X-Google-Smtp-Source: ABdhPJy2aEjcgSSu9zRsY2TefFfp7/7tsTwkaoZTuXWkk5rb7dHpgttAm7Aeqt7kWy34IQKbqpXx5w==
X-Received: by 2002:a5d:4d07:: with SMTP id z7mr29911584wrt.327.1643926057033;
        Thu, 03 Feb 2022 14:07:37 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id i94sm52531wri.21.2022.02.03.14.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:07:36 -0800 (PST)
Message-ID: <c9e0628b-c9ce-7866-dff9-9a44c51d82b2@gmail.com>
Date:   Thu, 3 Feb 2022 22:02:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
 <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 19:54, Usama Arif wrote:
> On 03/02/2022 19:06, Jens Axboe wrote:
>> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>>> On 2/3/22 18:29, Jens Axboe wrote:
>>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>>
>>>> They are cheap, but they are still noticeable at high requests/sec
>>>> rates. So would be best to avoid them.
>>>>
>>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>>> notification if it races with registering an eventfd descriptor. But
>>>> that's not really a concern, as if you register with inflight IO
>>>> pending, then that always exists just depending on timing. The only
>>>> thing I care about here is that it's always _safe_. Hence something ala
>>>> what you did below is totally fine, as we're re-evaluating under rcu
>>>> protection.
>>>
>>> Indeed, the patch doesn't have any formal guarantees for propagation
>>> to already inflight requests, so this extra unsynchronised check
>>> doesn't change anything.
>>>
>>> I'm still more сurious why we need RCU and extra complexity when
>>> apparently there is no use case for that. If it's only about
>>> initial initialisation, then as I described there is a much
>>> simpler approach.
>>
>> Would be nice if we could get rid of the quiesce code in general, but I
>> haven't done a check to see what'd be missing after this...
>>
> 
> I had checked! I had posted below in in reply to v1 (https://lore.kernel.org/io-uring/02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com/T/#m5ac7867ac61d86fe62c099be793ffe5a9a334976), but i think it got missed! Copy-pasting here for reference:
> 
> "
> I see that if we remove ring quiesce from the the above 3 opcodes, then
> only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is
> left for ring quiesce. I just had a quick look at those, and from what i
> see we might not need to enter ring quiesce in
> IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
> And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to

IORING_REGISTER_RESTRICTIONS and IORING_REGISTER_ENABLE_RINGS are simpler,
we can just remove quiesce (i.e. put them into io_register_op_must_quiesce())
without any extra changes.

TL;DR;
That's because IORING_SETUP_R_DISABLED prevents submitting requests
and so there will be no requests until IORING_REGISTER_ENABLE_RINGS is
called. And IORING_REGISTER_RESTRICTIONS works only before
IORING_REGISTER_ENABLE_RINGS was called.


-- 
Pavel Begunkov
