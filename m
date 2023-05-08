Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAE06F9DC4
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 04:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjEHChD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 22:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjEHChC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 22:37:02 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EF240C3
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 19:37:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f193ca059bso24754445e9.3
        for <io-uring@vger.kernel.org>; Sun, 07 May 2023 19:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683513418; x=1686105418;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fXKG70TAmc6tCSAPtCgDEu2Y783/cm+IfesfoMAG6Vs=;
        b=WFrBWAERmxTPSUMjbcqLpWcd/gvCU5RTNVh2n6FM4UNeOE8QPWaPdqAfWczqtLDvbx
         Dz9oaBiWmSwZLaymaOP7KgYh0MSGvju3bSt/SQB6mIukV3VcEKBhSYm6Qk2sUlqAkMh4
         ijSUYYJlQ2bPYSlA1ENrkqga4HAC5nJqepzK5U9RTgOBMzksCWhmSwNCuP4LYa93GR+V
         bc9LxbkFU6PJ0pdx0HBkv0NfSVvNP2gBX4UPNSs2pqcHkP/sETcJzaK83jCIvSKqCg+r
         QM1AwZet/Hl8bDayN7YetmowILucfr93WxLuFxTfD/wiiDLhJsJSWAJVoDn58hD7oPYF
         WZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683513418; x=1686105418;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXKG70TAmc6tCSAPtCgDEu2Y783/cm+IfesfoMAG6Vs=;
        b=Z0ucN42zllUcUtjl7LhHtQBo4F5ExPqLdxfOkawM0tNyNTNcXGzjqeGvsoKRrMBPLF
         zwPctdijsHMPDRxGgODO4EH7I+g35SOVY+KKzN4W68haOn6FQvA5MSkQbKJotcXvJAGt
         iyM9tQ509kTX7h2aID5a7xPSuUoxx3PN5PKMaLDtQfGKthZPqqRd6969EIX4y6F+7p89
         a0k+kpWQoQodtPzuj3AnZeKVMOkTAykue+eyxt0uU9yeGtbnC07ltmuaSF110SrBI6pZ
         IXeguyZztFklKsAY5UNfp7R98x6Eugz8QzqjxkBSqaoVJKVSIY8ZtQK097rgv6k7kO+p
         773Q==
X-Gm-Message-State: AC+VfDwQktwggJbAZEFkvJLNnglZP8JSAvuZQSw9PQTOC7gTlhjnQrds
        g+bMdqZd7/w0q6CVkq8WXm++I1AAW9s=
X-Google-Smtp-Source: ACHHUZ5vJJF+d8BIePqnwk4XpKP3uXBrhPcx8PqEFfQeQQdrCeZQXN/iOZvaebvTSkrM5F+HaNAumg==
X-Received: by 2002:a05:600c:2288:b0:3f1:8e33:8c68 with SMTP id 8-20020a05600c228800b003f18e338c68mr5994647wmf.26.1683513418071;
        Sun, 07 May 2023 19:36:58 -0700 (PDT)
Received: from [192.168.8.100] (188.30.86.13.threembb.co.uk. [188.30.86.13])
        by smtp.gmail.com with ESMTPSA id c15-20020a05600c0acf00b003f427687ba7sm316395wmr.41.2023.05.07.19.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 19:36:57 -0700 (PDT)
Message-ID: <a63fea56-6b56-e043-f746-597963312205@gmail.com>
Date:   Mon, 8 May 2023 03:30:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 7/7] io_uring,fs: introduce IORING_OP_GET_BUF
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <cover.1682701588.git.asml.silence@gmail.com>
 <fc43826d510dc75de83d81161ca03e2688515686.1682701588.git.asml.silence@gmail.com>
 <ZFEk2rQv2//KRBeK@ovpn-8-16.pek2.redhat.com>
 <4527d9f3-d7d5-908e-bf34-5c2a4e4e9609@gmail.com>
 <ZFMTJX2H5ByOygzw@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
