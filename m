Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB28570B06
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiGKT5C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 15:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKT5C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 15:57:02 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9AD5720D;
        Mon, 11 Jul 2022 12:57:00 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id r129-20020a1c4487000000b003a2d053adcbso5575198wma.4;
        Mon, 11 Jul 2022 12:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O95XBONbhmcHFULPXsQnT4f0oCEVatoS/EeJhmunXGs=;
        b=yyO2jz55rH4OEt1rGu/qz1g4dxICGifBHIiJ2ABbe6tQKV2jwL6TdzYMlCfQ8yHR0H
         TVWkLwzvhIrMQ34jD8PXKJm4gKdqwg0zw04cxPl+lao/1dfziwp+hC+BsKbB9r9kOMGI
         c9dpTFcZIRTeQKVtrTCJF/RYdFh1C+5nle4VxB4MORERlVXIxb2wCjojUB0vDOa9MYdz
         sxGkOplCTx0O1Z8WKNU06fdM/2J4NsVQhT/xzpz5JSyIgDUULjj9rxjKJxO+igq+Xh6v
         oomlWGNPlxxds/jKYxlDSu1mQE5cuDaQg0Yv9wC3suOYJ+pTl8fgz42HW5g/InqaYynM
         USow==
X-Gm-Message-State: AJIora+j54s/CTaLDGlbtbvsBMJJt5un7qjs91l2Xamo7qu28hlHqrAi
        TmR9dEVwcUOkm+7ygrPvYbA=
X-Google-Smtp-Source: AGRyM1u5Fb/D8Jsr7DeZ4Lnoq4U99v2IXTLSKnvm+VomEXYyv0wyV8hSvXYPgG6roa8mI3z1Pyblng==
X-Received: by 2002:a05:600c:219a:b0:3a2:e4b0:4cfb with SMTP id e26-20020a05600c219a00b003a2e4b04cfbmr60548wme.2.1657569418752;
        Mon, 11 Jul 2022 12:56:58 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d634a000000b0021b89f8662esm6684298wrw.13.2022.07.11.12.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 12:56:58 -0700 (PDT)
