Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC5519FE67
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 21:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgDFTs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 15:48:59 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:35821 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFTs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 15:48:59 -0400
Received: by mail-pj1-f47.google.com with SMTP id g9so330279pjp.0
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 12:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vEBKpJDdeL03ofoSIQ0k+qMonHBDS06LAY8q+3Oy8+Y=;
        b=ALJsJAxm8okKIMaryBRgj+j1o8lAXw0pRBFWe93h3XlTPUD7XNdS3FFXTICWQcpIic
         JtcIebfL/AW98lrHNZIqtodT+xmjFr495rcDqRj3R43h/eSndzpB/D7IlXBq9Fcx0vR2
         A45QErxrqygsl++MOe1E3gJf1+lCBj6snJiwVXmD8ZB6CfHt2XE33WKzzgWei0G8ACz5
         LlBCEX8/aPaMR9yTsiL2jbDqV81ymR/u2AwICuwoQcL5v5S5u/aRgoOmNfeHmuZVZBzS
         Mik6kSLwgS/LtB7GIWiMpVe6TBmE9bMY81T5Y81yIA8ZcqqhBOIVq3ywhx72Ps+9Ia52
         Pptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vEBKpJDdeL03ofoSIQ0k+qMonHBDS06LAY8q+3Oy8+Y=;
        b=FxBsyxx/wLR0DwQucc5Mta/R45noTL/oXPsZH1k6kTl2+QlPO0ZCEQtWa4Xu8C6Z7z
         YqFYhtgfHdcoSoG7bMQQRdQ4LjHWyYntIqeznrDW37si8aTvTYxTmMsxtXQX9ZAC1K6t
         cdZ4e+lWZ8THy4QjKcIhDPUVmSRFQl7ZLcoOXF1hK3bIhH42lDxehFpjpvlhciCTn4DV
         dYS2fR/1tYWQD4GPLKYZxHBmm/RfEAnxmNBDUQ85UooFrDnfBkKK3Tk8WqyANhUI5p6V
         Gh3QfbMcSESKecx5haQd3obXsFB+WHJeu5rlP8vYQI+w5tFDs09jq/e9oOhurXGiWCbi
         cSgQ==
X-Gm-Message-State: AGi0PuY1R8f6NqV/L8zcziInFzGGG7JAx1mkgQZZe9i3mzN/izsCJSys
        WmmKKd6KPI4Ox80Pt0W7ICLJP5Rh536e3w==
X-Google-Smtp-Source: APiQypJQNhJJp1hpdL1crWHM+EVCs58i2nYOov76At5ll0X+rlXX1ZSl076kpVx9QT+X5xs+8wKvKg==
X-Received: by 2002:a17:902:7897:: with SMTP id q23mr8690937pll.312.1586202536244;
        Mon, 06 Apr 2020 12:48:56 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id g11sm362620pjs.17.2020.04.06.12.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:48:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org
Subject: [PATCHSET 0/4] io_uring and task_work interactions
Date:   Mon,  6 Apr 2020 13:48:49 -0600
Message-Id: <20200406194853.9896-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's a case for io_uring where we want to run the task_work on ring
exit, but we can't easily do that as we don't know if the task_works has
work, or if exit work has already been queued.

Here's two prep patches that adds a task_work_pending() helper, and
makes task_work_run() check it. Then we can remove these checks from
the caller, and we can have io_uring check if we need to run work if
it needs to on ring exit.

-- 
Jens Axboe



