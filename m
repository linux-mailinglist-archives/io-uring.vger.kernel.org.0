Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30BD3E4F00
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhHIWMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 18:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbhHIWMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 18:12:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2204BC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 15:11:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso2237965pjb.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 15:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hX3VChd2KsGzzsgqaNA5SejDDDrhM0mSV55+UbjX7p0=;
        b=0+ylcrKAvEfZSuM7N/2HMq/OMKX716PaPQqYLXXlmVpcylD8nBZYjrC9bmFJbxGfQ2
         n8/wQcjPPquknIuUPvDvOkbnK79QtKqpHFoxua7P5GnvPagtlDm7qV2+JKYmq8JYaaic
         7qv9eCtpzsUAaoK5/KR2gOhK6yLnAp+Fbm8fM+ufSkT2hrYGo8gmbwfQkI4PvXeO8nWl
         ELU44JVjxKrxSM4kuxShF+3qk+MjiJBO+dpuD5Wk9TCT2tqkxlrD9LBjzb+h2fkm33ps
         o7Ffr5Yaqu8JnZBi0mZ9MeQK2xD5WTrQj99+t7IDlzsJDo+yBgLKY9i635CBtnrXDef1
         I0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hX3VChd2KsGzzsgqaNA5SejDDDrhM0mSV55+UbjX7p0=;
        b=MvolxO9LM1GHa8lzS5gj38aCd6qbbVLgH3ZPb8fG9cfsQq4WYVWSR1kczaxDY3Rh2s
         X+Sj/TLRiyn1JJQPMYO9ofdLguYkcNp29nQtOygjignKRya1eksdj6QIg9JDmzOZ2U5n
         eBU/lFFIvhDq2ibasjIhHZThwmGp1WFFNjtJUp+CSM5ZreFmShaeabfBknan4dT5FlQm
         cP0d0TNkXaNpUt95EQQzA9pIEIhCsA0mEioVz+1fWs4iNgev/+PFZtVHi9KUhhq3eMkZ
         9Nm7oezcRvRHm5qvqGK4L87QAQkPCN4xtBynQpztWk3ia5SpEgSTi62Br1A5nUVXxkIF
         Jk+Q==
X-Gm-Message-State: AOAM530Rf3vRyuOHJ5FdV8LXkLssW1B9ZpNlrUR9MiRX4p4CpKB0MaKA
        L4AK4kg6dduXuDvUoj1Dvi3Y6VnEpQHk4X+a
X-Google-Smtp-Source: ABdhPJxWJst2E3TY6mnV9U/BwSzkOH2vbEumSSPe1yY9/wI402tvl215ux0c7mZElWcrbrFyvzjrfw==
X-Received: by 2002:a17:90a:db44:: with SMTP id u4mr1314958pjx.180.1628547118311;
        Mon, 09 Aug 2021 15:11:58 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 65sm24396584pgi.12.2021.08.09.15.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 15:11:57 -0700 (PDT)
Subject: Re: iouring locking issue in io_req_complete_post() /
 io_rsrc_node_ref_zero()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com>
 <3f2529b9-7815-3562-9978-ee29bf7692e5@kernel.dk>
 <633EF027-6473-466B-8683-E5CBC10B0F5F@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce42b472-c629-bf0b-f955-47fc4cda457c@kernel.dk>
Date:   Mon, 9 Aug 2021 16:11:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <633EF027-6473-466B-8683-E5CBC10B0F5F@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 4:01 PM, Nadav Amit wrote:
> 
>> On Aug 9, 2021, at 6:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/8/21 10:36 PM, Nadav Amit wrote:
>>> Jens, others,
>>>
>>> Sorry for bothering again, but I encountered a lockdep assertion failure:
>>>
>>> [  106.009878] ------------[ cut here ]------------
>>> [  106.012487] WARNING: CPU: 2 PID: 1777 at kernel/softirq.c:364 __local_bh_enable_ip+0xaa/0xe0
>>> [  106.014524] Modules linked in:
>>> [  106.015174] CPU: 2 PID: 1777 Comm: umem Not tainted 5.13.1+ #161
>>> [  106.016653] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
>>> [  106.018959] RIP: 0010:__local_bh_enable_ip+0xaa/0xe0
>>> [  106.020344] Code: a9 00 ff ff 00 74 38 65 ff 0d a2 21 8c 7a e8 ed 1a 20 00 fb 66 0f 1f 44 00 00 5b 41 5c 5d c3 65 8b 05 e6 2d 8c 7a 85 c0 75 9a <0f> 0b eb 96 e8 2d 1f 20 00 eb a5 4c 89 e7 e8 73 4f 0c 00 eb ae 65
>>> [  106.026258] RSP: 0018:ffff88812e58fcc8 EFLAGS: 00010046
>>> [  106.028143] RAX: 0000000000000000 RBX: 0000000000000201 RCX: dffffc0000000000
>>> [  106.029626] RDX: 0000000000000007 RSI: 0000000000000201 RDI: ffffffff8898c5ac
>>> [  106.031340] RBP: ffff88812e58fcd8 R08: ffffffff8575dbbf R09: ffffed1028ef14f9
>>> [  106.032938] R10: ffff88814778a7c3 R11: ffffed1028ef14f8 R12: ffffffff85c9e9ae
>>> [  106.034363] R13: ffff88814778a000 R14: ffff88814778a7b0 R15: ffff8881086db890
>>> [  106.036115] FS:  00007fbcfee17700(0000) GS:ffff8881e0300000(0000) knlGS:0000000000000000
>>> [  106.037855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  106.039010] CR2: 000000c0402a5008 CR3: 000000011c1ac003 CR4: 00000000003706e0
>>> [  106.040453] Call Trace:
>>> [  106.041245]  _raw_spin_unlock_bh+0x31/0x40
>>> [  106.042543]  io_rsrc_node_ref_zero+0x13e/0x190
>>> [  106.043471]  io_dismantle_req+0x215/0x220
>>> [  106.044297]  io_req_complete_post+0x1b8/0x720
>>> [  106.045456]  __io_complete_rw.isra.0+0x16b/0x1f0
>>> [  106.046593]  io_complete_rw+0x10/0x20
>>>
>>> [ .... The rest of the call-stack is my stuff ] 
>>>
>>>
>>> Apparently, io_req_complete_post() disables IRQs and this code-path seems
>>> valid (IOW: I did not somehow cause this failure). I am not familiar with
>>> this code, so some feedback would be appreciated.
>>
>> Can you try with this patch?
> 
> Thanks! I might have hit another issue, but apparently even if it is
> real, it is unrelated.
> 
> Tested-by: Nadav Amit <nadav.amit@gmail.com>

Thanks for testing! And regarding another issue, I would expect nothing
less :-). It's always interesting to see new paths being paved, and
inevitably that'll shake out a few issues in code that's been less
exercised than the general part.

-- 
Jens Axboe

