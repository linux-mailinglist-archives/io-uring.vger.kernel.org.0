Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C820C3EE021
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 00:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhHPWvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 18:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbhHPWvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 18:51:47 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F62C0613CF;
        Mon, 16 Aug 2021 15:51:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x12so25740899wrr.11;
        Mon, 16 Aug 2021 15:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ofQY1mQBvnfrDRq8IwE+M9gjT2BSYoc2hzlBRViABDo=;
        b=Veqp45NSRcVHNb65GcV2PYdNMQZiR8Ar7QMmsVHJv9+u8KiVVKpCaYMv+iQUa2cUPG
         oIiwL12wBMdy6NVXwCjV2GmPdv6FqN+yaOYjqtgC7031a4EQ2Kw0ilsKghz9UfZJV0We
         v15fWl5RUL4FV+7BM+OL9SIMg+aP5Jj+ouK2e4sLB6y0QWpqBnmAqxj2+K2+Xm90qXhg
         bBimHWPixPJ7c6xhAtJ3v5s6Y+p3Dg6SsF/LlRjKDm6dNxH8mtYRxBJYQgx3EZ6nDA0W
         9cIqrYZ2z9301dXXzlrhvq6A1ALPQL+kbGCw4Lw5CX7pZIh1T1ZlaYS4O9+b5w4Slrxn
         Gycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ofQY1mQBvnfrDRq8IwE+M9gjT2BSYoc2hzlBRViABDo=;
        b=rhtnNE5K7cvJjl56OZgrkxOpsfLVdxzlu2O9WP23oyZl1ZDy+jcpNDvpc0aoV795oJ
         c34IbgpduET7rLolRrpQA7WxlAeIvoljpC42WlvxWooc728hvejMPXc2xx1u91OCo5hw
         xJo/H+MhqLdR4xdvRPpU0HLuGu4XJiVpw+qU1i8656KzVodY+mzz5lVZ0i+ALwL0mHK6
         aAsv1eYO9sUztnvpWHa38Rq8yoBwBxaKHtwqD9f4Fd+WuF5xQJU9AtC4OZ9tWMzI0OXq
         BjcaCh5Rb7bfTellh40JtnoDsRPlcxcYU/hkYhFwh9m1BhF/x5orqh2MRVIz1Sxi9wYU
         DA6A==
X-Gm-Message-State: AOAM532uB0BUsZx8mzqJt0NrmxqIo8R4ySmmbJJEq3Y1Ofb6GZUrCDO5
        FLycKjFrK+ewve0Cz0ZLGDo=
X-Google-Smtp-Source: ABdhPJwwG3OlL7pFAxzo5XfgoGWXmTE32jwfJbyXDo3beODWdQCSbOSQwCcaAC+6Cn/CmPJQxJ/d0g==
X-Received: by 2002:a05:6000:1b8e:: with SMTP id r14mr373440wru.251.1629154273878;
        Mon, 16 Aug 2021 15:51:13 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id h2sm150174wmm.33.2021.08.16.15.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 15:51:13 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000011fc2505c9b41023@google.com>
 <8236fd18-bf97-b7c6-b2c7-84df0a9bd8e5@kernel.dk>
 <d13c4e6b-b935-c517-f90d-d8201861800f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ec15a6e6-4bd6-25a5-3b91-c60715d51a0c@gmail.com>
Date:   Mon, 16 Aug 2021 23:50:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d13c4e6b-b935-c517-f90d-d8201861800f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 10:57 PM, Jens Axboe wrote:
> On 8/16/21 3:49 PM, Jens Axboe wrote:
>> On 8/16/21 3:41 PM, syzbot wrote:
>>> syzbot has found a reproducer for the following issue on:
>>>
>>> HEAD commit:    b9011c7e671d Add linux-next specific files for 20210816
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1784d5e9300000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17479216300000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147f0111300000
>>
>> #syz test: git://git.kernel.dk/linux-block for-next
> 
> Forgot to push out the update...
> 
> #syz test: git://git.kernel.dk/linux-block 16a390b4109c6eaa65f84e31c2c1d19bcbeb666f

fwiw, tested locally, solves the problem

-- 
Pavel Begunkov
