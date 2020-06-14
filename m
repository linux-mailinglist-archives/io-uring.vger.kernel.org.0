Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1591F898A
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2020 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFNPg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 11:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFNPgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 11:36:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5BDC05BD43
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:36:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n9so5764224plk.1
        for <io-uring@vger.kernel.org>; Sun, 14 Jun 2020 08:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xLLYrH1sH9lxEwpWO/VtB7Pc9KU9LV+2bLrJXEhhnV8=;
        b=PFh9UPCB5E433IIU9ZZ6fiKbUD1ZOQjKDx8BQB1DVX12Wkl4YQi87jX5doku+YAG0E
         umqangOC6h/hIQYBY8eyzpQZMsNlnX6dzVQ+Zkq4ZH8Nxa3f6/daabeD61UExKFMvwIQ
         2prg/vVFqNBZdveHPWZxhvdpXJEBl01TAHuxzcfZvG9i2CDEuN1CVdK/bFvJ0A7RKfaU
         gxMYN6uBvPa2p7A4jDsFZAK+mMySt9lMaxJT8xdKYITxJlIu/5JTnly+PntKa8OGx3fs
         LUaMMUh8UTEtpuBbMsOfKqWlkH6iaqkPrmCGoxZHzls56BoFgd4Ts2yFRLM6BfrloF3M
         0Shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xLLYrH1sH9lxEwpWO/VtB7Pc9KU9LV+2bLrJXEhhnV8=;
        b=G2JQ662xcAJGHYI6NIxn49ub484U2egDfbqwF7z+aEI/jXSlk5zV7sZTFkZ2WFWkib
         EGQGOHZlp8suxW3WIF6y5UZ8aKsiL2+KmMBiAsi5RSQVsbc/pVlRFj+sXWbcjOQ8Aj0R
         rgRtRJk5vQe/XFa5v6WCHT/IENknWoidh3IFUf7dUvoTalmHYBK+byP/I11w8bmQpkQZ
         VYh1wnZRuL+zntCxxCsuU/c207nzwJHqh+tzLIfm7goqjK6PB/MN5s7bOWc0vRmhZGIX
         0mzF91w471v9SPqTlesgbBosCBxz1sXVWEc3rI7HBfFv7eH6gitYKYM8RNEarwHuO5Cv
         Qw6A==
X-Gm-Message-State: AOAM533VnIWnN5hgP11DV9p1AsNrnwURGll6ImmHirtETEv3HjjKExoS
        +6mcm22en2uXm6YRbr9LT1VGQGm2jmH+wQ==
X-Google-Smtp-Source: ABdhPJy6522hefOgyXHaVFPZuA5oSPZNh7UwYnwdmGIBiz8EywAV/gHehHui4w8Y0HnF1IyLozVpRQ==
X-Received: by 2002:a17:90b:4c4b:: with SMTP id np11mr8069411pjb.58.1592149015281;
        Sun, 14 Jun 2020 08:36:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z85sm11621010pfc.66.2020.06.14.08.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 08:36:54 -0700 (PDT)
Subject: Re: Does need memory barrier to synchronize req->result with
 req->iopoll_completed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>
References: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
Date:   Sun, 14 Jun 2020 09:36:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/20 8:10 AM, Xiaoguang Wang wrote:
> hi,
> 
> I have taken some further thoughts about previous IPOLL race fix patch,
> if io_complete_rw_iopoll() is called in interrupt context, "req->result = res"
> and "WRITE_ONCE(req->iopoll_completed, 1);" are independent store operations.
> So in io_do_iopoll(), if iopoll_completed is ture, can we make sure that
> req->result has already been perceived by the cpu executing io_do_iopoll()?

Good point, I think if we do something like the below, we should be
totally safe against an IRQ completion. Since we batch the completions,
we can get by with just a single smp_rmb() on the completion side.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d830ddb..74c2a4709b63 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1736,6 +1736,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct req_batch rb;
 	struct io_kiocb *req;
 
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
+
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
@@ -1976,6 +1979,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (res != req->result)
 		req_set_fail_links(req);
 	req->result = res;
+	/* order with io_poll_complete() checking ->result */
+	smp_wmb();
 	if (res != -EAGAIN)
 		WRITE_ONCE(req->iopoll_completed, 1);
 }

-- 
Jens Axboe

