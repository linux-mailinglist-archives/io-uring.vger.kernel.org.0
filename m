Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687F16B0AEC
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 15:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjCHOVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 09:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCHOU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 09:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5634E8ABEF
        for <io-uring@vger.kernel.org>; Wed,  8 Mar 2023 06:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678285212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sops4x68iLJ61ANNFLgKRCF7RTvxeEpyHCZSHbGz/Ks=;
        b=VMqr8644yFH+kx5srnMvFXz+V3j1fHAt3fCEHsQLG1pDmNbufrLqxorhubfNbzkzBo7491
        UtubdnqlU/H0I/JwqEKSSp7XjEZ0PFm1xf/Vsi7DtfAtj8RGs9s516hlqIvPKKEQyTzhvI
        9cNqA8OPolFHXYxmuv8Z2GFmnzy0VQQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-xpmiKAVZP_-wKtAP1PB58w-1; Wed, 08 Mar 2023 09:20:10 -0500
X-MC-Unique: xpmiKAVZP_-wKtAP1PB58w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD0103C0E459;
        Wed,  8 Mar 2023 14:20:09 +0000 (UTC)
Received: from [10.22.33.96] (unknown [10.22.33.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93288C15BA0;
        Wed,  8 Mar 2023 14:20:09 +0000 (UTC)
Message-ID: <c069bcff-8229-4284-b973-e427ccf20b64@redhat.com>
Date:   Wed, 8 Mar 2023 09:20:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Unexpected EINVAL when enabling cpuset in subtree_control when
 io_uring threads are running
Content-Language: en-US
To:     Daniel Dao <dqminh@cloudflare.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/23 06:42, Daniel Dao wrote:
> Hi all,
>
> We encountered EINVAL when enabling cpuset in cgroupv2 when io_uring
> worker threads are running. Here are the steps to reproduce the failure
> on kernel 6.1.14:
>
> 1. Remove cpuset from subtree_control
>
>    > for d in $(find /sys/fs/cgroup/ -maxdepth 1 -type d); do echo
> '-cpuset' | sudo tee -a $d/cgroup.subtree_control; done
>    > cat /sys/fs/cgroup/cgroup.subtree_control
>    cpu io memory pids
>
> 2. Run any applications that utilize the uring worker thread pool. I used
>     https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-io_uring-worker-pool
>
>    > cargo run -- -a -w 2 -t 2
>
> 3. Enabling cpuset will return EINVAL
>
>    > echo '+cpuset' | sudo tee -a /sys/fs/cgroup/cgroup.subtree_control
>    +cpuset
>    tee: /sys/fs/cgroup/cgroup.subtree_control: Invalid argument
>
> We traced this down to task_can_attach that will return EINVAL when it
> encounters
> kthreads with PF_NO_SETAFFINITY, which io_uring worker threads have.
>
> This seems like an unexpected interaction when enabling cpuset for the subtrees
> that contain kthreads. We are currently considering a workaround to try to
> enable cpuset in root subtree_control before any io_uring applications
> can start,
> hence failure to enable cpuset is localized to only cgroup with
> io_uring kthreads.
> But this is cumbersome.
>
> Any suggestions would be very much appreciated.

Anytime you echo "+cpuset" to cgroup.subtree_control to enable cpuset, 
the tasks within the child cgroups will do an implicit move from the 
parent cpuset to the child cpusets. However, that move will fail if any 
task has the PF_NO_SETAFFINITY flag set due to task_can_attach() 
function which checks for this. One possible solution is for the cpuset 
to ignore tasks with PF_NO_SETAFFINITY set for implicit move. IOW, 
allowing the implicit move without touching it, but not explicit one 
using cgroup.procs.

Cheers,
Longman

