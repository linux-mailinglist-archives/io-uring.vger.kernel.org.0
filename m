Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5A565147
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiGDJtq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiGDJtl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 05:49:41 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D8A2BE0;
        Mon,  4 Jul 2022 02:49:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VIKLHp5_1656928175;
Received: from 30.97.56.234(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VIKLHp5_1656928175)
          by smtp.aliyun-inc.com;
          Mon, 04 Jul 2022 17:49:36 +0800
Message-ID: <532eb193-06cf-96a3-684f-cc7e16db5ddf@linux.alibaba.com>
Date:   Mon, 4 Jul 2022 17:49:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [RFC] libubd: library for ubd(userspace block driver based on
 io_uring passthrough)
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph.qi@linux.alibaba.com
References: <fd926012-6845-05e4-077b-6c8cfbf3d3cc@linux.alibaba.com>
 <YrnMwgW7TemVdbXv@T590>
 <fada5140-077e-6904-f9b6-c7bfba7779eb@linux.alibaba.com>
 <Yrw4gJq+NaX+TCDz@T590>
 <b3ef9b0e-f24c-7867-91c8-2bf15c646b77@linux.alibaba.com>
 <Yr1oMvYCqn5m2oLX@T590>
 <4e4b0130-81a1-567c-0fd5-624f9d18ce85@linux.alibaba.com>
 <YsJno65CzIei1K1X@T590>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <YsJno65CzIei1K1X@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/7/4 12:08, Ming Lei wrote:
