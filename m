Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04BE69541B
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 23:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBMWwx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 17:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBMWwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 17:52:53 -0500
X-Greylist: delayed 151 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Feb 2023 14:52:51 PST
Received: from cmx-torrgo002.bell.net (mta-tor-003.bell.net [209.71.212.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246614ED1;
        Mon, 13 Feb 2023 14:52:50 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E4C092006D8B72
X-CM-Envelope: MS4xfKyY6VeyTrDzCWtcd7cohvYEkYC78n2Yr7traWZTWWaCvqs6wjvkF0Kdul0RezFgEj+ByZJ4wBzfdfIsS6bnGQEIPZMreQdQoN6XzJ8FbbsSyZkTWZYw
 aoj0CRdzgJb6LYd+57NNamqcHT6ZIBOs1aiqdBfPmb+ZL7QVQLxdXj0c+yOwVfW0Q3ok0HjDmQiQRoBfzGe1R8JnKjakWa+sSVmxRdBFYYWoq7sY/OkvRtMD
 O91+bbWTsPyRoH8ajejl7QNDB/SnARNPZ4FCIUOcEkCMaD/9yFkHAv2+IxWJEwyxXpe8V96/Yf909TkzQj6Kb7QKXCUCp4oIpaWwH73gZow=
X-CM-Analysis: v=2.4 cv=ULS+oATy c=1 sm=1 tr=0 ts=63eabea8
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=0ODbCZyp71bEKlGsQz0A:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-torrgo002.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E4C092006D8B72; Mon, 13 Feb 2023 17:50:16 -0500
Message-ID: <507c7873-8888-dbcb-c512-4659af486848@bell.net>
Date:   Mon, 13 Feb 2023 17:50:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-parisc <linux-parisc@vger.kernel.org>
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
 <721b23a1-91f8-3f98-6448-6b9a70119eba@gmx.de>
 <96a542dc-c3a0-65ec-3bd0-fa1175b9bf87@kernel.dk>
 <587c828a-6155-f850-63f1-f2e6bc097fda@gmx.de>
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <587c828a-6155-f850-63f1-f2e6bc097fda@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-13 5:05 p.m., Helge Deller wrote:
> On 2/13/23 22:05, Jens Axboe wrote:
>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>
>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>
>> That's what I assumed, so virtual aliasing is what we're dealing with
>> here.
>>
>>> Thanks for the patch!
>>> Sadly it doesn't fix the problem, as the kernel still sees
>>> ctx->rings->sq.tail as being 0.
>>> Interestingly it worked once (not reproduceable) directly after bootup,
>>> which indicates that we at least look at the right address from kernel side.
>>>
>>> So, still needs more debugging/testing.
>>
>> It's not like this is untested stuff, so yeah it'll generally be
>> correct, it just seems that parisc is a bit odd in that the virtual
>> aliasing occurs between the kernel and userspace addresses too. At least
>> that's what it seems like.
>
> True.
>
>> But I wonder if what needs flushing is the user side, not the kernel
>> side? Either that, or my patch is not flushing the right thing on the
>> kernel side.
>>
>> Is it possible to flush it from the userspace side? Presumable that's
>> what we'd need on the sqe side, and then the kernel side for the cqe
>> filling. So probably the patch is half-way correct :-)
>
> I hacked up in __io_uring_flush_sq() in liburing/src/queue.c this code
> (which I hope is correct):
>                 if (!(ring->flags & IORING_SETUP_SQPOLL))
>                         IO_URING_WRITE_ONCE(*sq->ktail, tail);
>                 else
>                         io_uring_smp_store_release(sq->ktail, tail);
>         } /* ADDED: */
>         { int i;  unsigned long p = (unsigned long)sq->ktail & ~(4096-1);
>           fprintf(stderr, "FLUSH CACHE OF PAGE %lx\n", p);
>           for (i=0; i < 4096; i += 8)
>                 asm volatile("fdc 0(%0)" : : "r" (p+i));
>         }
>
> The kernel sometimes sees the tail value now (it fails afterwards, but that's ok for now).
> But I'm not sure yet if this is really the effect of the fdc (flush data cache instruction),
> or pure luck because the aliasing of the userspace address and kernel address matches in
> a sucessful run.
If the user and kernel aliases are not equivalent, the kernel must also flush the page to
invalidate any lines that may be present in the cache before trying to access the data in the page.
> For me it seems as it's the aliasing which makes it work sometimes.
>
> In this regard I wonder why we don't provide the cacheflush syscall on parisc....
The kernel knows the cache stride and can optimize the flush.  But it needs to handle non access TLB
faults on userspace.  Userspace can also do flushes.

Dave

-- 
John David Anglin  dave.anglin@bell.net

