Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD73A5E921D
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiIYKeH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 06:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYKeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 06:34:06 -0400
Received: from dd11108.kasserver.com (dd11108.kasserver.com [85.13.147.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3463F27CD4
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 03:34:05 -0700 (PDT)
Received: from smtpclient.apple (p54876f31.dip0.t-ipconnect.de [84.135.111.49])
        by dd11108.kasserver.com (Postfix) with ESMTPSA id 6871D2FC0BEF;
        Sun, 25 Sep 2022 12:34:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hanne.name;
        s=kas202209201026; t=1664102043;
        bh=ofsu41G8lA08y/2xbFVg4vFB2FZYCibPuNCDe3FoPNk=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=XkNqeGTk4ofaY1Sd1b271oiqVmmMxeu8w1MrNp9MXZuwI3yuoEu/OGQdrziHDdF8G
         Q8/y0hvKdsJ/haVHAOddpiycGatbqhNwOYVPLp2asuD5xSv8mOLGuBFjty6hlwjsSL
         GjyFnFq95wpzGZfrSlgAXKirZd0ru8b8AeQr30oFW5scZxuwDLm4yYgA6Voxl5+lbm
         QFha+DedrZDUXkKyx1DgvXOr5egHZ1mj6fxHckNBS4X43rE6SuOhvoh6PmM4ShHX1p
         LGhyeiCNS67jN3hfOozTKMPmdL/SN8yEb8yHpABDTKUfchG95ckD7s/7lbA14jYh2r
         5NCKLir/i7ZfA==
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Memory ordering description in io_uring.pdf
From:   "J. Hanne" <io_uring@jf.hanne.name>
In-Reply-To: <20adf5fe-98a0-06a0-7058-e6f9ba7d9e2a@kernel.dk>
Date:   Sun, 25 Sep 2022 12:34:02 +0200
Cc:     io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F05A663E-BA85-40F7-ABA7-5C75B267FE22@jf.hanne.name>
References: <20220918165616.38AC12FC059D@dd11108.kasserver.com>
 <20adf5fe-98a0-06a0-7058-e6f9ba7d9e2a@kernel.dk>
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

> Am 22.09.2022 um 03:54 schrieb Jens Axboe <axboe@kernel.dk>:
>=20
> On 9/18/22 10:56 AM, J. Hanne wrote:
>> Hi,
>>=20
>> I have a couple of questions regarding the necessity of including =
memory
>> barriers when using io_uring, as outlined in
>> https://kernel.dk/io_uring.pdf. I'm fine with using liburing, but =
still I
>> do want to understand what is going on behind the scenes, so any =
comment
>> would be appreciated.
>=20
> In terms of the barriers, that doc is somewhat outdated...
Ok, that pretty much explains why I got an inconsistent view after =
studying multiple sources=E2=80=A6

>=20
>> Firstly, I wonder why memory barriers are required at all, when NOT =
using
>> polled mode. Because requiring them in non-polled mode somehow =
implies that:
>> - Memory re-ordering occurs across system-call boundaries (i.e. when
>>  submitting, the tail write could happen after the io_uring_enter
>>  syscall?!)
>> - CPU data dependency checks do not work
>> So, are memory barriers really required when just using a simple
>> loop around io_uring_enter with completely synchronous processing?
>=20
> No, I don't beleive that they are. The exception is SQPOLL, as you =
mention,
> as there's not necessarily a syscall involved with that.
>=20
>> Secondly, the examples in io_uring.pdf suggest that checking =
completion
>> entries requires a read_barrier and a write_barrier and submitting =
entries
>> requires *two* write_barriers. Really?
>>=20
>> My expectation would be, just as with "normal" inter-thread userspace =
ipc,
>> that plain store-release and load-acquire semantics are sufficient, =
e.g.:=20
>> - For reading completion entries:
>> -- first read the CQ ring head (without any ordering enforcement)
>> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the CQ ring tail
>> -- then use __atomic_store(__ATOMIC_RELEASE) to update the CQ ring =
head
>> - For submitting entries:
>> -- first read the SQ ring tail (without any ordering enforcement)
>> -- then use __atomic_load(__ATOMIC_ACQUIRE) to read the SQ ring head
>> -- then use __atomic_store(__ATOMIC_RELEASE) to update the SQ ring =
tail
>> Wouldn't these be sufficient?!
>=20
> Please check liburing to see what that does. Would be interested in
> your feedback (and patches!). Largely x86 not caring too much about
> these have meant that I think we've erred on the side of caution
> on that front.
Ok, I will check. My practical experience with memory barriers is =
limited however, so I=E2=80=99m not in the position to give a final =
judgement

>=20
>> Thirdly, io_uring.pdf and
>> https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c =
seem a
>> little contradicting, at least from my reading:
>>=20
>> io_uring.pdf, in the completion entry example:
>> - Includes a read_barrier() **BEFORE** it reads the CQ ring tail
>> - Include a write_barrier() **AFTER** updating CQ head
>>=20
>> io_uring.c says on completion entries:
>> - **AFTER** the application reads the CQ ring tail, it must use an =
appropriate
>>  smp_rmb() [...].
>> - It also needs a smp_mb() **BEFORE** updating CQ head [...].
>>=20
>> io_uring.pdf, in the submission entry example:
>> - Includes a write_barrier() **BEFORE** updating the SQ tail
>> - Includes a write_barrier() **AFTER** updating the SQ tail
>>=20
>> io_uring.c says on submission entries:
>> - [...] the application must use an appropriate smp_wmb() **BEFORE**
>>  writing the SQ tail
>>  (this matches io_uring.pdf)
>> - And it needs a barrier ordering the SQ head load before writing new
>>  SQ entries
>>=20
>> I know, io_uring.pdf does mention that the memory ordering =
description
>> is simplified. So maybe this is the whole explanation for my =
confusion?
>=20
> The canonical resource at this point is the kernel code, as some of
> the revamping of the memory ordering happened way later than when
> that doc was written. Would be nice to get it updated at some point.
Ok, I will try. Where is the io_uring.pdf source (tex? markdown??)?

Regards,
  Johann

