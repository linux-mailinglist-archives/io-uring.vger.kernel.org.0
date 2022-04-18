Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BBD504A6B
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 03:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiDRB1G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 21:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiDRB1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 21:27:05 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2C0DE5
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 18:24:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso10946949pjj.1
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 18:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=NCTzIs6LJde1Q5R3dvT+G2BUcnqm1CJK+raAY3FAi6w=;
        b=H308yhtOI51HULUZElmhBliWUd3lGk2+HGBcLYGAqSbDkHmx+/Fgqq9bwE/JDuYp5p
         E2Ya+I3Ve3kfyCIAchK0fRhrJWpf9aGmHX69QSK+mwCcyHZnvLjDEWWwVtBdKcay2nb/
         MylnUXt8n1Jl5VFZcSinEyyHzitKj2AjFMx71SI9GfbP2LszIC/Bi0gbnA+AcsExBEJ0
         kKZ2IjAtNdblKlu5hZfwwNhMZyyfLh99DCXssh/5qepd5DzNxHUReY66u82eGCCaRVij
         SWOTe60nrU77PnIcqkEQNm7zmjBUi17WODJL/rsQelsu5bDvffTCogvVWf7rmlQP6h5W
         MGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=NCTzIs6LJde1Q5R3dvT+G2BUcnqm1CJK+raAY3FAi6w=;
        b=mnHq0Og91WuwEE2BxmS0DSFMVfVV4iLE4yfrlnRW0bCg1mvaWco4B0T4KCtaUcGUHB
         VNaV7182cb58oYbKEh1W6Ar+LdMbN0YNPdq4kUbCt1jyFYiPEqmKj0phRQe46OPCWfxl
         f68yNsqvmfpdXN1J3j7UQZ0wSDMPLl17Z5H8zvSGzYuRLBJEFHu+adcLwLya1GGAivj9
         0cmnD2bRx3nSHGa9r3yaAJsN0iIONV79SjUxhb+vWJDpiGYIxgdAbXJdwIzf57YoeWen
         2GFCq5HK2PB/rUwhIrZCA0UnlLMX7lFPqpOVlrvGhsO8/wvHI8V/gc+3/7AfEx3YXWwR
         AgWQ==
X-Gm-Message-State: AOAM533hNO8YN9lB8hUMpinnHUEY3Mo8kWzg+7j7M4kNS+rNYnhWwdam
        foVxyGy3X57almdew7vVp1P4FkHhJHuGZPRc
X-Google-Smtp-Source: ABdhPJxbdHl4pNLeJFRhYRK3y2xjWzDw19f9U0SUGA/JRtsZCXPlwmsCW1ORUxZ7/R+XqEE1aR9ZDA==
X-Received: by 2002:a17:903:2c1:b0:158:f9d0:839c with SMTP id s1-20020a17090302c100b00158f9d0839cmr3238973plk.118.1650245067468;
        Sun, 17 Apr 2022 18:24:27 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c6-20020aa78806000000b00505fd6423b2sm10016643pfo.95.2022.04.17.18.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 18:24:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH 00/14] submission path refactoring
Message-Id: <165024506681.223708.12888548216403655936.b4-ty@kernel.dk>
Date:   Sun, 17 Apr 2022 19:24:26 -0600
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

On Fri, 15 Apr 2022 22:08:19 +0100, Pavel Begunkov wrote:
> Lots of cleanups, most of the patches improve the submission path.
> 
> Pavel Begunkov (14):
>   io_uring: clean poll tw PF_EXITING handling
>   io_uring: add a hepler for putting rsrc nodes
>   io_uring: minor refactoring for some tw handlers
>   io_uring: kill io_put_req_deferred()
>   io_uring: inline io_free_req()
>   io_uring: helper for prep+queuing linked timeouts
>   io_uring: inline io_queue_sqe()
>   io_uring: rename io_queue_async_work()
>   io_uring: refactor io_queue_sqe()
>   io_uring: introduce IO_REQ_LINK_FLAGS
>   io_uring: refactor lazy link fail
>   io_uring: refactor io_submit_sqe()
>   io_uring: inline io_req_complete_fail_submit()
>   io_uring: add data_race annotations
> 
> [...]

Applied, thanks!

[01/14] io_uring: clean poll tw PF_EXITING handling
        commit: c68356048b630cb40f9a50aa7dd25a301bc5da9e
[03/14] io_uring: minor refactoring for some tw handlers
        commit: b03080f869e11b96ca080dac354c0bf6b361a30c
[04/14] io_uring: kill io_put_req_deferred()
        commit: 78bfbdd1a4977df1dded20f9783a6ec174e67ef8
[05/14] io_uring: inline io_free_req()
        commit: aeedb0f3f9938b2084fe8c912782b031a37161fa
[06/14] io_uring: helper for prep+queuing linked timeouts
        commit: 65e46eb620ad7fa187415b25638a7b3fb1bc0be2
[07/14] io_uring: inline io_queue_sqe()
        commit: 4736d36c3adc99d7ab399c406fcd04a8666e9615
[08/14] io_uring: rename io_queue_async_work()
        commit: 6c8d43e0f1375748e788d70cdecdf8ce9721e8fa
[09/14] io_uring: refactor io_queue_sqe()
        commit: ceba3567006f5e932521b93d327d8626a0078be1
[10/14] io_uring: introduce IO_REQ_LINK_FLAGS
        commit: ba0a753a0b63739fc7d53f9cab0f71b22c2afd92
[11/14] io_uring: refactor lazy link fail
        commit: 0e2aeac59ae13b868836072f6840e0993c8991d3
[12/14] io_uring: refactor io_submit_sqe()
        commit: b68c8c0108f53daad9a3ced38653fc586466f4ad
[13/14] io_uring: inline io_req_complete_fail_submit()
        commit: aacdc8a67f52dc96bd9e36f85e7a99705020be3d
[14/14] io_uring: add data_race annotations
        commit: e27fc3fb3d4722e2faa67a9bb340ac42d6bbdbea

Best regards,
-- 
Jens Axboe


