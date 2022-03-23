Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE844E49F2
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 01:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiCWAJt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 20:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiCWAJr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 20:09:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708713F7B
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 17:08:18 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so172796pjf.1
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 17:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=sAxPWh/aZhdCOlaJj0vWLLg1UzQ/98ltp1ezFXemBlI=;
        b=qVHK6QFE2tfGVj/rS+smA3KWjMSFaH4R2TYoaXm0WZDYO28TXTNCoPOeS/wBcqP1oq
         1u3737eLdEy5wqMnm09mUgdBnt3CZAGbl09t9P0Za3qrbEit0t/I83hLJLm5gBXaMivV
         AJNjuV3LAeVBrDlWvln+B7ZBDnpfYAllF7WjvhYA5OtO2Z/53tItpuEb/qQl2C2gyFeW
         Ky7RMxG7c/fX9pXBJTCPKy22qQuN+zSY0wjUZ0JhXamHvhxsNLBKTCzxFvvqjdPuphe/
         YJY//zi6o33EcXYstIT90GdFal0CBLmgf0wWuO6L1lCMJR1h3c77c9KWQzcHbZpTGFC0
         kmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sAxPWh/aZhdCOlaJj0vWLLg1UzQ/98ltp1ezFXemBlI=;
        b=YXvEeiG0Jz68RpT/s8FgZxIkrc4xnuwIXw658bwRVVzmgeAbT/e/9yIsOh9Q6DKTRH
         yTWpUUKH7VePtYTdyjLIXj/LVg0SJur6ZV1QSlnHqf49aJOgWfNxVTikleXBIYN+7fTV
         +6x78eajrRgxstAdurvY/qymhD7BQZgTAA3nMXwtjCkQCb8v5wxc17IHN+LF+Bcr8Lf5
         OyiiAzvn2CSvXMa1uqdKD8n8gtj4ZIf0UineYrHup6T7ietpCXvvGiMJ/rLuqbD4xGO6
         70K0oz22ARWxUOjh7pWcjEma1o/ihrKbtWNICO25E6RvUgsakytoraJt3EzuvQY6b4L7
         nl9g==
X-Gm-Message-State: AOAM5318PMRUvSS0JhBbFh4AA2rjY0tVdRxg/iynCGQMKkLjBJEcO9YT
        OoHQC7d8/JincHdzdC6rITSFhg==
X-Google-Smtp-Source: ABdhPJzi1azK51h/jovWI3Bh8IoUHKOYQ9P+MerXKCYJ0DUUhQF8t0tEK9wzi3LQAmayjCTyRNGhfw==
X-Received: by 2002:a17:90b:388c:b0:1bf:4047:c7c6 with SMTP id mu12-20020a17090b388c00b001bf4047c7c6mr8189328pjb.24.1647994098389;
        Tue, 22 Mar 2022 17:08:18 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o7-20020aa79787000000b004f8e44a02e2sm26461527pfp.45.2022.03.22.17.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 17:08:17 -0700 (PDT)
Message-ID: <8bcf2234-983e-171f-90dd-ff0c07412b46@kernel.dk>
Date:   Tue, 22 Mar 2022 18:08:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
Content-Language: en-US
To:     syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, jirislaby@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000042c81b05dad717e6@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000042c81b05dad717e6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/22 5:37 PM, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 91eac1c69c202d9dad8bf717ae5b92db70bfe5cf
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Mar 16 22:59:10 2022 +0000
> 
>     io_uring: cache poll/double-poll state with a request flag
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1280c825700000
> start commit:   b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1180c825700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1680c825700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=63af44f0631a5c3a
> dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14506ddb700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139b2093700000
> 
> Reported-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com
> Fixes: 91eac1c69c20 ("io_uring: cache poll/double-poll state with a request flag")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz test: git://git.kernel.dk/linux-block for-5.18/io_uring

All three reports are the same thing...

-- 
Jens Axboe

