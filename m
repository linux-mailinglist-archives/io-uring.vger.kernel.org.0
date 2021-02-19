Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834853201FB
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhBSXwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 18:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBSXwl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 18:52:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69107C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 15:52:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o38so6156675pgm.9
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 15:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vx+22eaohVQ9sWKSRkNzwg8vcYM+Z53yOST6U7cwQDA=;
        b=CaiG4wIKHA46nN88bGSu6KfNuU0votnQ+zvIwK4KKLVJTRACwMtfUSJsCqnvojqqPn
         hV7DmJVR2w7lrWU+0jq9u+LNzh6VwjfDuqZ2vBRpmU8iNzQS/KOfvsAdiT3htxK5aEOE
         1PcLEgaSXg269gICt6NsiKcL/FWiwWrvTkjuVnIE3JNhC4mtu9MOoIdTrzkYgWqU7zqA
         Ar3Y16TlDsp5yzNgLrELqbonXLnswYRvrLknuKZ7AKx+e8ubLHdDewybRJyyGhAo2R3c
         fFoEkJO/6yJlM70ixI3kTS+ZD3vuRA9V3qpnXLWTs5aUpx9PBGlO41naG81vcQWPLDNs
         jYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vx+22eaohVQ9sWKSRkNzwg8vcYM+Z53yOST6U7cwQDA=;
        b=Xihasnq8Wurzu3opZh9M/umUSa1/bezkFgm2mbOd1MrCUdqmPWBifus5WzBXOAVx1X
         vF3kFc87czMj+qIGBlAPGiMFg1OuaK4jp6WRJt8WNfVghUdbUNSV3HMyvfvd9AjSpobI
         RYKnt34SOk1XLuH9XYwF5qp7YbfVv0rtp4+YOOVm71pL9pGpk+maLtcu8leGE++W3ker
         jw9lajGmUxWLPFyU20JorsfcK6mFleGeVIoVBncECUFLHjzFE8MF357QfTOTDO7IdcGe
         qx9h1c2GHBWG0kKNgEXMhBbvyIMq2/oYu64JaNU5z7wWxU4vsSodHrNfsvl/asQcLyFr
         W0Ng==
X-Gm-Message-State: AOAM531APBUt83HbugfZoKsd2mzvv+HLnpGma+/1I1ZAM4Txx7mU8bF1
        LtVGaH5o6w9RLwaEBuFnI5jhcMbsSx+kfg==
X-Google-Smtp-Source: ABdhPJw+kUCHCTg6f1ucnaIxFyS90kVbfyfnUmrNejQhgXhxajV+RRI9WrscAYw8edwAJIsz2Utaag==
X-Received: by 2002:a63:1723:: with SMTP id x35mr10765801pgl.393.1613778720922;
        Fri, 19 Feb 2021 15:52:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c9sm9281367pjr.44.2021.02.19.15.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 15:52:00 -0800 (PST)
Subject: Re: [PATCHSET RFC 0/18] Remove kthread usage from io_uring
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <a982b3c3-17e7-bb53-0357-425241f069e0@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a389d225-02e6-4695-0ecb-239b5dace8c7@kernel.dk>
Date:   Fri, 19 Feb 2021 16:51:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a982b3c3-17e7-bb53-0357-425241f069e0@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 4:44 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> tldr - instead of using kthreads that assume the identity of the original
>> tasks for work that needs offloading to a thread, setup these workers as
>> threads of the original task.
>>
>> Here's a first cut of moving away from kthreads for io_uring. It passes
>> the test suite and various other testing I've done with it. It also
>> performs better, both for workloads actually using the async offload, but
>> also in general as we slim down structures and kill code from the hot path.
>>
>> The series is roughly split into these parts:
>>
>> - Patches 1-6, io_uring/io-wq prep patches
>> - Patches 7-8, Minor arch/kernel support
>> - Patches 9-15, switch from kthread to thread, remove state only needed
>>   for kthreads
>> - Patches 16-18, remove now dead/unneeded PF_IO_WORKER restrictions
>>
>> Comments/suggestions welcome. I'm pretty happy with the series at this
>> point, and particularly with how we end up cutting a lot of code while
>> also unifying how sync vs async is presented.
> 
> Thanks a lot! I was thinking hard about how to make all this easier to
> understand and perform better in order to have the whole context
> available natively for sendmsg/recvmsg, but also for the upcoming
> uring_cmd().
> 
> And now all that code magically disappeared completely, wonderful :-)

Glad to hear you like the approach! Yes, this will help both
readability, performance, and maintainability. Pretty much a win all
around imho.

-- 
Jens Axboe

