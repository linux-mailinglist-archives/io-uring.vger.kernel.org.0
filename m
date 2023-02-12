Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D36693794
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBLN2J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 08:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBLN2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 08:28:08 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B8A40F0;
        Sun, 12 Feb 2023 05:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676208483; bh=IQhzBS7+PQvrcqRTto1tO5RTXzIBnCloVw7OGfUonTo=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=XjXBBIbwUv0iUSbDDvAheShMKYkUnvONw/qeNJvr69ZcxhjiWnkWVQB79/yPvwhae
         Ki+oIo9VQ2JnmgOgUOaProis/fpyN/zWIEQUTU0uIGjh3BrEHllTUBEFky6Co7xkRm
         zpcUHXaxPcyq5Q5mnn2atDZuS+kmEJrkRQt1eLfL9BXvDwASV79R/fj1OSV/QO9X3a
         kRikXnJLTl0XziRhJf2kMQ6A6G2JGYdDQ4pDADuG6ZhzEzs6ONgxcsqIN+rgltfqCc
         rtEGO/It68TjpfRN4vtICymm1K+SnlfgMtXHomtWg1UEJ7B2SBwbQvjK3WEtX5QjmA
         wdkT19KYwhzxA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MRTRH-1pFKHm2UKL-00NP1Z; Sun, 12
 Feb 2023 14:28:03 +0100
Message-ID: <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
Date:   Sun, 12 Feb 2023 14:28:02 +0100
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
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CYvlwrMorqdUfvdJ0FGzhw4yaafveEMVFdiSWc5Rj9xBorrzbqR
 f55il4i6yZQFrtr5drkQLOT3BBEAok2SkpUJ53vWe1PMrudhv1+9+dIf+xfAx5uHIyQgQjc
 C9IFM3FleKXplimxBAu1Po66J7S/JpbAODO9OIkdxJ7wb6gU/TYIP45nB58WzjEghJjhasU
 dXTN/stxFY/R+BmrxEZ3g==
UI-OutboundReport: notjunk:1;M01:P0:S+x8qnXpDoY=;qmypRPtRLixeD1VkdaEH4pc5yjM
 pU+34vNFlJLjK2Q9iSnxz095S0vcrQzaue+t4uoSlAZtoGm8BHy35HzaK2ToDFBsLoB2vhFp4
 50V9BBfF1v/ZRyJCAOSHtozLIpXA9QXcY3teM5QQDcPMLmdzwUJdLoR+rNLLcA1dRr7WCiqW/
 zsHOS4MztAcoTSX4cFFMKFJKvTYAI5sI55IYzv2zt/Te9sBYBCYLqwgXbm13Fk5DYy/onXZqy
 ZPcg3vQXHicDKRJBr/08J9S9q785RuVm1dughWja0+D2D3EYPMPL5aJT8p9ZwIP9hx6Xhv5P2
 EAg0Y8wxhGPBPr6v+eyyFagN38gxQCMmX0WbkGKd/3emSjG29g+O9mh4h0zQmgZ+c1iUX4yxj
 sUthz+f20VsXVCYQD8JzwFZ7tLHerHhb3pighsV3+oAC2UVaA1XOKchvRjhF+ceo48vACKYyG
 Wdge7hhGWaxzY2eTRveCHjqt2zHwbbSc3Lw12rZNJ7LZsB/GrTm7rKyaeKp3je5TyKHrDCT4X
 ihK38Hnh31xPCfbKOMHnJdWIos0W5z0MtmTkIlMCzR7a6XdoX6cvBsBb55hwOWd+sHFt3jqBK
 3slmPNV14omrdiYIcY0uU+IMUBv4AkyhD35kVlh5ZZgkHDT1v7jNUBgv2pS2zNhkAz/+ihNrf
 8+RGT7nrtuRVOOEvfpiQfYSFZLvdqug9uNlA74HpV1KDxYsBq44Mhzh+paCt+EDI+6TagEalv
 /5mEOASaG0Zh8XH6zWEFULvKcVnHkpfi7kA+tnCR23XLoChMkhxoP/XO6r+60qJ3oNWBsRdMv
 vOhaXZ9U47s6PYkfMBtHon2kx4MNI8IxlyWxYkBBlCZVBFCKpUxdFgsBXhWBSqTBb9DWXpEKU
 l0+mhSpQaH9d172Jfdawdc91sne2plTIFcJ2Q77xJs6bUO3s6SSDWtrsZ1L/ioFP40XVO82Zy
 C8bSjA==
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 14:16, Jens Axboe wrote:
> On 2/12/23 2:47?AM, Helge Deller wrote:
>> Hi all,
>>
>> We see io-uring failures on the parisc architecture with this testcase:
>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c
>>
>> parisc is always big-endian 32-bit userspace, with either 32- or 64-bit=
 kernel.
>>
>> On a 64-bit kernel (6.1.11):
>> deller@parisc:~$ ./io_uring-test test.file
>> ret=3D0, wanted 4096
>> Submitted=3D4, completed=3D1, bytes=3D0
>> -> failure
>>
>> strace shows:
>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0, sq=
_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING_FE=
AT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR=
_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off=
=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, dr=
opped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68, =
ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_???=
 */}}) =3D 3
>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) =
=3D 0xf7522000
>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10=
000000) =3D 0xf6922000
>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) =
=3D 4
>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX=
_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=
=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>> brk(NULL)                               =3D 0x4ae000
>> brk(0x4cf000)                           =3D 0x4cf000
>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 0
>>
>>
>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>> root@debian:~# ./io_uring-test test.file
>> Submitted=3D4, completed=3D4, bytes=3D16384
>> -> ok.
>>
>> strace:
>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=3D0, sq=
_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|IORING_FE=
AT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR=
_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off=
=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=3D84, dr=
opped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_mask=3D68, =
ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORING_CQ_???=
 */}}) =3D 3
>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) =
=3D 0xf6d4c000
>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10=
000000) =3D 0xf694c000
>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX=
_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=
=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>> brk(NULL)                               =3D 0x15000
>> brk(0x36000)                            =3D 0x36000
>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 4
>>
>> I'm happy to test any patch if someone has an idea....
>
> No idea what this could be, to be honest. I tried your qemu vm image,
> and it does boot, but it's missing keys to be able to update apt and
> install packages... After fiddling with this for 30 min I gave up, any
> chance you can update the sid image? Given how slow this thing is
> running, it'd take me all day to do a fresh install and I have to admit
> I'm not THAT motivated about parisc to do that :)

Yes, I will update that image, but qemu currently only supports a 32-bit P=
A-RISC
CPU which can only run the 32-bit kernel. So even if I update it, you won'=
t be
able to reproduce it, as it only happens with the 64-bit kernel.
I'm sure it's some kind of missing 32-to-64bit translation in the kernel, =
which
triggers only big-endian machines.

Does powerpc with a 64-bit ppc64 kernel work?
I'd assume it will show the same issue.

I will try to add some printks and compare the output of 32- and 64-bit ke=
rnels.
If you have some suggestion where to add such (which?) debug code, it woul=
d help me a lot.

Thank you,
Helge
