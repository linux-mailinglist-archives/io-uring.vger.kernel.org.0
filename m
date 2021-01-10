Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B22F0876
	for <lists+io-uring@lfdr.de>; Sun, 10 Jan 2021 17:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAJQwC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 11:52:02 -0500
Received: from a4-15.smtp-out.eu-west-1.amazonses.com ([54.240.4.15]:57075
        "EHLO a4-15.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbhAJQwC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 11:52:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610297444;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=4ZMRTazqJIpZ6htEoopAVyb8N3PexHPg7F41YaHCeKY=;
        b=CzzuN7Fsuc6MOB9rETP6mNJvJwdlO/c/zguAFuduEMvbPDB7+wHzWKAo0BpJRZZX
        ZrZsPiJzkpR3pFiWLAUxG3EL3ChkOPqDxtaQr4XNSPBxO7ikkGRjBFXG4IJcwB1Wnkc
        Ez8l7DiOiLJh90apSg32xlhK9pjtb0HtHo4FTCNk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610297444;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=4ZMRTazqJIpZ6htEoopAVyb8N3PexHPg7F41YaHCeKY=;
        b=sEhiMnRfyiutWngBSHq4MpG3PPzuNQXw+aHj6Pg+/BVTiSvfDbH7UyXek4ZMGs6/
        vvhXWRgyC8aEbMxv67bW6aCIQ+vsbz0eZGPnogZBHB3T4xuECqD0/v2JveYj6mWJhqL
        ns7G0TvlRY80WtoUUG7YebNCXn3uOol1Gt3MPQsY=
Subject: Re: Fixed buffer have out-dated content
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
Date:   Sun, 10 Jan 2021 16:50:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2021.01.10-54.240.4.15
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09.01.2021 21:32 Pavel Begunkov wrote:
> On 09/01/2021 16:58, Martin Raiber wrote:
>> On 09.01.2021 17:23 Jens Axboe wrote:
>>> On 1/8/21 4:39 PM, Martin Raiber wrote:
>>>> Hi,
>>>>
>>>> I have a gnarly issue with io_uring and fixed buffers (fixed
>>>> read/write). It seems the contents of those buffers contain old data in
>>>> some rare cases under memory pressure after a read/during a write.
>>>>
>>>> Specifically I use io_uring with fuse and to confirm this is not some
>>>> user space issue let fuse print the unique id it adds to each request.
>>>> Fuse adds this request data to a pipe, and when the pipe buffer is later
>>>> copied to the io_uring fixed buffer it has the id of a fuse request
>>>> returned earlier using the same buffer while returning the size of the
>>>> new request. Or I set the unique id in the buffer, write it to fuse (via
>>>> writing to a pipe, then splicing) and then fuse returns with e.g.
>>>> ENOENT, because the unique id is not correct because in kernel it reads
>>>> the id of the previous, already completed, request using this buffer.
>>>>
>>>> To make reproducing this faster running memtester (which mlocks a
>>>> configurable amount of memory) with a large amount of user memory every
>>>> 30s helps. So it has something to do with swapping? It seems to not
>>>> occur if no swap space is active. Problem occurs without warning when
>>>> the kernel is build with KASAN and slab debugging.
>>>>
>>>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>>>> does not occur.
>>>>
>>>> Problem occurs with 5.9.16 and 5.10.5.
>>> Can you mention more about what kind of IO you are doing, I'm assuming
>>> it's O_DIRECT? I'll see if I can reproduce this.
>> It's writing to/reading from pipes (nonblocking, no O_DIRECT).
> A blind guess, does it handle short reads and writes? If not, can you
> check whether they happen or not?

Something like this was what I suspected at first as well. It does check 
for short read/writes and I added (unnecessary -- because the fuse 
request structure is 40 bytes and it does io in page sizes) code for 
retrying short reads at some point. I also checked for the pipes to be 
empty before they are used at some point and let the kernel log 
allocation failures (idea was that it was short pipe read/writes because 
of allocation failure or that something doesn't get rewound properly in 
this case). Beyond that three things that make a user space problem 
unlikely:

  - occurs only when using fixed buffers and does not occur when running 
same code without fixed buffer opcodes
  - doesn't occur when there is no memory pressure
  - I added print(k/f) logging that pointed me in this direction as well

>> I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 2GB VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M memtester while it runs (so it swaps, I guess). I can try further reducing the reproducer, but I wanted to avoid that work in case it is something obvious. The next step would be to remove fuse from the equation -- it does try to move the pages from the pipe when splicing to it, for example.
>

