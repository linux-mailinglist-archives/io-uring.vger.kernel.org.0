Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813D74DDC32
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 15:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiCROx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 10:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiCROx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 10:53:29 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0078046170
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:52:08 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id x9so5974162ilc.3
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=MAVgxuypyu7ZebO/vEDmryq+fX3OVhvZ+pHEAgQEAX0=;
        b=2W6elKddwieHo1Ef1EKzP2UeiNqfTeLSWelcun61Zu3vw5nHd/QkckJgSLnISoGSgO
         ZLuD4sMayH2ZENy0/WghIrLnEVUTy3HG64ifTQmPAT7c/z6U3K94ccyhMhOTBLL9SJ7I
         3YMbWTKPc+/6pbV/nvKKcRDzPeX2NdNQaBIPhm7+FGK67NGTH77bbfQkNj0U0xBisFLj
         UQOjtqBBY9+dQ7m6WQo2PSWGwsSHrEHxhBkf8onRh2gB2mgqRha2SMnYQ9QVuZGo5px0
         nBD3dFY6qmfZ7fttwtfUMLSxS4x8qLt8OsgtVbiilhLy8nAZRrOV8A5vH8/XoFGRwyF6
         FqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MAVgxuypyu7ZebO/vEDmryq+fX3OVhvZ+pHEAgQEAX0=;
        b=eEWe/qhka1UEkO91OoAAotGiQa3gfhd5H9SKUJRGjgPZoX+Gp/qDp4P+Yf3ljx6hmJ
         h0nx2NSye1SALtvRdGzeJ74ifPQM9LMzCvToXpt7dq8A+wPtRTI/UtdTVGK5JXJBd/OS
         qkg9WCn/lMGNssaTIGZb0Ragzd+bq/4KtffOPADOdFAfzJOyFf1BCBxJSBw3kbyBFdy1
         fut0Uld1J1LHEP94X//DsdsseKyAID+ruiMfSswgYn0MoW+2eCYJVf8674QIHdpaGiex
         cwol2fbkZm2z8rTUIDFyokZk6eqlbOeFkTU2Q2a5KPrcwZzojGDXTl39aoMx0U4RFRAa
         WP0A==
X-Gm-Message-State: AOAM533p/yDnySTOEulv++e+39WLheb9HJFv4nL4RovtTyBLfccbxK73
        Shn180sgafyQvLOLDHoj8I4ucynJGro8PAzO
X-Google-Smtp-Source: ABdhPJwPmXGSeSuHlltxLk+BZsvreAQyXQ+J+VhtLuyhufRL2NCRmH/q8/MhJIW0EQEyBG3PI4lkKg==
X-Received: by 2002:a05:6e02:2183:b0:2c7:fe42:7b07 with SMTP id j3-20020a056e02218300b002c7fe427b07mr1086399ila.302.1647615127910;
        Fri, 18 Mar 2022 07:52:07 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q5-20020a056e0220e500b002c79a587c4bsm5417013ilv.4.2022.03.18.07.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 07:52:07 -0700 (PDT)
Message-ID: <23c1e47b-45e5-242f-a563-d257a7de88ed@kernel.dk>
Date:   Fri, 18 Mar 2022 08:52:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC 0/4] completion locking optimisation feature
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 8:42 AM, Pavel Begunkov wrote:
> On 3/18/22 13:52, Pavel Begunkov wrote:
>> A WIP feature optimising out CQEs posting spinlocking for some use cases.
>> For a more detailed description see 4/4.
>>
>> Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
>> QD=1, and ~+2.5% for QD=4.
> 
> Non-io_uring overhead (syscalls + userspace) takes ~60% of all execution
> time, so the percentage should quite depend on the CPU and the kernel config.
> Likely to be more than 4% for a faster setup.
> 
> fwiw, was also usingIORING_ENTER_REGISTERED_RING, if it's not yet included
> in the upstream version of the tool.

But that seems to be exclusive of using PRIVATE_CQ?

> Also, want to play after to see if we can also avoid taking uring_lock.

That would certainly also be interesting!


-- 
Jens Axboe

