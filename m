Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578DB6BFBAA
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCRQyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCRQyG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:54:06 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BE219699;
        Sat, 18 Mar 2023 09:54:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so4678539wmb.1;
        Sat, 18 Mar 2023 09:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679158443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pbHZBWgbi8c8GIE/JCzYh14fTHX0XSC2HFBl14irg6w=;
        b=nS6m1zB5kxsJ1OXDJu+SWJ4SQ4hEdxiLcJoU7Xh3x0DIRLxJyoudctrklfTl2FMMx/
         IeSbVOfJzKM4Ez0+CJ9gBQHfteNBRQiVlKw1sr1+VkdJ5oj88d43W23DPN49sW9wriCS
         742fdYGrbH430N9boxOo72GQ8NxDzMVSjLGZhw/0D3p3iAmh0OGfBceNTE9jdy8hdiuv
         fmC6NbTOPLo3AsfqgxP5lglcicHMLO9tO8XXC8kXZ0dw16+TmsZgq1lkt6lYzLYUKoN5
         l7DNxNwrRZjN+AIpfRm35ivo1tX+Srd7MZYcOUuyI+JqN3dOX+xm3eN4tLkDcTGmme0f
         weEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679158443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pbHZBWgbi8c8GIE/JCzYh14fTHX0XSC2HFBl14irg6w=;
        b=qUiJ70NW3/WdQXOJ0yGPrxjc2/Lj6aauGMLILH3STMLjqaq5L79W63vhNmmKmOUJBO
         L/j4YPxlu1m4sNTo+wBk3dCKeeasrRZQJfG/xSgWTaQZrYiWVn8BM89cGMW/M2LeFzz1
         pawgH9CSPd7/7CNclcVKHs+IZRmuwHNwJYd5tjjUMUXyE0s3S1K9K4DqSoyetejLSOIX
         sCkU6543L5lquXhcRrJ8Kw/2MtbTw4pYvQ6yWcrsK4de+kZnNjw2f15eGBalysKvYQGj
         xmlgaeyP+hwXFhB0PVSvf7NLCrjBQhcVNd9bzqK6Qp/X9w6UQHqi8hDcBlifsZCAPtRk
         nreg==
X-Gm-Message-State: AO0yUKX20zaYodakhpn87Kt9MNQ89AM2XhzaE0e4foMv+a8bPH2M/h85
        XMiKzUnDhAVj7/1xgml4IsXOBpUb5B4=
X-Google-Smtp-Source: AK7set/KjW117cMHqZmSfauj+3MQY8VWH2yYr4rmA/4OmOudIWb/wUx+JRPjPDBy8qSQjf6AGsr5HQ==
X-Received: by 2002:a1c:7418:0:b0:3ed:af6b:7faa with SMTP id p24-20020a1c7418000000b003edaf6b7faamr1988561wmc.17.1679158443053;
        Sat, 18 Mar 2023 09:54:03 -0700 (PDT)
Received: from [192.168.43.77] (82-132-228-239.dab.02.net. [82.132.228.239])
        by smtp.gmail.com with ESMTPSA id a7-20020a5d5087000000b002c55306f6edsm4695473wrt.54.2023.03.18.09.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 09:54:02 -0700 (PDT)