> On Thu, Jun 30, 2022 at 05:29:07PM +0800, Ziyang Zhang wrote:
>> On 2022/6/30 17:09, Ming Lei wrote:
>>> On Thu, Jun 30, 2022 at 03:16:21PM +0800, Ziyang Zhang wrote:
>>>> Hi, Ming
>>>>
>>>> On 2022/6/29 19:33, Ming Lei wrote:
>>>>> On Wed, Jun 29, 2022 at 11:22:23AM +0800, Ziyang Zhang wrote:
>>>>>> Hi Ming,
>>>>>>
>>>>>> On 2022/6/27 23:29, Ming Lei wrote:
>>>>>>> Hi Ziyang,
>>>>>>>
>>>>>>> On Mon, Jun 27, 2022 at 04:20:55PM +0800, Ziyang Zhang wrote:
>>>>>>>> Hi Ming,
>>>>>>>>
>>>>>>>> We are learning your ubd code and developing a library: libubd for ubd.
>>>>>>>> This article explains why we need libubd and how we design it.
>>>>>>>>
>>>>>>>> Related threads:
>>>>>>>> (1) https://lore.kernel.org/all/Yk%2Fn7UtGK1vVGFX0@T590/
>>>>>>>> (2) https://lore.kernel.org/all/YnDhorlKgOKiWkiz@T590/
>>>>>>>> (3) https://lore.kernel.org/all/20220509092312.254354-1-ming.lei@redhat.com/
>>>>>>>> (4) https://lore.kernel.org/all/20220517055358.3164431-1-ming.lei@redhat.com/
>>>>>>>>
>>>>>>>>
>>>>>>>> Userspace block driver(ubd)[1], based on io_uring passthrough,
>>>>>>>> allows users to define their own backend storage in userspace
>>>>>>>> and provides block devices such as /dev/ubdbX.
>>>>>>>> Ming Lei has provided kernel driver code: ubd_drv.c[2]
>>>>>>>> and userspace code: ubdsrv[3].
>>>>>>>>
>>>>>>>> ubd_drv.c simply passes all blk-mq IO requests
>>>>>>>> to ubdsrv through io_uring sqes/cqes. We think the kernel code
>>>>>>>> is pretty well-designed.
>>>>>>>>
>>>>>>>> ubdsrv is implemented by a single daemon
>>>>>>>> and target(backend) IO handling(null_tgt and loop_tgt) 
>>>>>>>> is embedded in the daemon. 
>>>>>>>> While trying ubdsrv, we find ubdsrv is hard to be used 
>>>>>>>> by our backend.
>>>>>>>
>>>>>>> ubd is supposed to provide one generic framework for user space block
>>>>>>> driver, and it can be used for doing lots of fun/useful thing.
>>>>>>>
>>>>>>> If I understand correctly, this isn't same with your use case:
>>>>>>>
>>>>>>> 1) your user space block driver isn't generic, and should be dedicated
>>>>>>> for Alibaba's uses
>>>>>>>
>>>>>>> 2) your case has been there for long time, and you want to switch from other
>>>>>>> approach(maybe tcmu) to ubd given ubd has better performance.
>>>>>>>
>>>>>>
>>>>>> Yes, you are correct :)
>>>>>> The idea of design libubd is actually from libtcmu.
>>>>>>
>>>>>> We do have some userspace storage system as the IO handling backend, 
>>>>>> and we need ubd to provide block drivers such as /dev/ubdbX for up layer client apps.
>>>>>>
>>>>>>
>>>>>> I think your motivation is that provides a complete user block driver to users
>>>>>> and they DO NOT change any code.
>>>>>> Users DO change their code using libubd for embedding libubd into the backend.
>>>>>>
>>>>>>
>>>>>>>> First is description of our backend:
>>>>>>>>
>>>>>>>> (1) a distributing system sends/receives IO requests 
>>>>>>>>     through network.
>>>>>>>>
>>>>>>>> (2) The system use RPC calls among hundreds of
>>>>>>>>      storage servers and RPC calls are associated with data buffers
>>>>>>>>      allocated from a memory pool.
>>>>>>>>
>>>>>>>> (3) On each server for each device(/dev/vdX), our backend runs
>>>>>>>>      many threads to handle IO requests and manage the device. 
>>>>>>>>
>>>>>>>> Second are reasons why ubdsrv is hard to use for us:
>>>>>>>>
>>>>>>>> (1) ubdsrv requires the target(backend) issues IO requests
>>>>>>>>     to the io_uring provided by ubdsrv but our backend 
>>>>>>>>     uses something like RPC and does not support io_uring.
>>>>>>>
>>>>>>> As one generic framework, the io command has to be io_uring
>>>>>>> passthrough, and the io doesn't have to be handled by io_uring.
>>>>>>
>>>>>> Yes, our backend define its own communicating method.
>>>>>>
>>>>>>>
>>>>>>> But IMO io_uring is much more efficient, so I'd try to make async io
>>>>>>> (io uring) as the 1st citizen in the framework, especially for new
>>>>>>> driver.
>>>>>>>
>>>>>>> But it can support other way really, such as use io_uring with eventfd,
>>>>>>> the other userspace context can handle io, then wake up io_uring context
>>>>>>> via eventfd. You may not use io_uring for handling io, but you still
>>>>>>> need to communicate with the context for handling io_uring passthrough
>>>>>>> command, and one mechanism(such as eventfd) has to be there for the
>>>>>>> communication.
>>>>>>
>>>>>> Ok, eventfd may be helpful. 
>>>>>> If you read my API, you may find ubdlib_complete_io_request().
>>>>>> I think the backend io worker thread can call this function to tell the 
>>>>>> ubd queue thread(the io_uring context in it) to commit the IO.
>>>>>
>>>>> The ubdlib_complete_io_request() has to be called in the same pthread
>>>>> context, that looks not flexible. When you handle IO via non-io_uring in the same
>>>>> context, the cpu utilization in submission/completion side should be
>>>>> higher than io_uring. And this way should be worse than the usage in
>>>>> ubd/loop, that is why I suggest to use one io_uring for handling both
>>>>> io command and io request if possible.
>>>>
>>>> ubdlib_complete_io_request() can be called in the io worker thread,
>>>> not in the ubdsrv queue thread(with the io_uring context for handling uring_cmd).
>>>>
>>>> You can find ubd_runner.c in my libubd repo. There are many io worker
>>>> threads for each ubdsrv queue to handle IO requests.
>>>>
>>>> Actually this idea comes from tcmu-runner. The data flow is:
>>>>
>>>> 1) in ubdsrv queue thread, io_uring_enter(): returns(IO reqs received from blk-mq)
>>>>
>>>> 2) in ubdsrv queue thread, ubdsrv_reap_requests(): iterate on each cqe(with an IO req),
>>>>    
>>>>    for READ/WRITE requests, ubd_aio_queue_io() to enqueue the IO req into a io_queue
>>>>    (each ubdsrv queue has one io_queue). This IO req's status is IO_HANDLING_ASYNC.
>>>>     
>>>>    for other simple(can be handled very quickly), 
>>>>    handle it right now and call ubdlib_complete_io_request()
>>>>
>>>> 3) in ubdsrv queue thread, ubdsrv_commit_and_fetch(): iterate on all IO slots per ubdsrv queue
>>>>    and setup sqe if one IO(IO completion) is ready to commit.
>>>>    
>>>>    Here, some IO slots are still IO_HANDLING_ASYNC so no sqe is generated for them.
>>>>
>>>>
>>>> 4)  in ubdsrv queue thread, io_uring_enter(): submit all sqes and wait for cqes
>>>>     (io_uring_enter() will return after at least one IO req is received from blk-mq)
>>>>    
>>>> 5) When 3) or 4) happens, at the same time in ubdsrv queue IO worker threads:
>>>>    each io worker thread try to deque and handle one IO req from io_queue per ubdsrv queue.
>>>>    
>>>>    After the IO worker handles the IO req(WRITE/READ), it calls ubdlib_complete_io_request()
>>>>    This function can mark this  IO req's status to ready to commit.
>>>>
>>>> IO handling/completion and io_uring_enter() can happen at the same time.
>>>>
>>>> Besides, io_uring_enter can:
>>>>
>>>> 1) block and wait for cqes until at least
>>>> one blk-mq req comes from queue_rq()
>>>>
>>>> 2) submit sqes(with last IO completion and next fetch)
>>>>
>>>> so I have to consider how to notify io_uring about io completion 
>>>> after io_uring_enter() is slept(block and wait for cqes).
>>>
>>> Yeah, that was exactly my question, :-)
>>>
>>>>
>>>> In current version of ubd_runner(an async libubd target), I try to use an "unblock"
>>>> io_uring_enter_timeout() and caller can set a timeout value for it.
>>>> So IO completions happen after io_uring_enter_timeout() call can be committed
>>>> by next io_uring_enter_timeout() call...
>>>>
>>>> But this is a very ugly implementation 
>>>> because I may waste CPU on useless loops in ubdsrv queue thread if
>>>> blk-mq reqs do not income frequently.
>>>>
>>>> You mentioned that eventfd may be helpful and I agree with you. :)
>>>> I can register an eventfd in io_uring after ubd_aio_queue_io() and write the eventfd
>>>> in  ubdlib_complete_io_request().
>>>>
>>>> I will fix my code.
>>>
>>> FYI, there is one example about using eventfd to wakeup io_uring, which
>>> can be added to the library for your usecase:
>>>
>>> https://gist.github.com/1Jo1/6496d1b8b6b363c301271340e2eab95b
>>
>> Thanks, will take a view.
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> (2) ubdsrv forks a daemon and it takes over everything.
>>>>>>>>     Users should type "list/stop/del" ctrl-commands to interact with
>>>>>>>>     the daemon. It is inconvenient for our backend
>>>>>>>>     because it has threads(from a C++ thread library) running inside.
>>>>>>>
>>>>>>> No, list/stop/del won't interact with the daemon, and the per-queue
>>>>>>> pthread is only handling IO commands(io_uring passthrough) and IO request.
>>>>>>>
>>>>>>
>>>>>>
>>>>>> Sorry I made a mistake.
>>>>>>
>>>>>> I mean from user's view, 
>>>>>> he has to type list/del/stop from cmdlind to control the daemon.
>>>>>> (I know the control flow is cmdline-->ubd_drv.c-->ubdsrv daemon).
>>>>>>
>>>>>> This is a little weird if we try to make a ubd library.
>>>>>> So I actually provides APIs in libubd for users to do these list/del/stop works.
>>>>>
>>>>> OK, that is fine to export APIs for admin purpose.
>>>>>
>>>>>>
>>>>>>
>>>>>>>>
>>>>>>>> (3) ubdsrv PRE-allocates internal data buffers for each ubd device.
>>>>>>>>     The data flow is:
>>>>>>>>     bio vectors <-1-> ubdsrv data buffer <-2-> backend buffer(our RPC buffer).
>>>>>>>>     Since ubdsrv does not export its internal data buffer to backend,
>>>>>>>>     the second copy is unavoidable. 
>>>>>>>>     PRE-allocating data buffer may not be a good idea for wasting memory
>>>>>>>>     if there are hundreds of ubd devices(/dev/ubdbX).
>>>>>>>
>>>>>>> The preallocation is just virtual memory, which is cheap and not pinned, but
>>>>>>> ubdsrv does support buffer provided by io command, see:
>>>>>>>
>>>>>>> https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d
>>>>>>
>>>>>> Actually I discussed on the design of pre-allocation in your RFC patch for ubd_drv
>>>>>> but you did not reply :)
>>>>>>
>>>>>> I paste it here:
>>>>>>
>>>>>> "I am worried about the fixed-size(size is max io size, 256KiB) pre-allocated data buffers in UBDSRV
>>>>>> may consume too much memory. Do you mean these pages can be reclaimed by sth like madvise()?
>>>>>> If (1)swap is not set and (2)madvise() is not called, these pages may not be reclaimed."
>>>>>>
>>>>>> I observed that your ubdsrv use posix_memalign() to pre-allocate data buffers, 
>>>>>> and I have already noticed the memory cost while testing your ubdsrv with hundreds of /dev/ubdbX.
>>>>>
>>>>> Usually posix_memalign just allocates virtual memory which is unlimited
>>>>> in 64bit arch, and pages should be allocated until the buffer is read or write.
>>>>> After the READ/WRITE is done, kernel still can reclaim the pages in this
>>>>> virtual memory.
>>>>>
>>>>> In future, we still may optimize the memory uses via madvise, such as
>>>>> MADV_DONTNEED, after the slot is idle for long enough.
>>>>
>>>> Ok, thanks for explanation. 
>>>>
>>>>>
>>>>>>
>>>>>> Another IMPORTANT problem is your commit:
>>>>>> https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d
>>>>>> may be not helpful for WRITE requests if I understand correctly.
>>>>>>
>>>>>> Consider this data flow:
>>>>>>
>>>>>> 1. ubdsrv commits an IO req(req1, a READ req).
>>>>>>
>>>>>> 2. ubdsrv issues a sqe(UBD_IO_COMMIT_AND_FETCH_REQ), and sets io->addr to addr1.
>>>>>>    addr1 is the addr of buffer user passed.
>>>>>>    
>>>>>>
>>>>>> 3. ubd gets the sqe and commits req1, sets io->addr to addr1.
>>>>>>
>>>>>> 4. ubd gets IO req(req2, a WRITE req) from blk-mq(queue_rq) and commit a cqe.
>>>>>>
>>>>>> 5. ubd copys data to be written from biovec to addr1 in a task_work.
>>>>>>
>>>>>> 6. ubdsrv gets the cqe and tell the IO target to handle req2.
>>>>>>
>>>>>> 7. IO target handles req2. It is a WRITE req so target issues a io_uring write
>>>>>>    cmd(with buffer set to addr1).
>>>>>>
>>>>>>
>>>>>>
>>>>>> The problem happens in 5). You cannot know the actual data_len of an blk-mq req
>>>>>> until you get one in queue_rq. So length of addr1 may be less than data_len.
>>>>>
>>>>> So far, the actual length of buffer has to be set as at least rq_max_blocks, since
>>>>> we set it as ubd queue's max hw sectors. Yeah, you may argue memory
>>>>> waste, but process virtual address is unlimited for 64bit arch, and
>>>>> pages are allocated until actual read/write is started.
>>>>
>>>> Ok, since I allow users to config rq_max_blocks in libubd, 
>>>> it's users' responsibility to ensure length of user buffers
>>>> is at least rq_max_blocks.
>>>>
>>>> Now I agree on your commit:
>>>> https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d
>>>>
>>>> Provide WRITE buffer in advance(when sending COMMIT_AND_FETCH) seems OK :)
>>>>
>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> To better use ubd in more complicated scenarios, we have developed libubd.
>>>>>>>> It does not assume implementation of backend and can be embedded into it.
>>>>>>>> We refer to the code structure of tcmu-runner[4], 
>>>>>>>> which includes a library(libtcmu) for users 
>>>>>>>> to embed tcmu-runner inside backend's code. 
>>>>>>>> It:
>>>>>>>>
>>>>>>>> (1) Does not fork/pthread_create but embedded in backend's threads
>>>>>>>
>>>>>>> That is because your backend may not use io_uring, I guess.
>>>>>>>
>>>>>>> But it is pretty easy to move the decision of creating pthread to target
>>>>>>> code, which can be done in the interface of .prepare_target().
>>>>>>
>>>>>> I think the library should not create any thread if we want a libubd.
>>>>>
>>>>> I Agree.
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> (2) Provides libubd APIs for backend to add/delete ubd devices 
>>>>>>>>     and fetch/commit IO requests
>>>>>>>
>>>>>>> The above could be the main job of libubd.
>>>>>>
>>>>>> indeed.
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> (3) simply passes backend-provided data buffers to ubd_drv.c in kernel,
>>>>>>>>     since the backend actually has no knowledge 
>>>>>>>>     on incoming data size until it gets an IO descriptor.
>>>>>>>
>>>>>>> I can understand your requirement, not look at your code yet, but libubd
>>>>>>> should be pretty thin from function viewpoint, and there are lots of common
>>>>>>> things to abstract/share among all drivers, please see recent ubdsrv change:
>>>>>>>
>>>>>>> https://github.com/ming1/ubdsrv/commits/master
>>>>>>>
>>>>>>> in which:
>>>>>>> 	- coroutine is added for handling target io
>>>>>>> 	- the target interface(ubdsrv_tgt_type) has been cleaned/improved for
>>>>>>> 	supporting complicated target
>>>>>>> 	- c++ support
>>>>>>
>>>>>> Yes, I have read your coroutine code but I am not an expert of C++ 20.:(
>>>>>> I think it is actually target(backend) design and ubd should not assume 
>>>>>> how the backend handle IOs. 
>>>>>>
>>>>>> The work ubd in userspace has to be done is:
>>>>>>
>>>>>> 1) give some IO descriptors to backend, such as ubd_get_io_requests()
>>>>>>
>>>>>> 2) get IO completion form backend, such as ubd_complete_io_requests()
>>>>>
>>>>> Or the user provides/registers two callbacks: handle_io_async() and
>>>>> io_complete(), the former is called when one request comes from ubd
>>>>> driver, the latter(optional) is called when one io is done.
>>>>>
>>>>> Also you didn't mention how you notify io_uring about io completion after
>>>>> io_uring_enter() is slept if your backend code doesn't use io_uring to
>>>>> handle io.
>>>>>
>>>>> I think one communication mechanism(such as eventfd) is needed for your
>>>>> case.
>>>>
>>>> Ok, I will try eventfd with io_uring.
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> IMO, libubd isn't worth of one freshly new project, and it could be integrated
>>>>>>> into ubdsrv easily. The potential users could be existed usersapce
>>>>>>> block driver projects.
>>>>>>
>>>>>> Yes, so many userspace storage systems can use ubd!
>>>>>> You may look at tcmu-runner. It:
>>>>>>
>>>>>> 1) provides a library(libtcmu.c) for those who have a existing backend.
>>>>>>
>>>>>> 2) provides a runner(main.c in tcmu-runner) like your ubdsrv 
>>>>>>    for those who just want to run it. 
>>>>>>    And the runner is build on top of libtcmu.
>>>>>>
>>>>>>>
>>>>>>> If you don't object, I am happy to co-work with you to add the support
>>>>>>> for libubd in ubdsrv, then we can avoid to invent a wheel
>>>>>>
>>>>>> +1 :)
>>>>>
>>>>> Thinking of further, I'd suggest to split ubdsrv into two parts:
>>>>>
>>>>> 1) libubdsrv
>>>>> - provide APIs like what you did in libubd
>>>>> - provide API for notify io_uring(handling io command) that one io is
>>>>> completed, and the API should support handling IO from other context
>>>>> (not same with the io_uring context for handling io command).
>>>>>
>>>>> 2) ubd target
>>>>> - built on libubdsrv, such as ubd command is built on libubdsrv, and
>>>>> specific target implementation is built on the library too.
>>>>>
>>>>> It shouldn't be hard to work towards this direction, and I guess this
>>>>> way should make current target implementation more clean.
>>>>>
>>>>
>>>> Yes, this is like tcmu-runner's structure: a libtcmu and some target
>>>> Thanks, Ming.  Glad to co-work with you.
>>>>
>>>> I will take your advice and improve libubd(the communication mechanism, maybe eventfd).
>>>
>>> I have added libublk branch for working towards this direction, if we
>>> cowork on libublk, please write patch against this branch, then I can
>>> apply your patch directly.
>>>
>>> https://github.com/ming1/ubdsrv/tree/libublk
>>
>> Ok, but It concerns me that libubdsrv may change current ubdsrv project's structure a lot
>> because:
>> 1) target implementation will be built on top of libubdsrv and the target
>>    should create pthread(ubdsrv loop) itself.
>>
>> 2) have to remove pthread/process(daemon) in current ubdsrv to build libubdsrv.
>>    It was really a hard job. :-(
> 
> Both the two are not hard to do, and turns out that making libubdsrv is actually
> one big cleanup.
> 
> All these works[1] are basically done:
> 
> 1) libublksrv
> - built .so and .a are under lib/
> - exported header file is include/ublksrv.h
> - so any other application can make ublk device against this library
> - eventfd notification is added too, so io handling doesn't have to
> be done via io_uring, one callback of ->handle_event(), and two APIs
> are added for this support
> 
> 2) ublk/ubd utility
> - built against libublksrv, meantime it uses the private header of the
> library too, which is fine, since the two are in same project
> 
> 3) two examples
> - demo_null.c: one < 200 LOC standalone example to show how to make
> a ubd/null block device against libublksrv
> 
> - demo_event.c: one simple standalone example(~300LOC) to make one ublk
> disk by handling io via another pthread(not by io_uring) against
> libublksrv
> 
> Any comments/feedback/tests are welcome.
> 
> 
> [1] libublk
> https://github.com/ming1/ubdsrv/tree/libublk
> 

Hi Ming,

Thanks for your libublk code.
You almost have done everything we discussed before :)

One small question:
Could you please write another demo_event_loop.c:

1) based on demo_event.c(handling io via another pthread)
   but the loop backend is a fd(file). User calls pwrite/pread with the fd.
   
2) User-provided buffer: data buffer is allocated by backend
   (not posix_memalign() in ublksrv.c)
   and it is passed to ublksrv(finally to ubd_drv in kernel) by libublksrv's API
   ( maybe passed as an arg to ublksrv_complete_io()? )

3) I think pread/pwrite should be in demo_event_real_io_handler_fn() 
   for all IOs of each pending list. Am I correct?

4) Shall we consider multiple pthreads calling demo_event_real_io_handler_fn()
   (they are io worker threads actually)
   so we can handle IO concurrently?


I think designing more examples helps us design libublk's API more clearly.

> 
> Thanks,
> Ming
