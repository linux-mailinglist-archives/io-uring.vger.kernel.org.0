Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1346B0BCB
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 15:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjCHOrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 09:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCHOrQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 09:47:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647C7D08C1
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 06:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678286692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rh/7jxsAjlNSCe5Vflj31Md50O7qavIBLm45Q9D7gLI=;
        b=QBfNt/KYR5cZuQSqeg8csavI3SNBVbEJdJlL7BYIWYedHjZKEl8hoMevlaz+RR+6VTQyc1
        17C4b/4tfEm5gq8uvrL5hn9R/mS7UkmCTTqqrdB7rRSzCw6wmDm/Drlo1l8KCcv3hchCkW
        T5PI3V9Nh0TOfrFz84xHXzxyLsu5fi8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-fmhWAUmHM26YuoL8bJAz0A-1; Wed, 08 Mar 2023 09:44:51 -0500
X-MC-Unique: fmhWAUmHM26YuoL8bJAz0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7909E8021B6;
        Wed,  8 Mar 2023 14:44:50 +0000 (UTC)
Received: from [10.22.33.96] (unknown [10.22.33.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30DC4112132D;
        Wed,  8 Mar 2023 14:44:50 +0000 (UTC)
Message-ID: <377ee062-c899-b0c2-969e-268c8cfce87c@redhat.com>
Date:   Wed, 8 Mar 2023 09:44:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Daniel Dao <dqminh@cloudflare.com>
Cc:     io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
 <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
 <074823f4-993c-8caf-bd93-70589c4aae42@kernel.dk>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <074823f4-993c-8caf-bd93-70589c4aae42@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/23 09:26, Jens Axboe wrote:
> On 3/8/23 7:20?AM, Waiman Long wrote:
>> On 3/8/23 06:42, Daniel Dao wrote:
>>> Hi all,
>>>
>>> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
>>> worker threads are running. Here are the steps to reproduce the failure
>>> on kernel 6.1.14:
>>>
>>> 1. Remove cpuset from subtree_control
>>>
>>>     > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
>>> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>>>     > cat /sys/fs/cgroup/cgroup.subtree_control
>>>     cpu io memory pids
>>>
>>> 2. Run any applications that utilize the uring worker thread pool. I used
>>>      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
>>>
>>>     > cargo run -- -a -w 2 -t 2
>>>
>>> 3. Enabling cpuset will return EINVAL
>>>
>>>     > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>>>     +cpuset
>>>     tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
>>>
>>> We traced this down to task_can_attach that will return EINVAL when it
>>> encounters
>>> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
>>>
>>> This seems like an unexpected interaction when enabling cpuset for the subtrees
>>> that contain kthreads. We are currently considering a workaround to try to
>>> enable cpuset in root subtree_control before any io_uring applications
>>> can start,
>>> hence failure to enable cpuset is localized to only cgroup with
>>> io_uring kthreads.
>>> But this is cumbersome.
>>>
>>> Any suggestions would be very much appreciated.
>> Anytime you echo "+cpuset" to cgroup.subtree_control to enable cpuset,
>> the tasks within the child cgroups will do an implicit move from the
>> parent cpuset to the child cpusets. However, that move will fail if
>> any task has the PF_NO_SETAFFINITY flag set due to task_can_attach()
>> function which checks for this. One possible solution is for the
>> cpuset to ignore tasks with PF_NO_SETAFFINITY set for implicit move.
>> IOW, allowing the implicit move without touching it, but not explicit
>> one using cgroup.procs.
> I was pondering this too as I was typing my reply, but at least for
> io-wq, this report isn't the first to be puzzled or broken by the fact
> that task threads might have PF_NO_SETAFFINITY set. So while it might be
> worthwhile to for cpuset to ignore PF_NO_SETAFFINITY as a separate fix,
> I think it's better to fix io-wq in general. Not sure we have other
> cases where it's even possible to have PF_NO_SETAFFINITY set on
> userspace threads?

Changing current cpuset behavior is an alternative solution. It is a 
problem anytime a task (user or kthread) has PF_NO_SETAFFINITY set but 
not in the root cgroup. Besides io_uring, I have no idea if there is 
other use cases out there. It is just a change we may need to do in the 
future if there are other similar cases. Since you are fixing it on the 
io-wq side, it is not an urgent issue that needs to be addressed from 
the cpuset side.

Thanks,
Longman

