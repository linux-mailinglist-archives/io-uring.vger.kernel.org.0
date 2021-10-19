Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A2433B1D
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhJSPwr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhJSPwq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 11:52:46 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE129C061746
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 08:50:33 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so2849248otl.11
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AaVKBxfnT0MBUuzApSjuIfM0ffrR/bZgEwtyipODILw=;
        b=YYK1sLjy7nEViVr+sKA1drww83K18jqTXwD04GvfAuTzi/5tbPIJyt6PFtm3g5HN6Z
         CYP2iPFBbJ+mxXehFyvnDzWi7+CpJ2poE+sPJtReG2huVSmfd/+ksfaA1AX0HDwk2Cb9
         lCJ23WPXhVSpTu855/2VGEEnFCve7+0lIeuCUYOsMR08BH3oL9a5sAv23AH96nrBdc2+
         brnQ8PSMbQSFyUO2OllI7EHbIYLOuSJuFhZmeKctj7boYcEmY1OyCkU2BIghsZ/SvMme
         rbaDSQfH9cNKA3L/n93o52bO5OhFCMPs9kMLHJPa47yFbtfIA1ogpVyNCR1q4AnvFrAu
         +B4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AaVKBxfnT0MBUuzApSjuIfM0ffrR/bZgEwtyipODILw=;
        b=hhPSQk0kujobaZqseLhiBEXBOw9dI0GNBOT/6O8pFfKPbjuJ8e+uw157sa0ue8OP/C
         RshfYMGxeuT1YTqCidAMMTAZC+M0p0mK+sXyn7+NSFoVpZmOYqViKuLuKycKDGILHen4
         R5Wo8+4dEw8saoXxlUjQOiPn8hmL7e3Ri0fzECF4wJdvWGtFH/HiZ0K+QC7J7FkByHDd
         AGKtJ83JFJcM/M595tTxQkuXGFYhrPeDUg8x367H+FAhpRNfmxeBkvXN5y68ufBsgU4J
         U6XCN1Esj3WvKL0oNJ0RQ3GaezQpOz4tbDfZq7+417BcNEdj+3oqRZU/LzszLLjmMuAK
         /xhQ==
X-Gm-Message-State: AOAM533FfsOHvSO0i/A0eRfsRNGWzlPHzxOLGHbhwi18sJuq2c0bIO0D
        M9mphsobhU3ZVWBNE+zJKV2iYQP0JJI2fA==
X-Google-Smtp-Source: ABdhPJxkrraJps6q/gKEUDRCZU5B28dcm+/an718uXWEQwL7RBHiXNVtxKZIFB6jCjrU1YvC3cm5Tw==
X-Received: by 2002:a05:6830:1dc7:: with SMTP id a7mr6176252otj.342.1634658633015;
        Tue, 19 Oct 2021 08:50:33 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q39sm3798210oiw.47.2021.10.19.08.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:50:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Arnd Bergmann <arnd@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] io_uring: warning about unused-but-set parameter
Date:   Tue, 19 Oct 2021 09:50:30 -0600
Message-Id: <163465862593.624672.9684355063496610398.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211019153507.348480-1-arnd@kernel.org>
References: <20211019153507.348480-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 19 Oct 2021 17:34:53 +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When enabling -Wunused warnings by building with W=1, I get an
> instance of the -Wunused-but-set-parameter warning in the io_uring code:
> 
> fs/io_uring.c: In function 'io_queue_async_work':
> fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
>  1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
>       |                                                       ~~~~~~^~~~~~
> 
> [...]

Applied, thanks!

[1/1] io_uring: warning about unused-but-set parameter
      commit: 00169246e6981752e53266c62d0ab0c827493634

Best regards,
-- 
Jens Axboe


