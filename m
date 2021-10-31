Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACB444113A
	for <lists+io-uring@lfdr.de>; Sun, 31 Oct 2021 23:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhJaWcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Oct 2021 18:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhJaWcy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Oct 2021 18:32:54 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0B9C061714
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 15:30:22 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e144so19446744iof.3
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 15:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=/Dmx6emnmCMcMQTPRUk//X4hsMZZHU+latDa1ZS7xpo=;
        b=U1eA5aTsFdagrc+YDxqaB37ksm8eFr0MUd0jV7ncStgQQTrbGZtwU+/ONDVWYJaPjI
         HzSFCCf4yxCZq3VUp9XTsBAKz2xfz6abUDl+j3FAc+b2l9Ur6GtXOrKrbWu5Z+PKkSXs
         KHNwFs0wR2FeeP4+RWSGNNJCSr3RYhycAroBEPQ8DVquoFsCDlYy08QwJtP6kWQXXh55
         W1mJEdniYL0VEH2+vKpb+i241276sJWlCLR4JvOH18tSOIdWtXSXmulCB7XjABVPFryr
         aIrAQx6w7kPWu1iFMg8PHfX2Fc1VELtJ8HfOi/MUU47ANmsIl+CU+nyrbsDwkSCwNmcU
         4yPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/Dmx6emnmCMcMQTPRUk//X4hsMZZHU+latDa1ZS7xpo=;
        b=UYc4/NIE+h+dGuV0LhPdEKcuTPLkJxEDnPUAJS5yPLZJYcpAy24vI5/Ysxx9KP66Ah
         f7iHLiqTEZaujUd7zWcIIUDwrqn41D/Cu5MOAFi991zIx2lnIPRDsHaXXeb/ZQRIKbkW
         PyqZD85jdP9ZHd3mQrWQihTjtFrEXz6DMPu1vGTIlWCbnxGCrjVI9f1YzA2QqJfm1Som
         eKUpfefmhhaHDZ9eppgFakXYgBulKhIngz0C+gmDT8o8ars3BfWQ0tkAkg4z9Jo9Ga3y
         RUEClkw6/qYCvAIrpl4hqCguh67R5msyHkoDAp0kGiHQt3Bk/95Iggc0DLLkrgqjfSwq
         hG/A==
X-Gm-Message-State: AOAM530LT1OURj2jK+cMpiWMiYrlcqDK3HhEaVzwtYEh4CjV98cxJqSZ
        nZUk2iN0V+yqtQTrnLsYuz+qRA==
X-Google-Smtp-Source: ABdhPJzc82LYhHduV5YK+si1+WwhDOapx3D5vqbOAzAkZ72LDJIn2PIS9VMMgVz+TuYEmln6+nkCmQ==
X-Received: by 2002:a05:6638:2385:: with SMTP id q5mr18990904jat.42.1635719421615;
        Sun, 31 Oct 2021 15:30:21 -0700 (PDT)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m5sm6676807ild.45.2021.10.31.15.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 15:30:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20211030114858.320116-1-ammar.faizi@intel.com>
References: <20211030114858.320116-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing 0/2] Fixes for Makefile
Message-Id: <163571942062.98331.6952339658386200986.b4-ty@kernel.dk>
Date:   Sun, 31 Oct 2021 16:30:20 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 30 Oct 2021 22:55:52 +0700, Ammar Faizi wrote:
> 2 patches for liburing, both fix the Makefile.
> 
> Ammar Faizi (2):
>   examples/Makefile: Fix build script bug
>   test/Makefile: Refactor the Makefile
> 
> examples/Makefile |  21 ++--
>  test/Makefile     | 263 +++++++++++++++-------------------------------
>  2 files changed, 98 insertions(+), 186 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] examples/Makefile: Fix missing clean up
      commit: d543ff1a23d0a9ad7a2628f60194896f9033f27e
[2/2] test/Makefile: Refactor the Makefile
      commit: bceaacc35f9e75469f6179d63436d67dc5bd47d0

Best regards,
-- 
Jens Axboe


