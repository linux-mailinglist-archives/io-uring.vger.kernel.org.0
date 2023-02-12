Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5266937AB
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 15:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBLOD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 09:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBLOD2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 09:03:28 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCCC11EA7;
        Sun, 12 Feb 2023 06:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676210603; bh=+5Pqp7yspxV9nv52Z1O/wxMs/Z7kjK3TTGOZ/B+omwE=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=I1g0U8Hw76GGOYIjxlls5goeQg3mw3eLW/5NDyCUGvXhoEXDvJJeaXTq8LQ9ulCmn
         FpxBos2ypPNf0kgkXeq6oMXo5tTgvOprZyo48uzVpPy9HfnM0MybZq+S6FHPMyhFax
         3YEPR3xLG340bQFm0Eimj8bAf4nGvmiVLjvNoYtZ2kYUU3gHZgweZQedKrAcZjKuM1
         7aDyUb5cycKZewxeIHYnTXNvay8uOOjqU42IdHRrZeSWJQFqIXswaEL5Q+bHjnllJV
         rAFecYxbgkA1vcC8whx6w9scxSejRxhqdju3WzUCkPs+5nGqD5YQSQcp5kqm7MOZO2
         7GuYCGyjw00kw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M72oH-1pVKU93UFT-008eax; Sun, 12
 Feb 2023 15:03:22 +0100
Message-ID: <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
Date:   Sun, 12 Feb 2023 15:03:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AuVKJK+jCI+gGL2a1ptYvxja5dta4X0tCi5M/0lTPyeFUDnwtAn
 6UhJULCkrkNo8JXQ5QuyXLwE0+uTuUPwcN8+bkP0hFYM5dqRQODjJQtOz3kiac7N2qEdcaU
 typ2N1uN6yxm0lmLKPGc9uwCHw+y4swouwsOrbRd3f8L+kE+rTJ2wdy6tt+mh1u3ZbQX9cM
 G3YBGP/y0z0k5Xa4g+SRQ==
UI-OutboundReport: notjunk:1;M01:P0:+VmgLEluU20=;MsX090stxogPj7+1dxw8So5tKX8
 XWjSY9QcpAIGLegz5WeVDqlytJoQoQjsx7Dz6/uY2XbZkDzGcdv/1Y5E29+tEMAJkr2pHT862
 rk+yX6m7M0SGVLuQGYic3AsPDPNT18mAKld3iCgFhir8Turhn9Z5avvmN8lO+gR5TeY3Tk0m7
 XPllZi31adKcNW1D4vJaEfd9tFn+Ya5E/uTjgiXbCplSr/jFgC8ALHrWAOeinoYBnf+2sas2I
 RAdNSR+39n3ql4k+PUZRok4Sv6M3w2w2E9DSyAlDfw7aOlIarToA6SkA82Cfu16pAyouvdByI
 X1+v4Fb0rCSmntuzmzApHelPnG4LKPY90JeXCndNQMGk1AYAlXKCRfzO3PRGszy4TgPB4GO1R
 hP41Py8RWlz/pszMqGfExNoD+Sb6RpmcM7eJuO0Ov/wYznTzAD2V1Xxodtv3KvFomTObfv7+q
 dJJaZvWNQtFZorYAFpCLV3K9bfWG3JtcxNEC9gnHNwYhw6zrOEVPDpll24IaQpvm2jHMqPxn0
 2aAh3SSYpTDr2L6F7yRvWVmHoUxqLGWpoJzg1U0AXfR3VC3HKk3zxR9OpiDd/fOTGGkIJCxky
 lUew9kI8sHkJXc0MkVy9puD6cPUNWecVR+ROrdYR5QAiuvaR/F1l4jcKg2iWGu/7TlCyKA0Ri
 sKl1KDIeEwFYO6ILdgMkpY//YBxVNsMjOdBmzawOEdVmSqduLV4ASBLL5Cr1sEEHXDs7gYkDo
 PgCpEJWccqf0ZJkrS/ciKjXsX7GGvLEEBTTKEXqOa2upMmQP33zguPz5Abxt1psA9mS6Ls7mv
 mUMwmS1O0Rg1gA6mrk8YWcnYJsJhXnml971mptcK3YbbyIlxqRdMJVYYjBwD/U9lU7JAeWcJC
 RjjTnLmZEqpB/gRggJ2w1iLW/v/09UppTHLFpMZxZv7pVK8IwiknCQcaGGJUEfd/1NqFCeM3i
 1X294aMa9jKMJ0Vsz9Bts4RrCMw=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 14:35, Jens Axboe wrote:
