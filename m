Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB696F2914
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 15:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjD3Nnv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3Nnu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 09:43:50 -0400
X-Greylist: delayed 569 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Apr 2023 06:43:47 PDT
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [IPv6:2001:41d0:1004:224b::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C577030D7
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 06:43:47 -0700 (PDT)
Message-ID: <68892634-ceae-6d98-7474-49f85423838a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682861655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oUEqL7j6hpOXLWfRmzPGo5BwYy2GvS8bMoMVSa/W9RQ=;
        b=HUMIdAU57stB0k8VgGY8NGscTPtzatAsikIY59xQRSW40yHFDpwe/f4oa2AmLdJB8PgWa1
        Q4wSKl0QorH2iEJmCXk6BLaymoRvzufrBagMC+2WmNsHmEVimkUHyN1bPGYzMuBWuQwOwb
        tYxFrAQHhiSqINW/yQAdkuWge715FWY=
Date:   Sun, 30 Apr 2023 21:34:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <414392f2-3980-71fa-fa90-294085f156ee@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <414392f2-3980-71fa-fa90-294085f156ee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 4/25/23 23:28, Pavel Begunkov wrote:
> On 4/25/23 15:42, Ming Lei wrote:
>> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where 
>>>>>>>>>>> we always
>>>>>>>>>>> need io-wq punt. With that done, exclude them from the 
>>>>>>>>>>> file_can_poll()
>>>>>>>>>>> check in terms of whether or not we need to punt them if any 
>>>>>>>>>>> of the
>>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>> ---
>>>>>>>>>>>   io_uring/io_uring.c |  2 +-
>>>>>>>>>>>   io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>>   io_uring/opdef.h    |  2 ++
>>>>>>>>>>>   3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct 
>>>>>>>>>>> io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>>           return -EBADF;
>>>>>>>>>>>         if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>>> -        (!req->file || !file_can_poll(req->file)))
>>>>>>>>>>> +        (!req->file || !file_can_poll(req->file) || 
>>>>>>>>>>> def->always_iowq))
>>>>>>>>>>>           issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>>
>>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>>
>>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>>> ->always_iowq. If we can poll the file, we should not force 
>>>>>>>>> inline
>>>>>>>>> submission. Basically the ones setting ->always_iowq always do 
>>>>>>>>> -EAGAIN
>>>>>>>>> returns if nonblock == true.
>>>>>>>>
>>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for ->always_iowq, and
>>>>>>>> these OPs won't return -EAGAIN, then run in the current task 
>>>>>>>> context
>>>>>>>> directly.
>>>>>>>
>>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the 
>>>>>>> point of
>>>>>>> it :-)
>>>>>>
>>>>>> But ->always_iowq isn't actually _always_ since 
>>>>>> fallocate/fsync/... are
>>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the 
>>>>>> naming of
>>>>>> ->always_iowq is a bit confusing?
>>>>>
>>>>> Yeah naming isn't that great, I can see how that's bit confusing. 
>>>>> I'll
>>>>> be happy to take suggestions on what would make it clearer.
>>>>
>>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>>> shouldn't improve performance by doing so because these OPs are 
>>>> supposed
>>>> to be slow and always slept, not like others(buffered writes, ...),
>>>> can you provide one hint about not offloading these OPs? Or is it 
>>>> just that
>>>> NO_OFFLOAD needs to not offload every OPs?
>>>
>>> The whole point of NO_OFFLOAD is that items that would normally be
>>> passed to io-wq are just run inline. This provides a way to reap the
>>> benefits of batched submissions and syscall reductions. Some opcodes
>>> will just never be async, and io-wq offloads are not very fast. Some of
>>
>> Yeah, seems io-wq is much slower than inline issue, maybe it needs
>> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
>
> There were attempts like this one from Hao (CC'ed)
>
> https://lore.kernel.org/io-uring/20220627133541.15223-5-hao.xu@linux.dev/t/ 
>
>
> Not sure why it got stalled, but maybe Hao would be willing
> to pick it up again.


Hi folks, I'd like to pick it up again, but I just didn't get any reply 
at that time after sending

several versions of it...so before I restart that series, I'd like to 
ask Jens to comment the idea

of that patchset (fixed worker).


Thanks,

Hao


