Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B802501C2
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHXQKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 12:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgHXQKP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 12:10:15 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D0C061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:10:14 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id c6so7690152ilo.13
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 09:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3pzbp0PP4PMvyJugAnN/gepU4JOhwH7NND7Nn+BHOo8=;
        b=0YBJsNOroablrcRGaBM1rlBPIAuaasJIssnBGCPH6WUDbPPFYR/p+8GgvC2qugu4p/
         xUPbXCAM5FgGc3BB/HDZYbSOdXxR1nF6tgOlUtRkIp47UA8R2gYTQbk4TWJzc0Q7upGY
         XlZMeEbMJB494ctnjftTJCZOQOSdmYHxk/bCAZW3aogQ4KFMpY94zVJxdzkfYe6DWuiT
         3du4OM5NzQRHPYLNVZNp7KOvm90a3QU9NcRzZC0xQrto1ZEdCfIo1TyCK05BwkiM0oJd
         LyGtOTDkNbvg6fpPdvgaL2u0r2CvKrf/QXWFZdoBcuNX0aat4t2/nNXKExN1uET0cf9h
         fOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3pzbp0PP4PMvyJugAnN/gepU4JOhwH7NND7Nn+BHOo8=;
        b=desVCEakdlc/e31Kuf6jh+gtdrIAn38qazYVrh03ZxPsbPMVtoRcQNOSMWJt2FFswY
         qyFOonQUkbWXSvaaRx+NZLYm21Fb2pwOolA4hvv79uoUpSSqSNn2ExVFwWWNdSZRPP0E
         LcIPJ55sqtNQ7L6yaXvBbscS8qeLKNRCcCJX5YWNUb/DU94SGv4xGU5mZagFkUMRiNgD
         /VuHiHOn5qXpf3qqICBK6YLlnGSMCLoA31AiOvjQejTSPM4Hv4gHh6oH01KI3TH1yJkm
         ja0pB4o59cEoJbS+Q6ZgviJJalh4tgss8tOc2BGJDwgqDVbZU8pfVfBwLk/idyRYrc3b
         LWjg==
X-Gm-Message-State: AOAM532OSm0I0ECiKHXKKY9QxXPA8CVFgLf8u67zTH8y5ImpX/mimfZn
        3mP2t/4J1pQQNJIJ3zQPTSMoTh1dKjLapxZH
X-Google-Smtp-Source: ABdhPJx+79VkkUx0zDf+Wpwf0LcIE4bZw8pPunEBTZ/wqT3mPahbLawE2MvOueQ+39Ti+/3VQpNtbA==
X-Received: by 2002:a92:c8c1:: with SMTP id c1mr5579965ilq.42.1598285403807;
        Mon, 24 Aug 2020 09:10:03 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e1sm7410355ilq.40.2020.08.24.09.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 09:10:03 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
 <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
Date:   Mon, 24 Aug 2020 10:10:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 9:33 AM, Dmitry Shulyak wrote:
> On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/24/20 8:06 AM, Jens Axboe wrote:
>>> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
>>>> library that i am using https://github.com/dshulyak/uring
>>>> It requires golang 1.14, if installed, benchmark can be run with:
>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
>>>>
>>>> note that it will setup uring instance per cpu, with shared worker pool.
>>>> it will take me too much time to implement repro in c, but in general
>>>> i am simply submitting multiple concurrent
>>>> read requests and watching read rate.
>>>
>>> I'm fine with trying your Go version, but I can into a bit of trouble:
>>>
>>> axboe@amd ~/g/go-uring (master)>
>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>> # github.com/dshulyak/uring/fixed
>>> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
>>>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
>>>       |                                                ^
>>> FAIL  github.com/dshulyak/uring/fs [build failed]
>>> FAIL
>>> axboe@amd ~/g/go-uring (master)> go version
>>> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
>>
>> Alright, got it working. What device are you running this on? And am I
>> correct in assuming you get short reads, or rather 0 reads? What file
>> system?
>
> Was going to look into this.
> I am getting 0 reads. This is on some old kingston ssd, ext4.

I can't seem to reproduce this. I do see some cqe->res == 0 completes,
but those appear to be NOPs. And they trigger at the start and end. I'll
keep poking.

-- 
Jens Axboe

