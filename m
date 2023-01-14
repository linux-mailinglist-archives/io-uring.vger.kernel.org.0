Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F193F66A905
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 04:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjANDr2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 22:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjANDrZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 22:47:25 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CADBA461
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 19:47:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s67so16216562pgs.3
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 19:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mlVWNkvXH8V5N3aYVaLKlgaqMp0Dx24r6VM67jMVe0c=;
        b=dLHx9LsO00hMLMENuTBpWogS7EJT4kFFJacpEpJfeiZTPLia/8/HRjQEBo1SJL8Orw
         cLmWQ4hoqL+0r//+q/UVqEIqocI9Cm0kDp233kD3Mhmn1gdFIvLIwD1Ey9xKNzxzvJAh
         cyqNhqJk2s6IoWtQpypZbn1ElRHAM9NkGRyvLUCBhPeWVMLj1OvmMkWUT/p4FhkPxeeV
         KIYiuxBApl3U+Ik1Lg7FbuKb6CGc2xrBO7xTIH20eOtLt2y82jfu7m9CWGT4rGjATwus
         jQHhsVkkMY8oCLQD30mkqyuJT9ppeos8B+18khhn2H0Qre2HA7m3RqLvWTIyeTr3g5M6
         wkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mlVWNkvXH8V5N3aYVaLKlgaqMp0Dx24r6VM67jMVe0c=;
        b=TAYhEVVBSbX1ImPmecxEdjDN+Jd/VPFFtdgmdMjWZodtH15Zyq5bvfyVyapGtksGBL
         tXAHpzw/2Po3iOYIYxItORp4j7jeGqmBkqIs3KtOLnnFIkW0k/p0GCNa/hmf2adAtb9R
         565kNEP60lJ9PTroFs/qBKeXWbruIJK8lxUAFXJoiSUMh7Ahy4wNbqoN5/7pq1qTkSGl
         4quTtG+O8m48iiKnv4g5dNWNllhWxKOVGCvWKpXZ7Udx85Hw2Rhnigbc+lYqolt2cJHU
         f8r45ieEuJAzprwsllwII48d5VrE+ZG+zqdEE4yBTk4UOChp4eVGWKWwqTuOAScWPf7/
         gEQw==
X-Gm-Message-State: AFqh2ko1h/vBcxe5H0h+ZOl0gCHydBQcQjHoU+MuP48blYLJ11v1o5Ub
        0zHSupOzR5Rv5O7rDiOOf97pdw==
X-Google-Smtp-Source: AMrXdXuxt/o7OYAblzGaswfmMjUQCL3YvmwIihqMKN8CyfjPOjZi+lj4oXLzsQZmW1DKqmqNdpkkDQ==
X-Received: by 2002:a62:190d:0:b0:587:4621:9645 with SMTP id 13-20020a62190d000000b0058746219645mr5760421pfz.1.1673668043767;
        Fri, 13 Jan 2023 19:47:23 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y22-20020a626416000000b0058bc745026csm317486pfb.97.2023.01.13.19.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 19:47:23 -0800 (PST)
Message-ID: <61a5e391-4e87-7690-0fa8-9620928da351@kernel.dk>
Date:   Fri, 13 Jan 2023 20:47:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org> <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
 <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org> <Y8EuhoodlKFGh/55@T590>
 <e222ff73-9f0d-649b-a0a4-211d7cbb5514@kernel.dk>
 <6e237718-e09b-03ca-bd23-de94cdefa7fc@kernel.dk> <Y8H2+RaejnVtiMQY@T590>
 <Y8IPl3PsdAlAfvkq@T590>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8IPl3PsdAlAfvkq@T590>
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

