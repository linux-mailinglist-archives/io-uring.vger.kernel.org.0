Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B07C42E101
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhJNSUI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 14:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhJNSUF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 14:20:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4AC061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 11:18:00 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p68so4855457iof.6
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 11:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xyyd/ZnubbTPPijSP/CT18OhYkXDXMoW5W01trrWwy8=;
        b=v3vwOjaBOfztMUXuQjl04Pu1o8FOyIK/dt0PIQ+4wkDBwSCKznv19q81XZXvOcuc5l
         JnaOrDf4jqIbRn+nUHMfB3ZqlG7tQqbbUgbuWwFl1aHkxhd+AOOLk2ugZPNPBDlCn8aE
         zah64neVFnspy7C6Op0SP4XSTRcIVJAtgrIIkfZlRKMn/isFhYg6eG5KOwDjNQg9SPoy
         211dy9i0g9A+mmH1zvzqxgbwIvdNl+j2jj0s5aX0Cg8dnTvUn3ajAtlhTfBEEFG852dJ
         UtYnjeePHKPR6IkPX9EOfFUj5FgkMnVTBLezOWni+syGtz0S/1yTJ7597Uc0eBCn8o2j
         FRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xyyd/ZnubbTPPijSP/CT18OhYkXDXMoW5W01trrWwy8=;
        b=6HzGJMOF99Tu1vhoVNcSmK46wqTdqKWHmgMrXsuqdfGwQYqCWxcU6r3BVwn+FhZ8yI
         HP93YI+sToWSHe+WyZMYChWz9FkojX2HBiDsMBINP68EBI/mnY6h+sib1dHkF0sEoXKm
         vKOasSL5a19jbAKKbmO0rEukGhkXcdjYXtx3AzDCppE4nyihNR9UgAoFgeJZ46NloKyg
         ACp5VFMdCDjSmqW474KiosRq65XW06h15YWsQI1Lnv3ieW93fBLjVkWd9zc/GfIXyi2o
         Vx0wnMsN5m1rVD27b1uImqlAW/XcHKPvwDYhDTJlL/NPKsQNibHbk9+1TGBx1vfRMpCf
         KGOg==
X-Gm-Message-State: AOAM530n6U0rkNnVHWXo/iH8HuukhcZicUAfdQkUiazd2JsRqnAFpEaW
        PwuqJYUmY5j2GJcU56xeISSwddY64nMfqQ==
X-Google-Smtp-Source: ABdhPJzieGDQISdL4XwbBzQo+7XwzhzPnesyADfKVMcDTUXpwlERoN0ikYTsn/P+fvlw3qJnnyC8sA==
X-Received: by 2002:a05:6602:2ac1:: with SMTP id m1mr425108iov.118.1634235479422;
        Thu, 14 Oct 2021 11:17:59 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l18sm1548818ilj.12.2021.10.14.11.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:17:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 0/8] read/write cleanup
Date:   Thu, 14 Oct 2021 12:17:50 -0600
Message-Id: <163423546311.1385699.18367704997906902690.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 14 Oct 2021 16:10:11 +0100, Pavel Begunkov wrote:
> gave very slight boost (nullb IO) for my testing, 2.89 vs 2.92 MIOPS,
> but the main motivation is that I like the code better.
> 
> Pavel Begunkov (8):
>   io_uring: consistent typing for issue_flags
>   io_uring: prioritise read success path over fails
>   io_uring: optimise rw comletion handlers
>   io_uring: encapsulate rw state
>   io_uring: optimise read/write iov state storing
>   io_uring: optimise io_import_iovec nonblock passing
>   io_uring: clean up io_import_iovec
>   io_uring: rearrange io_read()/write()
> 
> [...]

Applied, thanks!

[1/8] io_uring: consistent typing for issue_flags
      (no commit info)
[2/8] io_uring: prioritise read success path over fails
      (no commit info)
[3/8] io_uring: optimise rw comletion handlers
      (no commit info)
[4/8] io_uring: encapsulate rw state
      (no commit info)
[5/8] io_uring: optimise read/write iov state storing
      (no commit info)
[6/8] io_uring: optimise io_import_iovec nonblock passing
      (no commit info)
[7/8] io_uring: clean up io_import_iovec
      (no commit info)
[8/8] io_uring: rearrange io_read()/write()
      (no commit info)

Best regards,
-- 
Jens Axboe


