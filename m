Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF336B0F76
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 17:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCHQ6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 11:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCHQ6G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 11:58:06 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B509D5151;
        Wed,  8 Mar 2023 08:56:30 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1801730wmb.0;
        Wed, 08 Mar 2023 08:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678294582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8aawLgdTyGrR288varEmmF/Y/ULImrZS2HNqkf0hRec=;
        b=cFS174NQxecQ+yipN6X2+qQG/mwkHvlgxmN/aW93fcFjdTPsi0ZzG+FBRfYAMhLPY/
         o4MHIzwIstBqbZ+HZdnHhQ7Dsvsx1fPWdipMzoU3V8HDnDSjnXqo3oYVstxej7r7/WKK
         kOuOsyiJZdgBYn3uAUgME8TS+IXKQ2/tbJmiDYqTHDa0LLG97lOBNFckR5qVWEkdAYLt
         ppjpma8uSMAaMZUvMb/SpjlIjPrWyeXCfWZCRIIPJ8UHun+TOGEAB+V4mYAdAscL7kU8
         DskIlFSFHG1QtMiJd7z6itgdNKf+uc/7VD7GJ2Q+J6lqhHn9UfaR0ewFS026bQAP2LTm
         cj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678294582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8aawLgdTyGrR288varEmmF/Y/ULImrZS2HNqkf0hRec=;
        b=06NRPKj1LCX5xrlDNX3r+jiMM+6bAW1cUcFrwl3wSyy/DmojUATzb69P5FCq30BHVv
         5gYePMPs15EyhY0tkQTDnh1aujjeRcWIu0/ofz8Nr3K5DLP5s1kUO4Jv7/TLDintGGAN
         q4tv5dmss6S6ODEdKsj6TCnM3s4qL5M75cohN0AmryDMcJx4+7m9d0b1ZP194N4wq6Cp
         tGDLkQ8f2qdAAWp17yBaEtHc858MCp1Wc03PMSILXr6Ru/bRH8nxqbMn1hLgg9wOn1G9
         16+sr5trDZC9v/p9+vfMBa9r92TYgGNpwZMrOsZvSzAsZJ5FPBidyV1+bjpG+TxQ6AiD
         JuyA==
X-Gm-Message-State: AO0yUKWtPOiqVznO+vH1qsC89IoXZyutp9W/QwhwgBdoO+BPOxwXGz68
        J7JPoJaKZAR1rkHshbzDsZusxOcLj8w=
X-Google-Smtp-Source: AK7set/VEIDpJXbnE4Qp5h8mXE/hLGy1cRJIa97Rn5tsxcpFdocolLh3rlzllJ4qmjsmq+whyjWY9w==
X-Received: by 2002:a05:600c:1c9c:b0:3ea:4af0:3475 with SMTP id k28-20020a05600c1c9c00b003ea4af03475mr16761043wms.1.1678294582145;
        Wed, 08 Mar 2023 08:56:22 -0800 (PST)
Received: from [192.168.8.100] (188.28.103.91.threembb.co.uk. [188.28.103.91])
        by smtp.gmail.com with ESMTPSA id p7-20020a5d48c7000000b002c71d206329sm15645709wrs.55.2023.03.08.08.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:56:21 -0800 (PST)
Message-ID: <9f08445c-1f1e-a8e8-be93-4a97ec631d32@gmail.com>
Date:   Wed, 8 Mar 2023 16:54:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
 <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
 <ZAfurtfY4lXa8sxX@ovpn-8-16.pek2.redhat.com>
 <effb2361-b66e-2678-ef86-5f9565c4ad9a@gmail.com>
 <ZAi1GKgHfLcDL2jM@ovpn-8-17.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZAi1GKgHfLcDL2jM@ovpn-8-17.pek2.redhat.com>
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

