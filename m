Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8706014F463
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgAaWQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42329 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgAaWQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id k11so10415203wrd.9;
        Fri, 31 Jan 2020 14:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z0qLNjKELTzo8V2eDuoK6TJ0KaPfo8HAQpIU4qVlhvY=;
        b=M6zJ9J3PkavUndeMp2TByATRmXERrJR1X50HtK8gCQBCcY/04qFM/74E8Ud7SAWNtw
         I5CAoqdGFvw/iy2hL62ZZaFHyb3BSRPB1inwnl82G658k3kmf2X7uoMI958n44ZmFwS9
         0zTE4pPmg1fI4PgkeLLatHnc75jp6Au4XWgfmBNCH2cEjLr5oO6oWoS9Drm/n314ibVc
         PlGwcbsLmhRdhCoBdXFTuilXSl01Rb/Ep5CxTgH7WCDvXilNTsrrK4hCvLU2JseZDXc8
         MSKpwanmiHKeh0FUZeWAZ7e2sJ5ALDbIsqPGO3PXF9b2NlhPkcTIOfMrPZf/w6ft7JoE
         nW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z0qLNjKELTzo8V2eDuoK6TJ0KaPfo8HAQpIU4qVlhvY=;
        b=CWmJ95Ywn6XozFC8CuN/PknPKtw06sALTrL84Xoxi8UE/Y8scLYpy5bgdWc3PJDR30
         KL2T03qbBS4K8xW4J5um9o/u03SrPHOOpTEELW3wZLgtFJNUz7NS70fraEq1HuCWYXWH
         w99QI7rWBbPr96uEvSHt8JWsnqhrvg4eVjMLDTGyBxCzAjBKNFWSu5N2RroSQrm1w6nb
         Bi/V42UsAb1pifoyO8EVucSFsg6IORn/3MOjEscao0tKB1dMokCtHaUhgloCuW0Z1pNF
         b32j9I0W6nIFLEjykYhkvvRBMU33g7IZQ7TLWUYzfaV8BQspAjl8rmPLUUeEcAYBCm0D
         x1lw==
X-Gm-Message-State: APjAAAX/2dtcA5Y1+Hw0l5wvyWkboDOSpRk1REj0JEzgIeYzRcOd6e0F
        fRPjAmRseqr7zFe8gl8TsUshDcY6
X-Google-Smtp-Source: APXvYqzk2ib0orQl1T3z77LcmZgoVPYGS6LGaOwmy4coPw/4BGyHwZhg0T4GsEi8Elz9myuqK6FJAQ==
X-Received: by 2002:adf:fe0e:: with SMTP id n14mr568702wrr.116.1580509003978;
        Fri, 31 Jan 2020 14:16:43 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] add persistent submission state
Date:   Sat,  1 Feb 2020 01:15:49 +0300
Message-Id: <cover.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apart from unrelated first patch, this persues two goals:

1. start preparing io_uring to move resources handling into
opcode specific functions

2. make the first step towards long-standing optimisation ideas

Basically, it makes struct io_submit_state embedded into ctx, so
easily accessible and persistent, and then plays a bit around that.

v2: rebase
v3: drop the mm-related patch and rebase

Pavel Begunkov (6):
  io_uring: always pass non-null io_submit_state
  io_uring: place io_submit_state into ctx
  io_uring: move ring_fd into io_submit_state
  io_uring: move *link into io_submit_state
  io_uring: persistent req bulk allocation cache
  io_uring: optimise req bulk allocation cache

 fs/io_uring.c | 166 +++++++++++++++++++++++++++-----------------------
 1 file changed, 89 insertions(+), 77 deletions(-)

-- 
2.24.0

