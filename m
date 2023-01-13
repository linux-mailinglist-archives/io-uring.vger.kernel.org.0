Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7666A185
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 19:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjAMSHb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 13:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjAMSHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 13:07:09 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195B54DB7
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 10:01:54 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id h26so11115765ila.11
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 10:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ovpbMbVDbRpC97Koh7MjXepJZhjdynAFk90KU4IEsBw=;
        b=MUe86TjtvBPvfT0wshGnlFdI4m0YFeKLPiqa+P83WyHzD5IGTBEfy6lsj2yz0+H8UD
         F54589YCEDHTUDyEWEt7Ry7heCc2Ha0vEtXK3/OS61ha7GMLZcyQGvQ/M+f5KhEcnpeh
         8LwS+3Pnuwo/os25Pj6fFKkASkXCHZcY+7HJcpjppqzUDzNQbP2xwG6OaBtUCfZsnrtL
         VEE2tMQ8VUFkJU1xpw0XipsTQgdeXLjBX6p7lQ+6WUXDZMaPPChuJo8yY3GO0M9aE9LZ
         dxhwD8RDEZGTOwRcgypr4lcdU0CHeGa01mNdikmpS97DsFbkTSyQnlF40yJ8YwD0Iydx
         +meQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovpbMbVDbRpC97Koh7MjXepJZhjdynAFk90KU4IEsBw=;
        b=SjaiwP5jBAKhUM6is8x6QZFe/XaTRj8Gl0Ci8GYl628DZN5uIakiIam0lugeZtQ4Vc
         q0iZn/Ft3qq5XDNOXptmp0hj58vcC50skt+rx3xTyGLtbfDGxROSbbyYc8YDAFbaMoro
         6IZZVFiHG0bQ+Nl6BBYucYe0mJxwdi17bL3ZP5AS+g1KturGMJTAecHfwbbRC4ZdaLuL
         u6X8tl16US7G1S5q9je2skDi45/pabjHEQ8rWpZ632NqgwdnWrgwSndpUWUFLzlotTx0
         phVPke98pf5NZpduvDSgEQIkmCYJXydZ4Qy3GggHi7fwp5BQw8JO5EnWrlcVtfmyvkYm
         NWtg==
X-Gm-Message-State: AFqh2ko6h7Zm9Ibr7KECSGaN7YmS0OUoeYtw8xtfcm4ERFeDTw6qWYT/
        ohf8YWQddD38IRRUzpdjGW3dvA5fpN8UHEsR
X-Google-Smtp-Source: AMrXdXuPE8QMbIk3GCQ4e6FzNmKLSYDrmk9kd3wFUgB7pdtjTg1qo6LUAtvKOW/geSPe2dybrxvf8w==
X-Received: by 2002:a05:6e02:d4b:b0:30b:f1dc:4d6 with SMTP id h11-20020a056e020d4b00b0030bf1dc04d6mr10104286ilj.3.1673632913837;
        Fri, 13 Jan 2023 10:01:53 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z9-20020a92da09000000b0030da09e3bd0sm4762969ilm.50.2023.01.13.10.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 10:01:53 -0800 (PST)
Message-ID: <6e237718-e09b-03ca-bd23-de94cdefa7fc@kernel.dk>
Date:   Fri, 13 Jan 2023 11:01:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org> <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
 <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org> <Y8EuhoodlKFGh/55@T590>
 <e222ff73-9f0d-649b-a0a4-211d7cbb5514@kernel.dk>
In-Reply-To: <e222ff73-9f0d-649b-a0a4-211d7cbb5514@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/13/23 10:51 AM, Jens Axboe wrote:
> On 1/13/23 3:12 AM, Ming Lei wrote:
>> Hello,
>>
>> On Thu, Jan 12, 2023 at 08:35:36AM +0100, Stefan Metzmacher wrote:
>>> Am 12.01.23 um 04:40 schrieb Jens Axboe:
>>>> On 1/11/23 8:27?PM, Ming Lei wrote:
>>>>> Hi Stefan and Jens,
>>>>>
>>>>> Thanks for the help.
>>>>>
>>>>> BTW, the issue is observed when I write ublk-nbd:
>>>>>
>>>>> https://github.com/ming1/ubdsrv/commits/nbd
>>>>>
>>>>> and it isn't completed yet(multiple send sqe chains not serialized
>>>>> yet), the issue is triggered when writing big chunk data to ublk-nbd.
>>>>
>>>> Gotcha
>>>>
>>>>> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
>>>>>> Hi Ming,
>>>>>>
>>>>>>> Per my understanding, a short send on SOCK_STREAM should terminate the
>>>>>>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>>>>>>
>>>>>>> But from my observation, this point isn't true when using io_sendmsg or
>>>>>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>>>>>>> can be completed after one short send is found. MSG_WAITALL is off.
>>>>>>
>>>>>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
>>>>>> in order to a retry or an error on a short write...
>>>>>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
>>>>>
>>>>> Turns out there is another application bug in which recv sqe may cut in the
>>>>> send sqe chain.
>>>>>
>>>>> After the issue is fixed, if MSG_WAITALL is set, short send can't be
>>>>> observed any more. But if MSG_WAITALL isn't set, short send can be
>>>>> observed and the send io chain still won't be terminated.
>>>>
>>>> Right, if MSG_WAITALL is set, then the whole thing will be written. If
>>>> we get a short send, it's retried appropriately. Unless an error occurs,
>>>> it should send the whole thing.
>>>>
>>>>> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
>>>>> of short send, and application needn't to take care of it?
>>>
>>> With new kernels yes, but the application should be prepared to have retry
>>> logic in order to be compatible with older kernels.
>>
>> Now ublk-nbd can be played, mkfs/mount and fio starts to work.
>>
>> But short send still can be observed sometimes when sending nbd write
>> request, which is done by sendmsg(), and the message includes two vectors,
>> (the 1st is the nbd_request, another one is the data to be written to disk).
>>
>> Short send is reported by cqe in which cqe->res is always 28, which is
>> size of 'struct nbd_request', also the length of the 1st io vec. And not
>> see send cqe failure message.
>>
>> And MSG_WAITALL is set for all ublk-nbd io actually.
>>
>> Follows the steps:
>>
>> 1) install liburing 2.0+
>>
>> 2) build ublk & reproduce the issue:
>>
>> - git clone https://github.com/ming1/ubdsrv.git -b nbd
>>
>> - cd ubdsrv
>>
>> - vim build_with_liburing_src && set LIBURING_DIR to your liburing dir
>>
>> - ./build_with_liburing_src&& make -j4
>>
>> 3) run the nbd test
>> - cd ubdsrv
>> - make test T=nbd
>>
>> Sometimes the test hangs, and the following log can be observed
>> in syslog:
>>
>> nbd_send_req_done: short send/receive tag 2 op 1 8000000000800002, len 524316 written 28 cqe flags 0
>> ...
>>
> 
> I can reproduce this, but it's a SEND that ends up being triggered,
> not a SENDMSG. Should the payload carrying op not be a SENDMSG? I'm
> assuming two vecs for that one.

Added some debug and it looks like the request was indeed send up
and is using IORING_OP_SEND and that the 28 is what was requested.
But the completion side seems to think it's a SENDMSG and we should've
received more?

I think this needs a bit of debugging on the userspace side first.

-- 
Jens Axboe


