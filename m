Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888A742A28A
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 12:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhJLKpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 06:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbhJLKpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 06:45:18 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19E3C06161C;
        Tue, 12 Oct 2021 03:43:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d3so51778582edp.3;
        Tue, 12 Oct 2021 03:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=9tW9+9W3ki2H59Q6eX3JXlQTuv6vyJPIiRkarHpBHmI=;
        b=f09MjGXeVx3UdxZU1QExsJVyx6awn0E26xv4JjT2PxSfjRKn/LruRMI/J+Zwb8IHuK
         5l6QBO5p6YTkpWIRImpkWYVB11luH/Ef3/eux/vUlrcYFVAlpkVvg+4eh2b72VL/duhm
         nDnpT1lCTz1i14UA9JPF82xtRzl30dMwwrAPrIrk/BRT7myjWdd92YF7zNn11d256XbI
         vZ0vw+RVCbaE5eIKThO8tLXaQ7lnKIYXHGZTRX82Qc+4QmgqSqryhcZhyKZwvf8KJb30
         QgbQZrtxAlZ5Or7N3hk2i6TsiFiZTr26xiuzPqK9xZOtL3epl9oTdDjWHTwH5dTXhT/Y
         rgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9tW9+9W3ki2H59Q6eX3JXlQTuv6vyJPIiRkarHpBHmI=;
        b=4gdrB3jZ+zJ7IKIC6f393uEY7JfmVTIP+IOfOt3HyvjmUxZmcf5fCkyzuK+LP4YsJX
         3E4hWW1qAlVC+Wk0DRX6khfcv7Ah8+PjLAFx0a9HnmJZHqCpCrb6kCN41TXv9eaXqSZa
         Err9lZbqgXy7Hpq05Eg7DDLTdlXxKc/0FD0JuAUHTK7tU503USnJs/qFFtZXyl0qWMUa
         LCDsf2waRyCD7VgrjTa1PC9vMpx3aeZ7htFlXZZJ3CbUktTtNRmIaRyvJfzPflRIuVn5
         UPB746noDjUZa0Kc+IMe0bK+jfdCE431xqIz0cptm/6B5NHo1qsqCUKmzriBGwDdwJXW
         uJUQ==
X-Gm-Message-State: AOAM533gjSGiToI5Hm+X78SQzU59b9py5bXRH7oh1UJNnS/yKzKpKyJs
        tjQ0kLF9nJH6/Skg8wZhGSw=
X-Google-Smtp-Source: ABdhPJyF0hmHa8SE+WtkOJoKaC/5JnmaKOatJC+y7uCeYzMv2TRRSxamhElOAfjadUORbP77BJOXWA==
X-Received: by 2002:a17:906:a0c9:: with SMTP id bh9mr32236875ejb.51.1634035394802;
        Tue, 12 Oct 2021 03:43:14 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.215])
        by smtp.gmail.com with ESMTPSA id f9sm990730edy.9.2021.10.12.03.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 03:43:14 -0700 (PDT)
Message-ID: <659c1c9e-3df1-14f4-0630-88fd118f9e23@gmail.com>
Date:   Tue, 12 Oct 2021 11:42:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [syzbot] WARNING in io_wq_submit_work (2)
Content-Language: en-US
To:     syzbot <syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com>,
        axboe@kernel.dk, fgheet255t@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000061c94a05ce199f2a@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000061c94a05ce199f2a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/21 21:32, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit c57a91fb1ccfa203ba3e31e5a389cb04de5b0561
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Sep 8 19:49:17 2021 +0000
> 
>      io_uring: fix missing mb() before waitqueue_active
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=143b46bf300000
> start commit:   926de8c4326c Merge tag 'acpi-5.15-rc1-3' of git://git.kern..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=37df9ef5660a8387
> dashboard link: https://syzkaller.appspot.com/bug?extid=bc2d90f602545761f287
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e4357d300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1173a663300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: io_uring: fix missing mb() before waitqueue_active

#syz fix: io-wq: fix cancellation on create-worker failure


-- 
Pavel Begunkov
