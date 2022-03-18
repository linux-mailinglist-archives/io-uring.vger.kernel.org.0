Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1244DDC8F
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 16:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiCRPPy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 11:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiCRPPw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 11:15:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB9A3D494
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:14:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r7so5024387wmq.2
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=y3o6Y/DheivV5JB+aOhwyukr3t+cVTHHIWQTaVASZyg=;
        b=fYqJMq6nW99DccdYqsy42xRhN74X0GbyEsBDyuT8akC17mfz6BFCbucL0WYmo0lFTt
         f3mH0uBCaS2G3d+TtwcmgzMKyEdpSaUfKBZrBC9Y83pa4oEhkkMvR9X4v6yRvwn/MmjW
         swjFP6AzrPOgXh2Gs/nZ6H7LGH8w1uBjqTmyzb3nOPpJFY5hPLe5qwWJOyGqJRUVbUKL
         CUonaRuWtGtNxxyaZisgulpnXf0Lx19g3oTQihD5jVhLrNQ2L820a7tFjx1Y2EeM53QF
         K4yCOx/dcB9Ez8T29j7ju52M6YY7rEPf9vm4K8IrkV92RB9ebPdktdQHSYDSp9G7TSGq
         4poA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y3o6Y/DheivV5JB+aOhwyukr3t+cVTHHIWQTaVASZyg=;
        b=5F+2T1F1HbrgK2P7ysTXZzSInQ4L5JbZYj1uHFom43u5dwd0WHaFTL3FpDlZ+2g+2U
         JBpwtlXq5uPFE9M+fNzf6VWZAfvQH49CO+aygVMXlGW+D6GCjGBi8krAShP4cgLhnkaA
         sww+Fv8L0uqiZxlKoNka7IRusTXrDRaIdvOc4c5QVP5xmXbiGuFsfoXw1Z9wMIVLs0Xy
         J3yEAC01F62xKeZ6MM+ok3b/U5mShsoPSEhvY3r+UZq7RPm1lY2NmcFUTPckvvW5qzg9
         meS7NdexmliMyH9GfZ49IRtEeZlR5vx4825sBDEP+Zj3EhOP7xjEcqBmW5f4s2q0Xig0
         oEbA==
X-Gm-Message-State: AOAM531UgM7YJIrgiBpVHDmDK8luJlVlEpEMaI1Vf/O271f7hAfcVfyD
        I1513deoFE6HSaRMibAvH8R4zsKWhtGtJg==
X-Google-Smtp-Source: ABdhPJyfk67yrZ7MCSvVVLzkRy49aUEpNzqnlagMiGGuIcPTwkjJel3cyaKd993r2VpnIo9wC6rAkQ==
X-Received: by 2002:a7b:c758:0:b0:38b:85cf:8a26 with SMTP id w24-20020a7bc758000000b0038b85cf8a26mr14710202wmk.76.1647616470649;
        Fri, 18 Mar 2022 08:14:30 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id l18-20020adfe592000000b001f064ae9830sm6480760wrm.37.2022.03.18.08.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:14:30 -0700 (PDT)
Message-ID: <7ef3335a-8e7c-d559-5a78-f48bf506f53c@gmail.com>
Date:   Fri, 18 Mar 2022 15:13:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 4/4] io_uring: optimise compl locking for non-shared rings
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
 <3530662a-0ae0-996c-79ee-cc4db39b965a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3530662a-0ae0-996c-79ee-cc4db39b965a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 14:54, Jens Axboe wrote:
> On 3/18/22 7:52 AM, Pavel Begunkov wrote:
>> When only one task submits requests, most of CQEs are expected to be
>> filled from that task context so we have natural serialisation. That
>> would mean that in those cases we don't need spinlocking around CQE
>> posting. One downside is that it also mean that io-wq workers can't emit
>> CQEs directly but should do it through the original task context using
>> task_works. That may hurt latency and performance and might matter much
>> to some workloads, but it's not a huge deal in general as io-wq is a
>> slow path and there is some additional merit from tw completion
>> batching.
> 
> Not too worried about io-wq task_work for cq filling, it is the slower
> path after all. And I think we can get away with doing notifications as
> it's just for CQ filling. If the task is currently waiting in
> cqring_wait, then it'll get woken anyway and it will process task work.
> If it's in userspace, it doesn't need a notification. That should make
> it somewhat lighter than requiring using TIF_NOTIFY_SIGNAL for that.
> 
>> The feature should be opted-in by the userspace by setting a new
>> IORING_SETUP_PRIVATE_CQ flag. It doesn't work with IOPOLL, and also for
>> now only the task that created a ring can submit requests to it.
> 
> I know this is a WIP, but why do we need CQ_PRIVATE? And this needs to

One reason is because of the io-wq -> tw punting, which is not optimal
for e.g. active users of IOSQE_ASYNC. The second is because the
fundamental requirement is that only one task should be submitting
requests. Was thinking about automating it, e.g. when we register
a second tctx we go through a slow path waiting for all current tw
to complete and then removing an internal and not userspace visible
CQ_PRIVATE flag.

Also, as SQPOLL task is by definition the only one submitting SQEs,
was thinking about enabling it by default for them, but didn't do
because of the io-wq / IOSQE_ASYNC.

> work with registered files (and ring fd) as that is probably a bigger
> win than skipping the completion_lock if you're not shared anyway.

It does work with fixed/registered files and registered io_uring fds.

In regards of "a bigger win", probably in many cases, but if you submit
a good batch at once, and completion tw batching doesn't kick in (e.g.
direct bdev read of not too high intensity), it might save
N spinlock/unlock when registered ring fd would kill only one pair of
fdget/fdput.

-- 
Pavel Begunkov
