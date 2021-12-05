Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3E468C06
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 16:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhLEQAQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 11:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhLEQAQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 11:00:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F2FC061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 07:56:49 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id k21so10105944ioh.4
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 07:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=tc+Wak176MQ5RwRaJdNR9r7WDJcunZm7pabqmDxViCA=;
        b=TbQMUyewo2GPpLtVJOYgNHHHPS4Z6AOX8BMS/r9yDG2HaGK0v9yAAabrAWd6uWvcck
         uq3rFbKD3hYyg5o869+3SwzfcI3BmHMqZ7InohLVoKJXTNBFod4LYEovO/TsA+A/T1Qy
         0WfTMhVRK57yBNLMWKPw4lgmgP/K16K7Hs4KtrbQlZ7kZZwYfnBd9WVcluWZVMvXMXdw
         KA6dpBA9kEWPwSOSOfCi/RGB9yGx4D3Ik6vI4pC5B8oBeVjeXtMSn1jAr8u8KAqvRb4y
         5+UiDPFxDjJg2EELGjZAc6tZmjRvRjPSyX6AQkuIou/kvu/FgTu8nAEPyrHGCkGBZ1Y4
         CupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=tc+Wak176MQ5RwRaJdNR9r7WDJcunZm7pabqmDxViCA=;
        b=3BI4axv4Y6lM9c/6Jp0l4edx945k6ct7kgKmEPb/dGn6EKnfgHNykDm11S6o4p0Vh0
         sh5qz3kpLk7yDrUKfTC7k2EQjyuF98gUNjBbbC/Y8+XeflvtyYCz3ILo73orqxA/XgNC
         hInIumNMlGjEvekWyZfuvuilhJgWLeRbzRM+sqkU/O5rMr3VBZwghpKybiviOkTlTo2m
         gvdjKv7HvTvHywVwnjnYQCXDNRo19Ie6PWKCySWvd4pIxHoFUnproterH7ojw6MwmTuG
         Dty5goF0aOQue5OiRIS+eTi4btQMUKQy9SUJHg4e0dPobpsJrhcFKzgX648Yqb9UMdfj
         Zdtw==
X-Gm-Message-State: AOAM531fN8xx+/as+xj50CyNgnrsOfSHnEGIWu3GXHGHHhN9g5zYfvYe
        QLHuZ3TCAt5bgvIVK1gZVFGxCwZlvAOIUD/F
X-Google-Smtp-Source: ABdhPJxJJXxAA4g4kKTTQMrI0eg+wrCKWhSsSoqzeubGz0HUN4SMJ8E4lQmnWPqfa+EoVNJj4zQBoA==
X-Received: by 2002:a05:6638:2402:: with SMTP id z2mr36138894jat.122.1638719808815;
        Sun, 05 Dec 2021 07:56:48 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d3sm5175056ilu.28.2021.12.05.07.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 07:56:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1638714983.git.asml.silence@gmail.com>
References: <cover.1638714983.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] small 5.17 updates
Message-Id: <163871980825.427546.15007889889392718455.b4-ty@kernel.dk>
Date:   Sun, 05 Dec 2021 08:56:48 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 5 Dec 2021 14:37:56 +0000, Pavel Begunkov wrote:
> 3/4 changes the return of IOPOLL for CQE_SKIP while we can, and
> other are just small clean ups.
> 
> v2: adjusted 3/4 commit message
> 
> Hao Xu (1):
>   io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
> 
> [...]

Applied, thanks!

[1/4] io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
      commit: 3648e5265cfa51492a65ee5a01f151807ec46dee
[2/4] io_uring: simplify selected buf handling
      commit: d1fd1c201d750711e17377acb4914d3ea29a608c
[3/4] io_uring: tweak iopoll CQE_SKIP event counting
      commit: 83a13a4181b0e874d1f196e11b953c3c9f009f68
[4/4] io_uring: reuse io_req_task_complete for timeouts
      commit: a90c8bf6590676035336ae98cc51bce1aeb96c33

Best regards,
-- 
Jens Axboe


