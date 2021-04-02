Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2DE352B91
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhDBOlj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 10:41:39 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:54421 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235584AbhDBOli (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 10:41:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUFSsNQ_1617374493;
Received: from 30.39.178.133(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UUFSsNQ_1617374493)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 02 Apr 2021 22:41:33 +0800
Subject: Re: [PATCH] io_uring: support multiple rings to share same poll
 thread by specifying same cpu
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210331155926.22913-1-xiaoguang.wang@linux.alibaba.com>
 <0e7acba9-1e45-2891-3461-42ca1485ac61@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <a9c49559-0e94-7244-9d00-c50b537c2118@linux.alibaba.com>
Date:   Fri, 2 Apr 2021 22:38:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <0e7acba9-1e45-2891-3461-42ca1485ac61@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 31/03/2021 16:59, Xiaoguang Wang wrote:
>> We have already supported multiple rings to share one same poll thread
>> by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
>> IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
>> has beed created firstly, that means it will require app to regulate the
>> creation oder between uring instances.
>>
>> Currently we can make this a bit simpler, for those rings which will
>> have SQPOLL enabled and are willing to be bound to one same cpu, add a
>> capability that these rings can share one poll thread by specifying
>> a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
>>    1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
>> try to attach this ring to an existing ring's corresponding poll thread,
>> no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
>> set.
>>    2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
>> for this case, we'll create a single poll thread to be shared by rings
>> rings which have same sq_thread_cpu.
>>    3, for any other cases, we'll just create one new poll thread for the
>> corresponding ring.
>>
>> And for case 2, don't need to regulate creation oder of multiple uring
>> instances, we use a mutex to synchronize creation, for example, say five
>> rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
>> enabled, and are willing to be bound same cpu, one ring that gets the
>> mutex lock will create one poll thread, the other four rings will just
>> attach themselves to the previous created poll thread once they get lock
>> successfully.
>>
>> To implement above function, define below data structs:
>>    struct percpu_sqd_entry {
>>          struct list_head        node;
>>          struct io_sq_data       *sqd;
>>          pid_t                   tgid;
>>    };
>>
>>    struct percpu_sqd_list {
>>          struct list_head        head;
>>          struct mutex            lock;
>>    };
>>
>>    static struct percpu_sqd_list __percpu *percpu_sqd_list;
>>
>> sqthreads that have same sq_thread_cpu will be linked together in a percpu
>> percpu_sqd_list's head. When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU
>> are both enabled, we will use struct io_uring_params' sq_thread_cpu and
>> current-tgid locate corresponding sqd.
> 
> I can't help myself but wonder why not something in the userspace like
> a pseudo-coded snippet below?
Yes, agree with you, this feature can be done in userspace. Indeed I also don't
have a much strong preference that this patch is merged into mainline codes, but it's
really convenient for usrs who want to make multiple rings share one same sqthread
by specifying cpu id.

> 
> BTW, don't think "pid_t tgid" will work with namespaces/cgroups.
In copy_process():
	/* ok, now we should be set up.. */
	p->pid = pid_nr(pid);
	if (clone_flags & CLONE_THREAD) {
		p->group_leader = current->group_leader;
		p->tgid = current->tgid;
	} else {
		p->group_leader = p;
		p->tgid = p->pid;
	}

current->tgid comes form pid_nr(pid), pid_nr() returns a global id seen from
the init namespace, seems that this id is unique. I'll try to confirm this
assumption more, thanks.

Regards,
Xiaoguang Wang
> 
> 
> 
> static std::vector<std::set<struct io_uring *>> percpu_rings;
> static std::mutex lock;
> 
> int io_uring_queue_init_params_percpu(unsigned entries,
> 				      struct io_uring *ring,
> 				      struct io_uring_params *p);
> {
> 	unsigned int cpu = p->sq_thread_cpu;
> 	std::unique_lock guard(lock);
> 
> 	if (!(p->flags & IORING_SETUP_SQPOLL))
> 		return -EINVAL;
> 	if (percpu_rings.size() <= cpu)
> 		percpu_rings.resize(cpu + 1);
> 
> 	p->flags &= ~IORING_SETUP_ATTACH_WQ;
> 	if (!percpu_rings[cpu].empty()) {
> 		struct io_uring *shared_ring = *percpu_rings[cpu].begin();
> 		p->wq_fd = shared_ring->ring_fd;
> 		p->flags |= IORING_SETUP_ATTACH_WQ;
> 	}
> 
> 	int ret = io_uring_queue_init_params(entries, ring, p);
> 	if (!ret)
> 		percpu_rings[cpu].insert(ring);
> 	return ret;
> }
> 
> void io_uring_queue_exit_percpu(struct io_uring *ring)
> {
> 	std::unique_lock guard(lock);
> 
> 	for (auto& cpu_set: percpu_rings)
> 		if (cpu_set.erase(ring))
> 			break;
> 	guard.release();
> 	io_uring_queue_exit(ring);
> }
> 
