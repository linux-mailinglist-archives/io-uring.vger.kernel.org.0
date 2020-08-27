Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E11B254737
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgH0Ooo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgH0OoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:44:24 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C8AC061232
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:44:23 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f12so5071726ils.6
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BvBnzh3obuyUM8uwyAg6+Zl7AVs2adJQvrnXXuqR/PQ=;
        b=aOAHV6uQAQVlX4aoMFWjdC9v57E5cC0AjZCtTF6GYcTrghuXOf8Fw6NLk/suxXkhU2
         zViUAl0NmIZa5ihE9PMDueIuiBFx5DOasGmrvktLc7e5r6OD+0oD9nDKl+0KvqGqIPFG
         BJgbssBNxa/kZTlS8BkLeqcQv9YXiLpmx5a1uN4P7h3oSSQxcwaKCwHZ165OdvIZC6Mf
         psv8Kta/q8Tz5GLxlrDhjSIyyxS9VAN9i/dZW1VxTUcPr5O+whKoDNqy6I5g64EB8ADD
         nEMZwCuBhJtzs7j4zgYA+Mf//9dosIRnf7H/UKL2qnhHQSkaeh0rjSiXZ/QXzYwKM4m+
         fCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BvBnzh3obuyUM8uwyAg6+Zl7AVs2adJQvrnXXuqR/PQ=;
        b=cpR0OeMw5/BSCK3IooAA8BVSJF40TFNaDW87OLw7jdAMhfc4nhPbdUqWsDe/vk8WsG
         gFd9QA42QAJnUG/NniAXqE2YiRMT1cNRUeNkEpji45J8bMhNIRAADT4MHMzpZT0gXxO/
         XMh1CJzoiWT4ssvjTpKGZgu2jT8oMTaYWixAhhVaq2wtXMpQfFKSUyeDq5dkZvyZi3Ld
         SYIDLVNYhIiEkTOAfaj09qClUqUmlFqq7TNOPzUHosS+MoF6M8tWbBt8yKcTafxT4q1D
         fZFiGkRFCZ9x3HK3HEBKSpZ9l2CxU0BpPvhczMW4UstloOfg4l4jz01T+eStM7JA8ieD
         cApA==
X-Gm-Message-State: AOAM533eq5/XQHosLx61I8W4nljFMnOaSW9hnUy1A9InAu0f3CAZkIAg
        FzDMi0F9cd8dCC3+W7SYhD/wwA==
X-Google-Smtp-Source: ABdhPJyg0+F3rh8DdZSHIP0joxQ9ukHmLSGNjSdvxHsvaBjE+o6SG54bNvvUi1FkYKaS/9Wgb3eT1Q==
X-Received: by 2002:a92:dd8c:: with SMTP id g12mr16624564iln.184.1598539462409;
        Thu, 27 Aug 2020 07:44:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j4sm1280083ilk.39.2020.08.27.07.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 07:44:21 -0700 (PDT)
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
 <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
 <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
 <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9363dfd-49da-b6ac-29f1-d8ba65665453@kernel.dk>
Date:   Thu, 27 Aug 2020 08:44:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827144129.5yvu2icj7a5jfp3p@steredhat.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/20 8:41 AM, Stefano Garzarella wrote:
> On Thu, Aug 27, 2020 at 08:10:49AM -0600, Jens Axboe wrote:
>> On 8/27/20 8:10 AM, Stefano Garzarella wrote:
>>> On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
>>>> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
>>>>> v5:
>>>>>  - explicitly assigned enum values [Kees]
>>>>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>>>>>  - added Kees' R-b tags
>>>>>
>>>>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
>>>>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
>>>>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
>>>>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
>>>>>
>>>>> Following the proposal that I send about restrictions [1], I wrote this series
>>>>> to add restrictions in io_uring.
>>>>>
>>>>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
>>>>> available in this repository:
>>>>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>>>>>
>>>>> Just to recap the proposal, the idea is to add some restrictions to the
>>>>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
>>>>> applications or guests to use io_uring queues.
>>>>>
>>>>> The first patch changes io_uring_register(2) opcodes into an enumeration to
>>>>> keep track of the last opcode available.
>>>>>
>>>>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
>>>>> handle restrictions.
>>>>>
>>>>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
>>>>> allowing the user to register restrictions, buffers, files, before to start
>>>>> processing SQEs.
>>>>>
>>>>> Comments and suggestions are very welcome.
>>>>
>>>> Looks good to me, just a few very minor comments in patch 2. If you
>>>> could fix those up, let's get this queued for 5.10.
>>>>
>>>
>>> Sure, I'll fix the issues. This is great :-)
>>
>> Thanks! I'll pull in your liburing tests as well once we get the kernel
>> side sorted.
> 
> Yeah. Let me know if you'd prefer that I send patches on io-uring ML.
> 
> About io-uring UAPI, do you think we should set explicitly the enum
> values also for IOSQE_*_BIT and IORING_OP_*?
> 
> I can send a separated patch for this.

No, I actually think that change was a little bit silly. If you
inadvertently renumber the enum in a patch, then tests would fail left
and right. Hence I don't think this is a real risk. I'm fine with doing
it for the addition, but doing it for the others is just going to cause
stable headaches for patches.

-- 
Jens Axboe

