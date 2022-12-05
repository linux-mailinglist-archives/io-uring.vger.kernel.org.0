Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10A7642B44
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 16:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiLEPTJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Dec 2022 10:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLEPSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Dec 2022 10:18:44 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4375D12083
        for <io-uring@vger.kernel.org>; Mon,  5 Dec 2022 07:18:43 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so11755604pjd.5
        for <io-uring@vger.kernel.org>; Mon, 05 Dec 2022 07:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Szp24HOMzPoiGQ4BSX7m574iUR6RH29idrxwSk0ZbYA=;
        b=KVZjZs00oLLG0wM9hD6pe9mzElhwptMQlZdTFbVs7YhS7MH4teKnATVWfNlv61muxB
         iZMvag3MIvgXEtfv5/cG2HVGcndgi2JY4C7yT9mBxAdpKbExxwtLbDOp3AgYDwPc1k0X
         yOw4yIapU85g2lzQCaFDKXyP+putijoF/4W2WZc3plbPykTETzXuQrrx/RU8DjFloTWd
         yuLzxOu3XpfMxD2aJU3QqevAT32ggyz2nX7hYq2tKKhaNBPD7Ogv1h3x9Tj8ALXXxQjO
         QzIwci7pWLU9PIJnaGoTzA3UnyYXZ7h92dn9lBoc1d/S7WCcj5x3DgybF4hGZe9DwFyz
         jqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Szp24HOMzPoiGQ4BSX7m574iUR6RH29idrxwSk0ZbYA=;
        b=nYxJfnxUgE6H6SNasEipXaIQ+gkK4x0STKFZtXi2gKsOtlDcVIY23VX3GUNteRzsbo
         b7AuOcEPqiedW0z5WVQ8+kb+4jPnTbHa4yf3yEAvJJIVpB1jIim8UWOW21fjOkP5/shX
         rG3/5yNRSlyh+eX6hEe84+cdUhRwXVuG57dS7bsVEE/p7Ie2RZaqiK7puGvCW4TLS3aH
         xwshhe5INyanOtzJd58FL23llyv5CHaKCq0+46/I3CPJ/JVE3j2X9DVNf7M4iFPQRru7
         +GZX8ID/Pv3wQ486IO0AJbgcNQpYgezyPRANABlQUOkqJ+Mkv/ZLXpPt911+vzfAZJjk
         Bdsg==
X-Gm-Message-State: ANoB5pnjK3RRcqFYaIcP/JIMgUDKW5RCYMAtSgvbvHTxUx5E2VwfiCoF
        PPiELz8S2itKTwhcEpiQerLwbg==
X-Google-Smtp-Source: AA0mqf5soJtvNKH35kKfFrYPJLYVdPpXBn9TRYNaBN41uR4Qnkc1TPUhZHRrdJ7ApCu+9g1+KeajUg==
X-Received: by 2002:a17:903:495:b0:189:911a:6b57 with SMTP id jj21-20020a170903049500b00189911a6b57mr37204072plb.110.1670253522570;
        Mon, 05 Dec 2022 07:18:42 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y14-20020a655a0e000000b0047712e4bc51sm8453033pgs.55.2022.12.05.07.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 07:18:42 -0800 (PST)
Message-ID: <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
Date:   Mon, 5 Dec 2022 08:18:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
 <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
 <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/5/22 8:12?AM, Dylan Yudaken wrote:
> On Mon, 2022-12-05 at 04:53 -0700, Jens Axboe wrote:
>> On 12/4/22 7:44?PM, Pavel Begunkov wrote:
>>> We want to limit post_aux_cqe() to the task context when -
>>>> task_complete
>>> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to
>>> another
>>> thread. Instead of trying to invent a new delayed CQE posting
>>> mechanism
>>> push them into the overflow list.
>>
>> This is really the only one out of the series that I'm not a big fan
>> of.
>> If we always rely on overflow for msg_ring, then that basically
>> removes
>> it from being usable in a higher performance setting.
>>
>> The natural way to do this would be to post the cqe via task_work for
>> the target, ring, but we also don't any storage available for that.
>> Might still be better to alloc something ala
>>
>> struct tw_cqe_post {
>> ????????struct task_work work;
>> ????????s32 res;
>> ????????u32 flags;
>> ????????u64 user_data;
>> }
>>
>> and post it with that?
>>
> 
> It might work to post the whole request to the target, post the cqe,
> and then return the request back to the originating ring via tw for the
> msg_ring CQE and cleanup.

I did consider that, but then you need to ref that request as well as
bounce it twice via task_work. Probably easier to just alloc at that
point? Though if you do that, then the target cqe would post later than
the original. And potentially lose -EOVERFLOW if the target ring is
overflown...

-- 
Jens Axboe
