Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6C3269CC
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 23:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZWHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 17:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhBZWHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 17:07:09 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279B0C06174A
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 14:06:29 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id g9so9362735ilc.3
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 14:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VANCDcWoh1f32URoRwsZjblU0mIeGcRR751Yd9L+eAs=;
        b=dQj/x877P0oLdf6q6o1dwI2+hNol8yWG+5uHa4l5EVZ6WrFVdLa3NaSlF+sEbGG8eN
         wWbe7XW/RiZMUeNtf/oj1yUbZER5crvmBJQiq4JTYPzWb0+FIdH8lLebN/SESU8dk9/x
         L21fnF/F1N3y4dtRtG3t2Wz2AgG0b3Xi602Hy/ZhzP+5XN9VEi3/JMmHhb0blWsd2cLn
         hZuwcjxlOhD9dQsf9ucLXgs4xZOgx7vIy7OMau3/jZ7kXRn41KU4mfFaLKZdJDb7Euq4
         CXmb5JeRBinEzLOpdcXOjRclGJVCAuawbmceWSGUBlZc8EscmXUdoaup+M+9BUeKSVT4
         bTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VANCDcWoh1f32URoRwsZjblU0mIeGcRR751Yd9L+eAs=;
        b=UJwjixt78TQZT6jbJzvSbkwBB3+dNFk6zEju0OJ09pBELa/DIh/m3COyImn/Oy2Jbn
         BVVo6SdYOT4GPIwTyw9sm3jMLWrAx2IZuE2Dw5isnrLltNn3eFkhNAzZlzNbqvDD/sef
         ZxN2sTv7tZ3M+ESeSjSGKs4rf5MK/O4GCNI8yzmt9FL+we6vDRMQt6CNOm5xHtcbO4ZU
         Zz0ASVbVuU24fx6TxAh0SqFk1xUKN6h0VL53jl7HZOrOGco0MZIO2pRdHI9K6SbwIWki
         TH5U/OyPfykNM0+CC4IZJuFJS1ADS8BjJoD14yPSkZMCDDo3DIurY72oQPG5oxWCnjpH
         MqJQ==
X-Gm-Message-State: AOAM531xk14g10jCrPTLYKDuHQaUiXFUFSloG4t/l3oFJJbkCGGsCxSv
        OkfIdV7CgpXDlqqySCHUJ9f6Ww==
X-Google-Smtp-Source: ABdhPJzPVWG0HeuUpPqT6vVcIZ6xemEmt2aexRvX3sdsSySMca54739XfKRTI5lc4ntTlJXPaffcBQ==
X-Received: by 2002:a92:1e12:: with SMTP id e18mr4238333ile.270.1614377188641;
        Fri, 26 Feb 2021 14:06:28 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x3sm6044374iof.21.2021.02.26.14.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 14:06:22 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in __cpuhp_state_remove_instance
To:     syzbot <syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, dvyukov@google.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, paulmck@kernel.org, peterz@infradead.org,
        qais.yousef@arm.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <000000000000f3daed05bc440347@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <806645c8-5a35-2341-a08f-ccb93a9a1fb0@kernel.dk>
Date:   Fri, 26 Feb 2021 15:06:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000f3daed05bc440347@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/21 2:33 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=114fa9ccd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
> dashboard link: https://syzkaller.appspot.com/bug?extid=38769495e847cea2dcca
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1181e0dad00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com

This one is already fixed in the current tree.

-- 
Jens Axboe

