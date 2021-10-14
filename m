Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC8E42DDB3
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhJNPON (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbhJNPN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:13:56 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A673C061361
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:06:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id i189so4169990ioa.1
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VMQ+k7bLAjbj3fMB/xZGcjvf+XpTjPwLDTz2lQgj24=;
        b=53m+az9tDqmLetTnYX7UZCC9ZjoUUtM+shTetZ0T7mJIN5Rf4EkRWMJH4OzdEpkN+n
         p94h0WYnk2SbbP5sWpDWm0u/eu67jFLHIUGRMCtZh6/vOFd3E7rjccCwGWf1D3K5n1KR
         L59/zQD0UT2za2lDVwYOdk/PNqdVaZYTQazGEZARVZFUfkZgObEQu9yYa883autpjzkq
         xo+55V2WQwsnb2Z2iA7wQoYMJ8DGQqrI0tuONda6029dHEZ8qrTFItonDAl9pk6sloUI
         U1OUVaBebcq2krY/XDlaYq4Ys8jBpzK5PF23hrprLK6v1pfkhzJBxXvrsAQ+zPa2WkvB
         L7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VMQ+k7bLAjbj3fMB/xZGcjvf+XpTjPwLDTz2lQgj24=;
        b=sjrXD14FbuQ9CzN1GWCqSEUmmgGY8gP+iythRVRRPq5IGoKla0qW7FILInbIR5vU9w
         ge26B3kfcwP0Gcf0Xysjj9gsXDR6ZAbc8VJbWK2KeU3Z7zrMu8x0gXzYBmVNC0OBmUyx
         ANK4W0Wtx4rOwei06LDd6uqqDtlFvCwqkFV2sDOilFRW4+VWGALVmFMHCBRLpCe0lqUL
         pUEzsPXa0vOaLC3doPggsQai/WiWniiuDTrR4LmrYC9pRoiRlZ1c5fCkMXvQgwuZttW+
         EampxxL5jxkruhX5/8yRzXqMdUPfsz0i71i07GglGKSoV8b48Bcv2+/CLIOZRm2e4E/S
         TpEA==
X-Gm-Message-State: AOAM530R8DI+3w744uqmtamPOT7B4NeIaTn+1WNTCrBRQzAnv8Nrie5R
        YHQZMWiLA9tmOuWKtGoQptLZoqGUk7eMmA==
X-Google-Smtp-Source: ABdhPJwnXtL3erfXWeuG/Artubuceg26QgtBoM3fkS92TKjRnhKgQoXb6Dmo3PIqU14Z6ByqwIzj+w==
X-Received: by 2002:a6b:2c95:: with SMTP id s143mr2802281ios.36.1634223992041;
        Thu, 14 Oct 2021 08:06:32 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m1sm1288166ilc.75.2021.10.14.08.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:06:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix wrong condition to grab uring lock
Date:   Thu, 14 Oct 2021 09:06:28 -0600
Message-Id: <163422398324.1291352.14398198966350285434.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211014140400.50235-1-haoxu@linux.alibaba.com>
References: <20211014140400.50235-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 14 Oct 2021 22:04:00 +0800, Hao Xu wrote:
> Grab uring lock when we are in io-worker rather than in the original
> or system-wq context since we already hold it in these two situation.
> 
> 

Applied, thanks!

[1/1] io_uring: fix wrong condition to grab uring lock
      commit: 14cfbb7a7856f190035f8e53045bdbfa648fae41

Best regards,
-- 
Jens Axboe


