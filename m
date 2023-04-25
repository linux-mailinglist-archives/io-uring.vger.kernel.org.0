Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915396EE556
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjDYQMS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjDYQMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 12:12:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66876E51
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 09:12:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94f4b911570so906858166b.0
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682439135; x=1685031135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU8aexTJuk3dOtQ+taUU5Phw7vZVHw6GgzOnAi1xio8=;
        b=DYWw8dOAnADSOzAgad08B8DAkTubUnwoQsTlrm7rVacOE+c1FpXFZQwBC3k3go2IGd
         A28yEW6z9cEs7um7LvCmBJ8ITt8kY8ioNzNotf/GQowmkZr9cV/o9ceWYf4Pmp9tlPcE
         4qo31MG5nDBuuZjljoPQzlUWwKMX/yOsDrPLuRIZ10MwxzISDrtMmdXQW1PxUub7yqB/
         3YWS4719gwLUKVAULmO8CMYMeXf3RWVUU6mtdu5NB5RmKUm2jkcMaiwVeJwntYcjtjaa
         ImzAQmGcbXRMyeNBQXfYjGSZ0LBT8fj7QUdLu6UXPLYVuIHY1HKxa9L1DTB/aIRpSeIb
         s7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682439135; x=1685031135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tU8aexTJuk3dOtQ+taUU5Phw7vZVHw6GgzOnAi1xio8=;
        b=RnutW6ULr7w7Cz9o7X7oiA0a5Q2Ooyl1nzuZ2dmB+2oBFwhNNWdqtdlzAN9SU/GwvR
         JhMPN/lvnUIoVXMQZB49IC0vtMWcz2Oi9/wqB2WEhvM5UsdWSRlAKyWWVv066JsWndFB
         Fl6PeIaIbdCN3/q/4aYxzU1UUpv9w4U7/z48txjuTxstFk7esmCBnr51QlM/NxqX/EH6
         CK20A1PhHzSbenw4EaY2Q8gLTB04goZBjyLmQVxAaeV+Q7mq0w1sL5b6OXtn/w+sfR8T
         VkUEVHAVRUOQgwjHmKKFSdbn2u32MRYRYO+RRCmaKspJ+WJChjLw+UBvI8Xv7TkZIYrd
         SMsQ==
X-Gm-Message-State: AAQBX9dvdSBbvhD7vQwZRfvbc76jtHceWocE6te0Zmxc4pg1N3SXHGR9
        oz2HpqMWNqv54IuJ8MPUFzs=
X-Google-Smtp-Source: AKy350bri6KGZyRaRDpqLQzXQ1TgwDncMtdo24vWqF2pULNxfDGuTATqHpxocHBwH/BEcYJ4XB4yfg==
X-Received: by 2002:a17:906:5a5d:b0:94a:6071:d613 with SMTP id my29-20020a1709065a5d00b0094a6071d613mr15228288ejc.64.1682439134766;
        Tue, 25 Apr 2023 09:12:14 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:7aec])
        by smtp.gmail.com with ESMTPSA id gz19-20020a170907a05300b0095076890fc1sm6945416ejc.1.2023.04.25.09.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 09:12:14 -0700 (PDT)
Message-ID: <8d753778-1033-72ca-d810-141b7d6735a6@gmail.com>
Date:   Tue, 25 Apr 2023 17:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
 <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/23 16:07, Ming Lei wrote:
> On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
>> On 4/25/23 8:42?AM, Ming Lei wrote:
>>> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>>>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>> ---
>>>>>>>>>>>>   io_uring/io_uring.c |  2 +-
>>>>>>>>>>>>   io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>>>   io_uring/opdef.h    |  2 ++
>>>>>>>>>>>>   3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>>>   		return -EBADF;
>>>>>>>>>>>>   
>>>>>>>>>>>>   	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>>>>>   		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>>>
>>>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>>>
>>>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>>>>>> returns if nonblock == true.
>>>>>>>>>
>>>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>>>>>> directly.
>>>>>>>>
>>>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>>>>>> it :-)
>>>>>>>
>>>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>>>>>> ->always_iowq is a bit confusing?
>>>>>>
>>>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>>>>>> be happy to take suggestions on what would make it clearer.
>>>>>
>>>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>>>> shouldn't improve performance by doing so because these OPs are supposed
>>>>> to be slow and always slept, not like others(buffered writes, ...),
>>>>> can you provide one hint about not offloading these OPs? Or is it just that
>>>>> NO_OFFLOAD needs to not offload every OPs?
>>>>
>>>> The whole point of NO_OFFLOAD is that items that would normally be
>>>> passed to io-wq are just run inline. This provides a way to reap the
>>>> benefits of batched submissions and syscall reductions. Some opcodes
>>>> will just never be async, and io-wq offloads are not very fast. Some of
>>>
>>> Yeah, seems io-wq is much slower than inline issue, maybe it needs
>>> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
>>
>> Indeed, depending on what is being linked, you may see io-wq activity
>> which is not ideal.
> 
> That is why I prefer to fused command for ublk zero copy, because the
> registering buffer approach suggested by Pavel and Ziyang has to link
> register buffer OP with the actual IO OP, and it is observed that
> IOPS drops to 1/2 in 4k random io test with registered buffer approach.

What's good about it is that you can use linked requests with it
but you _don't have to_.

Curiously, I just recently compared submitting 8 two-request links
(16 reqs in total) vs submit(8)+submit(8), all that in a loop.
The latter was faster. It wasn't a clean experiment, but shows
that links are not super fast and would be nice to get them better.

For the register buf approach, I tried it out, looked good to me.
It outperforms splice requests (with a hack that removes force
iowq execution) by 5-10% with synthetic benchmark. Works better than
splice(2) for QD>=2. Let me send it out, perhaps today, so we can
figure out how it compares against ublk/fused and see the margin is.

-- 
Pavel Begunkov
