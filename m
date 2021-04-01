Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176E35139D
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 12:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhDAK3l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 06:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbhDAK32 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 06:29:28 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9AFC0613A6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 03:29:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z2so1289083wrl.5
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 03:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x05r8YWvUwGqjuKmJSu/YGmYOasyDxlpP0oBK3PABTE=;
        b=QQAwSrjGUXTL7xC5qoz+3c217YM45qBXyfCVRfj+wQ8UxOS4iHhNtdeYL8nqrMtka2
         kmFEiHOVIuasQj0jk11mfirc4oFBUQr/TKLf7rCBDF0vDHJ+zR+G4cqMslhq/F00J8Fx
         gtazPrTiiw2ZDb0ESj58RhG5UUfIXRJSnfLVHtJtbcNlREkJ51iXkTs2G+l23hYycRVa
         jEwre4kCo9WJk3WSr83CbA4SfwVcnYoGorm9HI5q/SuKnsSX31DTjJJ+A3sFkQkuCM0Z
         3PxGKB+/tffFoI5Hmrmmsmg3UaK5mryHqsKJHza7vJ9UsdXiYt64OyylDp/HYTdo+ZSk
         ZOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x05r8YWvUwGqjuKmJSu/YGmYOasyDxlpP0oBK3PABTE=;
        b=rDIoXjEC6raHZliHubd314Cc4c/Tiw9a2POQ9e8G/W0B6i/XpKF6M2CsvD6l9FgctH
         Y7O+s8dSfrlFrKOB5sBp4w0mIsaU1I8xYNwwtrjU/QRFfTaA+30lb9CZZu2GRUgyNQGO
         1lwqw6YtxPJ+lLOoyYF7xfx44TaB1lQrSXcAPevNJuFsLRWNqrzbJieahTTzVsgk2sl6
         eUh+fpxa8uBkF8KiFMG6/2TG1lehjVbN9E2Vr+Q81OHE6jRP4ooTKeD6cP/2/h59+S/A
         t9OyYwe1V8Yq5h6niunXt/cPA3WzNHWbSw8g8g4DigNXGVwRl+pHQ+0uz1eF7j8NtXpK
         PU/g==
X-Gm-Message-State: AOAM530Gjvh4kWASNM2nvosziOzgDTRJo66rCt7mg8F/6sWzyM74jPa3
        d8vnCUdgbrV0bzEhEZF7uZ6grg412sUddg==
X-Google-Smtp-Source: ABdhPJxZ6wqNSYI2c1tc+gtKNIv36H7HjR/Vfgp87KlYCz/m+89KqfPpAr3Fknk09/QPRAeO1kyU7A==
X-Received: by 2002:adf:83c2:: with SMTP id 60mr8756347wre.386.1617272963945;
        Thu, 01 Apr 2021 03:29:23 -0700 (PDT)
Received: from [192.168.8.122] ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id z8sm9001854wrh.37.2021.04.01.03.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:29:23 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e8330d71aad136224b2f3a7f479121a32b496836.1617232645.git.asml.silence@gmail.com>
 <b575afc6-f699-84dc-245c-93af568fad0a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: forcefully cancel on io-wq destroy
Message-ID: <6597f401-b697-674a-954a-34d89a204c56@gmail.com>
Date:   Thu, 1 Apr 2021 11:25:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b575afc6-f699-84dc-245c-93af568fad0a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/04/2021 02:17, Jens Axboe wrote:
> On 3/31/21 5:18 PM, Pavel Begunkov wrote:
>> [  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
>> [  491.222957] Call Trace:
>> [  491.222967]  __schedule+0x36b/0x950
>> [  491.222985]  schedule+0x68/0xe0
>> [  491.222994]  schedule_timeout+0x209/0x2a0
>> [  491.223003]  ? tlb_flush_mmu+0x28/0x140
>> [  491.223013]  wait_for_completion+0x8b/0xf0
>> [  491.223023]  io_wq_destroy_manager+0x24/0x60
>> [  491.223037]  io_wq_put_and_exit+0x18/0x30
>> [  491.223045]  io_uring_clean_tctx+0x76/0xa0
>> [  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
>> [  491.223068]  ? blk_finish_plug+0x26/0x40
>> [  491.223085]  do_exit+0xc0/0xb40
>> [  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
>> [  491.223109]  __x64_sys_exit+0x1b/0x20
>> [  491.223117]  do_syscall_64+0x38/0x50
>> [  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
>> [  491.223194] Call Trace:
>> [  491.223198]  __schedule+0x36b/0x950
>> [  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
>> [  491.223218]  schedule+0x68/0xe0
>> [  491.223225]  schedule_timeout+0x209/0x2a0
>> [  491.223236]  wait_for_completion+0x8b/0xf0
>> [  491.223246]  io_wq_manager+0xf1/0x1d0
>> [  491.223255]  ? recalc_sigpending+0x1c/0x60
>> [  491.223265]  ? io_wq_cpu_online+0x40/0x40
>> [  491.223272]  ret_from_fork+0x22/0x30
>>
>> When io-wq worker exits and sees IO_WQ_BIT_EXIT it tries not cancel all
>> left requests but to execute them, hence we may wait for the exiting
>> task for long until someone pushes it, e.g. with SIGKILL. Actively
>> cancel pending work items on io-wq destruction.
>>
>> note: io_run_cancel() moved up without any changes.
> 
> Just to pull some of the discussion in here - I don't think this is a
> good idea as-is. At the very least, this should be gated on UNBOUND,
> and just waiting for bounded requests while canceling unbounded ones.

Right, and this may be unexpected for userspace as well, e.g.
sockets/pipes. Another approach would be go executing for some time, but
if doesn't help go and kill them all. Or mixture of both. This at least
would give a chance for socket ops to get it done if it's dynamic and
doesn't stuck waiting.

Though, as the original problem it locks do_exit() for some time,
that's not nice, so maybe it would need deferring this final io-wq
execution to async and letting do_exit() to proceed.

-- 
Pavel Begunkov