In-Reply-To: <ZFMTJX2H5ByOygzw@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/23 03:06, Ming Lei wrote:
> On Wed, May 03, 2023 at 03:54:02PM +0100, Pavel Begunkov wrote:
>> On 5/2/23 15:57, Ming Lei wrote:
>>> On Sun, Apr 30, 2023 at 10:35:29AM +0100, Pavel Begunkov wrote:
>>>> There are several problems with splice requests, aka IORING_OP_SPLICE:
>>>> 1) They are always executed by a worker thread, which is a slow path,
>>>>      as we don't have any reliable way to execute it NOWAIT.
>>>> 2) It can't easily poll for data, as there are 2 files it operates on.
>>>>      It would either need to track what file to poll or poll both of them,
>>>>      in both cases it'll be a mess and add lot of overhead.
>>>> 3) It has to have pipes in the middle, which adds overhead and is not
>>>>      great from the uapi design perspective when it goes for io_uring
>>>>      requests.
>>>> 4) We want to operate with spliced data as with a normal buffer, i.e.
>>>>      write / send / etc. data as normally while it's zerocopy.
>>>>
>>>> It can partially be solved, but the root cause is a suboptimal for
>>>> io_uring design of IORING_OP_SPLICE. Introduce a new request type
>>>> called IORING_OP_GET_BUF, inspired by splice(2) as well as other
>>>> proposals like fused requests. The main idea is to use io_uring's
>>>> registered buffers as the middle man instead of pipes. Once a buffer
>>>> is fetched / spliced from a file using a new fops callback
>>>> ->iou_get_buf, it's installed as a registered buffers and can be used
>>>> by all operations supporting the feature.
>>>>
>>>> Once the userspace releases the buffer, io_uring will wait for all
>>>> requests using the buffer to complete and then use a file provided
>>>> callback ->release() to return the buffer back. It operates on the
>>>
>>> In the commit of "io_uring: add an example for buf-get op", I don't see
>>> any code to release the buffer, can you explain it in details about how
>>> to release the buffer in userspace? And add it in your example?
>>
>> Sure, we need to add buf updates via request.
> 
> I guess it can't be buf update, here we need to release buf. At least
> ublk needs to release the buffer explicitly after all consumers are done
> with the buffer registered by IORING_OP_GET_BUF, when there may not be
> any new buffer to be provided, and the buffer is per-IO for each io
> request from /dev/ublkbN.

By "updates" I usually mean removals as well, just like
IORING_REGISTER_BUFFERS_UPDATE with iov_base == 0 would remove
the buffer.


>> Particularly, in this RFC, the removal from the table was happening
>> in io_install_buffer() by one of the test-only patches, the "remove
>> previous entry on update" style as it's with files. Then it's
>> released with the last ref put, either on removal with a request
>> like:
>>
>> io_free_batch_list()
>>       io_req_put_rsrc_locked()
>>           ...
>>
>>> Here I guess the ->release() is called in the following code path:
>>>
>>> io_buffer_unmap
>>>       io_rsrc_buf_put
>>>           io_rsrc_put_work
>>>               io_rsrc_node_ref_zero
>>>                   io_put_rsrc_node
>>>
>>> If it is true, what is counter-pair code for io_put_rsrc_node()?
>>> So far, only see io_req_set_rsrc_node() is called from
>>> io_file_get_fixed(), is it needed for consumer OP of the buffer?
>>>
>>> Also io_buffer_unmap() is called after io_rsrc_node's reference drops
>>> to zero, which means ->release() isn't called after all its consumer(s)
>>> are done given io_rsrc_node is shared by in-flight requests. If it is
>>> true, this way will increase buffer lifetime a lot.
>>
>> That's true. It's not a new downside, so might make more sense
>> to do counting per rsrc (file, buffer), which is not so bad for
>> now, but would be a bit concerning if we grow the number of rsrc
>> types.
> 
> It may not be one deal for current fixed file user, which isn't usually
> updated in fast path.

With opening/accepting right into io_uring skipping normal file
tables and cases like open->read->close, it's rather somewhat of
medium hotness, definitely not a slow path. And the problem affects
it as well
  
