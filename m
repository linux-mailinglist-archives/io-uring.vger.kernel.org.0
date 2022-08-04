Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04955589D90
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiHDOgU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiHDOgU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:36:20 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE032461
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:36:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y141so19519206pfb.7
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=q+k2/oQCg1jExDf3V4wAMLxe+YHu3Cav2Cj1hEhSNaI=;
        b=hE/oiEFnClv6y9rBHS2KMK6uuYGV0bVD21qZwtxdqZZmyh8k38w/J6Qot3ihBwHCsr
         +9bjT8zHi1y2HAOFKWIAT0cE2At/qgXJNxJMte7A2oqMd7MD9csFv3Hi4a75c5HMJ2iA
         GtwMS+oGPYOklrpW7S0botKdD3HBD3wXtRpXfjlQYKeW+mGGBCAJjfGk0Jfbgih5+NLr
         pD+VnyUgWZ2lTvRKRodcgEjHjACT105SBfJGerMo6oqdwY6tfVz7XNgUK6YEX5wtZ1vk
         vCcHZ9gczAibbdkDA+LGnxCrdEt+13gYZhYXchttcZhGXn+L38dkEeV0oZvFKdNWgy4H
         n+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=q+k2/oQCg1jExDf3V4wAMLxe+YHu3Cav2Cj1hEhSNaI=;
        b=EG+J/794Pcu/Q9WG1L9gCqaojvzF0sclbHLcnv9kzm/t0xZCBrkw8EoDlgFxuXIROc
         SiRvjLQGJDQmSrOVtNTbA1kCEE18KvCFdxucJl1mnvsyhtkY99dQm71Euv4RPtCmfDXq
         9hwkHOsq4pcSnVErbE7Ee6JlSl/Y7yKC2olWC2tIiEPU6/Gxbjmctg428PJGr4wbl8CK
         hi3ANBn7ATq/Ah136K/sPFMhAB4KcxypE8uLvnCg/eRiV9WLQhjm8iAbKkamj8C4wIfy
         ykM+FprEtp7Zf1e2jqiPRTn0KweHNtWYgnRGnCA4b47Hx39xEcIXbgs0WU+bwFNNQdN6
         3J4g==
X-Gm-Message-State: ACgBeo3X6jPpfrK0RuC7D+H0RVMhIzH5zWvD9DMy+2J5AG+W7/LlLjqW
        CAgPE9e0sPTbnFNk87FoVElIag==
X-Google-Smtp-Source: AA6agR7McvvMMvvmO1Lg8S2YS4nUVsullv7y6a/2XZIXBqXo7EJcpWXdQpN/AKwj5X+DJQwZRxS8eg==
X-Received: by 2002:a63:82c2:0:b0:41b:c0f3:39b3 with SMTP id w185-20020a6382c2000000b0041bc0f339b3mr1878157pgd.86.1659623778954;
        Thu, 04 Aug 2022 07:36:18 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b0016d2db82962sm1084731plc.16.2022.08.04.07.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:36:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     paul@paul-moore.com, yepeilin.cs@gmail.com, eparis@redhat.com,
        asml.silence@gmail.com
Cc:     linux-audit@redhat.com, peilin.ye@bytedance.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220803222343.31673-1-yepeilin.cs@gmail.com>
References: <20220803050230.30152-1-yepeilin.cs@gmail.com> <20220803222343.31673-1-yepeilin.cs@gmail.com>
Subject: Re: [PATCH v2] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()
Message-Id: <165962377794.930556.772272743019429536.b4-ty@kernel.dk>
Date:   Thu, 04 Aug 2022 08:36:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 3 Aug 2022 15:23:43 -0700, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently @audit_context is allocated twice for io_uring workers:
> 
>   1. copy_process() calls audit_alloc();
>   2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
>      is effectively audit_alloc()) and overwrites @audit_context,
>      causing:
> 
> [...]

Applied, thanks!

[1/1] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()
      commit: f482aa98652795846cc55da98ebe331eb74f3d0b

Best regards,
-- 
Jens Axboe