On 1/13/23 7:12?PM, Ming Lei wrote:
> On Sat, Jan 14, 2023 at 08:27:37AM +0800, Ming Lei wrote:
>> On Fri, Jan 13, 2023 at 11:01:51AM -0700, Jens Axboe wrote:
>>> On 1/13/23 10:51?AM, Jens Axboe wrote:
>>>> On 1/13/23 3:12?AM, Ming Lei wrote:
>>>>> Hello,
>>>>>
>>>>> On Thu, Jan 12, 2023 at 08:35:36AM +0100, Stefan Metzmacher wrote:
>>>>>> Am 12.01.23 um 04:40 schrieb Jens Axboe:
>>>>>>> On 1/11/23 8:27?PM, Ming Lei wrote:
>>>>>>>> Hi Stefan and Jens,
>>>>>>>>
>>>>>>>> Thanks for the help.
>>>>>>>>
>>>>>>>> BTW, the issue is observed when I write ublk-nbd:
>>>>>>>>
>>>>>>>> https://github.com/ming1/ubdsrv/commits/nbd
>>>>>>>>
>>>>>>>> and it isn't completed yet(multiple send sqe chains not serialized
>>>>>>>> yet), the issue is triggered when writing big chunk data to ublk-nbd.
>>>>>>>
>>>>>>> Gotcha
>>>>>>>
>>>>>>>> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
>>>>>>>>> Hi Ming,
>>>>>>>>>
>>>>>>>>>> Per my understanding, a short send on SOCK_STREAM should terminate the
>>>>>>>>>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>>>>>>>>>
>>>>>>>>>> But from my observation, this point isn't true when using io_sendmsg or
>>>>>>>>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>>>>>>>>>> can be completed after one short send is found. MSG_WAITALL is off.
>>>>>>>>>
>>>>>>>>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
>>>>>>>>> in order to a retry or an error on a short write...
>>>>>>>>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
>>>>>>>>
>>>>>>>> Turns out there is another application bug in which recv sqe may cut in the
>>>>>>>> send sqe chain.
>>>>>>>>
>>>>>>>> After the issue is fixed, if MSG_WAITALL is set, short send can't be
>>>>>>>> observed any more. But if MSG_WAITALL isn't set, short send can be
>>>>>>>> observed and the send io chain still won't be terminated.
>>>>>>>
>>>>>>> Right, if MSG_WAITALL is set, then the whole thing will be written. If
>>>>>>> we get a short send, it's retried appropriately. Unless an error occurs,
>>>>>>> it should send the whole thing.
>>>>>>>
>>>>>>>> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
>>>>>>>> of short send, and application needn't to take care of it?
>>>>>>
>>>>>> With new kernels yes, but the application should be prepared to have retry
>>>>>> logic in order to be compatible with older kernels.
>>>>>
>>>>> Now ublk-nbd can be played, mkfs/mount and fio starts to work.
>>>>>
>>>>> But short send still can be observed sometimes when sending nbd write
>>>>> request, which is done by sendmsg(), and the message includes two vectors,
>>>>> (the 1st is the nbd_request, another one is the data to be written to disk).
>>>>>
>>>>> Short send is reported by cqe in which cqe->res is always 28, which is
>>>>> size of 'struct nbd_request', also the length of the 1st io vec. And not
>>>>> see send cqe failure message.
>>>>>
>>>>> And MSG_WAITALL is set for all ublk-nbd io actually.
>>>>>
>>>>> Follows the steps:
>>>>>
>>>>> 1) install liburing 2.0+
>>>>>
>>>>> 2) build ublk & reproduce the issue:
>>>>>
>>>>> - git clone https://github.com/ming1/ubdsrv.git -b nbd
>>>>>
>>>>> - cd ubdsrv
>>>>>
>>>>> - vim build_with_liburing_src && set LIBURING_DIR to your liburing dir
>>>>>
>>>>> - ./build_with_liburing_src&& make -j4
>>>>>
>>>>> 3) run the nbd test
>>>>> - cd ubdsrv
>>>>> - make test T=nbd
>>>>>
>>>>> Sometimes the test hangs, and the following log can be observed
>>>>> in syslog:
>>>>>
>>>>> nbd_send_req_done: short send/receive tag 2 op 1 8000000000800002, len 524316 written 28 cqe flags 0
>>>>> ...
>>>>>
>>>>
>>>> I can reproduce this, but it's a SEND that ends up being triggered,
>>>> not a SENDMSG. Should the payload carrying op not be a SENDMSG? I'm
>>>> assuming two vecs for that one.
>>>
>>> Added some debug and it looks like the request was indeed send up
>>> and is using IORING_OP_SEND and that the 28 is what was requested.
>>> But the completion side seems to think it's a SENDMSG and we should've
>>> received more?
>>>
>>> I think this needs a bit of debugging on the userspace side first.
>>
>> Yeah, turns out it is indeed one userspace bug, IOSQE_IO_LINK is cleared
>> wrong, and now the issue can't be triggered with the following fix:
>>
>> https://github.com/ming1/ubdsrv/commit/175ffd14ae2f8fa562134edfd4ac949f8050c108
> 
> Figured out, it is still one userspace issue.
> 
> For nbd request sent to server, the cqe could come after the
> ublk io request is completed which is triggered by nbd reply
> from server, then if new ublk io req is submitted to same slot, the
> new data length and op code could be read in nbd_send_req_done(),
> and the warning is triggered.

Figured it was some kind of data reuse issue, as it is consistent with
that. Glad you got it figured out.

-- 
Jens Axboe

