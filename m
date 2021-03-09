Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5171F332AB7
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 16:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhCIPjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 10:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhCIPjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 10:39:20 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28015C06175F
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 07:39:20 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n132so14395905iod.0
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 07:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8ahT1PfmDE5o7sxez2PrjQRyN6HCfBh0U/WBlIaifEY=;
        b=is4XMq14wQnEZoZ1sQQuEPyxAjwLmCXXbiycEW4ZMEBxchWyFfmpiYjHzqP1apjxxH
         DlvwC/w6K01awlEJwfuHRu10l43oqKPwJ/UiDnGESLSaeVDBGKd0ow/1awFgJFKveIm9
         hdASjtyeNi/ar1TgOnURHyyg5nx+Ak1hAcq26EB4C2b4ipk6MZiAa2cp0A5Gri4mOaCk
         T+5oaQtVidPVeR/0nv6tZSObXzzvt24pQ8yam06+af8+UmCgKEgN5QWFew1JJ72w6+Lm
         ApU9loSa/bx3pfn4+ihS576Te9LiVrhEnIadxI6PmenyFm84sAMY/VIOuNKd0If4cEWl
         BWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ahT1PfmDE5o7sxez2PrjQRyN6HCfBh0U/WBlIaifEY=;
        b=r7v3sxJQTaNEiVQVhjSQugY9Bu7xSHJjP19H1NZidwFOpW21xu5qUOpKF1AZpesqhU
         Dcrxf2rYYiwmKA541SiUayvOnf5SQ08vU8Be/a6G2Espl99K2zG4b8m25cGYpXjZ+o8A
         TJKVlpxG5/4SOAb4qLIBKg+U9v0Etqe7F9uyrPpDV732HdrTT0o6wzOzMj/n1VK/p6N3
         SL95wSw6X3eQMY5xD3TXveiTWqoB9pj3ljilBno0XUMytvuVeD8LcIPegs29pkdMfvqz
         6jSBHr0DCyQnov7cutfZRP3fpbtkcd49XFx3gnbP2V8wXIi82m4ECQ5ohJZCrIlrwpV6
         UjkA==
X-Gm-Message-State: AOAM532zIRe27fVCzUKjnH2IPz4+/lZnu4jSylYFrnSApHGJ9OLbWuOg
        zqgZbAr1fuYLcIKyQ1EN8rNxKQ==
X-Google-Smtp-Source: ABdhPJwB5iVYyt6Y+B1/LN/TAhVkcMwklZnJx7bSWXAaLZ8WUvKFGeM4shcpQIbwjR9DwOsBPGsnHg==
X-Received: by 2002:a05:6638:210d:: with SMTP id n13mr29682849jaj.74.1615304359555;
        Tue, 09 Mar 2021 07:39:19 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r15sm7777746iot.5.2021.03.09.07.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 07:39:19 -0800 (PST)
Subject: Re: [syzbot] WARNING in io_wq_put
To:     syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000020922505bd1c4500@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f6aa960c-9c7e-b0f6-9931-1f563ead539f@kernel.dk>
Date:   Tue, 9 Mar 2021 08:39:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000020922505bd1c4500@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/21 8:33 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a38fd874 Linux 5.12-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1276fd0ad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9008fb06fa15d749
> dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
> compiler:       Debian clang version 11.0.1-2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Should be fixed in io_uring-5.12 as well.

-- 
Jens Axboe

