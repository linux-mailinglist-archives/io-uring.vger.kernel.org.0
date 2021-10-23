Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC44438140
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 03:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJWBXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 21:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhJWBXb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 21:23:31 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EF5C061764
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 18:21:13 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n63so7193605oif.7
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 18:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Gazg2MMiTxWsh2iaFiJREbASY1NrhBnOojAszCFT9D4=;
        b=uT1sMJXbPL82p+0jc5U5m6fjtVWsQzXj29sqk/2lKOqVxAIg2QstClerh2ZI3B7VP7
         dIe8PVi4BwZYdXsSwBzj1lCtMT/Lx3hoN4YlKBEWLXXklpiORnKfzf4KjFCqNWw9qJAx
         VaH8RvRqK7egXkBWznTj3vZx+u9eOKgYAub1eJzFy0EZjCz5Yt1MQVGkeK8UMWdsiTV8
         p+YpZ+rAZYAxIZgnC2VdYciZ2utHYhZ0h9lYltfroXzK4gckYhva5/a4u6l0iExXFUSI
         WMlcIUFc6q9BOHW2YDCRdogSo5CIdDaCaXsuxut0HPs38ZVfH6PEOobIXdgg7Z/n0uR/
         DAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Gazg2MMiTxWsh2iaFiJREbASY1NrhBnOojAszCFT9D4=;
        b=AfHNGlC6jgfem4Wxi73D+hyN5x7uf9hKkDQpTw86Lz3zdSGBEqQuF3akbtxjk5pgDz
         1IbRXzjPizCOd7OFEZGyUj2Wy/YVmLThMcRJAxbE6IWh77qeakw4/tVLU0ij3McWlc2b
         BJb9ffKl6gnfz9b+pkh+vSiyonTnKQZq7XlUu5ymtC5VAC7kDvTpGuqi/kO/LNPQ3qwM
         Yr6Ah412TyeHH+8sDFaEQw+MyWVHoFYnd3haSDp635a5tUwTp4lbkYShap0Op/RshA2e
         OAu6RI+dt0quB+1aPOG+iNDszkfIgn7dJso1EBd/30soItVVYpw+z7PsdWrLQI+2u0gV
         aTXQ==
X-Gm-Message-State: AOAM532yVt0Ivit9FqBNqMUqny81ICEGm49sEG8OWEMQ2u/yFhHMNf5E
        fouoiBHNeq/IC6RC47K37odoqws/eA5z/EWX
X-Google-Smtp-Source: ABdhPJzDjzf+pqKdADzCLebQDKDdwbg8aBE9SmfHXKa9TEpCsId43bSjQcsJJcMvRexwUrofq8Nhdw==
X-Received: by 2002:a05:6808:1898:: with SMTP id bi24mr2299801oib.3.1634952072352;
        Fri, 22 Oct 2021 18:21:12 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:7c50:21f2:ec35:e139:de38:5438])
        by smtp.gmail.com with ESMTPSA id f1sm1764763oos.46.2021.10.22.18.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 18:21:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018133445.103438-1-haoxu@linux.alibaba.com>
References: <20211018133445.103438-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH v3] io_uring: implement async hybrid mode for pollable requests
Message-Id: <163495207088.110422.9180917246816381390.b4-ty@kernel.dk>
Date:   Fri, 22 Oct 2021 19:21:10 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 18 Oct 2021 21:34:45 +0800, Hao Xu wrote:
> The current logic of requests with IOSQE_ASYNC is first queueing it to
> io-worker, then execute it in a synchronous way. For unbound works like
> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
> there waiting for events for a long time. And thus other works wait in
> the list for a long time too.
> Let's introduce a new way for unbound works (currently pollable
> requests), with this a request will first be queued to io-worker, then
> executed in a nonblock try rather than a synchronous way. Failure of
> that leads it to arm poll stuff and then the worker can begin to handle
> other works.
> The detail process of this kind of requests is:
> 
> [...]

Applied, thanks!

[1/1] io_uring: implement async hybrid mode for pollable requests
      commit: 90fa02883f063b971ebfd9f5b2184b38b83b7ee3

Best regards,
-- 
Jens Axboe