> On 2/12/23 6:28?AM, Helge Deller wrote:
>> On 2/12/23 14:16, Jens Axboe wrote:
>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>> Hi all,
>>>>
>>>> We see io-uring failures on the parisc architecture with this testcas=
e:
>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.=
c
>>>>
>>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-b=
it kernel.
>>>>
>>>> On a 64-bit kernel (6.1.11):
>>>> deller@parisc:~$ ./io_uring-test test.file
>>>> ret=3D0, wanted 4096
>>>> Submitted=3D4, completed=3D1, bytes=3D0
>>>> -> failure
>>>>
>>>> strace shows:
>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0, =
sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING_=
FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_C=
UR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_of=
f=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, d=
ropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68,=
 ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_??=
? */}}) =3D 3
>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0)=
 =3D 0xf7522000
>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x=
10000000) =3D 0xf6922000
>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT)=
 =3D 4
>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STA=
TX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=
=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>>>> brk(NULL)                               =3D 0x4ae000
>>>> brk(0x4cf000)                           =3D 0x4cf000
>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 0
>>>>
>>>>
>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>> root@debian:~# ./io_uring-test test.file
>>>> Submitted=3D4, completed=3D4, bytes=3D16384
>>>> -> ok.
>>>>
>>>> strace:
>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0, =
sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING_=
FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_C=
UR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_of=
f=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, d=
ropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68,=
 ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_??=
? */}}) =3D 3
>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0)=
 =3D 0xf6d4c000
>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x=
10000000) =3D 0xf694c000
>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STA=
TX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=
=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>>>> brk(NULL)                               =3D 0x15000
>>>> brk(0x36000)                            =3D 0x36000
>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 4
>>>>
>>>> I'm happy to test any patch if someone has an idea....
>>>
>>> No idea what this could be, to be honest. I tried your qemu vm image,
>>> and it does boot, but it's missing keys to be able to update apt and
>>> install packages... After fiddling with this for 30 min I gave up, any
>>> chance you can update the sid image? Given how slow this thing is
>>> running, it'd take me all day to do a fresh install and I have to admi=
t
>>> I'm not THAT motivated about parisc to do that :)
>>
>> Yes, I will update that image, but qemu currently only supports a
>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
>> update it, you won't be able to reproduce it, as it only happens with
>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>> translation in the kernel, which triggers only big-endian machines.
>
> I built my own kernel for it, so that should be fine, correct?

No, as qemu won't boot the 64-bit kernel.

> We'll see soon enough, managed to disable enough checks on the
> debian-10 image to actually make it install packages.
>
>> Does powerpc with a 64-bit ppc64 kernel work?
>> I'd assume it will show the same issue.
>
> No idea... Only stuff I use and test on is x86-64/32 and arm64.

Would be interesting if someone could test...

>> I will try to add some printks and compare the output of 32- and
>> 64-bit kernels. If you have some suggestion where to add such (which?)
>> debug code, it would help me a lot.
>
> I'd just try:
>
> echo 1 > /sys/kernel/debug/tracing/events/io_uring

I'll try, but will take some time...

> on both kernels and run that example. I do wonder if it's some O_DIRECT
> thing, does the example work if you just remove O_DIRECT from the file
> open?

No, still fails with O_DIRECT removed.

Thanks!
Helge
