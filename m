Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9C697FDE
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 16:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBOPwR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 10:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBOPwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 10:52:16 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885FA15570;
        Wed, 15 Feb 2023 07:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676476327; bh=tWh4LgioCaRVztgBW12E8474BYLLkNf072Hqi65Nxkk=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=Uk7xgYLzHhFTTFNjegtENYlReHbXvC0kBVkrt8HvljI3Yfn26wVA70jv4rluAbaIF
         nORvHA6XwjVUPguICxRg9i2lXJayGCXrOn/CjJpRtpa+BeoWuO+t6aU0bi2IT33VtS
         GfacNwHz68ozmmSwmpnR6sCP0NE7ZCs1n/oVCQFLJz3bV8sa1mwPDdfVXV1NNSzV+G
         wXnCImIe95zZKCW+IC4gawNGS6O08BetjvXyZvyKorOYuo58ivWz2t41iakIOob4JO
         tY4OViZZfHsDynSMAHo08FZ7xICwsCIDln949JNErrVwCn2g/AnLwwPjqkAsMV54WS
         xFgNdV7Ct7lMg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.136.89]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MiJVG-1owoTp1B5y-00fWJd; Wed, 15
 Feb 2023 16:52:07 +0100
Message-ID: <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
Date:   Wed, 15 Feb 2023 16:52:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        John David Anglin <dave.anglin@bell.net>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:V6ENFCYg9CnyKvs3mmDKU3GSt5z4/v7C2n4Lr2/ghkrT0yqt4Zv
 N6nDIWJ8QEUuNK6N+znv+AhE2hfPRsh3vvwa1wrf3J2/MKtyXHutyU7TiXr4iBSzAPXqeOa
 JsbWcbNUF3j1gKU4VY5gBG10MxftaoY1J1IJU2DDuyLSX99gt9CsUqtCNtDs9TNgJkqLscw
 Pt+GOz5XziDJGcQNlQrxg==
UI-OutboundReport: notjunk:1;M01:P0:PQDFROwK01I=;ZN+qxcUVU4Do7qOm85qXll2r2Hu
 v/cw50wv5zbsYNNmDbjPZdrCZEXjfbV6T+Z7oyDo5u1UEAQDv5DAeMQzMW+d2iGmGONnPXzrt
 nwnF3AzYUce1DkIZdaglOhmQA5VAly8fk1KyE+/M7p8xMKvOu6yBVzVCAB87rDl3USYDawW0+
 C+DG0d9JU3S5LJW+TuKQ7X9r40huRxB5IqfrgKxHESm4lu1vh2uxrxFWBdnRRlWvuC/4p5uml
 9aC3TPBOqt7WIfUMKA1b182vr3gDjfjD4namJUyPDIPbMWpNYi/aB8Rs+RWZMnQcYiaAJ5QJz
 zw0evYgRDgL0XWTN6ZF0yy3KMrK3lpIbO5fO6uFk82Mmwm34YDJ8pfM5OeUwkBa33buctQPeF
 xd/RrwxIxcLQPFoGs+3YgxfbOGwK7fuwbK3SXxjAsLCLK4GEVlfynvMkhfOauefyxEYeIRl42
 zk/zByfNd+8N8fWkKTZJQbXI/xtnZ+r7jOdyWkAmoOOUJHdsnvV5DuK1IloILV/zlRmgbpUWu
 bNTV8b5dD2/TsyFtDfBITwtNc2bTZRQVz+0pk7k+VbydVetK4Ik+pDFV8NST3GyWUVehDB0uS
 yDqcC5vwdeUZP3u7AG3CLN/o3/X//iUYveplQGbe1Ar85jidbPLTrtoLU4u71pwvLTONq8MHm
 zZxDzqyvvRfGDtdipn7XD1LI1fE1qbIoenJ7pQwPuOLwF8ni+8znBB5QbeTBJUyLwX7YSRYdz
 RnlUpC1andN40cGCuwhAq/N76VnK5NUDsW01fPHLrEYFH7HuWmtTNky9nGmS+q1hRN/4JM+4J
 kDDLVo5wkfPlmQX8ORvLtKsG62GWFUh1bHZBRBvm3TJUcacfvdWfokpbISK/KD2FCK2231teM
 LpnTxvmQVe1Xx2v4bcvciE4U1U82Fot1Bk83aQqkJH36+vbVCI9qJpDE7xa894hwxFt+NHQzs
 fAkxQoNHT6BSbhQB6Wn/lKkxL3M=
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/15/23 16:16, Jens Axboe wrote:
> On 2/14/23 7:12?PM, John David Anglin wrote:
>> On 2023-02-14 6:29 p.m., Jens Axboe wrote:
>>> On 2/14/23 4:09?PM, Helge Deller wrote:
>>>> * John David Anglin<dave.anglin@bell.net>:
>>>>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>>>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>>>> That's what I assumed, so virtual aliasing is what we're dealing w=
ith
>>>>>>> here.
>>>>>>>
>>>>>>>> Thanks for the patch!
>>>>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>>>>> ctx->rings->sq.tail as being 0.
>>>>>>>> Interestingly it worked once (not reproduceable) directly after b=
ootup,
>>>>>>>> which indicates that we at least look at the right address from k=
ernel side.
>>>>>>>>
>>>>>>>> So, still needs more debugging/testing.
>>>>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>>>>> correct, it just seems that parisc is a bit odd in that the virtua=
l
>>>>>>> aliasing occurs between the kernel and userspace addresses too. At=
 least
