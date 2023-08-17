Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A160977EEBD
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 03:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347530AbjHQBbg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 21:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345962AbjHQBbT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 21:31:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C718B271E;
        Wed, 16 Aug 2023 18:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692235874; x=1692840674; i=quwenruo.btrfs@gmx.com;
 bh=RNWCPhgP7R/t9efmK1JNcPDcVY+p4IZqdDEJswxW8LI=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=evvCp3527tzv4tE3QWRb+uViLmoy5EkDSSiiKO6nT67BZ957UBr5ievJTB057ty8vC83cWy
 hUeYa2ouJkeLw3/3VEdmrrc1aDdFSl4YRItBCtIuyDAeyfGTGNzP+W014w/8Y6p85WtU35HoD
 QJmhnliCAh5RZykHO5hhJr9TWjqFlYPeVVEjheXWmthi2Qkb6ujKAgQQNfXAU9KkvjKayW2B0
 zZ6s+Zw+BPIAgPMQ8DTzmH13dAu4WQP2bJrVuPL7uh2mUpqiUUwbsQLEFIzbT2prz/UhGiTqE
 ClvQQH2AR1WRE38mCCozsnBg8o9EJanucpuZANM0J4ZKFhEGqWYw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N6KYl-1phaQ703vV-016jrl; Thu, 17
 Aug 2023 03:31:14 +0200
Message-ID: <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
Date:   Thu, 17 Aug 2023 09:31:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
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
In-Reply-To: <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lJzbSmNfluxZyxnIsKqQ0RBKBKE1lXYaibzUAFb8kIcmXzovUgA
 bNAbjEcYxjSccT2Ywmw81uwcz71B8qs+zfCl/oqGaB8gFKtKFYF/PDqQN3LvyhwAqc/9kM8
 P2LKSiPiqr+2rnnQeF8/qVJAwwrPB4FOuN0AIjQiWLf/2U6EmlBX3r6VPPGfr8jhPG6vbLW
 GNFzVW5a7Jafu273Puo7A==
UI-OutboundReport: notjunk:1;M01:P0:sr4RHRpsnzw=;7mXh2bw1b7/GN8QlGgQP3DQClAe
 CX3HzHWi8pRpT4hvNl1XoDITBSrS3D6QlYVjOhpZtieNu8N1dE7iRvLZtwoyc3tV+izBYMfvC
 77McIUGU8BWLwI4IqaacESZPu1TCvUG0yEMbk1JIcuBYP8JGIesO74hvpVf3lmRX+w8gB7AJg
 dzZxvJPdYx6m7nW/syNTnqUJYV51xdu3oN5G7oJ443owZmpg3IwnHdd5ppQmwAMOungZXCh5P
 R8mrjp7hNFvzNyVB1KkOyAsu/Yx9mKxH1L/pLuITTRBpKvrtO8YRVUXghX49idSXfuQ+zBLSR
 GIgMjjrdSgCXnpMW97sedOMqffjoIEmQRbzokplnUBrSqKNcJyWFsx8Ac0xk5BkLJCjeGz8Wb
 bcu3BP/NxCc+Tru4d+WgvzyZvpxoSeJ3IGzlRaJ8yDaAFD6Eo0UtxRvW75gdw7pUaIlreEvpM
 q5wju1p1E0oHbvnRFH2xNAXzAkYp8kGmEcBTnxhJLYdTqIQjzc9gsTs2c2H8MC6TErN+k84b3
 c224xsQznc5zHtD2hlQpTABCgmvcjFuO+Podznnz2AYX+QlMILCVLfvISP4zcuk05HoBFhwQB
 LeD33jaslzuDk39PrrvkxVQ7VpZJmGsr5uQK01nv5w5pGBN3EFA/Zv9LSuedqc+ArTIxx1XLO
 4nARhw6fowTjGNllbZgMG9F9+Ed4loGcLpwjPr6hbBoqfDhHfwAoj7lisDuRXzNH9FhwoG3Pl
 voNsjjVcA9RxIdOmpRzmkUDigAfVzw18XstEYJWwAapaq+Lxp6gRn/HJQI42qDSo5X9313WE5
 BgSl/SlLOwppLhaG0+/hasxFyGuAptA0j/pRpVHplW4WDDd/mNVpS5uULnHkNuCOIJp8hFZUV
 Yg4VpQ48gadKahFyzXoYUTtsRMrpQjwxcacYkgHDX3oEyXnylvdAeG/cllm6+s82RBH0sX6bL
 qGJZA0W9h5H8gYdcXkF6DiJoaYk=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/17 09:23, Jens Axboe wrote:
> On 8/16/23 7:19 PM, Qu Wenruo wrote:
>> On 2023/8/17 09:12, Jens Axboe wrote:
>>> On 8/16/23 7:05 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2023/8/17 06:28, Jens Axboe wrote:
>>>> [...]
>>>>>
>>>>>>> 2) What's the .config you are using?
>>>>>>
>>>>>> Pretty common config, no heavy debug options (KASAN etc).
>>>>>
>>>>> Please just send the .config, I'd rather not have to guess. Things l=
ike
>>>>> preempt etc may make a difference in reproducing this.
>>>>
>>>> Sure, please see the attached config.gz
>>>
>>> Thanks
>>>
>>>>> And just to be sure, this is not mixing dio and buffered, right?
>>>>
>>>> I'd say it's mixing, there are dwrite() and writev() for the same fil=
e,
>>>> but at least not overlapping using this particular seed, nor they are
>>>> concurrent (all inside the same process sequentially).
>>>>
>>>> But considering if only uring_write is disabled, then no more reprodu=
ce,
>>>> thus there must be some untested btrfs path triggered by uring_write.
>>>
>>> That would be one conclusion, another would be that timing is just
>>> different and that triggers and issue. Or it could of course be a bug =
in
>>> io_uring, perhaps a short write that gets retried or something like
>>> that. I've run the tests for hours here and don't hit anything, I've
>>> pulled in the for-next branch for btrfs and see if that'll make a
>>> difference. I'll check your .config too.
>>
>> Just to mention, the problem itself was pretty hard to hit before if
>> using any debug kernel configs.
>
> The kernels I'm testing with don't have any debug options enabled,
> outside of the basic cheap stuff. I do notice you have all btrfs debug
> stuff enabled, I'll try and do that too.
>
>> Not sure why but later I switched both my CPUs (from a desktop i7-13700=
K
>> but with limited 160W power, to a laptop 7940HS), dropping all heavy
>> debug kernel configs, then it's 100% reproducible here.
>>
>> So I guess a faster CPU is also one factor?
>
> I've run this on kvm on an apple m1 max, no luck there. Ran it on a
> 7950X, no luck there. Fiddling config options on the 7950 and booting up
> the 7763 two socket box. Both that and the 7950 are using gen4 optane,
> should be plenty beefy. But if it's timing related, well...

Just to mention, the following progs are involved:

- btrfs-progs v6.3.3
   In theory anything newer than 5.15 should be fine, it's some default
   settings change.

- fsstress from xfstests project
   Thus it's not the one directly from LTP

Hopes this could help you to reproduce the bug.

Thanks,
Qu

>
>>> Might not be a bad idea to have the writes contain known data, and whe=
n
>>> you hit the failure to verify the csum, dump the data where the csum
>>> says it's wrong and figure out at what offset, what content, etc it is=
?
>>> If that can get correlated to the log of what happened, that might she=
d
>>> some light on this.
>>>
>> Thanks for the advice, would definitely try this method, would keep you
>> updated when I found something valuable.
>
> If I can't reproduce this, then this seems like the best way forward
> indeed.
>
