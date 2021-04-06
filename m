Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9483835581F
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhDFPh3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhDFPh2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 11:37:28 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7F2C06175F
        for <io-uring@vger.kernel.org>; Tue,  6 Apr 2021 08:37:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l76so10618200pga.6
        for <io-uring@vger.kernel.org>; Tue, 06 Apr 2021 08:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zPyKzJiBUBXEF6n1UtK4a6/wqFFul/4nSSHBtrhDa7A=;
        b=i+7kXT0ntuQcB9GC9Kxky/Vil0JP7usU8Zea6ll/BkXHIumSVIlTL4j9xR8n/APwAz
         uvkkBfsunFDkT0pQxu/wbf/9R31+oGDqu4iXLy06IFOb7NvY5Sxn+TnWSUy2saepzcvW
         3wykYfC43NdT/BoL68B8UHogi/coPHK0pGO7ZXGKSf+xXM6nKnKTXVb+JNj1nXwzvY+A
         sKmwtM3FoRSKontbZ4yZ3tP4x5k7GdfjYSUQHpi9mIAZ5A7OqOKUC7d8pkIEPZSiuCsG
         5vIziSOz0rvGwiW8Ae/hvzPOWl1juxI5viBbr046I15bQrThJZO1j1G/VVzgQ0Q2DuoK
         UpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPyKzJiBUBXEF6n1UtK4a6/wqFFul/4nSSHBtrhDa7A=;
        b=hcdJbikiytcHshvvy4jVXscc5f3O0N2fSaj2WHL6eapDJDoR5g+KRLqKdBAh1emqeD
         fnBf67xgr53Jcr+5Z2hwfERYXoz5MyKT67vbHLy+bmVxG+3nXjk9ArTSPdemioK6y2is
         G+YmLGQEFtCZeR8yPJ7EyQ7gZIx8tR9AIXkPcpxlOBarYO4mo7ednvX2yWrwYQHAQUk3
         g3r1bP5Zl/dNLqYVimxpPzdFmK+OTQXyhpEscZHkqjlVblq7q3/ETYZ/sKqNq/wwk1Bu
         mLgkEl53EqK5GAdAvh40TKAQNmfP6fIA/4nO+I0/nLkg8k614K0nbD5VNtn/fEgyYr09
         /DQw==
X-Gm-Message-State: AOAM531XdoZflt9V4AGX26LT3y0idOpMxoia9R3LPVG0ozH7YKpwIJDD
        UksoEAsCWpKhRXZCtPRPk7ndYLfMa9rgkA==
X-Google-Smtp-Source: ABdhPJx6d1KX7EkIb6wInkFM/zhjxErRj2Op9pFFhoKno7iIa7788LfIl55TgJr+TpiLHT1lwlV5Dw==
X-Received: by 2002:a63:f247:: with SMTP id d7mr26751734pgk.112.1617723438249;
        Tue, 06 Apr 2021 08:37:18 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 15sm18877321pfx.167.2021.04.06.08.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 08:37:17 -0700 (PDT)
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
References: <YGs4clcRhyoXX8D0@zeniv-ca.linux.org.uk>
 <20210405170801.zrdhnon6g4ggb6c7@wittgenstein>
 <YGtVtfbYXck3qPRl@zeniv-ca.linux.org.uk>
 <YGtW5g6EFFArtevk@zeniv-ca.linux.org.uk>
 <20210405200737.qurhkqitoxweousx@wittgenstein>
 <YGu7n+dhMep1741/@zeniv-ca.linux.org.uk>
 <20210406123505.auxqtquoys6xg6yf@wittgenstein>
 <YGxeaTzdnxn/3dsY@zeniv-ca.linux.org.uk>
 <20210406132205.qnherkzif64xmgxg@wittgenstein>
 <YGxs5b0pY4esY7J7@zeniv-ca.linux.org.uk>
 <YGxu4OWMLE+XXy7Z@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e4425217-90b9-6566-fee8-fd21df343aa3@kernel.dk>
Date:   Tue, 6 Apr 2021 09:37:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YGxu4OWMLE+XXy7Z@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/6/21 8:23 AM, Al Viro wrote:
> On Tue, Apr 06, 2021 at 02:15:01PM +0000, Al Viro wrote:
> 
>> I'm referring to the fact that your diff is with an already modified path_lookupat()
>> _and_ those modifications have managed to introduce a bug your patch reverts.
>> No terminate_walk() paired with that path_init() failure, i.e. path_init() is
>> responsible for cleanups on its (many) failure exits...
> 
> I can't tell without seeing the variant your diff is against, but at a guess
> it had a non-trivial amount of trouble with missed rcu_read_unlock() in
> cases when path_init() fails after having done rcu_read_lock().  For trivial
> testcase, consider passing -1 for dfd, so that it would fail with -EBADF.
> Or passing 0 for dfd and "blah" for name (assuming your stdin is not a directory).
> Sure, you could handle those in path_init() (or delay grabbing rcu_read_lock()
> in there, spreading it in a bunch of branches), but duplicated cleanup logics
> for a bunch of failure exits is asking for trouble.

Thanks for taking care of this Al, fwiw I'm (mostly) out on vacation.

-- 
Jens Axboe

