Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAB237FFB2
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 23:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhEMVQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 17:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbhEMVQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 17:16:51 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529C0C061574;
        Thu, 13 May 2021 14:15:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso1565061wmh.0;
        Thu, 13 May 2021 14:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JBy/O0ZLfy5u8rFBxaqSpqTiaMXG+jNpqopzCnsfGkY=;
        b=PzKf9qQPySJRpA2r6V70PkjhsEAV0MOiOQyele0GLcd644rLhrRwrqUjzNIGAWL/j7
         /ohdpj3F5c0QPnj/rVgM6NW0lMrx/O9M3KtSi4S/XjxbaLToZhmcgw1eO4ohEqNUgTYQ
         ISMQFGKvorvKhLCZlvcjpf5GyJNw4phDKn6Lp5NjPl1tiihLk3j5xoYHyiu4EJHpg+qo
         HpXYa0z5qsP2VPeVCWLJj/gyhFYQSnm5CDPw/z4OkgxECR0RKQSsmXTE7QKW7L/IA3GJ
         Yxu36UnCXqGusbcvkpW22nhB0NkdF8LFANWCvReBb3Lsy9POt+WuhuR3QXZ+15rCawIP
         /XUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBy/O0ZLfy5u8rFBxaqSpqTiaMXG+jNpqopzCnsfGkY=;
        b=laEbudqwQ4z3/PfhGrw/gheN/V1YdQXliLW5nqoM+hOjOF6dP69miAy4gaknVKqOSg
         SAe5Ht3eyYFj1/mF6/g0h+wc7iOuTrjzxY0onOqVMBBxZtDSi5xuySsrRbUp2dcMzGDo
         IWLCc0jz3LQkKjt71STMZCbHWUGcl8/hBSE7bH4JZiHT7/km0sCa8XmtmwVlzB2Pr5u7
         eooKkOuZp9WAV3xbrPG+hOicu0yfIIQaKB9nfTy8N2nGjz0oKaS586pZEEkerIHtdZqy
         V0z8EZ8/OEd1LrMeZRpyF0cB/QzWbiihfIiNDVcubeNigkYgz1+jBVOnl0EA6hNRjfgu
         DYfw==
X-Gm-Message-State: AOAM533b/0GmhkNnPypBn0bvOX2EGLbiYPVXarCyRnRqfZG5u5xrrAOm
        JwOYalFPo/RvcbF8nZ0jakQ=
X-Google-Smtp-Source: ABdhPJw9zhheEHc6WikRvIAR1PV74rFwAGziRAR8X/1APfkslROsPscqZR1qI1q+Cy+yNvyXnj06kw==
X-Received: by 2002:a05:600c:4e8e:: with SMTP id f14mr3345672wmq.65.1620940539123;
        Thu, 13 May 2021 14:15:39 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.196])
        by smtp.gmail.com with ESMTPSA id g66sm3255414wma.11.2021.05.13.14.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 14:15:38 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
To:     syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000002f920305c1c89a25@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <eb659001-f646-95e7-2037-8615e116582f@gmail.com>
Date:   Thu, 13 May 2021 22:15:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0000000000002f920305c1c89a25@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/21 3:50 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com

May still be there but silent because of fixed buffers changes,
test with the old behaviour restored

#syz test: https://github.com/isilence/linux.git syz_test7

> 
> Tested on:
> 
> commit:         50b7b6f2 x86/process: setup io_threads more like normal us..
> git tree:       git://git.kernel.dk/linux-block io_uring-5.13
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f81a36128b448b98
> dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
> compiler:       
> 
> Note: testing is done by a robot and is best-effort only.
> 

-- 
Pavel Begunkov
