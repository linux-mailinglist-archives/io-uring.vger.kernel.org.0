Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB104E7386
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359000AbiCYMds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355069AbiCYMdr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:33:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2357DD0839
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:32:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k14so6339910pga.0
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=fDcpHlfwaaM4pBI+gLzz4WtCiQPvKnbLB36gAKLKSOg=;
        b=35dyRvgOcBWcRZbbHdUbnE6HpXJEeTZEWaeYTuQWRLx+v2RLyZhgVUPR5cjhxwlJZa
         jLJ2nDze8CQtH5EYFzs9VEu+7hzOFWp+1ca3RgTSNDkjuZ2ChHFFbIiBQzKdOYI8JKTU
         80rjD1/cNC74gxagfFsAYF0EABpRtXcBqZd/WwpjLqD9eFA71QSgn+RoCAsVrtp6LLD/
         XUX3aTIpZ2M6OH4pwDoos/Qw7eiwkBopl4w2LjdHG1rGTIjEIfg4gbD39F1Get5LENDr
         FqAh6bcXTnI8VFFcRcu9g878sZzPR+9+kwkOZQ/kt7DAmRycvAXP4RhZcP3sBknpz2Ft
         yFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=fDcpHlfwaaM4pBI+gLzz4WtCiQPvKnbLB36gAKLKSOg=;
        b=o9KJU/LfhtxAmxtLL9Q+H2YRtHawxk1qDbnXX5FUqbeXOIpygvD3Qkz95nELmPbYdJ
         uLp6OVnyahgsQ7udTozC8Kn5hrWkvZbkr8PVkY9DsQ3T+Xo94jvDKn/4cO51kxRINQA/
         pU7PxyOjwM3pxhJkiK7YYKPlkhPhuq2FSWrEmfiCMGxCAw37UF635ZaQMqwo3dIB5xwG
         OQeY30EJEIT5s03/+FfOMwDzKVVKUz1w94Wp36c8f2gd56W0zft1JnHAan6xzUkLneV/
         ziwN2Fx7f0z47Y5RTOVxeI15ag3odG6VHly0VwnaUc4D6+LRQc+8bYfCyspZg2Nw3PwG
         x9mQ==
X-Gm-Message-State: AOAM530QiJpnRT27zsOeG5KIxL8DW3TZkRCopTtVdGqqCUCTBJ+jgLPa
        vhQx4d9zu+dEOG3W9KPR1lHh2Q==
X-Google-Smtp-Source: ABdhPJyLRQ2mC88NjgQuGJd3IIZkK15+xlk4me7QbSoytWOUZYjSfXh/b7lv9oF7KhPGxtFrhXupNw==
X-Received: by 2002:a63:b553:0:b0:374:87b5:fe64 with SMTP id u19-20020a63b553000000b0037487b5fe64mr7714580pgo.591.1648211532570;
        Fri, 25 Mar 2022 05:32:12 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0024c500b004fae56b2921sm6765069pfv.167.2022.03.25.05.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 05:32:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dylan Yudaken <dylany@fb.com>
Cc:     kernel-team@fb.com
In-Reply-To: <20220325093755.4123343-1-dylany@fb.com>
References: <20220325093755.4123343-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: enable EPOLLEXCLUSIVE for accept poll
Message-Id: <164821153154.5919.10359312288843087112.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 06:32:11 -0600
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

On Fri, 25 Mar 2022 02:37:55 -0700, Dylan Yudaken wrote:
> When polling sockets for accept, use EPOLLEXCLUSIVE. This is helpful
> when multiple accept SQEs are submitted.
> 
> For O_NONBLOCK sockets multiple queued SQEs would previously have all
> completed at once, but most with -EAGAIN as the result. Now only one
> wakes up and completes.
> 
> [...]

Applied, thanks!

[1/1] io_uring: enable EPOLLEXCLUSIVE for accept poll
      commit: 52dd86406dfa322c8d42b3a4328858abdc6f1d85

Best regards,
-- 
Jens Axboe


