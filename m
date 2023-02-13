Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395A8695280
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBMU7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 15:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjBMU7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 15:59:49 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540BC5FD8;
        Mon, 13 Feb 2023 12:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676321980; bh=sKZXg0qvoJ1b6D8TeM5VTq5TRhNTat8i8FeUJOWNoIE=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=GBmEvgesC9cCMZKn+WB4AYzh1Rx0jK3+IOHxih9+RyPPJyU4pnX5rY0rcTvmQk+eU
         dJDyZWfYVO0V66ijXhF1netxbjF6WU3THBl5S2PZVcJD00a1R3tCWDHO3cG0CiGc9E
         A2sM10KH0igQcYot0JHHBbpxJjR/jFawp/fJsxeCfSMIIMyWe2UILC96h52s3D65+5
         Rin/j87Z0M241sBh1qJwo/OCi3rmmlZgVTv4KelDeHOt5oKY13Uk8FBGT7A08Eh+xK
         Oy0+Xl8HGW9KIZ85vuRRPOuIZev5FLBIaVgEyTnuQn1ceOX6eucHHd3G5ueUN7vwrO
         U+AKivZjPTlfA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.143.195]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MQMyZ-1pEq1y3OjZ-00MIs8; Mon, 13
 Feb 2023 21:59:39 +0100
Message-ID: <721b23a1-91f8-3f98-6448-6b9a70119eba@gmx.de>
Date:   Mon, 13 Feb 2023 21:59:38 +0100
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
 <c5dcfbf1-bf00-2d2a-dba6-241f316efb92@gmx.de>
 <d37e2b43-f405-fe6f-15c4-7c9b08a093e1@gmx.de>
 <8f21a6bd-c66a-169b-6278-34a66dbcfee7@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <8f21a6bd-c66a-169b-6278-34a66dbcfee7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:f2rXRncupFBjpFM3tuM+MXNxQmo7ujDgVBZNmxSpwDxeOmLMJXM
 ZtV/5OEMbq4BOVP18qrZSMS6E2fFAasYlKg1hJgCumuqWt2Mchc85o0omq3ZY/EzJPYx9w5
 GG9hXAaUWqiNMwdOEJ8SGMN6kuO4BjHj8fR5WaoXOUlwumhrM56ARehuwzNQYN5RrxfH5v4
 f4NHCuNgDA+bwtat+2ldw==
UI-OutboundReport: notjunk:1;M01:P0:xUAWUcN98OA=;2vhpqwds2Kqsf29offvZOpP7d8k
 3LruQnpWHQ22ReFUp7QedH2FbNN9RrfSYHvLx2+WwxH1E6MfCn/QRAYMlKLIBP0vL/WL1o+EX
 s7FVh45FWIvYVeoXyb+fVdUMvF3qetruoiN4sK7hl28efl8JDgIQN4mpzQuUnEGQ8RMIWBDyc
 2rO6kh/E1WfZ6Jbn1CRGN7QU94UgWb5Xh3GLcSgf+GWNO9xUSM5UDZsGAS8XOCqcXRvrafqw2
 HSMfq6D+cpPmbfUtlbCRu+64b+yQSAuLEqGiKEzgc0AWKkmoN7+gxzsw4l3EVhQh9syMct07b
 yV8oSuf1Uy+L7tLCKNwnQ+NNlUEekQpRwJ7YkC2iBs+IrDhU77g8Z6brfVtkDfpmlRUCg+nSr
 xMy75ZanNBkXJv8OWixflZ9U/Nv28G8Qs4lVWIAD26uXyPlAbfi8pCeZOu69VCMm2+TmsoV+8
 LocRVxSLZP+L4XKXz5gPXPwVLZr7rS9bvz7uIMUmk/FD/pwMHAs3QdlURpqqv39UL6z2YYgEJ
 WMw/Q1Dx6fy76cQH8BqM1bIaHhxmMYjdsLOcMvY86ezQysMZk6PGg2/IU4QnBgFhKe16NdPxN
 5c/NXwfi63puQYOHiMEGCr0/yPq0ytW/cJIHeVyEwcEDpLZe6JTW5toPNNi+m/1I901J/LXzk
 IDQjtMz4ObMeskdsUv/ocreB8yCdfO56wT0HUlU25Mqx4Zfe6uPydfIzuXJQeQgkY+SKjwdhz
 6iZnnQ7nMUL3fyb1pecuZawCi5zv3GplDQAVNKBD6MmTXkub8P7g2eO1OP/96RRQ6c+hy27Zi
 XpEHzVdhaQwUqyfG6BrGGtQfXc0L9Rr35ElYzwotdj4seB+UyNW/ewpcHBZoDqYbmE02eVMPL
 T9X2e62bAiJFi6I2+TSCW+w9cKeHY/qVghnElaOKC3hWW2EE+fI3aGXMD1Pj+G7kaHz2XZKiU
 eVfCD97LsuhiIpC+J5H044TYlXA=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/23 17:15, Jens Axboe wrote:
