Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15B05E7D3B
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiIWOfa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiIWOfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:35:23 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C5303E6
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:35:19 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id g6so244536ild.6
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=OihChKAFYM3FhSFcvMrlTupQ9P1jq+k/g/MdKxicsSA=;
        b=RBN8KhwfPu5SktAbEcKBl/kzDnopi4XQp3s7DlIHNkuN4WvGla5o4YgYSYjQDMUltp
         ArPSATxhlp/2nmaOAFZHzb3ORmnuVfOD26uPpv+glGAtRslqkSseHsJ2ZBCmf41nrz27
         XqD/7RwsSmoBDkFuWmYF4pcA8u4CC42YydHJBBfagVkpbMX09KfwFz+Pv05UpeT1F2L8
         tUxp83NyxrM6J/MdN+x83F75yw7kgSIqKe//ntLWquVPuwBVxhhIrvjwTUODk1GZSwsh
         VaWltedv8Z+b7W8WXmFnHaVcNjOS6L3uTbA0PBoVJqLi/ZxDK55c+OKSNFlTqiM5451V
         Teyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OihChKAFYM3FhSFcvMrlTupQ9P1jq+k/g/MdKxicsSA=;
        b=4V0Ybs4HxlSYN+7LRicsczd9BKYpdzg4nzJh8Bhm68uohuBBSB5KjDKcmpmgFHxscd
         I/h226dOpvXrTsD1KtBfEQy8g8RchaxsgnWAdv36sgHU21DbV4skW50LxCQ5Qunz7XmN
         lJDxasbu0AdE7STttvDXdcldFUeMC65mZaOcXv0yhfyiSeOzoDwdi+DAHQdN+SW/ykIB
         W5aCl47SEZMdunFQPEAfvwUd17sFmz0JiR5sUcpoW0NmGHPox+AkbBxWIJDX3OLaqynY
         WtjDrEsxfx6cUk8Xfir89/+gU6RfgbnZFaBO9+4XGtSvTqXHlfADiS0/WjlHubDkNIDW
         d6wQ==
X-Gm-Message-State: ACrzQf3vbUA2GkoBTBk5J2iXdbVmIQeTTaWvwc+4h4u0n73N/0jNUoy8
        EIiaTfn5fO5d/LPGLHDMze/TwBEzUjkygQ==
X-Google-Smtp-Source: AMsMyM5LcAeWt9NWkGDpuoSOa7AlocdXSCdxltGqqcLkjGFPBioXEel1JDpqT/xE882rCr/ZAcoj4g==
X-Received: by 2002:a05:6e02:1bcf:b0:2f6:a41b:cc11 with SMTP id x15-20020a056e021bcf00b002f6a41bcc11mr4073537ilv.103.1663943718963;
        Fri, 23 Sep 2022 07:35:18 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f15-20020a056602088f00b006896f36afecsm3585236ioz.15.2022.09.23.07.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:35:18 -0700 (PDT)
Message-ID: <4bf24140-ddbf-f6ea-22c9-42d754e96cec@kernel.dk>
Date:   Fri, 23 Sep 2022 08:35:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
 <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
 <56c084c9-8920-dfa6-74d7-9b0ff8423b67@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <56c084c9-8920-dfa6-74d7-9b0ff8423b67@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 8:26 AM, Pavel Begunkov wrote:
> On 9/23/22 15:19, Jens Axboe wrote:
>> On 9/23/22 7:53 AM, Pavel Begunkov wrote:
>>> Overflowing CQEs may result in reordeing, which is buggy in case of
>>> links, F_MORE and so.
>>>
>>> Reported-by: Dylan Yudaken <dylany@fb.com>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 12 ++++++++++--
>>>   io_uring/io_uring.h | 12 +++++++++---
>>>   2 files changed, 19 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index f359e24b46c3..62d1f55fde55 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>>         io_cq_lock(ctx);
>>>       while (!list_empty(&ctx->cq_overflow_list)) {
>>> -        struct io_uring_cqe *cqe = io_get_cqe(ctx);
>>> +        struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
>>>           struct io_overflow_cqe *ocqe;
>>>             if (!cqe && !force)
>>> @@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
>>>    * control dependency is enough as we're using WRITE_ONCE to
>>>    * fill the cq entry
>>>    */
>>> -struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>>> +struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
>>>   {
>>>       struct io_rings *rings = ctx->rings;
>>>       unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>>>       unsigned int free, queued, len;
>>>   +    /*
>>> +     * Posting into the CQ when there are pending overflowed CQEs may break
>>> +     * ordering guarantees, which will affect links, F_MORE users and more.
>>> +     * Force overflow the completion.
>>> +     */
>>> +    if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
>>> +        return NULL;
>>
>> Rather than pass this bool around for the hot path, why not add a helper
>> for the case where 'overflow' isn't known? That can leave the regular
>> io_get_cqe() avoiding this altogether.
> 
> Was choosing from two ugly-ish solutions, but io_get_cqe() should be
> inline and shouldn't really matter, but that's only the case in theory
> though. If someone cleans up the CQE32 part and puts it into a separate
> non-inline function, it'll be actually inlined.

Yes, in theory the current one will be fine as it's known at compile
time. In theory... Didn't check if practice agrees with that, would
prefer if we didn't leave this to the compiler. Fiddling some other
bits, will check in a bit if I have a better idea.

-- 
Jens Axboe


