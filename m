Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B074FC70
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjGLA4d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjGLA4c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:56:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE5210CF
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:56:31 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-262c8746f08so856277a91.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689123391; x=1691715391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2MmQn1GYDg0hQfmn/BgjbxzoXDqG/APLCKt2WoBTnVU=;
        b=G5AzsQVCpi91WPaYhKDuY2nL5/dXUEcf274Os4x2QrcLhOFsj23C7Hh/5gTDOSQ9cX
         bVi8pSt0Df+IEJlgE5/yi4hNU413AgWWNbhUNrj4ml2BkUg6c4Awq2rtQTr2uZ0RpfYg
         yt+PHXaQaE2Vl8wGVHmLg6BZd3q7d4u+jtNeKyXuFAg10jvv1BzYZssYTGdfMqvvMi+F
         9s0Ab7D9lRqiZoN7JYpAywiLFMPn8SwQR+9VkN1Z4sEyaclort+3sB2YMM9BJduFMKvL
         JNSojAz3MXLN9i94AfX7+HmvABE0IEH0ZpIclHE4VyZxXlIb8TJTlPR3LrAqUqd+KZD1
         9OhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689123391; x=1691715391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MmQn1GYDg0hQfmn/BgjbxzoXDqG/APLCKt2WoBTnVU=;
        b=MKVaQroUI3EQT7RhAjrLWJnEVkH277LYHd8XslncJWmT8v5eSz0w0njCj/FEzOwBFt
         RolqS6E6D+LXjiGR89nePNEd6SDkFI38PPVEI9am61XXk0Fq0+k25D3imE+VR2z/TIzN
         +OfUaA2QKr0zUc1tU2YLOlVUasgsBdYREYroGJe2O1DqC2y6/h1Q35b3gEKiF8arhM4S
         CR+dai6c6kwGbhVL9m/YWyRjpQf3LoGB91TQijyY0GAFAtr3NsQ+gFvEaDpbHAvN4kUy
         r57VmB45ueZ6wpbLgf+Gs4iYg8EEH4JUQlYCzME8D8zEza6ceqSNa/e87S5U8Bi3ObP7
         +ebg==
X-Gm-Message-State: ABy/qLbD8vn155JLwFkxzKRJD8vCHquQbUEjei5dJZ5EG0s/CXyFj+If
        aMa0qgrmZIegnoKjkIWXimbo/A==
X-Google-Smtp-Source: APBJJlG+Yx5Lrtdh7SVA27f3nlxYiFVBZqvwJB3YbmhZavALkyFZPbHbRMc6vNfOmq40cXjui+tjXg==
X-Received: by 2002:a17:90a:c908:b0:262:c2a1:c029 with SMTP id v8-20020a17090ac90800b00262c2a1c029mr16242787pjt.2.1689123391097;
        Tue, 11 Jul 2023 17:56:31 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id cp9-20020a17090afb8900b00256a4d59bfasm8757624pjb.23.2023.07.11.17.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 17:56:30 -0700 (PDT)
Message-ID: <26b22ded-d6bc-97d6-75d8-22ff778d66ac@kernel.dk>
Date:   Tue, 11 Jul 2023 18:56:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 0/3] io_uring getdents
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Dave Chinner <david@fromorbit.com>, Hao Xu <hao.xu@linux.dev>,
        io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
 <5264f776-a5fd-4878-1b4c-7fe9f9a61b51@kernel.dk>
 <ZK35dZN7pYg0VuF0@codewreck.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZK35dZN7pYg0VuF0@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 6:53 PM, Dominique Martinet wrote:
> Jens Axboe wrote on Tue, Jul 11, 2023 at 05:51:46PM -0600:
>>> So what filesystem actually uses this new NOWAIT functionality?
>>> Unless I'm blind (quite possibly) I don't see any filesystem
>>> implementation of this functionality in the patch series.
> 
> I had implemented this for kernfs and libfs (so sysfs, debugfs, possibly
> tmpfs/proc?) in v2
> 
> The patch as of v2's mail has a bug, but my branch has it fixed as of
> https://github.com/martinetd/linux/commits/io_uring_getdents
> 
> (I guess these aren't "real" enough though)

No, I definitely think those are real and valid. But would be nice with
a "real" file system as well.

>>> I know I posted a prototype for XFS to use it, and I expected that
>>> it would become part of this patch series to avoid the "we don't add
>>> unused code to the kernel" problem. i.e. the authors would take the
>>> XFS prototype, make it work, add support into for the new io_uring
>>> operation to fsstress in fstests and then use that to stress test
>>> the new infrastructure before it gets merged....
>>>
>>> But I don't see any of this?
>>
>> That would indeed be great if we could get NOWAIT, that might finally
>> convince me that it's worth plumbing up! Do you have a link to that
>> prototype? That seems like what should be the base for this, and be an
>> inspiration for other file systems to get efficient getdents via this
>> (rather than io-wq punt, which I'm not a huge fan of...).
> 
> the xfs poc was in this mail:
> https://lore.kernel.org/all/20230501071603.GE2155823@dread.disaster.area/
> 
> I never spent time debugging it, but it should definitely be workable

If either you or Hao wants to take a stab at it and see how it goes,
I think that would be hugely beneficial for this patchset.

-- 
Jens Axboe


