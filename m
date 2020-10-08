Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E72876B1
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbgJHPG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHPG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:06:58 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0007CC0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:06:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b1so1719850iot.4
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZxKtwUQfrtFYgPTxfC0Fr3xXNcfRnpRDzLAYbyjbzuM=;
        b=Gzcc57vRbr6VO4vEeBUtqil9Id3YUAK5ngOU2/LVbUCIgmxdivLIOnF+tE/ko9lDyQ
         dQISWMxo+FS4G6+N6GAhoZzeAm6F6gMVpE2fDBuDcbdhwUjzY7e5wibddcOjzIB17W50
         lyZv9z8nRRfNnz6FRvrdISVO65gmX8l7fk0gq2TK2qr6AMaioseYYjGGbG4qy8T3YY1o
         LT8eF3CC6HHsEdRKxCpj4yyN7WttblXGSo807j+sKPBC16+2OL+DtA3sapp/1oG/5zkJ
         PX1L8O7y0KWY6Krm+WFhvA+boEykxr3dbga4GF44LpxrIAsAJHG2+fYI44Ol+9Yduqgl
         EUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxKtwUQfrtFYgPTxfC0Fr3xXNcfRnpRDzLAYbyjbzuM=;
        b=Upvtm10VjcV1CYR/dHo0tbyEcz+9+8BuyxpR6Io9SbWwTmdn3WFDVh/nSdnVKMO1io
         EuAZCI/h6vKojFZoyzc3xattwVo/W4lr8v+vLu5sHrLGodXND7NWw+ky4PMpKbne4HIk
         eOTl7cdsUVcOVAxlFeL63uGrcNjEwI0HcF4c37ldHjjeM1wEbarK4dLVRVGRftW6Papq
         rU2ECbzxxQSbBDjzwMBAm9l7TZQzNNgaLHo8l+wNDa8ul5jvf3WK5+pXyz+RFeRWiVtV
         OoKIbb0SBJxzwfnmftUhFNkCSY2HFbUEFMNUgBb26xtNqMI+C74Fd55J+Gt2XomyuVXy
         AQIw==
X-Gm-Message-State: AOAM533uht2Iat0ojBJf/dpHgEKaDNpO/5oM7ihOGraRSrgHVlN1TfbD
        dygi3ivRPD4mfxZi4tK0ZRPd4Q==
X-Google-Smtp-Source: ABdhPJzh6GEeDAHNvf2NyuZLqbKGR56JcQdByd83UwZQfjgGYtgahxjk2v32Dj59boxf4SP+dAu9fw==
X-Received: by 2002:a6b:6f09:: with SMTP id k9mr6262905ioc.21.1602169617117;
        Thu, 08 Oct 2020 08:06:57 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c8sm601392ils.50.2020.10.08.08.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 08:06:56 -0700 (PDT)
Subject: Re: inconsistent lock state in xa_destroy
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000045ac4605b12a1720@google.com>
 <de842e7f-fa50-193b-b1d7-c573e515ef8b@kernel.dk>
 <20201008150518.GG20115@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ecfb657e-91fe-5e53-20b7-63e9e6105986@kernel.dk>
Date:   Thu, 8 Oct 2020 09:06:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008150518.GG20115@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 9:05 AM, Matthew Wilcox wrote:
> On Thu, Oct 08, 2020 at 09:01:57AM -0600, Jens Axboe wrote:
>> On 10/8/20 9:00 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12555227900000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=cdcbdc0bd42e559b52b9
>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com
>>
>> Already pushed out a fix for this, it's really an xarray issue where it just
>> assumes that destroy can irq grab the lock.
> 
> ... nice of you to report the issue to the XArray maintainer.

This is from not even 12h ago, 10h of which I was offline. It wasn't on
the top of my list of priority items to tackle this morning, but it
is/was on the list.

-- 
Jens Axboe

