Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8141D4B2B12
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 17:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351824AbiBKQ4f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 11:56:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiBKQ4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 11:56:35 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6782013A
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:56:34 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e11so6391491ils.3
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=WnHyeQl3L0tRj0woeLUNO79D3K0lFHXeR3n2MpQn/e4=;
        b=Lf+gIB/la+8PhH+1jIke/j12tFDjcycg/T4VrlCaMC6h2OKKqgf++x7giV+lKZpMAz
         VQJLNjmTNrhtRdRyZBfF63IZAb6/OLQFT/JPDDZOq4yaPO80yPnQ+ODH0WAMmMbsRdOU
         vq2ReYEFsBGNnJQcyXIOA2xalNZKmpFpsFwPbFRlXTYexjvSk3IEfWgQj7krdVEHDxJ0
         Kp/yr1WjSAQJVlN+ojj6BZruOIu4rCi36moAQwGcR4l/PcaIxZ1BY0R4KUxuqI+ATt2c
         llqCQgf4TmyIr6GOKqGFTnFUt6wWRJPgiuCp0HpAkfNv8e62zXGZraNZ7gIoxeOAt7qL
         A6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=WnHyeQl3L0tRj0woeLUNO79D3K0lFHXeR3n2MpQn/e4=;
        b=lXJmGvuGbjd3Mm7Ygg75xCiSDhJaHKJoWBkrDmW/OvKTTvAfMTBF1F1wgXcuVaqutD
         7TYrIqiCvYpcSxbCECFtd4GSZknt/tqf4dSvelMp6Q/IBbSRXK2XUkP3fdYRSmw2aaU8
         oSNMyxec4/6pTOOn/RtrDosnZAePz23Wn2PjjKBiIlCz4ucqG4L1zn1amIgBbyqS29Lu
         ZM8/20cGPBtmYr4Vd2uoyU44McvmUP+d8PqGMK9p31UoA7U//TsHcoLb0dYaYUtZp865
         upYGIKZzyti3JUHkBJcCb1u5OmoFrmO1TZC2Cp0WKyb1RzeP9cDqjc8KqgkO892rlkOL
         id5A==
X-Gm-Message-State: AOAM531KCONwI8mlNYg1oN1CCYMxgQvCNRpaXStCClR0hZbCgE0sQrMx
        DB8leA+lQj6EWYkWSOr3WjVOvg==
X-Google-Smtp-Source: ABdhPJwPUeqKsl1NsWn9jCYzPs5RZHqhKOqYzaFx47gM5G52IsbvGXmD7aECbDMvdeyzXDkVBvxd4Q==
X-Received: by 2002:a05:6e02:1ba1:: with SMTP id n1mr1349978ili.99.1644598593703;
        Fri, 11 Feb 2022 08:56:33 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l12sm14844640ios.32.2022.02.11.08.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:56:33 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220206095241.121485-1-haoxu@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH 0/3] decouple work_list protection from the big wqe->lock
Message-Id: <164459859318.120249.4788774427765786341.b4-ty@kernel.dk>
Date:   Fri, 11 Feb 2022 09:56:33 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 6 Feb 2022 17:52:38 +0800, Hao Xu wrote:
> wqe->lock is abused, it now protects acct->work_list, hash stuff,
> nr_workers, wqe->free_list and so on. Lets first get the work_list out
> of the wqe-lock mess by introduce a specific lock for work list. This
> is the first step to solve the huge contension between work insertion
> and work consumption.
> good thing:
>   - split locking for bound and unbound work list
>   - reduce contension between work_list visit and (worker's)free_list.
> 
> [...]

Applied, thanks!

[1/3] io-wq: decouple work_list protection from the big wqe->lock
      (no commit info)
[2/3] io-wq: reduce acct->lock crossing functions lock/unlock
      (no commit info)
[3/3] io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
      (no commit info)

Best regards,
-- 
Jens Axboe


