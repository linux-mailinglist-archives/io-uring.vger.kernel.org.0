Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833D93FF267
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 19:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346696AbhIBRhJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346663AbhIBRhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 13:37:07 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8FFC061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 10:36:08 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b4so2624830ilr.11
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 10:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Xta9WuosfUfQ0MZht+mdjfWyHyDpCkZYojaF+Jm6iGs=;
        b=CDSxKKo66SjXyjfTeSDmi97oA7l/lfgL3Pp/bWXBquVdXJqSI9Qb1t8vXUw2097TZH
         eBiJ+/5CutdheghdlHzGxXqnkFwB7qWPNjRUc+xkA5o35LubHK14lbHwIZSoBK9+HPSm
         Ez5aCWOx0b/qXmeaO2e7AfoiS+Mv+S1z3L2AAEuj7oyfphk9kkoQCtvUO+iKMqCOUApT
         CDjAICei8MXvXYW6AL3x9v9pFZQdeHix3kiRWvJsnnIbZAj5zzVjKv3gR+SfxBaQ5XqW
         OMCxI6ZzLwnH4U3toV2Wvrptx5A810ziPMQeGNmrPxxoeWGeIuINUDqvPg8GptQd1qLC
         rGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xta9WuosfUfQ0MZht+mdjfWyHyDpCkZYojaF+Jm6iGs=;
        b=rdtMxePrYBYOcvPJOV9NzWYbY4Ou0QG1ZRd0bYB6euxnJyVqoilozEa6kCWv0+8x3D
         sj2Yt2tMNafumx40iO0BX+8r9+1W3HmKhOHJ/6Pt4NypEt/+LJBCRuvO6RBpxaiLzXL2
         uRztHoTT+SKZeTITSb1uLfckvmHb5d5vVEQbkREXvEnqtjpvxvcX63alSa+Pf4FdJ1f9
         9GzeSoBDI8cOioWznC5uvqvIaxUtpdIC1HD1RnoeA5h8Ue6IO0sdtS+8bLQ846K30NSD
         W0pmo/jLjyKJulBSM2tc0vtN+NK4kXd42kdN3r4BxWXtipHeyF88+Qb6nqWA6uWVkwcw
         0iNg==
X-Gm-Message-State: AOAM5333CJnr4QU+ubaSfonNXBFnzJ1CV4ZGfxdeMG+vv5djLpyIeWYH
        mnh959BuSC38zmpUm+OQgSLTq+EmtCSgvg==
X-Google-Smtp-Source: ABdhPJzze7VpcNDis0eNj3vAz7+cWLQ8WWhCKohU/WwuUcCesAmlPWEncObLb/uiq8OKrDd/4WBWnQ==
X-Received: by 2002:a05:6e02:dcb:: with SMTP id l11mr3220742ilj.169.1630604168100;
        Thu, 02 Sep 2021 10:36:08 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o15sm1335345ilo.73.2021.09.02.10.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 10:36:07 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in io_issue_sqe
To:     syzbot <syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000c96e4e05cb0697ab@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c2b300d4-9d52-9bab-813c-f11deedc434d@kernel.dk>
Date:   Thu, 2 Sep 2021 11:36:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000c96e4e05cb0697ab@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 11:34 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c849ce86e0f Merge tag '5.15-rc-smb3-fixes-part1' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1292c59d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bf588afb178273fb
> dashboard link: https://syzkaller.appspot.com/bug?extid=de67aa0cf1053e405871
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1681ad75300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b72083300000

These are all the same thing being reported:

#syz test git://git.kernel.dk/linux-block for-5.15/io_uring

-- 
Jens Axboe

