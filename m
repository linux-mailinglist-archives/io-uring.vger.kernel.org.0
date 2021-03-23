Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8763460D4
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhCWOBb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhCWOBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:01:24 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD4C061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:01:23 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id 19so18212828ilj.2
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4jXS728C1rKE4dEUAzBNtLxbTiVcRrY24zDvINGA1RE=;
        b=mH0WAT4lop+jpXzMvjL8tsLENP2+qfkPCLccibqBPdl6f6ScaeC2x9UriK3gkHsoKg
         6kAskBo2kkIPPgTGDU4lptjNDfsSTHGaVOleBTxNtR+qp6/dHSwXeZUfh0hxkpEqsPGt
         J1URoqp3Rzriwri45TBBIZjz2zq8MDLxY2TbCVBrLbcFbciKSeWJzIe7DgRrzuUhpj4e
         4qzuAK57r2wLgSoDDpRHpYRsKiJoYP5Zwko/05nIa7lniUu0EniFjbUlAEeh+71AF2nL
         pKIfpmMnCtbfkFfyHcxS418YymoRh1ZWlW3DL/oQFW1r1uJ+DWrjYK9zHf7RA/ELlSy/
         ZVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4jXS728C1rKE4dEUAzBNtLxbTiVcRrY24zDvINGA1RE=;
        b=R4HvkupzHlI79pAm5xOPgPTvp4n71C+1QKjWMr5grjNKFLUXUYRqxoLrTcCpM7tA24
         Ok3D/S7RTzkuGBY86oq6vltcEiX5BC2Bn1eUXnOh8F9Iinr1UIRrWEGZRCJkmW52vKz9
         +uyvsK00S5tab4ooeYkIRrwrz4TB/hj2rQE7DJsGgXNhLJFiMpNA8t819pfGKGT38Lqb
         tp9jSwxWBVYWk3RVoKIvKzONVCn7JaY4hZd8ad4/nuedS2F1kHg2mkPVJanCmyCnuK+4
         wS1TZ/MsF1qmIvBjFN24mAo0ERe6HVlXWzeWwfyOlh9QYnJC9QOWesyrEmPfr29qAMOG
         +kkw==
X-Gm-Message-State: AOAM533lSW3rwn21uOG//izf40c994Qbo1t8hDMjzH73+eqZx+7GNC1z
        rExJEEkEWeXbMAcihK8cO30EZQ==
X-Google-Smtp-Source: ABdhPJz/NtZ/A9Zi9tDINHTVyG7FoW1P0Ex1ew0Z7v1KfgoJ8RGjXrqhx421Qej4iVCSWjrd10yR8Q==
X-Received: by 2002:a92:cac2:: with SMTP id m2mr4785878ilq.33.1616508082841;
        Tue, 23 Mar 2021 07:01:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm9363031iof.54.2021.03.23.07.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:01:22 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_put
To:     syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000007a49c105be013f72@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <08603c70-64df-5dcc-f5c7-1646056af74b@kernel.dk>
Date:   Tue, 23 Mar 2021 08:01:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007a49c105be013f72@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/21 6:44 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13853506d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c51293a9ca630f6d
> dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
> compiler:       Debian clang version 11.0.1-2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ec259ed00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13acfa62d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block wq-no-manager

-- 
Jens Axboe

