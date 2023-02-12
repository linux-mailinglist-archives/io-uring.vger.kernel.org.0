Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784386939BE
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBLUBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 15:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBLUBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 15:01:09 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B430EF;
        Sun, 12 Feb 2023 12:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676232064; bh=JWwp3oaJgtJAKpHS1YAaeFN6XeyM+zeE+3kvvXXRztE=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=qw09W0ywYZj76N55NbBk1uj87uJhGhfE6ah3z9yFFjXsaBFAwYgRCmkgxGZ+TlNHC
         6glQk4vhdX6XrvZqjGy/cRYGo/BXRbXpWIR+WoF6jfVuBUDYh9q+oR+eqgIojFCS9o
         OOPbxP2V07Fdsi0B6//Ga31sFS4qESchZx1fXhcEBmWJOFpuGfTwwb+/D2F86Y5bt9
         0bMJoevw0JsF5Qk6twlvlUt86b+d0+UqN/tz8nDIJUyPdGEOa0Yko2IwoFAn+rWv0C
         zP9Efs9fTc11mnQS69eCK9pAUGjChNQPWHM7Uao2taIg/cmiIKIpeXVJJ/DuMJxbHw
         9olL8x/kxPIUA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdvqW-1otsvO1Ujm-00b5wv; Sun, 12
 Feb 2023 21:01:04 +0100
Message-ID: <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
Date:   Sun, 12 Feb 2023 21:01:03 +0100
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
 <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
 <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
 <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6zu0S03CCBMm2PBnAgwiRjkZbh3JPpWV/RlnZhCIQCVRRf1ETet
 1RziM/3/xeJJEdUtqOYk+U8/Jozkx6k4bLebApAycW3C5Yp2vt3UqVtXKRQ2jxu/YXRRt7X
 wUR/xheQInoDU0NLJc3/VmrF7QSAURu7iEJYOKEHz1ShcvUaOt/eRnCo2HKzxPwzyOwGNkv
 B6aPQ2+5V9FTq+pPTSoUg==
UI-OutboundReport: notjunk:1;M01:P0:LfdwaYcPzc8=;aT9YLE7MW8LhAIfQRQ+OL74MB0B
 7cLHuMJAvIfv+rgoYCSKmpAV60jXi2WUFnJdrvpvmApktw58Zh/sgQTc3Ngxrgb0pmhyrOMPV
 Do6jNJR2YPyqMAMMprK05WeO00fG4oixGjYzNX9FXq5A0dAg//hBZcYTQ9xGERtpIeDDqmcfY
 2T4ONPdQdqu6dnHHyHZBES/zg3Y9mNdcm3amqao1bScs7oDaKi7QiDVYlnlC8C6wNHz3vBSS/
 Fe1ZmTt8qumFF6ab8x+c9GLFiwkW2J9PBXDjwbdJaoaYYWOJuKwY8aULzPZZY+y0oK3+hiDUJ
 YrVU2bp13zkiLmeSIzbqsWRCcXdk6Ev3ahuw4POGx3f03qyzPFcpmK6/T6x32lWJrQl2M3jn2
 Dkb0qBE1pIwU0jXReHQEFhE2D0+K98aGmNaA+hwFNX2m4v58s6Fx5om1NhKpwSUc8nMGb0jpx
 EzVWFgycBuKA5YcwBO+koprVbOHwaF3sdhDQ+5GlG3E64XwaYvB3b+CvGNq74AnzjaJp+Kaeb
 QZvXXBin/AcApmwVmy6/2V0f+W2N4Br4lxad3gil9w6RAvgjtvmzp7Hv1K32yYJjydTNbp6jm
 PvOiSgu9EvJRJFzIJDcqL806SAx5FNNZ6MuxRPG/I/QB1Kcel2OaNeEl0Is7agnx12/uB3DKe
 95qB7jFlQtZ0UstccLQeZx0st606vBmVJXBNOuADv663CStEh7NB+W4sDsJzeaCfIY67Cu6Hv
 8kxV5qflDdFofk+bo5ZD4r7ZUReVav0oZuZH17U9rN5tnVLzD0f6V4jiXYQfOcePqkKw6iqHL
 ZpX497x1oU419/07jdNGqOeuP/J1Tl94aGmRGzirMs4vJQYnW7Ax1k5PYGMeaQJCX5m5FpD+W
 I6WPaRHfya1yj/qp/fATfC1YLUoHsH0g3jeds5dkGGQaZOMMiKJOR+OwmvFahZY4RlAwqnIgH
 SJ7l4vQSZCoKV+c/UzAxk2xpe8s=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 20:42, Jens Axboe wrote:
