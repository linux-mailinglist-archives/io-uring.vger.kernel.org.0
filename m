Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB3C1B5F14
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 17:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgDWPYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 11:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729152AbgDWPYW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 11:24:22 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346C7C08ED7D
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:24:21 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id i19so6734646ioh.12
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fhGqQah8FZL9iAQQpG8YQwGoufAnqMhsg7uJ26v1SRw=;
        b=iwtvRGptPxA2bp3/HQIqvvHs1s3BJ9z0HPmUlunmB4OB6cnlLReV40LMKgcFVOirLg
         OXxevkDNYgWtD0psGeseyKSquISJQcug79v936L11ZPXFroa0hb3hrJLE+AsVSNiMYNT
         WZtrcs+jNr3yYn/kfosO/RPDkEbsisBV/FwHaJ0IywBqHusuzD03fTOESLpo3W+l3FHU
         HAFzUvKlP0QuB442M0toncECmKQUG6ri9PVzNmtrQ1DLSE8KIlR3RdnDIpX44G7YczY4
         zKs0xplt4sOW3f960wwsKY13J0is4M0vBBHraDRsQqiHH+ayeggxPmDH7WuGV9BoXzPt
         t7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fhGqQah8FZL9iAQQpG8YQwGoufAnqMhsg7uJ26v1SRw=;
        b=YAT8p/2uH0ktlnvwnFFsBNimN9yMecnjaO+t20JVASGPt4j89rg4u0QfifuiX37hOk
         cB1djuZekkzSOzs4xcIO7KQqWEjJl3uhJ4JZYAhGO6snKKwWQY1/RThoX8bCMdTX/zE/
         Sjz+FrQN27Ekirpl/08aPV15OMsal6CShNH3kU1LFqzXYw7eQKNbRt0pDAOpADTyxzYo
         bR48PyJx0J7IpxKsztbS4OUBgt0Lf3JyxLXeJLt8ofuLuSqY9xxCav29zaL+bnBw6lKP
         eE/+ppkgrSTSlNlMzU6oUlwPxdwdptu+4tbaGBMKz/Nrw2FV8SC21QEJC7cB2amnLgL6
         Yp+Q==
X-Gm-Message-State: AGi0PuYPeLo527qwt2GNEIkEOxGCulphKM0auwtF5aMaO39aY/lCBjgp
        sEtnJ6wdkyCA86IOrUBRxR+8NVySA4ot/Q==
X-Google-Smtp-Source: APiQypJjo+928Xtn2p0vIzhslnPSLHBc+A7Brq/rQFE4sh6o2z6kSwi+PXApOFSYzcBWvOLf4xj0Gg==
X-Received: by 2002:a05:6602:2fcd:: with SMTP id v13mr4126551iow.124.1587655459994;
        Thu, 23 Apr 2020 08:24:19 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z7sm978675ilc.17.2020.04.23.08.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:24:19 -0700 (PDT)
Subject: Re: Ring Setup Question
To:     Daniel H <hodges.daniel.scott@gmail.com>, io-uring@vger.kernel.org
References: <CAAUBs7+nziOz02XPaBsP_6-4wgT3fV+VzAzgwOGAkui3K=czRQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc22c059-78e6-5396-f324-4783cf746a51@kernel.dk>
Date:   Thu, 23 Apr 2020 09:24:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAUBs7+nziOz02XPaBsP_6-4wgT3fV+VzAzgwOGAkui3K=czRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/20 8:38 AM, Daniel H wrote:
> I'm working on a implementation of for the Go language and I've been running
> into a failed test case that I can't understand. The test is setup in the
> following manner; first write some data into a file and then read the data
> back using the io_uring. The simple test case of reading back all the bytes
> passes. However, when using two reads to read half the amount of data what I
> observe is the second time the ring is entered (after the first read completes
> successfully) is that the resulting CQE doesn't match the UserData. The test
> uses a monotonically increasing value for UserData and the following debug
> messages show that each entry has a unique UserData field. I'm guessing
> the ring is setup properly, however I'm not sure how to proceed.
> 
> === RUN   TestRingFileReadWriterRead
> pre enter
> sq head: 0 tail: 1
> sq entries: [{Opcode:22 Flags:2 Ioprio:0 Fd:8 Offset:0
> Addr:824634362160 Len:7 UFlags:0 UserData:1 Anon0:[0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0 0 0 0 0]} {Opcode:0 Flags:0 Ioprio:0 Fd:0 Offset:0
> Addr:0 Len:0 UFlags:0 UserData:0 Anon0:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0]}]
> cq head: 0 tail: 0
> cq entries: [{UserData:0 Res:0 Flags:0} {UserData:0 Res:0 Flags:0}]
> enter complete
> sq head: 1 tail: 1
> sq entries: [{Opcode:22 Flags:2 Ioprio:0 Fd:8 Offset:0
> Addr:824634362160 Len:7 UFlags:0 UserData:1 Anon0:[0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0 0 0 0 0]} {Opcode:0 Flags:0 Ioprio:0 Fd:0 Offset:0
> Addr:0 Len:0 UFlags:0 UserData:0 Anon0:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0]}]
> cq head: 1 tail: 1
> cq entries: [{UserData:1 Res:7 Flags:0} {UserData:0 Res:0 Flags:0}]
> pre enter
> sq head: 1 tail: 2
> sq entries: [{Opcode:22 Flags:2 Ioprio:0 Fd:8 Offset:0
> Addr:824634362160 Len:7 UFlags:0 UserData:1 Anon0:[0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0 0 0 0 0]} {Opcode:22 Flags:2 Ioprio:0 Fd:8
> Offset:7 Addr:824634363240 Len:7 UFlags:0 UserData:2 Anon0:[0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]}]
> cq head: 1 tail: 1
> cq entries: [{UserData:1 Res:7 Flags:0} {UserData:0 Res:0 Flags:0}]
> enter complete
> sq head: 2 tail: 2
> sq entries: [{Opcode:22 Flags:2 Ioprio:0 Fd:8 Offset:0
> Addr:824634362160 Len:7 UFlags:0 UserData:1 Anon0:[0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0 0 0 0 0]} {Opcode:22 Flags:2 Ioprio:0 Fd:8
> Offset:7 Addr:824634363240 Len:7 UFlags:0 UserData
> :2 Anon0:[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]}]
> cq head: 1 tail: 2
> cq entries: [{UserData:1 Res:7 Flags:0} {UserData:1 Res:7 Flags:0}]

I think it'll be hard to advise on what is going wrong here without
having a test case.

-- 
Jens Axboe

