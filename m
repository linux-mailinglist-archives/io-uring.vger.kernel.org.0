Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B034D08D
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC2MzQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhC2Myw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 08:54:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0FAC061756
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 05:54:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f10so9337376pgl.9
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 05:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=US+rAtdbkqLkNl3oRSj3/J0RXu7PFDi44LyNiScUT2c=;
        b=Md5xAZ9bNGtWowXcdfE+VZgCgdw2isAbm75OG5MDCkIP9sCzF/xgvYwDF6OJJFfRYq
         woInjtbc9ubtyksesDpzR0lgUt+dZeycUjGZHwRYiWGjAz6CfM7HahGgIH1el6nzJP7x
         WfOJmPrDeXhOr0fInxBYUHdPg3vaxEarEmncCpCjPkhWUGWj4GBUL6veZVChZ0aQb4Jr
         VAEkoL4U+wk8fll7Ja/LMl4eNYDO8wnOTlJ6LhxFRw7ld7VVHKgGUw2y5fyfBUbeivnV
         6ENBGVcbv3OuHZyaGGKkCwS1WE4z/JnuuvVSMvOmmU+R+Jt5Rf6GZ+tZyn47hsRvjc8u
         zq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=US+rAtdbkqLkNl3oRSj3/J0RXu7PFDi44LyNiScUT2c=;
        b=gB67L0QSnxUDAlWzYHu0zmQsRpTjdjbQVuQX6w9LdMW4MS4k/6YRMyGxWNALsaMkYG
         BOhvvxAp8A1W8rsOT2TgirUzVXhgbSkMVhOfk7ej01s9TvAIy3lrFtBoZedEzRSrIu12
         hFrarqgHeE79fVqTHYccKKuZSwwxsjjTm6S7V0LZ+CPSgq2BCrsF3XrV72t/IK7hhvq+
         coLoM55UKBbjLISYrOvZy9J4N3e8q4WGz/PkCrz7mGjy9XBzPxiheIipvFlvyDOf/Mxl
         jl1JNak1zosvYxfVpiA6jViACzk9CFCou/tQWb43cimBAvXBA9k2LaDvuQHI7w2mRo7O
         UTgg==
X-Gm-Message-State: AOAM530/HPsed+sD2Xq+DtwnPOpQIt0L5RZxYD6HnkAYDcX3HVCt2WJx
        XUK01a7I9WlwChSTQGcfYe8cNg==
X-Google-Smtp-Source: ABdhPJwB4Wa1NWUtHJyMTM6wO9ZES46yFhG7C57uH0kHw+TJ3ehN31SiTDJoqkK/HdxbPtwuH7GbRg==
X-Received: by 2002:a63:f00d:: with SMTP id k13mr24223787pgh.295.1617022491576;
        Mon, 29 Mar 2021 05:54:51 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l3sm14901449pju.44.2021.03.29.05.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 05:54:50 -0700 (PDT)
Subject: Re: [syzbot] WARNING: still has locks held in io_sq_thread
To:     syzbot <syzbot+796d767eb376810256f5@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cbcdca05bea7e829@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61897224-d54b-9390-6721-57bed6a144e5@kernel.dk>
Date:   Mon, 29 Mar 2021 06:54:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000cbcdca05bea7e829@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/29/21 1:34 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10fcce62d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4e9addca54f3b44
> dashboard link: https://syzkaller.appspot.com/bug?extid=796d767eb376810256f5
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d06ddcd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150764bed00000

#syz test: git://git.kernel.dk/linux-block io_uring-5.12

-- 
Jens Axboe

