Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABDE328271
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 16:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhCAP2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhCAP2c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 10:28:32 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF621C06178A
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 07:27:51 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e7so14979534ile.7
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 07:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DdFL9dv5FlNh4UKRITwsOIwvbfnu7gb18YnUFz26l/0=;
        b=xjgRupqf3/3TcUXdxJK+/IZX8Wuqg+HsDA1mct9PgU0wXTiAtKZYlejuLH5H9BNVtl
         Jg/x7xmgUtWLxdgS/EAgvVE0dji4dBYgVb7JrNlLPFhNHOtAjBA20o5/S/hNknlIE/F9
         6ZVG56M3BsWr7+kr6snk1lXK1Hl09/f8ysWdhqSLY7om6jeONe6D7mjtQWPIlLEXKsQ9
         ol9xLM0X7ExjWyHZRnF7Ps6tCVfRWsHnofO9iiV26ualJnx96Rm0TNThhW/MyQjGXaxu
         hE3Rnzerrws9K01OhkeT94ZHUYs/5oIofc65nF/2eMqPbWayHeMji6XE3e3FAOBHKENG
         Zsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DdFL9dv5FlNh4UKRITwsOIwvbfnu7gb18YnUFz26l/0=;
        b=p2kIsk/WDB4xQv6IudFc6NSGaAGZrj4kzY5Zaqba0cBdOcNVC4iwGtwwwnULIHqKnI
         +U506KtT115qOjKiQkZifHY2q44WTYIJu5XzbdwSEJVaCGeuaGLt8TVS1mKZhKidWCxl
         oVsrkTSqDrRnhwl1MaIRlzRJEdix2s+n3hf3j/f8RSacTQndVdEOCP/UzaY2c0VtM9/L
         Ho1NDsqrmoNQLSK8K5GnANt5fRenm1JppjCdZWEeofW8Cd1UvgSa+PkKpRuXlsjd+xFM
         17Ss2zFYPKhAJls0bAd4hPSz2FuxLhwLwwln/hi3jlxkQ7KRv8XxzrxeKlJNgYoEqCpS
         O/4w==
X-Gm-Message-State: AOAM532eckkooPLmdBuH+zRTea+VwtYRdG4Gc9Q/1fUUxnbOl8rGzzj6
        ct2J1e0fvtXoXgHMDY9n6pva3g==
X-Google-Smtp-Source: ABdhPJz3/0R3Miyqd0Y0ZP5esnHp98pmqfCMATrESRtlyeMyBy5DVnsnrC3JIqZMOKdg7IeW1dZRfQ==
X-Received: by 2002:a05:6e02:1a82:: with SMTP id k2mr13897266ilv.155.1614612471432;
        Mon, 01 Mar 2021 07:27:51 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c16sm9313175ils.2.2021.03.01.07.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 07:27:50 -0800 (PST)
Subject: Re: possible deadlock in io_poll_double_wake (2)
To:     syzbot <syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000a52fb105bc71e7b8@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4c4caf8a-47e6-f112-f307-94fe0a622ff5@kernel.dk>
Date:   Mon, 1 Mar 2021 08:27:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000a52fb105bc71e7b8@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block syzbot-test

-- 
Jens Axboe

