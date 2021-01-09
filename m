Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F472F01F3
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbhAIQ7l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:59:41 -0500
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:52401 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbhAIQ7l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610211500;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=788XJq1L89TdeddCiu/mPVXHzEbRSFKC9eF/JXwOR3Q=;
        b=OLfDYfnIBNtg5SjUJ9bpV2bHqKTRLgGftq4GhoOwUEx1H9SyKR+vx6MlFZjo6LjG
        JS76KT3KZwNlOi/sl4XUWlDNjM5mNjC96wB3exVRt2J/w6IKkmUffp5cVzRdKck9+57
        qLJIDGhBMYlDohXGXhr45yx7hfrYwk6shq0Gr3kU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610211500;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=788XJq1L89TdeddCiu/mPVXHzEbRSFKC9eF/JXwOR3Q=;
        b=ajYLiP05hnpAabdHdQQNooI+ZB8N5Wir04GQbVGsJtGjP1/rawcr9ZeFBOtao/p3
        xzbBtrssuIrd8GqpKTU96rSanHCplH+SpNVdzq9CDEARTxTIZ4JLwhbLr7aKsSDnPNF
        lJ+5ldDeJfG5xhtBweSyTaw3RVtjrMTKCRkR88Ww=
Subject: Re: Fixed buffer have out-dated content
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
Date:   Sat, 9 Jan 2021 16:58:20 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2021.01.09-54.240.4.6
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09.01.2021 17:23 Jens Axboe wrote:
> On 1/8/21 4:39 PM, Martin Raiber wrote:
>> Hi,
>>
>> I have a gnarly issue with io_uring and fixed buffers (fixed
>> read/write). It seems the contents of those buffers contain old data in
>> some rare cases under memory pressure after a read/during a write.
>>
>> Specifically I use io_uring with fuse and to confirm this is not some
>> user space issue let fuse print the unique id it adds to each request.
>> Fuse adds this request data to a pipe, and when the pipe buffer is later
>> copied to the io_uring fixed buffer it has the id of a fuse request
>> returned earlier using the same buffer while returning the size of the
>> new request. Or I set the unique id in the buffer, write it to fuse (via
>> writing to a pipe, then splicing) and then fuse returns with e.g.
>> ENOENT, because the unique id is not correct because in kernel it reads
>> the id of the previous, already completed, request using this buffer.
>>
>> To make reproducing this faster running memtester (which mlocks a
>> configurable amount of memory) with a large amount of user memory every
>> 30s helps. So it has something to do with swapping? It seems to not
>> occur if no swap space is active. Problem occurs without warning when
>> the kernel is build with KASAN and slab debugging.
>>
>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>> does not occur.
>>
>> Problem occurs with 5.9.16 and 5.10.5.
> Can you mention more about what kind of IO you are doing, I'm assuming
> it's O_DIRECT? I'll see if I can reproduce this.

It's writing to/reading from pipes (nonblocking, no O_DIRECT).

I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 2GB 
VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M 
memtester while it runs (so it swaps, I guess). I can try further 
reducing the reproducer, but I wanted to avoid that work in case it is 
something obvious. The next step would be to remove fuse from the 
equation -- it does try to move the pages from the pipe when splicing to 
it, for example.

