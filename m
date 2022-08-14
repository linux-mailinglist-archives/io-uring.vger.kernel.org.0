Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C0F592041
	for <lists+io-uring@lfdr.de>; Sun, 14 Aug 2022 16:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiHNOsJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Aug 2022 10:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiHNOsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Aug 2022 10:48:08 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C2F140C0
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=aOvzu4x8jImTAPL7SY58qT2WH++XnDXWBv8Cfsr9Rw4=; b=EVSiJIsrX7CWBXzLiJQPC9zbkp
        qKaH0baWNl9vKAiwW9lvH8Indbhd+/+UzlCX1Wv+HPmRxU5nAKQBjuxCs2Q19jX7HOI88zM5p6Die
        B/vDWpIDqU1S18J54KKgAKmZujKLUfPsBBvT7DMjpKDV1bc3HIePtw8l/IlMTHG5TIRcLhzBiOrl5
        wz9KvCRvxHBbisAH4zSi8RR7e8J4fuxfqDNn0ZbhgUZ8NrYneMkxUzolgJiH1caYTgcO8LoBi/2vq
        v5lCwnOynpRu9TL0OW417OWzQ54Axd2yEx2p3SmcjJVTNOgQ8oL/HH+/31b4kIyVRnk2RA6Pd8Jqd
        NkHpyJ8ZNOysxoCX3VGcMhpNTWECcpMG/yP/BoLlv7tDuKoKpWbw7yoVxukA6a+LGRQ2dDlXLvMV/
        GLcxuMODaOJYdqlu+BGWtZgRCnCNHcyBxAidzTC2I39TSQBApMKt6A0UIA2cA44AFhnuxFmE1FQTA
        iR4GLnZMT3mvKb/JU/rKEIDM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNEuL-0007E7-77; Sun, 14 Aug 2022 14:48:05 +0000
Message-ID: <6e523a67-96ce-e67e-e07d-3b63a86e5e3f@samba.org>
Date:   Sun, 14 Aug 2022 16:48:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
 <064b4920-5441-1ae2-b492-cb75f7796d8d@samba.org>
 <14283cb1-11b3-2847-4f48-9ea30c48c1bf@kernel.dk>
 <6357d22c-2fcc-ccc9-882c-9ebf83add50d@samba.org>
 <8d91ba5e-5b28-5ec0-b348-7eebd1edf2dd@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 1/1] io_uring/net: send retry for zerocopy
In-Reply-To: <8d91ba5e-5b28-5ec0-b348-7eebd1edf2dd@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 14.08.22 um 16:13 schrieb Jens Axboe:
> On 8/14/22 8:11 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>>>> io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
>>>>> is set, however new zerocopy send is inconsistent in this regard, which
>>>>> might be confusing. Handle short sends.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>     io_uring/net.c | 20 +++++++++++++++++---
>>>>>     1 file changed, 17 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>> index 32fc3da04e41..f9f080b3cc1e 100644
>>>>> --- a/io_uring/net.c
>>>>> +++ b/io_uring/net.c
>>>>> @@ -70,6 +70,7 @@ struct io_sendzc {
>>>>>         unsigned            flags;
>>>>>         unsigned            addr_len;
>>>>>         void __user            *addr;
>>>>> +    size_t                done_io;
>>>>>     };
>>>>>       #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
>>>>> @@ -878,6 +879,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>           zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>>>>         zc->addr_len = READ_ONCE(sqe->addr_len);
>>>>> +    zc->done_io = 0;
>>>>>       #ifdef CONFIG_COMPAT
>>>>>         if (req->ctx->compat)
>>>>> @@ -1012,11 +1014,23 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>>>>         if (unlikely(ret < min_ret)) {
>>>>>             if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>>>>>                 return -EAGAIN;
>>>>> -        return ret == -ERESTARTSYS ? -EINTR : ret;
>>>>> +        if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
>>>>> +            zc->len -= ret;
>>>>> +            zc->buf += ret;
>>>>> +            zc->done_io += ret;
>>>>> +            req->flags |= REQ_F_PARTIAL_IO;
>>>>
>>>> Don't we need a prep_async function and/or something like
>>>> io_setup_async_msg() here to handle address?
>>>
>>> I don't think so, it's a non-vectored interface, so all the state is
>>> already in io_sendzc.
>>
>> This has support for sockaddr address compared to io_send(),
>> if the caller need to keep io_sendzc->addr valid until the qce arrived,
>> then we need to clearly document that, as that doesn't match the common practice
>> of other opcodes. Currently everything but data buffers can go after the sqe is
>> submitted.
> 
> Good point, it's not just the 'from' address. Pavel?

It's basically dest_addr from:

        ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
                       const struct sockaddr *dest_addr, socklen_t addrlen);

It's not used in most cases, but for non-connected udp sockets you need it.

Maybe the fixed io_op_def.async_size could be changed to something that only
allocated the async data if needed. Maybe the prep_async() hook could to the allocation
itself if needed.

metze
