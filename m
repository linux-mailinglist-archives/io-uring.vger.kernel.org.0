Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D278666BAB
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 08:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbjALHgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 02:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbjALHgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 02:36:11 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156ACB89
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 23:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Z6vUM3uGQnC35OZDmMXhZ+yMxnfkJ5FsJw+rGd+S94M=; b=KH6Zl/3yGJ2hAksvBxOOcYermN
        4vGO/iTf2N9SR3vBUzzOrickg7NtefRV68esi1zdLDpVxV6TGunbon+MEVK/6MK5+UV6Jj7GBCBof
        fWgw0Q0NDrp2RHOfhJTuczpg8NvifePIV9Oxf6OUeMxxBBdakF06EjtU0Z4xxCP2ZuZ/iOHlPWtOh
        Z0LQ8DAXvVsDJUIOlfrQeT0tRAzpSAY3pSVgNYmvBCVGuhDEH72knqB7P/W9lXkxzCOda6TBaKuoF
        GZEQY0L0XXoFRHcH07QM3kr4gxE765vzdy8hdN+3ZWCHsMaeqdZSdLg3SvLBx6CLBZPHN7DmJTaRE
        tLCFBQCcFOgWQpfyaO/T3ElBJi5ShEs6z/7Cr3M7R45mXHlPcKeasuKXBzRqIpN28O9xP5V6J5/Wz
        yg1znBde42tHdALrUKwwp08Ah2ItpcLV1Ump1ufVPkUbBqokrNA2nYGHoPHEF0DkBrToYak4P+s+2
        q+E1Bu6ggbzzVnq0VxTO3TY+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pFs84-007rd9-Aw; Thu, 12 Jan 2023 07:36:06 +0000
Message-ID: <9eca9d42-e8ab-3e2b-888a-cd41722cce7a@samba.org>
Date:   Thu, 12 Jan 2023 08:35:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org> <Y79+P4EyU1O0bJPh@T590>
 <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 12.01.23 um 04:40 schrieb Jens Axboe:
> On 1/11/23 8:27?PM, Ming Lei wrote:
>> Hi Stefan and Jens,
>>
>> Thanks for the help.
>>
>> BTW, the issue is observed when I write ublk-nbd:
>>
>> https://github.com/ming1/ubdsrv/commits/nbd
>>
>> and it isn't completed yet(multiple send sqe chains not serialized
>> yet), the issue is triggered when writing big chunk data to ublk-nbd.
> 
> Gotcha
> 
>> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
>>> Hi Ming,
>>>
>>>> Per my understanding, a short send on SOCK_STREAM should terminate the
>>>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>>>
>>>> But from my observation, this point isn't true when using io_sendmsg or
>>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>>>> can be completed after one short send is found. MSG_WAITALL is off.
>>>
>>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
>>> in order to a retry or an error on a short write...
>>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
>>
>> Turns out there is another application bug in which recv sqe may cut in the
>> send sqe chain.
>>
>> After the issue is fixed, if MSG_WAITALL is set, short send can't be
>> observed any more. But if MSG_WAITALL isn't set, short send can be
>> observed and the send io chain still won't be terminated.
> 
> Right, if MSG_WAITALL is set, then the whole thing will be written. If
> we get a short send, it's retried appropriately. Unless an error occurs,
> it should send the whole thing.
 >
>> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
>> of short send, and application needn't to take care of it?

With new kernels yes, but the application should be prepared to have retry
logic in order to be compatible with older kernels.

It was added for recv* in 5.18 and send* in 5.19.

The MSG_WAITALL logic for failing links was added with 5.12.
(It was backported to v5.10.28)
As the 5.15 code was backported to v5.10.162, it's safe to assume
it's available with IORING_FEAT_NATIVE_WORKERS.

> Correct. I did add a note about that in the liburing man pages after
> your email earlier:
> 
> https://git.kernel.dk/cgit/liburing/commit/?id=8d056db7c0e58f45f7c474a6627f83270bb8f00e
> 
> since that wasn't documented as far as I can tell.
> 

