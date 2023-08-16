Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B35277EC27
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346635AbjHPVq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 17:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346706AbjHPVqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 17:46:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F92D4F;
        Wed, 16 Aug 2023 14:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692222369; x=1692827169; i=quwenruo.btrfs@gmx.com;
 bh=2l1gpWue0h1gVN88bh9qkNPY1uHRSMUusxscTwiFi28=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=BelMTPSidnMrXxXk2pB7xyzyyMvYXAJyqksbZTrOFLnyXBpo+L1dBQxSq9A8fzbzredN80E
 VfCvKJAqeQJWfCq2+yq0EEJ/BBDoWJGGKz4kMkIGOM2hdhR20dKZ/75ebq+nEEjUtna5gxAd2
 3boJ6yF9ZHGedscSqa8lY08S1/dZFx/nyaZijmJj991ISWdi8gK2Zv/ba4AguBhYaAqRHtPMo
 0ZcGMFYtcx46B3N+3OrcnI6zWNzlRF+J2NzV6LC3wFedrLGaUwYoTa07dQ/Rz3JeXjja3AgFu
 3ZTHTxLVM1VwF/AYoTxcyw59cPJ9odEUeROmUkTm/Hg8Yqpw7eGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MYNJq-1qJiuA2KDC-00VSAV; Wed, 16
 Aug 2023 23:46:09 +0200
Message-ID: <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
Date:   Thu, 17 Aug 2023 05:46:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
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
In-Reply-To: <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lz4MSppe2DDvlLm+liCUI2w0+seUH4DJ9bg/fnPSGBSClmfQ8Cx
 7JKS6QY5LIQIi6j+jga8N/JCE46r5GojUef1R7Lwn+LdEEWGO8KXhCknPvgkM8RrpTEW3SK
 CQDsjjUNQHaJNq2wctsaaiERHFLMBLnw4Ds4lGF8iZo8K6qDmcrFhnSJnbqG+vJ5NxT3c5n
 v72+5UFiz0qmBFzAVsAhg==
UI-OutboundReport: notjunk:1;M01:P0:f+enb+2MLqE=;bhBbmhJUYSh8tP3xGTeF1mL2LJj
 CaM33GRClsI+63M9sawyzgpzbtR3iY+83iKDAfDYy0oYPSyCTFGNXTvyLYKMo+Cg0/w3Hjv5B
 33yFROnBRbvCk3SRHNkuaRhtKAId/YiHSL3UN5Gmv0DfD3FGVb4MH8Cimh5ZEZkeB54VK5BqL
 544wTm/w3bqJgsCvecz37V8KU0/ytm4f9KrWCv5nLx/xo0/n+dO4ml0KB1m6nwomIpN++H5x1
 MXk8A5lKkuwuovva2TSzWKlCmCPpREFJ4sm9MXQN/ie0pQYNv0S4w2HPLYy5ljfl3ZvlQTc9k
 GTCftRYGnPFbqtmWsjOXmUcHTBIhAg6DNBJecuIyEumDqNSEK4EaShOeU2zrwoLGBGD0KWVRk
 9aYD3muz2o7ukYGZXUNTMvCmhW8HXgeILLpXzHmoCVg/o1bptLCLANu7mzAWRDtqk8YPrC3O/
 eg5T5Me8nVAoA3gd0pmMjWdTSinK4iXKL7p7GKIXa5pNDgMKyWqLR95xhjzBrSte15yqhBSBr
 Yxj6iPI+jpLEqiU1vurLRv0eBSYndTv2lX7f45/cppan46Y/BR3pP0BnzD1lmz4FkIracgmHS
 M9yB/pCu5uSUN8YbbyYm7iMifvFIoBM4pFgCGYDmdgTH8/v6U93OOmtY5gYnFl/wT768gOIZH
 2MSqD4SmNvjWi4XED2H41Eg5tdz72E32iqhVE4XBZuC7KEqlPA7SpAHUR/kKj4VFHT5KfNW/t
 cQepJvIbCONL8+fuAtioWP2AChJeqaiGpIzaPDZF1bfa/miwZbxDCkFt9rcH9NnIzCp7+eh0x
 /Zr//mCiHgE0ZCo/bI8nAsJvXCiamBmJHhucMWp8cMrR14EVs1fx078HyUQLkW5pyBzW/Hgqx
 60Z9YRcEZ10Q1Q0Uwv6hVf1sJA+kpKFpqvARWjR1Yak21u1GBERCb8/gOBd9ZPgHpoAQ0Zx9T
 zvpm9tVK4X8T92Rq9Yw5mWsRMhg=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/16 22:33, Jens Axboe wrote:
