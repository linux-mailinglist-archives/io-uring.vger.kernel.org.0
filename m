Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291B0781BCF
	for <lists+io-uring@lfdr.de>; Sun, 20 Aug 2023 02:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjHTAfh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Aug 2023 20:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjHTAfS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Aug 2023 20:35:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E07BBEA2;
        Sat, 19 Aug 2023 16:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692489584; x=1693094384; i=quwenruo.btrfs@gmx.com;
 bh=cmhiELHm4RVGWeLZUCvVl9BYPM+INWigkIzaSyvRXzE=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=uIVa7A7yPi8X9LOcfB/6jWVUabe7lbIy8dfrhd4ZIH7RM94womw9R7sV6iB1aLI/aKZDfou
 OApwk7dFxPKDJXYx3yIGHouhEPxv1sLs4QT20Nd/Je+sMx5R/q7JkBqP4YoSh9im+lunVz+pM
 H8nKp0AEnmttBmfcFkWCY11YrEFsxvz/q+mGLRt0fCEocEdda/9Pld4uBRj9w7vdr32jva072
 OF74ivqz59UBRcS/Ak3pl7hgufrG5P0qsiRjKevWO8Jkmyn7nAX2lDtsJOxGHalqmxEqjf6hx
 kQoPtmEo94+TAHatlsIsYH70LvBdfOCPUptAF1lejb0TjvTC+vzA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MEFvp-1qPZED0hAD-00AHIi; Sun, 20
 Aug 2023 01:59:44 +0200
Message-ID: <1726ad73-fabb-4c93-8e8c-6d2aab9a0bb0@gmx.com>
Date:   Sun, 20 Aug 2023 07:59:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
 <d67e7236-a9e4-421c-b5bf-a4b25748cac2@kernel.dk>
 <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
 <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
 <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
 <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
 <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
 <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00iVQUJDToH
 pgAKCRDCPZHzoSX+qNKACACkjDLzCvcFuDlgqCiS4ajHAo6twGra3uGgY2klo3S4JespWifr
 BLPPak74oOShqNZ8yWzB1Bkz1u93Ifx3c3H0r2vLWrImoP5eQdymVqMWmDAq+sV1Koyt8gXQ
 XPD2jQCrfR9nUuV1F3Z4Lgo+6I5LjuXBVEayFdz/VYK63+YLEAlSowCF72Lkz06TmaI0XMyj
 jgRNGM2MRgfxbprCcsgUypaDfmhY2nrhIzPUICURfp9t/65+/PLlV4nYs+DtSwPyNjkPX72+
 LdyIdY+BqS8cZbPG5spCyJIlZonADojLDYQq4QnufARU51zyVjzTXMg5gAttDZwTH+8LbNI4
 mm2YzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00ibgUJDToHvwAK
 CRDCPZHzoSX+qK6vB/9yyZlsS+ijtsvwYDjGA2WhVhN07Xa5SBBvGCAycyGGzSMkOJcOtUUf
 tD+ADyrLbLuVSfRN1ke738UojphwkSFj4t9scG5A+U8GgOZtrlYOsY2+cG3R5vjoXUgXMP37
 INfWh0KbJodf0G48xouesn08cbfUdlphSMXujCA8y5TcNyRuNv2q5Nizl8sKhUZzh4BascoK
 DChBuznBsucCTAGrwPgG4/ul6HnWE8DipMKvkV9ob1xJS2W4WJRPp6QdVrBWJ9cCdtpR6GbL
 iQi22uZXoSPv/0oUrGU+U5X4IvdnvT+8viPzszL5wXswJZfqfy8tmHM85yjObVdIG6AlnrrD
In-Reply-To: <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/UySt3+owrIEBM8GVJR2Gd1OEuH+2Z+Ukt96D//ERE0ItKdDfaM
 NzZYwSIpBG7cbPyMgmFn3+cPXGInuo3XzvW7jF1Uw+3cUEhP7ey4bT5CJ/p5LZvT/ruJkP+
 mneSEnLQrUBcW8RKvdp3gvdXWCAc7OtGlxsSwzs46wrKAtuENTk5EJou0XwiY6JPmfJj//S
 hRHMobRXjItplC81FWdWA==
