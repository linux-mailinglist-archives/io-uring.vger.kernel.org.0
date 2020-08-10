Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3BC240AFE
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgHJQK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgHJQK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 12:10:27 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D127C061756;
        Mon, 10 Aug 2020 09:10:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f26so8796076ljc.8;
        Mon, 10 Aug 2020 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n9aATTiWeg3eGm4JQNFh3hVmy+5EHRdeMVoNfdIDaVc=;
        b=XHGpd34R1ZumOZvay2qCWEMVUwtJjMxwLmDZJMi/D2cKOsK3PbjarhJwjrhxwKvyLY
         my65PXjsgbnWtjyzLBWN3JYcDB+4OZO2ekklaUTYv8Em9/EIalOhrxZKC5ZWxzC0Tj0a
         prXAsDqiomS4CNGZrNNkwnPA4EvzZylcF9z91xxBU5oqNT5qdE6Qmty3p6WvlrxJTJMU
         ci9Nvne8npUs6H1ctIaZuKVorU6ADhmoE3tXBzNFTED5Qg9b+sKyyUJYDOq6mF/AH4YB
         UhKlYVCZ5YqRFpXCFyf01rFaf4vE1ISV4GWBgVzGr8EJWezroaJjoorsS2pDqAM+bh7G
         WE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n9aATTiWeg3eGm4JQNFh3hVmy+5EHRdeMVoNfdIDaVc=;
        b=pWYnX0FV+x8PS4e8T09ouGd5Ef+KuwLvvqhTYkE/GTvbheHk82A2w68W0CHaVOvIB3
         eerrM8mg7EyCA4rVahoz9QpRW3rbJ/xrtxwmSl2Rdgj0oyPFVd75ua8HXyGErAdN3IRZ
         /E3syPzCD1khNeN+8hDKkE2CGmt0gK1ypntnasBrFIRIGKdXrbPIVb31Rzgpdwv1UDLQ
         ejfz38hr220mv7b34RPHmkZ0cGAlMcGH2Z4rzwXFuazMTGFdnLKO4BOi+Mx86BxDFIqm
         cwTBuBUoIX1VtlCimYmZs8ui2N3shCOypNrI8CeDkvTm7YrMJ0r08ttQD3xwjuFBjfxN
         VUdQ==
X-Gm-Message-State: AOAM532EVtFmfAMLVEOFyqFurHmVdwWTS7xE5vtYD2NvdetHtXzyM26M
        tnEXS+qhSxaUiaUtCspngZg=
X-Google-Smtp-Source: ABdhPJxB/evje8kcCGJlAvVWY5CucYiyFf9xHIaEK7LD0LFgKStP/rwtPQRXLNHjaSZoRVuK5W6g+Q==
X-Received: by 2002:a05:651c:543:: with SMTP id q3mr911983ljp.145.1597075825642;
        Mon, 10 Aug 2020 09:10:25 -0700 (PDT)
Received: from [192.168.88.55] ([195.91.224.52])
        by smtp.gmail.com with ESMTPSA id d13sm10834194lfl.89.2020.08.10.09.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 09:10:25 -0700 (PDT)
To:     syzbot <syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000099566305ac881a16@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: INFO: task hung in io_uring_flush
Message-ID: <bff14407-8ad7-fdda-e5cf-0dabc1acbb0d@gmail.com>
Date:   Mon, 10 Aug 2020 19:08:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000099566305ac881a16@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/08/2020 19:04, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit f86cd20c9454847a524ddbdcdec32c0380ed7c9b
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Jan 29 20:46:44 2020 +0000
> 
>     io_uring: fix linked command file table usage

There are several known problems with io_uring_cancel_files() including
races and hangs. I had some drafts and going to patch it in a week or so.

> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16db4d3a900000
> start commit:   9420f1ce Merge tag 'pinctrl-v5.9-1' of git://git.kernel.or..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15db4d3a900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11db4d3a900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=72cf85e4237850c8
> dashboard link: https://syzkaller.appspot.com/bug?extid=6338dcebf269a590b668
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141dde52900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b196aa900000
> 
> Reported-by: syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com
> Fixes: f86cd20c9454 ("io_uring: fix linked command file table usage")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

-- 
Pavel Begunkov
