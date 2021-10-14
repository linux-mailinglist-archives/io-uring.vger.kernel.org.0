Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CB42DDB7
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhJNPOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbhJNPOP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:15 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10405C061777
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g25so20458413wrb.2
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQKdhtPZdV537B8lhHoBkkWV9ZxXlg+qPiLKXknXXPo=;
        b=lOO4KOwjh8zeh3ftO1d/kmPGhG6cIba4j8WARly0bpT2jnKme57I1W4rq20XoJjO+x
         Z+dNrxiMsRu83/zy1+yK2X1PZHtPQEMRq8/GTiJK+7Yf0zN74XMF+6/W/Dkn2oO3Il9n
         IKsqyoZKL2+9pN/hqm2TGh96rNJ1qZS33nCh0tCXfzn9HCgYFGd3uaEVKsIqxI5SQBYg
         cZBdMYo4ltuO7AITEeNW8NCSOuMXUtpqvZ1DgDw6NwZTaTUTPY8f5EXPrQmGan0A0KH4
         HFb0lPCzkk/IyyE9GTQYBUDP7UxqLcKUsEhIWngLFp0XW1wKtZmPZQ5Wfm+LnUOejvv7
         nD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQKdhtPZdV537B8lhHoBkkWV9ZxXlg+qPiLKXknXXPo=;
        b=3Nu2fF2sUrRoCZXdOG36V9UgYBOh52SKucWgC5I6DiPonRrplTFQyfCHn4myZC6WXK
         LEh/mZIT9GE3o07YgOFagsirfsh+rNZMhN/7u5VISmBNHDRi4nnWB3ka6bmwsIyyj2e+
         dhJKKqUyOy6ky6DnVubPbLewTqVXDtklJyW5+XzFJTMZD5LCf5TV1quYd3s9WHVS47BJ
         Ewr+kQZEjEfHXbT0Qqm90cdxyEwGJAvGltezcWmoPZjYoIbkqPyAZ49/KzEJhsOpuepT
         AVEmAwjfQk0bTLyFOFSFOmDWZyjgOx0gXDLsEX1MbrYSj2xtcu2VB9AxiNkjNZ1fO+7e
         ePgw==
X-Gm-Message-State: AOAM532A5C+Ho9hPqGsoeSnRb+4Oty/aDOTlASc5NAuJsS91ZLXINwg0
        +K3L00T7SeH4Rn2VfDTaXxr26+aReFQ=
X-Google-Smtp-Source: ABdhPJxBlRGEnEePO6Icc/BppeZaqMECRVFMbCZyr0+3NojnNZXBV3cQTtAC4nRWaowHQkRHM9w7rg==
X-Received: by 2002:adf:ba0d:: with SMTP id o13mr7246189wrg.339.1634224267451;
        Thu, 14 Oct 2021 08:11:07 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/8] read/write cleanup 
Date:   Thu, 14 Oct 2021 16:10:11 +0100
Message-Id: <cover.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

gave very slight boost (nullb IO) for my testing, 2.89 vs 2.92 MIOPS,
but the main motivation is that I like the code better.

Pavel Begunkov (8):
  io_uring: consistent typing for issue_flags
  io_uring: prioritise read success path over fails
  io_uring: optimise rw comletion handlers
  io_uring: encapsulate rw state
  io_uring: optimise read/write iov state storing
  io_uring: optimise io_import_iovec nonblock passing
  io_uring: clean up io_import_iovec
  io_uring: rearrange io_read()/write()

 fs/io_uring.c | 233 ++++++++++++++++++++++++++------------------------
 1 file changed, 122 insertions(+), 111 deletions(-)

-- 
2.33.0

