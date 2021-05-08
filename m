Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA9377250
	for <lists+io-uring@lfdr.de>; Sat,  8 May 2021 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhEHOS3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 May 2021 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHOS3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 May 2021 10:18:29 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CDDC061574;
        Sat,  8 May 2021 07:17:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z6so12043191wrm.4;
        Sat, 08 May 2021 07:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=H3c5ec7McH5Zt4hIpHC+Y3YBw9oxk9RjSdvboac24Mk=;
        b=cI9frh2jqh7zWEi4uhTuc4yKutnoTEH+9cpqpZbeqkuzr4YHNyxvur0Wm1h+hOlxIB
         GdjfrTA0xoeOvMyML0J41fabzDhp66p0ckS+RHFDNDdJ6H3ZcV8J+1uoYwrS0L0jRlrC
         4kzSuSU4egJLjzrIZ+ItBsSWHczvYcoiYbmy3KYEMPOp5e+z4OpAMz/MNkxMn1YH7+Uy
         sPYu9AudF8DtmK6+Zvgbv1zA0Oh9ZRWe8r1+PtUWm3diPfzfdiXfm3KpMfx7ogI/AsCh
         8BzgqY4Cx5OrCjWfVvkvkmXEnJQh3cEytOgFJGdOHkKuCSXfG+KHfvAGt3gVGnVG1oxM
         3fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H3c5ec7McH5Zt4hIpHC+Y3YBw9oxk9RjSdvboac24Mk=;
        b=IKS+Cut80tnonXJOt7hWj1jE8o3tLJ6jiX5C6qAd0amE+lw3+hHFIAAbxjJzGnQBou
         F9xk7k1PYjZTXA+4/WE3ILsel9Lk3m3r5K/25Fs7f6X4Yc0pvw/mD16tBEqCmU2nYrO4
         l/KxMDnx4Hn0PZC8uGX6ojT2GUb6hd/vWj5BVZhVR9TEROQ9sA8yZYtPA8hs4Ozz2YkW
         hhv0zyeUeDw4M0Uexx0319FVHCqgYRauk1A54iQGLBUvb5z3euixLl88M1aEJ4ES6lib
         NQJF4XQw6BcEh6y1iudqmZm9rLtd0pEZblexJMpQErewa4W1rDEDGII9ZlWPM3fO0Auj
         SS0w==
X-Gm-Message-State: AOAM531e40olD6DOGJHttoGT0sd2mYsLDKN77s15HD+N3Ro5pU+K5zro
        c8RKi1gZJHKQStIQ4XwLRlk=
X-Google-Smtp-Source: ABdhPJyLdig4xicDV+GKZswgYqckgYoB7vw2Ow/WK44uKVYYamhRUA9+gdBrs/5G2QKJCc+xwFoRcQ==
X-Received: by 2002:a5d:660c:: with SMTP id n12mr19405903wru.87.1620483445776;
        Sat, 08 May 2021 07:17:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id f25sm13693750wrd.67.2021.05.08.07.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 07:17:25 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in __io_uring_cancel
To:     syzbot <syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000004f05705c1c86547@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c2bba1fe-a091-e08f-2e0e-cfe7759e3f72@gmail.com>
Date:   Sat, 8 May 2021 15:17:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000004f05705c1c86547@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/21 3:35 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         50b7b6f2 x86/process: setup io_threads more like normal us..
> git tree:       git://git.kernel.dk/linux-block io_uring-5.13
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5e1cf8ad694ca2e1
> dashboard link: https://syzkaller.appspot.com/bug?extid=47fc00967b06a3019bd2
> compiler:       
> 
> Note: testing is done by a robot and is best-effort only.
> 

#syz fix: io_uring: fix work_exit sqpoll cancellations

-- 
Pavel Begunkov
