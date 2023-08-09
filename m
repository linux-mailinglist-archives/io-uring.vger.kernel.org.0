Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259D977654E
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjHIQpm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjHIQpm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:45:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047F21BF2
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:45:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-686f6231bdeso1820552b3a.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691599540; x=1692204340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fWPKgkPD2NApId8xAMwR5FJ9kwbAbO40jZgA/kxOPXw=;
        b=xiZQdRUMzTPeshTAGUCQLm71pGlwG66tm90kWG1wNVdvxVbSSeZKoYp8ya8uKdQgJj
         YD3zbUYdow9V8KDGVxi6V5rfM1uK+bitg9oAfomuVGVgbf7fNV1N2kpUy0KRbgD/1guf
         Hz7wVDRWhoiiN8W2VG8oZ2UuSbkRBwLF+eFqI0Mfmck/SzIVDiS2sK21wdgxtfLoiQAA
         xKzKjov3DuUI+ayU9saBx3Q6as8aU/rUXnZaqopfgn9jzoyfnIKPrwQE2a0ieH4GQPq7
         9g27h/OWDPqhePzXLqdkt7ezzJCGwtSLt5Fhg0kHpFxmVuzeQJFR8NmkEeoVLqBRtjNY
         nmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691599540; x=1692204340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWPKgkPD2NApId8xAMwR5FJ9kwbAbO40jZgA/kxOPXw=;
        b=HFbETyMb93SjgSmW4vvolrusxi+yYDn+FHA1A8IKM9zPYjHHjfPpn10RTU6I9A/6j2
         6XmWqRzokA2MisK5NChk5p7jLDuEjzf6sO33pMp1pdOtQiepGCExj4ST6T5MDrqIAzdQ
         nuESVoPn8l+u3q4XJg2Xu9S+Pen0khSunVpftOaTOGEn+0SORFyd2UomgF8aj6PQJ3FR
         m3TdFJFf7hlY03P9i3JQ8Medxu4dHbnx2aHuJY+0GsbTUIUkI23jDSKjP9lUT85p9w4D
         22FZo3YbPKZ0S3GpNj5Wgxx184TJBC8h84wZ8doJ2SprJmqKuywkq8ZD0D0aJHPkAZDT
         r0ng==
X-Gm-Message-State: AOJu0YyVrJVU7DhtSkCBAAwj4iGVMuqLKlz1RAmCnXKJnAEqRN36M3+u
        Alw3XPcpEf54YhG0Psm1SrKQjw==
X-Google-Smtp-Source: AGHT+IEx0Ytt+kxAQ4OV01aL6Ii+J3q3POJQTrecEBmqnYI9oFnRd9t3jwQGaxAckeHmgbmQxmHCmg==
X-Received: by 2002:a05:6a00:1d23:b0:676:2a5c:7bc5 with SMTP id a35-20020a056a001d2300b006762a5c7bc5mr3500680pfx.1.1691599540439;
        Wed, 09 Aug 2023 09:45:40 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a62ed06000000b006833bcc95b0sm10186888pfh.115.2023.08.09.09.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:45:39 -0700 (PDT)
Message-ID: <cf604127-3d18-4613-a395-84e6a1b0afa9@kernel.dk>
Date:   Wed, 9 Aug 2023 10:45:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring
 system-wide
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>, Jeff Moyer <jmoyer@redhat.com>
Cc:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        asml.silence@gmail.com, corbet@lwn.net, akpm@linux-foundation.org,
        keescook@chromium.org, ribalda@chromium.org, rostedt@goodmis.org,
        jannh@google.com, chenhuacai@kernel.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com, evn@google.com, poprdi@google.com,
        jordyzomer@google.com, krisman@suse.de
References: <20230630151003.3622786-1-matteorizzo@google.com>
 <20230630151003.3622786-2-matteorizzo@google.com>
 <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de>
 <x49fs5awiel.fsf@segfault.boston.devel.redhat.com>
 <20230809150945.abp755qafjhxbmx6@awork3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230809150945.abp755qafjhxbmx6@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 9:09 AM, Andres Freund wrote:
> Hi,
> 
> Sorry for the delayed response, EINBOXOVERFLOW.
> 
> On 2023-07-26 16:02:26 -0400, Jeff Moyer wrote:
>> Andres Freund <andres@anarazel.de> writes:
>>
>>> Hi,
>>>
>>> On 2023-06-30 15:10:03 +0000, Matteo Rizzo wrote:
>>>> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
>>>> or 2. When 0 (the default), all processes are allowed to create io_uring
>>>> instances, which is the current behavior. When 1, all calls to
>>>> io_uring_setup fail with -EPERM unless the calling process has
>>>> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
>>>> regardless of privilege.
>>>
>>> Hm, is there a chance that instead of requiring CAP_SYS_ADMIN, a certain group
>>> could be required (similar to hugetlb_shm_group)? Requiring CAP_SYS_ADMIN
>>> could have the unintended consequence of io_uring requiring tasks being run
>>> with more privileges than needed... Or some other more granular way of
>>> granting the right to use io_uring?
>>
>> That's fine with me, so long as there is still an option to completely
>> disable io_uring.
> 
> Makes sense.
> 
> 
>>> ISTM that it'd be nice if e.g. a systemd service specification could allow
>>> some services to use io_uring, without allowing it for everyone, or requiring
>>> to run services effectively as root.
>>
>> Do you have a proposal for how that would work?
> 
> I think group based permissions would allow for it, even if perhaps not in the
> most beautiful manner. Systemd can configure additional groups for a service
> with SupplementaryGroups, so adding a "io_uring" group or such should work.

I'm going to drop the original patch until we work out a scheme that
everybody is happy with, and that is flexible enough.

-- 
Jens Axboe

