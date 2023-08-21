Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF7B7834F2
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 23:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjHUVmv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 17:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHUVmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 17:42:50 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4ACE;
        Mon, 21 Aug 2023 14:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692654165; x=1693258965; i=quwenruo.btrfs@gmx.com;
 bh=h7EgsQ/FZ8i/nuvFeLTkguKPrsy2jcinab6AYkQBYKU=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=GJoUHp/gp6broc0zIJcDS70BVZRcnlIzAXBkS9rGRrpoh3a0QwGONRFg/EuZFDMASCneKaY
 6zgahMd20wcwOkio8ZfPVu3794wzNJ4PDabZFuEFDj23Nz7bBvTg9pu0+c9ubCR6AuS6lqlW9
 uoBaLnvXiX00RwspRYjfzRQ2Kna2ZWG66Ynt8SI5a3GSXzznIxvP9ufsXanAms+9+cSsXYtan
 OBydOh//hdNgVpN4XvRJDqiSrzTHnnB/X7hkY1cXIY0+Jcmi/K59EVvOmESXmzmmZtJSy8ZTp
 WuNVcMDxTnE4t6LtHk3v0zmCz2KF0xuilG5UBZ9BhSCqsOy+VkTQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N1Obb-1pZnjT2xjf-012tSf; Mon, 21
 Aug 2023 23:42:45 +0200
Message-ID: <9858b7e0-c1a9-4432-baa4-2d12a208777c@gmx.com>
Date:   Tue, 22 Aug 2023 05:42:40 +0800
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
 <1726ad73-fabb-4c93-8e8c-6d2aab9a0bb0@gmx.com>
 <7526b413-6052-4c2d-9e5b-7d0e4abee1b7@gmx.com>
 <8efc73c1-3fdc-4fc3-9906-0129ff386f20@kernel.dk>
 <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
 <71feba44-9b2c-48cd-9fe3-9f057145588f@gmx.com>
 <267b968a-e1a8-4b6d-9e78-97e295121cce@kernel.dk>
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
In-Reply-To: <267b968a-e1a8-4b6d-9e78-97e295121cce@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JNEygMEOnI/3b5EMnSYqY+xCYpBaq9tgCj0JHggzUHtai8eNBTy
 3Uo1i7WWlgfBevo+9qphEzumYOKN7QQZni9diZe0GK9CS1H1EnYXh/I2DhgAyoECmPMQt8G
 d8F8ZucNVKUQB1I6Y4SlIKlWU72fa81XzqwFR8S+/4mwJ2EY1kHNgRvOWm4GZBNwO0ckUX1
 ASntP6JFRKAfP34g7wngg==
UI-OutboundReport: notjunk:1;M01:P0:o30YSWZY1jo=;tn2p8mAcW464OsAFRuQOLJoSt0w
 7DpHwmNWaAUj+Qt9p2EzTOz2pkJuFBK1rRMmcxqm7C6yIloXYLVf4YXFKu3I4dt7Kt8HJho5F
 vs+f/SHq7UsAhEZ5jR+FdRfinit9l+0dOICAt87zQ/i0Y7Al4ftbWbri/oWCs3FcAm8raGXMJ
 GYdZPTIe6otVbt/KZvXDgvPcsaLLLmZNeLFNoTUUdrspaGHTA957J7W5vrVIMQEKYkUkM+3EU
 pFE1MtRshcZMeDriIk4ylFaeZ/4IXsbDzeOqKK4f79HEJ1MR/YtAk65cSbiCzUfFAAtmhuJzN
 DMV0xLxW66GtJusLvx2IeTC3lEadnkWm/+XX73HVlMbwpa7btVLEFppoSnnzPFtFiMrjl8P5f
 RbC1YT3LcCNL3992vczR+zrRo0f0Z5XF11wtEf40v4zp1jkl+mvjeeSWdTnpRix/DhoWxY+U9
 6yFlnq+/F1hYQUZZBKWIVYf3dFhlV9tvsWVNycu1M6jZhdnGMCTX6oa/0cpr4640SvQJKxXdw
 Mi+QgYGZbgH/BhGcZ88Ujjy3LjoEnd9eUIQpFngVu+voEgxMy3NL39X1w+5WYbLXf0/BuLohC
 wzdeVkApRE55o+Q9L+udUsvjhpL5rXpmD/9Ikt3tyyA/jPmOLMrBQS0V2t1WuHXgPLbaS1qMV
 C9Y3nWGpyu9AsbbtTfmyWrJhzwYLjawPEfvhaftbmzfpD3cCVA5UBxZfOrtXkwNyi2LfKMOIP
 JvIvDl1iPkV5+Z1gFtC0LKfOzrDgGpnpAzichahlOzRTOeJ797Ju/j2kqj3rtmF5fXwQuNEBn
 17l2zuI98/lITqSc0DuTQVsJN3k+KpG0xpRKX3F7iknF2+ezKuwkxoH4/7LsCTGks10Ofp4xC
 XtMd+vbMRq2duB4hs9ToMut5BPKnZ6oeTjrvmZAFoI/VlLZuBErf31W9wM+R0n8tHgC0UjlZF
 Uf1kcELLkY1hhVV1SuZpl5l5Wok=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/21 22:57, Jens Axboe wrote:
