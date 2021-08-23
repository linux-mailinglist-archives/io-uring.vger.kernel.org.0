Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E73F3F4E27
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 18:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhHWQRv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 12:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhHWQRu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 12:17:50 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A688C061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:17:08 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so37701128otf.6
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zF2RgDZNdOnxP8SO0Pf9zKJpCdmBQOpuTDgBDY4uaFw=;
        b=pHmQi7KesUtRDtalIMOp32QnIx11ElK7jTQjJhpjFLlYz5n2G5paHI+qc5BqgQ1P84
         d63cMXyXySAhfbpFNreDijY5GVXxa6ABKaG9j26V19fpzxRhA7JlG8fYsbNvlwZzpUz6
         Eaagk/NiV71SyrmQxvve4+9X8OLk9AcgA7Pb2YlHkS7dIjtMTLw+jz3/HsvwYuXKpi+s
         zemu9/tL7tDiiN65LtWI5g3ZwchWPoH6+nE24wHRvnMONXf0n3YBS5ojOwliLZ1yF/HQ
         RoPHSa4WN2hOZeXYaMY30JXrMheYrYHdmHgHcY/WlzDoYOdzGhf/8zFXgYaCqUUq6nZp
         co8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zF2RgDZNdOnxP8SO0Pf9zKJpCdmBQOpuTDgBDY4uaFw=;
        b=Jko30thuiOB6XqlJ5D0qd2imYcVJ8WPGdxLjM+L3iuinfG+ZVfE0vDDtrKINpSkp9Y
         JhFI/debYMbYxhEcRWBhdZjZFCbnLyBZ9/ncShHeDCv6RoZRA4Frc+MYmWQ06lJpd6x8
         BmU1g45UfHZX4CoWspZxYZgAwqR6sodfEW0Gs9VUhvLPwRUOweVmEdnFKbpUO8tlwOhm
         k1qPnjYTlWcWc1BVYVTa9scx4s9y/wFumxou7FgGXtPsUkCNMiBhVHjBSUztdi0OY2BZ
         EcOhNTQwXySUC0FDq5BckYElXL/ZvrUGbp2u8y3jkTl97kNZZcULb0IBlYCd4V99hkuf
         qUdQ==
X-Gm-Message-State: AOAM532WRuRTVIIaC8zuu67BY8xeaTiSTa1uaGlRNgroow4KGEScq1qf
        ImbXi6HkqA7bJ+gyjESYuioM8w==
X-Google-Smtp-Source: ABdhPJx5UySzxtqURakttmLlYahl4F1lHomAsMCfA1NzdWinUokfQFm5vtsk7qPcWzDGfTijhmPxZg==
X-Received: by 2002:a9d:527:: with SMTP id 36mr16925335otw.363.1629735427450;
        Mon, 23 Aug 2021 09:17:07 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c16sm3878356otp.59.2021.08.23.09.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 09:17:07 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix io_try_cancel_userdata race for iowq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
References: <dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d12f70d5-c661-fda4-24d4-982d046f9ae7@kernel.dk>
Date:   Mon, 23 Aug 2021 10:17:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 6:30 AM, Pavel Begunkov wrote:
> WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
> CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
> Call Trace:
>  io_async_cancel fs/io_uring.c:6014 [inline]
>  io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
>  io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
>  io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
>  io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> io_try_cancel_userdata() can be called from io_async_cancel() executing
> in the io-wq context, so the warning fires, which is there to alert
> anyone accessing task->io_uring->io_wq in a racy way. However,
> io_wq_put_and_exit() always first waits for all threads to complete,
> so the only detail left is to zero tctx->io_wq after the context is
> removed.
> 
> note: one little assumption is that when IO_WQ_WORK_CANCEL, the executor
> won't touch ->io_wq, because io_wq_destroy() might cancel left pending
> requests in such a way.

Applied, thanks.

-- 
Jens Axboe

