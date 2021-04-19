Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D01364143
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 14:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhDSMJj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 08:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhDSMJi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 08:09:38 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB132C06174A;
        Mon, 19 Apr 2021 05:09:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u20so13506984wmj.0;
        Mon, 19 Apr 2021 05:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wn8Ty+mw20wGFWpDWqVoK+9j1cUNrHpSGL2+OCH4Fb4=;
        b=sPv+1YeGV40XSNce99bdQK1JiXy4QacHcU9WC9AhYM1fd+nQsTM50hUITrkmLtnZ1G
         lFnlzXsYndITe4VTurGzmp3KWenbTLT/TL011vlX3bzC43ZL8xiw2AHP4D5HkMqV/jh+
         IkC/VxDPKE/nhWOFxopcAXmHPBbjZ7e8WO4+IYgeBApe0dLfTwRAz753hD6pg80z7CiN
         1C5Ic5AKbEh+Qpf0kJA3JTwVojs5wbkEXP5R5TQ29eHeG2kA5nAVCX21hQuXp9FhFkfc
         nSYU3lf66oWSklEEuxDezCJAeO3LQf4P/A2hVb+i0IkadbhTHLqOYWbdaqyLnf714M56
         4okA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wn8Ty+mw20wGFWpDWqVoK+9j1cUNrHpSGL2+OCH4Fb4=;
        b=ADSahlJu2NEQ95HGGNbuh2WLrH0EPF5FsMVTxmsBwmu1NRi/iYbhLD4C/ySZbUgNB0
         Bk0FCg43gue4aaWP/Oz4vJ3c62jWN1LkpYp/u48DO3opsAD0Fu4JGkixfVdSvweoNSU3
         gZM7JDo2n/jNC4Y/Ta13uZbYqZgrveHv7nRdCgY5MKFGtfkevGC/1Rcx8Xxj91uCd23J
         Ej0nIsvrj+3nQiCTx9Kj9m0IazjpNjvbQesabUM/BwOl5S2zNqq6cO42IZm6dLK1XgHM
         CNxavnWDM2HBK7gf38JngeRHQw+R+Cj6rlGqOtIRnTzqFsXxwcNYAVA6jVIqdnmwQct0
         nNYA==
X-Gm-Message-State: AOAM532B7gLJy31zOZ4iKU9U0bqUMdBQhhAgeWPc8cuqXhrwKVYp5/ju
        Lq7FTycboYR9sA31ZDr6wCk=
X-Google-Smtp-Source: ABdhPJwahqJBQVg23/gRZDAh1TfXm2rrCHSf905r4Y3xBukgqePcsSaA90P8vce66fB8zvdZpF1BCg==
X-Received: by 2002:a05:600c:6d4:: with SMTP id b20mr21135895wmn.99.1618834145615;
        Mon, 19 Apr 2021 05:09:05 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.103])
        by smtp.gmail.com with ESMTPSA id s10sm22364037wrt.23.2021.04.19.05.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 05:09:05 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Read in idr_for_each (2)
To:     syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>,
        axboe@kernel.dk, egiptomarmol@loucastone.com, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@anirudhrb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        willy@infradead.org
References: <000000000000d45f8005c00706a1@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a9eeb6ef-79dd-0185-4ec0-87b6101be9e4@gmail.com>
Date:   Mon, 19 Apr 2021 13:09:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000d45f8005c00706a1@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/21 7:28 PM, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 61cf93700fe6359552848ed5e3becba6cd760efa
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Mon Mar 8 14:16:16 2021 +0000
> 
>     io_uring: Convert personality_idr to XArray
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16f91b9ad00000
> start commit:   dd86e7fa Merge tag 'pci-v5.11-fixes-2' of git://git.kernel..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
> dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174b80ef500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165522d4d00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: io_uring: Convert personality_idr to XArray
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: io_uring: Convert personality_idr to XArray

-- 
Pavel Begunkov
