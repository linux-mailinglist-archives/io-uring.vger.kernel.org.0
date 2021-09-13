Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95329409CB0
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 21:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhIMTMZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 15:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbhIMTMY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 15:12:24 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB890C061574
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 12:11:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z1so13548656ioh.7
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 12:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5bQL7fnkPD6fAv1sUB1Zwl0EAvo0uwPEO1nytkIz0sY=;
        b=pH4G1sFodjRm/zAnXGeia7JvtvmPDjoxPT+Jp8P0JUDZMupj6gR6QKNjDvigSI/giV
         QByHDqNWAGmc4s57TikfJFY2ScjKdawEL2/sMhErw7EiTxtZPidAf9wkexUQMCNyXFyW
         u136JAz9tRNqOx+3/3K49QnGMBDgGKkkwFxRLmwI4MwF05fC21E9nV3OJAGMgYRhuXXV
         CigWlJpaQXxJaR1HWuUof4llDxnK7tSZ3R5EthELR+6ZPhOSG3y8ksqeWX5VyvIB3QVc
         a3DJZzwyLjodQwuHq5WUPy0yFvaR0jHOXxXYZjz2K6elk8NrfCMCG4FRs0dlfZRRp1A5
         ZxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5bQL7fnkPD6fAv1sUB1Zwl0EAvo0uwPEO1nytkIz0sY=;
        b=JQYmzjKpZIaBL5cMgNk5JMV3hum4wnVyg/YQBcPFlHCXsrtBjogn8SB8veVSNK9jNj
         aZUJTvqUUqEiA5wejIyqaLAHztm18Vi85kHxGOCPZ2f3d6wnPBEPvm82Xhu8AtRM0cqb
         qZ2lKhnBHn6q0QNc01ceAnjW/mOh2gvyLgbOWxpv9stmiT+WWQrzS6gfmh/lBfShDVog
         G+rlOHPkfUGf8H117l3sznbU6mDTUuHmgg4tMzpMQtuNBGisbHgISid4mJmRJ+muW9GI
         L7tHHea/OtTYLhXyVnSaJ1Nhg76gEMiAdCWAynKpl8aLXCzCkZcF0wRICpWD52nl0IGD
         u12Q==
X-Gm-Message-State: AOAM531NTZgdXtQm0uaqowpjn2I2zoepdeXUfoqCPlmigxDg4jPaN8mn
        WpHdMdquWkA5JBftlePCX2RduQ==
X-Google-Smtp-Source: ABdhPJyFupFHIFXwYH9E1NYUZ85LhbkxGFSW7/JY6X+6KXNOe+DyqsQPOHfi1Wei8xAbR1R7Wud/aQ==
X-Received: by 2002:a05:6638:dc8:: with SMTP id m8mr1706561jaj.21.1631560268051;
        Mon, 13 Sep 2021 12:11:08 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o18sm5215735ilh.52.2021.09.13.12.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 12:11:07 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in io_uring_register
To:     syzbot <syzbot+337de45f13a4fd54d708@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        johalun0@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000008f30cb05cbe4af29@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8428f733-ae95-f57b-8d42-6c7a279f4d84@kernel.dk>
Date:   Mon, 13 Sep 2021 13:11:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000008f30cb05cbe4af29@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/21 12:32 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a3fa7a101dcf Merge branches 'akpm' and 'akpm-hotfixes' (pa..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17da7b93300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ddf81d5d49fe3452
> dashboard link: https://syzkaller.appspot.com/bug?extid=337de45f13a4fd54d708
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129e9da5300000

#syz test git://git.kernel.dk/linux-block io_uring-5.15

-- 
Jens Axboe

