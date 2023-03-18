Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A682D6BFAE5
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 15:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCROgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 10:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCROgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 10:36:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F69719699
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 07:36:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a16so3704681pjs.4
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 07:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679150198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=evWK/j+Fz+6ogk6UJoi+Ed7wwA7w6Ptpe3Rj5dE7lmE=;
        b=Q1qJNzpPUwB90SCS2RyedUmgtcNJB7dPK1o1hezIGyD+DdCaMf+iWVyUzE0m5rGlBR
         g8NeIyhiAkOZulLYpRsuPjBjB/PtlM1epmCUGaKeHR1THVhPKslY4Iaw5ps0RRnGerRe
         4keXHIL6mvbhotVvGRtfp2H+Ab24rcoIGnpx11NjhFgB/NGzhOUb2gBi0iUzpaYif2c2
         UFU1ntQ6F+J0kLM7Uk9Wc3qksN/YRpue5lU6eFUEssTUINtKvdrfsha/bFOoF1vIhvh6
         rR/ZNx86dV6Do2XH+ev5nom/pNDthe9OeYnqbQkzC/XVGjggdvjgqaR2WMq/P773f3ut
         rt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679150198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evWK/j+Fz+6ogk6UJoi+Ed7wwA7w6Ptpe3Rj5dE7lmE=;
        b=Eg0qaWeOa8Wr9jy/mAxxFAIywrw3HNrwiMp6IgYzsUM/RA10+4LHCes03d1XxeQnK4
         ZUVj4eYaOxodXb35Kb/df3Gm4HsqAs0z7qgPFvYdj0lodvcVY9XifYQrSmJCk8ZUK6Dr
         RAdgCKXlGSJNIra/NG97TEeSLp9vROTz+JL16VaM+jXPPmwnQtpsi2F8J0dxDtw/2UKr
         /f3uaixmLrbWEpBmifHJjJKQ/eBFVxHVeMvMcVvCgn6qCGfK1dUyHG6IZ8svkK7XskD+
         wG4XJhhucpfuc6rpyqmkvgXjtfaS2a7Q45C0oMjR/ou7ITQBo9bdtXoZbzL0K79b3ySs
         q7CQ==
X-Gm-Message-State: AO0yUKXPLLZ4ArOW/eSojIoUa/XQOLj1wUpePn/Uj/u9g70IckwEnXjE
        jWL4l7HZagCI0tzGtYVQ9F7nmg==
X-Google-Smtp-Source: AK7set9UjdzbIOtx2yyMAip//VawiucCW88QlObBpnitUPZWAxtjQ1YzELnm5Zhv6fcAlGTiP0FhhA==
X-Received: by 2002:a17:902:c40c:b0:19c:f005:92de with SMTP id k12-20020a170902c40c00b0019cf00592demr10234682plk.4.1679150198602;
        Sat, 18 Mar 2023 07:36:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v9-20020a1709028d8900b001964c8164aasm3370367plo.129.2023.03.18.07.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 07:36:38 -0700 (PDT)
Message-ID: <bb2a0c27-afc9-5683-9346-005b55a7240c@kernel.dk>
Date:   Sat, 18 Mar 2023 08:36:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <ZBQhSzIhvZL+83nM@ovpn-8-18.pek2.redhat.com>
 <3971d43f-601f-635f-5a30-df7e647f6659@kernel.dk>
 <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZBW+PCaeNmCR/k0M@ovpn-8-18.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/23 7:35?AM, Ming Lei wrote:
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
>>>>       when adding new ioctl or uring command
>>>>     - inline io_init_rq() for core code, so just export io_init_slave_req
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
> 
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
> 
> I believe that Pavel has realized this point[3] too, and here the only
> of value of using pipe is to reuse ->splice_read(), however, the above
> points show that ->splice_read() isn't good at this purpose.
> 
> 
> [1] https://lore.kernel.org/linux-block/ZAk5%2FHfwc+NBwlbI@ovpn-8-17.pek2.redhat.com/
> [2] https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
> [3] https://lore.kernel.org/linux-block/7cdea685-98d3-e24d-8282-87cb44ae6174@gmail.com/

splice is just one idea, but I do wonder if there's a way to express
this relationship (and buffer handovers) that doesn't involve needing
these odd kind of fused commands where they must be submitted as one big
sqe, but really are two normal ones. BPF is obviously one way, and maybe
we'll do BPF with io_uring at some point, but it makes things rather
more complicated to use and I'd prefer to avoid it if we can.

I'll take a closer look at the patches.

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

Thanks, did get that one now and applied it.

-- 
Jens Axboe

