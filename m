Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611AC1A1BB3
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgDHF77 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 01:59:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40090 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgDHF76 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 01:59:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id s8so6350126wrt.7;
        Tue, 07 Apr 2020 22:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qgOhFm3XtMgYp/T383LRXeGh7PQDJ5K4iJ9WPwxykVA=;
        b=I81SNJlzXpW369Cml1GX0PWwV2T84wE2B90dDPQMaanNxcBAClEmb2T38I82HkPLnv
         yDtCPcLjKySq8lx+Gb9tKCWzNT3/zsemLP5+skqxwvFpQbzzZuNd3xS/dGLbvFuzuS2K
         0lMUpbykfTsVEHPmHviNzkSR4NcARvmoIOtlhCuHkHwVi/p2pcngwD9ybRgTgZVrolU/
         6gIclqu2+3UGXz39mxa/IdoKEngGn/NvFMhoO99srrUKDMosCPKtYZtNZmug4lBd8YiK
         6j/EpIh4r0NNUkUaNY72sRtQ8Rsed1X40SC5hG9H/qHIBqutfCGNLFwyW5WVeLv8xLxQ
         ZFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qgOhFm3XtMgYp/T383LRXeGh7PQDJ5K4iJ9WPwxykVA=;
        b=Glzyi/hyytzfHRP1jmlXlIm3nCBdwtXu5wb1YVKXh+saa5a9uvh64dnpZLZwlJkPVA
         wmIK+oLmrGZBJxVuCI24nQZH+7/MfprTQFf+lPWLAADf6ngxrGfe+lzuFAEFuURsUmoh
         zwnIPDlWodpTIp9JrhyzJhM4G7zKpKNkUJpMzBnrfDA1n6ZDrVNfwnrp0kpC3IU34dMZ
         YzYFAr2fyRHEU6933RMW+BVRD5KRjsenYtI9OtYMZueRwZat+VfHudk6uj67xKRLEDwW
         Bl8IHI+6y96u9Pn0L8IcCVYx5bFCLtvnhexvM5sUvyXcnK+wH//NzUHFOoSB2g/Iy+1o
         BB6g==
X-Gm-Message-State: AGi0Pub5guMOYYwo1JaACpFxjaMfUl0OszAFZ+c4HT0pWHF3XL8cejuo
        e8au2NP0T0IEc73Emza2cKs=
X-Google-Smtp-Source: APiQypJ5yg+Pqe6G2BNf8c4jAbz7omPkj6lfBwPEXaGul6YNIU9FvYqqEo2lPkDaxHDmDQBbBvOIRA==
X-Received: by 2002:adf:80af:: with SMTP id 44mr6706005wrl.241.1586325596518;
        Tue, 07 Apr 2020 22:59:56 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b15sm33454986wru.70.2020.04.07.22.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 22:59:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] clean early submission path
Date:   Wed,  8 Apr 2020 08:58:42 +0300
Message-Id: <cover.1586325467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is mainly in preparation for future changes, but looks nice
by itself. The last patch fixes a mild vulnerability.

Pavel Begunkov (4):
  io_uring: simplify io_get_sqring
  io_uring: alloc req only after getting sqe
  io_uring: remove req init from io_get_req()
  io_uring: don't read user-shared sqe flags twice

 fs/io_uring.c | 113 ++++++++++++++++++++++++--------------------------
 1 file changed, 54 insertions(+), 59 deletions(-)

-- 
2.24.0

