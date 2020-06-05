Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A41EFBB0
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 16:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgFEOmc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 10:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgFEOmc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 10:42:32 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080C3C08C5C2
        for <io-uring@vger.kernel.org>; Fri,  5 Jun 2020 07:42:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so3709631plv.9
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2020 07:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kWmWY107rL+xsIIhFUjNTUmeVB4+7Mb6mUCJ2bTAek8=;
        b=FsGe7wFGGdfMO+60vFghW/jiJzjC8SSJ0pZqzQMAvVGM9/qniaAF8MHtnRHnEEhwwF
         Su8K2GDWr9oGUbLOg5DXBFZ5oFEvb0od59O261yqszT8OIP9HJE34svYuegmLhXPu/Zo
         976f8IDLVPQM/cZLNmCqKN8yfCBrtyF68tIrF54Xq8meZ84YOcEJwuHZk0Ut1NYuVTru
         4DqS0Xvb8tP50yNzdLQrOvIdvU+MrBQUPA+XuEBjcFCkUjXt6/IoOGK9/l3cO+cKxmaN
         XIDG4+iWyGw9+9Or1VhfVJIJ/WXYVBYMM2SGsYNIlCoP8AqbT9kJKlZBxECX9nh+NH7J
         NK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kWmWY107rL+xsIIhFUjNTUmeVB4+7Mb6mUCJ2bTAek8=;
        b=WnV+8cT6YcG+P4qnA8u9YdfMKSZaZTeh4z0clK1i5hBQucJ5Ge5dN2ek6r5kccje9J
         fhpIpHWiMQfsq7l7EFsw8Is9vOL9B5P1H6tsndP6TpDtK4juUZXaO+mH7JrrbqeU3+cp
         IiXTRGJ7HBkQECQrytkqlbLH8nZOFz8bC4bjb8a8FXKIa2JL9Wpi25esW7pJ1itD1NBX
         KeN1+MHAXABnhTmIuBcLxXwc0LN2zp73vZ/16BMklbv7D/fYfnfpZ8Cg1erzNawesmc4
         vfH1pHbTwxaQhPYmP9mk6Wt6POvcEswl+Ac+l9ENuMexIbTFncIXltOAS2HhluBAHA+E
         x6NQ==
X-Gm-Message-State: AOAM532zyPLjn62EdlEM9VTTrbfqKyS00Deger2dSO32WRfCzjwjVqL2
        9Qv3RIZsjtRny2pi2hKlMQGjVg==
X-Google-Smtp-Source: ABdhPJwLtUnSV/ZHIAhiWei0T4bnq1OqRswoMTSv82AFOm5LbY8oHymBtDpRahXmzi58KiaRpGTUtg==
X-Received: by 2002:a17:90a:df0c:: with SMTP id gp12mr3503128pjb.148.1591368151295;
        Fri, 05 Jun 2020 07:42:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k126sm7788338pfd.129.2020.06.05.07.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 07:42:30 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
From:   Jens Axboe <axboe@kernel.dk>
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
Message-ID: <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
Date:   Fri, 5 Jun 2020 08:42:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/20 7:04 PM, Jens Axboe wrote:
> On 6/3/20 6:59 PM, Andres Freund wrote:
>> Hi,
>>
>> I was trying to benchmark the benefits of this for the io_uring using
>> postgres I am working on. The initial results where quite promising
>> (reducing cpu usage significantly, to lower than non-uring sync io). But
>> unfortunately trying another workload triggered both panics and before
>> that seemingly returned wrong data.
>>
>> I first saw that problem with b360d424ce02, which was
>> linux-block/async-buffered.6 at the time. After hitting the issue, I
>> updated to the current linux-block/async-buffered.6, but the problem
>> persists.
>>
>> The workload that triggers the bug within a few seconds is postgres
>> doing a parallel sequential scan of a large table (and aggregating the
>> data, but that shouldn't matter). In the triggering case that boils down
>> to 9 processes sequentially reading a number of 1GB files (we chunk
>> tables internally into smaller files). Each process will read a 512kB
>> chunk of the file on its own, and then claim the next 512kB from a
>> shared memory location. Most of the IO will be READV requests, reading
>> 16 * 8kB into postgres' buffer pool (which may or may not be neighboring
>> 8kB pages).
> 
> I'll try and reproduce this, any chance you have a test case that can
> be run so I don't have to write one from scratch? The more detailed
> instructions the better.

Can you try with async-buffered.7? I've rebased it on a new mechanism,
and doing something like what you describe above I haven't been able
to trigger anything bad. I'd try your test case specifically, so do let
know if it's something I can run.

-- 
Jens Axboe

