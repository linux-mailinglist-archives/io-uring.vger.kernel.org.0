Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F068E1A8DDC
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 23:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633998AbgDNVlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 17:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2633991AbgDNVk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 17:40:59 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF94C061A0C;
        Tue, 14 Apr 2020 14:40:59 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o81so9230362wmo.2;
        Tue, 14 Apr 2020 14:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u64x/Qw3ftLTMz2uZfg2N+jGFHmpawLcn/9u79QLico=;
        b=bE8twXYunjrtJQmL+t5DyOaZIkShuig3BIpEVeynGY4ZcXGZ8bj4dEYMXxBO4+/ZeR
         8tfZJpa3mi9MJwI0OIrpyem7urDSDcPhDgqAQA2YzvbuSNZ1Lj/+ipi4nPcwYyIKRooH
         lpphEmFP5mVR8dYx+1nqPJq4CKLCQD9v8N2tLlqNV/NDQu0hq0p+MY7qo9+XrpaJvz8O
         YRi0/sQktYEjcRv8LRon/8E3YIEjrxdOflVszye2NzTSTrZWsihkjQY5yMBEtW6paMFA
         oOTM34oR1r/45ExyaxkxGxBiC3XiA2bRIU9WBUJW4cDn6+l9OFjvymE/hjm0owCF2vj1
         KvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u64x/Qw3ftLTMz2uZfg2N+jGFHmpawLcn/9u79QLico=;
        b=t9EXFj9NrbhpQBjlm0qc4wjxejI6Aee0iiUoP5gIhVgLao+B4d0RO672YyYihFktH3
         yhCykLd2DNGa/97oOReTUr6WIInm2XCzVML3pvC4ueeOPFI9Ps8lQ9fnJqFjNAaeOcvv
         ky+FAQhreJKysmVRF7qe6D2tvSfwgNrTCF73ZhuyPZedy9YSpSz8in/M2Pstp7xnP29b
         Ny1lxzYgyTxON3pr6dfm69pCZvcp5ervulweziV99wfpxgWvr7gfP3tbP5rsCGod5cFb
         /ePxiAnEtxqNUTqpugO5zHvZRA6DMgpICvGb1Km65HMEBUvozAunqG9/FnrKLKIv6WCG
         3pfQ==
X-Gm-Message-State: AGi0PuYIzSyLIaxH1HZexVsOXTN7vL88NB1AKPobNG4NZ3e7SMSZrgRA
        mgZlViZyOohKGSoeOSkMqBL5GEXo
X-Google-Smtp-Source: APiQypKfNQkrPJKalZdKjQBcnBHLkY4WLfnxCnjuz3msS6nHF5+Ewr5gtZN8j7t/Q2UbPbFvZkY/TA==
X-Received: by 2002:a1c:9a96:: with SMTP id c144mr1848585wme.84.1586900457942;
        Tue, 14 Apr 2020 14:40:57 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l185sm20320540wml.44.2020.04.14.14.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:40:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] timeout and sequence fixes
Date:   Wed, 15 Apr 2020 00:39:47 +0300
Message-Id: <cover.1586899625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[4/4] is dirty, but fixes the issue. And there is still "SQ vs CQ"
problem, solving which can effectively revert it, so I suggest to
postpone the last patch for a while. I'll rebase if it'd be necessary.

Pavel Begunkov (4):
  io_uring: fix cached_sq_head in io_timeout()
  io_uring: kill already cached timeout.seq_offset
  io_uring: don't count rqs failed after current one
  io_uring: fix timeout's seq catching old requests

 fs/io_uring.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

-- 
2.24.0

