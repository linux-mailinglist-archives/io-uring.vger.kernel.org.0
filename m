Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE53C35793D
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 02:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhDHA7G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 20:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHA7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 20:59:06 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AA1C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 17:58:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q26so228342wrz.9
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 17:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9NwueN5H2dzYWnowmnl7VR1K0xvYEcTdUdMoCfBRG0g=;
        b=eE6WEKSBymiUlYJySVbBMgnggJx9SgsOSFRnW+wf/vEWtGEPWF4TFlz95K0yWu/t4v
         qnyizI3Pei0e+Oo7DwROkCm/sYxu+hKz5fipY/N67zuXLYeUK8NCY/a1K1qWOxPNlNot
         ic7+O4DEhkWnqindrn+1L8jyGSVYYS5RULdrNmvm6Au79tzVMCBJAFjw7UXzXT+Ack8I
         fl/0A1o7ez1XsWkG+72gQcfy9mWRhbc/+cirsaSUQXgFrwOs5ipsl+BlUMzsMoObaROB
         34AgwYEgCK1sP0+LVNm63cmEoh+dyLt6oRLlK5SbrKDE49Nfii0i55fPm8KQhXDYk5Dx
         89cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9NwueN5H2dzYWnowmnl7VR1K0xvYEcTdUdMoCfBRG0g=;
        b=NR1JA+EzpTO6fE5ZYmZIqvu1qH9XfewWjtiMamJEch29BLAyz4CvG724L2a8vQPJUW
         ETBkOocrdEVzeBecnBya+na3CGmyR8Z3iVRNiOe4YU21t+a1/bYjT97zFuY9OLP2bT0s
         p5Ov5L0iEIvte9PSvlGla4ngzrL8G1LYBdyRQCy2p20Du7PL2BvnTmPQGsqA18xu3FqH
         wTNdDacse1/LWwX2s9ijnQ+luDlXs0oaB0lqYJ3ygVKdAfAS4kimXfeC4HFoDQtx7Tgd
         7aGNtzbfCadWr7j0+JM2iNp5j41LI3nEtMCJfimouB7gHXsUQz2McCJOmiu/+uQIBh4L
         Gfpw==
X-Gm-Message-State: AOAM5309WKvbWqMfUcY2qMqsrkgta6Sz8SzQzDl2Q4DYZkD5NjJBmtwE
        oXwk+jXcXgbUTJX4f7vAXbSZpzXWm4Azmw==
X-Google-Smtp-Source: ABdhPJwnzCqTM40y/dh+yYUCRB27L3zYVAOEd1rVXF5X85uAVcvl+RoY77ijyw6sw1dHoUR3UZSnPw==
X-Received: by 2002:a5d:6550:: with SMTP id z16mr7586730wrv.366.1617843534798;
        Wed, 07 Apr 2021 17:58:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id s9sm12219287wmh.31.2021.04.07.17.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 17:58:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/4] 5.12 fixes
Date:   Thu,  8 Apr 2021 01:54:38 +0100
Message-Id: <cover.1617842918.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 fix REQ_F_REISSUE,
3/4 is one of poll fixes, more will be sent separately

Long discussed 4/4 is actually fixes something, not sure what's
the exact reason for hangs, but maybe we'll find out later.
Easily reproducible by while(1) ./lfs-openat; and also reported
by Joakim Hassila.

Pavel Begunkov (4):
  io_uring: clear F_REISSUE right after getting it
  io_uring: fix rw req completion
  io_uring: fix poll_rewait racing for ->canceled
  io-wq: cancel unbounded works on io-wq destroy

 fs/io-wq.c    |  4 ++++
 fs/io_uring.c | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.24.0