> On 8/16/23 12:52 AM, Qu Wenruo wrote:
>> Hi,
>>
>> Recently I'm digging into a very rare failure during btrfs/06[234567],
>> where btrfs scrub detects unrepairable data corruption.
>>
>> After days of digging, I have a much smaller reproducer:
>>
>> ```
>> fail()
>> {
>>          echo "!!! FAILED !!!"
>>          exit 1
>> }
>>
>> workload()
>> {
>>          mkfs.btrfs -f -m single -d single --csum sha256 $dev1
>>          mount $dev1 $mnt
>>      # There are around 10 more combinations with different
>>          # seed and -p/-n parameters, but this is the smallest one
>>      # I found so far.
>>      $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt
>>      umount $mnt
>>      btrfs check --check-data-csum $dev1 || fail
>> }
>> runtime=3D1024
>> for (( i =3D 0; i < $runtime; i++ )); do
>>          echo "=3D=3D=3D $i / $runtime =3D=3D=3D"
>>          workload
>> done
>> ```
>
> Tried to reproduce this, both on a vm and on a real host, and no luck so
> far. I've got a few followup questions as your report is missing some
> important info:

You may want to try much higher -p/-n numbers.

For verification purpose, I normally go with -p 10 -n 10000, which has a
much higher chance to hit, but definitely too noisy for debug.

I just tried a run with "$fsstress -p 10 -n 10000 -w -d $mnt" as the
workload, it failed at 21/1024.

>
> 1) What kernel are you running?

David's misc-next branch, aka, lastest upstream tags plus some btrfs
patches for the next merge window.

Although I have some internal reports showing this problem quite some
time ago.

> 2) What's the .config you are using?

Pretty common config, no heavy debug options (KASAN etc).

>
>> At least here, with a VM with 6 cores (host has 8C/16T), fast enough
>> storage (PCIE4.0 NVME, with unsafe cache mode), it has the chance aroun=
d
>> 1/100 to hit the error.
>
> What does "unsafe cche mode" mean?

Libvirt cache option "unsafe"

Which is mostly ignoring flush/fua commands and fully rely on host fs
(in my case it's file backed) cache.

> Is that write back caching enabled?
> Write back caching with volatile write cache? For your device, can you
> do:
>
> $ grep . /sys/block/$dev/queue/*
>
>> Checking the fsstress verbose log against the failed file, it turns out
>> to be an io_uring write.
>
> Any more details on what the write looks like?

For the involved file, it shows the following operations for the minimal
reproducible seed/-p/-n combination:

```
0/24: link d0/f2 d0/f3 0
0/29: fallocate(INSERT_RANGE) d0/f3 [276 2 0 0 176 481971]t 884736 585728 =
95
0/30: uring_write d0/f3[276 2 0 0 176 481971] [1400622, 56456(res=3D56456)=
] 0
0/31: writev d0/f3[276 2 0 0 296 1457078] [709121,8,964] 0
0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[276 2 308134 1763236 320
1457078] return 25, fallback to stat()
0/34: dwrite d0/f3[276 2 308134 1763236 320 1457078] [589824,16384] 0
0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[276 2 308134 1763236 496
1457078] return 25, fallback to stat()
0/38: dwrite d0/f3[276 2 308134 1763236 496 1457078] [2084864,36864] 0
0/40: fallocate(ZERO_RANGE) d0/f3 [276 2 308134 1763236 688 2809139]t
3512660 81075 0
0/43: splice d0/f5[289 1 0 0 1872 2678784] [552619,59420] -> d0/f3[276 2
308134 1763236 856 3593735] [5603798,59420] 0
0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [276 1 308134 1763236 976
5663218]t 1361821 480392 0
0/49: clonerange d0/f3[276 1 308134 1763236 856 5663218] [2461696,53248]
-> d0/f5[289 1 0 0 1872 2678784] [942080,53248]
```

>
>> And with uring_write disabled in fsstress, I have no longer reproduced
>> the csum mismatch, even with much larger -n and -p parameters.
>
> Is it more likely to reproduce with larger -n/-p in general?

Yes, but I use that specific combination as the minimal reproducer for
debug purposes.

>
>> However I didn't see any io_uring related callback inside btrfs code,
>> any advice on the io_uring part would be appreciated.
>
> io_uring doesn't do anything special here, it uses the normal page cache
> read/write parts for buffered IO. But you may get extra parallellism
> with io_uring here. For example, with the buffered write that this most
> likely is, libaio would be exactly the same as a pwrite(2) on the file.
> If this would've blocked, io_uring would offload this to a helper
> thread. Depending on the workload, you could have multiple of those in
> progress at the same time.

My biggest concern is, would io_uring modify the page when it's still
under writeback?
In that case, it's going to cause csum mismatch as btrfs relies on the
page under writeback to be unchanged.

Thanks,
Qu

>
