Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885331EEF5
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhBRSwJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhBRSf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:35:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16BFC061797
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:46 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v14so4059533wro.7
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XQ1KGF4URDOGBeMkdA3olcFI4RQnOCKSVr7UfJ+Eg18=;
        b=MmJ3QumOI7uSob1nbHLKN0cqMy+YNmC+qBUbbjrgYUCUsUasc18barOBjdRCGL48h6
         S+uWFGpJ08397BBQ/68OMCyYqfKzl2T/vbY6XN/KL3CJ+q4AAM1wWG27QQqlJhlBkfcd
         NYlpxKeYDprI+YVlBos8fhIfphN8EbC8p/7ti/sQ/PQoDPzwJlgZ/5Ps+5lXqD0ihoxh
         f10ybY1jNlRlsfbgh74eT8S2TQEAjQIwAM1k7bprO/fwko5tZNQ6Uk3zHyFA9ha5GYXW
         ozPILL4q5p0sFZJBGD3Bsab7OEa9hMjTvNNTsUNuhkzVJ+/0CtDgy1xAxIAt8x1jKGf9
         fIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XQ1KGF4URDOGBeMkdA3olcFI4RQnOCKSVr7UfJ+Eg18=;
        b=Kxj49o2cCY2Wnfrj7mRbE2H2BFKwCUWAdMdUMsiTpJS0sZ1eoOKIH3Gw7vlzAk0sYK
         7Us5UW5akqjEs4onUYFohlxVoB0s5ryywHWggSDV+HLI5LT+obao4lD6sTLDKvQp/Asw
         a7hefLS1MVFqB/rTbziAe2M6WCF9HUVmVa7yl+CUUZX98bZtDKcOx8jnSC5+UsdjaSQN
         fdhibTILeCG3kxtGI8uwbbYyXo+JWvUC1r+s714fAsQV4TH7eoYs0eHFmNLM+XdhkCfO
         ts7voAMP1DQAApDEYGaGil2EaSXkESc02K54nOEdrNQdDqO04Z9oQcMv1GK3i7uL74GS
         DnsA==
X-Gm-Message-State: AOAM53250i53JB7UO1WecrKtjfP/Yo43bfUDDB/fX7vNegIM7vV9qlUM
        SkDQX2sRmi6rSuaWyWQDrOR4NoRfKNRZQQ==
X-Google-Smtp-Source: ABdhPJy4PqG6OxamjE12YJkyJ/HT67/nMvH9kvwbLZov3lHMMJa8+XoVRDY+v+1dWF9dkQMSH7aSUg==
X-Received: by 2002:adf:b342:: with SMTP id k2mr5556244wrd.264.1613673224100;
        Thu, 18 Feb 2021 10:33:44 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 00/11] submission path cleanups and optimisation
Date:   Thu, 18 Feb 2021 18:29:36 +0000
Message-Id: <cover.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor how we do io_req_prep(), which is currently spilled across
multiple ifs and functions, that's a mess which is hard to validate.
It also cuts down amount of work we're doing during submission, where
nops(batch=32) test shows 15217 vs 16830 KIOPS, before and after
respectively.

1-6 are easy and should change nothing functionally.

7/11 cancels all the link, where currently it can be partially executed.
That happens only in some cases, and currently is not consistent. That
change alters the user visible behaviour and breaks one liburing test,
but looks like the right thing to do. (IMHO, the test is buggy in that
regard).

8/11 makes us to do one more opcode switch for where we previously
were doing io_req_defer_prep(). That includes all links, but the total
performance win, removing an extra async setup in 10/11, and just making
all the thing cleaner justifies it well enough.

Pavel Begunkov (11):
  io_uring: kill fictitious submit iteration index
  io_uring: keep io_*_prep() naming consistent
  io_uring: don't duplicate ->file check in sfr
  io_uring: move io_init_req()'s definition
  io_uring: move io_init_req() into io_submit_sqe()
  io_uring: move req link into submit_state
  io_uring: don't submit link on error
  io_uring: split sqe-prep and async setup
  io_uring: do io_*_prep() early in io_submit_sqe()
  io_uring: don't do async setup for links' heads
  io_uring: fail links more in io_submit_sqe()

 fs/io_uring.c | 460 +++++++++++++++++++++++++-------------------------
 1 file changed, 228 insertions(+), 232 deletions(-)

-- 
2.24.0