UI-OutboundReport: notjunk:1;M01:P0:5raWnEwzU1w=;a0ahjtLTr1gojEd0eGv0M+YkIE5
 5CntqIP9J37kE7fES+6alQR7uy53RX0b44vgb99E9qjNYzZYLCh5tnS352Qyf0grbGed3C9pv
 Yyv4AMNGhJilpqD1J+sAOQS6RfU7BsVNCYY5Bg6yjKTMbFOGe1S9tvVCLlU6ygeD+2MAh0BCt
 m5q6RvNBsozoWthpdfmTAbZo4Dwnxylp+lVwkBZ36mmX0ti4InjwuHLiY6XqLsipX36iJCeiL
 l9s9zJw92MBsCg9zSH0i3Cxv3JBp/mr8G/i55swF5Ri3TGpAU41QpYX7ZB08D06xX4tNQw6Cf
 Q0JNvtr0Tkxl0QX+MMq+I0MFu3L/Hzosxwwzn2h0u2M8dR6b0LOgwU5pc4FFT0pMrPV8Filps
 9aL40nJ0A+ykW37biZYaSvDxayv2VGX1x/9Zv/JN9O7AV/6qT17BPza4t9MBKjAaTRwmPayxI
 ZNMhWJcW8ApuV2luoHsEqYeZ6luKwoqFd5Oxa1M5oy4ZDdhpFO74X/KiZFaNUmePAkzOy8SHV
 wjjzvxnEpD9fDxYWSqhw/PcawP8oNHIfU1lQb86YTkypLeT+DIT8GglcElFrWWthfShblAZIh
 2v03nYa0ljcx1Q5Sh3KOOCqxojUHGbKJsa3Eq9msxEnf6rfwnysCT+H/G8LXAzclnES6jwdm7
 P1abkelYW0N6FhCo1/NKDSP+I4EzXoBD2sKtfkKcGkghWiu1sVwQD8mk9jMs+pC5yJQw4DfJW
 T9iYdbYmyWHFr8ScJa2I0LmrmQs+Btc/M1k3p2LqAIMq8dWT2tnmVmvxby9npl62QvOyN3gRq
 mP+QXuZfQenTl6TjIE9ZGYTxyk42b2ZeQrH920G3KkiffUhR+wKnFHzvHXL+WZudAX7PCVPaV
 sd+5/oEFG6uedJ35sQHzQcvfmYpFV29AfGKY0HhLnhxE08XAuzsWpSqtziI7ggYGLrxdGh8at
 AlC8/JdPSrg+2bT0Se6Fps5rUPc=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens

I tried more on my side to debug the situation, and found a very weird
write behavior:

	Some unexpected direct IO happened, without corresponding
	fsstress workload.

The workload is:

	$fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt -v > /tmp/fsstress

Which I can reliably reproduce the problem locally, around 1/50 possibilit=
y.
In my particular case, it results data corruption at root 5 inode 283
offset 8192.

Then I added some trace points for the following functions:

- btrfs_do_write_iter()
   Two trace points, one before btrfs_direct_write(), and one
   before btrfs_buffered_write(), outputting the aligned and unaligned
   write range, root/inode number, type of the write (buffered or
   direct).

- btrfs_finish_one_ordered()
   This is where btrfs inserts its ordered extent into the subvolume
   tree.
   This happens when a range of pages finishes its writeback.

Then here comes the fsstress log for inode 283 (no btrfs root number):

0/22: clonerange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
[307200,0]
0/23: copyrange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
[1058819,0]
0/25: write d0/f2[283 2 0 0 0 0] [393644,88327] 0
0/29: fallocate(INSERT_RANGE) d0/f3 [283 2 0 0 176 481971]t 884736 585728 =
95
0/30: uring_write d0/f3[283 2 0 0 176 481971] [1400622, 56456(res=3D56456)=
] 0
0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[283 2 308134 1763236 320
1457078] return 25, fallback to stat()
0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 320
1457078] return 25, fallback to stat()
0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 496
1457078] return 25, fallback to stat()
0/38: dwrite d0/f3[283 2 308134 1763236 496 1457078] [2084864,36864] 0
0/39: write d0/d4/f6[283 2 308134 1763236 496 2121728] [2749000,60139] 0
0/40: fallocate(ZERO_RANGE) d0/f3 [283 2 308134 1763236 688 2809139]t
3512660 81075 0
0/43: splice d0/f5[293 1 0 0 1872 2678784] [552619,59420] -> d0/f3[283 2
308134 1763236 856 3593735] [5603798,59420] 0
0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [283 1 308134 1763236 976
5663218]t 1361821 480392 0
0/49: clonerange d0/f3[283 1 308134 1763236 856 5663218] [2461696,53248]
-> d0/f5[293 1 0 0 1872 2678784] [942080,53248]

Note one thing, there is no direct/buffered write into inode 283 offset
8192.

But from the trace events for root 5 inode 283:

  btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D393216(393644)
len=3D90112(88327)
  btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D1396736(1400622)
len=3D61440(56456)
  btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D708608(709121)
len=3D12288(7712)

  btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D8192(8192)
len=3D73728(73728) <<<<<

  btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D589824(589824)
len=3D16384(16384)
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D8192 len=3D73728
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D589824 len=3D16384
  btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D2084864(2084864)
len=3D36864(36864)
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2084864 len=3D36864
  btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D2748416(2749000)
len=3D61440(60139)
  btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D5603328(5603798)
len=3D61440(59420)
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D393216 len=3D90112
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D708608 len=3D12288
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D1396736 len=3D61440
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D3592192 len=3D4096
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2748416 len=3D61440
  btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D5603328 len=3D61440

Note that phantom direct IO call, which is in the corrupted range.

If paired with fsstress, that phantom write happens between the two
operations:

0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0

I'll keep digging, but the phantom writes which is not properly loggeg
from fsstress is already a concern to me.

Or maybe I'm missing some fixes in fsstress?

Thanks,
Qu