> On 8/20/23 6:38 PM, Qu Wenruo wrote:
>>
>>
>> On 2023/8/20 22:11, Jens Axboe wrote:
>>> On 8/20/23 7:26 AM, Jens Axboe wrote:
>>>> On 8/19/23 6:22 PM, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2023/8/20 07:59, Qu Wenruo wrote:
>>>>>> Hi Jens
>>>>>>
>>>>>> I tried more on my side to debug the situation, and found a very we=
ird
>>>>>> write behavior:
>>>>>>
>>>>>>        Some unexpected direct IO happened, without corresponding
>>>>>>        fsstress workload.
>>>>>>
>>>>>> The workload is:
>>>>>>
>>>>>>        $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt -v > /tmp/fsst=
ress
>>>>>>
>>>>>> Which I can reliably reproduce the problem locally, around 1/50
>>>>>> possibility.
>>>>>> In my particular case, it results data corruption at root 5 inode 2=
83
>>>>>> offset 8192.
>>>>>>
>>>>>> Then I added some trace points for the following functions:
>>>>>>
>>>>>> - btrfs_do_write_iter()
>>>>>>      Two trace points, one before btrfs_direct_write(), and one
>>>>>>      before btrfs_buffered_write(), outputting the aligned and unal=
igned
>>>>>>      write range, root/inode number, type of the write (buffered or
>>>>>>      direct).
>>>>>>
>>>>>> - btrfs_finish_one_ordered()
>>>>>>      This is where btrfs inserts its ordered extent into the subvol=
ume
>>>>>>      tree.
>>>>>>      This happens when a range of pages finishes its writeback.
>>>>>>
>>>>>> Then here comes the fsstress log for inode 283 (no btrfs root numbe=
r):
>>>>>>
>>>>>> 0/22: clonerange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>>>> [307200,0]
>>>>>> 0/23: copyrange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>>>> [1058819,0]
>>>>>> 0/25: write d0/f2[283 2 0 0 0 0] [393644,88327] 0
>>>>>> 0/29: fallocate(INSERT_RANGE) d0/f3 [283 2 0 0 176 481971]t 884736
>>>>>> 585728 95
>>>>>> 0/30: uring_write d0/f3[283 2 0 0 176 481971] [1400622, 56456(res=
=3D56456)] 0
>>>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[283 2 308134 176323=
6 320
>>>>>> 1457078] return 25, fallback to stat()
>>>>>> 0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 3=
20
>>>>>> 1457078] return 25, fallback to stat()
>>>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384]=
 0
>>>>>> 0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 4=
96
>>>>>> 1457078] return 25, fallback to stat()
>>>>>> 0/38: dwrite d0/f3[283 2 308134 1763236 496 1457078] [2084864,36864=
] 0
>>>>>> 0/39: write d0/d4/f6[283 2 308134 1763236 496 2121728] [2749000,601=
39] 0
>>>>>> 0/40: fallocate(ZERO_RANGE) d0/f3 [283 2 308134 1763236 688 2809139=
]t
>>>>>> 3512660 81075 0
>>>>>> 0/43: splice d0/f5[293 1 0 0 1872 2678784] [552619,59420] -> d0/f3[=
283 2
>>>>>> 308134 1763236 856 3593735] [5603798,59420] 0
>>>>>> 0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [283 1 308134 1763236 9=
76
>>>>>> 5663218]t 1361821 480392 0
>>>>>> 0/49: clonerange d0/f3[283 1 308134 1763236 856 5663218] [2461696,5=
3248]
>>>>>> -> d0/f5[293 1 0 0 1872 2678784] [942080,53248]
>>>>>>
>>>>>> Note one thing, there is no direct/buffered write into inode 283 of=
fset
>>>>>> 8192.
>>>>>>
>>>>>> But from the trace events for root 5 inode 283:
>>>>>>
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D393216(3936=
44)
>>>>>> len=3D90112(88327)
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D1396736(140=
0622)
>>>>>> len=3D61440(56456)
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D708608(7091=
21)
>>>>>> len=3D12288(7712)
>>>>>>
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D8192(8192)
>>>>>> len=3D73728(73728) <<<<<
>>>>>>
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D589824(589824=
)
>>>>>> len=3D16384(16384)
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D8192 len=3D7372=
8
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D589824 len=3D16=
384
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D2084864(20848=
64)
>>>>>> len=3D36864(36864)
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2084864 len=3D3=
6864
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D2748416(274=
9000)
>>>>>> len=3D61440(60139)
>>>>>>     btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D5603328(560=
3798)
>>>>>> len=3D61440(59420)
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D393216 len=3D90=
112
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D708608 len=3D12=
288
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D1396736 len=3D6=
1440
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D3592192 len=3D4=
096
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2748416 len=3D6=
1440
>>>>>>     btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D5603328 len=3D6=
1440
>>>>>>
>>>>>> Note that phantom direct IO call, which is in the corrupted range.
>>>>>>
>>>>>> If paired with fsstress, that phantom write happens between the two
>>>>>> operations:
>>>>>>
>>>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384]=
 0
