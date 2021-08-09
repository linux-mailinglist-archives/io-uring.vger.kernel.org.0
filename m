Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFEC3E3F11
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 06:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhHIEgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 00:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhHIEgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 00:36:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F301EC06175F
        for <io-uring@vger.kernel.org>; Sun,  8 Aug 2021 21:36:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l11so3406043plk.6
        for <io-uring@vger.kernel.org>; Sun, 08 Aug 2021 21:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=UvK7f/CVhwGrNV6py3unUYqxvVXzp3MeJX4ZOds9I8s=;
        b=YJNc+xjzKkHHNtQM/zZXbYifAM+pepdqFh1io5qwxnjJBcVVIDMRTsgiwm5hFcIDo8
         RyBd2GUYGBKzl4S9OxQkP30VRUx0SpfARSLC79wKdtdmU3S42vbf7k+ILLVfwocJ3FkC
         KXfUKqGAXAgrDepK5g+LLfak16suVIZg8zkf3Ka6jWwL2+FGTG7khCzkeYoXFG/jOZi/
         n+6JZ5v0ghw5+1fkGreValRt/yVqwUlVU04JHZYq4hy5sk25e4nOM094dYXywAUiEFxX
         MAHd1hENX/EtHp69GmruYYkN9tB37dnjRRdyKsPtpScsCxsmFxt2C+EiNqOrKoLamfxj
         Q0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=UvK7f/CVhwGrNV6py3unUYqxvVXzp3MeJX4ZOds9I8s=;
        b=TM/r11pBxINQg04m1nLl/15vFz82NtgLGf4Zhsfz9YlqvMr3+oy1X2+2RbqQKKgIo/
         Dm8sH44vZ+c4Cxmk0LGstqeLFhmlShG/gfmhXAAZXXM1QhjavPO8SfOEq0bKU9dmydPC
         ruEGIOk62yhtAj5K3KVJNWhAIkTakde3xSmkcNV9ei0LjCNOBUCFiRHRMcW15qN63nXA
         aU36f8OhjTvePED/8ahGZLXTlMepgm8XwiuafzR2AN3VFVdHSbJxpe3qJanOS+DSzli7
         SW1ubmx+sVwDlc+VHpSnjQhb8Hf1FmS+5sviSl7Gscq6ba8W+7Wgx2fzKybPtcEITNxk
         Yfug==
X-Gm-Message-State: AOAM530b6VjsCLeN1B0j87reuI8fcautT6rbg6IoUBZlwyk0TmXHv3vm
        cvBgkKm/WNsgf/6ljDjinA20Zp6J6YitBQ==
X-Google-Smtp-Source: ABdhPJywa5tVb2gqbNOy8vyqHsCt9Q45LFlvTAn+B2dXzj6dcCGd1XHtDBa7S3PBlSFISeOZvkB3Yw==
X-Received: by 2002:aa7:85cf:0:b029:3bc:9087:a94f with SMTP id z15-20020aa785cf0000b02903bc9087a94fmr16169333pfn.78.1628483780247;
        Sun, 08 Aug 2021 21:36:20 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id b12sm18866415pff.63.2021.08.08.21.36.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Aug 2021 21:36:19 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: iouring locking issue in io_req_complete_post() / 
 io_rsrc_node_ref_zero()
Message-Id: <C187C836-E78B-4A31-B24C-D16919ACA093@gmail.com>
Date:   Sun, 8 Aug 2021 21:36:18 -0700
Cc:     io-uring@vger.kernel.org
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens, others,

Sorry for bothering again, but I encountered a lockdep assertion =
failure:

[  106.009878] ------------[ cut here ]------------
[  106.012487] WARNING: CPU: 2 PID: 1777 at kernel/softirq.c:364 =
__local_bh_enable_ip+0xaa/0xe0
[  106.014524] Modules linked in:
[  106.015174] CPU: 2 PID: 1777 Comm: umem Not tainted 5.13.1+ #161
[  106.016653] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 07/22/2020
[  106.018959] RIP: 0010:__local_bh_enable_ip+0xaa/0xe0
[  106.020344] Code: a9 00 ff ff 00 74 38 65 ff 0d a2 21 8c 7a e8 ed 1a =
20 00 fb 66 0f 1f 44 00 00 5b 41 5c 5d c3 65 8b 05 e6 2d 8c 7a 85 c0 75 =
9a <0f> 0b eb 96 e8 2d 1f 20 00 eb a5 4c 89 e7 e8 73 4f 0c 00 eb ae 65
[  106.026258] RSP: 0018:ffff88812e58fcc8 EFLAGS: 00010046
[  106.028143] RAX: 0000000000000000 RBX: 0000000000000201 RCX: =
dffffc0000000000
[  106.029626] RDX: 0000000000000007 RSI: 0000000000000201 RDI: =
ffffffff8898c5ac
[  106.031340] RBP: ffff88812e58fcd8 R08: ffffffff8575dbbf R09: =
ffffed1028ef14f9
[  106.032938] R10: ffff88814778a7c3 R11: ffffed1028ef14f8 R12: =
ffffffff85c9e9ae
[  106.034363] R13: ffff88814778a000 R14: ffff88814778a7b0 R15: =
ffff8881086db890
[  106.036115] FS:  00007fbcfee17700(0000) GS:ffff8881e0300000(0000) =
knlGS:0000000000000000
[  106.037855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.039010] CR2: 000000c0402a5008 CR3: 000000011c1ac003 CR4: =
00000000003706e0
[  106.040453] Call Trace:
[  106.041245]  _raw_spin_unlock_bh+0x31/0x40
[  106.042543]  io_rsrc_node_ref_zero+0x13e/0x190
[  106.043471]  io_dismantle_req+0x215/0x220
[  106.044297]  io_req_complete_post+0x1b8/0x720
[  106.045456]  __io_complete_rw.isra.0+0x16b/0x1f0
[  106.046593]  io_complete_rw+0x10/0x20

[ .... The rest of the call-stack is my stuff ]=20


Apparently, io_req_complete_post() disables IRQs and this code-path =
seems
valid (IOW: I did not somehow cause this failure). I am not familiar =
with
this code, so some feedback would be appreciated.

Thanks,
Nadav

