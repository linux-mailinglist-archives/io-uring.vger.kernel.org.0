Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D40350BC9
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 03:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhDABRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 21:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhDABRw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 21:17:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62C3C061574
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 18:17:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso96502pjb.3
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 18:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VraptSf7dwPO5UR5ade7TQoIgKyz4G2cu1MUk4R/MQU=;
        b=WHw9Rm1J5Lw3uqINN5YXlQwLhHWT7egdvz3ZPpxRo/junyYJHyuv+P44vhLdRnSoIn
         nj7KCbaITKENpYKxBcgG7fE9ASS2xZsceqmoCDBrbMoCgi1+ALvvN8Pun/xNVDDhJ73T
         aqc5xQ79zfHX8UpwCvyso2h6JhCvm6eliBHMLQhkpbZuJYKk5a5a6OAS/O5mSBQMt6tm
         yAeOb+3cnPH6T6HEaUqHGEgIjGRBx4wWgXC2jaT5n3dUuT8To1C3iaIzyLKuzJQ+ZhzL
         UVQ2YwAzc+XX0BiroZ8SscJXumN4lRvGa494QhcU2X8OgBU3HmT87WjNVFribD4CTMo2
         9b5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VraptSf7dwPO5UR5ade7TQoIgKyz4G2cu1MUk4R/MQU=;
        b=MLqfPPra+gOm3spWHXRM9ow0Vt068UPrGlpM43dKkfijjMiewT1qWigWOYRlM1Sngd
         qSee/8VMu5NKG9S+3DwRCZzxXkqPJ8BPXudGeelqnS2aPZEUOaCBdy27JvMpDvE32ymm
         ylD+rj5SOin/SZhQbbCyCj6Toyf1btMXw4Lhe6yD93Q2PP/8kFAIxaoyY0TKLUv5+pWL
         CLqdrt/HR/rOoro9sjXDkNYYP2nNSGy8gOQjqKmRlCEGG6n+k4VRCPvDGjiwUJVYG8yf
         4F1j9PWGev43DfG18sLNkOe+RDc6kc8EvHbdWqI6QVTjO5BDdwkDgSsTkO5wvO7x7cBF
         cINA==
X-Gm-Message-State: AOAM533iAr2kEjZdDjUO2f/8yNq8ViTX834ThxApAzfENYXnqvjjT3D4
        vqsK7ykApLk78hTdFJcrTauMOhvv5jg+vg==
X-Google-Smtp-Source: ABdhPJwrci50JmQERN8bkbT91GY0N/3cC6FOq8IWz9Se0y2ur+yM/EHSWcY4Fr0av0F9svsO1Ptd8w==
X-Received: by 2002:a17:902:b289:b029:e4:bc38:a7 with SMTP id u9-20020a170902b289b02900e4bc3800a7mr5750419plr.50.1617239870808;
        Wed, 31 Mar 2021 18:17:50 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r23sm3434069pje.38.2021.03.31.18.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 18:17:50 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: forcefully cancel on io-wq destroy
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e8330d71aad136224b2f3a7f479121a32b496836.1617232645.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b575afc6-f699-84dc-245c-93af568fad0a@kernel.dk>
Date:   Wed, 31 Mar 2021 19:17:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e8330d71aad136224b2f3a7f479121a32b496836.1617232645.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/21 5:18 PM, Pavel Begunkov wrote:
> [  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
> [  491.222957] Call Trace:
> [  491.222967]  __schedule+0x36b/0x950
> [  491.222985]  schedule+0x68/0xe0
> [  491.222994]  schedule_timeout+0x209/0x2a0
> [  491.223003]  ? tlb_flush_mmu+0x28/0x140
> [  491.223013]  wait_for_completion+0x8b/0xf0
> [  491.223023]  io_wq_destroy_manager+0x24/0x60
> [  491.223037]  io_wq_put_and_exit+0x18/0x30
> [  491.223045]  io_uring_clean_tctx+0x76/0xa0
> [  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
> [  491.223068]  ? blk_finish_plug+0x26/0x40
> [  491.223085]  do_exit+0xc0/0xb40
> [  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
> [  491.223109]  __x64_sys_exit+0x1b/0x20
> [  491.223117]  do_syscall_64+0x38/0x50
> [  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
> [  491.223194] Call Trace:
> [  491.223198]  __schedule+0x36b/0x950
> [  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
> [  491.223218]  schedule+0x68/0xe0
> [  491.223225]  schedule_timeout+0x209/0x2a0
> [  491.223236]  wait_for_completion+0x8b/0xf0
> [  491.223246]  io_wq_manager+0xf1/0x1d0
> [  491.223255]  ? recalc_sigpending+0x1c/0x60
> [  491.223265]  ? io_wq_cpu_online+0x40/0x40
> [  491.223272]  ret_from_fork+0x22/0x30
> 
> When io-wq worker exits and sees IO_WQ_BIT_EXIT it tries not cancel all
> left requests but to execute them, hence we may wait for the exiting
> task for long until someone pushes it, e.g. with SIGKILL. Actively
> cancel pending work items on io-wq destruction.
> 
> note: io_run_cancel() moved up without any changes.

Just to pull some of the discussion in here - I don't think this is a
good idea as-is. At the very least, this should be gated on UNBOUND,
and just waiting for bounded requests while canceling unbounded ones.

-- 
Jens Axboe

