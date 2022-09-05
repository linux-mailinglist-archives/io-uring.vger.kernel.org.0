Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D5D5AD885
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiIERmL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 13:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiIERmK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 13:42:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CC64C607
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 10:42:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso580908pjq.1
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 10:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=OZJt9bKXiECdEj4vCJHWJlzYrm4PjBMHRNBkmycpQm0=;
        b=e2GnhQIvXUzxRI78HUogEjgzuBq+Vzn8wX6E1bQvFMTsVrZwBdNXn33IDV5sfPTM23
         atWH9a62RgpmmX/yvrzLli6x3z2hqkgaRoDdtCGJwScudQcXEFigSPUttAhzFu50LDTg
         BGBUqVdl7MzOg5EXLbXka4yzvDf6iejLC+pzKZHHDu43+7ylSrm/FT00lV8UENCNZm8x
         fERA0pTC7b7n6LihGhWgq4IhR71DI2fhsO404T1R8FCHWLwZUlpqVTzGSikE8heqVFfM
         JHp3Mg4HlnM+ESqyho3mJmYGT49OESgRDjxBc7mOB0TGdLzSCVXAkBILGmIbrSFg1ijQ
         GQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OZJt9bKXiECdEj4vCJHWJlzYrm4PjBMHRNBkmycpQm0=;
        b=3rpcAJB1SV0gmmzZa1YckFhsTh+0SaHrvvkIHO7QiiKirWqzZDUXP+tZSKo6Ry1h0M
         DT0lPPe0+s8sCjEJhKaEyFBGbCds4yFvqpoSiP/zqB8bvN+mjg0haLWEqR2DkXkbfcGK
         U9Hghk88h8u5v7X6ajw/ZFaIjmahKuRPpHodvF0wSQob5Wz8nFaYAi0iFrkv3zdKjx9k
         jhzOzuso35B3psHfK14D42Kesw7h0jNXrcQFUI/LF7EtLlS2L1fycK0dkG60nfNjNf08
         qsyrRICf5OrTkMLbY17+Ifa72ovgUKi5P3zaCb6qgv/78KEOiMfZxTbWFTOTG0cyuvJK
         JlwA==
X-Gm-Message-State: ACgBeo1qG3YNeKO1LTbxMVVKxQ0giA7ofmWuvrdmB5lCB0+RuvV0bXD9
        PyOijhgbzajMAWGuq9zb6ka3qca9Qo2tJQ==
X-Google-Smtp-Source: AA6agR4NlGjeLCBYHqQhh91mkrQxNTpvlB4hv2QEpZOAqytKqVLpv2ZatWq3LWTLaFy1ko3sCToO8Q==
X-Received: by 2002:a17:90b:4a86:b0:200:b21:e357 with SMTP id lp6-20020a17090b4a8600b002000b21e357mr14664270pjb.13.1662399725991;
        Mon, 05 Sep 2022 10:42:05 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a16cf00b002005fcd2cb4sm2361586pje.2.2022.09.05.10.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:42:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Kernel-team@fb.com
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
Subject: Re: [PATCH liburing v3 00/11] Defer taskrun changes
Message-Id: <166239972526.372447.7435917288581693562.b4-ty@kernel.dk>
Date:   Mon, 05 Sep 2022 11:42:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 5 Sep 2022 06:22:47 -0700, Dylan Yudaken wrote:
> This series adds support to liburing for the IORING_SETUP_DEFER_TASKRUN flag.
> 
> This flag needs a couple of new API calls to force a call to get events for
> users that are polling the io_uring fd (or a registered eventfd).
> 
> The second half of the series is a bit mixed and includes some documentation
> fixes, overflow cleanups and test cleanups. I sent these a couple of months
> ago and forgot about it, but now it does depend on the new API so it needs to
> be ordered.
> I can send it separately if you like.
> 
> [...]

Applied, thanks!

[01/11] Copy defer task run definition from kernel
        commit: 1999c963b86b0378b44edb2820e9d5102b7b531a
[02/11] Add documentation for IORING_SETUP_DEFER_TASKRUN flag
        commit: f8bac73b2529d33a10002905351c08f9cc457fd7
[03/11] add io_uring_submit_and_get_events and io_uring_get_events
        commit: daa5b2dff32f0ba3383d66b48badf122bd6d2898
[04/11] add a t_probe_defer_taskrun helper function for tests
        commit: cc2e1bce106f2356c3a3ddd528b56980b8ea8a77
[05/11] update existing tests for defer taskrun
        commit: f91105d5495546403ec5c15aa0768ae6a93d5ab1
[06/11] add a defer-taskrun test
        commit: bfca8f112cf1bd9cf8781cdcaa8f0f52bc727506
[07/11] update io_uring_enter.2 docs for IORING_FEAT_NODROP
        commit: f84b884aa865435ca2e691dad72d6c89529eb60b
[08/11] add docs for overflow lost errors
        commit: d5be8c01ee0d80f20da17fbc8b241d44157c06b6
[09/11] expose CQ ring overflow state
        commit: 3f2835810413beee65dad84a69b1c6280fb79eb8
[10/11] overflow: add tests
        commit: c9663ac060552aa4dc3f1b5af0fb5319a2a9b24e
[11/11] file-verify test: log if short read
        commit: 8bcc9029e3f7292bd17ed67d48c1122f1d56e36b

Best regards,
-- 
Jens Axboe


