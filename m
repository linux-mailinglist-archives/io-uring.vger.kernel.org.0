Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D4D3AD5F7
	for <lists+io-uring@lfdr.de>; Sat, 19 Jun 2021 01:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhFRXeu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 19:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234509AbhFRXeu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 19:34:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA0DC061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 16:32:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y13-20020a1c4b0d0000b02901c20173e165so6647042wma.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 16:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oHjG6O3MSWf/PT8LVivNH5Io50OoOczl3WgpEGgaQg=;
        b=g71FzcrwZ2ezp9GsMr3H6reEgoIEYSmXSIwxPTKtOVuNbrgu/EnWPs+BJMR/QEa4RA
         KPqDPE2eT6o8TMUVsd72+Q6spSEWGD3/8oMT30EEYGCXUxr6yIKucJsjjd/4gFiMwQFc
         6WZOOv2U8aBfkd1ANqKxYENEO7JjbjWSa/sE3J5BhchJMSDyIULOyC1i3n2YXgGhxb6U
         gJxo4yC8xLw5H7hdv9jR2S1vIivUD8yhvqmoDa1+xu2X4c7vCFgLTSeq/i9pb26oPIvL
         IUe/ulcUVyXr3WAxjqbvtpBSoql9QfG3LTHZuGiT3L2dZcHVNlALkwia+K8dW+8XRyY5
         S4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7oHjG6O3MSWf/PT8LVivNH5Io50OoOczl3WgpEGgaQg=;
        b=MpkNybgWo+Hi+dV+tBhyeRT27sbRLX+nWOAC5zgal2a+Nqp/CCwOB1e+Aj5t3E8Hjb
         0Fhg+kyhrG1CHEDeAkXrgFlcvPFXYe7BV1wfT4e5mAYUkECV/3AO1JAH+Redb3FWLoxQ
         3H/v3UY5IMkbMlObo1uU87z4o31dM0oQRu4XyjyRiB2YwvPdyf8pJaqX2ES2kCiGm5Nu
         38p0+5gOzQAUCWmDKgmjho1TYwmJghlMxfZ0Ygh7C2LisKahyLYqchIroMPtQOoKhVVe
         3xO9yks5k0B2tcYIl0K+Dh/4tZFg5hMKwSsNgh0fXPbUK6f0cd4COQgGZ1CrkQBKPi8s
         zCew==
X-Gm-Message-State: AOAM53135Ba6F1O9OpmY56m7vx2ctWs9luU/Z4q3sD7qlI6C+bNONd4q
        kIa0pefxGcx8995TkOdmHblSlLGcJs2uoA==
X-Google-Smtp-Source: ABdhPJw8uYHW4Sxyafn4u7oXf68OIvJMwko4kjt9d8JcEjSZuAhKCt6CczxazU8swICJijmdP0XH6Q==
X-Received: by 2002:a1c:40c3:: with SMTP id n186mr13920786wma.52.1624059157664;
        Fri, 18 Jun 2021 16:32:37 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id o20sm11765774wms.3.2021.06.18.16.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 16:32:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/2] kvmalloc reg file table
Date:   Sat, 19 Jun 2021 00:32:15 +0100
Message-Id: <cover.1624058853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As mentioned before, couldn't get numbers due to huge performance
jumps between reboots outweighting any gains of this series, so
sending just as an RFC.

Jens, sorry for pestering, but if you will be doing benchmarking,
can you compare how it is with the 1/2?
2/2 clearly slashes some extra cycles.

Pavel Begunkov (2):
  io_uring: use kvmalloc for fixed files
  io_uring: inline fixed part of io_file_get()

 fs/io_uring.c | 98 +++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

-- 
2.31.1

