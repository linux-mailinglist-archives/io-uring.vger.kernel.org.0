Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD0769743D
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 03:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBOCPv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 21:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjBOCPu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 21:15:50 -0500
X-Greylist: delayed 120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Feb 2023 18:15:49 PST
Received: from cmx-mtlrgo001.bell.net (mta-mtl-005.bell.net [209.71.208.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF3920685;
        Tue, 14 Feb 2023 18:15:48 -0800 (PST)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [174.88.80.151]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 63E35DF700AA57BB
X-CM-Envelope: MS4xfF+ZAqY6fgv7W+Z/KMjKKHw6Cb2dAcCC87DIpjYmRmHFLMCe0+cPyAz6MXK9XVm7r9ldi4VeNkgrn2hgepihVjcJy+rNkvJrRtl6lkk8GqvHY6u1slFm
 4BEr+J3WqToEZtI8WpLrUyaUl0W8UEOTRm25nzRbWrgxEbJ8e2yj0vmrqxTe3NrLgZ5VRy33xUhcRx9Jejp0NtHNygq3sI2u/zeg8fU2IDPo8tNp2vpcsQCT
 7jFnSW8gvdY1iddWdhgnEOK8q9AZVFPiWbM4/mewjXkGJlH7vj7eJN1jH2swA7EhxXAp66yifOyW+c3AJZ7xY/iHHrB9nV2kReEQwrrH9mxqe01f608FpjH+
 FtxgJQ7j2oQyUiCnl+c1r8JRpsx5CO7RwmxuH0ONke2jpCe/Ydk=
X-CM-Analysis: v=2.4 cv=AuWNYMxP c=1 sm=1 tr=0 ts=63ec3f88
 a=6Iw0JHgwQEnu+SgMJEJdFQ==:117 a=6Iw0JHgwQEnu+SgMJEJdFQ==:17
 a=IkcTkHD0fZMA:10 a=FBHGMhGWAAAA:8 a=JPfK03Pn82aHAJPgZp0A:9 a=QEXdDO2ut3YA:10
 a=9gvnlMMaQFpL9xblJ6ne:22
Received: from [192.168.2.49] (174.88.80.151) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 63E35DF700AA57BB; Tue, 14 Feb 2023 21:12:24 -0500
Message-ID: <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
Date:   Tue, 14 Feb 2023 21:12:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
To:     Jens Axboe <axboe@kernel.dk>, Helge Deller <deller@gmx.de>,
        io-uring@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
Content-Language: en-US
From:   John David Anglin <dave.anglin@bell.net>
In-Reply-To: <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-14 6:29 p.m., Jens Axboe wrote:
> On 2/14/23 4:09 PM, Helge Deller wrote:
>> * John David Anglin<dave.anglin@bell.net>:
>>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>> That's what I assumed, so virtual aliasing is what we're dealing with
>>>>> here.
>>>>>
>>>>>> Thanks for the patch!
>>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>>> ctx->rings->sq.tail as being 0.
>>>>>> Interestingly it worked once (not reproduceable) directly after bootup,
>>>>>> which indicates that we at least look at the right address from kernel side.
>>>>>>
>>>>>> So, still needs more debugging/testing.
>>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>>> correct, it just seems that parisc is a bit odd in that the virtual
>>>>> aliasing occurs between the kernel and userspace addresses too. At least
>>>>> that's what it seems like.
>>>> True.
>>>>
>>>>> But I wonder if what needs flushing is the user side, not the kernel
>>>>> side? Either that, or my patch is not flushing the right thing on the
>>>>> kernel side.
>> The patch below seems to fix the issue.
>>
>> I've successfuly tested it with the io_uring-test testcase on
>> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
>>
>> The idea is similiar on how a file is mmapped shared by two
>> userspace processes by keeping the lower bits of the virtual address
>> the same.
>>
>> Cache flushes from userspace don't seem to be needed.
> Are they from the kernel side, if the lower bits mean we end up
> with the same coloring? Because I think this is a bit of a big
> hammer, in terms of overhead for flushing. As an example, on arm64
> that is perfectly fine with the existing code, it's about a 20-25%
> performance hit.
The io_uring-test testcase still works on rp3440 with the kernel flushes removed.

-- 
John David Anglin  dave.anglin@bell.net

