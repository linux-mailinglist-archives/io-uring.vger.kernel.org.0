Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432D1E8380
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2QUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 12:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgE2QUj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 12:20:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3BFC03E969
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 09:20:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f21so1676298pgg.12
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 09:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QYTmRXSXGvX7cQ+bSaHAXwGUmhYclnvRRyIDOpDKEN8=;
        b=YicrkdZ9tioZM+v0cQSLvdU08Q6HXV2UKDCBXPW5pdQoe6/rkVFFF++aTIWCpOo8Kk
         Du2pX3WFFCIlDQMg5cs9EKa9mck/meduu8zagnaioBj9eXfzslrtwwG5EXxwzjCBzV8m
         z443GCYMXSDKI9ELgaXWz+C12NvIcPx5zIJ9xqu0f6T/rL7g+D7ffDKJfDVO/8bkqXwU
         55HFIijAZnlLGjkkABKk7FP+bBZM41eTwyTSTL4ZO+Fl9roKWaSSrTox9IkFEIXf5+o3
         ELTsCvyNRttCnrnqK1uKgDUh3MMM8adR7HFhxPe25U8ENrBvnYklija3k+6Q2IzRHU6Y
         YKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QYTmRXSXGvX7cQ+bSaHAXwGUmhYclnvRRyIDOpDKEN8=;
        b=A3e/CsmMjRI9XAWdbE343jw43PDYpe/vu+LXbD+zy2tf4UHbHNGXm8xuHqbWOMFRUw
         PeJ8FZAOwdC5nuLE1yfC5cy6W+QI4S4ahPJDsqHkNernroEtZbQC7eQU0WxLonvX+l4y
         RHedO+ALq9IWJaZuZql/WsoYk+vyvp3UDFnLv2UGlw3je+Y1mVhPhCYPD8OQkh+LNAOU
         LR/UUZDTF3R3m8K8LF5URcqrxb1jLwa3khFkmKlIzCzn6+XaCsGDrKtCNIKB3DnIIQZG
         Ta1Oz902EfV3LYUssldGIR4XXlzTh9jm2403tfgMzJ/wxS9XMKUOTQaz04KxB9yBs2b1
         5Diw==
X-Gm-Message-State: AOAM531oZmFRYiAIJQNRdWUXkvXp+qEXTDa++dMY5ZY3a4TydcBWbBZ2
        NM03eQpInPA8NmNWj/PUCp1+fh6793jtKg==
X-Google-Smtp-Source: ABdhPJziUDCn+cLl5rX7j+LIXP0zU+CooHpC/5qon1Nyqi2Th083WFGCK8Al/3A+5pXbrqR2H7NKjg==
X-Received: by 2002:a62:1503:: with SMTP id 3mr9647398pfv.202.1590769238592;
        Fri, 29 May 2020 09:20:38 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id gp18sm7614621pjb.38.2020.05.29.09.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 09:20:38 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as
 unspported
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
 <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
 <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
 <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk>
 <x49o8q7zp21.fsf@segfault.boston.devel.redhat.com>
 <6ca210e3-eba6-0621-3ebc-d3545f5ad7e9@kernel.dk>
 <x49h7vyzsvu.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0800aa17-030d-27d7-7b00-7ef0b39d9cfe@kernel.dk>
Date:   Fri, 29 May 2020 10:20:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <x49h7vyzsvu.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/20 9:02 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 5/28/20 4:12 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>>> poll won't work over dm, so that looks correct. What happens if you edit
>>>>> it and disable poll? Would be curious to see both buffered = 0 and
>>>>> buffered = 1 runs with that.
>>>>>
>>>>> I'll try this here too.
>>>>
>>>> I checked, and with the offending commit reverted, it behaves exactly
>>>> like it should - io_uring doesn't hit endless retries, and we still
>>>> return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
>>>> I've queued up the revert.
>>>
>>> With that revert, I now see an issue with an xfs file system on top of
>>> an nvme device when running the liburing test suite:
>>>
>>> Running test 500f9fbadef8-test
>>> Test 500f9fbadef8-test failed with ret 130
>>>
>>> That means the test harness timed out, so we never received a
>>> completion.
>>
>> I can't reproduce this. Can you try again, and enable io_uring tracing?
>>
>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>
>> run test
>>
>> send the 'trace' file, or take a look and see what is going on.
> 
> I took a look, and it appeared as though the issue was not in the
> kernel.  My liburing was not uptodate, and after grabbing the latest,
> the test runs to completion.

OK good, that's a relief!

-- 
Jens Axboe

