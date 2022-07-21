Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7272E57D1F7
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 18:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiGUQuP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiGUQuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 12:50:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E50327B30
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:50:11 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r70so1769003iod.10
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 09:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=gHNrGLYT17BnSY+qR2B0neV9VxPWv4HgMzE4b8nMg9E=;
        b=rjbycU+y/n5TtpdtFUIcRfDy5z31THTvHGNFj7EyJtiAu/zeKV64Yg4uR1iExAS06y
         bQXDF7v2meliE82RN1fvdbusnYVhD3v+NHKajP9DAyNi1Jb+wdih0VdlfTqVkUvu2GrY
         sbvVV+O874FbcMyWP3vsZ51P/3LC/fqBeU0Q7SWBSNY2UZgSUQtlbe6qJFn8AjJ1G/xj
         uqfAUpHM2vXynEmtjzzAinsemR8IZ6rrXC7XXyMi8SfnU0ELl+g3XXRy1QtYS8lg2j2P
         K+8FNh5SBsYLRWPB+l84x8vjFVblGWw+dWQq3yDJAGzWeVhEYwc8S4U9I882zCsJyLVa
         cm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=gHNrGLYT17BnSY+qR2B0neV9VxPWv4HgMzE4b8nMg9E=;
        b=Hos3Y1tsESmgErRB7ptFyiMXatmm1wGZsv7Sp5xWU6czbc3+e9H0cXeNLJ9S+pcMM2
         EFPYaDLFmKwhoclQaExK9hT2tXOWa9aZl4Plc0G6BzEj5GsFrc9adPPn6keJoO9V1vw+
         d4RHSJf7yIZJhiQsP3p8MAujbaKdzusudJM27d5zEiMWzxgZ1flprXckohQ2WagMtJ2H
         qLku8KT86igZyYffvDqTK8RIxMU09OxEjAuqiqWD/0Ad5XalxiCQtD/NuPge+WpCewy0
         h8V+/mkQu126/DDaPXEgucsa8Biw72lI/oPDvZxt3gfMrATG7XGKF9qCQgMaGmKi93yz
         bAOg==
X-Gm-Message-State: AJIora8oa8UoxluS/Grita6kMbhY4jZQ4PgHNWp3JOWgOwqWNZqzPCg2
        8hRPiUV/HXU8d4KzUxc9IvHzJkNK4ICiiA==
X-Google-Smtp-Source: AGRyM1vTsVuR3/btvdDkuhLKupwb6ZI7MFGhIC6et7nE38thFPswq05jDjEx01PK5nSNdgIG0jQe0w==
X-Received: by 2002:a05:6638:3589:b0:33f:88f2:2545 with SMTP id v9-20020a056638358900b0033f88f22545mr21910117jal.229.1658422210558;
        Thu, 21 Jul 2022 09:50:10 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f8-20020a056638112800b0033f4bd1342esm973581jar.104.2022.07.21.09.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:50:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, dylany@fb.com
Cc:     io-uring@vger.kernel.org, Kernel-team@fb.com
In-Reply-To: <20220721160406.1700508-1-dylany@fb.com>
References: <20220721160406.1700508-1-dylany@fb.com>
Subject: Re: [PATCH liburing 0/2] test: fix poll-mshot-update tests
Message-Id: <165842220974.60758.8642607125616587690.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 10:50:09 -0600
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

On Thu, 21 Jul 2022 09:04:04 -0700, Dylan Yudaken wrote:
> This test did not look at the IORING_CQE_F_MORE flag, and so could start failing.
> Update it to do this in patch 1, and then patch 2 runs the test with more/less
> overflows to test these codepaths
> 
> Dylan Yudaken (2):
>   fixup poll-mshot-update
>   test: have poll-mshot-update run with both big and small cqe
> 
> [...]

Applied, thanks!

[1/2] fixup poll-mshot-update
      commit: 6451f3d9c0d06537a87d2adbe88c7f83aa0de787
[2/2] test: have poll-mshot-update run with both big and small cqe
      commit: 3609e11ccce8a9bc1ce36a3191fa8e25dd762932

Best regards,
-- 
Jens Axboe


