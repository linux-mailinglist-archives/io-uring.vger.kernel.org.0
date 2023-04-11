Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111EB6DE780
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 00:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDKWsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 18:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDKWso (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 18:48:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F80210C;
        Tue, 11 Apr 2023 15:48:43 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l18so9008327wrb.9;
        Tue, 11 Apr 2023 15:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681253321; x=1683845321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J8z4ld9M7fftUfGlVauhoYGNSHVLLFw30U9QnPZZQ0Q=;
        b=WBSt0uIWmzOcToKeWQxxdMApFSn0OOldxgDCfvBJZx439ZuHjAjl7STB4wvunzSCfJ
         G6RUXJWdWqBr0oFqcYNS7oE/cjx9KIqAbF9IKvqjv+hXQPE+fKxKCs3pVWTz377VIBmT
         ZZnz42ge0iJN9NPXjE459lPWPobVpXzc1vRFn9XqVfxtgRWzWpJpckw1C/1Uqk8dr3jr
         RLeIr8jCRByAjdlESGggC3jQJzwUA3o3BYEHDjBcQcaZh8ywo7FyyMdEGQNlpO+uUeuw
         ZhefFtWIqAStgA4PHeGrUztkjvUmscroMon9eulPSIn4lImiTpYJaddZsRHdZbwWZIX4
         K/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681253321; x=1683845321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8z4ld9M7fftUfGlVauhoYGNSHVLLFw30U9QnPZZQ0Q=;
        b=DXjqnXzQ/k/rz2JNfFeRkx+hFjr4fdSLdFhCKF3b3WG6xUg/ENLtX2uRITuYJfVFIT
         GuohFcmftZbMOa6cRhnt9DsgVCAhRghj8sLda/Dr0WHR+QRDEJl/Uw3Ks/8TEuYvPGpK
         N/HdcCLk1oZD1IE5FP3OUq5bQVHwSUlYoiEMdB0lXo7bxlEEiMroahmg7tfUaKXTB57N
         KP/lFv3oshcXr86FP9WWJdSccd29i3brG+2LshWUtYwrq+RnOHjljHwI768uml0Ys0Ha
         BDNFgdZLclrU+uk9cTeweyBmUx6y6f0Twh/tfaorq5E6G5yHyQCs27uOVWcHJReacUwN
         xGXw==
X-Gm-Message-State: AAQBX9fBQpBgOPh2DeEgavFBgO3a8ezC42UORTM79Hyiokp16bjUWsJx
        KOaAlZA4rcR3OF0IfkN4b/+34UCOmx7lReHoEVw=
X-Google-Smtp-Source: AKy350bm9/hkzTmDMITQuK1I1lLskq3ilk2A747iayl3f0ls6saSW3UKC/7hJzvOXLGaj1dw8xncoyujhc8923PdMRY=
X-Received: by 2002:a5d:6803:0:b0:2ef:bb9f:f5bc with SMTP id
 w3-20020a5d6803000000b002efbb9ff5bcmr960994wru.14.1681253321374; Tue, 11 Apr
 2023 15:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com> <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
In-Reply-To: <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 12 Apr 2023 04:18:16 +0530
Message-ID: <CA+1E3rLLu2ZzBHp30gwXBWzkCvOA4KD7PS70mLuGE8tYFpNEmA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > 4. Direct NVMe queues - will there be interest in having io_uring
> > managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
> > io_uring SQE to NVMe SQE without having to go through intermediate
> > constructs (i.e., bio/request). Hopefully,that can further amp up the
> > efficiency of IO.
>
> This is interesting, and I've pondered something like that before too. I
> think it's worth investigating and hacking up a prototype. I recently
> had one user of IOPOLL assume that setting up a ring with IOPOLL would
> automatically create a polled queue on the driver side and that is what
> would be used for IO. And while that's not how it currently works, it
> definitely does make sense and we could make some things faster like
> that. It would also potentially easier enable cancelation referenced in
> #1 above, if it's restricted to the queue(s) that the ring "owns".

So I am looking at prototyping it, exclusively for the polled-io case.
And for that, is there already a way to ensure that there are no
concurrent submissions to this ring (set with IORING_SETUP_IOPOLL
flag)?
That will be the case generally (and submissions happen under
uring_lock mutex), but submission may still get punted to io-wq
worker(s) which do not take that mutex.
So the original task and worker may get into doing concurrent submissions.

The flag IORING_SETUP_SINGLE_ISSUER - is not for this case, or is it?