On 3/8/23 16:17, Ming Lei wrote:
> On Wed, Mar 08, 2023 at 02:46:48PM +0000, Pavel Begunkov wrote:
>> On 3/8/23 02:10, Ming Lei wrote:
>>> On Tue, Mar 07, 2023 at 05:17:04PM +0000, Pavel Begunkov wrote:
>>>> On 3/7/23 15:37, Pavel Begunkov wrote:
>>>>> On 3/7/23 14:15, Ming Lei wrote:
>>>>>> Hello,
>>>>>>
>>>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>>>> and its ->issue() can retrieve/import buffer from master request's
>>>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>>>> SQE order is kept, and batching handling is done too.
>>>>>
>>>>>    From a quick look through patches it all looks a bit complicated
>>>>> and intrusive, all over generic hot paths. I think instead we
>>>>> should be able to use registered buffer table as intermediary and
>>>>> reuse splicing. Let me try it out
>>>>
>>>> Here we go, isolated in a new opcode, and in the end should work
>>>> with any file supporting splice. It's a quick prototype, it's lacking
>>>> and there are many obvious fatal bugs. It also needs some optimisations,
>>>> improvements on how executed by io_uring and extra stuff like
>>>> memcpy ops and fixed buf recv/send. I'll clean it up.
>>>>
>>>> I used a test below, it essentially does zc recv.
>>>>
>>>> https://github.com/isilence/liburing/commit/81fe705739af7d9b77266f9aa901c1ada870739d
>>>>
>> [...]
>>>> +int io_splice_from(struct io_kiocb *req, unsigned int issue_flags)
>>>> +{
>>>> +	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
>>>> +	loff_t *ppos = (sp->off == -1) ? NULL : &sp->off;
>>>> +	struct io_mapped_ubuf *imu;
>>>> +	struct pipe_inode_info *pi;
>>>> +	struct io_ring_ctx *ctx;
>>>> +	unsigned int pipe_tail;
>>>> +	int ret, i, nr_pages;
>>>> +	u16 index;
>>>> +
>>>> +	if (!sp->file->f_op->splice_read)
>>>> +		return -ENOTSUPP;
>>>> +
>>>> +	pi = alloc_pipe_info();
>>>
>>> The above should be replaced with direct pipe, otherwise every time
>>> allocating one pipe inode really hurts performance.
>>
>> We don't even need to alloc it dynanically, could be just
>> on stack. There is a long list of TODOs I can add, e.g.
>> polling support, retries, nowait, caching imu and so on.
>>
>> [...]
>>> Your patch looks like transferring pages ownership to io_uring fixed
>>> buffer, but unfortunately it can't be done in this way. splice is
>>> supposed for moving data, not transfer buffer ownership.
>>
>> Borrowing rather than transferring. It's not obvious since it's
>> not implemented in the patch, but the buffer should be eventually
>> returned using the splice's ->release callback.
> 
> What is the splice's ->release() callback? Is pipe buffer's
> release()? If yes, there is at least the following two problems:

Right

> 1) it requires the buffer to be saved(for calling its callback and use its private
> data to return back the whole buffer) in the pipe until it is consumed, which becomes
> one sync interface like splice syscall, and can't cross multiple io_uring OPs or
> per-buffer pipe inode is needed

We don't mix data from different sources, it's reasonable to expect
that all buffers will have the same callback, then it'll be saved
in struct io_mapped_ubuf. That's sth should definitely be checked and
rejected if happens.

> 2) pipe buffer's get()/release() works on per-buffer/page level, but
> we need to borrow the whole buffer, and the whole buffer could be used

Surely that can be improved.

> by arbitrary number of OPs, such as one IO buffer needs to be used for
> handling mirror or stripped targets, so when we know the buffer can be released?

There is a separate efficient lifetime semantic for io_uring's registered
buffers, which don't involve any get/put. It'll be freed according to it,
i.e. when the userspace asks it to be removed and there are no more
inflight requests.

> And basically it can't be known by kernel, and only application knows
> when to release it.
> 
> Anyway, please post the whole patch, otherwise it is hard to see
> the whole picture, and devil is always in details, especially Linus
> mentioned splice can't be used in this way.

Sure

> 
>>
>>> https://lore.kernel.org/linux-block/CAJfpeguQ3xn2-6svkkVXJ88tiVfcDd-eKi1evzzfvu305fMoyw@mail.gmail.com/
>>>
>>> 1) pages are actually owned by device side(ublk, here: sp->file), but we want to
>>> loan them to io_uring normal OPs.
>>>
>>> 2) after these pages are used by io_uring normal OPs, these pages have
>>> been returned back to sp->file, and the notification has to be done
>>> explicitly, because page is owned by sp->file of splice_read().
>>
>> Right, see above, they're going to be returned back via ->release.
> 
> How?

I admit, I shouldn't have skipped it even for a quick POC. It'll save
->release() in struct io_mapped_ubuf and call it when the buffer is
freed from io_uring perspective, that is there are no more requests
using it and the user requested it to be removed.

>>> 3) pages RW direction has to limited strictly, and in case of ublk/fuse,
>>> device pages can only be read or write which depends on user io request
>>> direction.
>>
>> Yes, I know, and directions will be needed anyway for DMA mappings and
>> different p2p cases in the future, but again a bunch of things is
>> omitted here.
> 
> Please don't omitted it and it is one fundamental security problem.

That's not interesting for a design concept with a huge warning.
io_import_fixed() already takes a dir argument, we just need to check
it against the buffer's one.


>>> Also IMO it isn't good to add one buffer to ctx->user_bufs[] oneshot and
>>> retrieve it oneshot, and it can be set via req->imu simply in one fused
>>> command.
>>
>> That's one of the points though. It's nice if not necessary (for a generic
>> feature) to be able to do multiple ops on the data. For instance, if we
>> have a memcpy request, we can link it to this splice / zc recv, memcpy
>> necessary headers to the userspace and let it decide how to proceed with
>> data.
> 
> I feel it could be one big problem for buffer borrowing to cross more than one
> OPs, and when can the buffer be returned back?

Described above

> memory copy can be done simply by device's read/write interface, please see
> patch 15.

I don't think I understand how it looks in the userspace, maybe it's
only applicable to ublk? but it seems that the concept of having one op
producing a buffer and another consuming it don't go well with multi
use in general case, especially stretched in time.

E.g. you recv data, some of which is an application protocol header
that should be looked at by the user and the rest is data that might
be sent out somewhere else.

Am I wrong?

-- 
Pavel Begunkov
