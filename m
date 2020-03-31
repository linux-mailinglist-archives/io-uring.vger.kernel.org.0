Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4741A1998FD
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2020 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgCaOxs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Mar 2020 10:53:48 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:43825 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgCaOxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Mar 2020 10:53:47 -0400
Received: by mail-il1-f195.google.com with SMTP id g15so19665500ilj.10
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2020 07:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0eOtXIqj2oDuIMpA9Wt18PpHJkAZb38WQ9zSO73WLSY=;
        b=DCEsyy1sudgvuAcOwREzLD03ObZfHEsvNPRdxZgk+VfQ2Imj8oLebFJpuxIXDQ2IDy
         hihYJujg7pgKegXN4t/7wCE2CIcECI3go7/7QtLEa4SypgnwKguW9fvs+NmJ9KP4GrXg
         VAnkmg4ISVqeWV60nOQv33NwY3FugQzEvLWsk6mYuqTH0eBx8o1p32pVgWIukOUYGPtm
         +iBoxa9Z7NWrYbMJ9Qv2FZ0SxThA6vjB8jInBe+D5gr7TC5cJjnjRlAsAt8ddIU4B86n
         1CHjlcuQgngL94VNXDNy7CHnE6v+5ucr+lPy8oSvze0v5rTvLFuY+Q23aMixyI5EHMGq
         Vngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0eOtXIqj2oDuIMpA9Wt18PpHJkAZb38WQ9zSO73WLSY=;
        b=i+uw64eN9mb/6DqcdaL9pfp6R8ll/f3xjWq2Y0tKcwHAZV1CGNtgsrXVi4ogU4WnTk
         Ob8RNca7Ltlj2noavHizOzdcIBuxXKDv1jvleclWBUzjrjBgHuGrniMimwBtIVqptXLE
         r0bSbnfogTgHhtD/dlyfqKWTpq9E/VXPWmyi7CRAV7i7lNEg6BZkaqxg/NgRFnGBm9r/
         AyZZbWqpmMwOOA8QHyeIsT8xNQSCepCZwcFbrgWsGZ/Z2mj7C5tla6N7ucrrv3833Rxv
         vffKXMtOxfWZiYTOjFgHl5G9mYKOoWBc73aJvX/aU9t/XQZ+jsRQbZ4yzESZ/xFsUFhJ
         SnPg==
X-Gm-Message-State: ANhLgQ2zE+eKbfsqfxmwlDLEK8f1Ismo5AHtmdX3aXGgDSwOHOXnvgMy
        TzIO5yXvkKFu+/ZGjUK5p34rgQ==
X-Google-Smtp-Source: ADFU+vtMg5iIxOv3TcW+zVaA43LrZFv03GGnEKvbbhsJWQMg6rZLgR2wheAMS9gYsskhrwLwwr/zUg==
X-Received: by 2002:a92:3b11:: with SMTP id i17mr17172566ila.161.1585666425632;
        Tue, 31 Mar 2020 07:53:45 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d70sm5985217ill.57.2020.03.31.07.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:53:44 -0700 (PDT)
Subject: Re: INFO: trying to register non-static key in io_cqring_ev_posted
 (2)
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <20200331114459.17184-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a9c10c6-30b7-4177-146c-c2da2585ce5d@kernel.dk>
Date:   Tue, 31 Mar 2020 08:53:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331114459.17184-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/20 5:44 AM, Hillf Danton wrote:
> 
> On Tue, 31 Mar 2020 04:14:03 -0700
>>
>> syzbot has bisected this bug to:
>>
>> commit b41e98524e424d104aa7851d54fd65820759875a
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Feb 17 16:52:41 2020 +0000
>>
>>     io_uring: add per-task callback handler
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115adadbe00000
>> start commit:   673b41e0 staging/octeon: fix up merge error
>> git tree:       upstream
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=135adadbe00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=155adadbe00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=acf766c0e3d3f8c6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=0c3370f235b74b3cfd97
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ac1b9de00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10449493e00000
>>
>> Reported-by: syzbot+0c3370f235b74b3cfd97@syzkaller.appspotmail.com
>> Fixes: b41e98524e42 ("io_uring: add per-task callback handler")
>>
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> Looks like another line is missed in that work.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5962,6 +5962,7 @@ static int io_sq_thread(void *data)
>  				}
>  				if (current->task_works) {
>  					task_work_run();
> +					finish_wait(&ctx->sqo_wait, &wait);
>  					continue;
>  				}
>  				if (signal_pending(current))

Can you send this as a properly formatted patch? That indeed looks like
the issue.

-- 
Jens Axboe

