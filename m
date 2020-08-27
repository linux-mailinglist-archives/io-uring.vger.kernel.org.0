Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337EB254689
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgH0OL4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgH0OKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:10:55 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49172C061235
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:10:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q14so4955174ilj.8
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=etGmff5kjea2pYumFvnmRUd62aXV3Jnz4zFc8MdNedw=;
        b=VT257ly/Gi/sHNPTYqDt3YpqbEVFt/d4BM9TRuMzVg3+JUv1/v1DCMU7+QMWuChY8s
         b1p5uA8EnzQd8lo/7L/WuXpX234qc0mXNzM57pqrSHInoWgkqOLhM2UYewaqawhC8xs2
         /JATaHIrv9gRN6q5OwyC0zpbV8MrYvPYfPRrgSUIY5c7xpj2AzHpQ+9GWbamAj53fWdn
         IeXDsh5FTtNMD5PrcA8140uRXbLsq0eEhyqWzzAwR/z3Hh16IW5HhkceWImTFcsjSh0N
         B4HSMRW2OuXRO1u3iXOEWUD/HUY/3yuxS1JX9rZ/y2txqPH0FqMoeouoQ7oGg5U+3kGI
         219g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etGmff5kjea2pYumFvnmRUd62aXV3Jnz4zFc8MdNedw=;
        b=okVpR7+CYnRRfQjiYNNDohlCVgGS0HGmSDE+43BctRgyYVCHDmNhgReIHKXM5HnYvL
         2lL5C+iGDIK+PMYcXP8jxs1pux07f9xHMODy/10i6ZzHYKV1HDBFrh6r1AuzwwxtwaDB
         ZEK3/rc/OMdzaI/l0VmBHU2SMDpMDPtHmtwE9wIvwCoqWeOkqcYumSd7K/LGrfYb3ZR0
         mYCJneF696J/bkNM+02IWNMw6f6WJqbSvB5DFaj5/4X2jZJk+9oXfPyD2vYux/hNbONX
         CpmZ0IDihxCZdQCDizpJgmco6mljoFR7cqkf6fjH1uDRTmqJsLeGbpHkpUL2xLhOv6a4
         C0ww==
X-Gm-Message-State: AOAM531ZN1qCnJtJowzhnuATLdQdv7u/v9AbkdF01Hr7iTtBSP50IzOO
        +LbK6DX0K2c8IZ0tHVvuBaWVew==
X-Google-Smtp-Source: ABdhPJzM4CEH4kFINWPdYKqisNNlQjrNEp30gUUdhxYouGz8K5XQM7Wt2Ie5RxeKhyFHqad/dXvtng==
X-Received: by 2002:a92:9181:: with SMTP id e1mr16756233ill.274.1598537451548;
        Thu, 27 Aug 2020 07:10:51 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h18sm1235881iow.16.2020.08.27.07.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 07:10:50 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7c0ff79-87c0-6c7e-b048-b82a45d0f44a@kernel.dk>
Date:   Thu, 27 Aug 2020 08:10:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/20 8:10 AM, Stefano Garzarella wrote:
> On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
>> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
>>> v5:
>>>  - explicitly assigned enum values [Kees]
>>>  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
>>>  - added Kees' R-b tags
>>>
>>> v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
>>> v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
>>> RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
>>> RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
>>>
>>> Following the proposal that I send about restrictions [1], I wrote this series
>>> to add restrictions in io_uring.
>>>
>>> I also wrote helpers in liburing and a test case (test/register-restrictions.c)
>>> available in this repository:
>>> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
>>>
>>> Just to recap the proposal, the idea is to add some restrictions to the
>>> operations (sqe opcode and flags, register opcode) to safely allow untrusted
>>> applications or guests to use io_uring queues.
>>>
>>> The first patch changes io_uring_register(2) opcodes into an enumeration to
>>> keep track of the last opcode available.
>>>
>>> The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
>>> handle restrictions.
>>>
>>> The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
>>> allowing the user to register restrictions, buffers, files, before to start
>>> processing SQEs.
>>>
>>> Comments and suggestions are very welcome.
>>
>> Looks good to me, just a few very minor comments in patch 2. If you
>> could fix those up, let's get this queued for 5.10.
>>
> 
> Sure, I'll fix the issues. This is great :-)

Thanks! I'll pull in your liburing tests as well once we get the kernel
side sorted.

-- 
Jens Axboe

