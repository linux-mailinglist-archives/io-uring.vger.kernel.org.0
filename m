Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5751F9976
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgFOOBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 10:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOOBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 10:01:12 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC125C061A0E;
        Mon, 15 Jun 2020 07:01:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p5so17232386wrw.9;
        Mon, 15 Jun 2020 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M7wQKWp9lNb+0zWRIHsa3B/WaoRNCApu4CB/A57cLAA=;
        b=QYWmZk35FyUTn2ZVO/ILE+7wV0p9nKuexSfotzMLtwksG9mZT8SaHCx6GkpndBvjtv
         ERbAhDS0UK5Yz9TmoRQaf9AosmldGH6QyEkp0UyvbFRx0MefuJnOS24MN1EaOxHx48fc
         VMpRbQHPvoEqGP6Iep7jFFM6PR7FwGaqtkd4JqpY1dhokoBOA2oO9qAABtvkLEd79632
         BhRLCB/7Lh1qQwhZGqWUlbMzQjD7tVzJuqtLstZyF5qaQvKxyNarA3Yv49lBBCvA0siG
         hTf2S2/hLpoWANuEmbUXqTQVr0MJtUj7Js69HCmIeg60oFZUI/OhH/mMpbSPYxmB+zXC
         8KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M7wQKWp9lNb+0zWRIHsa3B/WaoRNCApu4CB/A57cLAA=;
        b=gPwJOJhpGYsduILtmcYE8cKYMotw8wRSqgjZW212GS2GgS890mFqI8+SdzK8JVwVSa
         e9FR7WUMHQaIiQxYOUfGBce5DxkDL4A4x+qdO/GSydc/xOJ4itsxBsoww3FDhGbvkz15
         Be9x34TDtCKfuTs6DYXEKYpGjo/r8GBx/3bvb6Jzqw9oGKPK4PEgr/oClbr5A7KKdOsa
         JGEtu9ab2Wf97qdQta8F/XvXIX9rb80QR3bW/a9XUUqEMVMbrXX/+LsnHs7D/corzx0A
         UPp9UlnPTbScuJqmT4sGgiGtXOChAtYqii/eOMR4aiE6QPHxTKOUcngTwG0BErvd9XTc
         obqQ==
X-Gm-Message-State: AOAM531zv2h57VtrNFpVofIEzm7kqpAQYEDaQ5QCmqU/OH3m+idZ32sm
        4L+7KPxL6xssh+Swio7MF9UZVTu6
X-Google-Smtp-Source: ABdhPJy4hwrw4GC32VIHoHzNMPLIZ+ob1IM2iYpeXw/u5Ad2TzyFeOTTQE2m/CfgvzuE7W9ttFPQ/g==
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr28482081wrq.218.1592229670557;
        Mon, 15 Jun 2020 07:01:10 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id d17sm25697154wrg.75.2020.06.15.07.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 07:01:08 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix lazy work init
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiufei.xue@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <a75c1537cc655cb766e8e2517e18f74e13d60f1b.1592228129.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1d7ac6e0-a14c-a102-ad33-a3b2b1e160d4@gmail.com>
Date:   Mon, 15 Jun 2020 16:59:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a75c1537cc655cb766e8e2517e18f74e13d60f1b.1592228129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/06/2020 16:36, Pavel Begunkov wrote:
> Don't leave garbage in req.work before punting async on -EAGAIN
> in io_iopoll_queue().

oops, cc'ed a wrong person.
+Cc: Xiaoguang Wang

> 
> [  140.922099] general protection fault, probably for non-canonical
>      address 0xdead000000000100: 0000 [#1] PREEMPT SMP PTI
> ...
> [  140.922105] RIP: 0010:io_worker_handle_work+0x1db/0x480
> ...
> [  140.922114] Call Trace:
> [  140.922118]  ? __next_timer_interrupt+0xe0/0xe0
> [  140.922119]  io_wqe_worker+0x2a9/0x360
> [  140.922121]  ? _raw_spin_unlock_irqrestore+0x24/0x40
> [  140.922124]  kthread+0x12c/0x170
> [  140.922125]  ? io_worker_handle_work+0x480/0x480
> [  140.922126]  ? kthread_park+0x90/0x90
> [  140.922127]  ret_from_fork+0x22/0x30
> 
> Fixes: 7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests
> completed inline")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 54addaba742d..410b2df16c71 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1105,6 +1105,7 @@ static inline void io_prep_async_work(struct io_kiocb *req,
>  			req->work.flags |= IO_WQ_WORK_UNBOUND;
>  	}
>  
> +	io_req_init_async(req);
>  	io_req_work_grab_env(req, def);
>  
>  	*link = io_prep_linked_timeout(req);
> 

-- 
Pavel Begunkov
