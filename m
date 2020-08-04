Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3223BB0A
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 15:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgHDNUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 09:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbgHDNUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 09:20:40 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFCBC06174A;
        Tue,  4 Aug 2020 06:20:40 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id o18so15415891eds.10;
        Tue, 04 Aug 2020 06:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W1K4qrUBZsqMH/rooAhYGqAkfedt0Wcx/RYRc0TpDNE=;
        b=loB7rMSMxgXWHkJRmz3D6CFFpE9oOC7dC/YkSl7H+U9l6bWgoT4yqyBTp1v+9aGPLr
         yt+SdezVxZBMkQLxtFh15xU3MR2NKqwbXlgCrL/DqRDyJgnjECiODBFBimrYyiy5P/27
         7JVONK/qo6RXkykGT9Q1dUaJJCCPrwzYWkjTXPiVHvLfnV/d7mT987J8yXpdm+zawbD6
         NmgHY4ftiTj8yIFXrPvrl7zNxMSrK3Cae6Qn4UBu+uRn1zKG+R/Y1phRJ0Y2ocxih1Pw
         K4d9KNwmze0IWYJGVwNyAPlCA0xKxE8oZusQ1apxtj02kcWrBXmWrxItprVkx5JPUmB9
         RGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=W1K4qrUBZsqMH/rooAhYGqAkfedt0Wcx/RYRc0TpDNE=;
        b=IG12NR4SDoeSkXrCvbzNZ0ZC4GtIlVqnlmSTFMEhTyeOopmUqSuGYuhKHzAgM7/GDr
         tRafZeNnhnCAl0OB8K2WvezQ4StmWaZ9dXgsUMizqZbOjr0rlK8aEX0Z7R7pOhD4aGDH
         1VG/9pSU60Nd59WZ6096sK/v5IWHfia6Grn/0lpLm0B/NCvuioKtUWIFBW9SLE+7COef
         UFmggDbJHTKl1/FUehKdsD6jabD8aD1kN4T1GPf66+SBHB8H7UMqyY3hQG2PSNt++z1L
         fA+WcFb6c1NdcHS4WuGUMETBVmkZ2VXYcrdD4b+rYCPfIYiMQi7URxCIMsjn1G8rU451
         7DNA==
X-Gm-Message-State: AOAM533zIGj0jEh4z5GNsgn2SznZ/MpP8BV45KFH2BRzqK1GnAvTupOu
        ZzkaCpbMx49/Z6F4J3KOu5S50qLY
X-Google-Smtp-Source: ABdhPJxp1zZ23hbDO9vz5dUZwTOxBrIt28pQP+dbVdwL8x7V86T6f4AkYb1rhjkQmMU77dpTZwOM3A==
X-Received: by 2002:a05:6402:1443:: with SMTP id d3mr11164773edx.40.1596547238063;
        Tue, 04 Aug 2020 06:20:38 -0700 (PDT)
Received: from [192.168.43.215] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id r25sm18298627edy.93.2020.08.04.06.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 06:20:37 -0700 (PDT)
To:     Liu Yong <pkfxxxing@gmail.com>, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20200804125637.GA22088@ubuntu>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] fs/io_uring.c: fix null ptr deference in
 io_send_recvmsg()
Message-ID: <701640d6-fa20-0b38-f86b-b1eff07597dd@gmail.com>
Date:   Tue, 4 Aug 2020 16:18:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200804125637.GA22088@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/08/2020 15:56, Liu Yong wrote:
> In io_send_recvmsg(), there is no check for the req->file.
> User can change the opcode from IORING_OP_NOP to IORING_OP_SENDMSG
> through competition after the io_req_set_file().

After sqe->opcode is read and copied in io_init_req(), it only uses
in-kernel req->opcode. Also, io_init_req() should check for req->file
NULL, so shouldn't happen after.

Do you have a reproducer? What kernel version did you use?

> 
> This vulnerability will leak sensitive kernel information.
> 
> [352693.910110] BUG: kernel NULL pointer dereference, address: 0000000000000028
> [352693.910112] #PF: supervisor read access in kernel mode
> [352693.910112] #PF: error_code(0x0000) - not-present page
> [352693.910113] PGD 8000000251396067 P4D 8000000251396067 PUD 1d64ba067 PMD 0
> [352693.910115] Oops: 0000 [#3] SMP PTI
> [352693.910116] CPU: 11 PID: 303132 Comm: test Tainted: G      D
> [352693.910117] Hardware name: Dell Inc. OptiPlex 3060/0T0MHW, BIOS 1.4.2 06/11/2019
> [352693.910120] RIP: 0010:sock_from_file+0x9/0x30
> [352693.910122] RSP: 0018:ffffc0a5084cfc50 EFLAGS: 00010246
> [352693.910122] RAX: ffff9f6ee284d000 RBX: ffff9f6bd3675000 RCX: ffffffff8b111340
> [352693.910123] RDX: 0000000000000001 RSI: ffffc0a5084cfc64 RDI: 0000000000000000
> [352693.910124] RBP: ffffc0a5084cfc50 R08: 0000000000000000 R09: ffff9f6ee51a9200
> [352693.910124] R10: ffff9f6ee284d200 R11: 0000000000000000 R12: ffff9f6ee51a9200
> [352693.910125] R13: 0000000000000001 R14: ffffffff8b111340 R15: ffff9f6ee284d000
> [352693.910126] FS:  00000000016d7880(0000) GS:ffff9f6eee2c0000(0000) knlGS:0000000000000000
> [352693.910126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [352693.910127] CR2: 0000000000000028 CR3: 000000041fb4a005 CR4: 00000000003626e0
> [352693.910127] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [352693.910128] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [352693.910128] Call Trace:
> [352693.910132]  io_send_recvmsg+0x49/0x170
> [352693.910134]  ? __switch_to_asm+0x34/0x70
> [352693.910135]  __io_submit_sqe+0x45e/0x8e0
> [352693.910136]  ? __switch_to_asm+0x34/0x70
> [352693.910137]  ? __switch_to_asm+0x40/0x70
> [352693.910138]  ? __switch_to_asm+0x34/0x70
> [352693.910138]  ? __switch_to_asm+0x40/0x70
> [352693.910139]  ? __switch_to_asm+0x34/0x70
> [352693.910140]  ? __switch_to_asm+0x40/0x70
> [352693.910141]  ? __switch_to_asm+0x34/0x70
> [352693.910142]  ? __switch_to_asm+0x40/0x70
> [352693.910143]  ? __switch_to_asm+0x34/0x70
> [352693.910144]  ? __switch_to_asm+0x34/0x70
> [352693.910145]  __io_queue_sqe+0x23/0x230
> [352693.910146]  io_queue_sqe+0x7a/0x90
> [352693.910148]  io_submit_sqe+0x23d/0x330
> [352693.910149]  io_ring_submit+0xca/0x200
> [352693.910150]  ? do_nanosleep+0xad/0x160
> [352693.910151]  ? hrtimer_init_sleeper+0x2c/0x90
> [352693.910152]  ? hrtimer_nanosleep+0xc2/0x1a0
> [352693.910154]  __x64_sys_io_uring_enter+0x1e4/0x2c0
> [352693.910156]  do_syscall_64+0x57/0x190
> [352693.910157]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Signed-off-by: Liu Yong <pkfxxxing@gmail.com>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e0200406765c..0a26100b8260 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1675,6 +1675,9 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
>  
> +	if (!req->file)
> +		return -EBADF;
> +
>  	sock = sock_from_file(req->file, &ret);
>  	if (sock) {
>  		struct user_msghdr __user *msg;
> 

-- 
Pavel Begunkov
