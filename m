Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7379566A14D
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 18:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjAMR6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 12:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAMR6B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 12:58:01 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA4D6C075
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 09:51:22 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e129so10803933iof.3
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 09:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ZUFLvYR5Yp55WzRP1o4A9CluuOB9fmxe57NVyiNRjA=;
        b=Cl465fvUWqUeaTSVOh2w5xg91cJr+qKDb3k2Wt+ZmRCF6300h8uZncpeZgrJVoMQWM
         veBnjyPzBhYn/nmwYg/tX+u87KpfFZ78biiCAMGsShItXCxrz0NC4vV879qZeE9CflVl
         4hzf7KNa10+NFWxjUUf2AwjlUEXZ92CBcmw6bxnCNYPrMAkVKMdd+F7HqLzV0rh0+zsd
         A/e7C8aNIeyO790DlyY6TlF+5aR5LGm3Huo6gfmn682DlQuATjjzFZQeBJnN7GKlQR0U
         SOnX1AGd+2y3Xeu0Mgsat0gx4+9oMGSTozLJJNlGFidW/djSr04t91CJgKfOeM/vrLRF
         jiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZUFLvYR5Yp55WzRP1o4A9CluuOB9fmxe57NVyiNRjA=;
        b=YlOJhYOaXzeAzhSf4ph2ZMnlsGSycpPymEVh7/NGn+GYs9WtoGtzyJTPDoUoZNKTvV
         22g1W92srvBxK0wU+rKQZer6BSNSPhypQFIi9QzZLwIbdY4FrNshbsNJJtMYm+UPGqdh
         elM4hV0UwS0k2Ir+Zj8bAYwTmkepBkPRRPhYmpfwpfyqlbf79zFC2CnlXmpaORIws2Yu
         qWoS34vXttWC/XcxbW0KHo+GI4V05SSGXWPTOgXpyGK1UG24VhMeY90zWkheJvstoMIt
         aS6DzZjvy5ImzHfIA2c752P3RaD8wY39izFVoPt16+3cT7b/8zWo/QfJCppD0dlhau3l
         TlHg==
X-Gm-Message-State: AFqh2kq6MBFVn6mNbKLhS8j88JqQJRCOI88IMOqzWxSEogylR3X+0dHM
        TyqjVBhuIMM117MvPDn7v8YOMQ==
X-Google-Smtp-Source: AMrXdXsBTYa+1kumP71af4x4s/ueHgHID/3aiAWpz0gaGIIsN3xTGFtGF1Cl51TSfbnDHwJwmOSxVA==
X-Received: by 2002:a05:6602:1cf:b0:6ed:95f:92e7 with SMTP id w15-20020a05660201cf00b006ed095f92e7mr9523426iot.0.1673632281944;
        Fri, 13 Jan 2023 09:51:21 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g187-20020a025bc4000000b00389e9e6112csm6314430jab.70.2023.01.13.09.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 09:51:21 -0800 (PST)
Message-ID: <e222ff73-9f0d-649b-a0a4-211d7cbb5514@kernel.dk>
Date:   Fri, 13 Jan 2023 10:51:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
To:     Ming Lei <ming.lei@redhat.com>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org> <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
 <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org> <Y8EuhoodlKFGh/55@T590>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y8EuhoodlKFGh/55@T590>
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

On 1/13/23 3:12 AM, Ming Lei wrote:
> Hello,
> 
> On Thu, Jan 12, 2023 at 08:35:36AM +0100, Stefan Metzmacher wrote:
>> Am 12.01.23 um 04:40 schrieb Jens Axboe:
>>> On 1/11/23 8:27?PM, Ming Lei wrote:
>>>> Hi Stefan and Jens,
>>>>
>>>> Thanks for the help.
>>>>
>>>> BTW, the issue is observed when I write ublk-nbd:
>>>>
>>>> https://github.com/ming1/ubdsrv/commits/nbd
>>>>
>>>> and it isn't completed yet(multiple send sqe chains not serialized
>>>> yet), the issue is triggered when writing big chunk data to ublk-nbd.
>>>
>>> Gotcha
>>>
>>>> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
>>>>> Hi Ming,
>>>>>
>>>>>> Per my understanding, a short send on SOCK_STREAM should terminate the
>>>>>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>>>>>
>>>>>> But from my observation, this point isn't true when using io_sendmsg or
>>>>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>>>>>> can be completed after one short send is found. MSG_WAITALL is off.
>>>>>
>>>>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
>>>>> in order to a retry or an error on a short write...
>>>>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
>>>>
>>>> Turns out there is another application bug in which recv sqe may cut in the
>>>> send sqe chain.
>>>>
>>>> After the issue is fixed, if MSG_WAITALL is set, short send can't be
>>>> observed any more. But if MSG_WAITALL isn't set, short send can be
>>>> observed and the send io chain still won't be terminated.
>>>
>>> Right, if MSG_WAITALL is set, then the whole thing will be written. If
>>> we get a short send, it's retried appropriately. Unless an error occurs,
>>> it should send the whole thing.
>>>
>>>> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
>>>> of short send, and application needn't to take care of it?
>>
>> With new kernels yes, but the application should be prepared to have retry
>> logic in order to be compatible with older kernels.
> 
> Now ublk-nbd can be played, mkfs/mount and fio starts to work.
> 
> But short send still can be observed sometimes when sending nbd write
> request, which is done by sendmsg(), and the message includes two vectors,
> (the 1st is the nbd_request, another one is the data to be written to disk).
> 
> Short send is reported by cqe in which cqe->res is always 28, which is
> size of 'struct nbd_request', also the length of the 1st io vec. And not
> see send cqe failure message.
> 
> And MSG_WAITALL is set for all ublk-nbd io actually.
> 
> Follows the steps:
> 
> 1) install liburing 2.0+
> 
> 2) build ublk & reproduce the issue:
> 
> - git clone https://github.com/ming1/ubdsrv.git -b nbd
> 
> - cd ubdsrv
> 
> - vim build_with_liburing_src && set LIBURING_DIR to your liburing dir
> 
> - ./build_with_liburing_src&& make -j4
> 
> 3) run the nbd test
> - cd ubdsrv
> - make test T=nbd
> 
> Sometimes the test hangs, and the following log can be observed
> in syslog:
> 
> nbd_send_req_done: short send/receive tag 2 op 1 8000000000800002, len 524316 written 28 cqe flags 0
> ...
> 

I can reproduce this, but it's a SEND that ends up being triggered,
not a SENDMSG. Should the payload carrying op not be a SENDMSG? I'm
assuming two vecs for that one.

-- 
Jens Axboe


