Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87A14E36F1
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 03:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiCVCyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 22:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiCVCyY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 22:54:24 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3120D5AA63
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 19:52:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i184so849231pgc.1
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 19:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=yIRZ7GvOnJVLPwy0S5xtV6IPzSZKyTV0r6eqJQ/AFow=;
        b=un90pA42ZbdxW9pxrVh0lihTk5gFjWGqMC2aazEyBhcqIuNrh0cT7xjaZHGMBZBYMt
         G1qF5o6xoviMUAA0xoF7WPTz4golB8akU4ZFGJ5UMtsP+NhywTR6kfAzfuqIQUnC6Kle
         BK1B3173aAgx4k1xjz6HIeqIJx1X4IKvJk4Ukm3D+xlTw6H9FKFtG4IS3P/gkkiM1HOh
         btOCtKk0YwJlStK9m6s9iDla5VNi/9iPtgWVABHsvHNlVJ7D66NmkQjzddSnP06EJwGl
         lFF6SmQZ3dlmaDtHUnPSmetinBJV+kJIHR+cNooV3os59UPEwZ/rANERxTSFeUblA5/j
         fj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=yIRZ7GvOnJVLPwy0S5xtV6IPzSZKyTV0r6eqJQ/AFow=;
        b=J6bDrl3IVhGXmqDa0VqXo8Pugzf4KNSgpp+zY4wXw12khrXfwceXuRuyKfegV5Z1ny
         50EIbMkQQ/8SkPcSA+wWVfGhQLmn9l07TGUAsVJwb4+/CGVGFpFsQqZMhzY4lN45l3P5
         kVx90SZ+O7fnqk0URB9TImCoRUkZOfB49FnmFqthqdwpaTWyJ2jTyXMjK5lJ3motpUvw
         hLQTLK6/jtguYKBAvVrpflqHsxVfHPxnkTbRBF4jOHryOfgfgBCGgRAAggTLY54LRsUK
         ZoMevpgRWWa5dBhx1V1Wpnvsg6/Ul3/CL2Zj6l5cBWMXkZAlYmJ7m4mHXkkEoNYWuIM8
         zIbQ==
X-Gm-Message-State: AOAM531M7yVh0oo9dnboZ2/yfLw6cJ9WFWoxhJvm9L2y0+pZ8qF5DUx/
        2Z3vLpSQrF41g4FOI5az3YdWYeFpPtUgHObL
X-Google-Smtp-Source: ABdhPJzPnieErnmyg7yq3f1HRzHEMGqS1qcIfNEDTdsnPPb0xriI2jnxyw3G9ZumTw7BQa4uwiRl6w==
X-Received: by 2002:a63:1c7:0:b0:37c:4e86:25e9 with SMTP id 190-20020a6301c7000000b0037c4e8625e9mr20171504pgb.550.1647917577451;
        Mon, 21 Mar 2022 19:52:57 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm6146005pfh.23.2022.03.21.19.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:52:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/6] completion path optimisations
Message-Id: <164791757663.261330.6587536015396703190.b4-ty@kernel.dk>
Date:   Mon, 21 Mar 2022 20:52:56 -0600
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

On Mon, 21 Mar 2022 22:02:18 +0000, Pavel Begunkov wrote:
> Small optimisations and clean ups. 5/6 in particular removes some overhead
> from io_free_batch_list(), which is hot enough to care about it.
> 
> Pavel Begunkov (6):
>   io_uring: small optimisation of tctx_task_work
>   io_uring: remove extra ifs around io_commit_cqring
>   io_uring: refactor io_req_find_next
>   io_uring: optimise io_free_batch_list
>   io_uring: move poll recycling later in compl flushing
>   io_uring: clean up io_queue_next()
> 
> [...]

Applied, thanks!

[1/6] io_uring: small optimisation of tctx_task_work
      commit: 15071bf78bd3ee0253a3b57c2e092980dbd91a87
[2/6] io_uring: remove extra ifs around io_commit_cqring
      commit: c9be622494c012d56c71e00cb90be841820c3e34
[3/6] io_uring: refactor io_req_find_next
      commit: 096b50e6c27e3e983871a585116f2ae49a394196
[4/6] io_uring: optimise io_free_batch_list
      commit: 0eab1c46d7db864c6cb4405a4d9e6e75d541c97c
[5/6] io_uring: move poll recycling later in compl flushing
      commit: 2b095f5b2dfc49b79fdd68b03eec02ba278c7ea1
[6/6] io_uring: clean up io_queue_next()
      commit: b0b2d42c8384eb6068e751c4943452a756f433f1

Best regards,
-- 
Jens Axboe


