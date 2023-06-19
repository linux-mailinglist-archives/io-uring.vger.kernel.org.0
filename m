Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B181B7359D2
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjFSOkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjFSOkB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 10:40:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79792AA
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 07:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=ovUoaEpDXGh1iz1Xey/MARc2xpulgyQpevtNIZ6SLSI=; b=OHMpMBrWCtzZSAMiJ2Ghff0hDo
        yNNEhDbbmQrytag7UwFeX5Eh+r0TBpIFVj1zo7btTrKXx15up8Z3O0fgQuu7DvxzwS4EWkzhzuGGO
        mJKB2CGhJT1lx0BvVNAGmAlc+VnpWW4Phe1Fi6mytkz+wZ6y85ezHmnak/61m4mfudP9HODHxmcsz
        NQwrQd/hK0BEwG6HAGyaCjzHU7/R+jwPs6jhdJAiexWPW17FPdc6lwQ3zQ1gv5M0N+rNm1W71tyWA
        TGpIpX0C+aVtxPMicHGQPg8zHqi6hGLrwPPEC5pIttOrIoF6cmIRMxBTl9Dx9N/DfxMREKU1Y3/lm
        yq+Ly6VeALPhPwc1Q5nLBlkLi2zorxeRRPnKPPgF0JG7/qqa8zYdioniKMq8RNtdIhCglUKurO3xH
        4BOIDGrrU3ygcboGKtUHkiXBP53kokmVvu1h+yc52ekyD3PkY+GMI/G7WTuw7oUF5WazncYC2ajFj
        V4krZBuaohSWuZpkiewjm6e6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBG2w-0033fR-1P;
        Mon, 19 Jun 2023 14:39:58 +0000
Message-ID: <a0be6879-6b8c-ef4e-4416-29dd6a6f03a9@samba.org>
Date:   Mon, 19 Jun 2023 16:40:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
 <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
 <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
 <10d83431-656f-a70a-de4a-efe32af0d324@samba.org>
 <ead9cb99-1143-c3f3-bd7a-6d376ff7a802@samba.org>
 <02ce6357-f28a-56d7-9c22-ffc1dc14f73d@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <02ce6357-f28a-56d7-9c22-ffc1dc14f73d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 19.06.23 um 16:38 schrieb Jens Axboe:
> On 6/19/23 7:27?AM, Stefan Metzmacher wrote:
>> Am 19.06.23 um 15:09 schrieb Stefan Metzmacher:
>>> Am 19.06.23 um 15:05 schrieb Jens Axboe:
>>>> On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
>>>>> Hi Jens,
>>>>>
>>>>>> If the application sets ->msg_control and we have to later retry this
>>>>>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>>>>>> need to retain the original msg_control value. This is due to the net
>>>>>> stack overwriting this field with an in-kernel pointer, to copy it
>>>>>> in. Hitting that path for the second time will now fail the copy from
>>>>>> user, as it's attempting to copy from a non-user address.
>>>>>
>>>>> I'm not 100% sure about the impact of this change.
>>>>>
>>>>> But I think the logic we need is that only the
>>>>> first __sys_sendmsg_sock() that returns > 0 should
>>>>> see msg_control. A retry because of MSG_WAITALL should
>>>>> clear msg_control[len] for a follow up __sys_sendmsg_sock().
>>>>> And I fear the patch below would not clear it...
>>>>>
>>>>> Otherwise the receiver/socket-layer will get the same msg_control twice,
>>>>> which is unexpected.
>>>>
>>>> Yes agree, if we do transfer some (but not all) data and WAITALL is set,
>>>> it should get cleared. I'll post a patch for that.
>>>
>>> Thanks!
>>>
>>>> Note that it was also broken before, just differently broken. The most
>>>> likely outcome here was a full retry and now getting -EFAULT.
>>>
>>> Yes, I can see that it was broken before...
>>
>> I haven't checked myself, but I'm wondering about the recvmsg case,
>> I guess we would need to advance the msg_control buffer after each
>> iteration, in order to avoid overwritting the already received messages
>> on retry.
>>
>> This all gets complicated with things like MSG_CTRUNC.
>>
>> I guess it's too late to reject MSG_WAITALL together with msg_control
>> for io_recvmsg() because of compat reasons,
>> but as MSG_WAITALL is also processed in the socket layer, we could keep it
>> simple for now and skip the this retry logic:
>>
>>          if (flags & MSG_WAITALL)
>>                  min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>>
>> This might become something similar to this,
>> but likely more complex, as would need to record kmsg->controllen == 0
>> condition already in io_recvmsg_prep:
>>
>>          if (flags & MSG_WAITALL && kmsg->controllen == 0)
>>                  min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> 
> Yep agree, I think this is the best way - ensure that once we transfer
> data with cmsg, it's a one-shot kind of deal.
> 
> Do you want to cut a patch for that one?

No, sorry I'm busy with other stuff and not able to to do any testing...

metze

