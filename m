Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C7B77DAB5
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 08:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbjHPGwo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 02:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjHPGwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 02:52:14 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E82F1BCC;
        Tue, 15 Aug 2023 23:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692168730; x=1692773530; i=quwenruo.btrfs@gmx.com;
 bh=kdfHFwX6W/1/pxRlOfMixchnxBbohs3pHE0RZfAcB3U=;
 h=X-UI-Sender-Class:Date:To:From:Subject;
 b=nS0cGIwcNgrT1cZJNwDQpM55s9oXwzd1a8uUHaick+XTcZ+BltCHEiAiyOyfWcyCYefsyOy
 wOfAGOUXQoALUteDNo+6AyRXMJTWpe37yCIiOVhHXwTYVHRpXsc/VG9Elnh38B6cOVpUbKDhk
 Jy7uV6wddLdwRq59roj87Va6ahUc7G1J0j11w8/Suf17/pJHnL/LxQtGigrOhtmCX4uoSM3YL
 gkB/mvEwUUOQ+iDm4LtQQPZVQLY1iNzkdsTvuONTKG2PUmn+UJmG5KEBLPTdFQIFuBRPnx5hW
 Z5K71kF+QdaZx5BM2pDgYpOcrc9jIo3c39GN9IcLg8Z6WUuRyiiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mj8qj-1prs1H0EYX-00f76T; Wed, 16
 Aug 2023 08:52:10 +0200
Message-ID: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
Date:   Wed, 16 Aug 2023 14:52:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Possible io_uring related race leads to btrfs data csum mismatch
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9W+ZYEazh9DwQgMjukStFb1wErN29C4Vt1pBoEYSeXIe7pdYsXO
 9apJzNFEJDOO8uq9KFPpy1utiBOi7vDkb5345+3x8hl9zlohPjIBk1KmuplWl+aolASNDrn
 NJK2hZmTWooAKYvamLk4bi562/GNxQrP+xbVvFILA4Z1yVkuwS01uBOi6xyy9i3RBjDdMhm
 Ym3U/m4EpUfFhmWOvO/oA==
UI-OutboundReport: notjunk:1;M01:P0:MR1Iat2Jwvw=;IgSDXL3vuKjOsZV7b4RUWTadMxh
 dUM7z6y8pvft1YmOQU6A7HPiw6M2r9lBbeqc54Kk3PuJmWnCUzAQadGlJvZyDlOMFGWtTfRMe
 07bBWRSG0S1XqvsDBRORrkQfzo6O7mG6OrO0xBOLSA/TJK7zko893vKTJSNf65UOagbJfDLy1
 20JOWJorSv6BdBdelrTr/cKR3XujDsZkNTKH3YlZTjjQ2dzwGQn1unjAoDWyJOMs/OeFj2+n+
 tc4vGCmsK3eMXZAs/N1wy8Sot1+FvKx4nQwdpCtkcMCw1JQgBg1ty9HpdDFv+rkdmm66X/ruV
 87UItsFwXknLp2uE4lmUl7zQudcF5wCh3tBW9mlvKnXPriWusS9GQ3YXCE81A2fQbeIBeIoKX
 4aUIW9WhqzZyEXx683+j0U9p7yzr4KzNY0aFIQZa8ltTDN24wEXJcuxazxF5EPh6t8jiMLsNC
 NH+dOu+tEfYSkY5BWubNfzPNHwLkZskk9K/iRGNId+lM4g9QKISlRSK/kwoVsn2wGDKyJnxGW
 PO94qx/nKwcH4FaJSbxFdRkP9ZSnt1kvr7Fei8gG+gNYWE5F11ugiZQ1yRl527ILq81xDo17q
 8EwtcHKgPv+eIvGbykLHtzJn8fpJ++gDUAoiHE0TAeHoR2lm2L757N4rJqgmUTZ8Xyt7Zvbkn
 v0GpCV+F3EEfXDN/mMX/gNgll4xkyPVX2qb+mPEMkbLmtptkL04NcjLEl4qG67avEZvKpJNGt
 KhKcINvZWlUr3C0Unan6K64zAs/O+Cer2H9j4CB9Mgk+1wu1qjmHW9g6SFr+HEziaPF/dkRu+
 Hh5j1BlSkoFlHko6CVIQMGE7tB97P+WNn7ADygkMqA8vyUK8fItDqiFHrR7GTidIUcLFlqHD1
 VOjDV0wckKb8xjEd1xPfVIHkT99v0ZsbZwzhRDkfY4uMTaiSpU98RJfycsc25c9lKJNDd9aXW
 NdQiwmmjsU83NahYT5phOSWTNvc=
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

Hi,

Recently I'm digging into a very rare failure during btrfs/06[234567],
where btrfs scrub detects unrepairable data corruption.

After days of digging, I have a much smaller reproducer:

```
fail()
{
         echo "!!! FAILED !!!"
         exit 1
}

workload()
{
         mkfs.btrfs -f -m single -d single --csum sha256 $dev1
         mount $dev1 $mnt
	# There are around 10 more combinations with different
         # seed and -p/-n parameters, but this is the smallest one
	# I found so far.
	$fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt
	umount $mnt
	btrfs check --check-data-csum $dev1 || fail
}
runtime=3D1024
for (( i =3D 0; i < $runtime; i++ )); do
         echo "=3D=3D=3D $i / $runtime =3D=3D=3D"
         workload
done
```

At least here, with a VM with 6 cores (host has 8C/16T), fast enough
storage (PCIE4.0 NVME, with unsafe cache mode), it has the chance around
1/100 to hit the error.

Checking the fsstress verbose log against the failed file, it turns out
to be an io_uring write.

And with uring_write disabled in fsstress, I have no longer reproduced
the csum mismatch, even with much larger -n and -p parameters.

However I didn't see any io_uring related callback inside btrfs code,
any advice on the io_uring part would be appreciated.

Thanks,
Qu
