Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737C345DE74
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 17:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345575AbhKYQRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 11:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349570AbhKYQPV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 11:15:21 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA305C0613DD
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 08:00:54 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id l8so6306278ilv.3
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 08:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=O0g780XUQdQIIN+4g5hKQ/7jBqzvWjKKGQrD1uDI7U8=;
        b=5JZW2bwVv/aK9eNSDwpG8fOrlJZXPg6+2ftnW944g499H9rNQfrvuK4tB6wU0ZwnCv
         o1eX2wdV6NE5C5dn6BzrvCmmiij0pdyG/OFJFV6dfWLY6tCEpB/dKKYpvCOnxu2Of+k8
         I8taiPwukG1D1mzeD7d3L1ljElZ/Mpqn8eNXzu5b+R1gciTYWJXkzz2feJdNYhyV/D2+
         NI+xBNhRMJbJq29nAadlC6o4Oc91N0BoCCMAZOkp64W4khezW0uSs6WtX4LhsJ3KQEQi
         AKJtqf1jRkbAgV5R/cbKHee4EcovpyziRDm9ybwQ2uRYwX0M7o7pMUYYucByVr3TuRpY
         K0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=O0g780XUQdQIIN+4g5hKQ/7jBqzvWjKKGQrD1uDI7U8=;
        b=Tmko5sZhFz94nGzjHCnUACyTBBuOANk+tZ/sEX8qyCve2GwGWCZ4m+wkAKbIwTgIzn
         7JP4griZMi7yu7nId2ZGMXSvE7JWrQGcg3AKiiNsJ+V44lne1jrVRhM8Vpkr3VtjGyvf
         p1jGnBxLWRhhzoajk7eoXdWDmQL3OuNGBjC6yg4CW+rPCSsZYSsfqxxOF2G/PwHf7Klr
         sK/xL3wSuB1ttux/ZrOkz+qBUQ+xtAhF9kZ4gmbcKM1dC/A6Bl2TUQyyGznXQR8sjRiV
         Xl4SP0I9h44rBw5EHsn2iU+dZknvsYmqZpd+pgvNdIkOmgq1bTj1NKCr1g6avAfWwLu1
         tVbQ==
X-Gm-Message-State: AOAM532kZ6EHQdgfyQoWafopWMeYBmCBuOGLuKzLcAQ711+W2IL0IAnB
        UhRLLGSp2Abk0i1nNC/OuMjCBw==
X-Google-Smtp-Source: ABdhPJzwdE8S6Ow4YEixXyyWlbdR0jsy/XEa9qnE/W7rkBmfBQeiBEAw0Zm+KN0OEqfIIREurMgckw==
X-Received: by 2002:a05:6e02:12cb:: with SMTP id i11mr21335695ilm.12.1637856054115;
        Thu, 25 Nov 2021 08:00:54 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 10sm1985866ilx.42.2021.11.25.08.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:00:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
In-Reply-To: <20211125092103.224502-1-haoxu@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
Subject: Re: [PATCH for-5.17 0/2] small fix and code clean
Message-Id: <163785605138.523421.7852091101066277742.b4-ty@kernel.dk>
Date:   Thu, 25 Nov 2021 09:00:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 25 Nov 2021 17:21:01 +0800, Hao Xu wrote:
> Hao Xu (2):
>   io_uring: fix no lock protection for ctx->cq_extra
>   io_uring: better to use REQ_F_IO_DRAIN for req->flags
> 
> fs/io_uring.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_uring: fix no lock protection for ctx->cq_extra
      commit: e302f1046f4c209291b07ff7bc4d15ca26891f16
[2/2] io_uring: better to use REQ_F_IO_DRAIN for req->flags
      commit: b6c7db32183251204f124b10d6177d46558ca7b8

Best regards,
-- 
Jens Axboe


