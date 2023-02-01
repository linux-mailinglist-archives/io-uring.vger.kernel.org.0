Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C07686FA8
	for <lists+io-uring@lfdr.de>; Wed,  1 Feb 2023 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBAUau (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Feb 2023 15:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjBAU3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Feb 2023 15:29:53 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5239E113FD
        for <io-uring@vger.kernel.org>; Wed,  1 Feb 2023 12:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=vBnL5Y63rlW78r0QrCkOj0z1ZMt1mgBJW4rR/cKmT3s=; b=qgMJZfi1Qqnv8m28cUd0YG3HXP
        i9YUw9x5iMKpFjDxjFG7Le701xm/XbGQRtUrdtOqjdck6kKMOg/OR+UHIp/ZbQZvazkKXErVuHAzH
        PlQwrHX6DBGUFd12GQ9KZ4jkghyt8S+Oa9Ts8Jf30lqDTvEzKb/XJxPm3XfVMd/6cx2230ussknYK
        ZYCx1Gjt50mL1Ahom7S4EAPaLx+uL1R4cjgZeReeTLPtyAElXCqb2eEwyWu+kGvfuD1WnKezsMSU4
        7OdbZaULnvLYBLkwaaBWzLIc/jSMhzqR55NxgRIBb5cYkprI5G4Xy+4ciEQWbWCXGX7Uouu8J8WOk
        VATzMDZdY6LDfuLL4nOl37ZFE24BnKsMjhQ2y0xAjfxzUpiV2GM/M62NiSJBfHF5kHpq2LXaC0UWm
        nkBiw3Mw5N3pF0C4ArsQ4DgcQNTQP3YljLwofzRkfB6HmE45TG/EbGu4pT9H6UR9Utm3Q5PD1N9kZ
        TCGrudMRDG3Nff4wOzRcnU39;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNJjq-00BHXS-7U; Wed, 01 Feb 2023 20:29:50 +0000
Message-ID: <1b033b5c-3bab-0831-d642-50cce9905b2a@samba.org>
Date:   Wed, 1 Feb 2023 21:29:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Samba Technical <samba-technical@lists.samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <2a9e4484-4025-2806-89c3-51c590cfd176@samba.org>
 <60ce8938-77ed-0b43-0852-7895140c3553@samba.org>
 <79b3e423-16aa-48f1-ee27-a198c2db2ba8@samba.org>
 <b3cbaa88-9b01-e82f-bcfa-2fccc69b37c4@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b3cbaa88-9b01-e82f-bcfa-2fccc69b37c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>> any change to get some feedback on these?
>> https://lore.kernel.org/io-uring/60ce8938-77ed-0b43-0852-7895140c3553@samba.org/
>> and
>> https://lore.kernel.org/io-uring/c9a5b180-322c-1eb6-2392-df9370aeb45c@samba.org/
>>
>> Thanks in advance!
> 
> Finally getting around to this after the break...
> 
> I think your initial patch looks reasonable for doing cancel-on-close.
> Can you resubmit it against for-6.3/io_uring so we can get it moving
> forward, hopefully?
> 
> That would also be a good point to discuss the fixed file case as well,
> as ideally this should obviously work on both types.

I rebased on for-6.3/io_uring from over a week ago:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/oem-6.X-metze

root@ub1704-167:~/samba.git# uname -a
Linux ub1704-167 6.2.0-rc5-metze.01-00809-g3ffcd1640c8d #1 SMP PREEMPT_DYNAMIC Mon Jan 23 22:56:13 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

I modified the test a bit in order to only test fd events (without signal events),
with this samba code:
https://git.samba.org/?p=metze/samba/wip.git;a=shortlog;h=refs/heads/master-io-uring-native-ops
https://git.samba.org/?p=metze/samba/wip.git;a=shortlog;h=0ddfc6ac8f0bf7c33d0e273b45d9df1951b6452b

It shows that the epoll backend is still the fasted, see below.
I know that the samba_io_uring_ev_native is not really optimized in userspace,
but I fear the limiting factor is the need to re-issue IORING_OP_POLL_ADD
after each completion.

Having IORING_POLL_ADD_MULTI together with a working IORING_POLL_ADD_LEVEL,
might provide something that would be faster than the epoll backend,
but that would mean we would need to maintain a ready list and
issue only a limited amount of completions from the ready list
per io_uring_enter() in order to avoid overflowing the completion queue.
But I'm not sure how to implement that myself...

So IORING_POLL_CANCEL_ON_CLOSE is sadly not enough to be useful for me,
do you think I should submit it anyway even if it's unclear if samba will make use of it
any time soon?

metze

root@ub1704-167:~/samba.git# time bin/smbtorture //a/b local.event.samba_io_uring_ev_native.context
smbtorture 4.19.0pre1-DEVELOPERBUILD
Using seed 1675281295
time: 2023-02-01 19:54:55.272582
test: context
time: 2023-02-01 19:54:55.275092
backend 'samba_io_uring_ev_native' - test_event_context
Got 1000000.00 pipe events
Got 295844.07 pipe events/sec
time: 2023-02-01 19:54:58.655572
success: context

real    0m3,472s
user    0m1,861s
sys     0m1,609s

root@ub1704-167:~/samba.git# time bin/smbtorture //a/b local.event.epoll.context
smbtorture 4.19.0pre1-DEVELOPERBUILD
Using seed 1675281298
time: 2023-02-01 19:54:58.739744
test: context
time: 2023-02-01 19:54:58.741575
backend 'epoll' - test_event_context
Got 1000000.00 pipe events
Got 326759.90 pipe events/sec
time: 2023-02-01 19:55:01.802051
success: context

real    0m3,147s
user    0m1,926s
sys     0m1,218s

root@ub1704-167:~/samba.git# time bin/smbtorture //a/b local.event.poll.context
smbtorture 4.19.0pre1-DEVELOPERBUILD
Using seed 1675281930
time: 2023-02-01 20:05:30.685121
test: context
time: 2023-02-01 20:05:30.686870
backend 'poll' - test_event_context
Got 1000000.00 pipe events
Got 275666.78 pipe events/sec
time: 2023-02-01 20:05:34.314512
success: context

real    0m3,713s
user    0m1,799s
sys     0m1,911s


