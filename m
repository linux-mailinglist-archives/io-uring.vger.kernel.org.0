Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C4054B67E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 18:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiFNQm2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 12:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbiFNQmX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 12:42:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0859AB50
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:42:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a15so12054145wrh.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=duXA7P3laox4cSAXt0DJnrW+x7rBylmTTrdNsSc123k=;
        b=JMSOB3m3WO4wPStDjhyoFqSKQbynCIO+gm1us3ugwCbaVispmGHLDeMji7ytIR+aBi
         l5t03ebaUBA5nQkicaSPYZCW95h8k0u5QEXETstusWJFuN3/XjdC82k/G1mijE/V4ljw
         xEvioa3RcSY44ZuQseujkunIqDST1dnWkACH7vK6Qsic+tUUx8c69xlOV2dr83xJYVtW
         forNy9nAmfuyFi3j+cVVLGDx2sORDd2CV6RUcyt+/pXpxD4yyl15qPzcwwFOr+lSG7hB
         kAGO30+pow5B376VGLEoO3MzBtEulHNWd25cFerH1FJck4rozWR8Guk07FsO0acusdfb
         B1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=duXA7P3laox4cSAXt0DJnrW+x7rBylmTTrdNsSc123k=;
        b=7gFFY4nhA6p+UxlWrnAFewPrnednLc0aR3bm/Ku3WO/JHeSZANvtse1xivz/dFCicV
         xTSWnmTJqd03sR/6EIpMW/aIMlb+PZKFpUr5XdJ7XjU/DAEIWGNIi646q9NDeY8zb1qr
         H2kPaDkamqCzmbc7Mk93JIZQ6xR4IuCmVYVETDQKsC5j9dx8HH85QrhVmZLFKmy7H4+E
         rTg8WR0ilzTRJ5Zc0+cmbDMffFvuEcicDx1Xe+wG/Hm7FfE6eApXDsY7HteQk/+Qjgpy
         RbRfPGbIhyosTgTxmGSD3DTVJOCVGmpZPCtAbEKxGmO4oDxnH91kcJn+bwGWDK62pnKQ
         ii4A==
X-Gm-Message-State: AJIora8et8UYo+NB3ptbF9UMPqbXZfjOQXa/tBfvopi4hyy5PFtm3IBO
        eAZMAxKjFIe9avAlB6mMYWwfTdKUnEj8Lg==
X-Google-Smtp-Source: AGRyM1vBCNYhj4V+s8SyngNqhZcvApzbFMxNli6ZoXZrKcHDEkL85ipMcCgRcEc7oUT3kV92z/HQ2g==
X-Received: by 2002:a05:6000:1448:b0:219:ebf7:79ff with SMTP id v8-20020a056000144800b00219ebf779ffmr5966118wrx.70.1655224939401;
        Tue, 14 Jun 2022 09:42:19 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id b6-20020a056000054600b002102739add8sm14923014wrf.54.2022.06.14.09.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:42:18 -0700 (PDT)
Message-ID: <485e5bd3-c099-566c-be86-4c8670314efe@gmail.com>
Date:   Tue, 14 Jun 2022 17:41:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
 <6a0ed050-e61f-a17c-f20c-677d00f65ca0@gmail.com>
 <b6f3fd47-a04f-3ffc-60fd-57a79da01070@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b6f3fd47-a04f-3ffc-60fd-57a79da01070@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/22 04:35, Xiaoguang Wang wrote:
> hello Pavel,
> 
>> On 5/30/22 14:15, Xiaoguang Wang wrote:
>>> One big issue with file registration feature is that it needs user
>>> space apps to maintain free slot info about io_uring's fixed file
>>> table, which really is a burden for development. Now since io_uring
>>> starts to choose free file slot for user space apps by using
>>> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
>>> need app to uses direct accept or direct open, which as far as I know,
>>> some apps are not prepared to use direct accept or open yet.
>>>
>>> To support apps, who still need real fds, use registration feature
>>> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slots,
>>> which will store picked fixed files slots in fd array and let cqe return
>>> the number of slots allocated.
>>
>> Why close bits are piggybacked in this patch without any mention
>> in the commit message?
> Sorry, it actually should be in one separate patch.
> 
>> What is error semantics of
>> IORING_CLOSE_FD_AND_FILE_SLOT. Fail if any errored or both? How
>> can it be reliably used? Why we do two separate things in one
>> request with not clear semantics?
> Yeah, indeed I know this issue when writing this patch, either normal
> fd close or file slot close may fail independently.  I put them together
> just for efficiency, one CLOSE op can do two jobs.
> 
>>
>> There is already one fix pending. Another problem on the surface
>> is that it may call io_close() twice and the second will fail, e.g.
>>
>> -> io_close()
>> ---> close_fixed()
>> ---> if (file->flush) return -EAGAIN
>> -> io_close()
>> ---> close_fixed() // fails
> Thanks for pointing this issue.
> 
>>
>>
>> I do think we need to revert the close change, and then remake
>> properly and only if someone can describe sane semantics for it.
> Revert this close change seems reasonable, I thought for a while,
> didn't figure out better solutions yet.
> Sorry for the trouble again.

No worries, let's kill it off then and return it back if and when
someone comes up with a good semantaics for error handling.



