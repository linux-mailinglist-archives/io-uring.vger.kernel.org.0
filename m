Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C83A8457
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhFOPu0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 11:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhFOPuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 11:50:24 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25BBC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:18 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso2312137wmj.2
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GPLvhehrD3Yn8oXpiI+AFiJEjeKb5NTeLUAScjvIuxc=;
        b=NKZRtEVPBbxRU1yHY3C2oEBEfuyra9x4oWl7UHU7+jnPcwmsS3CefzVxVP1ioL1UTV
         LrTLSZ4276o4JyCp7bWIoRETtI1EaNARJLw+z3sjT0yVFolezxNrkObmt+35AnGuKpCJ
         wgF0XDf9XY68g7FQll9PzsEg13fn/uIL3TKPnv9tQTCNZVecTH72VAezjwmL1if4sZ6R
         feUMjfZZGRO/jEp4LyVsOyfk4AHG16vA7mDTawDIVkOyKbqlit4s4mTOB814KenZnKCs
         lK7Z+1YmzHAYaCPjQ2Qqz1XJTrlzV7fig2sotwMLpnOzQ2MeDY3a+x/bOmvsDWXLJBfZ
         7grQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GPLvhehrD3Yn8oXpiI+AFiJEjeKb5NTeLUAScjvIuxc=;
        b=l3X4hPL5MHCxD65swdaUXOd+7hlIwa+a7ZuDZByolwkeHdoUTzx+q27bP5JEuyrQwz
         IhvfSTn3U0SxipGG+NA2B8Sd6SISnik89HYVBFpz1i4lTrICXnsVHO3Z605abi4jXqJP
         WF7A2M7+rtqjTHgjSWsYcrBs6U/x1DxuShX7RtfRuc2FgRtTspOOVNmZUihK4bF6nJUS
         PSVA7CbCKb2BH38JxSuxQLYLn9OZO1CYMxq4cWLihomU9vTqavRo8PaB7MwstzhRKz4H
         Q5qaN/od2Qb3NfeH1pOlOje5eR9MfBYSwaP9xkjCKd9e6ZV9bMlv55/u/2YpNXaSsRZw
         Oa1w==
X-Gm-Message-State: AOAM530pAvmAz3nALzTYOvw/xEcpLHWB/XylQzBbvqbOcZcuMvgaaijI
        yXhEweHDaIR0I9X434T05O0=
X-Google-Smtp-Source: ABdhPJyt4Dcr873SavJCDMiFB9TY4hY/KmQfqAcPEfmS9PHj3WwZxknsOqUOhkeiQq1puLxw1jxwyA==
X-Received: by 2002:a05:600c:1d1a:: with SMTP id l26mr23863457wms.189.1623772097407;
        Tue, 15 Jun 2021 08:48:17 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id o3sm20136378wrm.78.2021.06.15.08.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:48:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/3] further optimise drain
Date:   Tue, 15 Jun 2021 16:47:55 +0100
Message-Id: <cover.1623772051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On top of "[PATCH 5.14 00/12] for-next optimisations"

The first two further optimise non-drain and rare-drain cases, so the
overhead of it on the hot/generic path is minimal. With those, I'm more
or less happy about draining.

3/3 inlines io_commit_cqring(). I didn't want to bloat the binary with
it before, but now the hot path is shrinked enough.

Pavel Begunkov (3):
  io_uring: switch !DRAIN fast path when possible
  io_uring: shove more drain bits out of hot path
  io_uring: optimise io_commit_cqring()

 fs/io_uring.c | 68 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

-- 
2.31.1