> But IORING_OP_GET_BUF is supposed to be for fast path, this delay
> release is really one problem. Cause if there is any new buffer provided &
> consumed, old buffer can't be released any more. And this way can't
> be used in ublk zero copy, let me share the ublk model a bit:
> 
> 1) one batch ublk blk io requests(/dev/ublkbN) are coming, and batch size is
> often QD of workload on /dev/ublkbN, and batch size could be 1 or more.
> 
> 2) ublk driver notifies the blk io requests via io_uring command
> completion
> 
> 3) ublk server starts to handle this batch of io requests, by calling
> IORING_OP_GET_BUF on /dev/ublkcN & normal OPs(rw, net recv/send, ...)
> for each request in this batch
> 
> 4) new batch of ublk blk io requests can come when handling the previous
> batch of io requests, then the old buffer release is delayed until new
> batch of ublk io requests are completed.
> 
>>
>>> ublk zero copy needs to call ->release() immediately after all
>>> consumers are done, because the ublk disk request won't be completed
>>> until the buffer is released(the buffer actually belongs to ublk block request).
>>>
>>> Also the usage in liburing example needs two extra syscall(io_uring_enter) for
>>> handling one IO, not take into account the "release OP". IMO, this way makes
>>
>> Something is amiss here. It's 3 requests, which means 3 syscalls
>> if you send requests separately (each step can be batch more
>> requests), or 1 syscall if you link them together. There is an
>> example using links for 2 requests in the test case.
> 
> See the final comment about link support.
> 
>>
>>> application more complicated, also might perform worse:
>>>
>>> 1) for ublk zero copy, the original IO just needs one OP, but now it
>>> takes three OPs, so application has to take coroutine for applying
>>
>> Perhaps, you mean two requests for fused, IORING_OP_FUSED_CMD + IO
>> request, vs three for IORING_OP_GET_BUF. There might be some sort of
>> auto-remove on use, making it two requests, but that seems a bit ugly.
> 
> The most important part is that IORING_OP_GET_BUF adds two extra wait:
> 
> 1) one io_uring_enter() is required after submitting IORING_OP_GET_BUF
> 
> 2) another io_uring_enter() is needed after submitting buffer consumer
> OPs, before calling buffer release OP(not added yet in your patchset)
> 
> The two waits not only causes application more complicated, but also
> hurts performance, cause IOs/syscall is reduced. People loves io_uring
> because it is really async io model, such as, all kinds of IO can be
> submitted in single context, and wait in single io_uring_enter().

*Pseudo code*
N = get_free_buffer_slot();
sqe1 = prep_getbuf_sqe(buf_idx = N);
sqe1->flags |= F_LINK;

sqe2 = prep_write_sqe(buf_idx = N);
sqe2->flags |= F_LINK;

sqe3 = prep_release_buf_sqe(buf_idx = N);
sqe3->flags |= F_LINK;

submit_and_wait(nr_wait=3);


That should work, there is only 1 syscall. We can also
play with SKIP_CQE_SUCCESS and/or HARDLINK to fold 3 cqes
into 1.

>>> 3 stages batch submission(GET_BUF, IO, release buffer) since IO_LINK can't
>>> or not suggested to be used. In case of low QD, batch size is reduced much,
>>> and performance may hurt because IOs/syscall is 1/3 of fused command.
>>
>> I'm not a big fan of links for their inflexibility, but it can be
>> used. The point is rather it's better not to be the only way to
>> use the feature as we may need to stop in the middle, return
> 
> LINK always support to stop in the middle, right?

Normal links will stop execution on "error", which is usually
cqe->res < 0, but read/write will also break the link on short
IO, and the short IO behaviour of send/recv will depend on
MSG_WAITALL. IOSQE_IO_HARDLINK will continue executing linked
requests even with prior errors.

>> control to the userspace and let it handle errors, do data processing
>> and so on. The latter may need a partial memcpy() into the userspace,
>> e.g. copy a handful bytes of headers to decide what to do with the
>> rest of data.
> 
> At least this patchset doesn't work with IO_LINK, please see my previous
> reply because the current rw/net zc retrieves fixed buffer in ->prep().
> 
> Yeah, the problem can be addressed by moving the buffer retrieving into
> ->issue().

