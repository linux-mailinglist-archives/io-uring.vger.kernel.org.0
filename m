Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16A46C0EF
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 17:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhLGQwA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 11:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbhLGQwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 11:52:00 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1D9C061574
        for <io-uring@vger.kernel.org>; Tue,  7 Dec 2021 08:48:29 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k21so17943614ioh.4
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 08:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Ik1fUnh9mXBWWKkzddOCfaOCq09gl9lPl3UCD5Szhlo=;
        b=N9YdNM968vz1wHpmfQFNAk921MEdkgS4B4SkYRrgJt4U0AYZPJOwHfFCZ0RUTHel7m
         MHPO+JIOi2TfRYsfUJkhajzgTG3IEpvuFLwwQvRomwn0S7M7adiEfAaqilEpEKYq6Hyq
         rFc95BL69Ps3yfJMMlZKQGKr6IVZ1KaaNr1Uhr2GqUTm6JvJ2ZV6kIO/J6TXRiyqgqAb
         r/XWZOYeWx/zaIhz8ONORrqu/TX2TSxRxjzCS2JAtE3iL+ExW+e5a1rInNeF7Or/Gqif
         0IQHm+DOn0e25u8oyzDQTqp/Mir2NjZ4uJL69iQ+1NXF0u63/9BwvkuTrgM9oUAgoc6r
         WYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Ik1fUnh9mXBWWKkzddOCfaOCq09gl9lPl3UCD5Szhlo=;
        b=RPH2cbsGQfLnBrBMlQW4npx8aX6EdOm561y7xmaxnoU8leHUTnVlLrhYeVCzTeBtEd
         N04vHfr3+hvCa1zg9GFvSzWBTr+L/pflaWXTguUGxsT/aP2yYiSHZtGsMYzfW2ToVFrb
         CmpluKG+Nlu6/GBGSrGK+g+ELXgy5tiA2mWN0jfm60sharrGGpS3pN6boVMFI1xceWTl
         eF8dtLj/+jUqEZOvlmgJKmKvkyXYMuLO0/80wldu7mZY2gpjvF8DgCSSQC5l1C/O7B7Y
         iu2dLChooAsrSOIT+jGagGtkPlrLDruz8F0Jte0FYht0ucKAgaFwFeihCqgbYSRG1KDA
         21tQ==
X-Gm-Message-State: AOAM532eU7HoOp6IyU5S72UISb7qDSjxJAaDE+Xzi7VG1KuECaCZkq4L
        cprOYRFJnTWudNCctbUdLq6EMA==
X-Google-Smtp-Source: ABdhPJyv7exC4N9QVa574ivBud3qdFR688KDHF7K92IUsIhLQf+Ac4leizWExUhTAdhvHlthG+CQ1w==
X-Received: by 2002:a02:c6c5:: with SMTP id r5mr53773263jan.110.1638895708733;
        Tue, 07 Dec 2021 08:48:28 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h14sm141434ild.16.2021.12.07.08.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:48:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        io-uring@vger.kernel.org
In-Reply-To: <20211207093951.247840-1-haoxu@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH v7 0/5] task optimization
Message-Id: <163889570793.163542.7405893922358223646.b4-ty@kernel.dk>
Date:   Tue, 07 Dec 2021 09:48:27 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 7 Dec 2021 17:39:46 +0800, Hao Xu wrote:
> v4->v5
> - change the implementation of merge_wq_list
> 
> v5->v6
> - change the logic of handling prior task list to:
>   1) grabbed uring_lock: leverage the inline completion infra
>   2) otherwise: batch __req_complete_post() calls to save
>      completion_lock operations.
> 
> [...]

Applied, thanks!

[1/5] io-wq: add helper to merge two wq_lists
      commit: ce220e94513db1231a91847e2d5dd51baec6613c
[2/5] io_uring: add a priority tw list for irq completion work
      commit: e4780d989211b8d41571493d9423cc46a2cbe191
[3/5] io_uring: add helper for task work execution code
      commit: 9277479b763b9f210cab256022dd974341b87c69
[4/5] io_uring: split io_req_complete_post() and add a helper
      commit: 028b57a9cfb34267542484f26f25ae4d2dc31d67
[5/5] io_uring: batch completion in prior_task_list
      commit: 186cbb99b1e82b857b986ce886bafb255bd2f43c

Best regards,
-- 
Jens Axboe