Message-ID: <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
Date:   Mon, 11 Jul 2022 22:56:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
 <20220711183746.GA20562@test-zns>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220711183746.GA20562@test-zns>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>> @@ -448,6 +442,14 @@ static int nvme_uring_cmd_io(struct nvme_ctrl 
>>> *ctrl, struct nvme_ns *ns,
>>>      pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
>>>      pdu->meta_len = d.metadata_len;
>>> +    if (issue_flags & IO_URING_F_MPATH) {
>>> +        req->cmd_flags |= REQ_NVME_MPATH;
>>> +        /*
>>> +         * we would need the buffer address (d.addr field) if we have
>>> +         * to retry the command. Store it by repurposing ioucmd->cmd
>>> +         */
>>> +        ioucmd->cmd = (void *)d.addr;
>>
>> What does repurposing mean here?
> 
> This field (ioucmd->cmd) was pointing to passthrough command (which
> is embedded in SQE of io_uring). At this point we have consumed
> passthrough command, so this field can be reused if we have to. And we
> have to beceause failover needs recreating passthrough command.
> Please see nvme_uring_cmd_io_retry to see how this helps in recreating
> the fields of passthrough command. And more on this below.

so ioucmd->cmd starts as an nvme_uring_cmd pointer and continues as
an address of buffer for a later processing that may or may not
happen in its lifetime?

Sounds a bit of a backwards design to me.

>>> +    }
>>>      blk_execute_rq_nowait(req, false);
>>>      return -EIOCBQUEUED;
>>>  }
>>> @@ -665,12 +667,135 @@ int nvme_ns_head_chr_uring_cmd(struct 
>>> io_uring_cmd *ioucmd,
>>>      int srcu_idx = srcu_read_lock(&head->srcu);
>>>      struct nvme_ns *ns = nvme_find_path(head);
>>>      int ret = -EINVAL;
>>> +    struct device *dev = &head->cdev_device;
>>> +
>>> +    if (likely(ns)) {
>>> +        ret = nvme_ns_uring_cmd(ns, ioucmd,
>>> +                issue_flags | IO_URING_F_MPATH);
>>> +    } else if (nvme_available_path(head)) {
>>> +        struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>> +        struct nvme_uring_cmd *payload = NULL;
>>> +
>>> +        dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>>> +        /*
>>> +         * We may requeue two kinds of uring commands:
>>> +         * 1. command failed post submission. pdu->req will be non-null
>>> +         * for this
>>> +         * 2. command that could not be submitted because path was not
>>> +         * available. For this pdu->req is set to NULL.
>>> +         */
>>> +        pdu->req = NULL;
>>
>> Relying on a pointer does not sound like a good idea to me.
>> But why do you care at all where did this command came from?
>> This code should not concern itself what happened prior to this
>> execution.
> Required, please see nvme_uring_cmd_io_retry. And this should be more
> clear as part of responses to your other questions.

I think I understand. But it looks fragile to me.

> 
>>> +        /*
>>> +         * passthrough command will not be available during retry as it
>>> +         * is embedded in io_uring's SQE. Hence we allocate/copy here
>>> +         */
>>
>> OK, that is a nice solution.
> Please note that prefered way is to recreate the passthrough command,
> and not to allocate it. We allocate it here because this happens very early
> (i.e. before processing passthrough command and setting that up inside
> struct request). Recreating requires a populated 'struct request' .

I think that once a driver consumes a command as queued, it needs a
stable copy of the command (could be in a percpu pool).

The current design of nvme multipathing is that the request is stripped
from its bios and placed on a requeue_list, and if a request was not
formed yet (i.e. nvme available path exist but no usable) the bio is
placed on the requeue_list.

So ideally we have something sufficient like a bio, that can be linked
on a requeue list, and is sufficient to build a request, at any point in
time...

>>
>>> +        payload = kmalloc(sizeof(struct nvme_uring_cmd), GFP_KERNEL);
>>> +        if (!payload) {
>>> +            ret = -ENOMEM;
>>> +            goto out_unlock;
>>> +        }
>>> +        memcpy(payload, ioucmd->cmd, sizeof(struct nvme_uring_cmd));
>>> +        ioucmd->cmd = payload;
>>> -    if (ns)
>>> -        ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>> +        spin_lock_irq(&head->requeue_ioucmd_lock);
>>> +        ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
>>> +        spin_unlock_irq(&head->requeue_ioucmd_lock);
>>> +        ret = -EIOCBQUEUED;
>>> +    } else {
>>> +        dev_warn_ratelimited(dev, "no available path - failing I/O\n");
>>
>> ret=-EIO ?
> Did not do as it was initialized to -EINVAL. Do you prefer -EIO instead.

It is not an invalid argument error here, it is essentially an IO error.
So yes, that would be my preference.

>>> +    }
>>> +out_unlock:
>>>      srcu_read_unlock(&head->srcu, srcu_idx);
>>>      return ret;
>>>  }
>>> +
>>> +int nvme_uring_cmd_io_retry(struct nvme_ns *ns, struct request *oreq,
>>> +        struct io_uring_cmd *ioucmd, struct nvme_uring_cmd_pdu *pdu)
>>> +{
>>> +    struct nvme_ctrl *ctrl = ns->ctrl;
>>> +    struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
>>> +    struct nvme_uring_data d;
>>> +    struct nvme_command c;
>>> +    struct request *req;
>>> +    struct bio *obio = oreq->bio;
>>> +    void *meta = NULL;
>>> +
>>> +    memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
>>> +    d.metadata = (__u64)pdu->meta_buffer;
>>> +    d.metadata_len = pdu->meta_len;
>>> +    d.timeout_ms = oreq->timeout;
>>> +    d.addr = (__u64)ioucmd->cmd;
>>> +    if (obio) {
>>> +        d.data_len = obio->bi_iter.bi_size;
>>> +        blk_rq_unmap_user(obio);
>>> +    } else {
>>> +        d.data_len = 0;
>>> +    }
>>> +    blk_mq_free_request(oreq);
>>
>> The way I would do this that in nvme_ioucmd_failover_req (or in the
>> retry driven from command retriable failure) I would do the above,
>> requeue it and kick the requeue work, to go over the requeue_list and
>> just execute them again. Not sure why you even need an explicit retry
>> code.
> During retry we need passthrough command. But passthrough command is not
> stable (i.e. valid only during first submission). We can make it stable
> either by:
> (a) allocating in nvme (b) return -EAGAIN to io_uring, and it will do 
> allocate + deferral
> Both add a cost. And since any command can potentially fail, that
> means taking that cost for every IO that we issue on mpath node. Even if
> no failure (initial or subsquent after IO) occcured.

As mentioned, I think that if a driver consumes a command as queued,
it needs a stable copy for a later reformation of the request for
failover purposes.

> So to avoid commmon-path cost, we go about doing nothing (no allocation,
> no deferral) in the outset and choose to recreate the passthrough
> command if failure occured. Hope this explains the purpose of
> nvme_uring_cmd_io_retry?

I think it does, but I'm still having a hard time with it...

> 
> 
>>> +    req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
>>> +            d.data_len, nvme_to_user_ptr(d.metadata),
>>> +            d.metadata_len, 0, &meta, d.timeout_ms ?
>>> +            msecs_to_jiffies(d.timeout_ms) : 0,
>>> +            ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
>>> +    if (IS_ERR(req))
>>> +        return PTR_ERR(req);
>>> +
>>> +    req->end_io = nvme_uring_cmd_end_io;
>>> +    req->end_io_data = ioucmd;
>>> +    pdu->bio = req->bio;
>>> +    pdu->meta = meta;
>>> +    req->cmd_flags |= REQ_NVME_MPATH;
>>> +    blk_execute_rq_nowait(req, false);
>>> +    return -EIOCBQUEUED;
>>> +}
>>> +
>>> +void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
>>> +{
>>> +    struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>> +    struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head,
>>> +            cdev);
>>> +    int srcu_idx = srcu_read_lock(&head->srcu);
>>> +    struct nvme_ns *ns = nvme_find_path(head);
>>> +    unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
>>> +        IO_URING_F_MPATH;
>>> +    struct device *dev = &head->cdev_device;
>>> +
>>> +    if (likely(ns)) {
>>> +        struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>> +        struct request *oreq = pdu->req;
>>> +        int ret;
>>> +
>>> +        if (oreq == NULL) {
>>> +            /*
>>> +             * this was not submitted (to device) earlier. For this
>>> +             * ioucmd->cmd points to persistent memory. Free that
>>> +             * up post submission
>>> +             */
>>> +            const void *cmd = ioucmd->cmd;
>>> +
>>> +            ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>> +            kfree(cmd);
>>> +        } else {
>>> +            /*
>>> +             * this was submitted (to device) earlier. Use old
>>> +             * request, bio (if it exists) and nvme-pdu to recreate
>>> +             * the command for the discovered path
>>> +             */
>>> +            ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);
>>
>> Why is this needed? Why is reuse important here? Why not always call
>> nvme_ns_uring_cmd?
> 
> Please see the previous explanation.
> If condition is for the case when we made the passthrough command stable
> by allocating beforehand.
> Else is for the case when we avoided taking that cost.

The current design of the multipath failover code is clean:
1. extract bio(s) from request
2. link in requeue_list
3. schedule requeue_work that,
  3.1 takes bios 1-by-1, and submits them again (exactly the same way)

I'd like us to try to follow the same design where retry is
literally "do the exact same thing, again". That would eliminate
two submission paths that do the same thing, but slightly different.

> 
>>> +        }
>>> +        if (ret != -EIOCBQUEUED)
>>> +            io_uring_cmd_done(ioucmd, ret, 0);
>>> +    } else if (nvme_available_path(head)) {
>>> +        dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>>> +        spin_lock_irq(&head->requeue_ioucmd_lock);
>>> +        ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
>>> +        spin_unlock_irq(&head->requeue_ioucmd_lock);
>>> +    } else {
>>> +        dev_warn_ratelimited(dev, "no available path - failing I/O\n");
>>> +        io_uring_cmd_done(ioucmd, -EINVAL, 0);
>>
>> -EIO?
> Can change -EINVAL to -EIO if that is what you prefer.

Yes.
