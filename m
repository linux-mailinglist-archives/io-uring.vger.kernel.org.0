Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E23550BF8
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 17:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiFSPwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 11:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFSPwm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 11:52:42 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16207BC94
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 08:52:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so653205pju.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 08:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qVw/Mgy7KgFWxkDBLizJc4HJi+GgqJlEVI/r8pZDQhY=;
        b=GaFXenPm8wXq9iBdZjPLIZAasAmbBTHu83xz05nuiqGH5Rp4q5i6CxoyeakDWgHEKQ
         SRqjf5lqSPnU7vVvU7aaGCflo4lTPfKUa9LhyAAiOT1kcKBWaxHMPMW5q9YKuec+9vQ/
         CuOMBKc3Z97fHV8eSRavMeItSVCkBUSc1DHrinQBtWrK+HrvSrW2I377R9svApmDAxqr
         LOqoSHvPRSdL+LcSL1F9SQEqSLC2oe29y3Ej4/MpZbHcVhJeJRV/pPbZzvIPXbj5fHtp
         Y/VXgBgvH+lzIxTrnb1AjDb0mJNgFJczi3QPMJoVx1sl0+nTGmlwJBFC8R/nVm8SdGwD
         cFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qVw/Mgy7KgFWxkDBLizJc4HJi+GgqJlEVI/r8pZDQhY=;
        b=susEEZw8Fyb3AGqRTu90dhcyTYVKyXWdxzHA2/I8MxIx7kYnbaDt2uynj69RW3FzRn
         VrQN1Kl7EOlrFGXHXzzH94wmaFxz/EpbYVDfWAXZ4tupFd8w2R6w4aFeOwMYcvnpBmk4
         6qCBVGX7Sz35xk+iXP4xszn+AIsbpXq+Rie14K8HkQwXafHGsrH1PLYRBaL2W3GjNXhq
         ZOWwt7utZiGdtaLAsqwdpv9UinGZS0xTuSkdZCt7UQ+DDHiF96kUzrBsh0nnECq9ZxEa
         Smqym3X8k49GWfg+J9INaYk2lkcBJ0XIn6k+k1YNukIHuL9kdGdLQr92zF5r6k6dngzZ
         nX7w==
X-Gm-Message-State: AJIora//cTv2AGFpA9OckRb3G9BKfIedBOSMrf3NI0SlzebkuJxuUm8a
        FpJcjPCbI+wgkM1MFY15Q6nO2+bsdfUWZA==
X-Google-Smtp-Source: AGRyM1sTt6cnR+LGgbJeEAGlBRWTDEQp9OqVTsTV8k9ZLaaOrXgPcMdM8MGORMnk4tM8yz+JZRVoRA==
X-Received: by 2002:a17:902:9301:b0:16a:1c68:f8d6 with SMTP id bc1-20020a170902930100b0016a1c68f8d6mr3531763plb.72.1655653961470;
        Sun, 19 Jun 2022 08:52:41 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903028100b0015e8d4eb24fsm6922755plr.153.2022.06.19.08.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 08:52:41 -0700 (PDT)
Message-ID: <17a15f3e-1257-3cc5-edf7-26876ca2a701@kernel.dk>
Date:   Sun, 19 Jun 2022 09:52:40 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f42c7b8d-b144-434e-64a0-842209bdf31a@gmail.com>
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

On 6/19/22 8:52 AM, Pavel Begunkov wrote:
> On 6/19/22 14:31, Jens Axboe wrote:
>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>> It's not clear how widely used IOSQE_CQE_SKIP_SUCCESS is, and how often
>>> ->flush_cqes flag prevents from completion being flushed. Sometimes it's
>>> high level of concurrency that enables it at least for one CQE, but
>>> sometimes it doesn't save much because nobody waiting on the CQ.
>>>
>>> Remove ->flush_cqes flag and the optimisation, it should benefit the
>>> normal use case. Note, that there is no spurious eventfd problem with
>>> that as checks for spuriousness were incorporated into
>>> io_eventfd_signal().
>>
>> Would be note to quantify, which should be pretty easy. Eg run a nop
>> workload, then run the same but with CQE_SKIP_SUCCESS set. That'd take
>> it to the extreme, and I do think it'd be nice to have an understanding
>> of how big the gap could potentially be.
>>
>> With luck, it doesn't really matter. Always nice to kill stuff like
>> this, if it isn't that impactful.
> 
> Trying without this patch nops32 (submit 32 nops, complete all, repeat).
> 
> 1) all CQE_SKIP:
>     ~51 Mreqs/s
> 2) all CQE_SKIP but last, so it triggers locking + *ev_posted()
>     ~49 Mreq/s
> 3) same as 2) but another task waits on CQ (so we call wake_up_all)
>     ~36 Mreq/s
> 
> And that's more or less expected. What is more interesting for me
> is how often for those using CQE_SKIP it helps to avoid this
> ev_posted()/etc. They obviously can't just mark all requests
> with it, and most probably helping only some quite niche cases.

That's not too bad. But I think we disagree on CQE_SKIP being niche,
there are several standard cases where it makes sense. Provide buffers
is one, though that one we have a better solution for now. But also eg
OP_CLOSE is something that I'd personally use CQE_SKIP with always.

Hence I don't think it's fair or reasonable to call it "quite niche" in
terms of general usability.

But if this helps in terms of SINGLE_ISSUER, then I think it's worth it
as we'll likely see more broad appeal from that.

-- 
Jens Axboe

