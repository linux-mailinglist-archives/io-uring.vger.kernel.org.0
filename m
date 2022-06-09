Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5497354501F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiFIPGe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 11:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiFIPG0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 11:06:26 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D22823ED
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 08:06:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u23so38474616lfc.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jun 2022 08:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=raEvZkK9yVRe4ZvotPm4rs+VlUPCqHdGyTgcRCfaNSk=;
        b=d3eM1T7+rsbqPMQi5UKoYgBQNYw8gbt1nfmPo+eYD8UOXVvI0eviB15fXayaoQNxT8
         oXDYuE+Ixd8icq8kF0fcBzMlzMPfANQyOBeeqkemdWefGwN3QLlrEZluOMUudcWBVRmm
         FD0WVFhNEAjWFsII84sFwnJ/XMrdjBVvggmlRMuEyFfb48TzDLXb7brWWaDNdK5ar/bK
         LulETZuYXCBJFEBWymi78fJa4uzW9NwDEWvpFg3bvXI+UjKSskp96sNY+GVR6zFiGcU0
         /SEUa0+tYU+p650ze1aXbJcSOlhst7kxz62zzoCQY+/6+90Db+yO3BsYzM5v68nzR5wi
         mpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=raEvZkK9yVRe4ZvotPm4rs+VlUPCqHdGyTgcRCfaNSk=;
        b=b7QSW1WMjZ3EswQS2iDy/+sXfs7SHrUXHdqJBVDlfUNIONqSmfF9mByRrVECHa0SOR
         RuvP/brMG+Cv/gwe0f4H6nL4DqQdDcg0AxGb+rtPEFpSbpUcZ01Pa3nOg2Vom/ZuzkF1
         M2fL1v4yFnc8tm0wBbe8Rvb43smJ0WKg8BaZjcfq1eYK0+WHWtKqOXy1JPx6R1PGDGod
         9zIb0Q3bdpR3N0NAiIhqmvsD54O9QETNY0Ztfgg3E4aLPmd4DKnnaRMt4nN0MJon6zAT
         AF5E56x+HaguayxTjXSKDfdCWfwm40WFVo/qtYukXrLKmuSDwkPbLXoa7pL4j1WBs+S9
         FfLw==
X-Gm-Message-State: AOAM533YF7VUIBHTxCRxqFVWs/l1rMn/i4mVo6C6Krbh84tZNlHM2ML8
        H/xXWBT4nAxZCqxFIpnPLQqjMg==
X-Google-Smtp-Source: ABdhPJyGLlGyAehwilCYwqOFdeN54FGL7em1ZhxGKFsBdcBSVip+aoadvAXqLI8j+hDM2QJSmYKkVQ==
X-Received: by 2002:a05:6512:c04:b0:478:f837:d813 with SMTP id z4-20020a0565120c0400b00478f837d813mr26188230lfu.17.1654787182907;
        Thu, 09 Jun 2022 08:06:22 -0700 (PDT)
Received: from [192.168.172.199] (176-20-186-40-dynamic.dk.customer.tdc.net. [176.20.186.40])
        by smtp.gmail.com with ESMTPSA id w23-20020a2e1617000000b00253ebd8805bsm3719785ljd.24.2022.06.09.08.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 08:06:22 -0700 (PDT)
Message-ID: <78e3cf67-a3f2-0ca3-4b83-27aa738c3b20@kernel.dk>
Date:   Thu, 9 Jun 2022 09:06:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
 <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
 <ed5b8a0a-d312-1181-c6b4-95fd126ea9e9@linux.dev>
 <8ec6116d-39cd-ed6c-3477-9165d1a27128@kernel.dk>
 <e4f72c36-b56a-5760-1e42-bf16304b1bd7@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e4f72c36-b56a-5760-1e42-bf16304b1bd7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 4:32 AM, Hao Xu wrote:
> On 6/9/22 18:19, Jens Axboe wrote:
>> On 6/9/22 4:14 AM, Hao Xu wrote:
>>> On 6/9/22 18:06, Jens Axboe wrote:
>>>> On 6/9/22 1:53 AM, Hao Xu wrote:
>>>>> Hi all,
>>>>> I haven't done tests to demonstrate it. It is for partial io case, we
>>>>> don't consume/release the buffer before arm_poll in ring-mapped mode.
>>>>> But seems we should? Otherwise ring head isn't moved and other requests
>>>>> may take that buffer. What do I miss?
>>>>
>>>> On vacation this week, so can't take a look at the code. But the
>>>> principle is precisely not to consume the buffer if we arm poll, because
>>>> then the next one can grab it instead. We don't want to consume a buffer
>>>> over poll, as that defeats the purpose of a provided buffer. It should
>>>> be grabbed and consumed only if we can use it right now.
>>>>
>>>> Hence the way it should work is that we DON'T consume the buffer in this
>>>> case, and that someone else can just use it. At the same time, we should
>>>> ensure that we grab a NEW buffer for this case, whenever the poll
>>>
>>> If we grab a new buffer for it, then we have to copy the data since we
>>> have done partial io...this also defeats the purpose of this feature.
>>
>> For partial IO, we never drop the buffer. See the logic in
>> io_kbuf_recycle(). It should be as follows:
> 
> Yea, in io_kbuf_recycle(), if it's partial io, we just return. For
> legacy mode, this means we keep the buffer. For ring-mapped mode, this
> means we then release the uring_lock without moving the ring->head,
> and then other requests may take that buffer which is in use..
> And next time we do (for example) recv(), we lost the data which we got
> at the previous time.
> Do I miss something?

If we don't commit for ring mapped buffers, then yeah that's definitely
a bug. Please send a fix :-)

Pavel can take care of it this week.

-- 
Jens Axboe

