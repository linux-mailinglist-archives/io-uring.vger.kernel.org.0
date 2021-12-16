Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0847769A
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhLPQFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbhLPQFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:05:41 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C78C06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:41 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q72so35762135iod.12
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tL3o525SSbhSebgjQfZMQ7uigsMTO2fDpoEDGUF4HUE=;
        b=0LEQNGb1bTHq9e+hYsc3l+U2okJ0k4nHCnm1dhpKeonjqY5/ZM5neoakgeOcnU8rMt
         pqd/Xs3gl8OfNB5zpWbbHRemeoSAhzx4OjzZC9/nUuQ5hNpz9f5iBm0955pOnS1isizS
         JAip0m3naR8v4h1fESL4IKpKKycnMHxyPGjlktYqX9o1oKPQgvGE6+BklJ58NVHSreeu
         pIxhC+CTNkzBhAgy0G4S4qMsOTW6SLnoF3binn+Y5vangPa3tr2JNByLyvb6RJlZUOSc
         Q6M4wLWZjHPSPDI/FLUA7mI2SPGwGpULFNf82V7VdpjkSXl9392Ow7vVukUVOmKvpL0U
         /eNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tL3o525SSbhSebgjQfZMQ7uigsMTO2fDpoEDGUF4HUE=;
        b=0mClI6LPNUiCFTjOBE4CIPqTOxcaPwi5pYb2Lcq3bPooLrxNLULNe9dCfYl7etSdt1
         ykBJDOPejlfKarld3SoI3ovnj73/SwrTosv/Ysu8d5VX5oDSTy5OHE6hMUQz2dwjocbu
         Ta8jGoDODCQ4eLMY93yvxUkO8lgu1QIA4zDrwXMJFFt5mEiJfTFRcs5V7i8hJa3cFFQp
         ZwaFOTR1OL12LIXrzsWJmQKttK9Zbr3COSDe5nikGigIT7jbe50OfMOOMphZNyWxyhGW
         shSfQgpdm5MZN1I9OkE7b/tgy/YBMkGNTpyOy5fmBqg/mE05HwIBkZnKK12CAXKAdlz5
         dB1g==
X-Gm-Message-State: AOAM532C+yJqjYNCdaOntfCdfAFyAcKVaYdG4aMRSFhBLDjaH1XhFft+
        vLG/IxZCc+i00QG+1Yn//vPTmX6FhrFwjg==
X-Google-Smtp-Source: ABdhPJyX8QJ18MhgVKKInSNZnCJnXEn3TufvHX3LuCasO/H2/ZZH4vXTozIHee1wM/MvTcWLkJaRoA==
X-Received: by 2002:a05:6638:3381:: with SMTP id h1mr10264337jav.176.1639670740358;
        Thu, 16 Dec 2021 08:05:40 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm3237155ild.14.2021.12.16.08.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:05:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCHSET v4 0/4] Add support for list issue
Date:   Thu, 16 Dec 2021 09:05:33 -0700
Message-Id: <20211216160537.73236-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the support in 5.16-rc1 for allocating and completing batches of
IO, the one missing piece is passing down a list of requests for issue.
Drivers can take advantage of this by defining an mq_ops->queue_rqs()
hook.

This implements it for NVMe, allowing copy of multiple commands in one
swoop.

This is good for around a 500K IOPS/core improvement in my testing,
which is around a 5-6% improvement in efficiency.

Note to Christoph - I kept the copy helper, since it's used in 3
spots and I _think_ you ended up being fine with that...

Changes since v3:
- Use nvme_sq_copy_cmd() in nvme_submit_cmds()
- Add reviewed-by's

-- 
Jens Axboe


