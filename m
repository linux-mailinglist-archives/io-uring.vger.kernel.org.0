Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B20550C07
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 18:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiFSQRT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 12:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSQRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 12:17:17 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBAE64CA
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:17:16 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l4so8197180pgh.13
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=PG5W7W35N+b97eHfzluX1I+2jULNoYH6F/2Qqh7GvU0=;
        b=k1Z2LWF6YEdk37EouE7djB6pHjvzR67reiDJDiTw9T7J+4CsJNwoCBnaklQXYRjrq1
         gQ4v1YpsVZPteDDIbfASs/PMVz1DKl+cJDLyIWFjm0w1JTsqjg3O//X4qKTtOr0RfxDP
         kA0TRjrz4bhqE1ewuRdE/5sWIb9O8wiXeKtrcuR8GZXiPgIF9ZGpKaXjrOQrWYM9aYYe
         m0uuyHAXzs7GLtMNFTa7fyMH/9qBKhVF8XMQvdl+oF+TS3gucg6nttzLT7/1kfcH46nV
         NbKjXzv6azrjJDgt3n4r3gb/f4mPL8LKfFauCpklcCanwf9zP0W1B93LMqcPHiiEQt0u
         Hcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PG5W7W35N+b97eHfzluX1I+2jULNoYH6F/2Qqh7GvU0=;
        b=hwzXGftz5qc7rEGl44iUNAdAumV4uyj2hK1C06MIWCZdwdXNQKbRda8YRx1uX4GGUr
         dtlTr6WP82olpiB4HZ/D/BNU2E2WAIa5BIH4o8iQEsOIR5iij6ZvCBDSymKhHLXbWEl/
         zNnUsRn09Wx/terAp5gXU00e4mis3q486ATqs+ZIug8y9k3E56ROXR06vyrjnuMQtTXF
         7MjKZRo7SrZ/0RVdzB10xOPeScZp9cydMEHvMid4f3Ip7seocErKICSLFHxNQzLpSxQE
         VPuVEbgBDqrrnksDkOlWxB4ybrfiD7XByA6ZO14jqw9JUosIqNDqo2i5H7PC7kWd6tAZ
         BtuA==
X-Gm-Message-State: AJIora9xRqRokdxxQTwN0sNPv269+2Cjk6GG44EjajoggFAtAb7x7/Yb
        HYdKSPnG8xpIalVVTggMc2tXGJAuA7QK4g==
X-Google-Smtp-Source: AGRyM1tfBsjjKzwEhGWuL+8gi16ijwcIINc69BT1y/ndETPgSx8zYNZxuCEsBNE2OyGrjufX7SMtrg==
X-Received: by 2002:a63:5c26:0:b0:405:2650:d202 with SMTP id q38-20020a635c26000000b004052650d202mr18258833pgb.276.1655655435655;
        Sun, 19 Jun 2022 09:17:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jh20-20020a170903329400b00168b113f222sm1605901plb.173.2022.06.19.09.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 09:17:15 -0700 (PDT)
Message-ID: <11f9a9b2-b6fa-cb1e-c4df-cc9201b4e61c@kernel.dk>
Date:   Sun, 19 Jun 2022 10:17:13 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1b514266-94f5-aa5e-a382-18c28eecb9fc@gmail.com>
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

On 6/19/22 10:15 AM, Pavel Begunkov wrote:
> On 6/19/22 16:52, Jens Axboe wrote:
>> On 6/19/22 8:52 AM, Pavel Begunkov wrote:
>>> On 6/19/22 14:31, Jens Axboe wrote:
>>>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>>>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>>>>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>>>>> high level of concurrency that enables it at least for one CQE, but
>>>>> sometimes it doesn't save much because nobody waiting on the CQ.
>>>>>
>>>>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>>>>> normal use case. Note, that there is no spurious eventfd problem with
>>>>> that as checks for spuriousness were incorporated into
>>>>> io_eventfd_signal().
>>>>
>>>> Would be note to quantify, which should be pretty easy. Eg run a nop
>>>> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
>>>> it to the extreme, and I do think it'd be nice to have an understanding
>>>> of how big the gap could potentially be.
>>>>
>>>> With luck, it doesn't really matter. Always nice to kill stuff like
>>>> this, if it isn't that impactful.
>>>
>>> Trying without this patch nops32 (submit 32 nops, complete all, repeat).
>>>
>>> 1) all CQE_SKIP:
>>>      ~51 Mreqs/s
>>> 2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
>>>      ~49 Mreq/s
>>> 3) same as 2) but another task waits on CQ (so we call wake_up_all)
>>>      ~36 Mreq/s
>>>
>>> And that's more or less expected. What is more interesting for me
>>> is how often for those using CQE_SKIP it helps to avoid this
>>> ev_posted()/etc. They obviously can't just mark all requests
>>> with it, and most probably helping only some quite niche cases.
>>
>> That's not too bad. But I think we disagree on CQE_SKIP being niche,
> 
> I wasn't talking about CQE_SKIP but rather cases where that
> ->flush_cqes actually does anything. Consider that when at least
> one of the requests queued for inline completion is not CQE_SKIP
> ->flush_cqes is effectively disabled.
> 
>> there are several standard cases where it makes sense. Provide buffers
>> is one, though that one we have a better solution for now. But also eg
>> OP_CLOSE is something that I'd personally use CQE_SKIP with always.
>>
>> Hence I don't think it's fair or reasonable to call it "quite niche" in
>> terms of general usability.
>>
>> But if this helps in terms of SINGLE_ISSUER, then I think it's worth it
>> as we'll likely see more broad appeal from that.
> 
> It neither conflicts with the SINGLE_ISSUER locking optimisations
> nor with the meantioned mb() optimisation. So, if there is a good
> reason to leave ->flush_cqes alone we can drop the patch.

Let me flip that around - is there a good reason NOT to leave the
optimization in there then?

-- 
Jens Axboe

