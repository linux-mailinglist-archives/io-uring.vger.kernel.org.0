Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE35644171
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 11:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiLFKow (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 05:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiLFKon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 05:44:43 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F18ECD0
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 02:44:42 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bx10so22925378wrb.0
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 02:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yTABD2v3hrbf6yaASfySTzw03w3yieo5DaSUTcLGsA0=;
        b=Zmt+R3Q+RXaoqTX4HP+Xc/u4txGVFO78XiOnXuvSOMmp1sCk5lk7m7W00Kk0OpPKDr
         SNurxQm5edYTERycxQVljvGgg2gXrqvG1Zb6ZLWCcPbjOZ12kCE2E+/lX3SHD6UFISLx
         mF9tTUvpcoxiBJgZiz8SS70B0PtL01yZOCNhGW5B8cLdWVLB/I1++TDqh6VTcfCGngum
         NzTcPZNHdWtB3uamJKcI1bo1YYQ/EBJTVXnkowD9aQDz0klbKV/X+yYRHUBwJWhk3WHD
         HmrHI+z2yZsYH3cV+gPV+y0KInQ7FJKuGXlAZyp2hjvvVZQp6SJE5pbQkRoxer3QwE6m
         4/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTABD2v3hrbf6yaASfySTzw03w3yieo5DaSUTcLGsA0=;
        b=qiTyprhPYNH+8KHhlZKl1nObTRzh1wtGnvKNMSNwFYEAh++Si06M/G3ZZSsn8EZ5K5
         dcJxK/lihXVjibojme2c3TDccfg/PvOq0aVwKC2Kt1dSfKotyqXYBkWnzAaS9t90luwF
         AOHKntNDxgSYLq6OEb8ZdFK5hOiIEke2JIwPwF8y+Z9GAqY0VM6y1VVx2kn86dgWdD5U
         uhGYA5VoXXCKgioujy0MxhHq0jkSBon3MPjuMk3qxZS1zn9mrPaVJm15pKAsZJmFqWhz
         Ts+qZsFobMl+SpgX+7WyXf+uUboG/6Lh5eDyFT0qc+YRUvJDJBU+6U056jTTGbpTXZjg
         FkbQ==
X-Gm-Message-State: ANoB5pm9tvhdyYFBd/JZMo1BfL2+SXVlOpOHZd90bKtCuJhezdsR6+Jy
        zbAsM8BorRQ1RlLgRN427y0=
X-Google-Smtp-Source: AA0mqf4Fa0/eCWqhS2GSRLAkU0pdAqgX98hmbIavsTbC1UYgRK49zjz3XvvEke+mb+Kg0Wpsc/ArFQ==
X-Received: by 2002:a05:6000:1e12:b0:242:1522:249b with SMTP id bj18-20020a0560001e1200b002421522249bmr12182213wrb.326.1670323480763;
        Tue, 06 Dec 2022 02:44:40 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:1f2a])
        by smtp.gmail.com with ESMTPSA id o29-20020adfa11d000000b0024278304ef6sm1181945wro.13.2022.12.06.02.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 02:44:40 -0800 (PST)
Message-ID: <03be41e8-fafd-2563-116c-71c52a27409f@gmail.com>
Date:   Tue, 6 Dec 2022 10:42:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
 <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
 <d64021e26df111c20c7e194627abf5c526636b73.camel@fb.com>
 <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bc83f604-bdde-e86e-9d12-dfc6aa0a91af@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/5/22 15:18, Jens Axboe wrote:
> On 12/5/22 8:12?AM, Dylan Yudaken wrote:
>> On Mon, 2022-12-05 at 04:53 -0700, Jens Axboe wrote:
>>> On 12/4/22 7:44?PM, Pavel Begunkov wrote:
>>>> We want to limit post_aux_cqe() to the task context when -
>>>>> task_complete
>>>> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to
>>>> another
>>>> thread. Instead of trying to invent a new delayed CQE posting
>>>> mechanism
>>>> push them into the overflow list.
>>>
>>> This is really the only one out of the series that I'm not a big fan
>>> of.
>>> If we always rely on overflow for msg_ring, then that basically
>>> removes
>>> it from being usable in a higher performance setting.
>>>
>>> The natural way to do this would be to post the cqe via task_work for
>>> the target, ring, but we also don't any storage available for that.
>>> Might still be better to alloc something ala
>>>
>>> struct tw_cqe_post {
>>> ????????struct task_work work;
>>> ????????s32 res;
>>> ????????u32 flags;
>>> ????????u64 user_data;
>>> }
>>>
>>> and post it with that?

What does it change performance wise? I need to add a patch to
"try to flush before overflowing", but apart from that it's one
additional allocation in both cases but adds additional
raw / not-batch task_work.

>> It might work to post the whole request to the target, post the cqe,
>> and then return the request back to the originating ring via tw for the
>> msg_ring CQE and cleanup.
> 
> I did consider that, but then you need to ref that request as well as
> bounce it twice via task_work. Probably easier to just alloc at that
> point? Though if you do that, then the target cqe would post later than
> the original. And potentially lose -EOVERFLOW if the target ring is
> overflown...

Double tw is interesting for future plans, but yeah, I don't think
it's so much of a difference in context of this series.

-- 
Pavel Begunkov
