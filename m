Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72C347313D
	for <lists+io-uring@lfdr.de>; Mon, 13 Dec 2021 17:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhLMQGe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Dec 2021 11:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240287AbhLMQGd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Dec 2021 11:06:33 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F15C061574
        for <io-uring@vger.kernel.org>; Mon, 13 Dec 2021 08:06:33 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e128so19059305iof.1
        for <io-uring@vger.kernel.org>; Mon, 13 Dec 2021 08:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wosmB9PxFEFwiBTzx+ccKeiFCy43oa7nLi45YgJ+TwI=;
        b=nIafQMrPaOkkx8ilGxdiTnYhtxnsm6iIl+ZubseP4x9pa5KrkyFSb8gn16j/6j1uHE
         XCoMwMiQLzQreqtEcA9ZmgEWVHHeB9ipW7IDCQDO53h3UMRjuWAOglJsNI+AU5E4HhQA
         RWoNuG7YlcY47vdDBqRsqaoDpCSgFOWRaJpYPgOfSgbzvDwKUKG1zaVJV7lr0+V25wSx
         rBTkdIwvdN0HbXzTaSZEn5wKCR4/NovHreqxn4JSIHGZlQdLvLYmyJ3ZppbW5ogltXjW
         fJ9qAMAfE0hviIhG3MzgTCpz2ozOp3TxgIM3Hl+eTzlpSed6PvZfzX7NAaRTieGtDz1L
         915g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wosmB9PxFEFwiBTzx+ccKeiFCy43oa7nLi45YgJ+TwI=;
        b=1/a9NAPFKjvTP4jjqowk0H2siUVfkWMsJ4XicOT8lMrRN3gidez1d4YpQfjp8w32lV
         OBJ7NCWCu4uIixgPu3ur/P1cROpwi+eSfdJkQpIXVwCfd5bQmkBXt+PEP7W5be5kq+na
         m/cOVVOfXOoa52gqUL76LBv8NKlRTHqEkXkI/ZUqaRSzldyiYvBkWQDp7oiYnOrP6FZH
         s5yAbZ1HqTDHfgQ7LQpubB9O1fViMlCyqVgNYNpjayL+uEgTSr4xkXXKR21RuU7jrsC5
         Ol9yLjfhU38QFZLbA4X/ZKD7cQwNlyQtRYzljcobJG5BVO7R+41diX7t8p66WhgM+Xqg
         chIw==
X-Gm-Message-State: AOAM530XISPVLD+z///D9hZbIWajJ9iBohS2LJ+XnPzEO73bPFpTksh1
        xnGJXzt8EoNiv/jbV9oKrwrR8OWI/mtlZw==
X-Google-Smtp-Source: ABdhPJzsysd5Rxgl49Rp+s2Vk3n19RRPgUULpI3VbWFUOl7QEUjoTN4XMzpCL/pKOImKNofYNR7kXg==
X-Received: by 2002:a05:6602:2cce:: with SMTP id j14mr34874989iow.111.1639411592711;
        Mon, 13 Dec 2021 08:06:32 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n10sm9652148ilk.58.2021.12.13.08.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 08:06:32 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_worker_cancel_cb
To:     syzbot <syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000080c88305d300e67f@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <494d69b4-d9da-b698-39e6-ed41b64a09a7@kernel.dk>
Date:   Mon, 13 Dec 2021 09:06:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000080c88305d300e67f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/12/21 11:08 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a763d5a5abd6 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12b900bab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7d5e878e3399b6cc
> dashboard link: https://syzkaller.appspot.com/bug?extid=b18b8be69df33a3918e9
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143f7551b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f56825b00000
> 
> The issue was bisected to:
> 
> commit 71a85387546e50b1a37b0fa45dadcae3bfb35cf6
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Dec 10 15:29:30 2021 +0000
> 
>     io-wq: check for wq exit after adding new worker task_work

#syz test git://git.kernel.dk/linux-block io_uring-5.16

-- 
Jens Axboe

