Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C6A2F037E
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 21:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbhAIUgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 15:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbhAIUgw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 15:36:52 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FBCC061786
        for <io-uring@vger.kernel.org>; Sat,  9 Jan 2021 12:36:11 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id i9so12323903wrc.4
        for <io-uring@vger.kernel.org>; Sat, 09 Jan 2021 12:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bYHgq1Xevy37+omyLYqazcE+5PyTQiE2p4YRxzHJnpM=;
        b=Dbj0AkMyGNVKiIbwM819xAGTCYMP7+t7j8w2X49It9wThT7ORqVsmFK85adoWPDvFz
         DxshZLcWzlQGhXRIvVmiCmLJdliYw1EuffkJd7yh/akyGDCsM1abBiZ/d8pH0wkCEw0X
         +dHhUVHbuIYkdSVY6sBWjD4WQgl+oqxC0gYjniFkyhUNKYkz/G6HrQFJLfrwi/JcF+he
         mBC3CfExOkPw+USR4lKSqkbJnGBM7OKCHdRPpucCgf2bkvDy42uyvYNCdGrXlTDr3J4+
         w9IwLQmCiXhSOt9cVLOBNHuj8QKCUExUqKdW3ArO8apj+TrdOiqnLXdUOFab6IlHZaFi
         nptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bYHgq1Xevy37+omyLYqazcE+5PyTQiE2p4YRxzHJnpM=;
        b=hVOxi0s0eAki39Bfey+LTB78qsuxR6UHrXqe7JYvkbCxRL3dUHIPS/drlVTKho78y+
         wQouw2UQS17OO1QyjfYoo7T/9OFt0aYBgnOCyMPCkvouVCb3eEbcg/DsoXvQiF48PDa/
         dZVnP7LfmKBDNcPt75dknRQpiSRVNKjgy6Ig0JJv3txe8l+jD2VFRquAtWzggrTIsAq7
         z3ou5iI7ks0c4E8F/ofANSBOXzy8MPw00Mck6JVawhyGuxCTfoUR9tGvJTPefHUvSn6M
         0mzpP2PiCm93/pHAs+wttD8hvsokuP5wYd9MMZtwGwPCypo8AjOvPO/4eQ31VxjcLmli
         h0PQ==
X-Gm-Message-State: AOAM533X+Z1pCACo8dlaqad2szSv0P4xP0QDfDlpiAYJLRXkvnjlGtE1
        RDKeJG20zCqZA3Wb/Lfk1zX/3PNwHO4lk1sJ
X-Google-Smtp-Source: ABdhPJy/BUloCTbaiWXZcXlCaMeYtQw/CCfZqIrZPPiU7iXjCH8iSo+BQzmF/QwxmbdEy/TzqVAEoQ==
X-Received: by 2002:a5d:60cb:: with SMTP id x11mr9586882wrt.0.1610224570063;
        Sat, 09 Jan 2021 12:36:10 -0800 (PST)
Received: from [192.168.8.114] ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id h20sm19425570wrb.21.2021.01.09.12.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 12:36:09 -0800 (PST)
To:     Martin Raiber <martin@urbackup.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Fixed buffer have out-dated content
Message-ID: <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
Date:   Sat, 9 Jan 2021 20:32:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/01/2021 16:58, Martin Raiber wrote:
> On 09.01.2021 17:23 Jens Axboe wrote:
>> On 1/8/21 4:39 PM, Martin Raiber wrote:
>>> Hi,
>>>
>>> I have a gnarly issue with io_uring and fixed buffers (fixed
>>> read/write). It seems the contents of those buffers contain old data in
>>> some rare cases under memory pressure after a read/during a write.
>>>
>>> Specifically I use io_uring with fuse and to confirm this is not some
>>> user space issue let fuse print the unique id it adds to each request.
>>> Fuse adds this request data to a pipe, and when the pipe buffer is later
>>> copied to the io_uring fixed buffer it has the id of a fuse request
>>> returned earlier using the same buffer while returning the size of the
>>> new request. Or I set the unique id in the buffer, write it to fuse (via
>>> writing to a pipe, then splicing) and then fuse returns with e.g.
>>> ENOENT, because the unique id is not correct because in kernel it reads
>>> the id of the previous, already completed, request using this buffer.
>>>
>>> To make reproducing this faster running memtester (which mlocks a
>>> configurable amount of memory) with a large amount of user memory every
>>> 30s helps. So it has something to do with swapping? It seems to not
>>> occur if no swap space is active. Problem occurs without warning when
>>> the kernel is build with KASAN and slab debugging.
>>>
>>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>>> does not occur.
>>>
>>> Problem occurs with 5.9.16 and 5.10.5.
>> Can you mention more about what kind of IO you are doing, I'm assuming
>> it's O_DIRECT? I'll see if I can reproduce this.
> 
> It's writing to/reading from pipes (nonblocking, no O_DIRECT).

A blind guess, does it handle short reads and writes? If not, can you
check whether they happen or not?

> 
> I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 2GB VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M memtester while it runs (so it swaps, I guess). I can try further reducing the reproducer, but I wanted to avoid that work in case it is something obvious. The next step would be to remove fuse from the equation -- it does try to move the pages from the pipe when splicing to it, for example.


-- 
Pavel Begunkov