Right, one of the test patches does exactly that (fwiw, not tested
seriously), and as it was previously done for files. It won't be
a big problem.

> But my concern is more about easy use and performance:
> 
> 1) with io_link, the extra two waits(after IORING_OP_GET_BUF and before IORING_OP_GET_BUF)
> required can be saved, then application doesn't need coroutine or
> similar trick for avoiding the extra wait handling.

It shouldn't need that, see above.

> 2) but if three OPs uses the buffer registered by IORING_OP_GET_BUF, the three
> OPs have to be linked one by one, then all three have to be be submitted one
> after the previous one is completed, performance is hurt a lot.

In general, it sounds like a generic feature and should be as such.
But

I agree with the sentiment, that's exactly why I was saying that
they're not perfectly flexible and don't cover all the cases, but
the same can be said for the 1->N kinds of dependency. And even
with a completely configurable graphs of requests there will be
questions like "how to take result from one request and give it
to another with a random meaning, i.e. as a buffer/fd/size/
index/whatnot", and there are more complicated examples.

I don't see any good scalable way for that without programmability.
It appeared before that it was faster to return back to the userspace
than using BPF, might be worth to test it again, especially with
DEFER_TASKRUN and recent optimisations.


>> I deem fused cmds to be a variant of linking, so it's rather with
>> it you link 2 requests vs optionally linking 3 with this patchset.
> 
> IMO, one extra 64byte touching may slow things a little, but I think it

Fwiw, the overhead comes from all io_uring hops a request goes
through, e.g. init, ->prep, ->issue, free, etc. I'd love to
see it getting even slimmer, and there are definitely spots
that can be optimised.

> won't be big deal, what really matters is that easy use of the interface
> and performance.

Which should also be balanced with flexibility and not only.

> Fused command solves both: allow to submit the consumer OPs concurrently;
> avoid multiple wait point and make application easier to implement
> 
> For example:
> 
> 1) fused command based application: (every IO command takes 1 syscall usually)
> 
> 	for each reapped CQE:
> 		- if CQE is for io command from /dev/ublkc:
> 			- handle it by allocating/queuing three SQEs:
> 				- one SQE is for primary command,
> 				- the 2nd SQE is for READ to file 1
> 				- the 3rd SQE is for READ to file 2
> 		- if CQE is for primary command or normal OP:
> 			- just check if the whole fused command is completed
> 				- if yes, notify that the current io command is
> 				completed (the current io request from /dev/ublkbN will
> 				be completed in ublk driver, and this io command is
> 				queued for incoming request)
> 				- if any err, handle the err: retry or terminate,
> 				  similar with handling for 'yes'
> 				- otherwise, just return
> 		io_uring_enter();			//single wait point
> 
> 2) IORING_OP_GET_BUF based application(every IO command needs two syscall)
> 
> 	for each reapped CQE:
> 		- if CQE is for io command from /dev/ublkc:
> 			- handle it by:
> 				queuing IORING_OP_GET_BUF
> 				recoding this io needs to be hanlded
> 
> 	io_uring_enter()	//wait until all IORING_OP_GET_BUF are done
> 
> 	for each IO recorded in above, queue two new RW OPs(one for file1, one for file2)
> 
> 	io_uring_enter()	//wait until the above two OPs are done
> 
> 	for each reapped CQE:
> 		release the buffer registered by IORING_OP_GET_BUF
> 
> Or coroutine based approach: (every io command needs two syscalls)
> 
> 	for each reaaped CQE:
> 		- if CQE is for command from /dev/ublkc:
> 				- queue IORING_OP_GET_BUF
> 				- corouine wait: until IORING_OP_GET_BUF is done
> 				- queue two RW OPs with the registered buffer
> 				- coroutine wait: until all above OP is done
> 				- release buffer registered by IORING_OP_GET_BUF
> 		- otherwise:
> 			- call related co routine wakeup handler for advancing in
> 			above co routine wait point
> 		io_uring_enter();
> 
> coroutine based approach may look clean and easier to implement, but
> it depends on language support, and still needs extra care, also stackless
> coroutine isn't easy to use.

-- 
Pavel Begunkov
