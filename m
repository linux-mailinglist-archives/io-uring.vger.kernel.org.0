Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19227441080
	for <lists+io-uring@lfdr.de>; Sun, 31 Oct 2021 20:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhJaTnj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Oct 2021 15:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhJaTnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Oct 2021 15:43:39 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19638C061764
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 12:41:07 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id j28so10002564ila.1
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 12:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tUREh5LHd66l0OLGq8t2Df8ogS/efOJa+e+gKKpOSzs=;
        b=YVQ8ATqPbzx3r236TDe5h8S8/hbELrCy0eejyBnDtPxDG8pKzxSXlyfVsk7CNTk3mJ
         VzpqzghhPrqlUJK/ejvnrVg4vjmRJ5PWCNyzEfwYSsf/Lk2ALHnm0W3L4H4kWBX+2VpK
         3CIid+BM4MG7vmLpMWg98z856wq3Yxx4OVXB9hLqRaGxCdgzW2U/qjmEBP/d4CGZpAWt
         Kjght+EK+YImwpSgO85XX2pU4jwbrOg9kM2ytWfD7frmDoIXGebpJ2ukWzYSA2MoUSur
         LNkjiIJxQnFfbzuun5Q0oc1JMDVXXNczcAxkozgFwgt4vBEa5mJYv977JwCk++kMN5bX
         mHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUREh5LHd66l0OLGq8t2Df8ogS/efOJa+e+gKKpOSzs=;
        b=8JZ+1GZ2hzqU01Jj3JUYS+kGl64udbl91haCkbtXG9LZTR634lQQPfOkEgZyLWhHuF
         dny0g9zgLVC2VtcbXH6QBaq7nRbvliMUCyVeJvLpTmo/9fg6LRcqVB42CQypzrt+rDgc
         23pQLoJL9eSTgGI72CzMt4zRzXJ2mgb1ho1celd4YLFaEwBwdQTatvPffszX9PIRKqDd
         GnwzpeAhjCOTkMEm5qNQ8wXNa5Nj/Di/dCbBNSRkum+InkaOm+4+GieSxFOkfAJlwwQl
         QWYIPlXOS4pH87iEY6w7aiv00ZWFXRq7p4qFR/3hMQvsVGKFF4Tb/nN9pZnB2ASp7+AZ
         Sv4Q==
X-Gm-Message-State: AOAM530Na6dRyN+d/xLtbug0Ab0DIOFQA+ttKZSbDhc5oln8oj8AAvfv
        D+Jw/covdrjCYbnhJgu8jikF1A==
X-Google-Smtp-Source: ABdhPJy7kO9AYFBRAJ1fgLQ4Fc5NqLK2w2cnUbQ5IfYE3VUCGF/k9+9Fv/6TW82wDVqy4Erqr9Sx9Q==
X-Received: by 2002:a05:6e02:1c8a:: with SMTP id w10mr17322578ill.193.1635709266435;
        Sun, 31 Oct 2021 12:41:06 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a20sm6906987ila.22.2021.10.31.12.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 12:41:06 -0700 (PDT)
Subject: Re: [syzbot] WARNING: ODEBUG bug in __put_task_struct
To:     syzbot <syzbot+30a60157d4ef222fd5e2@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, andrii@kernel.org,
        asml.silence@gmail.com, ast@kernel.org, bpf@vger.kernel.org,
        christian@brauner.io, daniel@iogearbox.net, david@redhat.com,
        ebiederm@xmission.com, io-uring@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        npiggin@gmail.com, peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xiaoguang.wang@linux.alibaba.com,
        yhs@fb.com
References: <000000000000bb843a05cfa99111@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bd03422b-4a19-c518-f550-13cd7be243fc@kernel.dk>
Date:   Sun, 31 Oct 2021 13:41:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000bb843a05cfa99111@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/21 11:41 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1413226ab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cea91ee10b0cd274
> dashboard link: https://syzkaller.appspot.com/bug?extid=30a60157d4ef222fd5e2
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ba3e2b00000
> 
> The issue was bisected to:
> 
> commit 34ced75ca1f63fac6148497971212583aa0f7a87
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Mon Oct 25 05:38:48 2021 +0000
> 
>     io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

This was dropped from the tree last week:

#syz invalid

-- 
Jens Axboe

