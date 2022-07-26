Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5505813AE
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiGZM6J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiGZM6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:58:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5489526ADF
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:58:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso13150975pjq.1
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=qCvw0POah4GzImKTH/+kyUqe1VQuk74b4knUGMb3jDg=;
        b=D+MOCwPNc1uYXp/2nfO8j23oCeproBSS6O6sv2mDK73Zgd+q7QIGfQ5v0yx/UMXrsX
         KYQdXZ6NJ2047JBs43s2k3YKV+SAqOHtMdOfIbCJlnGPFsSnlgXJIKTeWXsYzDrDpDea
         dr8Pp2GKtj+QmDtd9LjXpxYf3ZEK6YyXOgqft/XMJKPAYvpMutqyvtSo7wl2ebQna3Oe
         G5fLk3ZdJ9d1O5S6L7T2SlbNKanQ9qZKIiW95zPVXp36fMkaSQQh0T31HyLpm7PXQajo
         olWEKJRceQQO8I+LpOqcIYkku97TOh/AXE9Klx/w386KeEeZMe6FzxpQ9vbGp3fwPKKG
         0Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=qCvw0POah4GzImKTH/+kyUqe1VQuk74b4knUGMb3jDg=;
        b=7HMG+O2I+uveDeh6E9cRiciEwCe65ehFaxgYz/OL4rjsKk3911rXWI+kKF2lGKM9lD
         GkYzxeZKX97uGqQMP15jA919NxPzvmrGOnZnAk+A2ZnvBkNRQnvWI3epc+gYZfrfPPJP
         5wIubMtaunxaXqu4Vn6O19Cwxu1xo6LkEWnVP5xGG8bTcBrbYczRNBBmmJn9iJNFloVh
         PGdT5YZYjAM92w17iZx51Vtt51DdapR3UFnYv89mjBguIFZLj2Rg/ITvvkpgu/q+n0Nj
         XOJeV5u8SC7jkuXFbC+KZxfxIQPV7L+o6oerqXdV9LkNSxWW0zC8RAytS0ZEq52lYC3L
         4mKA==
X-Gm-Message-State: AJIora/OKWplSsuHQzhOFuzOhmwk1rXz3Ki/5M2tlm6G6NS+ruI8GJiT
        9iA9p2bTz6iaanOn1uI6HEmOx1ZmA998TQ==
X-Google-Smtp-Source: AGRyM1sg22VOzoCyxLUmuyGxonLRxp3YqPNAA8V1YUsYVssk2kFBHvD7AhLpE5UKl2qdoFfcfgSJAg==
X-Received: by 2002:a17:90b:38c1:b0:1f2:c43b:a46b with SMTP id nn1-20020a17090b38c100b001f2c43ba46bmr8154454pjb.83.1658840283734;
        Tue, 26 Jul 2022 05:58:03 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id cp14-20020a170902e78e00b0016d80313a4esm3827185plb.164.2022.07.26.05.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 05:58:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     alviro.iskandar@gnuweeb.org
Cc:     gwml@vger.gnuweeb.org, ammarfaizi2@gnuweeb.org,
        io-uring@vger.kernel.org
In-Reply-To: <20220726111851.3608291-1-alviro.iskandar@gnuweeb.org>
References: <20220726111851.3608291-1-alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH liburing] arch/syscall: Use __NR_mmap2 existence for preprocessor condition
Message-Id: <165884028283.1502668.6639349221847360074.b4-ty@kernel.dk>
Date:   Tue, 26 Jul 2022 06:58:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Jul 2022 11:18:51 +0000, Alviro Iskandar Setiawan wrote:
> Now __NR_mmap2 is only used for i386. But it is also needed for other
> archs like ARM and RISCV32. Decide to use it based on the __NR_mmap2
> definition as it's not defined on other archs. Currently, this has no
> effect because other archs use the generic mmap definition from libc.
> 
> 

Applied, thanks!

[1/1] arch/syscall: Use __NR_mmap2 existence for preprocessor condition
      commit: 00c8a105ba688a3826304430f8e57835a302609d

Best regards,
-- 
Jens Axboe


