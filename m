Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BED56939AF
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 20:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBLTf2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 14:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBLTf1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 14:35:27 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0E510AA2;
        Sun, 12 Feb 2023 11:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676230502; bh=o44dbL78fGt/6MyxbLL26NAvODOqpntat5u78ySr16Y=;
        h=X-UI-Sender-Class:Date:Subject:From:To:Cc:References:In-Reply-To;
        b=i/hrGuecVbU6JQlT//A9Q9KbMeVAe/6quMFP2PBpLpQOu6TqbSxuiso02NWPWgFGr
         4w5cGMbI472Gmtd/DJ8vZ6GF0PVjR89EoX8cycOVZ+nfdvvcI6V+VFh2SECz/qPxU1
         hjppuN/bCrpLXPciRVGYZ5xoDfoAK4lJVQNsB6rHfgpkILCh3KMARn0r67CzrK9spU
         xgaVvwRbGgpyEvh9mztB32zNscpRXf+MB+xJoIPTZlUQ6UMzkkAr4FaCzOBWK2oiKP
         eW9zlMq7A8YFAKMLMng0ZJwXo3dzzPogydbBE4QzYTxTfmUYGx4ux9WY0A4jcWFvJd
         s38J9Fs/I8QQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4axg-1pSw1A2Bew-001jXw; Sun, 12
 Feb 2023 20:35:02 +0100
Message-ID: <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
Date:   Sun, 12 Feb 2023 20:35:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
From:   Helge Deller <deller@gmx.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
 <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
In-Reply-To: <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pNjS4KzBNJhpJExiy47DTJB7AYZQO9DmiY7fr5LGt/3W5czYG60
 +fmvcaJKIaR+4Tlo3rcbTLhZYP2mKHXC76+CNF6ddI7JyOH+gYY9AgVC31M9zC382YZ48t5
 CqIkFwuUXcKSU+jYLkEAroCbjb7r16n6rvYOMd+EqBkHvjhPzrMfWRzYPi8TDprGeXRa17I
 vr0if9qhn1iS4yMI91sog==
UI-OutboundReport: notjunk:1;M01:P0:1UzpP/T2TPY=;XKVjgsID8/oTR+vKxsZvCzoNan/
 G0KgKCGYsDxWa4Hfjho7k8uffY8SHFyYugVHyqaJtzLo/pyiWqadFgLipiVR0g/wkoXCDAwey
 CQQECphephjT8XzuwooybZQcVQSFJR4UMZ87iD/WOHchN8yxoIkmG4+Moz4J+dFCeumk8l9Mg
 4/Y6o/GefL1eECXb5iRqw9jtmFMKM8rl7bvrz3vdnId5RD2RKnp/yLv4PR6Euif6Ydsw5mMw1
 iKLaBhnXJWeZN2uFvRi2eIVwnlj270b2ak6xCGvA2Dh5/wivPoMVX+B+tcfgpHzstLKW+P6e7
 kRd/O4dwCUNhSoO4XZFcdI2JXoGdiChCIOUlGu8I6Uzl33oZhzqXOPUqZxfTR9zLpJ9t6ZLTU
 tLs+iBG/GejnRq+oc3kc9emrjZWbALqoD1IELriZ+zIN9p/6X57szk/iG12fg79HfCOziJe/U
 yhCIqeX9hVeGfv1QKw2sSWv3L/x/mI7efIl5NYjPUkEUw0NgFc+5FWdY9ByDedF884uxjGyxs
 iPBVQlq59RwlH7g7qGpYxMuCmeaQtv0t5zktNHOiKHZu2eJQ2NjD2N/qMl42yUydDNKVAif2H
 bBAcldDxKv8MyXVgp8/wJ1M3afq5fp2BNOyTd7fSgfnDcw8m1+YOaRP6LbRlzOl5fgfSlww1N
 W+RbJHBD0Tnv6ZM/RMu6nTv8M8Kz50SNetW0ErGlvjEYnyMMINj1NhnYR7J+TLy7KUYJcfYFg
 95KTtXP4Nc5qRDsekoE08Xv3xQBD+nLuzD5Yh8EUIvHJMAefgCbY+6M106tw9fA3AsWbJhwLd
 b2l8UJH2xahvG/TAAykhum+9tUKUvpzOV4bWhzO9V8FbrKSW5Kj/5NZEv9iuvB7xKsvpuHuoa
 PZe+knpj+aZ7AOFA1d8VQ3IUrVTdhcjtPtHzjEyJNtRMp3MwFXk3lrYfDIRn2e990TkVBcQFy
 rpqDItZnSFMQTWeGjXsR0KT+B4g=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 15:03, Helge Deller wrote:
