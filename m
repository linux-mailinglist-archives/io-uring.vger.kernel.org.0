Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F096E1A618F
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 04:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgDMCkC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 22:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgDMCkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 22:40:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957CC0A3BE0
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 19:40:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so3262419pjb.3
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 19:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bGFAVxmxtuXUVibisoehtctzVRAULQgEFObReOzddbQ=;
        b=hkc9e97SFOGvD7g1YMypmBbEe7I7Hd/eVFl55vGS4BrxiBFnB+V8BHlY8cK7naMzuN
         ozx9o/bBFfOKKKJjxbm3iLt4uQenoygBA0Lb6pbC5J91Ax3vZCWVhOEpjnM9Elxdd6uo
         htMb1TFGHCM/8hYxLa4seeh7lQevZ5aNXbiftCMvZOcqP5MeKaGjQY9OHOeY8T/fY2zB
         jcJ/ZHRrG3jhxHtKtkcVDocwBU8qfZhPGMGwLhPkZtS6HZi0GRi/nQlSUl9bBck2WiG/
         SYmriMWhWwqQTg8RA12lEzMME19VB1G+j3YmvWjUPXnxJnL2oO63fLLET4pm2e0yv9HK
         Vx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bGFAVxmxtuXUVibisoehtctzVRAULQgEFObReOzddbQ=;
        b=VJv9oD+0FhnbYTy7qTNnsmPq83HycuscJtLUi/szxy11hRHKMl3wShk4HQM/Ws3nb3
         ILDuhaBllfStSX0u0CMe+us0oeBRnb1p9GwNRx7teb2AATcmMOahLOX7sw8lWV36qYbp
         wU3eP0qzhoq3dHlh0uCWTsHH1RGnQW0Fe24VJeJIzdvEyvvtPd4hSOKDRNN+7g0uE2uZ
         cA2RGPMEHJp0eUgR0ab4MsyC+VlSQWi2bqOu+z7X5+lHLW6Z18xo4FbYUZda53YUNXB4
         8VQNPHA6x6Q+nWU1rh0i2Pl6qQ32YmtLbdXkxjcQRZdTn6a7fDgvs1tAd1nN+r6boFCW
         GN6g==
X-Gm-Message-State: AGi0PuY6YiCaETjZIvSyJ9POwN+M+1vMkSFGKhNFLLK+gIp+ewiCgsrC
        hvXbqt/Vu8eImxVtyawh370cwOaJ3gAhYA==
X-Google-Smtp-Source: APiQypJAlaUCo5VvEVkihXuGlThWxDMXS8B4fEyCy9sOfd6WQ7SPfhFCfwPcc38lfjYSnVEYtyqsdA==
X-Received: by 2002:a17:90a:d811:: with SMTP id a17mr19371158pjv.179.1586745601891;
        Sun, 12 Apr 2020 19:40:01 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w142sm7408406pff.111.2020.04.12.19.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 19:40:01 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: restore req->work when canceling poll
 request
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200413020531.2801-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05a36a17-a628-abe8-8835-c4d5d8033511@kernel.dk>
Date:   Sun, 12 Apr 2020 20:39:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200413020531.2801-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/20 8:05 PM, Xiaoguang Wang wrote:
> When running liburing test case 'accept', I got below warning:
> RED: Invalid credentials
> RED: At include/linux/cred.h:285
> RED: Specified credentials: 00000000d02474a0
> RED: ->magic=4b, put_addr=000000005b4f46e9
> RED: ->usage=-1699227648, subscr=-25693
> RED: ->*uid = { 256,-25693,-25693,65534 }
> RED: ->*gid = { 0,-1925859360,-1789740800,-1827028688 }
> RED: ->security is 00000000258c136e
> eneral protection fault, probably for non-canonical address 0xdead4ead00000000: 0000 [#1] SMP PTI
> PU: 21 PID: 2037 Comm: accept Not tainted 5.6.0+ #318
> ardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
> IP: 0010:dump_invalid_creds+0x16f/0x184
> ode: 48 8b 83 88 00 00 00 48 3d ff 0f 00 00 76 29 48 89 c2 81 e2 00 ff ff ff 48
> 81 fa 00 6b 6b 6b 74 17 5b 48 c7 c7 4b b1 10 8e 5d <8b> 50 04 41 5c 8b 30 41 5d
> e9 67 e3 04 00 5b 5d 41 5c 41 5d c3 0f
> SP: 0018:ffffacc1039dfb38 EFLAGS: 00010087
> AX: dead4ead00000000 RBX: ffff9ba39319c100 RCX: 0000000000000007
> DX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e10b14b
> BP: ffffffff8e108476 R08: 0000000000000000 R09: 0000000000000001
> 10: 0000000000000000 R11: ffffacc1039df9e5 R12: 000000009552b900
> 13: 000000009319c130 R14: ffff9ba39319c100 R15: 0000000000000246
> S:  00007f96b2bfc4c0(0000) GS:ffff9ba39f340000(0000) knlGS:0000000000000000
> S:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R2: 0000000000401870 CR3: 00000007db7a4000 CR4: 00000000000006e0
> all Trace:
> __invalid_creds+0x48/0x4a
> __io_req_aux_free+0x2e8/0x3b0
> ? io_poll_remove_one+0x2a/0x1d0
> __io_free_req+0x18/0x200
> io_free_req+0x31/0x350
> io_poll_remove_one+0x17f/0x1d0
> io_poll_cancel.isra.80+0x6c/0x80
> io_async_find_and_cancel+0x111/0x120
> io_issue_sqe+0x181/0x10e0
> ? __lock_acquire+0x552/0xae0
> ? lock_acquire+0x8e/0x310
> ? fs_reclaim_acquire.part.97+0x5/0x30
> __io_queue_sqe.part.100+0xc4/0x580
> ? io_submit_sqes+0x751/0xbd0
> ? rcu_read_lock_sched_held+0x32/0x40
> io_submit_sqes+0x9ba/0xbd0
> ? __x64_sys_io_uring_enter+0x2b2/0x460
> ? __x64_sys_io_uring_enter+0xaf/0x460
> ? find_held_lock+0x2d/0x90
> ? __x64_sys_io_uring_enter+0x111/0x460
> __x64_sys_io_uring_enter+0x2d7/0x460
> do_syscall_64+0x5a/0x230
> entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> After looking into codes, it turns out that this issue is because we didn't
> restore the req->work, which is changed in io_arm_poll_handler(), req->work
> is a union with below struct:
> 	struct {
> 		struct callback_head	task_work;
> 		struct hlist_node	hash_node;
> 		struct async_poll	*apoll;
> 	};
> If we forget to restore, members in struct io_wq_work would be invalid,
> restore the req->work to fix this issue.

Thanks, I already applied v1 but with the changes mentioned:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.7&id=b1f573bd15fda2e19ea66a4d26fae8be1b12791d

-- 
Jens Axboe

