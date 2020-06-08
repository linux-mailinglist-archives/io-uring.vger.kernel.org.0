Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D8B1F2098
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 22:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgFHUUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgFHUT7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 16:19:59 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159CC08C5C2
        for <io-uring@vger.kernel.org>; Mon,  8 Jun 2020 13:19:59 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d8so3917764plo.12
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2020 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZZx5yvm0LERNWG/JYc2qibmsm0u6bJFtDVKihdjnxtw=;
        b=lFAQgcFoPXkfTGEjM/PvnSt1qtkawGtAYhu3iop0pZgkwHwR4jE4itm+uOXdIGuudX
         ai+oUrrZsQUXEo4JU/A/uJ2nZo7+dbdfZWPws26B2dDRYf7w9enhr3kB5s9almq46KGc
         Ecxe5Ni4HpDNR4ePxpJYUuLhC9m54nn3ho9obFDWzblaKWxfhlygqg32Wh7b7yAEkpON
         nK+iHkU0ruCcqPCTVs0eNrWvz1hxx/P4OxEn2ITSrIvayxvmGJWKDdOG6VmxLF+WhBIR
         Hlkv2CurD8tbVdqWQCOBo0CI3DtyFapiwXSevEzud/8xacPizPRAq6OYJh82TNsRlxhB
         7SyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZx5yvm0LERNWG/JYc2qibmsm0u6bJFtDVKihdjnxtw=;
        b=TsxxkZ8Iq2Pb61mqSWE9zUDkO+9yeoqyRyj+mvpYxeu++iKua6/gMlprNi0FPsQBWE
         rtr0RLutQo0dHeAX2oP8BwC6GqBSqzTdA5zIbhQKVpbqDRUIDeSqHmeSl6AbKbbBZcys
         eWKWm0hWGNS2uGgNcHw5krPQBMJvlukaidqMkybOvKdLDu8t3zbjAI5yOZWsTt5OpLwP
         io1QvdnJUS8a6T3hN9M4JiQeww8B9FbKXXxFuTGek2X4S+xSO9lHR37XFXvFgP8mT3JZ
         cc86ic8Wr+QpSro4J1oRIjzFU1S8QPkqPgSWeiTvxFgghT4ukKgXBRNNlis0Jb4EgJAs
         ZfPQ==
X-Gm-Message-State: AOAM531LMwZmFM1wqRMlIxV9T8C4AI8iMiOlAIYaaqEtv+fglEta7/zU
        zDSEzBH6daAPEX/GyxOAEp+O2yjJF2i0fg==
X-Google-Smtp-Source: ABdhPJzw2DHoSweIn/oZCzwkkuzXO+dqbAHywLph7u0wbH59UmAZ3recAQEJ64zn7XqwHBLKxp8acg==
X-Received: by 2002:a17:902:9885:: with SMTP id s5mr417889plp.204.1591647598729;
        Mon, 08 Jun 2020 13:19:58 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x14sm7952168pfq.80.2020.06.08.13.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 13:19:58 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
Date:   Mon, 8 Jun 2020 14:19:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/20 5:21 AM, Clay Harris wrote:
> On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:
> 
>> On 5/31/20 6:47 AM, Clay Harris wrote:
>>> Tested on kernel 5.6.14
>>>
>>> $ ./closetest closetest.c
>>>
>>> path closetest.c open on fd 3 with O_RDONLY
>>>  ---- io_uring close(3)
>>>  ---- ordinary close(3)
>>> ordinary close(3) failed, errno 9: Bad file descriptor
>>>
>>>
>>> $ ./closetest closetest.c opath
>>>
>>> path closetest.c open on fd 3 with O_PATH
>>>  ---- io_uring close(3)
>>> io_uring close() failed, errno 9: Bad file descriptor
>>>  ---- ordinary close(3)
>>> ordinary close(3) returned 0
>>
>> Can you include the test case, please? Should be an easy fix, but no
>> point rewriting a test case if I can avoid it...
> 
> Sure.  Here's a cleaned-up test program.
> https://claycon.org/software/io_uring/tests/close_opath.c

Thanks for sending this - but it's GPL v3, I can't take that. I'll
probably just add an O_PATH test case to the existing open-close test
cases.

-- 
Jens Axboe

