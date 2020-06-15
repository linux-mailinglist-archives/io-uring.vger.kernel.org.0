Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31191F9A78
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 16:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgFOOjB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 10:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgFOOjA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 10:39:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7DEC05BD43
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 07:38:59 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b201so7920187pfb.0
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AlD+LICwiIvLTtYfnuORDdMvLerlM40fltHFm8HguOM=;
        b=Cz/M8iMEWh8OWbvja/EPnEx0btECakHXcsdrblbrdDTGLRbPcy6CZOpsFeQVJ2FGZz
         /6j9sLx92AvAQzPITwU5GaPHOfTiw7bM9q1LRlV9xmoz7QdLa3xA46nJ9UkA7rujWngW
         8FkRD/2tP/pqaOjwSDPMui1ktuCk4YtyxHGLTzd44rN8kGown+rFsmhfM8WJ02t2MrUi
         ZGSCUWKUo9j+XF64O9IZYGrpeeiB1UKvrS8/CoGlDYJWaBTINSCRhVxI/1h/73GlDhGC
         vWqsrzR5oK7Mu9cxdcK4JxTg0syHXBn4FSedCXbVxu/LIJj1BxSdVXePGm8bOdKSsP56
         NE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AlD+LICwiIvLTtYfnuORDdMvLerlM40fltHFm8HguOM=;
        b=VjYUOeTrtBkwZn+apgBdryxY5J2d9N+B1j0TRFZleSjzbK7bfKWxEsw4tzc8cv4+n/
         IaLLmZETjxn7eBDRDSg4FCLzYgjT9+8Q3rb+3fzvmzGc0ns0Dg3xwlydRAz2mMrvhmk9
         qIPzWgU7sagUImZdbUObPb3RLZo9wA0tiHCycv2qbKJsS/keiAP5t7oFkrvxMLhvVVHJ
         J5egDsRDU2o+lBPLWNFuy4R8WvwXE2OAytLEkDtvZvNqpqS0yXF0gJCeJ+AczZ4RcjnI
         KTOyNhLT9lE7ivH2SGOJV2XCxSJPTeP/EZmhXsBKIXuRoQLz6VGeGH3EHw/N7ew283fb
         b/NQ==
X-Gm-Message-State: AOAM5310a/uSzVLHaVNb1czdYCIq3bu/d1eM8wq1AVgkDRcJ62PhST4J
        9RerqX50NyX274Ej30nYKAtGpw==
X-Google-Smtp-Source: ABdhPJwtJQzYR8PxiFBA9wMHX6eviM/MV1mSOHg9ZiqJpLfPtZFIqxDSEdsoLEVCdK0d5Wgw7CRy5w==
X-Received: by 2002:aa7:9d02:: with SMTP id k2mr23687864pfp.288.1592231938656;
        Mon, 15 Jun 2020 07:38:58 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 4sm3732181pgk.68.2020.06.15.07.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 07:38:58 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix lazy work init
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiufei.xue@linux.alibaba.com
References: <a75c1537cc655cb766e8e2517e18f74e13d60f1b.1592228129.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eaeab71d-6a53-95e8-03d3-5e22d7e6de49@kernel.dk>
Date:   Mon, 15 Jun 2020 08:38:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a75c1537cc655cb766e8e2517e18f74e13d60f1b.1592228129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 7:36 AM, Pavel Begunkov wrote:
> Don't leave garbage in req.work before punting async on -EAGAIN
> in io_iopoll_queue().
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

Applied, thanks.

-- 
Jens Axboe