>>>>>
>>>>> Just to be more accurate, there is a 0/33 operation, which is:
>>>>>
>>>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[285 2 308134 1763236=
 320
>>>>> 1457078] return 25, fallback to stat()
>>>>> 0/33: awrite - io_getevents failed -4
>>>>>
>>>>> The failed one doesn't have inode number thus it didn't get caught b=
y grep.
>>>>>
>>>>> Return value -4 means -INTR, not sure who sent the interruption.
>>>>> But if this interruption happens before the IO finished, we can call
>>>>> free() on the buffer, and if we're unlucky enough, the freed memory =
can
>>>>> be re-allocated for some other usage, thus modifying the pages befor=
e
>>>>> the writeback finished.
>>>>>
>>>>> I think this is the direct cause of the data corruption, page
>>>>> modification before direct IO finished.
>>>>>
>>>>> But unfortunately I still didn't get why the interruption can happen=
,
>>>>> nor how can we handle such interruption?
>>>>> (I guess just retry?)
>>>>
>>>> It's because you are mixing aio/io_uring, and the default settings fo=
r
>>>> io_uring is to use signal based notifications for queueing task_work.
>>>> This then causes a spurious -EINTR, which stops your io_getevents()
>>>> wait. Looks like this is a bug in fsstress, it should just retry the
>>>> wait if this happens. You can also configure the ring to not use sign=
al
>>>> based notifications, but that bug needs fixing regardless.
>>>
>>> Something like this will probably fix it.
>>>
>>>
>>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>>> index 6641a525fe5d..05fbfd3f8cf8 100644
>>> --- a/ltp/fsstress.c
>>> +++ b/ltp/fsstress.c
>>> @@ -2072,6 +2072,23 @@ void inode_info(char *str, size_t sz, struct st=
at64 *s, int verbose)
>>>                 (long long) s->st_blocks, (long long) s->st_size);
>>>    }
>>>
>>> +static int io_get_single_event(struct io_event *event)
>>> +{
>>> +    int ret;
>>> +
>>> +    do {
>>> +        /*
>>> +         * We can get -EINTR if competing with io_uring using signal
>>> +         * based notifications. For that case, just retry the wait.
>>> +         */
>>> +        ret =3D io_getevents(io_ctx, 1, 1, event, NULL);
>>> +        if (ret !=3D -EINTR)
>>> +            break;
>>> +    } while (1);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>>    void
>>>    afsync_f(opnum_t opno, long r)
>>>    {
>>> @@ -2111,7 +2128,7 @@ afsync_f(opnum_t opno, long r)
>>>            close(fd);
>>>            return;
>>>        }
>>> -    if ((e =3D io_getevents(io_ctx, 1, 1, &event, NULL)) !=3D 1) {
>>> +    if ((e =3D io_get_single_event(&event)) !=3D 1) {
>>>            if (v)
>>>                printf("%d/%lld: afsync - io_getevents failed %d\n",
>>>                       procid, opno, e);
>>> @@ -2220,10 +2237,10 @@ do_aio_rw(opnum_t opno, long r, int flags)
>>>        if ((e =3D io_submit(io_ctx, 1, iocbs)) !=3D 1) {
>>>            if (v)
>>>                printf("%d/%lld: %s - io_submit failed %d\n",
>>> -                   procid, opno, iswrite ? "awrite" : "aread", e);
>>> +                    procid, opno, iswrite ? "awrite" : "aread", e);
>>>            goto aio_out;
>>>        }
>>> -    if ((e =3D io_getevents(io_ctx, 1, 1, &event, NULL)) !=3D 1) {
>>> +    if ((e =3D io_get_single_event(&event)) !=3D 1) {
>>>            if (v)
>>>                printf("%d/%lld: %s - io_getevents failed %d\n",
>>>                       procid, opno, iswrite ? "awrite" : "aread", e);
>>>
>> Exactly what I sent for fsstress:
>> https://lore.kernel.org/linux-btrfs/20230820010219.12907-1-wqu@suse.com=
/T/#u
>
> It's not really, as you only did the one case of io_getevents(). What
> happens if the other one gets EINTR and aborts, now we do a rw operation
> and the first event returned is the one from the fsync?

Oh my bad, forgot there is another one.

Would fix it in the next update.

Thanks,
Qu
>
> You should not just fix up the one that you happened to hit, fix up both
> of them.
>
