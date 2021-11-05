Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0462B446B4F
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 00:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhKEXoh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Nov 2021 19:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhKEXoh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Nov 2021 19:44:37 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AC6C061570
        for <io-uring@vger.kernel.org>; Fri,  5 Nov 2021 16:41:56 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id i12so11028156ila.12
        for <io-uring@vger.kernel.org>; Fri, 05 Nov 2021 16:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UzS3QOFEJxmVEtz5Kez5BnsRNW8Bt6XtmTpky/YNk1s=;
        b=KubIviG+C7WovXI8QIbc4Z302dscnfHCIZXoZowum0xuFCcEf7smG/kfbiRf5cLsh5
         cOuwwSozMSqXsINcbN8TfElHJwkOI4+vQr5YnyWO3CuxWsR3EH+gjiqAVO7vJPNJ+1zL
         uPjfZkmUeSbt3/ZV04yWzNOiz0S9vn/VOvmMhUObTXFyBrjZVKf+JFxDa3KOCNWAYxWy
         +nOtzo5mqe4xeBWLSwHl/1fajQ43Cc/RlAfzwvPv5RmtaeVjmL3fimlUJjXTCpCmGger
         YLnIrohcLtJ+DtEJ94vegYyh4mVsDBpTRgSLUg3ZQALrBmmHoPb2WtwjVuuJvk8VETM/
         09rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UzS3QOFEJxmVEtz5Kez5BnsRNW8Bt6XtmTpky/YNk1s=;
        b=z3DgA9XhRzAFd8b3YK/nHuV6YC6GMcfA3O+mdsqF1aLPHUZV6bVZut50gmSgR0eNCU
         SYQWfP0+DDKUx/JnEOK2E+OfHEGH2qb1dI5uKTSFQ4AB0g7sLL29LN1Qxp/dpCA//5Xr
         qbcLvXY3/1y+3Lk6vcrZOo8AqssqCL3tTV95cQrEmUsi3aNiSJafsJxAJpM6eVB0DF8L
         pwdk0OPzUzs3IgNWH//N6nt1E2N9kgefi9wz9noupZy9LcIzZQRAr87xoqMQP3MgjlTe
         PCgtttxShArytHwhycZIqXR95qUgssf6fauPW1MzATZ40eIdkSZ1zCFI7QFu0z1+fP63
         iCkA==
X-Gm-Message-State: AOAM533bcu/OaDod8JbrbNKrJOTuQmGhVXubcjH5diSWFPnS4n0X0A1M
        J3TsPIWirl6ZVVuz+WT1JggFmA==
X-Google-Smtp-Source: ABdhPJzGXj9Ldz80yvZvMnobZ5dn87XuvZl0SEQOnThqz0h3QDNsJ0ZfKuzuSoCcjyCLXe7s+8SGPw==
X-Received: by 2002:a92:c56b:: with SMTP id b11mr31574326ilj.243.1636155716233;
        Fri, 05 Nov 2021 16:41:56 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g10sm6278319ila.34.2021.11.05.16.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 16:41:55 -0700 (PDT)
Subject: Re: [PATCH v2 liburing] test: Add kworker-hang test
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
References: <jVMSI0NVN7BJ-ammarfaizi2@gnuweeb.org>
 <ECikfVpksVU-ammarfaizi2@gnuweeb.org>
 <CAGzmLMVvhkanBZYq-4PU0NeiPH8K8jhRBH+koqf-1gGrzXGjxg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <687bd0c5-be36-6892-c1e5-4488548aab12@kernel.dk>
Date:   Fri, 5 Nov 2021 17:41:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGzmLMVvhkanBZYq-4PU0NeiPH8K8jhRBH+koqf-1gGrzXGjxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/21 5:35 PM, Ammar Faizi wrote:
> On Wed, Oct 20, 2021 at 7:52 PM Ammar Faizi
> <ammar.faizi@students.amikom.ac.id> wrote:
>>
>> Add kworker-hang test to reproduce this:
>>
>>   [28335.037622] INFO: task kworker/u8:3:77596 blocked for more than 10 seconds.
>>   [28335.037629]       Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
>>   [28335.037637] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   [28335.037642] task:kworker/u8:3    state:D stack:    0 pid:77596 ppid:     2 flags:0x00004000
>>   [28335.037650] Workqueue: events_unbound io_ring_exit_work
> 
> Hi Jens, will you take this patch? If yes, I will spin the v3 because
> this one no longer applies since the test/Makefile changed.

Yes I will, sorry it dropped off my radar. Please just respin it.

> This kworker hang bug still lives in Linux 5.15 stable anyway.

We just need to backport the fix, then it should be fixed there too :-)

-- 
Jens Axboe

