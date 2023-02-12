Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8637C693A6F
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 23:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBLWUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 17:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBLWUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 17:20:19 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C67FF15;
        Sun, 12 Feb 2023 14:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676240411; bh=AJ1kKDsttRHVjdSIK3ERM5A9jbt3lp4Z3RaurXCxN+Y=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=NDM1fxM3+QMmusF0LN7VHtfZJt6TRNYC2u/s60fHlCJYBeUGVrAQPRPI7PKPTFgks
         KtmjDn2tBvR0Yms/HzQkSkw8ijDaSUbyVj9icea/4lez/BPpd4B/MD42dp+S2O7IWV
         J5ysADe6OwcZ2FkHg4HQj5QLbbmkkRDdEyFIwUb0MV1/pAQlqsQUKpYWOhk7gsBxgz
         J43hBtggfzg0WlGiwAwVkTKyxEITIt0X2bvkULNUg4gsnuq8jdWWiuTbROmarMN1yi
         CEiPCWwitVZzg0I+5bQ3EeRZv5LTl+c6RGVKoHF+fH1Hgj+LhefZADwkkXjQlSs9jE
         sENNpyUijwwxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.190.155]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0XCw-1og7Op1yrM-00wUb4; Sun, 12
 Feb 2023 23:20:11 +0100
Message-ID: <c5dcfbf1-bf00-2d2a-dba6-241f316efb92@gmx.de>
Date:   Sun, 12 Feb 2023 23:20:10 +0100
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
 <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
 <05b6adc3-db63-022e-fdec-6558bdb83972@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <05b6adc3-db63-022e-fdec-6558bdb83972@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zXSNTMkDwst4Lf1Xc9GOyppozRR4pOjBwaXH51JTO/PTFautvtZ
 v+Vl6vHn2CEa3vLCDRRfk9tsE9haH+Uemo70MkwPawAjA7FgeL0B6UfwzuNS4OPorOYT/qH
 fKP/0tipA3ZaKG3loITqrTCf+KlshpAuVv18uXz6flKcwMjYMAZq5T0+uN+AVpm9zfGAL0q
 nIWecd0HtORunhVHkClBQ==
UI-OutboundReport: notjunk:1;M01:P0:utDFw9h/sWk=;CF6mKDrmTj5178P1jat508BEGsH
 a1utuJ2cZT8OmsHIcViuWf/KzMQvReibI325ocAahwpO1vTc3/65z5mfog9sGkYAHSZYS9ubN
 YeqKNAyZn8oogpF+GzkcZEQHOacEIlTPdHqGba9fk+4aRV+X9Zv7G1H8/BbDXgSQvx5ZTxBJO
 vNLt0aGqlvOlts0TNKgD4FAWlYkQcByS3hvibFx7VAkMGMPoaJon6GHO2npFkQZ4GtXrLfnim
 rlkHdDIbN0J4JTO2Q8Q+ZROJ/eTvk/2p9e9SfL/evSsu9heeFRsKhsLB10m+ZQUAZ+jHDBB0h
 tST7aIH21b356plS5e7dRCoCXVsh5AL46QfZQVAF2bOcNp7DD4sF2Mp4vQtzMva7ZYvXRZj72
 Ms/j7jSqzg+PhMtMHQuY7h1TX6aKsgYCLU58tKsYXqsHlquOhQQluAwfGYx/3NvS6IOWzjdGp
 nlav2XS65y912yXzCvyP/lKTY7h06j0Ogh+vYquLpiPtahdyEIZ122FsgEPzxmuXMy1wovxhK
 sk3HxuzbBcumNqqeNunaRDjXUqEvnxO6F36law11PZWnGiKhsSRowZfrCq9DOXQjlwiBeSeYU
 eTJM2UYMLcqossyGkjlJgodvo09z7xj/t1wPWJNo4FL9VCdoHhhdY1HKEzz+k+xpEvB3ujmBd
 TJ4Vh0nBUf8JGLZTIhrFZWpg2wP07ayfxPoQQaS8tUSJ95KRuue+nhhAd7Y6Jye35wLJ3ybj4
 4Q8eeXgzGfHiQRu1bnkDix6lcdi6nPwlcxoafM9tbGy4L0RQjqi34nF5LIANjm3S1r4V6zCiw
 G+tV470OUK0JnkBWgn2rm4STyZ7LUVboYuProsa8Ki9jcbXem8FsclJWysxUMKmtKe2FJObqb
 NBk8MnLwIjBMaSNzHvCpt7KfOReKHgM33TAa85BRnVQjPmFTVHVQOOcdKHj791o6UFTFOF7xx
 A8CF7S8/dAX0i2g9O5QKr7Hqhqc=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 22:48, Jens Axboe wrote:
> On 2/12/23 1:01?PM, Helge Deller wrote:
>> On 2/12/23 20:42, Jens Axboe wrote:
>>> On 2/12/23 12:35?PM, Helge Deller wrote:
>>>> On 2/12/23 15:03, Helge Deller wrote:
>>>>> On 2/12/23 14:35, Jens Axboe wrote:
>>>>>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>>>>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>>>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> We see io-uring failures on the parisc architecture with this te=
stcase:
>>>>>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-=
test.c
>>>>>>>>>
>>>>>>>>> parisc is always big-endian 32-bit userspace, with either 32- or=
 64-bit kernel.
