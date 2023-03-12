Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE456B677F
	for <lists+io-uring@lfdr.de>; Sun, 12 Mar 2023 16:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCLPaH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 11:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCLPaG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 11:30:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610A63D90B
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 08:30:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so9380659pjz.1
        for <io-uring@vger.kernel.org>; Sun, 12 Mar 2023 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678635003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6GnfTEBx0Nlfa/chTK4qukddUAosUQzWsROtATVXXDc=;
        b=VCgg6sd0Af2V2tqmG/8MwXSJ/KNRxdpwmgw7dxAGrUPc0k6nPXRajWOwKOYsyAIyhj
         EwA4/TLF8YKxHU+oumzvsx5upeDF12HW9wrgC16u1fhAsbh4Dg541d28m5OYPLmZkShg
         fdjlT3I3N0EccgZcLyHvCNRIonObMgp3xN290Yy+RoiZ5DwO2/lHUSx2mSD4X6oRVrpy
         tpskSTAelpJzYCTWz0L9rksXpB7ZaXi/lMHeuA7j0WYmPK6PuVCsg4/H22HeweRodahQ
         FMIt03qVf8HTs3VWwslDel86ubwLYRC9Z/N6x9iKslAcuYyq14QF90pjV4wfTAHIuti4
         RVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678635003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GnfTEBx0Nlfa/chTK4qukddUAosUQzWsROtATVXXDc=;
        b=nHk/74M/m88oc5vkEclouTy2t1Jma6L1FODlcckupStE9os6XKg2ejf5pgaZKeud+Q
         6br010xxfNyB+tTtSU5D7IpTDHjvVp28VXaScWMsngkyya031dwkm9okU+hy7stkZVro
         ywOmMp1jb0hZbNeVPVHENibFSgYhPDPc7jKoq3GFy/mlYxU4eDVWopPXImBShwvmPIH8
         OMtcFQmJqYYvaaVZ7UAa0vaN2+oeRtGrLTJVt/ywrtHWzuStfM+V8eXSNxYb/OpmTsov
         TlkTxbC0RDjTB5XF8r4NfvzOjVfloeMViJD75k7lHEqZ1W85ziYdBVbDFoWuIYcvBxN9
         +DhQ==
X-Gm-Message-State: AO0yUKXCnc6fnodjwwYhrGN955w+UDddFEBYdThssAu5Hjklrpy0knMy
        ziYTUo/QU//l3gTFJjTSJ8bLUQ==
X-Google-Smtp-Source: AK7set9/WeDJMqach+3/EpgfQ0WRXp4GQITTAByqxtX5NWKvITk/16WI7vbBgkNI1qmmswy+KNUtow==
X-Received: by 2002:a17:90a:ab06:b0:230:9ae4:b5e2 with SMTP id m6-20020a17090aab0600b002309ae4b5e2mr7515656pjq.0.1678635002676;
        Sun, 12 Mar 2023 08:30:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709029a4700b0019adfb96084sm3022093plv.36.2023.03.12.08.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 08:30:02 -0700 (PDT)
Message-ID: <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
Date:   Sun, 12 Mar 2023 09:30:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/23 1:45?PM, Pavel Begunkov wrote:
> On 3/11/23 17:24, Jens Axboe wrote:
>> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>>> io_uring extensively uses task_work, but when a task is waiting
>>> for multiple CQEs it causes lots of rescheduling. This series
>>> is an attempt to optimise it and be a base for future improvements.
>>>
>>> For some zc network tests eventually waiting for a portion of
>>> buffers I've got 10x descrease in the number of context switches,
>>> which reduced the CPU consumption more than twice (17% -> 8%).
>>> It also helps storage cases, while running fio/t/io_uring against
>>> a low performant drive it got 2x descrease of the number of context
>>> switches for QD8 and ~4 times for QD32.
>>>
>>> Not for inclusion yet, I want to add an optimisation for when
>>> waiting for 1 CQE.
>>
>> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
>> that, and I see context rates of around 8.1-8.3M/sec with the current
>> kernel.
>>
>> Applied the two patches, but didn't see much of a change? Performance is
>> about the same, and cx rate ditto. Confused... As you probably know,
>> this test waits for 32 ios at the time.
> 
> If I'd to guess it already has perfect batching, for which case
> the patch does nothing. Maybe it's due to SSD coalescing +
> small ro I/O + consistency and small latencies of Optanes,
> or might be on the scheduling and the kernel side to be slow
> to react.
> 
> I was looking at trace_io_uring_local_work_run() while testing,
> It's always should be @loop=QD (i.e. 32) for the patch, but
> the guess is it's also 32 with that setup but without patches.

It very well could be that it's just loaded enough that we get perfect
batching anyway. I'd need to reuse some of your tracing to know for
sure.

>> Didn't take a closer look just yet, but I grok the concept. One
>> immediate thing I'd want to change is the FACILE part of it. Let's call
>> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
> 
> I don't really care, will change, but let me also ask why?
> They're more or less synonyms, though facile is much less
> popular. Is that your reasoning?

Yep, it's not very common and the name should be self-explanatory
immediately for most people.

-- 
Jens Axboe