>>>>>>> that's what it seems like.
>>>>>> True.
>>>>>>
>>>>>>> But I wonder if what needs flushing is the user side, not the kern=
el
>>>>>>> side? Either that, or my patch is not flushing the right thing on =
the
>>>>>>> kernel side.
>>>> The patch below seems to fix the issue.
>>>>
>>>> I've successfuly tested it with the io_uring-test testcase on
>>>> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
>>>>
>>>> The idea is similiar on how a file is mmapped shared by two
>>>> userspace processes by keeping the lower bits of the virtual address
>>>> the same.
>>>>
>>>> Cache flushes from userspace don't seem to be needed.
>>> Are they from the kernel side, if the lower bits mean we end up
>>> with the same coloring? Because I think this is a bit of a big
>>> hammer, in terms of overhead for flushing. As an example, on arm64
>>> that is perfectly fine with the existing code, it's about a 20-25%
>>> performance hit.
>>
>> The io_uring-test testcase still works on rp3440 with the kernel
>> flushes removed.
>
> That's what I suspected, the important bit here is just aligning it for
> identical coloring. Can you confirm if the below works for you? Had to
> fiddle it a bit to get it to work without coloring.

Yes, the patch works for me on 32- and 64-bit, even with PA8900 CPUs...

Is there maybe somewhere a more detailled testcase which I could try too?

Some nits below...

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db623b3185c8..1d4562067949 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -72,6 +72,7 @@
>   #include <linux/io_uring.h>
>   #include <linux/audit.h>
>   #include <linux/security.h>
> +#include <asm/shmparam.h>
>
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/io_uring.h>
> @@ -3200,6 +3201,51 @@ static __cold int io_uring_mmap(struct file *file=
, struct vm_area_struct *vma)
>   	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot=
);
>   }
>
> +static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
> +			unsigned long addr, unsigned long len,
> +			unsigned long pgoff, unsigned long flags)
> +{
> +	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
> +	struct vm_unmapped_area_info info;
> +	void *ptr;
> +
> +	ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
> +	if (IS_ERR(ptr))
> +		return -ENOMEM;
> +
> +	/* we do not support requesting a specific address */
> +	if (addr)
> +		return -EINVAL;

With this ^ we disallow users to provide a proposed address.
I think this is ok and I suggest to keep it that way.

Alternatively one could check the given address against the
alignment which is calculated below, but this will make the
code IMHO unnecessary bigger.

> +
> +	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
> +	info.length =3D len;
> +	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
> +	info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_base);
> +	info.align_mask =3D PAGE_MASK;
> +	info.align_offset =3D (unsigned long) ptr;

For parisc I introduced SHM_COLOUR because it allows userspace
to map a shared file initially at any PAGE_SIZE-aligned address.
Only if then a second user maps the same file, the aliasing will be enforc=
ed.

Other platforms just have SHMLBA, and for some SHMLBA is > PAGE_SIZE.
So, instead of above code, this untested code might be better for those ot=
her
platforms ?
info.align_mask =3D PAGE_MASK & (SHMLBA - 1);
info.align_offset =3D (unsigned long)ptr & (SHMLBA - 1);

this is ok ->
> +#ifdef SHM_COLOUR
> +	info.align_mask &=3D (SHM_COLOUR - 1);
> +	info.align_offset &=3D (SHM_COLOUR - 1)

^^ misses a ";" at the end.

Helge

> +#endif
> +
> +	/*
> +	 * A failed mmap() very likely causes application failure,
> +	 * so fall back to the bottom-up function here. This scenario
> +	 * can happen with large stack limits and large mmap()
> +	 * allocations.
> +	 */
> +	addr =3D vm_unmapped_area(&info);
> +	if (offset_in_page(addr)) {
> +		VM_BUG_ON(addr !=3D -ENOMEM);
> +		info.flags =3D 0;
> +		info.low_limit =3D TASK_UNMAPPED_BASE;
> +		info.high_limit =3D mmap_end;
> +		addr =3D vm_unmapped_area(&info);
> +	}
> +
> +	return addr;
> +}
> +
>   #else /* !CONFIG_MMU */
>
>   static int io_uring_mmap(struct file *file, struct vm_area_struct *vma=
)
> @@ -3414,6 +3460,8 @@ static const struct file_operations io_uring_fops =
=3D {
>   #ifndef CONFIG_MMU
>   	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
>   	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
> +#else
> +	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
>   #endif
>   	.poll		=3D io_uring_poll,
>   #ifdef CONFIG_PROC_FS
>

