Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51EB7820F5
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 02:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbjHUAir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Aug 2023 20:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjHUAir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Aug 2023 20:38:47 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A97A3;
        Sun, 20 Aug 2023 17:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692578321; x=1693183121; i=quwenruo.btrfs@gmx.com;
 bh=SgLLAXq/0ypHadjnFbpIe9iUpUEdMtrd5UnUTbcTORE=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=PZqFyNZE2iyxPjhX1dwzgQGDaxp1EKFvfZ0a4KMf1++NPzn8nrpg0fswzD/+f/9M8A3FfUf
 1mFUGJdZKlT7JNVZM7ScIlGOViZidXDpz0U0GlgCtaGA92iWfi9DcXnUMW7hBqLI40aetXCf4
 TrF1+gZIStKX0bpTWjuuOwQ1hbqh+zNjMjHV4JCRusaXEsOfX7wXoTQFJJaTON2223U4sGOnI
 lIGeEtQddSvk6NrkqgVkfnZcudZ+fU8eHOiKyKlBnm68N2R92HY+FMV4kZ2o9w5P63/dLYcFz
 dAXei5js0BBInuLMD9r792BZUFagPc7USi6fPZB1hJFm6O1gneaw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MN5eX-1qHjfR4AHV-00Iyr3; Mon, 21
 Aug 2023 02:38:41 +0200
Message-ID: <71feba44-9b2c-48cd-9fe3-9f057145588f@gmx.com>
Date:   Mon, 21 Aug 2023 08:38:37 +0800
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
In-Reply-To: <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SecN7RH4/FpJeCcNdlv14Bsd2NP5VpUonwSjKDHjJpEw3hE/eXJ
 g6jVQPEX1yhLisP7X8HE0U8K6b88XDgQcCocxbuQ+emQHDNUvMC0c8A/9ZjLP6+3FgyNC0I
 d3oXXZbVUgRzkAEjUo2zYNtRs0T3u04YcxaGtWW0RfltVQvyftIqjdUXi4Wfob6sobt1qHa
 6kiiHSO4rGY/ucCv95VGg==
UI-OutboundReport: notjunk:1;M01:P0:KWlMwspR0+Q=;sAufzKzirURbXQ5ltLqAQ4UF/VV
 MWVHq7HddKbMco8tH+3E0SSXTiqgLis/YLYYDE0aMPlC/9SiUqK+T2mtZ5YJ6cvEGkJKIjfIk
 NRrZIOwR2YjujJhogVfsHpNkRRxSM7bQTkjVhFR4tji//KBjWrI7xQB99PuHih+0TxC0+t2fa
 Szq65SNOs7C2UkBFois7PqnE+kknn9n32tEjbBtmEOqiL7SUCrt9uwAs0cEVzknxHf3taCVA6
 Z6W/DiNna5ar1rAQNUtSUEHNcCYCnobeGE9UuLdsEn+OJLccNmdFKviSCkTPzU4tJzGZjLAkl
 nCqxRTfjHzJVxmYA7Ovtz2A0bcKHZIt2G29+lPt0ckC8XOBZKBWszZ14nqsV6dGwfVZtTyIKh
 m/Q3Fz6dH3nLAzdD4jlQIojGBzBZxq9AVRR1fDcN3zPq5YO4kwBJux6JETqCqlsdrXWh6xnQj
 Yg2ZmUXYHbC3P8tW6M4JyL0Z882DrhaJ+1Oj76yFS6zSmRCpMJOUQA5wMQ7qrtTK7AWb2NgjI
 bXXMAkFmDbz2Qw91hauanqdZi24QYRl/ENiKojuRyx+dYzH8QdLEwSuGws0NrXg3QK+rURffb
 Wim8jkX7qShAQ7SAaYGOhTnEcVWXD4FSGsPBdb1i/JSx2+notIapl6+iPsfvsUHND5gBHhquk
 xh673cT55dRGlyGUGGerc1Wq4JZrJvHmHeGUajvsb4I2/rL0J8i10eJfI/wwXfL09tXJATAkI
 8A7BYrhPcoI6MngziiN1S21siPBkgjIc7vZX+bOpq8BPehpq68SOpGoESJ0UwJx3LVrwR8URz
 VA7BnmcfUNhXy7R9w2Ug4cRW4elYhEK/RJAbK1esLRFzQIPNjOUlkTTBl1/6TKgfJWtm/cKik
 Nla8Gf/mOs3qTC5Xel9Ky1HQTCUfmuOizfutQzLJ5mReyjZu8vC+i5O+GT7lT6rs5WVJnGO0i
 ZJdEmIJ3TLsYetcANn9hBaha424=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/20 22:11, Jens Axboe wrote:
