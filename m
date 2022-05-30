Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF653739F
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 04:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiE3CsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 22:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiE3Cr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 22:47:59 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161843E5FC
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 19:47:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VEgpr6c_1653878873;
Received: from 30.82.254.106(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEgpr6c_1653878873)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 May 2022 10:47:54 +0800
Message-ID: <2333ef08-250b-6f8d-10e9-d3c9040bcc47@linux.alibaba.com>
Date:   Mon, 30 May 2022 10:47:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slot
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu.linux@icloud.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220526123848.18998-1-xiaoguang.wang@linux.alibaba.com>
 <aff94898-3642-99c4-e640-39139214dbc7@icloud.com>
 <76746921-0d10-2e8b-db30-26f1143b953b@linux.alibaba.com>
 <58d62354-0dab-e6a6-662d-26253bcb8123@kernel.dk>
 <8e6585df-10d6-9f12-5e82-7d7bc905e741@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <8e6585df-10d6-9f12-5e82-7d7bc905e741@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 5/28/22 6:28 AM, Jens Axboe wrote:
>> On 5/28/22 3:45 AM, Xiaoguang Wang wrote:
>>> hi Hao,
>>>
>>>> Hi Xiaoguang,
>>>>
>>>> On 5/26/22 20:38, Xiaoguang Wang wrote:
>>>>> One big issue with file registration feature is that it needs user
>>>>> space apps to maintain free slot info about io_uring's fixed file
>>>>> table, which really is a burden for development. Now since io_uring
>>>>> starts to choose free file slot for user space apps by using
>>>>> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
>>>>> need app to uses direct accept or direct open, which as far as I know,
>>>>> some apps are not prepared to use direct accept or open yet.
>>>>>
>>>>> To support apps, who still need real fds, use registration feature
>>>>> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slot,
>>>>> which will return free file slot in cqe->res.
>>>>>
>>>>> TODO list:
>>>>>      Need to prepare liburing corresponding helpers.
>>>>>
>>>>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>>> ---
>>>>>   fs/io_uring.c                 | 50 ++++++++++++++++++++++++++++++++++---------
>>>>>   include/uapi/linux/io_uring.h |  1 +
>>>>>   2 files changed, 41 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 9f1c682d7caf..d77e6bbec81c 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -680,6 +680,7 @@ struct io_rsrc_update {
>>>>>       u64                arg;
>>>>>       u32                nr_args;
>>>>>       u32                offset;
>>>>> +    u32                flags;
>>>>>   };
>>>>>     struct io_fadvise {
>>>>> @@ -7970,14 +7971,23 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
>>>>>       return 0;
>>>>>   }
>>>>>   +#define IORING_FILES_UPDATE_INDEX_ALLOC 1
>>>>> +
>>>>>   static int io_rsrc_update_prep(struct io_kiocb *req,
>>>>>                   const struct io_uring_sqe *sqe)
>>>>>   {
>>>>> +    u32 flags = READ_ONCE(sqe->files_update_flags);
>>>>> +
>>>>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>>>>           return -EINVAL;
>>>>> -    if (sqe->rw_flags || sqe->splice_fd_in)
>>>>> +    if (sqe->splice_fd_in)
>>>>> +        return -EINVAL;
>>>>> +    if (flags & ~IORING_FILES_UPDATE_INDEX_ALLOC)
>>>>> +        return -EINVAL;
>>>>> +    if ((flags & IORING_FILES_UPDATE_INDEX_ALLOC) && READ_ONCE(sqe->len) != 1)
>>>> How about allowing multiple fd update in IORING_FILES_UPDATE_INDEX_ALLOC
>>>> case? For example, using the sqe->addr(the fd array) to store the slots we allocated, and let cqe return the number of slots allocated.
>>> Good idea, I'll try in patch v2, thanks.
>>> Jens, any comments about this patch? At least It's really helpful to our
>>> internal apps based on io_uring :)
>> I like this suggestion too, other thoughts in reply to the original.
> BTW, if you have time, would be great to get this done for 5.19. It
> makes the whole thing more consistent and makes it so that 5.19 has
> (hopefully) all the alloc bits for direct descriptors.
Yeah, I have free time now, will prepare new version today.

Regards,
Xiaoguang Wang

>