>>>>>>>>>
>>>>>>>>> On a 64-bit kernel (6.1.11):
>>>>>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>>>>>> ret=3D0, wanted 4096
>>>>>>>>> Submitted=3D4, completed=3D1, bytes=3D0
>>>>>>>>> -> failure
>>>>>>>>>
>>>>>>>>> strace shows:
>>>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=
=3D0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|I=
ORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_=
FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80,=
 sq_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=
=3D84, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_ma=
sk=3D68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORI=
NG_CQ_??? */}}) =3D 3
>>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, =
3, 0) =3D 0xf7522000
>>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, =
3, 0x10000000) =3D 0xf6922000
>>>>>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DI=
RECT) =3D 4
>>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH=
, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attri=
butes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>>>>>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>>>>>>>>> brk(NULL)                               =3D 0x4ae000
>>>>>>>>> brk(0x4cf000)                           =3D 0x4cf000
>>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 0
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>>>>>> root@debian:~# ./io_uring-test test.file
>>>>>>>>> Submitted=3D4, completed=3D4, bytes=3D16384
>>>>>>>>> -> ok.
>>>>>>>>>
>>>>>>>>> strace:
>>>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_idle=
=3D0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP|I=
ORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_=
FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80,=
 sq_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=
=3D84, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_ma=
sk=3D68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORI=
NG_CQ_??? */}}) =3D 3
>>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, =
3, 0) =3D 0xf6d4c000
>>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, =
3, 0x10000000) =3D 0xf694c000
>>>>>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH=
, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attri=
butes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>>>>>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>>>>>>>>> brk(NULL)                               =3D 0x15000
>>>>>>>>> brk(0x36000)                            =3D 0x36000
>>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 4
>>>>>>>>>
>>>>>>>>> I'm happy to test any patch if someone has an idea....
>>>>>>>>
>>>>>>>> No idea what this could be, to be honest. I tried your qemu vm im=
age,
>>>>>>>> and it does boot, but it's missing keys to be able to update apt =
and
>>>>>>>> install packages... After fiddling with this for 30 min I gave up=
, any
>>>>>>>> chance you can update the sid image? Given how slow this thing is
>>>>>>>> running, it'd take me all day to do a fresh install and I have to=
 admit
>>>>>>>> I'm not THAT motivated about parisc to do that :)
>>>>>>>
>>>>>>> Yes, I will update that image, but qemu currently only supports a
>>>>>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even i=
f I
>>>>>>> update it, you won't be able to reproduce it, as it only happens w=
ith
>>>>>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>>>>>>> translation in the kernel, which triggers only big-endian machines=
.
>>>>>>
>>>>>> I built my own kernel for it, so that should be fine, correct?
>>>>>
>>>>> No, as qemu won't boot the 64-bit kernel.
>>>>>
>>>>>> We'll see soon enough, managed to disable enough checks on the
>>>>>> debian-10 image to actually make it install packages.
>>>>>>
>>>>>>> Does powerpc with a 64-bit ppc64 kernel work?
>>>>>>> I'd assume it will show the same issue.
>>>>>>
>>>>>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>>>>>
>>>>> Would be interesting if someone could test...
>>>>>
>>>>>>> I will try to add some printks and compare the output of 32- and
>>>>>>> 64-bit kernels. If you have some suggestion where to add such (whi=
ch?)
>>>>>>> debug code, it would help me a lot.
>>>>>>
>>>>>> I'd just try:
>>>>>>
>>>>>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>>>>>
>>>>> I'll try, but will take some time...
>>>>>
>>>>
>>>> At entry of io_submit_sqes(), io_sqring_entries() returns 0, because
>>>> ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4 on=
 32-bit), and
>>>> ctx->cached_sq_head is 0 in both cases.
>>>
>>> cached_sq_head will get updated as sqes are consumed, but since sq.tai=
l
>>> is zero, there's nothing to submit as far as io_uring is concerned.
>>>
>>> Can you dump addresses/offsets of the sq and cq heads/tails in userspa=
ce
>>> and in the kernel? They are u32, so same size of 32 and 64-bit.
>>
>> For both kernels (32- and 64-bit) I get:
>> p->sq_off.head =3D 0  p->sq_off.tail =3D 16
>> p->cq_off.head =3D 32  p->cq_off.tail =3D 48
>
> So all that looks as expected. Is it perhaps some mmap thing on 64-bit
> kernels? The kernel isn't seeing the updates. You could add the below
> debugging, and keep your kernel side stuff. Sounds like they don't quite
> agree.
>
>
> diff --git a/examples/io_uring-test.c b/examples/io_uring-test.c
> index 1a685360bff6..f1cfda90c018 100644
> --- a/examples/io_uring-test.c
> +++ b/examples/io_uring-test.c
> @@ -73,7 +73,9 @@ int main(int argc, char *argv[])
>   			break;
>   	} while (1);
>
> +	printf("pre-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead, *ring=
.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
>   	ret =3D io_uring_submit(&ring);
> +	printf("post-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead, *rin=
g.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
>   	if (ret < 0) {
>   		fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>   		return 1;

Result is:
pre-submit sq head/tail 0/0, 0/4
..
post-submit sq head/tail 0/4, 4/4

Helge