> On 2/12/23 14:35, Jens Axboe wrote:
>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>> Hi all,
>>>>>
>>>>> We see io-uring failures on the parisc architecture with this testca=
se:
>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test=
.c
>>>>>
>>>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-=
bit kernel.
>>>>>
>>>>> On a 64-bit kernel (6.1.11):
>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>> ret=3D0, wanted 4096
>>>>> Submitted=3D4, completed=3D1, bytes=3D0
>>>>> -> failure
>>>>>
>>>>> strace shows:
>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0,=
 sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING=
_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_=
CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_o=
ff=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, =
dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68=
, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_?=
?? */}}) =3D 3
>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0=
) =3D 0xf7522000
>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0=
x10000000) =3D 0xf6922000
>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT=
) =3D 4
>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, ST=
ATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribute=
s=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>>>>> brk(NULL)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0x4ae000
>>>>> brk(0x4cf000)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0x4cf000
>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0
>>>>>
>>>>>
>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>> root@debian:~# ./io_uring-test test.file
>>>>> Submitted=3D4, completed=3D4, bytes=3D16384
>>>>> -> ok.
>>>>>
>>>>> strace:
>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0,=
 sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING=
_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_=
CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_o=
ff=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, =
dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68=
, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_?=
?? */}}) =3D 3
>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0=
) =3D 0xf6d4c000
>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0=
x10000000) =3D 0xf694c000
>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, ST=
ATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribute=
s=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>>>>> brk(NULL)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0x15000
>>>>> brk(0x36000)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0x36000
>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)=C2=A0=C2=A0=C2=A0=C2=A0 =3D 4
>>>>>
>>>>> I'm happy to test any patch if someone has an idea....
>>>>
>>>> No idea what this could be, to be honest. I tried your qemu vm image,
>>>> and it does boot, but it's missing keys to be able to update apt and
>>>> install packages... After fiddling with this for 30 min I gave up, an=
y
>>>> chance you can update the sid image? Given how slow this thing is
>>>> running, it'd take me all day to do a fresh install and I have to adm=
it
>>>> I'm not THAT motivated about parisc to do that :)
>>>
>>> Yes, I will update that image, but qemu currently only supports a
>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
>>> update it, you won't be able to reproduce it, as it only happens with
>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>>> translation in the kernel, which triggers only big-endian machines.
>>
>> I built my own kernel for it, so that should be fine, correct?
>
> No, as qemu won't boot the 64-bit kernel.
>
>> We'll see soon enough, managed to disable enough checks on the
>> debian-10 image to actually make it install packages.
>>
>>> Does powerpc with a 64-bit ppc64 kernel work?
>>> I'd assume it will show the same issue.
>>
>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>
> Would be interesting if someone could test...
>
>>> I will try to add some printks and compare the output of 32- and
>>> 64-bit kernels. If you have some suggestion where to add such (which?)
>>> debug code, it would help me a lot.
>>
>> I'd just try:
>>
>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>
> I'll try, but will take some time...
>

At entry of io_submit_sqes(), io_sqring_entries() returns 0, because
ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4 on 32-b=
it), and
ctx->cached_sq_head is 0 in both cases.

Helge
