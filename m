Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628A4776406
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjHIPhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjHIPh2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:37:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6F43A86
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:36:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bba9539a23so14135185ad.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691595413; x=1692200213;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jGppBv6EfJHUWjhzBQCm1GBwlG0L1b+I1b9Fv5RMCS8=;
        b=h46N/fjVmPJOQEPzd++zAuY5C8Nk9BYPKmXzsYnH2WGosqFlKzVPXgIMT8cNb8EXHp
         rLOD6Ahq0SHf8pEetAJHlxjLxWqDqmIeP91gVzwndYZBcZo9CLzFrJTFhqM59eOhjjtj
         yK7Viq7QNvdQQDtvm/cSSs4ahk+x5Y/kIMRziwvOpCEnSzr/kfWQYmef/GD8KF5j7CU2
         IRNa90xakzPcKCFl75UNS5vkQ1276CqjDSQMu7NPvbGZfBUdDjQDnx85+PdijiEQyq9i
         Ffip/HcuVCh/2jp6EvbUTUs82QqPZPCjXrL5iJHY4zyyaEQeTAX9akAJJ/SP+WVWi8pC
         YJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595413; x=1692200213;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGppBv6EfJHUWjhzBQCm1GBwlG0L1b+I1b9Fv5RMCS8=;
        b=I9CJkrg0AdojKWj8+LaOaQT+3IKLBj6dK8B4gKpQs3CdFtqx+JPiAcqMuG0tYDHjOM
         uyjtmq+ev+5IfqdBmLi39KNCv9D4aIMMNGNZbt5bnAkfPOs0DmwXiCGO1IaUWYChGvIf
         1vWkwamK2ejouLXeFxDp7yn00RvWGpLYL9etN1xBPto8NGBsL9tXIRECzlVDAW0z9Gpf
         Cid+Bo8JdWNC7cXstjBbKeJlprGqYeP8FpHCYxjGcyj0vCZVh/z57mGIk39QHFwtWg4l
         HFLefdIGFcG7D6yy/xzpj4eQXAZcspkB8WWINtMrcGqnOooehw5PedLa88iZKgexvELh
         Oj2w==
X-Gm-Message-State: AOJu0YyRYFdzZdGsB5rb01ZgciuydDKvtO1xkd4NspbKcpWRyvTHmrlv
        w3qWoqk2bSquCV+9spojYJQdqIo8NfXtTk5RAJw=
X-Google-Smtp-Source: AGHT+IGw2rwreMwTSHL9oJOOco/EkAUdFhLAmfHnoOeg4YQJzN9F+WxRVFKZyMUkEWrPAjH8b7tXng==
X-Received: by 2002:a17:902:d2c2:b0:1bb:83ec:832 with SMTP id n2-20020a170902d2c200b001bb83ec0832mr3851167plc.2.1691595413517;
        Wed, 09 Aug 2023 08:36:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902d18100b001b9d7c8f44dsm11403977plb.182.2023.08.09.08.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 08:36:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7c740701d3b475dcad8c92602a551044f72176b4.1691543666.git.asml.silence@gmail.com>
References: <7c740701d3b475dcad8c92602a551044f72176b4.1691543666.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: kill io_uring userspace examples
Message-Id: <169159541244.37442.8152636045491122341.b4-ty@kernel.dk>
Date:   Wed, 09 Aug 2023 09:36:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 09 Aug 2023 13:22:52 +0100, Pavel Begunkov wrote:
> There are tons of io_uring tests and examples in liburing and on the
> Internet. If you're looking for a benchmark, io_uring-bench.c is just an
> acutely outdated version of fio/io_uring. And for basic condensed init
> template for likes of selftests take a peek at io_uring_zerocopy_tx.c.
> 
> Kill tools/io_uring/, it's a burden keeping it here.
> 
> [...]

Applied, thanks!

[1/1] io_uring: kill io_uring userspace examples
      commit: f0939ef2dba5f42fadaebf8168691e95d3e4c7bc

Best regards,
-- 
Jens Axboe



