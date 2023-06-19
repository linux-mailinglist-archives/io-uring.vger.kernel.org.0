Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2617A735881
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 15:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjFSN1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 09:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjFSN1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 09:27:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA5E1AC
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 06:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=SilJzCr8lZgu51FPgpQTlpHQ7VDk1Ui3zYZUpoYiFWo=; b=Z8uQRZhaoFNtU3FhJm5ni5bSW7
        3VsONMNe55cM9viqowtllAOkJXvIigXI2IVvWgWaKOP8c+SSc7U9YPbPEI76PhAGzEDB03VASRB+w
        RIZxSIj/ExX9AuV4VY0F2jTQ+su2D7eQIs4lKHW+BS5WJr1s0dqnDfNXDg/I876YLS1PU0RQcJSIr
        6a0gNy9pKlq3HmCcsBEcn5CI/jXdkO154U30JVtpsD71k5GOG3Urh3KOOlt/jQoAmtiTSfUu6wklk
        GCQHsFRfwYsvN/TLy/2lV3RfKJzeQ1wedbT3zx7wyAnf6jNV1GivQEzNhKciHCQPKlaXz/m5A1W7L
        nEN19+0ahqbLCT0f7VC7J2DSd6BQC3MfMC4DY5rUkh1Tanm3iYPGFn9bSuapPFTVgUiguFGeXT1oR
        nKz9h/kZ2HoCF4VkQQ1OUPAbUEkoo6aNDtK4Dy6xFuKWQkbJPDqrpkOD3ZmyccLY7ha3zyBeRG1lB
        ohZMUEGwuwYjkL/F+vR3icx8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBEuX-0032zJ-0L;
        Mon, 19 Jun 2023 13:27:14 +0000
Message-ID: <ead9cb99-1143-c3f3-bd7a-6d376ff7a802@samba.org>
Date:   Mon, 19 Jun 2023 15:27:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: save msghdr->msg_control for retries
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
 <b104c37a-a605-e3c8-67ab-45f27e158e21@samba.org>
 <d98ebddb-89b9-e0d2-8390-69a3ab53b985@kernel.dk>
 <10d83431-656f-a70a-de4a-efe32af0d324@samba.org>
In-Reply-To: <10d83431-656f-a70a-de4a-efe32af0d324@samba.org>
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

Am 19.06.23 um 15:09 schrieb Stefan Metzmacher:
> Am 19.06.23 um 15:05 schrieb Jens Axboe:
>> On 6/19/23 3:57?AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>>> If the application sets ->msg_control and we have to later retry this
>>>> command, or if it got queued with IOSQE_ASYNC to begin with, then we
>>>> need to retain the original msg_control value. This is due to the net
>>>> stack overwriting this field with an in-kernel pointer, to copy it
>>>> in. Hitting that path for the second time will now fail the copy from
>>>> user, as it's attempting to copy from a non-user address.
>>>
>>> I'm not 100% sure about the impact of this change.
>>>
>>> But I think the logic we need is that only the
>>> first __sys_sendmsg_sock() that returns > 0 should
>>> see msg_control. A retry because of MSG_WAITALL should
>>> clear msg_control[len] for a follow up __sys_sendmsg_sock().
>>> And I fear the patch below would not clear it...
>>>
>>> Otherwise the receiver/socket-layer will get the same msg_control twice,
>>> which is unexpected.
>>
>> Yes agree, if we do transfer some (but not all) data and WAITALL is set,
>> it should get cleared. I'll post a patch for that.
> 
> Thanks!
> 
>> Note that it was also broken before, just differently broken. The most
>> likely outcome here was a full retry and now getting -EFAULT.
> 
> Yes, I can see that it was broken before...

I haven't checked myself, but I'm wondering about the recvmsg case,
I guess we would need to advance the msg_control buffer after each
iteration, in order to avoid overwritting the already received messages
on retry.

This all gets complicated with things like MSG_CTRUNC.

I guess it's too late to reject MSG_WAITALL together with msg_control
for io_recvmsg() because of compat reasons,
but as MSG_WAITALL is also processed in the socket layer, we could keep it
simple for now and skip the this retry logic:

         if (flags & MSG_WAITALL)
                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);

This might become something similar to this,
but likely more complex, as would need to record kmsg->controllen == 0
condition already in io_recvmsg_prep:

         if (flags & MSG_WAITALL && kmsg->controllen == 0)
                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);


metze
