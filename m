Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E95B431A1E
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJRM4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhJRM4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:56:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EDBC06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:54:13 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z69so12967537iof.9
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YhPsVExHBU57cxWLCZcGnPL2hq8OB3c0EpUt+K1uEtM=;
        b=p5z5xnEdwWphk1XQfbSWdfetVM6SPOTzhYa+uJ7weQVuM5pPEguYT8DoZynbtitCE6
         AhpEH1LqusEqYRfgQsJF7m6IyDKRELreGQtKotlhGTBRQTW2v6cZTH3cCbikv8OubVCE
         Si8wCMMlMhYLDiN3FN/J4x5bFgDIR47BrrrE1ofGm/S5hxSUg4N1yYVXxWksSTfBx9+y
         /EFYClDO0srlG5m2r9uJwHvcCvQLrzrSkGqY85CBXJVQQ1/XXdNcIFMZ7D2tqCycZCZW
         VOFZPFVoNv0G1cTp+momgt2tpaReevc16uHu8VXBo9ZUbkzVas8rXJMzWAjKXv6Tq4MQ
         Mi+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YhPsVExHBU57cxWLCZcGnPL2hq8OB3c0EpUt+K1uEtM=;
        b=7p12X43w486EEhvqZill3vYP5FZUzlyBNhe5Iq9r+6AyIq2DvaL69sminlXjE6g9qq
         ZAUeaEJypgrdOFf+ZqtLVMfHmJL80WtCmQX5ix0IOG95zdZDprlwGvA7bik/RsJPlSeg
         Mr2PxptnyuPK/lQa9UivOsvlbdZjl4nS+OahqEijhrovmAbeK00sIUzoU3bGdayZ6FpW
         CB7H5XG3aEbntsBgTbDevvK2XVvRvZTaHUy4PuJW/xv/W1pX6cPrvttPoGIYdGNIcRFQ
         Qww46L0UcQuQ/iFVQBYM+J7KAmCClKKXR3EjtFpQjizbFKWSJOOmc52/Bn6P1wHXv5rA
         kgmw==
X-Gm-Message-State: AOAM531ddqmPneNOfX2yM3VQlECy4Ngl4YGQ38Zd6XBQc2/MXWH8PPPr
        dBJSj50N5GIp0rHyj3FRDR/GIQ==
X-Google-Smtp-Source: ABdhPJyvV+6lzRfQcB6W01Bb5EfTaVDlHeK3SbN9iwTh2Noa4CiVwrX13AXktLn4rkklWvw5DEOsbQ==
X-Received: by 2002:a6b:8d4a:: with SMTP id p71mr14145796iod.16.1634561652703;
        Mon, 18 Oct 2021 05:54:12 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y14sm6833632ily.44.2021.10.18.05.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:54:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        yangerkun <yangerkun@huawei.com>, zhangyi <yi.zhang@huawei.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [PATCHSET liburing 0/2] Small fixes for tests
Date:   Mon, 18 Oct 2021 06:54:09 -0600
Message-Id: <163456164473.240708.6609248952703455574.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
References: <DdOIWk8hb7I-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 18 Oct 2021 19:45:59 +0700, Ammar Faizi wrote:
> test/timeout-overflow.c | 2 +-
>  test/timeout.c          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Applied, thanks!

[1/2] test/timeout: Fix `-Werror=maybe-uninitialized`
      commit: 49e3095eb27febf4dd2639430cb554a5c694ccf9
[2/2] test/timeout-overflow: Fix `-Werror=maybe-uninitialized`
      commit: b3813170f9f24f9e18f068a7a1e29747417e360c

Best regards,
-- 
Jens Axboe


