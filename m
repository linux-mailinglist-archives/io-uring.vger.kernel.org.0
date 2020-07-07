Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B2A216DE5
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgGGNiN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGNiN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:38:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8CC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 06:38:12 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z13so45178790wrw.5
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 06:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jN1c2VbD9pYcG4iLjm7Ul3HpteWxaKFqQrNVVkJfal8=;
        b=ryIzUNrKHJpDG/w05MAR4kTFWyGtx93YZnInthJ8Va2d5ivIX0C4Ikq4GEGuriI2qF
         THS+6hBzvniD5kAt73dcR8WxNx4kncURvbfhDJigWSA9hnrRbqA7ie/a26kTQXP2PU4w
         +Z0M6DkewIfZcizxKzxnTj3LEuXR55gIA7zowqn8kfDYlzLV3eHF0IFQyilhBnVwnieW
         YSq6aENhdGnY9LffPGOiD3hMRvK8Unicbo9Sw9RnPmaGmAW6pxnfSSZBEbZIOrAVS4uX
         XHnrwQtH955Zh7RyDm6azU+uhz9/GmxqX9CXatwXx0cPIGwR7zzcFxQfDztCN+fldRQ4
         RHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jN1c2VbD9pYcG4iLjm7Ul3HpteWxaKFqQrNVVkJfal8=;
        b=sifCNvapQMCOP4ZdBc3X8xDRIIUhrDqKm8ORMC/vNn//2Cffi8LJHcOG8rYGI8Wmh2
         U6va+8rGoZD9W5qh55ZxC0wOMNZDoWCdpnNU1VPVq7+ZswHBXT+38oc11yt317TJ60fS
         XywNWrAHEEtt2Rh3z/DlUG/8bRMj+7Ef6bXeGF9VVDTmIIY5Le6luQtMeT0F8sYgyM09
         WOIn7qEEbcjQdVe3PLQCV8VNwvQbvEGk9k7PO/RngBqjD2h+E7yDINGkpldJBxz5jOiS
         /QW6m3c74BN5AsqaR1gi0om785xfnXDwOTioVfMDDTbnlsKDLK7w7dkqC96mGpGeW+vh
         EtlA==
X-Gm-Message-State: AOAM531YGvwImioLxqouSFtuy2XQd5OHuMLXoGTtlzDT/+9Lz7ZD3Jr9
        xBZvnTovoYunYHPFDHoAyY8=
X-Google-Smtp-Source: ABdhPJx2v/afNzg4WyRImxp3hZm/PesI/VnE6rWTYI0pm2U0Jj/GFE2xQiluHLfoOLh/Il0rUR2CFw==
X-Received: by 2002:a5d:4607:: with SMTP id t7mr57858922wrq.251.1594129091586;
        Tue, 07 Jul 2020 06:38:11 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 14sm1093663wmk.19.2020.07.07.06.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:38:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/3] reduce CPU usage on exit for IOPOLL
Date:   Tue,  7 Jul 2020 16:36:19 +0300
Message-Id: <cover.1594128832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1,2] are small preps for the future that should change
nothing functionally.

[3] helps to reduce CPU usage on exit. We don't care about latency
and CQEs when io_uring is going away, so checking it every HZ/20
should be enough
Please, check the assumptions, because I hope that nobody expects
 ->iopoll() to do real work but not just completing.

Pavel Begunkov (3):
  io_uring: partially inline io_iopoll_getevents()
  io_uring: remove nr_events arg from iopoll_check()
  io_uring: don't burn CPU for iopoll on exit

 fs/io_uring.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

-- 
2.24.0