> On 2/12/23 3:31?PM, Helge Deller wrote:
>> On 2/12/23 23:20, Helge Deller wrote:
>>> On 2/12/23 22:48, Jens Axboe wrote:
>>>> On 2/12/23 1:01?PM, Helge Deller wrote:
>>>>> On 2/12/23 20:42, Jens Axboe wrote:
>>>>>> On 2/12/23 12:35?PM, Helge Deller wrote:
>>>>>>> On 2/12/23 15:03, Helge Deller wrote:
>>>>>>>> On 2/12/23 14:35, Jens Axboe wrote:
>>>>>>>>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>>>>>>>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>>>>>>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>
>>>>>>>>>>>> We see io-uring failures on the parisc architecture with this=
 testcase:
>>>>>>>>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uri=
ng-test.c
>>>>>>>>>>>>
>>>>>>>>>>>> parisc is always big-endian 32-bit userspace, with either 32-=
 or 64-bit kernel.
>>>>>>>>>>>>
>>>>>>>>>>>> On a 64-bit kernel (6.1.11):
>>>>>>>>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>>>>>>>>> ret=3D0, wanted 4096
>>>>>>>>>>>> Submitted=3D4, completed=3D1, bytes=3D0
>>>>>>>>>>>> -> failure
>>>>>>>>>>>>
>>>>>>>>>>>> strace shows:
>>>>>>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_id=
le=3D0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP=
|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORIN=
G_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f8=
0, sq_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=
=3D84, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_ma=
sk=3D68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORI=
NG_CQ_??? */}}) =3D 3
>>>>>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULAT=
E, 3, 0) =3D 0xf7522000
>>>>>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULAT=
E, 3, 0x10000000) =3D 0xf6922000
>>>>>>>>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O=
_DIRECT) =3D 4
>>>>>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_P=
ATH, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_at=
tributes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D689308, ...}) =3D 0
>>>>>>>>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) =3D 4
>>>>>>>>>>>> brk(NULL)                               =3D 0x4ae000
>>>>>>>>>>>> brk(0x4cf000)                           =3D 0x4cf000
>>>>>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 0
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>>>>>>>>> root@debian:~# ./io_uring-test test.file
>>>>>>>>>>>> Submitted=3D4, completed=3D4, bytes=3D16384
>>>>>>>>>>>> -> ok.
>>>>>>>>>>>>
>>>>>>>>>>>> strace:
>>>>>>>>>>>> io_uring_setup(4, {flags=3D0, sq_thread_cpu=3D0, sq_thread_id=
le=3D0, sq_entries=3D4, cq_entries=3D8, features=3DIORING_FEAT_SINGLE_MMAP=
|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORIN=
G_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f8=
0, sq_off=3D{head=3D0, tail=3D16, ring_mask=3D64, ring_entries=3D72, flags=
=3D84, dropped=3D80, array=3D224}, cq_off=3D{head=3D32, tail=3D48, ring_ma=
sk=3D68, ring_entries=3D76, overflow=3D92, cqes=3D96, flags=3D0x58 /* IORI=
NG_CQ_??? */}}) =3D 3
>>>>>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULAT=
E, 3, 0) =3D 0xf6d4c000
>>>>>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULAT=
E, 3, 0x10000000) =3D 0xf694c000
>>>>>>>>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) =3D 4
>>>>>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_P=
ATH, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_at=
tributes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D1855488, ...}) =3D 0
>>>>>>>>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) =3D 4
>>>>>>>>>>>> brk(NULL)                               =3D 0x15000
>>>>>>>>>>>> brk(0x36000)                            =3D 0x36000
>>>>>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     =3D 4
>>>>>>>>>>>>
>>>>>>>>>>>> I'm happy to test any patch if someone has an idea....
>>>>>>>>>>>
>>>>>>>>>>> No idea what this could be, to be honest. I tried your qemu vm=
 image,
>>>>>>>>>>> and it does boot, but it's missing keys to be able to update a=
pt and
>>>>>>>>>>> install packages... After fiddling with this for 30 min I gave=
 up, any
>>>>>>>>>>> chance you can update the sid image? Given how slow this thing=
 is
>>>>>>>>>>> running, it'd take me all day to do a fresh install and I have=
 to admit
>>>>>>>>>>> I'm not THAT motivated about parisc to do that :)
>>>>>>>>>>
>>>>>>>>>> Yes, I will update that image, but qemu currently only supports=
 a