> On 2/12/23 12:35?PM, Helge Deller wrote:
>> On 2/12/23 15:03, Helge Deller wrote:
>>> On 2/12/23 14:35, Jens Axboe wrote:
>>>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> We see io-uring failures on the parisc architecture with this test=
case:
>>>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-te=
st.c
>>>>>>>
>>>>>>> parisc is always big-endian 32-bit userspace, with either 32- or 6=
4-bit kernel.
>>>>>>>
>>>>>>> On a 64-bit kernel (6.1.11):
>>>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>>>> ret=3D0, wanted 4096
>>>>>>> Submitted=3D4, completed=3D1, bytes=3D0
>>>>>>> -> failure
>>>>>>>
>>>>>>> strace shows:
>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D=
0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORI=
NG_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEA=
T_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq=
_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84=
, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D=
68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ=
_??? */}}) =3D 3
>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3,=
 0) =3D 0xf7522000
>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3,=
 0x10000000) =3D 0xf6922000
>>>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRE=
CT) =3D 4
>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, =
STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribu=
tes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>>>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>>>>>>> brk(NULL)                               =3D 0x4ae000
>>>>>>> brk(0x4cf000)                           =3D 0x4cf000
>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 0
>>>>>>>
>>>>>>>
>>>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>>>> root@debian:~# ./io_uring-test test.file
>>>>>>> Submitted=3D4, completed=3D4, bytes=3D16384
>>>>>>> -> ok.
>>>>>>>
>>>>>>> strace:
>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D=
0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORI=
NG_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEA=
T_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq=
_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84=
, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D=
68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ=
_??? */}}) =3D 3
>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3,=
 0) =3D 0xf6d4c000
>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3,=
 0x10000000) =3D 0xf694c000
>>>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, =
STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribu=
tes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>>>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>>>>>>> brk(NULL)                               =3D 0x15000
>>>>>>> brk(0x36000)                            =3D 0x36000
>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 4
>>>>>>>
>>>>>>> I'm happy to test any patch if someone has an idea....
>>>>>>
>>>>>> No idea what this could be, to be honest. I tried your qemu vm imag=
e,
>>>>>> and it does boot, but it's missing keys to be able to update apt an=
d
>>>>>> install packages... After fiddling with this for 30 min I gave up, =
any
>>>>>> chance you can update the sid image? Given how slow this thing is
>>>>>> running, it'd take me all day to do a fresh install and I have to a=
dmit
>>>>>> I'm not THAT motivated about parisc to do that :)
>>>>>
>>>>> Yes, I will update that image, but qemu currently only supports a
>>>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if =
I
>>>>> update it, you won't be able to reproduce it, as it only happens wit=
h
>>>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>>>>> translation in the kernel, which triggers only big-endian machines.
>>>>
>>>> I built my own kernel for it, so that should be fine, correct?
>>>
>>> No, as qemu won't boot the 64-bit kernel.
>>>
>>>> We'll see soon enough, managed to disable enough checks on the
>>>> debian-10 image to actually make it install packages.
>>>>
>>>>> Does powerpc with a 64-bit ppc64 kernel work?
>>>>> I'd assume it will show the same issue.
>>>>
>>>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>>>
>>> Would be interesting if someone could test...
>>>
>>>>> I will try to add some printks and compare the output of 32- and
>>>>> 64-bit kernels. If you have some suggestion where to add such (which=
?)
>>>>> debug code, it would help me a lot.
>>>>
>>>> I'd just try:
>>>>
>>>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>>>
>>> I'll try, but will take some time...
>>>
>>
>> At entry of io_submit_sqes(), io_sqring_entries() returns 0, because
>> ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4 on 3=
2-bit), and
>> ctx->cached_sq_head is 0 in both cases.
>
> cached_sq_head will get updated as sqes are consumed, but since sq.tail
> is zero, there's nothing to submit as far as io_uring is concerned.
>
> Can you dump addresses/offsets of the sq and cq heads/tails in userspace
> and in the kernel? They are u32, so same size of 32 and 64-bit.

For both kernels (32- and 64-bit) I get:
p->sq_off.head =3D 0  p->sq_off.tail =3D 16
p->cq_off.head =3D 32  p->cq_off.tail =3D 48

Helge