> On 8/20/23 7:26 AM, Jens Axboe wrote:
>> On 8/19/23 6:22 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2023/8/20 07:59, Qu Wenruo wrote:
>>>> Hi Jens
>>>>
>>>> I tried more on my side to debug the situation, and found a very weir=
d
>>>> write behavior:
>>>>
>>>>       Some unexpected direct IO happened, without corresponding
>>>>       fsstress workload.
>>>>
>>>> The workload is:
>>>>
>>>>       $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt -v > /tmp/fsstres=
s
>>>>
>>>> Which I can reliably reproduce the problem locally, around 1/50
>>>> possibility.
>>>> In my particular case, it results data corruption at root 5 inode 283
>>>> offset 8192.
>>>>
>>>> Then I added some trace points for the following functions:
>>>>
>>>> - btrfs_do_write_iter()
>>>>     Two trace points, one before btrfs_direct_write(), and one
>>>>     before btrfs_buffered_write(), outputting the aligned and unalign=
ed
>>>>     write range, root/inode number, type of the write (buffered or
>>>>     direct).
>>>>
>>>> - btrfs_finish_one_ordered()
>>>>     This is where btrfs inserts its ordered extent into the subvolume
>>>>     tree.
>>>>     This happens when a range of pages finishes its writeback.
>>>>
>>>> Then here comes the fsstress log for inode 283 (no btrfs root number)=
:
>>>>
>>>> 0/22: clonerange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>> [307200,0]
>>>> 0/23: copyrange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>> [1058819,0]
>>>> 0/25: write d0/f2[283 2 0 0 0 0] [393644,88327] 0
>>>> 0/29: fallocate(INSERT_RANGE) d0/f3 [283 2 0 0 176 481971]t 884736
>>>> 585728 95
>>>> 0/30: uring_write d0/f3[283 2 0 0 176 481971] [1400622, 56456(res=3D5=
6456)] 0
>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[283 2 308134 1763236 =
320
>>>> 1457078] return 25, fallback to stat()
>>>> 0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 320
>>>> 1457078] return 25, fallback to stat()
>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
>>>> 0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 496
>>>> 1457078] return 25, fallback to stat()
>>>> 0/38: dwrite d0/f3[283 2 308134 1763236 496 1457078] [2084864,36864] =
0
>>>> 0/39: write d0/d4/f6[283 2 308134 1763236 496 2121728] [2749000,60139=
] 0
>>>> 0/40: fallocate(ZERO_RANGE) d0/f3 [283 2 308134 1763236 688 2809139]t
>>>> 3512660 81075 0
>>>> 0/43: splice d0/f5[293 1 0 0 1872 2678784] [552619,59420] -> d0/f3[28=
3 2
>>>> 308134 1763236 856 3593735] [5603798,59420] 0
>>>> 0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [283 1 308134 1763236 976
>>>> 5663218]t 1361821 480392 0
>>>> 0/49: clonerange d0/f3[283 1 308134 1763236 856 5663218] [2461696,532=
48]
>>>> -> d0/f5[293 1 0 0 1872 2678784] [942080,53248]
>>>>
>>>> Note one thing, there is no direct/buffered write into inode 283 offs=
et
>>>> 8192.
>>>>
>>>> But from the trace events for root 5 inode 283:
>>>>
>>>>    btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D393216(393644)
>>>> len=3D90112(88327)
>>>>    btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D1396736(140062=
2)
>>>> len=3D61440(56456)
>>>>    btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D708608(709121)
>>>> len=3D12288(7712)
>>>>
>>>>    btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D8192(8192)
>>>> len=3D73728(73728) <<<<<
>>>>
>>>>    btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D589824(589824)
>>>> len=3D16384(16384)
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D8192 len=3D73728
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D589824 len=3D16384
>>>>    btrfs_do_write_iter: r/i=3D5/283 direct fileoff=3D2084864(2084864)
>>>> len=3D36864(36864)
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2084864 len=3D3686=
4
>>>>    btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D2748416(274900=
0)
>>>> len=3D61440(60139)
>>>>    btrfs_do_write_iter: r/i=3D5/283 buffered fileoff=3D5603328(560379=
8)
>>>> len=3D61440(59420)
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D393216 len=3D90112
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D708608 len=3D12288
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D1396736 len=3D6144=
0
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D3592192 len=3D4096
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D2748416 len=3D6144=
0
>>>>    btrfs_finish_one_ordered: r/i=3D5/283 fileoff=3D5603328 len=3D6144=
0
>>>>
>>>> Note that phantom direct IO call, which is in the corrupted range.
>>>>
>>>> If paired with fsstress, that phantom write happens between the two
>>>> operations:
>>>>
>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
>>>
>>> Just to be more accurate, there is a 0/33 operation, which is:
>>>
>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[285 2 308134 1763236 3=
20
>>> 1457078] return 25, fallback to stat()
>>> 0/33: awrite - io_getevents failed -4
>>>
>>> The failed one doesn't have inode number thus it didn't get caught by =
grep.
>>>
>>> Return value -4 means -INTR, not sure who sent the interruption.
>>> But if this interruption happens before the IO finished, we can call
>>> free() on the buffer, and if we're unlucky enough, the freed memory ca=
n
>>> be re-allocated for some other usage, thus modifying the pages before
>>> the writeback finished.
>>>
>>> I think this is the direct cause of the data corruption, page
>>> modification before direct IO finished.
>>>
>>> But unfortunately I still didn't get why the interruption can happen,
>>> nor how can we handle such interruption?
>>> (I guess just retry?)
>>
>> It's because you are mixing aio/io_uring, and the default settings for
>> io_uring is to use signal based notifications for queueing task_work.
>> This then causes a spurious -EINTR, which stops your io_getevents()
>> wait. Looks like this is a bug in fsstress, it should just retry the
>> wait if this happens. You can also configure the ring to not use signal
>> based notifications, but that bug needs fixing regardless.
>
> Something like this will probably fix it.
>
>
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 6641a525fe5d..05fbfd3f8cf8 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2072,6 +2072,23 @@ void inode_info(char *str, size_t sz, struct stat=
64 *s, int verbose)
>   			 (long long) s->st_blocks, (long long) s->st_size);
>   }
>
> +static int io_get_single_event(struct io_event *event)
> +{
> +	int ret;
> +
> +	do {
> +		/*
> +		 * We can get -EINTR if competing with io_uring using signal
> +		 * based notifications. For that case, just retry the wait.
> +		 */
> +		ret =3D io_getevents(io_ctx, 1, 1, event, NULL);
> +		if (ret !=3D -EINTR)
> +			break;
> +	} while (1);
> +
> +	return ret;
> +}
> +
>   void
>   afsync_f(opnum_t opno, long r)
>   {
> @@ -2111,7 +2128,7 @@ afsync_f(opnum_t opno, long r)
>   		close(fd);
>   		return;
>   	}
> -	if ((e =3D io_getevents(io_ctx, 1, 1, &event, NULL)) !=3D 1) {
> +	if ((e =3D io_get_single_event(&event)) !=3D 1) {
>   		if (v)
>   			printf("%d/%lld: afsync - io_getevents failed %d\n",
>   			       procid, opno, e);
> @@ -2220,10 +2237,10 @@ do_aio_rw(opnum_t opno, long r, int flags)
>   	if ((e =3D io_submit(io_ctx, 1, iocbs)) !=3D 1) {
>   		if (v)
>   			printf("%d/%lld: %s - io_submit failed %d\n",
> -			       procid, opno, iswrite ? "awrite" : "aread", e);
> +		 	       procid, opno, iswrite ? "awrite" : "aread", e);
>   		goto aio_out;
>   	}
> -	if ((e =3D io_getevents(io_ctx, 1, 1, &event, NULL)) !=3D 1) {
> +	if ((e =3D io_get_single_event(&event)) !=3D 1) {
>   		if (v)
>   			printf("%d/%lld: %s - io_getevents failed %d\n",
>   			       procid, opno, iswrite ? "awrite" : "aread", e);
>
Exactly what I sent for fsstress:
https://lore.kernel.org/linux-btrfs/20230820010219.12907-1-wqu@suse.com/T/=
#u

Thanks,
Qu
