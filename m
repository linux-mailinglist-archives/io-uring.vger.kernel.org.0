Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EBA5047D4
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 15:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiDQNEA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 09:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiDQNEA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 09:04:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC233A27
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:01:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso11942940pjj.2
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=ZyFShyLF+03jY8z+Gly07ogGzhY89pT4I1HxPa/FMMI=;
        b=tB5zsRuNrMsl9KFonFrUgNk22bhpEbSByB7WZxbHHnEL7XV0GWry7GhtQW91ILBpkF
         M4c8jceRzarit6JJHiEJunkxwYNsAfo2qdQoiNhe7qa6qgYEuvECH5mW2AkzEEksugkX
         II1ZCxR/+pdVShe0UpJpzPlBYWsy9gSTINgQE45tTKY46Cjln9Ns6SUGfXvKwgYvtGO/
         WhT8TDQil8dPbaq+pSYAcnlGwO5DFWWGcb23EitMT5lpnd0sLusovUHOrcFtIfRfokwi
         m8o5PgINHFJ2Ibc0eJ5WKaHjPWrjDA1VeLHV93+9E/t7/HlKzs/zkq0DpVzk0SRuC0Gt
         6OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ZyFShyLF+03jY8z+Gly07ogGzhY89pT4I1HxPa/FMMI=;
        b=Zuggpr7ZMvkJT/CwRFIC8DpXJo8eWSqU4oGob1UnF8amJCiXNe5G5p/lzCHTdimcm0
         Z2b9oKgj9ZU4HMOxdzd04R534o46tKO9be8FiozEVCfzJDrnmNTWFGLDNdVkZZJ7mRh/
         MA7saEGvAuTZbSZipobuMN41uIMcDqWaaS6oIWQtjsyoip2SXe7hdiiZ3oUDq2sQKhU8
         afhwDi/V2nV6KlDZZ0kEj9i/S3Yh176jbpHGQcnRItQBwX+/QSreRwhITXJYHtKd2hY8
         G+LiQrtZnRkixYH4dhGwxNBbReK7jz2Ct0cVWWx+A+NyiIOl9kmcfOKubqh4LQM7MgAf
         1yuw==
X-Gm-Message-State: AOAM532JTdCBclMRHWO8yykrMSiRGBZFVl5Tw1GODzYLg39xTmzitmpi
        CDIdiaYK2rTyTECukEXcJCldrQ==
X-Google-Smtp-Source: ABdhPJx38YGqbNnu4J3sv4R9egXN8iSoTlPuMFDmxAZ0MUD3+MSt//4ysqrLLoMFIVFYLwyp3lfG3A==
X-Received: by 2002:a17:90a:b890:b0:1cb:7ef2:8577 with SMTP id o16-20020a17090ab89000b001cb7ef28577mr8173855pjr.45.1650200484069;
        Sun, 17 Apr 2022 06:01:24 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a174800b001d286e16e4esm1475897pjm.3.2022.04.17.06.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 06:01:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <cover.1650186365.git.asml.silence@gmail.com>
References: <cover.1650186365.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH liburing 0/3] extra tests
Message-Id: <165020048299.15363.17270853138064370162.b4-ty@kernel.dk>
Date:   Sun, 17 Apr 2022 07:01:22 -0600
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

On Sun, 17 Apr 2022 10:09:22 +0100, Pavel Begunkov wrote:
> 2 and 3 add extra tests that were useful during the SCM patching and
> rsrc refactoring. 1/3 tames the multicqe_drain's execution time.
> 
> Pavel Begunkov (3):
>   tests: reduce multicqe_drain waiting time
>   tests: extend scm cycle breaking tests
>   tests: add more file registration tests
> 
> [...]

Applied, thanks!

[1/3] tests: reduce multicqe_drain waiting time
      commit: e0aa6fceed8e9a36325ae3d6d83b0dfb73aea2ca
[2/3] tests: extend scm cycle breaking tests
      commit: c1459b2c99f0bb2554d181d9bf55388814add1a5

Best regards,
-- 
Jens Axboe