Message-ID: <4f8161e7-5229-45c4-1bb2-b86d87e22a16@gmail.com>
Date:   Sat, 18 Mar 2023 16:51:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/23 13:35, Ming Lei wrote:
> Hi Jens,
> 
> Thanks for the response!
> 
> On Sat, Mar 18, 2023 at 06:59:41AM -0600, Jens Axboe wrote:
>> On 3/17/23 2:14?AM, Ming Lei wrote:
>>> On Tue, Mar 14, 2023 at 08:57:11PM +0800, Ming Lei wrote:
>>>> Hello,
>>>>
>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>> and its ->issue() can retrieve/import buffer from master request's
>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>> SQE order is kept, and batching handling is done too.
>>>>
>>>> Please see detailed design in commit log of the 2th patch, and one big
>>>> point is how to handle buffer ownership.
>>>>
>>>> With this way, it is easy to support zero copy for ublk/fuse device.
>>>>
>>>> Basically userspace can specify any sub-buffer of the ublk block request
>>>> buffer from the fused command just by setting 'offset/len'
>>>> in the slave SQE for running slave OP. This way is flexible to implement
>>>> io mapping: mirror, stripped, ...
>>>>
>>>> The 3th & 4th patches enable fused slave support for the following OPs:
>>>>
>>>> 	OP_READ/OP_WRITE
>>>> 	OP_SEND/OP_RECV/OP_SEND_ZC
>>>>
>>>> The other ublk patches cleans ublk driver and implement fused command
>>>> for supporting zero copy.
>>>>
>>>> Follows userspace code:
>>>>
>>>> https://github.com/ming1/ubdsrv/tree/fused-cmd-zc-v2
>>>>
>>>> All three(loop, nbd and qcow2) ublk targets have supported zero copy by passing:
>>>>
>>>> 	ublk add -t [loop|nbd|qcow2] -z ....
>>>>
>>>> Basic fs mount/kernel building and builtin test are done, and also not
>>>> observe regression on xfstest test over ublk-loop with zero copy.
>>>>
>>>> Also add liburing test case for covering fused command based on miniublk
>>>> of blktest:
>>>>
>>>> https://github.com/ming1/liburing/commits/fused_cmd_miniublk
>>>>
>>>> Performance improvement is obvious on memory bandwidth
>>>> related workloads, such as, 1~2X improvement on 64K/512K BS
>>>> IO test on loop with ramfs backing file.
>>>>
>>>> Any comments are welcome!
>>>>
>>>> V3:
>>>> 	- fix build warning reported by kernel test robot
>>>> 	- drop patch for checking fused flags on existed drivers with
>>>> 	  ->uring_command(), which isn't necessary, since we do not do that
>>>>        when adding new ioctl or uring command
>>>>      - inline io_init_rq() for core code, so just export io_init_slave_req
>>>> 	- return result of failed slave request unconditionally since REQ_F_CQE_SKIP
>>>> 	will be cleared
>>>> 	- pass xfstest over ublk-loop
>>>
>>> Hello Jens and Guys,
>>>
>>> I have been working on io_uring zero copy support for ublk/fuse for a while, and
>>> I appreciate you may share any thoughts on this patchset or approach?
>>
>> I'm a bit split on this one, as I really like (and want) the feature.
>> ublk has become popular pretty quickly, and it makes a LOT of sense to
>> support zero copy for it. At the same time, I'm not really a huge fan of
>> the fused commands... They seem too specialized to be useful for other
>> things, and it'd be a shame to do something like that only for it later
>> to be replaced by a generic solution. And then we're stuck with
>> supporting fused commands forever, not sure I like that prospect.
>>
>> Both Pavel and Xiaoguang voiced similar concerns, and I think it may be
>> worth spending a bit more time on figuring out if splice can help us
>> here. David Howells currently has a lot going on in that area too.
> 
> IMO, splice(->splice_read()) can help much less in this use case, and
> I can't see improvement David Howells has done in this area:

Let me correct a misunderstanding I've seen a couple of times
from people. Apart from the general idea of providing buffers, it's
not that bound to splice. Yes, I reused splicing guts for that
half-made POC, but we can add a new callback that would do it a
bit nicer, i.e. better consolidating returned buffers. Would
probably be even better to have both of them falling back to
splice so it can cover more cases. The core of it is mediating
buffers through io_uring's registered buffer table, which
decouples all the components from each other.

> 1) we need to pass reference of the whole buffer from driver to io_uring,
> which is missed in splice, which just deals with page reference; for
> passing whole buffer reference, we have to apply per buffer pipe to
> solve the problem, and this way is expensive since the pipe can't
> be freed until all buffers are consumed.
> 
> 2) reference can't outlive the whole buffer, and splice still misses
> mechanism to provide such guarantee; splice can just make sure that
> page won't be gone if page reference is grabbed, but here we care
> more the whole buffer & its (shared)references lifetime
> 
> 3) current ->splice_read() misses capability to provide writeable
> reference to spliced page[2]; either we have to pass new flags
> to ->splice_read() or passing back new pipe buf flags, unfortunately
> Linus thought it isn't good to extend pipe/splice for such purpose,
> and now I agree with Linus now.

It might be a non-workable option if we're thinking about splice(2)
and pipes, but pipes and ->splice_read() are just internal details,
an execution mechanism, and it's hidden from the userspace.

I guess someone might make a point that we don't want any changes
to the splice code even if it doesn't affect splice(2) userspace
users, but that's rather a part of development process.
  
> I believe that Pavel has realized this point[3] too, and here the only
> of value of using pipe is to reuse ->splice_read(), however, the above
> points show that ->splice_read() isn't good at this purpose.

But agree that, ->splice_read() doesn't support the revers
direction, i.e. a file (e.g. ublk) provides buffers for
someone to write into it, that would need to be extended
in some way.

> [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/

Oops, missed this one

> [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/

Miklos said that it's better to signal the owner of buffer about
completion, IIUC the way I was proposing, i.e. calling ->release
when io_uring removes the buffer and all io_uring requests using
it complete, should do exactly that.

> [3] https://lore.kernel.org/linux-block/7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com/
> 
>>
>> So while I'd love to see this feature get queued up right now, I also
>> don't want to prematurely do so. Can we split out the fixes from this
>> series into a separate series that we can queue up now? That would also
>> help shrink the patchset, which is always a win for review.
> 
> There is only one fix(patch 5), and the real part is actually the 1st 4
> patches.
> 
> I will separate patch 5 from the whole patchset and send out soon, and will
> post out this patchset v4 by improving document for explaining how fused
> command solves this problem in one safe & efficient way.

-- 
Pavel Begunkov
