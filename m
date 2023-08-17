Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7C377EEA0
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 03:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbjHQBTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 21:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347491AbjHQBTQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 21:19:16 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56AE2723;
        Wed, 16 Aug 2023 18:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692235152; x=1692839952; i=quwenruo.btrfs@gmx.com;
 bh=DCx0IYb1ePlWeopq9sftleSqX/iPB12vHQ0xRU+WCtM=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=rgyuHwjaw8F66Ccn5TeJvbn9tORtzXd0ObfWUuNnKQIRRvXr0QoSDEPTmtb6mdG33eGU9aj
 1JuDms+9eW1oyyeiiNWoNeSQAF3GJSXBqAnGU+vGQHj0Gar9A4rj2DziWpzX7B0+QTyLW2g1G
 s+mN0GiiR/1kmS7EKfLv1+vrOQuAbesAur/KDRV8nnZQHkGHO7AqjFdFQW6tMp9qkeEPHrZ3j
 tLx17QEzP9YKMBMkdVqc9zyM7Y8526AeaRHknh9rX6thklLNlXUfVyKdwi41cHsTKxADRHvzw
 KMZavK5m2x5T8DSYX7mruBcmp8982WW9zMLVSBtzo19FUecK9HVw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MA7KU-1qdZTh2qh0-00BfC1; Thu, 17
 Aug 2023 03:19:12 +0200
Message-ID: <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
Date:   Thu, 17 Aug 2023 09:19:21 +0800
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
In-Reply-To: <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Gr3jlEKrs4PD1wfF/1QIbVUdjjCSPWjWQQerWu1vuLsJ9lZrNqx
 sGz/lMP3tdIx+DSaeKZHtnqaFj9reLLEQ9XMu7sy1d3lzP7RikNfroiQvDwiNN9wbwMIXHj
 FKeW1xpxmsN5NH+0tEQ+13OoZfZLnXk8c74Pl6eGX7PGQrN/DE8vb/JMT3a67nQ/BSgnTRC
 NO6IwC8ryjXOiVzIH3avw==
UI-OutboundReport: notjunk:1;M01:P0:gGmc3fPwwZQ=;ycFcHQFUTl3VhvsIR03WjUY3pXf
 ysHDpgh2eU8TCHRjOTxtFt2OxyOAW5jJOv0ra/CXtYvY1bt/1Ext2he9Wy77SMuoNDxNlaJ2+
 LWkaw+1cekLVmPZr0WncTT/YJk37vzpnLgEi4B7qsKlbbAZfHRpT7blNFg1z2Oqi7fkdTuI7+
 TkdSq6H/F9mXRWVhChMfXVfcGKnS0T5Ts/jysosNlRD6ljfsOvomlPfhlIvsgAoo3Y5/PJNCN
 GVPSgJUECsznkRNcNkPcngbjDzg6807YjjoW/H42xhD/U7olXfFBMjELm/WwI7FP/wpCSOKI1
 aoPfmeV04hKxQlK1rsIztJrVuVkzBd83DG3uNz7JdF3jUmUtX/gAVr0uZQYqCtu9pG1EyZLOK
 qtcZS1r6RZikWct2q9eOXvRCUGieSe4q+LxB4Ai6bUpHv7F385w9f45/ZOzHqtwHwH4AUnJPC
 EMkDvStbQd1Rq6BepIcJy/qcGpPh/agWEiepoKe9TFdr6JHQMx8ijgZvY1LdTqAdX8ecG2G3I
 dfDEpo3DTygUSpSBtMcUfBLlQOiPhrJuQnRYPX5KC3VP8HJDlco7vFezuidbYmEnAuWzp1SYs
 SHh/kr8b1g4K/NtiBRixYF2CxXKONW7gO5t/DYosKaEKNhhZZb8HmXkuuHk2H+biGGK0JhMcs
 kTK2CiQyLPY9M6x4tlQx1INImSBIRbpDtGuMMEELx24r2Ytrs6zhsan8mRvpaOBL+J49lfTst
 CD0YXXwzZoypdTr7H8VMbiFRpXwpiM9+Ja7yBgytCfcA+j1viw4iuj9y/ChO0AkEWJrWIzWJX
 2HnoelESNB3pHRLuQnf2SZS4WiKFNy0r0S8SQ5cDXJO6T/fG46Q93O8PIoGxHlbs8CprdYu3R
 XNYaVwmwdWOtGr60wSZ14RvzeXOqUo4Mb5iafWnR00MI7EnKIpZpgSIwwhSbpnXnpsP3CYfFR
 BvZbsAS9+X8z6hBbChF3A1MmxKw=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/17 09:12, Jens Axboe wrote:
> On 8/16/23 7:05 PM, Qu Wenruo wrote:
>>
>>
>> On 2023/8/17 06:28, Jens Axboe wrote:
>> [...]
>>>
>>>>> 2) What's the .config you are using?
>>>>
>>>> Pretty common config, no heavy debug options (KASAN etc).
>>>
>>> Please just send the .config, I'd rather not have to guess. Things lik=
e
>>> preempt etc may make a difference in reproducing this.
>>
>> Sure, please see the attached config.gz
>
> Thanks
>
>>> And just to be sure, this is not mixing dio and buffered, right?
>>
>> I'd say it's mixing, there are dwrite() and writev() for the same file,
>> but at least not overlapping using this particular seed, nor they are
>> concurrent (all inside the same process sequentially).
>>
>> But considering if only uring_write is disabled, then no more reproduce=
,
>> thus there must be some untested btrfs path triggered by uring_write.
>
> That would be one conclusion, another would be that timing is just
> different and that triggers and issue. Or it could of course be a bug in
> io_uring, perhaps a short write that gets retried or something like
> that. I've run the tests for hours here and don't hit anything, I've
> pulled in the for-next branch for btrfs and see if that'll make a
> difference. I'll check your .config too.

Just to mention, the problem itself was pretty hard to hit before if
using any debug kernel configs.

Not sure why but later I switched both my CPUs (from a desktop i7-13700K
but with limited 160W power, to a laptop 7940HS), dropping all heavy
debug kernel configs, then it's 100% reproducible here.

So I guess a faster CPU is also one factor?

>
> Might not be a bad idea to have the writes contain known data, and when
> you hit the failure to verify the csum, dump the data where the csum
> says it's wrong and figure out at what offset, what content, etc it is?
> If that can get correlated to the log of what happened, that might shed
> some light on this.
>
Thanks for the advice, would definitely try this method, would keep you
updated when I found something valuable.

Thanks,
Qu
