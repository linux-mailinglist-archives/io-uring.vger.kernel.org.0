Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEA3E4CEB
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhHITTK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbhHITTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:10 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954D3C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso169972wms.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pI9Ebh5RCtj7783Uwq8eSoXwV9SqeY2fnJ9lmslROGE=;
        b=gZxOBfrwSBPn7Tlccd0XOM5/rkKn2lg2U6IJ4wlHeZPZuGZrszuj/Jo3YEE13IDewl
         hhxZ2Fgwu8ndOzK9bPTUIj2MtrivOAciE51HAoav1dY4w/VbOXDs6GCzdFczp2OCCEpF
         oVYGonu2PzCutMVuV/gjIheYI8DFJgKuLq1IQ0FEzC/ibuSd3QLs55RNBWVyz7vIRKsK
         kQFLcfwnTlEOgZzQm8d72/4H1tR62AwkzkfgseZ2uWHrfMLiXcxw7Y/lLB8ZjAmUFo80
         ar3Nw/iM2Nzfcfmt27gcZmpVcb0Cf2LA+o+7L4slGMUayb2+02U29HnhlKH3MSRpWXJ0
         AmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pI9Ebh5RCtj7783Uwq8eSoXwV9SqeY2fnJ9lmslROGE=;
        b=VHPD50eQdImjEhALBuglzOsxk7nlEBBaFIudg2Y2ps+eADFnwRzkO950HK4g+xCvqI
         1yguMXIOKS7NC+CTxjh24/C2adfmxE6drqi64+gEHpmCgjJQECXJUTDQbanU670XjOXX
         KCbp3x+U0+Ny9ZcKPau0jRn0iTBqysBb1UZGSydzcUwp9pb/2cJ1RR9/iE5F6IzEGxG7
         KC48O6ol0rdSD1pFW72gQkbzdNG5YrxIb/uta0hq0iHtJit8zrIAm5aP3012OWOk06Gt
         0XRhSHxPJCRgmynM8+sEgmY6Eg2ihRBCovdow3+ifVc/VJ14aor0RUINj7Nm7skLul8U
         Puzg==
X-Gm-Message-State: AOAM533H0n1J5/vDMX/1AyworNI3u4qrSBCHNMFo1TAUiBKwhc5wF3IM
        0TjlIjklBQcua4A3++S8xmNcM5MxM3A=
X-Google-Smtp-Source: ABdhPJwYKup1jiV3pzZlNLImtP2ZoVwFA8qpm3mN9sv33eH0EYOyuHwLV9ynyIBWKN6EmIz2hgdXbg==
X-Received: by 2002:a7b:c309:: with SMTP id k9mr19020183wmj.48.1628536728305;
        Mon, 09 Aug 2021 12:18:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/7] the rest of for-next patches
Date:   Mon,  9 Aug 2021 20:18:06 +0100
Message-Id: <cover.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Resending the tail w/o "io_uring: hide async dadta behind flags".
The dropped patch might also conflict with 5.14, so will be
resent later.

Pavel Begunkov (7):
  io_uring: move io_fallback_req_func()
  io_uring: cache __io_free_req()'d requests
  io_uring: remove redundant args from cache_free
  io_uring: use inflight_entry instead of compl.list
  io_uring: inline struct io_comp_state
  io_uring: remove extra argument for overflow flush
  io_uring: inline io_poll_remove_waitqs

 fs/io_uring.c | 140 ++++++++++++++++++++++----------------------------
 1 file changed, 61 insertions(+), 79 deletions(-)

-- 
2.32.0