>>>>>>>>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So eve=
n if I
>>>>>>>>>> update it, you won't be able to reproduce it, as it only happen=
s with
>>>>>>>>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64b=
it
>>>>>>>>>> translation in the kernel, which triggers only big-endian machi=
nes.
>>>>>>>>>
>>>>>>>>> I built my own kernel for it, so that should be fine, correct?
>>>>>>>>
>>>>>>>> No, as qemu won't boot the 64-bit kernel.
>>>>>>>>
>>>>>>>>> We'll see soon enough, managed to disable enough checks on the
>>>>>>>>> debian-10 image to actually make it install packages.
>>>>>>>>>
>>>>>>>>>> Does powerpc with a 64-bit ppc64 kernel work?
>>>>>>>>>> I'd assume it will show the same issue.
>>>>>>>>>
>>>>>>>>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>>>>>>>>
>>>>>>>> Would be interesting if someone could test...
>>>>>>>>
>>>>>>>>>> I will try to add some printks and compare the output of 32- an=
d
>>>>>>>>>> 64-bit kernels. If you have some suggestion where to add such (=
which?)
>>>>>>>>>> debug code, it would help me a lot.
>>>>>>>>>
>>>>>>>>> I'd just try:
>>>>>>>>>
>>>>>>>>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>>>>>>>>
>>>>>>>> I'll try, but will take some time...
>>>>>>>>
>>>>>>>
>>>>>>> At entry of io_submit_sqes(), io_sqring_entries() returns 0, becau=
se
>>>>>>> ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4=
 on 32-bit), and
>>>>>>> ctx->cached_sq_head is 0 in both cases.
>>>>>>
>>>>>> cached_sq_head will get updated as sqes are consumed, but since sq.=
tail
>>>>>> is zero, there's nothing to submit as far as io_uring is concerned.
>>>>>>
>>>>>> Can you dump addresses/offsets of the sq and cq heads/tails in user=
space
>>>>>> and in the kernel? They are u32, so same size of 32 and 64-bit.
>>>>>
>>>>> For both kernels (32- and 64-bit) I get:
>>>>> p->sq_off.head =3D 0  p->sq_off.tail =3D 16
>>>>> p->cq_off.head =3D 32  p->cq_off.tail =3D 48
>>>>
>>>> So all that looks as expected. Is it perhaps some mmap thing on 64-bi=
t
>>>> kernels? The kernel isn't seeing the updates. You could add the below
>>>> debugging, and keep your kernel side stuff. Sounds like they don't qu=
ite
>>>> agree.
>>>>
>>>>
>>>> diff --git a/examples/io_uring-test.c b/examples/io_uring-test.c
>>>> index 1a685360bff6..f1cfda90c018 100644
>>>> --- a/examples/io_uring-test.c
>>>> +++ b/examples/io_uring-test.c
>>>> @@ -73,7 +73,9 @@ int main(int argc, char *argv[])
>>>>                break;
>>>>        } while (1);
>>>>
>>>> +    printf("pre-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead,=
 *ring.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
>>>>        ret =3D io_uring_submit(&ring);
>>>> +    printf("post-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead=
, *ring.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
>>>>        if (ret < 0) {
>>>>            fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
>>>>            return 1;
>>>
>>> Result is:
>>> pre-submit sq head/tail 0/0, 0/4
>>> ..
>>> post-submit sq head/tail 0/4, 4/4
>>
>> I have to correct myself!
>> The problem exists on both, 32- and 64-bit kernels.
>> My current testing with 32-bit kernel was on qemu, but after booting th=
e same kernel
>> on a physical box, I see the testcase failing on the 32-bit kernel too.
>>
>> So, probably some cache-flushing / alias-handling is needed....
>> This is a 1-CPU box, so SMP isn't involved.
>
> Yep sounds like it. What's the caching architecture of parisc?

parisc is Virtually Indexed, Physically Tagged (VIPT).


> Something
> like this perhaps, but may not be complete as we'd need to do something
> for the cqe writes too I think, not just the cq tail.
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db623b3185c8..ab0d1297bb0e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2338,6 +2338,8 @@ static const struct io_uring_sqe *io_get_sqe(struc=
t io_ring_ctx *ctx)
>   	unsigned head, mask =3D ctx->sq_entries - 1;
>   	unsigned sq_idx =3D ctx->cached_sq_head++ & mask;
>
> +	flush_dcache_page(virt_to_page(ctx->sq_array + sq_idx));
> +
>   	/*
>   	 * The cached sq head (or cq tail) serves two purposes:
>   	 *
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index ab4b2a1c3b7e..b132f44a9364 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -220,6 +220,7 @@ static inline void io_commit_cqring(struct io_ring_c=
tx *ctx)
>   {
>   	/* order cqe stores with ring update */
>   	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
> +	flush_dcache_page(virt_to_page(ctx->rings));
>   }
>
>   /* requires smb_mb() prior, see wq_has_sleeper() */

Thanks for the patch!
Sadly it doesn't fix the problem, as the kernel still sees
ctx->rings->sq.tail as being 0.
Interestingly it worked once (not reproduceable) directly after bootup,
which indicates that we at least look at the right address from kernel sid=
e.

So, still needs more debugging/testing.

Helge
