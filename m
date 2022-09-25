Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4A5E92E8
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 14:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiIYMDR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 08:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIYMDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 08:03:15 -0400
Received: from dd11108.kasserver.com (dd11108.kasserver.com [85.13.147.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C1424BDC
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 05:03:13 -0700 (PDT)
Received: from smtpclient.apple (p54876f31.dip0.t-ipconnect.de [84.135.111.49])
        by dd11108.kasserver.com (Postfix) with ESMTPSA id CA5092FC208F;
        Sun, 25 Sep 2022 14:03:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hanne.name;
        s=kas202209201026; t=1664107391;
        bh=RoEjD9lCe+rOkyEZ76YyZEK2jK+3/fvoptYN8tn3C24=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=hH+LD4ZzW0hkUpAYHSWJvf4b8XeUhvU8putOZb46plVrXyTanxpiA/kAof8dnWjhg
         r44TB139SFDS7VXglrlFtRbYyOCa/E3OfXfvvyJv7AYrJv0tlO09u2kDo+SNJNrTyh
         SO1All3J0O3ENQXAsxJbOs/cooJ/Q9SAx/TMSK6XPRcumAupuvZXCQMxxcs9Rombrh
         jYl1SyuIVTvJw10FatrA2FWhCbpCASGERNXNVSJ2ze/TjMPRdS1PnJwzo3cBCIdyqN
         Ozd+2CaOJHUc1O0NX2ZrUe6c2qYI9l4ERx2xL16sL3BQAXvqtGuUy4SXulD5sZsHiO
         GHJ3fZPd7Rtyg==
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Memory ordering description in io_uring.pdf
From:   "J. Hanne" <io_uring@jf.hanne.name>
In-Reply-To: <F05A663E-BA85-40F7-ABA7-5C75B267FE22@jf.hanne.name>
Date:   Sun, 25 Sep 2022 14:03:11 +0200
Cc:     io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <34BFB203-FC7D-45AB-85D2-B6C0B26C57FA@jf.hanne.name>
References: <20220918165616.38AC12FC059D@dd11108.kasserver.com>
 <20adf5fe-98a0-06a0-7058-e6f9ba7d9e2a@kernel.dk>
 <F05A663E-BA85-40F7-ABA7-5C75B267FE22@jf.hanne.name>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

what needs to be brought into an consistent state:
- https://kernel.dk/io_uring.pdf (where is the source??)
- https://git.kernel.dk/cgit/liburing/tree/man/io_uring.7 =
(https://manpages.debian.org/testing/liburing-dev/io_uring.7.en.html)
- https://git.kernel.dk/cgit/liburing/tree/src/queue.c (using macros =
from =
https://git.kernel.dk/cgit/liburing/tree/src/include/liburing/barrier.h)
- https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c

I=E2=80=99ll start with submission queue handling.

Quoting myself, my (possibly naive) approach for submitting entries =
would be, using gcc atomic builtins in absence of standardized C =
functions:
- (1) first read the SQ ring tail (without any ordering enforcement)
- (2) then use __atomic_load(__ATOMIC_ACQUIRE) to read the SQ ring head
- (3) then use __atomic_store(__ATOMIC_RELEASE) to update the SQ ring =
tail

Comparing with the existing documentation, (3) matches everywhere:
- io_uring.pdf confirms (3), as it inserts a write_barrier() before =
updating the ring tail
- io_uring.7 confirms (3), as it uses atomic_store_release to update the =
ring tail
- __io_uring_flush_sq in queue.c confirms (3), as it uses =
io_uring_smp_store_release to update the ring tail
  (BUT, __io_uring_flush_sq in queue.c also special cases =
IORING_SETUP_SQPOLL, which I do not fully understand)
- io_uring.c says: "the application must use an appropriate smp_wmb() =
before writing the SQ tail (ordering SQ entry stores with the tail =
store)"

However, (2) is not so clear:
- io_uring.pdf never reads the ring head (but at least it mentions that =
the example is simplified as it is missing a queue full check)
- io_uring.7 never reads the ring head (as it does not check if the ring =
is full, which it does not even mention)
- __io_uring_flush_sq in queue.c confirms that, usually, acquire =
semantics are needed for reading the ring head, but seems to handle it =
elsewhere due to how it works internally (?)
- io_uring.c says: =E2=80=9C[the application] needs a barrier ordering =
the SQ head load before writing new SQ entries (smp_load_acquire to read =
head will do)."
  (BUT, it does not mention WHY the application needs to load the ring =
head)

Lastly, I absolutely do not understand the second write_barrier in =
io_uring.pdf after updating the ring tail. =
https://git.kernel.dk/cgit/liburing/commit/?id=3Decefd7958eb32602df07f12e9=
808598b2c2de84b more or less just removed it. Before removal, it had =
this comment: =E2=80=9CThe kernel has the matching read barrier for =
reading the SQ tail.=E2=80=9C. Yes, the kernel does need such a read =
barrier, but the write barrier *before* the ring tail update should be =
enough?!

So, my recommendation for documentation updates is:
- In io_uring.pdf, remove the second write_barrier after the ring tail =
update.
- In io_uring.pdf, augment the submission example with reading the ring =
head (to check for a queue-full condition), including a read_barrier =
after
- In io_uring.7, also add a queue-full check
- In io_uring.c extend the comment to say WHY the application needs to =
read the ring head

Comments?

Regards,
  Johann

> Am 25.09.2022 um 12:34 schrieb J. Hanne <io_uring@jf.hanne.name>:
>=20
> Hi,
>=20
>> Am 22.09.2022 um 03:54 schrieb Jens Axboe <axboe@kernel.dk>:
>>=20
>> On 9/18/22 10:56 AM, J. Hanne wrote:
>>> Hi,
>>>=20
>>> I have a couple of questions regarding the necessity of including =
memory
>>> barriers when using io_uring, as outlined in
>>> https://kernel.dk/io_uring.pdf. I'm fine with using liburing, but =
still I
>>> do want to understand what is going on behind the scenes, so any =
comment
>>> would be appreciated.
>>=20
>> In terms of the barriers, that doc is somewhat outdated...
> Ok, that pretty much explains why I got an inconsistent view after =
studying multiple sources=E2=80=A6
>=20
>>=20
>>> Firstly, I wonder why memory barriers are required at all, when NOT =
using
>>> polled mode. Because requiring them in non-polled mode somehow =
implies that:
>>> - Memory re-ordering occurs across system-call boundaries (i.e. when
>>> submitting, the tail write could happen after the io_uring_enter
>>> syscall?!)
>>> - CPU data dependency checks do not work
>>> So, are memory barriers really required when just using a simple
>>> loop around io_uring_enter with completely synchronous processing?
>>=20
>> No, I don't beleive that they are. The exception is SQPOLL, as you =
mention,
>> as there's not necessarily a syscall involved with that.
>>=20
>>> Secondly, the examples in io_uring.pdf suggest that checking =
completion
>>> entries requires a read_barrier and a write_barrier and submitting =
entries
>>> requires *two* write_barriers. Really?
>>>=20
>>> My expectation would be, just as with "normal" inter-thread =
userspace ipc,
>>> that plain store-release and load-acquire semantics are sufficient, =
e.g.:=20
>>> - For reading completion entries:
>>> -- first read the CQ ring head (without any ordering enforcement)
>>> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the CQ ring tail
>>> -- then use __atomic_store(__ATOMIC_RELEASE) to update the CQ ring =
head
>>> - For submitting entries:
>>> -- first read the SQ ring tail (without any ordering enforcement)
>>> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the SQ ring head
>>> -- then use __atomic_store(__ATOMIC_RELEASE) to update the SQ ring =
tail
>>> Wouldn't these be sufficient?!
>>=20
>> Please check liburing to see what that does. Would be interested in
>> your feedback (and patches!). Largely x86 not caring too much about
>> these have meant that I think we've erred on the side of caution
>> on that front.
> Ok, I will check. My practical experience with memory barriers is =
limited however, so I=E2=80=99m not in the position to give a final =
judgement
>=20
>>=20
>>> Thirdly, io_uring.pdf and
>>> https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c =
seem a
>>> little contradicting, at least from my reading:
>>>=20
>>> io_uring.pdf, in the completion entry example:
>>> - Includes a read_barrier() **BEFORE** it reads the CQ ring tail
>>> - Include a write_barrier() **AFTER** updating CQ head
>>>=20
>>> io_uring.c says on completion entries:
>>> - **AFTER** the application reads the CQ ring tail, it must use an =
appropriate
>>> smp_rmb() [...].
>>> - It also needs a smp_mb() **BEFORE** updating CQ head [...].
>>>=20
>>> io_uring.pdf, in the submission entry example:
>>> - Includes a write_barrier() **BEFORE** updating the SQ tail
>>> - Includes a write_barrier() **AFTER** updating the SQ tail
>>>=20
>>> io_uring.c says on submission entries:
>>> - [...] the application must use an appropriate smp_wmb() **BEFORE**
>>> writing the SQ tail
>>> (this matches io_uring.pdf)
>>> - And it needs a barrier ordering the SQ head load before writing =
new
>>> SQ entries
>>>=20
>>> I know, io_uring.pdf does mention that the memory ordering =
description
>>> is simplified. So maybe this is the whole explanation for my =
confusion?
>>=20
>> The canonical resource at this point is the kernel code, as some of
>> the revamping of the memory ordering happened way later than when
>> that doc was written. Would be nice to get it updated at some point.
> Ok, I will try. Where is the io_uring.pdf source (tex? markdown??)?
>=20
> Regards,
>  Johann

