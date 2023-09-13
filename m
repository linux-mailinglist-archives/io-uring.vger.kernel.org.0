Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3393879E8B8
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbjIMNKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjIMNKe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 09:10:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332C19B9;
        Wed, 13 Sep 2023 06:10:30 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99bcf2de59cso873029366b.0;
        Wed, 13 Sep 2023 06:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694610629; x=1695215429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EItSaMMIQ4l0sl5dWXf433pLMyLU6EyR+eht2eo0tf4=;
        b=oZhN97+3QjThY2NXckVNp2H5XEz8OC0Ed1IVZtdaeBea+DFmsLgxlkNYUUlq6x2jcd
         4dLOY9ldREGlJRbkyzTwhBF66jF0hMX0/IPG1sFFZg8sFJnvXgaC8YvCzs1f/8NKyH84
         sBMxn/+5b0ac7OxQ1XoueEix4vEYJz28Idx29AAFT++Z/K9ZJnuw3njN8M17KSjk2XGG
         buygfKuQFOmyE63P2Q5/VdGiszeKS00aN7cliUjJ1eVDPkgD/ExaKyJ2FcGCe4EorC5l
         OvUvZnDEZtqdvyVb6byWWPR+/vmp0vKwQ/JJf9PysFHAlKnuntM0yEhs0qvtFkLoS0EN
         r06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694610629; x=1695215429;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EItSaMMIQ4l0sl5dWXf433pLMyLU6EyR+eht2eo0tf4=;
        b=EhU5JmXPBFqE5qQv1u26yQdcpdUPNjVmtk9hSgwBfYCH8xUJzLEWuGslF17ejzqElp
         1wC6Q1ArPZvgE16y8BrZJkYbe60HzWE3edqviISqNg/OvVJBSP1NrjcKc+TCdRGoiY/C
         n0DoerM5WqdsJ8x2b2NBoG7mkOI8XizNrc+dNrJQWRKKWor/5oWsFRw3bCNu6G8Ofpg2
         eZ4KeUJ56onxNJkZphHrnPFOgOAcNCXQ86/xgj8lMRqoBfc+T3UkP5e6Ed4Mql4BQI5W
         kbtCRDOZ/UoNMkgeRq7ZBhe6y5mT6wxRMeOePqWJAMbtBnuKIbz91lpzfL7J9eEzh7s8
         LfhQ==
X-Gm-Message-State: AOJu0YwBk5DgXrVyr5nsUas7dKMfceYWwnkKHEKaKKd4PN+2TOvLMvgS
        GoQqt4wbdLFzYd8FCZa5oq4=
X-Google-Smtp-Source: AGHT+IGmAg2nyNeH7X7N2h+wRrIog5pODFyZFwQdi/rVOMuR2kfnsZOFkB2q8Bv0vKhjzzWN4T8nSA==
X-Received: by 2002:a17:906:8a63:b0:9aa:138d:9f4e with SMTP id hy3-20020a1709068a6300b009aa138d9f4emr1807330ejc.56.1694610628947;
        Wed, 13 Sep 2023 06:10:28 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7e52])
        by smtp.gmail.com with ESMTPSA id lj16-20020a170906f9d000b00992d0de8762sm8419626ejb.216.2023.09.13.06.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 06:10:28 -0700 (PDT)
Message-ID: <e8d6c6ba-e9f0-45ac-219e-c1427424d31a@gmail.com>
Date:   Wed, 13 Sep 2023 14:10:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] UBSAN: array-index-out-of-bounds in
 io_setup_async_msg
Content-Language: en-US
To:     syzbot <syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000002770be06053c7757@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000002770be06053c7757@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 13:11, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0bb80ecc33a8 Linux 6.6-rc1
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d1eb78680000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
> dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16613002680000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13912e30680000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/eeb0cac260c7/disk-0bb80ecc.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a3c360110254/vmlinux-0bb80ecc.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/22b81065ba5f/bzImage-0bb80ecc.xz
> 
> The issue was bisected to:
> 
> commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Thu Aug 24 22:53:32 2023 +0000
> 
>      io_uring: add option to remove SQ indirection
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15892e30680000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17892e30680000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13892e30680000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
> Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
> 
> ================================================================================
> UBSAN: array-index-out-of-bounds in io_uring/net.c:189:55
> index 3779567444058 is out of range for type 'iovec [8]'
> CPU: 1 PID: 5039 Comm: syz-executor396 Not tainted 6.6.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0x125/0x1b0 lib/dump_stack.c:106
>   ubsan_epilogue lib/ubsan.c:217 [inline]
>   __ubsan_handle_out_of_bounds+0x111/0x150 lib/ubsan.c:348
>   io_setup_async_msg+0x2a0/0x2b0 io_uring/net.c:189

Which is

/* if were using fast_iov, set it to the new one */
if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
	size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
	async_msg->msg.msg_iter.__iov = &async_msg->fast_iov[fast_idx];
}

The bisection doesn't immediately make sense, I'll try
it out

-- 
Pavel Begunkov
