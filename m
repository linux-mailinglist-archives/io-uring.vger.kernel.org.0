Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AC16A006
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBXIbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:31:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36979 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXIbS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:31:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id l5so5006760wrx.4
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 00:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdU3n29CYvSCdHy/ov9U/4GWTV75yDKtE5gp19lnclg=;
        b=iiZihdEfhF++z01DD8b8GGz+ANLkGRLz1ce+2FG3MKX57LuLze3edd/vUJlOcs8z31
         N6AnxTi05e+DZaoLqwiDxl8NLxH8GF83RCQS/ba5KL7Yn89mZj9yB/7pEKIlkeZVtggy
         Bwc6jSVwBuLxzO12yn5sFCTxhYCWQaLhe5zMDuPhLHw7l5v9h9WjjahlVT41o2oypI9V
         Cb+XC1rWRhkMfYJYIQoe781MyHinDVnOQZy/hKphZb3IU4sH6BZgd5qvww2QFp+CFBlG
         VYP9e4t//JSaAvgyg0TvZ07prtsm/EJSBPHUQbS52RdvL8lZSUmrC7fuV++CWVO7F1PE
         tNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdU3n29CYvSCdHy/ov9U/4GWTV75yDKtE5gp19lnclg=;
        b=HCBDnvyLdp9VsvL4jMQC+K8XJpKW7Nk6iZ5N6mVUsAK8vHy8qOAdeRBJx8ObISI+Im
         LvtyL2cVCwFg1WbS8reVAEI8IELudnESKzsUgi687KaTdedrh/OB1pcuzlGUGYyqtkPU
         XK5Pv3fb1LTRDlD38azd7ltBOrK4RiqZjz+AJ8Cw5Fu58nlKSCyx3GAjEkjiEcf7/lob
         5S4K9EckYrTTyyL8fnA9YMpgfPVKD1SEiTRtla2Ke8tPiegelQQyUZvoDy3t7Z3wujPe
         bMgOlvKsmDSc7JNJbADz8wyoECKi0fv8g9XcfjbDTb0VMLDnTjqkT+c/byF7CHunWOBN
         /+Zw==
X-Gm-Message-State: APjAAAV/AYXX5rDlkTR2ZIjDA+4IYWMcAL6hmWgxK4qoJ0skz4VUgVHA
        nTijpUeeA9F1yh8gtLalT47fMFFA
X-Google-Smtp-Source: APXvYqw0E/kZ7QUUN4ICUNqapPgD2QuHl5EY6sYN22wpJNafRhGKtOibgpyBpCGhcxa1lUlvHfCH/g==
X-Received: by 2002:adf:afc9:: with SMTP id y9mr1265947wrd.346.1582533076231;
        Mon, 24 Feb 2020 00:31:16 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id a16sm17946265wrx.87.2020.02.24.00.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:31:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 0/3] async punting improvements for io_uring
Date:   Mon, 24 Feb 2020 11:30:15 +0300
Message-Id: <cover.1582530396.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

*on top of for-5.6*

This cleans up io-wq punting paths, doing small fixes and removing
unnecessary logic from different submission paths.

v2:
- remove pid-related comment, as it's fixed separately
- make ("add missing io_req_cancelled()") first
  in the series, so it may be picked for 5.6

v3:
- rebase + drop a patch definitely colliding with poll work

Pavel Begunkov (3):
  io_uring: don't call work.func from sync ctx
  io_uring: don't do full *prep_worker() from io-wq
  io_uring: remove req->in_async

 fs/io_uring.c | 101 +++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

-- 
2.24.0

