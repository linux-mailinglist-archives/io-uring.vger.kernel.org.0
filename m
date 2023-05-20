Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E745170A474
	for <lists+io-uring@lfdr.de>; Sat, 20 May 2023 03:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjETB52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 21:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjETB51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 21:57:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD48F128
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 18:57:26 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d132c6014so655337b3a.0
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 18:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684547846; x=1687139846;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyRqEzv7fzTySxs5AZ4jzXnSv36taWja29wajwP6wes=;
        b=FE9r61Owjx/13VLQrugLyJJaZujC5jAU75t3/yHxyQ/GyS0dIFKNvk4doPloRF5/83
         vDxuqnEjWuweehaqkhnFWAZktGxg5R1vZxmBQTkGxgJiKiwCVlpKKap/Umg2SqwI2ykL
         ydoOXE2d+E8bM5da3c3dWo6KDm9jEJeIqK31ZjHUWlBagEtegwZ49C2DV9FfdlX4hL23
         ga8bguGuH3Y5eLQDG8GSVLOgbkNnwJmwO7Jt69dyfYsjV6lzUwlaJKzMSDjL04YvDUUQ
         JvXewK0PFbJfsTM1AZQ+Iypv30E6ArJ2752ATkS8LQLE0oqZZuisg8DRW1odetO+fFtu
         Pi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684547846; x=1687139846;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyRqEzv7fzTySxs5AZ4jzXnSv36taWja29wajwP6wes=;
        b=HRchoyLg7GTI0nTjX3WJ64kGbPwJ/c2UaUIgtjTiWGjQy5JTdFAIhtqdnAhq4zny3H
         fRKhtWybSvKfTjS7JeHKMg3gczUp1SaGR4HRpH32GJzJUZe3h9/6sYu4zWhS4amX3PuN
         tb4N430dvRfG/+OGl7Snl9G4MqwZP9v7SnYS924og2YJddx691GHy1GLfHTQWgxjBehI
         IAR+2HXvevCIofdq4x6/D8pJPPo19L179Vzfoc0X+2CW8eqYa2JTwH7LnYszIyJgNAc2
         pAO0OH/Ln26W0W3oY+zk+0a7sqndOVs4lWenXgg2I/Qkov2cwsfl9sLFoE4oABdT1GnN
         OtsQ==
X-Gm-Message-State: AC+VfDx0ta5KLd+Bu32btrWNErHViTC+cWI+4YzYcm0w5SoC/4JYrppW
        uDVuG2J9QMaNHmzr8e523aRIDkbkObchOqQkLkw=
X-Google-Smtp-Source: ACHHUZ5kp89lqutVKgb1fWzfYCh0hHaYQa6+m5ijqV0a9cUNXM3fUSHsgr2aO0zxPEwXevgg20F0Bw==
X-Received: by 2002:a05:6a00:348d:b0:643:6b4c:2f74 with SMTP id cp13-20020a056a00348d00b006436b4c2f74mr3973186pfb.3.1684547846111;
        Fri, 19 May 2023 18:57:26 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t30-20020a63225e000000b0051afa49e07asm348421pgm.50.2023.05.19.18.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 18:57:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     yang lan <lanyang0908@gmail.com>
In-Reply-To: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
Message-Id: <168454784506.383343.5044474028086679581.b4-ty@kernel.dk>
Date:   Fri, 19 May 2023 19:57:25 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 19 May 2023 15:05:14 +0100, Pavel Begunkov wrote:
> It's ok for io_uring request allocation to fail, however there are
> reports that it starts killing tasks instead of just returning back
> to the userspace. Add __GFP_NORETRY, so it doesn't trigger OOM killer.
> 
> 

Applied, thanks!

[1/1] io_uring: more graceful request alloc OOM
      (no commit info)

Best regards,
-- 
Jens Axboe



