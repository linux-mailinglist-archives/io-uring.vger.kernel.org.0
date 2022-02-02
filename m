Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E22A4A7825
	for <lists+io-uring@lfdr.de>; Wed,  2 Feb 2022 19:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiBBSmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Feb 2022 13:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiBBSmQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Feb 2022 13:42:16 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CD3C061714;
        Wed,  2 Feb 2022 10:42:15 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id l25so257831wrb.13;
        Wed, 02 Feb 2022 10:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=jD7dDnlbfq+o7nOhWq/APMJyxBDxJ/kNestum5/HP6k=;
        b=J5r75D9PZxre+mg+3pYvsm8T2yUGTn7sXVhQYb8XpA1AppYzi24+n4QekEQGUbvGka
         JEiz3di8J5LMVNMVKbB23CV4aPZh1eWGd01DSUtrLvKW68eJroe4tctidiOHLA7v1pSw
         6DbQcCL8YMuvauQqch8k64p5H4SsKHyky9x+qnuBUwer2t1dOt2QcoLaDxbulUz+iIPW
         YL5WX3MqdfCdQIok2YhVaiEKiSYGnny7UHEIOUYvrtAtJ5WhUiIzQgBKqcDsbFPdTzx4
         UQSxVr+udlMCluqvDc7bhgqiHu7xNyFyC9LejjG3VLZoLZPI55aEQjV4Uk55pWh+y7GP
         R0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=jD7dDnlbfq+o7nOhWq/APMJyxBDxJ/kNestum5/HP6k=;
        b=D8zn7/npoldLTrgDAvOKyJ8Aym0YKMBvp6v0/Xls3RBiFlYu29uuMA9ifH6+gHeVTd
         yMBHIa18DcwVWgUkODDb+r8hgEB64SevDFdrribCnV+vAhd0CGoL1mQEBoaM33mAY86g
         Atwl1WuVH18IxBxLbBExwmNZwq0yCMglfGJnXHbiVUlvz5axMiQy1iiB59NComVvmhHy
         Vf0QCfOaSxdjyo2VbMx5godOS52Z97mrnvaF645AswSPHiIJFmGAm6hjNeNiwPAHldxO
         0iBSkmbHOKmUpgbOG3FN+ChDpwuoRo0Vu+81QL6NtGzDcLDZVMFvjqPtCR3Qz6u4Q6yA
         EWvA==
X-Gm-Message-State: AOAM5308X2UGXI5yfwnQ943y4A6m1ttrqV6qTAWXPaapfCdx6BvZo4JP
        LLJ1Izds2b/ul2HqbST6u6gZQlMQuE8=
X-Google-Smtp-Source: ABdhPJxgAl44G61lRhlbP6q73+r2EVtgN0SPRnQOevV9XoA8JGaWlTuEFfoGnE4+6hJhhHqfG67DNQ==
X-Received: by 2002:a5d:64a9:: with SMTP id m9mr25516012wrp.661.1643827334145;
        Wed, 02 Feb 2022 10:42:14 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id r3sm4134669wrt.102.2022.02.02.10.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:42:13 -0800 (PST)
Message-ID: <ba6a2e40-7638-ca42-f999-e6f40b491165@gmail.com>
Date:   Wed, 2 Feb 2022 18:39:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
 <1337e416-ef4d-8883-ab4f-b36dd88698d6@gmail.com>
In-Reply-To: <1337e416-ef4d-8883-ab4f-b36dd88698d6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/22 18:32, Pavel Begunkov wrote:
> On 2/2/22 16:57, Jens Axboe wrote:
>> On 2/2/22 8:59 AM, Usama Arif wrote:
>>> Acquire completion_lock at the start of __io_uring_register before
>>> registering/unregistering eventfd and release it at the end. Hence
>>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>>> will finish before acquiring the spin_lock in io_uring_register, and
>>> all new calls will wait till the eventfd is registered. This avoids
>>> ring quiesce which is much more expensive than acquiring the spin_lock.
>>>
>>> On the system tested with this patch, io_uring_reigster with
>>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
>>
>> This seems like optimizing for the wrong thing, so I've got a few
>> questions. Are you doing a lot of eventfd registrations (and unregister)
>> in your workload? Or is it just the initial pain of registering one? In
>> talking to Pavel, he suggested that RCU might be a good use case here,
>> and I think so too. That would still remove the need to quiesce, and the
>> posted side just needs a fairly cheap rcu read lock/unlock around it.
> 
> A bit more context:
> 
> 1) there is io_cqring_ev_posted_iopoll() which doesn't hold the lock
> and adding it will be expensive
> 
> 2) there is a not posted optimisation for io_cqring_ev_posted() relying
> on it being after spin_unlock.
> 
> 3) we don't want to unnecessarily extend the spinlock section, it's hot
> 
> 4) there is wake_up_all() inside, so there will be nested locks. That's
> bad for perf, but also because of potential deadlocking. E.g. poll
> requests do locking in reverse order. There might be more reasons.

5) there won't be sync with ctx->cq_ev_fd, and so no rules when
it will start to be visible. Will need to be solved if RCU.

there are probably more caveats, those are off the top of my head


> But there will be no complaints if you do,
> 
> if (evfd) {
>      rcu_read_lock();
>      eventfd_signal();
>      rcu_read_unlock();
> }
> 
> + some sync on the registration front
> 

-- 
Pavel Begunkov
