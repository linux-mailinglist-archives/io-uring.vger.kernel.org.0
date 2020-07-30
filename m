Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6032335F8
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgG3Pp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729950AbgG3Ppz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:45:55 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72869C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:45:55 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l23so6587861edv.11
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ch/EcCc3RchLiVnHmELhmt48SnglPTATyP3XYLImitw=;
        b=g3zRHLLqoHNgfUb90M205KpX2CcHN2nZW28gnKkifddxPnO6sfMB10/EBnJ68u05jd
         G4v0D25TaoTztZqA8Wp7q6AUCmR8rYZwxXX6u/Yrf4uUmCt9iLzBeuoYfuf1lYvujkse
         mRRSojUCONhz149QUCneotw2SQVT8+WpzuXqmbF9LACrIdXHDPJGfqNIgKwl6s86/syQ
         L9fn9MTR0TAmQAr6/YLokToCrgyz9IdsivoORbULmQG9Nl5vHJRszT9Y4s7cSdx634et
         LGhq/YFR6Mmiqq0hh+rI7/I3JSqQ43vAuCTC48B76xtt+5UljsSlaIlMlpmQOT2oBRTB
         ismQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ch/EcCc3RchLiVnHmELhmt48SnglPTATyP3XYLImitw=;
        b=HZnS/GZb1i3MFlDFd1Tb4mbgoLC7IPIjHbcOFYJRp+eUQFCjkOKPaDXr73/+dXshGr
         COOjs9eymufSD+GhyFUVuEiAk1LCEofqeVaIKX3bHt5yDVcTdyt4sjQ0wBoRrRNpRTAq
         SWS9Dw0QY8kG8Fu7jSnmEIjxiPD7XDC+JCrkJpJDQLegh4WaJvBHJxw5uL+DxgPzXxRI
         79RszCW85D5e5pYejZguOEgMwEZqUCgSp3P5jGbmiersBsk0kk3uCps4q5OmRvnA82Gv
         6xSZkpyqDPGSgoy1iQV7atO2ej08An/FrJm6bqd8vBU4W+bGA8lvKmgROS4SdEPMfnTA
         5Ljg==
X-Gm-Message-State: AOAM530c25KZohEN8JPJ5681tbM7ao5kq0BJfqL84GkUCbMeU3gdvjhu
        raSG4lPHdwyJz2tmcIv6BNs=
X-Google-Smtp-Source: ABdhPJyHPWHPqbJnyOLpCF/jirXpQoAHAvtthz9NJMvl5HkiPmOxdvLTZN5OU4cHpCEaejytdTxd/A==
X-Received: by 2002:a05:6402:1457:: with SMTP id d23mr3271240edx.149.1596123954134;
        Thu, 30 Jul 2020 08:45:54 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:45:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/6] 5.9 small cleanups/fixes
Date:   Thu, 30 Jul 2020 18:43:44 +0300
Message-Id: <cover.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1/1] takes apart the union, too much trouble and there is no reason
left for keeping it. Probably for 5.10 we can reshuffle the layout as
discussed.

Pavel Begunkov (6):
  io_uring: de-unionise io_kiocb
  io_uring: deduplicate __io_complete_rw()
  io_uring: fix racy overflow count reporting
  io_uring: fix stalled deferred requests
  io_uring: consolidate *_check_overflow accounting
  io_uring: get rid of atomic FAA for cq_timeouts

 fs/io_uring.c | 100 ++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 64 deletions(-)

-- 
2.24.0

