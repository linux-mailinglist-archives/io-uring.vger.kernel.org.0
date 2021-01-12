Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C184C2F36A1
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 18:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390793AbhALRGL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 12:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbhALRGK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 12:06:10 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B247C0617A5;
        Tue, 12 Jan 2021 09:05:06 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r3so3297587wrt.2;
        Tue, 12 Jan 2021 09:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xbha0bjtgmWAV8KMhvonjfsuNNBF+pMbi8XLxFXZpV4=;
        b=BU9SRtiVu7oLwO/+fAIjbWo1tLwJTl8Q/EjTLuHcTLGrURyXGm/aLKuY9LQZjva4f/
         ZIje5ym5UQjfiC5NU6mWjrpqY3lzjkb072ITkP0Ynl+W0ZABBDnmlN+wzFR6/3kzQICa
         BKzYw16qvmBmdbV2rQhNFgEm+rlKj3FmTAgdGONCUygdBonP7rBUz9Qn+CO8ezt2IDfo
         sfQENtb4h1nxAo44reyi2nCkf5wEf0CKC3EYC8CGSuWg0UlWT4rFIXlOeMbszKmjYzx2
         t4/ophhrQvb+ZpAfFVVJbvGZhEwYbzK6oYFt+sV0i8OgGhOhyEgHRv4VW4Pyfu8wDcco
         36cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xbha0bjtgmWAV8KMhvonjfsuNNBF+pMbi8XLxFXZpV4=;
        b=nbqEw3ulN8o6s4P46kS2dK4CBFuzFW5hGEel8lw2OFFAD2PxL27B/L60eCwsfViMt2
         izvz9YCbF89kwfKz3WUqcjdfGOpUlBtjnSMbK6xbMd03p6urVaErtaH3m8ffHFpC8mjs
         OiBIzl7psWFXl8yEMvIQJ9YM+peZLgy+zgxMZDfXxYxNp8A8xWkDLguT8lZ47porEJYv
         ht7NQGR0xTzZ/xouXGg5dmlJKYwNJPPFfrFKueNcn61M6pAF7e4fktmwLJpD4OEglVAe
         83PFg6PkjgehGkJ1RXFAzNBsVLi0OAoOhvnfzWpo0IX/kZNjWf9WiCqf6Pl+SqJmXnWm
         z+1w==
X-Gm-Message-State: AOAM532TlhoAG/ev1bYA+prdP7SoFvMwTGALEdy5LV00EnaCZP7wJIpl
        yNshlHWYC1JcqDqCnWOaBj1HgBMtxSfUCQ==
X-Google-Smtp-Source: ABdhPJylMb4/4/R4GXfDfFwv44Nj3Tb/z3VGHaeowbn4WXPUMjRVGPFZCeg6YwaANPwqMX5lv9raaQ==
X-Received: by 2002:a5d:488b:: with SMTP id g11mr4259709wrq.5.1610471104977;
        Tue, 12 Jan 2021 09:05:04 -0800 (PST)
Received: from [192.168.8.120] ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id h5sm6155795wrp.56.2021.01.12.09.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 09:05:04 -0800 (PST)
To:     dsterba@suse.cz, Martin Raiber <martin@urbackup.org>,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
References: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
 <20210112153606.GS6430@twin.jikos.cz>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
Message-ID: <206bd726-e77c-da24-6560-69faee5281e0@gmail.com>
Date:   Tue, 12 Jan 2021 17:01:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210112153606.GS6430@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/01/2021 15:36, David Sterba wrote:
> On Fri, Jan 08, 2021 at 12:02:48AM +0000, Martin Raiber wrote:
>> When reading from btrfs file via io_uring I get following
>> call traces:
> 
> Is there a way to reproduce by common tools (fio) or is a specialized
> one needed?

I'm not familiar with this particular issue, but:
should _probably_ be reproducible with fio with io_uring engine
or fio/t/io_uring tool.

> 
>> [<0>] wait_on_page_bit+0x12b/0x270
>> [<0>] read_extent_buffer_pages+0x2ad/0x360
>> [<0>] btree_read_extent_buffer_pages+0x97/0x110
>> [<0>] read_tree_block+0x36/0x60
>> [<0>] read_block_for_search.isra.0+0x1a9/0x360
>> [<0>] btrfs_search_slot+0x23d/0x9f0
>> [<0>] btrfs_lookup_csum+0x75/0x170
>> [<0>] btrfs_lookup_bio_sums+0x23d/0x630
>> [<0>] btrfs_submit_data_bio+0x109/0x180
>> [<0>] submit_one_bio+0x44/0x70
>> [<0>] extent_readahead+0x37a/0x3a0
>> [<0>] read_pages+0x8e/0x1f0
>> [<0>] page_cache_ra_unbounded+0x1aa/0x1f0
>> [<0>] generic_file_buffered_read+0x3eb/0x830
>> [<0>] io_iter_do_read+0x1a/0x40
>> [<0>] io_read+0xde/0x350
>> [<0>] io_issue_sqe+0x5cd/0xed0
>> [<0>] __io_queue_sqe+0xf9/0x370
>> [<0>] io_submit_sqes+0x637/0x910
>> [<0>] __x64_sys_io_uring_enter+0x22e/0x390
>> [<0>] do_syscall_64+0x33/0x80
>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Prevent those by setting IOCB_NOIO before calling
>> generic_file_buffered_read.
>>
>> Async read has the same problem. So disable that by removing
>> FMODE_BUF_RASYNC. This was added with commit
>> 8730f12b7962b21ea9ad2756abce1e205d22db84 ("btrfs: flag files as
> 
> Oh yeah that's the commit that went to btrfs code out-of-band. I am not
> familiar with the io_uring support and have no good idea what the new
> flag was supposed to do.

iirc, Jens did make buffered IO asynchronous by waiting on a page
with wait_page_queue, but don't remember well enough.

> 
>> supporting buffered async reads") with 5.9. Io_uring will read
>> the data via worker threads if it can't be read without sync IO
>> this way.
> 
> What are the implications of that? Like more context switching (due to
> the worker threads) or other potential performance related problems?

io_uring splits submission and completion steps and usually expect
submissions to happen quick and not block (at least for long),
otherwise it can't submit other requests, that reduces QD and so
forth. In the worst case it can serialise it to QD1. I guess the
same can be applied to AIO.

-- 
Pavel Begunkov
