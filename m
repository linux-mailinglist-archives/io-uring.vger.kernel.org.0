Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9D67894A
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 22:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjAWVOi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 16:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjAWVOh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 16:14:37 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19D037B6D
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 13:14:36 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z3so9866521pfb.2
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 13:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFsPMdf1j0w0lMQpjXuyYPW0WCh4YJyAPJR3+vhnwY0=;
        b=x9n57NPPl0gdc+plfvPkjJbCb7autZmSYbe6s1csq6KwYwcOGmqGAdOEYiBsqj7Lej
         bK4OELBNKfmntb9JKWQSWNpvQbL6hF7HO/K8XB+O0klcvXd4dOP1jHkm3lwWBfptgF6z
         g01A+MCzayvkmw8GeU8PsEK0mEVF26FstFfQbNXNF6klOOY5qEnWajCpBhQt1QRqozuP
         IMp0hN7VWpqHse/ZtTiyNV1mQ5SS7Rb0wk1xxrwkzqbF4ruxVERZ3Zf1g7yWeyapr99M
         CVqnytDSO9xhxIjznVomLzkir5R3QmQ+CrW2DhWNBMHOl9yvPat2F3xH7eN8HmZ6/ytc
         EJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFsPMdf1j0w0lMQpjXuyYPW0WCh4YJyAPJR3+vhnwY0=;
        b=iA3/Q3ApM36VLhjhX3ZtymyLvCTK7ok/C3KpZVXIbGxTMyRCN0EFmZcIvZRgXfm4Ds
         D7hFeGralqp5W4N6HKv+waA45kaLcv1tGNOUOLxTqZkwN53mIth5ZHnklH7ujktJ25A7
         AylMo0NqSAFTwkNkkRCWij34PYnx9P555zoD8ol/6zO51pJ3+OToPx3PiSypuruVMVb5
         xT5c1+FqM6qc8uSalPSxAuf82UkAj+aQsEp1yKW/4sk+0I85fBDQ6sYtLsRmTYUHmYWm
         KUkZXo1nemdiECQxlVwKIK/F1yfiA7HhwDoebZxzny/+C2fEK7tZ/fE1j3qrcTUX1U/v
         3CMA==
X-Gm-Message-State: AFqh2kovsJKPy87kl8wcWmgMHUhBNv/8ndafXW0rDwRD91NkXJaVf3lO
        88flH1+K+UjSdlPVemP+agOy/wySz3zyPenf
X-Google-Smtp-Source: AMrXdXsKW8mHCCbaHzfFkx4459KbV/+jQXyIt6jV/5L7uu4LTOE7K8LhSZqLDInLvwPbo66rPgSjkg==
X-Received: by 2002:aa7:8c51:0:b0:582:d97d:debc with SMTP id e17-20020aa78c51000000b00582d97ddebcmr6601459pfd.3.1674508476242;
        Mon, 23 Jan 2023 13:14:36 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a35-20020a056a001d2300b0058d926cef4csm54295pfx.7.2023.01.23.13.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 13:14:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] normal tw optimisation + refactoring
Message-Id: <167450847551.188955.4920595346700558648.b4-ty@kernel.dk>
Date:   Mon, 23 Jan 2023 14:14:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 23 Jan 2023 14:37:12 +0000, Pavel Begunkov wrote:
> 1-5 are random refactoring patches
> 6 is a prep patch, which also helps to inline handle_tw_list
> 7 returns a link tw run optimisation for normal tw
> 
> Pavel Begunkov (7):
>   io_uring: use user visible tail in io_uring_poll()
>   io_uring: kill outdated comment about overflow flush
>   io_uring: improve io_get_sqe
>   io_uring: refactor req allocation
>   io_uring: refactor io_put_task helpers
>   io_uring: refactor tctx_task_work
>   io_uring: return normal tw run linking optimisation
> 
> [...]

Applied, thanks!

[1/7] io_uring: use user visible tail in io_uring_poll()
      commit: 10d6d8338e7b984897ceb905f4b63576aac5b721
[2/7] io_uring: kill outdated comment about overflow flush
      commit: 89126f155a5d13c178a3e5d97c6a805626f10406
[3/7] io_uring: improve io_get_sqe
      commit: d5a6846a1c5fc7b864b63e90d136a3af6034e37c
[4/7] io_uring: refactor req allocation
      commit: 3b70c8766b2a668664e64ee5921a4e300353d451
[5/7] io_uring: refactor io_put_task helpers
      commit: dfb27668173462154929f5b8da80cc4b1ba94672
[6/7] io_uring: refactor tctx_task_work
      commit: b5b57128d0cd58a487c6ffd04ed526f569232c03
[7/7] io_uring: return normal tw run linking optimisation
      commit: 73b62ca46fe7e10334f601643c2ccd4fca4a4874

Best regards,
-- 
Jens Axboe



