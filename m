Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9D2F6D85
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbhANVvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:51:25 -0500
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:41485 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730236AbhANVvX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610661005;
        h=Subject:From:To:References:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=R8R4MphPd6WmnFqxAVEK8yhz00h89byOfXrnAMCkFMw=;
        b=ZgTQMyw+9oFC7Hzg8iUsIh6GDnTILOAUpv68f4bWs1kiDmo/8k40cGlq/ZzOd9j6
        tp+cK0j0dTxKcl9IixPpxZirlEK//fnetFUqUzEjZXQCnQeblY8tcJOYktfTvpuGOa6
        BoqinzkmRJA2ZrHJQh6GKNPIzIV6arb/EASYtbZc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610661005;
        h=Subject:From:To:References:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=R8R4MphPd6WmnFqxAVEK8yhz00h89byOfXrnAMCkFMw=;
        b=n5iL7DKYJirCEQcVapIvexBZst5HkeFvUe4jJdIjhNNrJT0tBS/s+oVvf1bXhial
        z4bmN1Caz/XGIScTIGwTTiPHlpmVbdGqlFvbmuBT6p6xsSyW0v4b6xdCZwDYmLKVQxH
        /4Bp4vIqLdv0wXgoSYK4vo+SbnyOsXyvynSUs6rA=
Subject: Re: Fixed buffers have out-dated content
From:   Martin Raiber <martin@urbackup.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
 <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
Message-ID: <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
Date:   Thu, 14 Jan 2021 21:50:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2021.01.14-54.240.4.6
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10.01.2021 17:50 Martin Raiber wrote:
> On 09.01.2021 21:32 Pavel Begunkov wrote:
>> On 09/01/2021 16:58, Martin Raiber wrote:
>>> On 09.01.2021 17:23 Jens Axboe wrote:
>>>> On 1/8/21 4:39 PM, Martin Raiber wrote:
>>>>> Hi,
>>>>>
>>>>> I have a gnarly issue with io_uring and fixed buffers (fixed
>>>>> read/write). It seems the contents of those buffers contain old 
>>>>> data in
>>>>> some rare cases under memory pressure after a read/during a write.
>>>>>
>>>>> Specifically I use io_uring with fuse and to confirm this is not some
>>>>> user space issue let fuse print the unique id it adds to each 
>>>>> request.
>>>>> Fuse adds this request data to a pipe, and when the pipe buffer is 
>>>>> later
>>>>> copied to the io_uring fixed buffer it has the id of a fuse request
>>>>> returned earlier using the same buffer while returning the size of 
>>>>> the
>>>>> new request. Or I set the unique id in the buffer, write it to 
>>>>> fuse (via
>>>>> writing to a pipe, then splicing) and then fuse returns with e.g.
>>>>> ENOENT, because the unique id is not correct because in kernel it 
>>>>> reads
>>>>> the id of the previous, already completed, request using this buffer.
>>>>>
>>>>> To make reproducing this faster running memtester (which mlocks a
>>>>> configurable amount of memory) with a large amount of user memory 
>>>>> every
>>>>> 30s helps. So it has something to do with swapping? It seems to not
>>>>> occur if no swap space is active. Problem occurs without warning when
>>>>> the kernel is build with KASAN and slab debugging.
>>>>>
>>>>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>>>>> does not occur.
>>>>>
>>>>> Problem occurs with 5.9.16 and 5.10.5.
>>>> Can you mention more about what kind of IO you are doing, I'm assuming
>>>> it's O_DIRECT? I'll see if I can reproduce this.
>>> It's writing to/reading from pipes (nonblocking, no O_DIRECT).
>> A blind guess, does it handle short reads and writes? If not, can you
>> check whether they happen or not?
>
> Something like this was what I suspected at first as well. It does 
> check for short read/writes and I added (unnecessary -- because the 
> fuse request structure is 40 bytes and it does io in page sizes) code 
> for retrying short reads at some point. I also checked for the pipes 
> to be empty before they are used at some point and let the kernel log 
> allocation failures (idea was that it was short pipe read/writes 
> because of allocation failure or that something doesn't get rewound 
> properly in this case). Beyond that three things that make a user 
> space problem unlikely:
>
>  - occurs only when using fixed buffers and does not occur when 
> running same code without fixed buffer opcodes
>  - doesn't occur when there is no memory pressure
>  - I added print(k/f) logging that pointed me in this direction as well
>
>>> I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 
>>> 2GB VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M 
>>> memtester while it runs (so it swaps, I guess). I can try further 
>>> reducing the reproducer, but I wanted to avoid that work in case it 
>>> is something obvious. The next step would be to remove fuse from the 
>>> equation -- it does try to move the pages from the pipe when 
>>> splicing to it, for example.

When I use 5.10.7 with 09854ba94c6aad7886996bfbee2530b3d8a7f4f4 ("mm: 
do_wp_page() simplification"), 1a0cf26323c80e2f1c58fc04f15686de61bfab0c 
("mm/ksm: Remove reuse_ksm_page()") and 
be068f29034fb00530a053d18b8cf140c32b12b3 ("mm: fix misplaced unlock_page 
in do_wp_page()") reverted the issue doesn't seem to occur.

