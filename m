Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E248774EB5
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 00:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjHHWzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjHHWzL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 18:55:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7F41996
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 15:55:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bbadf9ed37so8428925ad.0
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 15:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691535309; x=1692140109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fq5/S8J1QpqhbVz+0r61Fn703VpjoVLaBkKsH4mRO14=;
        b=kMceCnbwPqduAso4KGF5sL9eSspmG4gvl7B7O2ECWFkuKrw/Kb6rSYSdGWXLbO+htA
         IG7fCtiuREpOHs4OZMKt0G0TkeqIm5m9keiENc4DPkpiP3Mf3pJthm1e6sFUp570uzjn
         WwLLf+e2g/0Xjn+gJYKfNlGFBLBZaudCw8SVjB4STr5Mu3t+5EOpPpDfHIa4JddYmBbC
         EDbt/f9W3NKuLw9hwgysKH5Qa/vEBGQ9HujIsY4zpACiR3kjyLrBvTKFMhHDij2o4Q5h
         7SHutotgWYoN9zqaLgmGEnyWRePMFZCgnDbH36aDux8tjuTSkmwGVLuLDjuIFsGhlGHs
         BoHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691535309; x=1692140109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fq5/S8J1QpqhbVz+0r61Fn703VpjoVLaBkKsH4mRO14=;
        b=ZYY50gvACd6ekJxh7SDtTKsersv+tQiuwUyyWRbExRU+005tSc7BKygSLVr+i2+Azz
         ot4IcHoQoG7VQKpH64SifhNqcBEdODNsZKvfOYMsZ/o1fHUieHpYj/KVR3gTE8FGsWRM
         FLlwIOav2diCwnaqfUXHXtUERySQTKQkUXAvS7DE7KqPRxTv3kcDvYPziYDWL2wYnI+e
         oY85qbiOhH3Z6iQ7CNS8wCFIIJ/NkXdC4AyCGwadOqhdH8KdxMnuqk5zrgtS/loDBYCq
         VqLjqyGc9P3/cjxGDaYNbZMYMSyN6b5Ueoc5SGBPYFLk+5Gz1GyebcFsBkZPVpm3kxpy
         hYCw==
X-Gm-Message-State: AOJu0YzBB9EPZj1YqisoMJf2oqO0qjG6+T2oAkCUS2mVjlSF9EEOZbpB
        BH/sknuf2xCtocu3IJaGjG1/+A==
X-Google-Smtp-Source: AGHT+IGQhrfxYYrEl6v690kg205iYI/9lt/xA1ZvgaALoPEw4FOUCnMsSbfMapzRTUij16VALh0CTw==
X-Received: by 2002:a17:903:2281:b0:1b8:85c4:48f5 with SMTP id b1-20020a170903228100b001b885c448f5mr1219880plh.2.1691535309528;
        Tue, 08 Aug 2023 15:55:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902768700b001ae0a4b1d3fsm9518846pll.153.2023.08.08.15.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 15:55:08 -0700 (PDT)
Message-ID: <5cf17fbc-103f-0bdc-edc1-2e24f24ea7d9@kernel.dk>
Date:   Tue, 8 Aug 2023 16:55:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
 <22630618-40fc-5668-078d-6cefcb2e4962@kernel.dk>
 <3aacee27-6e30-ef50-ff1f-9fc1334c8924@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3aacee27-6e30-ef50-ff1f-9fc1334c8924@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/23 3:33?AM, Hao Xu wrote:
> On 8/1/23 08:28, Jens Axboe wrote:
>> On 7/31/23 9:26?AM, Darrick J. Wong wrote:
>>> I've watched quite a bit of NOWAIT whackamole going on over the past few
>>> years (i_rwsem, the ILOCK, the IO layer, memory allocations...). IIRC
>>> these filesystem ios all have to run in process context, right? If so,
>>> why don't we capture the NOWAIT state in a PF flag? We already do that
>>> for NOFS/NOIO memory allocations to make sure that /all/ reclaim
>>> attempts cannot recurse into the fs/io stacks.
>>
>> I would greatly prefer passing down the context rather than capitulating
>> and adding a task_struct flag for this. I think it _kind of_ makes sense
>> for things like allocations, as you cannot easily track that all the way
>> down, but it's a really ugly solution. It certainly creates more churn
>> passing it down, but it also reveals the parts that need to check it.
>> WHen new code is added, it's much more likely you'll spot the fact that
>> there's passed in context. For allocation, you end up in the allocator
>> anyway, which can augment the gfp mask with whatever is set in the task.
>> The same is not true for locking and other bits, as they don't return a
>> value to begin with. When we know they are sane, we can flag the fs as
>> supporting it (like we've done for async buffered reads, for example).
>>
>> It's also not an absolute thing, like memory allocations are. It's
>> perfectly fine to grab a mutex under NOWAIT issue. What you should not
> 
> Hi Jens,
> To make sure, I'd like to ask, for memory allocation, GFP_NOIO semantics
> is all we need in NOWAIT issue, GFP_NOWAIT is not necessary, do I
> understand it right?

Yep, GFP_NOIO should be just fine.

-- 
Jens Axboe

