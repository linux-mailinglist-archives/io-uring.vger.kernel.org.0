Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA0C5E584D
	for <lists+io-uring@lfdr.de>; Thu, 22 Sep 2022 03:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiIVByl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 21:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiIVByj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 21:54:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F28B01
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 18:54:32 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 3so7734289pga.1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 18:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=v7udx63NJLPOWnkmiZoa0Esgcb0822FZgS1XvDl3bDM=;
        b=Mp780LFDO1D6TvZI6HEIyl72aJodqLT/UzmQDcDGyTpoKjwicarElWc90PWCqxqe5J
         tJ6NDKrhlGwcwBCqhNFTjpcWr1CfO4srCm/6MjMq6nN1xWLew+yXCZtZaSe+gYNLOIPe
         1S9P2UV9tGDoIN0dCAer3ImuCdNKFLv+9AfpCz9Rf6YSpRcmG5qLUmw4HEYCEQ4i9ahw
         ox+wb3TY3zgRI0m5hUskFsiacg+JxUNWBB08dfD2SH/Fs1JkVGiN8zwBOk180WXVqzr3
         tCJqjGf5UecKcjGsFrBgoS+7sFCdvWFuw8HkE4QJTQT4/135N85NFrtljgHH/amGY8UW
         Ma0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=v7udx63NJLPOWnkmiZoa0Esgcb0822FZgS1XvDl3bDM=;
        b=xykugGxrEi7QTUfXE8kctXddGOv53VInEseM1u/XIYAdPDuFZu5QkQPbgnATIvzUgK
         KoKb2qOesPaz2V8X4Iv59fsQeoX6Lzc6lFj1VqrPrRuTm/fXC7R/s2AkaKBm5fu2piCx
         dOp0EZbStJYada3KOpEHGaLheDf6uyLHmSpKjEve7v1TJ1wYTd8jbsvzXtNDdEY96lVf
         WCEBaaFbAIyUpQrf3vq6VR6+HSqe5WaeAtuLN8LK/XhQ8H3vaw2TJUVTGcImRXUgphCP
         RUcFOn+wBMlLzbXnjymGOEjmG//bbX7aNpROJ+2G1rVLHqysKZWCjCdjEyYG7FBdA7jt
         dLIA==
X-Gm-Message-State: ACrzQf2zjSYI2EwhX06ELDXzKa0EFT9p0/kqheS8PwMdV7p0UFknSxYr
        JlWH0xUdmR2urlafiSHjrUdZ6t+RNhdb3Q==
X-Google-Smtp-Source: AMsMyM7UR8Gh40vbiw77NwquHP3i5uDNmoODc3JPggPw2vMFNLaCxi4sUpo8qxEQb0n8Ki7OFVaLBg==
X-Received: by 2002:a05:6a00:189d:b0:53e:79de:3fc1 with SMTP id x29-20020a056a00189d00b0053e79de3fc1mr1199895pfh.2.1663811672005;
        Wed, 21 Sep 2022 18:54:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i62-20020a17090a3dc400b001facf455c91sm2570287pjc.21.2022.09.21.18.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 18:54:31 -0700 (PDT)
Message-ID: <20adf5fe-98a0-06a0-7058-e6f9ba7d9e2a@kernel.dk>
Date:   Wed, 21 Sep 2022 19:54:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Memory ordering description in io_uring.pdf
Content-Language: en-US
To:     "J. Hanne" <io_uring@jf.hanne.name>, io-uring@vger.kernel.org
References: <20220918165616.38AC12FC059D@dd11108.kasserver.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220918165616.38AC12FC059D@dd11108.kasserver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/22 10:56 AM, J. Hanne wrote:
> Hi,
> 
> I have a couple of questions regarding the necessity of including memory
> barriers when using io_uring, as outlined in
> https://kernel.dk/io_uring.pdf. I'm fine with using liburing, but still I
> do want to understand what is going on behind the scenes, so any comment
> would be appreciated.

In terms of the barriers, that doc is somewhat outdated...

> Firstly, I wonder why memory barriers are required at all, when NOT using
> polled mode. Because requiring them in non-polled mode somehow implies that:
> - Memory re-ordering occurs across system-call boundaries (i.e. when
>   submitting, the tail write could happen after the io_uring_enter
>   syscall?!)
> - CPU data dependency checks do not work
> So, are memory barriers really required when just using a simple
> loop around io_uring_enter with completely synchronous processing?

No, I don't beleive that they are. The exception is SQPOLL, as you mention,
as there's not necessarily a syscall involved with that.

> Secondly, the examples in io_uring.pdf suggest that checking completion
> entries requires a read_barrier and a write_barrier and submitting entries
> requires *two* write_barriers. Really?
> 
> My expectation would be, just as with "normal" inter-thread userspace ipc,
> that plain store-release and load-acquire semantics are sufficient, e.g.: 
> - For reading completion entries:
> -- first read the CQ ring head (without any ordering enforcement)
> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the CQ ring tail
> -- then use __atomic_store(__ATOMIC_RELEASE) to update the CQ ring head
> - For submitting entries:
> -- first read the SQ ring tail (without any ordering enforcement)
> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the SQ ring head
> -- then use __atomic_store(__ATOMIC_RELEASE) to update the SQ ring tail
> Wouldn't these be sufficient?!

Please check liburing to see what that does. Would be interested in
your feedback (and patches!). Largely x86 not caring too much about
these have meant that I think we've erred on the side of caution
on that front.

> Thirdly, io_uring.pdf and
> https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c seem a
> little contradicting, at least from my reading:
> 
> io_uring.pdf, in the completion entry example:
> - Includes a read_barrier() **BEFORE** it reads the CQ ring tail
> - Include a write_barrier() **AFTER** updating CQ head
> 
> io_uring.c says on completion entries:
> - **AFTER** the application reads the CQ ring tail, it must use an appropriate
>   smp_rmb() [...].
> - It also needs a smp_mb() **BEFORE** updating CQ head [...].
> 
> io_uring.pdf, in the submission entry example:
> - Includes a write_barrier() **BEFORE** updating the SQ tail
> - Includes a write_barrier() **AFTER** updating the SQ tail
> 
> io_uring.c says on submission entries:
> - [...] the application must use an appropriate smp_wmb() **BEFORE**
>   writing the SQ tail
>   (this matches io_uring.pdf)
> - And it needs a barrier ordering the SQ head load before writing new
>   SQ entries
>   
> I know, io_uring.pdf does mention that the memory ordering description
> is simplified. So maybe this is the whole explanation for my confusion?

The canonical resource at this point is the kernel code, as some of
the revamping of the memory ordering happened way later than when
that doc was written. Would be nice to get it updated at some point.

-- 
Jens Axboe


