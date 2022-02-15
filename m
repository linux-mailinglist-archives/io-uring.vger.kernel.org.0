Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E64B79B9
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 22:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiBOVn0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 16:43:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiBOVnZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 16:43:25 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49388B3E4C
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 13:43:15 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 24so73692ioe.7
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 13:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=UBfIa9QaOEP9iMmtgy5U6FtxHzePl0Ulhu75DIbx6tw=;
        b=8K1kul5A1ckyjPzUM7iV3OeWfS7btbZDnv2g7rzPeUkyPUTWbfSOq4HE4VjwaD262U
         gptsVea95+rfEjZ9uEOe61kcJ2elru2Eds95Bq/g4MgzvImPRuCYbo6YEg7ef3/MFyvy
         dhku2I3z8QCSG6vofHGYfD5RKQyiKz4VR6cSBFyJGJGTZY05s9HqzVb0AEsxN5Bpw6vq
         gv3cvt84xekuDYZ8IwaXBEsTvdceOhnzsoQAAIh8rUuvI0SXqGxCMhels5hEEhuuZVTa
         5dq9mkzaM4rMfAJ2ISKQwdGZH4mtl6QN6B2nS7c4/z8nm7MK1ITJQzDMzJNlmFj0kxMG
         Uwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=UBfIa9QaOEP9iMmtgy5U6FtxHzePl0Ulhu75DIbx6tw=;
        b=b2BX+i/aoHWaL57VjT8JccwXftwZte42Z0I8c8l5BKw2xSZ78M7x6BgPu01a4ECLA6
         pBbj+mjPlPsBw5b4eYEOJIUjGlLiFY3FhQUHoguBnX8GE8zMD9mC+ZFjWTJoKyJGtmL7
         bMNq/GvWFWf43K1XHDnmXKVqsdcIAc0SeO5k2WP2UIWp+VjAcVWOW6V7sDpdFC1Ybx/c
         k79sYbuGn0e6WY/53SiZn759/9KGqbp/zp+mgZuAoGYi9HJ7xrCdrYz5H94ACtkw6GdT
         syMbKQHefzNTQgS2CvIN7jpQ2+vTufwg8amHrVNCkYmCPiBAGKZEtqVcxhx1ZcpSmEL0
         qS+Q==
X-Gm-Message-State: AOAM531wlTSXK1rq94HdG14U183ASoC8vlh/MU0Mu6JbFyooA/d6PSJh
        7Gmk116SaJM/mARp2guz4368ouig44yuqg==
X-Google-Smtp-Source: ABdhPJxe6xS3Iqb5A+26Igd7wGbbMz+zUM81wX+VqoJzmLZtY5hsUYLKS5LIQ41Q/zqlvASkjbIAfg==
X-Received: by 2002:a05:6638:2217:: with SMTP id l23mr555241jas.190.1644961394648;
        Tue, 15 Feb 2022 13:43:14 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t195sm17112212iof.47.2022.02.15.13.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 13:43:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Nugra <nnn@gnuweeb.org>, Nugra <richiisei@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Arthur Lapz <rlapz@gnuweeb.org>
In-Reply-To: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
References: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/2] Support busybox mktemp and add x86-64 syscall macros
Message-Id: <164496139393.13212.16397855953865799793.b4-ty@kernel.dk>
Date:   Tue, 15 Feb 2022 14:43:13 -0700
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

On Tue, 15 Feb 2022 22:36:49 +0700, Ammar Faizi wrote:
> Two patches in this series.
> 1) Support busybox mktemp from Nugra.
> -------------------------------------
> Busybox mktemp does not support `--tmpdir`, it says:
>     mktemp: unrecognized option: tmpdir
> 
> It can be fixed with:
> 	1. Create a temporary directory.
> 	2. Use touch to create the temporary files inside the directory.
> 	3. Clean up by deleting the temporary directory.
> 
> [...]

Applied, thanks!

[1/2] configure: Support busybox mktemp
      commit: cce3026ee45a86cfdd104fd1be270b759a161233
[2/2] arch/x86: Create syscall __do_syscall{0..6} macros
      commit: 20bb37e0f828909742f845b8113b2bb7e1065cd1

Best regards,
-- 
Jens Axboe