> 
> Regards,
> Xiaoguang Wang
>>
>>
>>
>>> Suggested-by: Hao Xu <howeyxu@tencent.com>
>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>> ---
>>> V2:
>>>     Add illegal flags check in io_close_prep().
>>> ---
>>>    fs/io_uring.c                 | 75 +++++++++++++++++++++++++++++++++++++------
>>>    include/uapi/linux/io_uring.h |  1 +
>>>    2 files changed, 66 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 6d91148e9679..18a7459fb6e7 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -574,6 +574,7 @@ struct io_close {
>>>        struct file            *file;
>>>        int                fd;
>>>        u32                file_slot;
>>> +    u32                flags;
>>>    };
>>>      struct io_timeout_data {
>>> @@ -1366,7 +1367,9 @@ static int io_req_prep_async(struct io_kiocb *req);
>>>      static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>>>                     unsigned int issue_flags, u32 slot_index);
>>> -static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>>> +static int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
>>> +                unsigned int offset);
>>> +static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>>>      static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
>>>    static void io_eventfd_signal(struct io_ring_ctx *ctx);
>>> @@ -5945,16 +5948,22 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>>>        return 0;
>>>    }
>>>    +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
>>> +
>>>    static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>    {
>>> -    if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
>>> +    if (sqe->off || sqe->addr || sqe->len || sqe->buf_index)
>>>            return -EINVAL;
>>>        if (req->flags & REQ_F_FIXED_FILE)
>>>            return -EBADF;
>>>          req->close.fd = READ_ONCE(sqe->fd);
>>>        req->close.file_slot = READ_ONCE(sqe->file_index);
>>> -    if (req->close.file_slot && req->close.fd)
>>> +    req->close.flags = READ_ONCE(sqe->close_flags);
>>> +    if (req->close.flags & ~IORING_CLOSE_FD_AND_FILE_SLOT)
>>> +        return -EINVAL;
>>> +    if (!(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT) &&
>>> +        req->close.file_slot && req->close.fd)
>>>            return -EINVAL;
>>>          return 0;
>>> @@ -5970,7 +5979,8 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>>          if (req->close.file_slot) {
>>>            ret = io_close_fixed(req, issue_flags);
>>> -        goto err;
>>> +        if (ret || !(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT))
>>> +            goto err;
>>>        }
>>>          spin_lock(&files->file_lock);
>>> @@ -8003,6 +8013,42 @@ static int io_files_update_prep(struct io_kiocb *req,
>>>        return 0;
>>>    }
>>>    +static int io_files_update_with_index_alloc(struct io_kiocb *req,
>>> +                        unsigned int issue_flags)
>>> +{
>>> +    __s32 __user *fds = u64_to_user_ptr(req->rsrc_update.arg);
>>> +    struct file *file;
>>> +    unsigned int done, nr_fds = req->rsrc_update.nr_args;
>>> +    int ret, fd;
>>> +
>>> +    for (done = 0; done < nr_fds; done++) {
>>> +        if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
>>> +            ret = -EFAULT;
>>> +            break;
>>> +        }
>>> +
>>> +        file = fget(fd);
>>> +        if (!file) {
>>> +            ret = -EBADF;
>>> +            goto out;
>>> +        }
>>> +        ret = io_fixed_fd_install(req, issue_flags, file,
>>> +                      IORING_FILE_INDEX_ALLOC);
>>> +        if (ret < 0)
>>> +            goto out;
>>> +        if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
>>> +            ret = -EFAULT;
>>> +            __io_close_fixed(req, issue_flags, ret);
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +out:
>>> +    if (done)
>>> +        return done;
>>> +    return ret;
>>> +}
>>> +
>>>    static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>>>    {
>>>        struct io_ring_ctx *ctx = req->ctx;
>>> @@ -8016,10 +8062,14 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>>>        up.resv = 0;
>>>        up.resv2 = 0;
>>>    -    io_ring_submit_lock(ctx, issue_flags);
>>> -    ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
>>> -                    &up, req->rsrc_update.nr_args);
>>> -    io_ring_submit_unlock(ctx, issue_flags);
>>> +    if (req->rsrc_update.offset == IORING_FILE_INDEX_ALLOC) {
>>> +        ret = io_files_update_with_index_alloc(req, issue_flags);
>>> +    } else {
>>> +        io_ring_submit_lock(ctx, issue_flags);
>>> +        ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
>>> +                &up, req->rsrc_update.nr_args);
>>> +        io_ring_submit_unlock(ctx, issue_flags);
>>> +    }
>>>          if (ret < 0)
>>>            req_set_fail(req);
>>> @@ -10183,9 +10233,9 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>>>        return ret;
>>>    }
>>>    -static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>>> +static int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
>>> +                unsigned int offset)
>>>    {
>>> -    unsigned int offset = req->close.file_slot - 1;
>>>        struct io_ring_ctx *ctx = req->ctx;
>>>        struct io_fixed_file *file_slot;
>>>        struct file *file;
>>> @@ -10222,6 +10272,11 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>>>        return ret;
>>>    }
>>>    +static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>>> +{
>>> +    return __io_close_fixed(req, issue_flags, req->close.file_slot - 1);
>>> +}
>>> +
>>>    static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>>>                     struct io_uring_rsrc_update2 *up,
>>>                     unsigned nr_args)
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 53e7dae92e42..e347b3fea4e4 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -47,6 +47,7 @@ struct io_uring_sqe {
>>>            __u32        unlink_flags;
>>>            __u32        hardlink_flags;
>>>            __u32        xattr_flags;
>>> +        __u32        close_flags;
>>>        };
>>>        __u64    user_data;    /* data to be passed back at completion time */
>>>        /* pack this to avoid bogus arm OABI complaints */
>>
> 

-- 
Pavel Begunkov
