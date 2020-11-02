Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266882A2DFA
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 16:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgKBPTc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 10:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgKBPTc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 10:19:32 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0187C061A04
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 07:19:31 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r12so6266344iot.4
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=49FGBKLX9bjRkUIwwFYH04GGaHdzd9ual/GUV3gPQsU=;
        b=Z9YjdCoMGxgXi8OKp7mMzKofIUTxG3aaghQ4KuqjZoIQ60iQ+0AYAk4pbEYrkhQcas
         bXSwZ/8q078axG1lyreFsisJspjsS8TaRGqNXNQzwEyl2zQ0hcXbeC4QQnY2CU4Jn4SF
         MGC76YUNUkvOpZG75zKiBAZK+WsXAlkA8TBxVoDjDHVqpX2iqoZX7JcTODvb0zWJcOfP
         0LIWCB0MuKEE/QXc9CEMOFBc/cHAywmV5m5N3iYb0UR2TyM5uCt12h13ufNOHTaJ3IAw
         iGYTFgGQBsQDt08aCfCpvOjMZ2QdexJOMXveQliBvzaI7dQKYNGn7CM663YM2Py0oVRc
         IZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=49FGBKLX9bjRkUIwwFYH04GGaHdzd9ual/GUV3gPQsU=;
        b=rlKhVR8mMBTrht1P238NwpbOpWfSXfLDlBYbF2+zpglp8TKnunL5zDh/kLI8IWbX+m
         r+vDVrAReqJB1533snclMuJCDzHPj5kP2nuRsb1CkahexxR5Fr6DRL83oyzalwuCiKbj
         So7QQDUkn6nDGnfGQtE2TxF3u6WFo8vqxz1lWPDrZEqA+OYTWK5cvCT6rQvZjY13tlrj
         tMluMcU7YiXyzbrpKp3G7m7IAbd4AftKbtej4o+VHuy5FEzHIzVG5Z9tJsiD47HNru82
         BX11A8JdMwyG40RMabgyWAlg72lKtBp09q1+5vrnH/XVChNFjsgpZOjNL/Bm4Zdnb/WI
         4/pw==
X-Gm-Message-State: AOAM530LL4W9RHGEEdSq1xL9C5/vTQILWhHo6S4TctixKSxIX2zdHOQn
        HooYX2I05l6CObL9qtaxodMtZA==
X-Google-Smtp-Source: ABdhPJxpku+l31t6D5PSG3BnC/0CVXqaptAeWUb/56zYbW0Bbd3pGxC590t1qtuOaZ58Q1B35gotfw==
X-Received: by 2002:a6b:6806:: with SMTP id d6mr10963958ioc.54.1604330371135;
        Mon, 02 Nov 2020 07:19:31 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t16sm10775048ilh.76.2020.11.02.07.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:19:30 -0800 (PST)
Subject: Re: KASAN: null-ptr-deref Write in kthread_use_mm
To:     syzbot <syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        will@kernel.org
References: <00000000000008604f05b31e6867@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <298f1180-ab14-d08e-dcd2-3e4bbbc1e90a@kernel.dk>
Date:   Mon, 2 Nov 2020 08:19:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000008604f05b31e6867@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 4:54 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4e78c578 Add linux-next specific files for 20201030
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=148969d4500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=83318758268dc331
> dashboard link: https://syzkaller.appspot.com/bug?extid=b57abf7ee60829090495
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e1346c500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388fbca500000
> 
> The issue was bisected to:
> 
> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 2 09:04:21 2020 +0000
> 
>     lockdep: Fix lockdep recursion

That bisection definitely isn't correct. But I'll take a look at the issue.

-- 
Jens Axboe

