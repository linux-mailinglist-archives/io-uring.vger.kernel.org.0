Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F296B0B14
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 15:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjCHO1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 09:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjCHO1X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 09:27:23 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53FCB659
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 06:26:53 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p6so9751362pga.0
        for <io-uring@vger.kernel.org>; Wed, 08 Mar 2023 06:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678285613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6DzypvQ9Ir4BceedTjh7GQOOsJgVNAfYu10w2CD9pqk=;
        b=Pyf8V3e9hyJO+g4hHyoq1KA7bcPTty4SEJ3OnQ+9kxx1oE+MLTkxL8BS4TVXPGP+Jh
         eSssiNkJcdGMAvHAXux9Z87TAAvJPn7jBSktnB+ZFuoV3b6gmKwv7Fa9M4ijdTc1wSwP
         e3+dUriachwEZC5RKofoob0sqIqscgphpU/aOPwXpJWhfN4foCyLq37qQrxzPL9lyOEt
         i/YsqAyJ7GsQY0UlLHuusw6mVCQ+FDm6jmxapNjrckmdfc2J1KVe+D2IlDMMY9SI3ITL
         a4nwEHIphc6f0gK8rpsylMJpJrhaT4g0Ywy5J4KvLR+P5SRrQ8uz5royHE/q6pxnlbXJ
         nCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678285613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DzypvQ9Ir4BceedTjh7GQOOsJgVNAfYu10w2CD9pqk=;
        b=ASi6DzCJiWAXsXTm4s8cIseFHwJUd/jnQ1oB1XIHWjBCusEhLaRihfKveWtKMcML8d
         /yRUChcJqDErxueUj1zmggLXYfEkAhoztTsOrJPwbnTFnmbrgktEBi99xs0sLqHW81Rb
         3em8zW8FIma9JFIWtRciy8u/VjdcytBjlU6MCFIMJHBsF4IvzvIg3tpVLuGyDXTDCADe
         CnKdr181MI3SL89NMGqkjcxq1+dZ5j4cCRnE4uA5a3N2R/QmIZ7vnH4GK/hDNpLu6KDx
         RDe//9zRzXkOmvfs6G/hwO2jGhQK3NQzhE4UEw/PYr6F1equPsdzT8qeAbMlgyYpyVp1
         RfPg==
X-Gm-Message-State: AO0yUKUcqkLLAFjFUMNfvULdztgFm6xDNNQ8NPa1X2+dNPdCnJkMSseP
        oC3VvJZ5UGCImrn4YHvigSx9hw==
X-Google-Smtp-Source: AK7set+rYJJTDBOWnCa/b2YmmrMnbgTu/hcqTSPkk3vFIpknj1dpE4/ong9tJr7MIuEdncnMxuFBbA==
X-Received: by 2002:aa7:8804:0:b0:5d1:f76:d1d7 with SMTP id c4-20020aa78804000000b005d10f76d1d7mr2800868pfo.1.1678285612728;
        Wed, 08 Mar 2023 06:26:52 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id 6-20020aa79106000000b0059085684b54sm9851411pfh.140.2023.03.08.06.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 06:26:52 -0800 (PST)
Message-ID: <074823f4-993c-8caf-bd93-70589c4aae42@kernel.dk>
Date:   Wed, 8 Mar 2023 07:26:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Content-Language: en-US
To:     Waiman Long <longman@redhat.com>,
        Daniel Dao <dqminh@cloudflare.com>
Cc:     io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
 <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/23 7:20?AM, Waiman Long wrote:
> On 3/8/23 06:42, Daniel Dao wrote:
>> Hi all,
>>
>> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
>> worker threads are running. Here are the steps to reproduce the failure
>> on kernel 6.1.14:
>>
>> 1. Remove cpuset from subtree_control
>>
>>    > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
>> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>>    > cat /sys/fs/cgroup/cgroup.subtree_control
>>    cpu io memory pids
>>
>> 2. Run any applications that utilize the uring worker thread pool. I used
>>     https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
>>
>>    > cargo run -- -a -w 2 -t 2
>>
>> 3. Enabling cpuset will return EINVAL
>>
>>    > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>>    +cpuset
>>    tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
>>
>> We traced this down to task_can_attach that will return EINVAL when it
>> encounters
>> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
>>
>> This seems like an unexpected interaction when enabling cpuset for the subtrees
>> that contain kthreads. We are currently considering a workaround to try to
>> enable cpuset in root subtree_control before any io_uring applications
>> can start,
>> hence failure to enable cpuset is localized to only cgroup with
>> io_uring kthreads.
>> But this is cumbersome.
>>
>> Any suggestions would be very much appreciated.
> 
> Anytime you echo "+cpuset" to cgroup.subtree_control to enable cpuset,
> the tasks within the child cgroups will do an implicit move from the
> parent cpuset to the child cpusets. However, that move will fail if
> any task has the PF_NO_SETAFFINITY flag set due to task_can_attach()
> function which checks for this. One possible solution is for the
> cpuset to ignore tasks with PF_NO_SETAFFINITY set for implicit move.
> IOW, allowing the implicit move without touching it, but not explicit
> one using cgroup.procs.

I was pondering this too as I was typing my reply, but at least for
io-wq, this report isn't the first to be puzzled or broken by the fact
that task threads might have PF_NO_SETAFFINITY set. So while it might be
worthwhile to for cpuset to ignore PF_NO_SETAFFINITY as a separate fix,
I think it's better to fix io-wq in general. Not sure we have other
cases where it's even possible to have PF_NO_SETAFFINITY set on
userspace threads?

-- 
Jens Axboe

