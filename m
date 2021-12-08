Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47D546DB2D
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhLHSio (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 13:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhLHSio (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 13:38:44 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3B3C061746
        for <io-uring@vger.kernel.org>; Wed,  8 Dec 2021 10:35:10 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p65so3853532iof.3
        for <io-uring@vger.kernel.org>; Wed, 08 Dec 2021 10:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Mp/umo0ij8ijwWQmx/BTmxZMxH9eLxn6w69qjVTXGwQ=;
        b=mkmkgyBL6fHYwFbuMOX7s6gubidA4q1GtClYptmr5hRipUf4QIFl56TRnmTap7GfOP
         dcepUdwsO3RIa+PB0Y8L+/3OOOkJAPdsGjXk5ztFWw7wu0K2hJm/dQOLOigUwyTiYkd4
         l94fMEBdp7RnyfoXI41Xu+CvaFrgiHuZ7FyDMtkmHmI+aShxNmkSO5vzEa+4Z4uOubh1
         Gxfde33xWK9Pg32FQ5uJB3uNRwdwhYbTtNmu5/6N8ol9lp36zuQmYhiLzlxXYldbOMtt
         AKpK8sJkvOWdxbL66JN3gd83TsV+9UvKfnpnYma3COiKKzdb+/FBFpr97HIjNC5NtGz6
         bg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Mp/umo0ij8ijwWQmx/BTmxZMxH9eLxn6w69qjVTXGwQ=;
        b=e7LcKfbN5/8juia5FXu+9uxyFXrHhHF+cq4RV/fvUIICMLrLKLwlXZ08bdglEB9H48
         42s3e/pzTD2H2GsYoSIGZUCEMOoE4p2abAeHK9uQEERpqqBRauPTmWfyDCpIgxUfm7B3
         ONDLKJsZ8utQyA2alo6j8jAFbSiygCPilj0z0de/tqqNtGXOP6wPjnCuT9snL8IOGzGK
         gV8v8wEGGLW0UQcnHiiRZphzJyzwUZI5ammG8+0/2KMrMiqu0GDqgQbdMuctU5nX7R9s
         belLcleHr3Ly2stbCppl50wT+DkXFFl9AEjbziRKhpvo00L/1Szjxn9XklGTjVsPZlzn
         CphQ==
X-Gm-Message-State: AOAM532C9KZiekhb/N0lhCYNaBJvZV0va2ii3ASlRth6JDAncdyWNFSp
        iOGVZ6N1mTlFRmUiKhZDpyLn0w==
X-Google-Smtp-Source: ABdhPJzyg7zGCAFXyLJN/nnEVFnuoG410ick2SWZPjLH03bODa9tSiFC54iy4fFbRV9jLBTGq1KAPg==
X-Received: by 2002:a05:6602:2ac5:: with SMTP id m5mr8718089iov.156.1638988509525;
        Wed, 08 Dec 2021 10:35:09 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k10sm2509081ilu.80.2021.12.08.10.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:35:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
In-Reply-To: <20211208052125.351587-1-haoxu@linux.alibaba.com>
References: <20211208052125.351587-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH v8] io_uring: batch completion in prior_task_list
Message-Id: <163898850760.215031.2046444798170708740.b4-ty@kernel.dk>
Date:   Wed, 08 Dec 2021 11:35:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 8 Dec 2021 13:21:25 +0800, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.
> 
> 

Applied, thanks!

[1/1] io_uring: batch completion in prior_task_list
      commit: f28c240e7152462f0750a8939db28d985ecf7c67

Best regards,
-- 
Jens Axboe


