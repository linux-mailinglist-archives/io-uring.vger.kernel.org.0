Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDB728E595
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 19:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgJNRnH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 13:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgJNRnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 13:43:07 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFA9C0613D2
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 10:43:07 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e19so190202qtq.17
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=f0pB5/6uDIV5mRb154M8ZVIAD20wSOQVeYXIO9SVDew=;
        b=muD/lbk0Vi2OKCQINdAD0dBZKl/O4MC+SGXL1v/iFdXsYvFHgNGI2r5WgbrVMbcctt
         Tx/6BW1FEWInPo6YfTbwpTkWv1aQ/VkiAbIMtmc6stXt4VLF/z6fUbbcwl7yn9U1yKpg
         l98Qwl2GVtKfLMZJP6yBrBEDuR7scTQoaJaif2QW/46o069dkIakORHFJ7TfKGbN4sWx
         hmrJ4SGB+OblEHnBSSU8vCCkNa9T5q8b4MG/MIl18HYeTkQNnAGK75Wb2xIzIG4JvSfI
         +sLnl7Q6z9ajGR5mvrgyHlVh41AT2X3ubCDDvLvZBpM8jNr4KWjt/PNJ9Ta1C/GOpEir
         Rw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f0pB5/6uDIV5mRb154M8ZVIAD20wSOQVeYXIO9SVDew=;
        b=VGPRmxSppbl/inKuNKScT8kTJro4Vq1E1oIIttpmfSwps4N9jeSJy30H3GDea80u0E
         ZOq2cGorIKRhbPWKnBBkSNVVGj9l2oTbnye/fbY9xiAhbQOhD7VrVm4FtRW+VGcVX1UK
         RfFUqymK8+y9vtX/6+O61wNaD1zZ9mZGLR1l4hPgdV6aITt1VYuAMZK5K2raUch67j1F
         EhNipNAbHbYsvtJS2Cun+CjAslFs2WuBrfeDNFsStoCkopw8isbgHDK9awV44g+R2BDw
         6xjJ+CL6s+/a9xzGUuFV2SL5T9FOX48EJn69jBAi8wFOdnIo3nPNBM8wa8l/8s+NAUkb
         KYOQ==
X-Gm-Message-State: AOAM532nK16VsibDHZjOifUnFuv3jcM5eOjL8dWVD/S9sMNO7dX90Sqe
        9XWsUVoP6deyaZAZdere2+13s0bKDz4Mo5Lr5Z8=
X-Google-Smtp-Source: ABdhPJwbUQC4GE9QEd4CALxjProAdSsd0yvJVFSrYJOGRCGJXxb5pnQvJqp/Nva52BLlvmTpzwVm3R9fZhVylqz5jdc=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a0c:b78c:: with SMTP id
 l12mr651830qve.38.1602697386340; Wed, 14 Oct 2020 10:43:06 -0700 (PDT)
Date:   Wed, 14 Oct 2020 10:43:04 -0700
In-Reply-To: <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
Message-Id: <20201014174304.1393937-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAHk-=wgUjjxhe2qREhdDm5VYYmLJWG2e_-+rgChf1aBkBqmtHw@mail.gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: Re: [GIT PULL] io_uring updates for 5.10-rc1
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     torvalds@linux-foundation.org
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-tooling@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for not reporting it sooner.  It looks to me like a GNU `as` bug:
https://github.com/ClangBuiltLinux/linux/issues/1153#issuecomment-692265433
When I'm done with the three build breakages that popped up overnight I'll try
to report it to GNU binutils folks.

(We run an issue tracker out of
https://github.com/ClangBuiltLinux/linux/issues, if your interested to see what
the outstanding known issues are, or recently solved ones.  We try to
aggressively track when and where patches land for the inevitable backports.
We have 118 people in our github group!)
