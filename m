Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80913EC86D
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhHOJo7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhHOJo7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:44:59 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE2C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:29 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q6so7828890wrv.6
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxkC5jhYrSpwx/BSYYb3i2aa+e9ZWchjca25YJj7SFE=;
        b=TP+jTB3AmcF3j4fPmwVRssIIfK7ZYqSXakSUameTzTZslLDYNbdLUhqVOQZFT1wbDd
         erFRP0lc+ksFf1NP4Dft1711Y3fnlXs95yVuvtjSTooD+e/g/IbzJr44ML1KxXLQO0Nj
         kVDgzXWEBF+kk5rin2koSHWBi0USrNC4OMetxmxZnhFcr4EXfGg3Qg9c+q5h1NfNlR9j
         YGmaoEmbgY/BCPA5akSlGNKs4N0ubzJ5HNvhbiN1x2eCJgbdNm75Zxrk+VRnZ4EEM8IC
         iB15eU/Cn5AThJeqpTUxvTR9ZV41oeSEytcuiaeUCpVGbwnPRsJLmM3staNh5jIdUP8a
         wSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YxkC5jhYrSpwx/BSYYb3i2aa+e9ZWchjca25YJj7SFE=;
        b=MYweFio+S84+ewBpp5Gs2gsDIX73kLl3/VOq4k9PEKLb2aCe23iIhxyguEt+myQaCK
         7bWJDbGK67+Mnc8doyPjiS6iJ1nvkL2Zqu37ze6+Kr6Qx9YEwnm9CRcSGMDEHrVZkeDx
         1FY40QLNOC65hVwzifeURQZ9cmZmi1KLsP03D8aIKeChlapGm77+LO1VE9Xv7kohNfsx
         tzjwKCfWvYbRkiE9+jHu7xwgYZKaj1zeoj+5k47ac8Mqhyi9wWmed9zN9WkCWw3EyvD+
         eWoewwDCQsjAX+lpil7FceVfs7xzXJcNPCWy2LpXSWeerJTdCZ6FI+0KSARK8Yqqy2s9
         bZ1A==
X-Gm-Message-State: AOAM531J6aYDeVPEdGL6Hoj3vng8BfF3ZfcTl5mxArn/ZQEPju10J1MI
        f3GmcksAVnvWuvx11hBivxk=
X-Google-Smtp-Source: ABdhPJw1eJ6IvxbUcOlOQrEZTKjULXnvHUxn7kaml2eq3qs9YgH74XPa+BahVH23+PsZ6glqriDGGg==
X-Received: by 2002:adf:ee0f:: with SMTP id y15mr10785997wrn.353.1629020668095;
        Sun, 15 Aug 2021 02:44:28 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id i21sm7784240wrb.62.2021.08.15.02.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:44:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] update linked timeout tests
Date:   Sun, 15 Aug 2021 10:43:50 +0100
Message-Id: <cover.1629020550.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main part is 2/2, which prepares the tests for early fail
of invalid linked timeout SQE sequences.

Pavel Begunkov (2):
  tests: close pipes in link-timeout
  tests: fail early invalid linked setups

 test/link-timeout.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

-- 
2.32.0

