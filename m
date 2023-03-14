Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E09D6B9E16
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 19:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCNSSX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 14:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNSSQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 14:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108F385A71
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 11:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678817847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/ZtBwgB7cTsUBrCI6syMahmMU7UxQQ3MRmKHMli2aQ=;
        b=VqWC+wAwSXOoHwA0u0Yf260o+QNdz9PNF9+/v1BxK9rI8kl58naPgxAFbuplc9bBpYdoMw
        m4Y84YVnp7a/DAIc22mfeLQOPVGYH9wnEb7a8m6EFF3IV0I1PlhlZ0mhN91lAnan4A5Arv
        73SC0dLUqsFvhCl/Cv9ElqW8ebxYovI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-BKN_3FgsOWWNzusJqb1PPA-1; Tue, 14 Mar 2023 14:17:23 -0400
X-MC-Unique: BKN_3FgsOWWNzusJqb1PPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECF13858F09;
        Tue, 14 Mar 2023 18:17:22 +0000 (UTC)
Received: from [10.22.18.199] (unknown [10.22.18.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2B014042AC0;
        Tue, 14 Mar 2023 18:17:22 +0000 (UTC)
Message-ID: <05c48a47-cfb2-af73-6709-f622fd254f89@redhat.com>
Date:   Tue, 14 Mar 2023 14:17:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq
 workers
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Daniel Dao <dqminh@cloudflare.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        cgroups@vger.kernel.org
References: <0f0e791b-8eb8-fbb2-ea94-837645037fae@kernel.dk>
 <CA+wXwBRGzfZB9tjKy5C2_pW1Z4yH2gNGxx79Fk-p3UsOWKGdqA@mail.gmail.com>
 <20230314162559.pnyxdllzgw7jozgx@blackpad>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20230314162559.pnyxdllzgw7jozgx@blackpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/14/23 12:25, Michal Koutný wrote:
> Hello.
>
> On Tue, Mar 14, 2023 at 10:07:40AM +0000, Daniel Dao <dqminh@cloudflare.com> wrote:
>> IMO this violated the principle of cpuset and can be confusing for end users.
>> I think I prefer Waiman's suggestion of allowing an implicit move to cpuset
>> when enabling cpuset with subtree_control but not explicit moves such as when
>> setting cpuset.cpus or writing the pids into cgroup.procs. It's easier to reason
>> about and make the failure mode more explicit.
>>
>> What do you think ?
> I think cpuset should top IO worker's affinity (like sched_setaffinity(2)).
> Thus:
> - modifying cpuset.cpus	                update task's affinity, for sure
> - implicit migration (enabling cpuset)  update task's affinity, effective nop
Note that since commit 7fd4da9c158 ("cgroup/cpuset: Optimize 
cpuset_attach() on v2") in v6.2, implicit migration (enabling cpuset) 
will not affect the cpu affinity of the process.
> - explicit migration (meh)              update task's affinity, ¯\_(ツ)_/¯
>
> My understanding of PF_NO_SETAFFINITY is that's for kernel threads that
> do work that's functionally needed on a given CPU and thus they cannot
> be migrated [1]. As said previously for io_uring workers, affinity is
> for performance only.
>
> Hence, I'd also suggest on top of 01e68ce08a30 ("io_uring/io-wq: stop
> setting PF_NO_SETAFFINITY on io-wq workers"):
>
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
>                  set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
>          else
>                  set_cpus_allowed_ptr(current, cpu_online_mask);
> -       current->flags |= PF_NO_SETAFFINITY;
>
>          mutex_lock(&sqd->lock);
>          while (1) {
>
> Afterall, io_uring_setup(2) already mentions:
>> When cgroup setting cpuset.cpus changes (typically in container
>> environment), the bounded cpu set may be changed as well.

Using sched_setaffiinity(2) can be another alternative. Starting from 
v6.2, cpu affinity set by sched_affiinity(2) will be more or less 
maintained and constrained by the current cpuset even if the cpu list is 
being changed as long as there is overlap between the two. The 
intersection between cpu affinity set by sched_setaffinity(2) and the 
effective_cpus in cpuset will be the effective cpu affinity of the task.

Cheers,
Longman

