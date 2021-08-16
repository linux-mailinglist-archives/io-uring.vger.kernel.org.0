Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47F83EDF92
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 23:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhHPV6Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 17:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhHPV6X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 17:58:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69109C0613C1
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 14:57:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e15so22224258plh.8
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 14:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w0gBUvcfT9p7HZwNIy8O6fg521MOLC17VQ+Fm13oktc=;
        b=e/qUpIYLNwQBkBu6puLKC7WY25hd89SUf4iKG166+iewrTwI1VD7pdDtYQX3RHZTGh
         ZotGW4bghaT/4ufBCjSWigSGeuGUaJvEItfpMsUeFPcbw65/NgZU4afLLk62YTcA3VK5
         yKlF7yH+EkUN/lq2fzIj03o0o6lLkBx7iWGT8BxfOt7fFo64WDqfBHGttx0pDwX41bD0
         03w9UEl4ZPmUxFLQNMoU8F8ca0PVdW0D4Ds4ulq3Awz21wImMsioAcNnlMbpG727qNJ6
         1XRhBP5WWFKBgL/QvLHiGpgXDJ1wXxG3KbZKWnAnegOjcQsrZuC1HCT7bK2FELDUruzw
         vuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w0gBUvcfT9p7HZwNIy8O6fg521MOLC17VQ+Fm13oktc=;
        b=TUYW64d8FQWAvFNsH0mLL7wVgnvdZBXeodVGOUFVjUT1wmE2DH+KrEJNT+f9UG7wsY
         S+z0YKrLWY4xZEdluyz2gmCyIDPW1qWljRiY5z9LYDoO0EzyjAUApH3xcJgmYr3Qqgtl
         WC41Asw9pm2KjJhJv4HDxG5ZUBgGauSspwf04dvZaRYYcRHDPAbDWeZPPBjIzOLsGjuI
         28JXR6V3oefVQvS1O9QHbWQSe3sJMrA9LuTe3YnIMQTtGkwathyDq0lV5QWB6b2afrcf
         E4BYpJFL57SaxAf46u0puelhcwFW6l/NV862vCUPuj6iPO7OAmkMFkIsbr1gKKHtgMSa
         daWg==
X-Gm-Message-State: AOAM530YZTa88SMRWlCOKAtYyIr10NePkOpUGj+9MXZ/xYFd7JCzCcTn
        SRvCU+jcUYXPN6Kqvo/ktz3ZEw==
X-Google-Smtp-Source: ABdhPJxK9JdjhESwVsZ8+4W0CK7yZ7cjFJCGZX96Ju4XTfTfF4N7nHIt4NOzgHy6v91jxM/FriFBkA==
X-Received: by 2002:a17:902:8648:b029:129:dda4:ddc2 with SMTP id y8-20020a1709028648b0290129dda4ddc2mr291848plt.4.1629151070864;
        Mon, 16 Aug 2021 14:57:50 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j6sm132419pfi.220.2021.08.16.14.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:57:50 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
From:   Jens Axboe <axboe@kernel.dk>
To:     syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000011fc2505c9b41023@google.com>
 <8236fd18-bf97-b7c6-b2c7-84df0a9bd8e5@kernel.dk>
Message-ID: <d13c4e6b-b935-c517-f90d-d8201861800f@kernel.dk>
Date:   Mon, 16 Aug 2021 15:57:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8236fd18-bf97-b7c6-b2c7-84df0a9bd8e5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 3:49 PM, Jens Axboe wrote:
> On 8/16/21 3:41 PM, syzbot wrote:
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    b9011c7e671d Add linux-next specific files for 20210816
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1784d5e9300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17479216300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147f0111300000
> 
> #syz test: git://git.kernel.dk/linux-block for-next

Forgot to push out the update...

#syz test: git://git.kernel.dk/linux-block 16a390b4109c6eaa65f84e31c2c1d19bcbeb666f


-- 
Jens Axboe

