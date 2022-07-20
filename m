Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E8557B93B
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 17:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiGTPL0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiGTPLY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 11:11:24 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09E442AE5
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 08:11:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r70so13353341iod.10
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 08:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Dzh0OHfhSfTPdRD1uqG+wxzQNMPCpCHl9H/l+XFp8pA=;
        b=z3yATtngvqNDfJ8LwUm7Wh7DA9H96iiqQiJ06MziOryC56MMLPo5PgjaOX20JKAcrF
         RxaYcebq5AR4ZqZu5oZmP4WzTuwwto8nPtXNu1ciQ39UL7m5rJnz5YiU86rk1wMeQB4y
         DyOrWPldCeXByRxmX19+VN3wkOT03yoZJ2M+Tn00YVD1SD6+o3aLNWT9CMyH8AeX0zVH
         9Idt+AtYZYNvz5R8kWTNuEiYz37ZVJijp+41fqthlnRYBPX0sQC6PJ+WB7OB4LiyXf2o
         uzyEShFMwfbKCfYrJqwujCHq9mX8ZJ703kBmU9JH6J0STHr3vu79MnLwBwfYgmySwzdd
         /0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dzh0OHfhSfTPdRD1uqG+wxzQNMPCpCHl9H/l+XFp8pA=;
        b=7rDWXmrs/rxI0Ntj55Y8vRBVQc2iVTi+Y+A6LkGaOa/UvTBXtmperblatOa+SsoW5E
         RyPbnDLlzT2cPX4LOnXJihn+fgAXJRcTfKux3Yjp5WgLf/joA51nE6mZ/GJtsHrfp1zv
         8aTzKWzQN9ZaMdx9JIRvwevDgyvTKLBm5qF7Itps4VbRnsCpNC0dtW5Vf0GHx3A8WUtT
         Tn/Wi/g5u67fjLWviWRjA4JUiEn6q67u0B4JGLqsz2cNbTfUhKNUxWKX/a7L/pckULdV
         3V2zGZpkQlDMDEMzGGcwOJfObMgpJyWDAa2JT71pIW2pRJE0+cL0ZEcQX6YYCO6IAC+G
         2KnQ==
X-Gm-Message-State: AJIora85NF5q/3/lC6em+wm5OjEo0VYZi33IP6f2w5TMkGFufXSe3GWG
        YhYEV056GQoCiK7J1PCtLjbf7A==
X-Google-Smtp-Source: AGRyM1tvyPJEWtQKdPzmfqgg4gAhar/S04riTBZcDusHmTco4zK/wtPUvt3JJSh5Z0tLWnXetR84/w==
X-Received: by 2002:a05:6638:dd1:b0:341:595e:4ef8 with SMTP id m17-20020a0566380dd100b00341595e4ef8mr11481693jaj.26.1658329882081;
        Wed, 20 Jul 2022 08:11:22 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c42-20020a02962d000000b0033f29233b9csm7769925jai.74.2022.07.20.08.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 08:11:21 -0700 (PDT)
Message-ID: <a4e8e599-49bd-bf26-dd8d-754a627a251e@kernel.dk>
Date:   Wed, 20 Jul 2022 09:11:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file
 op
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
 <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com>
 <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
 <CAHC9VhQeScpuhFU=E+Q7Ewyd0Ta-VLA+45zQF9-g-Ae+CN1fgA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhQeScpuhFU=E+Q7Ewyd0Ta-VLA+45zQF9-g-Ae+CN1fgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/22 9:06 AM, Paul Moore wrote:
> On Mon, Jul 18, 2022 at 1:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 7/15/2022 8:33 PM, Paul Moore wrote:
>>> On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
>>>> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
>>>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>>>> add infrastructure for uring-cmd"), this extended the struct
>>>>>> file_operations to allow a new command which each subsystem can use
>>>>>> to enable command passthrough. Add an LSM specific for the command
>>>>>> passthrough which enables LSMs to inspect the command details.
>>>>>>
>>>>>> This was discussed long ago without no clear pointer for something
>>>>>> conclusive, so this enables LSMs to at least reject this new file
>>>>>> operation.
>>>>> From an io_uring perspective, this looks fine to me. It may be easier if
>>>>> I take this through my tree due to the moving of the files, or the
>>>>> security side can do it but it'd have to then wait for merge window (and
>>>>> post io_uring branch merge) to do so. Just let me know. If done outside
>>>>> of my tree, feel free to add:
>>> I forgot to add this earlier ... let's see how the timing goes, I
>>> don't expect the LSM/Smack/SELinux bits to be ready and tested before
>>> the merge window opens so I'm guessing this will not be an issue in
>>> practice, but thanks for the heads-up.
>>
>> I have a patch that may or may not be appropriate. I ran the
>> liburing tests without (additional) failures, but it looks like
>> there isn't anything there testing uring_cmd. Do you have a
>> test tucked away somewhere I can use?
> 
> I just had a thought, would the io_uring folks be opposed if I
> submitted a patch to add a file_operations:uring_cmd for the null
> character device?  A simple uring_cmd noop seems to be in keeping with
> the null device, and it would make testing the io_uring CMD
> functionality much easier as it would not rely on a specific device.
> 
> I think something like this would be in keeping with the null driver:
> 
>   static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int
> issue_flags)
>   {
>     return 0;
>   }
> 
> Thoughts?

I think that's a good idea. We're adding an nvme based test for
liburing, but that's to be able to test the whole passthrough part, not
just uring_cmd in particular.

Adding a dummy one to null/zero makes sense for test purposes.

-- 
Jens Axboe

