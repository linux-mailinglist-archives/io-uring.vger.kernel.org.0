Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B4A645DC6
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 16:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLGPmH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 10:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLGPmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 10:42:06 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E27960B7B
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 07:42:05 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q190so6882117iod.10
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 07:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R1z23SEckSv1zAsMOUmjhNC3ejnWKZJnfGxVqTHjZHc=;
        b=RBMHDrUbLQtYXYchaQQN8KSte+Q1e9O7HY8FXosNJv+pftwh41fvQvl9x32njRwhSU
         BjkGxX3kzgrKkQKOnWUs1OfOi4Zxoict39VBUQAErMZSlZceedO5/3HTZFeQb2B/zCfB
         DUfSwTTvT8KS37B3taRDGXomfMkZ8+U517sDC3C6eCtfEDsb/RRfQWgeKcguW3epi5Ev
         xeJUN7gJCQU+CY5HE4N4mKA9OAs/fFTPMhUKYOsasqZxRI1MkeupU2sZaUcCm+hSbcux
         nYBKAAccPTNN3B7mH6bR0aYi1r6XaC21bCyQfmF62Rgbsu89bXFXPkq9cQ/D1DJ5Vf7k
         ssRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R1z23SEckSv1zAsMOUmjhNC3ejnWKZJnfGxVqTHjZHc=;
        b=iUXTRfr6rK/HbxEqUC2KHTqgOAOw1La0Z4Omn+QWrHPgFFmyyBpOtVmJw1rw9ajiYX
         Y+cLoJJ+PZ/UiybFHwTvlYGbg9uq33gYHOHOS4CHr43wbpd7jzvZq1B9ztm4leI185Q7
         MtkmNzk5d7Ml69tNk6MqayBsEoIJXjXHraImHj6AY1twpkFmVcc+EwHgaK2gn0Sxsy4l
         xjwfhVTGkVf8vsPyBZSOPRhZaZqiWQZNsJ28vut5aiIqd3TypnnFoCcc8Bdeiy0FUA6c
         MeMIzajTNsy2waYu/yapzWgEJMjazAxdud93Rr/ZPi2++2tsqfiv7ktwbbT9XWaGvCsq
         qoVA==
X-Gm-Message-State: ANoB5pkGgpUyQKI1IBudyYCKnXzNZvGp5VDkbN5QxDmqEZzVA0yFV3HP
        bqtPD8OPH2IGldDOUPC1/qnVMg==
X-Google-Smtp-Source: AA0mqf7f7+L9tqwa7q6Gc1QYV80loy6gShy2LgkVLQbJ8yZilEJNEI/7bWWEUnqThSA7KQzIDDVPow==
X-Received: by 2002:a02:ccdb:0:b0:38a:160a:2a86 with SMTP id k27-20020a02ccdb000000b0038a160a2a86mr12292416jaq.95.1670427724720;
        Wed, 07 Dec 2022 07:42:04 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 9-20020a920d09000000b0030249f369f7sm7035709iln.82.2022.12.07.07.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 07:42:03 -0800 (PST)
Message-ID: <d2aaa175-ca27-1d2a-0b05-05298f41a773@kernel.dk>
Date:   Wed, 7 Dec 2022 08:42:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
 <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
 <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
 <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
 <03be41e8-fafd-2563-116c-71c52a27409f@gmail.com>
 <4654437d-eb17-2832-ceae-6c45d6458006@kernel.dk>
 <63bd3dc2-b2f6-ea7c-916c-33058f35df2e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <63bd3dc2-b2f6-ea7c-916c-33058f35df2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 8:59 PM, Pavel Begunkov wrote:
> On 12/6/22 16:06, Jens Axboe wrote:
>> On 12/6/22 3:42?AM, Pavel Begunkov wrote:
>>> On 12/5/22 15:18, Jens Axboe wrote:
>>>> On 12/5/22 8:12?AM, Dylan Yudaken wrote:
>>>>> On Mon, 2022-12-05 at 04:53 -0700, Jens Axboe wrote:
>>>>>> On 12/4/22 7:44?PM, Pavel Begunkov wrote:
>>>>>>> We want to limit post_aux_cqe() to the task context when -
>>>>>>>> task_complete
>>>>>>> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to
>>>>>>> another
>>>>>>> thread. Instead of trying to invent a new delayed CQE posting
>>>>>>> mechanism
>>>>>>> push them into the overflow list.
>>>>>>
>>>>>> This is really the only one out of the series that I'm not a big fan
>>>>>> of.
>>>>>> If we always rely on overflow for msg_ring, then that basically
>>>>>> removes
>>>>>> it from being usable in a higher performance setting.
>>>>>>
>>>>>> The natural way to do this would be to post the cqe via task_work for
>>>>>> the target, ring, but we also don't any storage available for that.
>>>>>> Might still be better to alloc something ala
>>>>>>
>>>>>> struct tw_cqe_post {
>>>>>> ????????struct task_work work;
>>>>>> ????????s32 res;
>>>>>> ????????u32 flags;
>>>>>> ????????u64 user_data;
>>>>>> }
>>>>>>
>>>>>> and post it with that?
>>>
>>> What does it change performance wise? I need to add a patch to
>>> "try to flush before overflowing", but apart from that it's one
>>> additional allocation in both cases but adds additional
>>> raw / not-batch task_work.
>>
>> It adds alloc+free for each one, and overflow flush needed on the
>> recipient side. It also adds a cq lock/unlock, though I don't think that
>> part will be a big deal.
> 
> And that approach below does 2 tw swings, neither is ideal but
> it feels like a bearable price for poking into another ring.
> 
> I sent a series with the double tw approach, should be better for
> CQ ordering, can you pick it up instead? I don't use io_uring tw
> infra of a ring the request doesn't belong to as it seems to me
> like shooting yourself in the leg.

Yeah I think that's the right choice, it was just a quick hack on
my end to see if it was feasible. But it's not a good fit to use
our general tw infra for this.

-- 
Jens Axboe


