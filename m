Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED151E6FEA
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 01:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437459AbgE1XDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 19:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437385AbgE1XDo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 19:03:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC9DC08C5C6
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 16:03:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q24so260514pjd.1
        for <io-uring@vger.kernel.org>; Thu, 28 May 2020 16:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ouOcXTSuJ4OxsulGNIFEWWBWX5wQZkwTTZj9X4uuRKs=;
        b=LaV6MR3q4ggXQbBC9+VFr9sX9+0FU33DVJTFR7sWC62Fk1WDHqbrQtrOR7eATej8Gl
         QrtM1WKaRJYlEU9XMPLhKS9au0Y8Q+GLG3z4VfD+bNytYCbOqJj4xsDuJerqu4jaPFDT
         Xk3z6G9v86fTjekRBHORurCnADsjSow984mQ8ZhA/pjUZ6VB0ITR57T7CO5orPzwMfs5
         ANf1bMSunLWNwQClhP5Nf7CansNjPKqBmt9JGHRMDcBtAS7IBqZDP+MLhA9GUCVyLLWV
         pFrrPl/jW648vcvyu5KYrPC6zLMo/kUx/Njg5fNvrYjJ6aN8Pe8/A8aJVi0N/qNVqt45
         5hNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ouOcXTSuJ4OxsulGNIFEWWBWX5wQZkwTTZj9X4uuRKs=;
        b=d6bHF2pFo0sojP279X5UfZgFKvHGwayTglFpmiGcEVuXQ10WSUFzNIA6fdqxrxfHie
         w4jE9lVfjlBYuFVRAJ9eob+8Hc+V7M2m1ZiWbitrb2Ziv93tiOWiZou29k2I19iQevd0
         YGeJ/V3VjFtq+r+2dLPeC9I8Rvg3a+oenA5Ibb3+i3qqdLJOc1b+zLtHu5Xnh88sMrf+
         FAr0u77BxmJ5ghxZHfEbfdnG5HEFKfeHr9lt2RXhhrPC2PwBF6HvK8TK0NkU1EFALep/
         q9qGQntd/Lb+GdTlvyr5Ka8+2SnGzwBJZn571GdJN1fRfJxinqjkoF3ZjBqT1e6YOOLq
         h23w==
X-Gm-Message-State: AOAM5329Zqw/OLBIILSZvyWLMFgnfUk5qLUO7c11rS0prDfc+34anchB
        aWPvLlfewSX+iHzt3PbKFvyJqktOW7o/pQ==
X-Google-Smtp-Source: ABdhPJyQXtwk05uCn5D84dTRYs3mXfHJmnopXNyCX6hwOmYkzn7lQ+ABbMjUZO2OnTBVYmQv83UwDQ==
X-Received: by 2002:a17:90a:ce91:: with SMTP id g17mr6089333pju.60.1590707022210;
        Thu, 28 May 2020 16:03:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 62sm5505639pfe.93.2020.05.28.16.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 16:03:41 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ca210e3-eba6-0621-3ebc-d3545f5ad7e9@kernel.dk>
Date:   Thu, 28 May 2020 17:03:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <x49o8q7zp21.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/20 4:12 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>>> poll won't work over dm, so that looks correct. What happens if you edit
>>> it and disable poll? Would be curious to see both buffered = 0 and
>>> buffered = 1 runs with that.
>>>
>>> I'll try this here too.
>>
>> I checked, and with the offending commit reverted, it behaves exactly
>> like it should - io_uring doesn't hit endless retries, and we still
>> return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
>> I've queued up the revert.
> 
> With that revert, I now see an issue with an xfs file system on top of
> an nvme device when running the liburing test suite:
> 
> Running test 500f9fbadef8-test
> Test 500f9fbadef8-test failed with ret 130
> 
> That means the test harness timed out, so we never received a
> completion.

I can't reproduce this. Can you try again, and enable io_uring tracing?

# echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable

run test

send the 'trace' file, or take a look and see what is going on.

-- 
Jens Axboe

