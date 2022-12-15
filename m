Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DC164E149
	for <lists+io-uring@lfdr.de>; Thu, 15 Dec 2022 19:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLOStk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Dec 2022 13:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiLOStb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Dec 2022 13:49:31 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320D2409B
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:49:30 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id p24-20020a0568301d5800b0066e6dc09be5so15884oth.8
        for <io-uring@vger.kernel.org>; Thu, 15 Dec 2022 10:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xrKh7psmcPkRK+1oa6796wnAtl9xswN+IYST7Q8GbU=;
        b=4rqNoyFuDiWFlzoGj3JKy3NIAkA4R3PD0uxm3N0YULmqQelAgFKQjUyOk2f3vsrcbL
         cnqCQKdVtXEGE9IeFwujOnDXeZ46cMVMo20OZpo9WnJxhFwPHjHDuNw7wK3m2yXOeCtE
         HCswQxtOn3SyJtf00G6eU+pjIc5UMYbP2xANx6gDV9YTM9h9U5581ifDznmPGEUHNeNX
         0F1W0PkTPyVthxYgaUH3YUUen10/H1tVIj+UKM2o0GY7rxvfbhG1rSxRqmZK3VS2DeOg
         rQ2K5pabewfjbkNCNCDd9xE6hlwQCpcxjzxzhgdW6uy9TNogDdOx/7UebeMFUV0rCSns
         IrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2xrKh7psmcPkRK+1oa6796wnAtl9xswN+IYST7Q8GbU=;
        b=pZDeSUEcYAFOnB2DjF9APEB7fYd0dU8xQ3uPa1NoPKzqPx8RY/8Y9JM/vA9Ik25/DI
         OyrkeiNHS3tMiJ3HSitnWOiRR9Ud1L3sVcmDwyWf7N8WkG0Od7xjpV+GWnX/4BrmnwOJ
         1zel7ymlgd/Ct2Y324wZI6F7LegN078AMT6uCydo/iofaoLR1fe0bhY8GQWpSyT0Yj7u
         J2o2Vpdd3IWSgF7raN0VjApy7AR/qRA/gsZxVxuCrwF5sc47aDDF/gpU9bgoes/KgWcb
         kag6Fdz4gq2zCOOdM0cV0y1I550pxZNVgZhAGD6mq83s77cj9/zGQpZsxdVj+teyB487
         w/jQ==
X-Gm-Message-State: ANoB5pmIu1p5AHNbDOTYHUrylv4MZ+yPpePvPK5rTWZGk+NiAmC55xVm
        aVknY6rGXF9x0CiaOJ8qejdbRQ==
X-Google-Smtp-Source: AA0mqf4oEqBdv2JBCMuk2lCpzJ56f8NEc4zt/d+IVDlpqhGorrrG8KtNIS2+XSpyl9vDhxOsrvVK9w==
X-Received: by 2002:a05:6830:336a:b0:670:77e9:4b98 with SMTP id l42-20020a056830336a00b0067077e94b98mr2990502ott.2.1671130169605;
        Thu, 15 Dec 2022 10:49:29 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v21-20020a9d7d15000000b0066c3bbe927esm3846497otn.21.2022.12.15.10.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:49:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
In-Reply-To: <20221215184138.795576-1-dylany@meta.com>
References: <20221215184138.795576-1-dylany@meta.com>
Subject: Re: [PATCH] io_uring: use call_rcu_hurry if signaling an eventfd
Message-Id: <167113016853.52282.4184815382776784529.b4-ty@kernel.dk>
Date:   Thu, 15 Dec 2022 11:49:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 15 Dec 2022 10:41:38 -0800, Dylan Yudaken wrote:
> io_uring uses call_rcu in the case it needs to signal an eventfd as a
> result of an eventfd signal, since recursing eventfd signals are not
> allowed. This should be calling the new call_rcu_hurry API to not delay
> the signal.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> 
> [...]

Applied, thanks!

[1/1] io_uring: use call_rcu_hurry if signaling an eventfd
      commit: de8f0209fe8064172a86a61537a7b21d6e5334ad

Best regards,
-- 
Jens Axboe


