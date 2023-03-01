Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96696A7233
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 18:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCARfq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 12:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCARfp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 12:35:45 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8F147427
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 09:35:27 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id d12so5685863ioe.10
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 09:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677692127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=herTKowxo0WdfO8RQXq/PlWYz+Q+s0/O5A888s6Am3Y=;
        b=ZCbI6lpc9cOvzMEEBHFrndmb294kEF9g4VtKfEAm1yZa1dOh4+GXLSLWU+gEPR/vH3
         TaO7tqJ9XORc4JxyoX2Q+EdCMV7j1l8PwYYO3BsAjkllaoYYdohwbWXB8zc5uC/E43bv
         yhzp0a0kA+EP8/HbYAnLCP/eeL4wA5jzuvRx6g4paMkyxWbDZiz55vIPh3L+69F6n0Rz
         Bn44YNTsB8RO1bXCyEf+1YbYdCZr/aQli6dk1L5zH1q3lSKLtyBo1VBphoGi87Ivj1TT
         LSiwa8uxSWLxwjaQ6vDJeqpDbJcXbTgjYne6FcVF/9OTcTSqp7FqRyin+sWWlVU7DhvR
         XmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677692127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=herTKowxo0WdfO8RQXq/PlWYz+Q+s0/O5A888s6Am3Y=;
        b=u/EkZujDeL07DPU+zMRr24OiNZ+IWGmVwqaOvLp1Ad3SnF/8PIKzRjWVifGioNWHHD
         GLiGl2/8/g6GBqnq13NVfuJ9WcQtN1YxhJTy34QQcY6TvrL4mqh1lgB9sdFflNsL/CU8
         q1d6Anve9j3yBkDFyL1wVA+c8M3poRj1IBX0597mUc66ZdwLEDgNemFDtj1yhzncLMJG
         oVTrJXVnZxHhwKP4RWW/a2r3FMGTXe/ZB2tR8Ng/TvOaRziqyPhj2frhg0aCYr5sQDic
         AkgEC7ln2SOQ5OebQGUUIIL6xsDdkLtHJVoYLxmsfUKKozZKMC7A59VpKvLmpEVeHIFH
         vZ5Q==
X-Gm-Message-State: AO0yUKUcVRb1r8UF/56Ry9CtJEo4rSFxsmuh0tYIJo3B3cKWoe7lHbHZ
        UjlZmU68tBrGNiBxaohPWRDBKxYcEQqjzkil
X-Google-Smtp-Source: AK7set/bqYK5O4Ivk9QZRU+rvQvpgv8YBZ/ygNoTVcunwTSGr/IGHb/xOH9TMscpcx/M0fRB5EiuHA==
X-Received: by 2002:a05:6602:13c5:b0:746:c86d:390e with SMTP id o5-20020a05660213c500b00746c86d390emr6939915iov.0.1677692127036;
        Wed, 01 Mar 2023 09:35:27 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h11-20020a5e974b000000b00746cb6d90c0sm4038774ioq.14.2023.03.01.09.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 09:35:26 -0800 (PST)
Message-ID: <0ca484de-0af1-b506-5ded-fa125bee1bcb@kernel.dk>
Date:   Wed, 1 Mar 2023 10:35:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC v2 2/3] io_uring: add fixed poll support
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20211028122850.13025-1-xiaoguang.wang@linux.alibaba.com>
 <20211028122850.13025-2-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20211028122850.13025-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/21 6:28?AM, Xiaoguang Wang wrote:
> Recently I spend time to research io_uring's fast-poll and multi-shot's
> performance using network echo-server model. Previously I always thought
> fast-poll is better than multi-shot and will give better performance,
> but indeed multi-shot is almost always better than fast-poll in real
> test, which is very interesting. I use ebpf to have some measurements,
> it shows that whether fast-poll is excellent or not depends entirely on
> that the first nowait try in io_issue_sqe() succeeds or fails. Take
> io_recv operation as example(recv buffer is 16 bytes):
>   1) the first nowait succeeds, a simple io_recv() is enough.
> In my test machine, successful io_recv() consumes 1110ns averagely.
> 
>   2) the first nowait fails, then we'll have some expensive work, which
> contains failed io_revc(), apoll allocations, vfs_poll(), miscellaneous
> initializations anc check in __io_arm_poll_handler() and a final
> successful io_recv(). Among then:
>     failed io_revc() consumes 620ns averagely.
>     vfs_poll() consumes 550ns averagely.
> I don't measure other overhead yet, but we can see if the first nowait
> try fails, we'll need at least 2290ns(620 + 550 + 1110) to complete it.
> In my echo server tests, 40% of first nowait io_recv() operations fails.
> 
> From above measurements, it can explain why mulit-shot is better than
> multi-shot, mulit-shot can ensure the first nowait try succeed.
> 
> Based on above measurements, I try to improve fast-poll a bit:
> Introduce fix poll support, currently it only works in file registered
> mode. With this feature, we can get rid of various repeated operations
> in io_arm_poll_handler(), contains apoll allocations, and miscellaneous
> initializations anc check.

I was toying with an idea on how to do persistent poll support,
basically moving the wait_queue_entry out of io_poll and hence detaching
it from the io_kiocb. That would allow a per-file (and type) poll entry
to remain persistent in the kernel rather than needing to do this
expensive work repeatedly. Pavel kindly reminded me of your work, which
unfortunately I had totally forgotten.

Did you end up taking this further? My idea was to make it work
independently of fixed files, but I also don't want to reinvent the
wheel if you ended up with something like this.

-- 
Jens Axboe

