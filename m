Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7697A2C7A42
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgK2RdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2RdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:33:07 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8005BC0613CF
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s8so11994671wrw.10
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lrdubHfSQUtAQ065SdjVNzE7aA4wyBVfaR72oij1wE=;
        b=Uyo6PEf9AI8Q9/szmaRubZuWk1azSzWyxqS9Tdv7duWIufBqStRD+wTiJB+Y5paGUx
         91IyhmIs+NOvtiVSeVPOz9xvja7XidRj+3CGm/BcbzuScvtNGvnZvfvTDq5tdKL8bbgp
         0twMx+HNW+Ph968shJmHho1wNQs00AxD8xwrPyPn2dm3dQ//UbbT+hiEBwXDuTR0zT8Q
         FhoikF2Z/lAskH6V44dORdtlkzxanbweusiZPz97Ghz92EjSDUf2/gS9TwEwzRjyowDj
         Si3SV2qyKYAZ458uEoMo3ovs4PLUWzy3jyRZckre4fF67Z2Vtm5w5YV+iVgNA28wVUHc
         vOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lrdubHfSQUtAQ065SdjVNzE7aA4wyBVfaR72oij1wE=;
        b=EVTge2aVuEe3O5Olp2b2z7O02iUpfrnBBJaRiX25i0ThQFykxe3OIoo5HiQ/Bh1j/l
         /3Navv2kZYCdEAKSWM/QB3ctXBErC3jejBBSP+yyiBad8WgnymppHY4ExF00MhMyrsGr
         JzELZhn5QnTyXDiijI70x4Mg6rGzXZ7HDcWubmITP+WNNfyyrtgGzh0gxd/tNh+yhgHm
         6a2pDqTjH6mn/PdgL9tEZUV1RtUxd2R63toJ9K4EJ8IK7TaGLgxwBmIHf0KV22lMCTjl
         k3hlLEUuiZPeE3qC6nfgf62cTdS3xhJjF1d27imq5jVzP0WTXYk4WM/z4AXympTSKetF
         FYRg==
X-Gm-Message-State: AOAM533IsW9dRnmS83dGBkDLyY4/pcmFELvhvxy3n9w33wnWypnkVbwJ
        +2kDvxGrJ371ENztR9a5BNKV5c3b6KI=
X-Google-Smtp-Source: ABdhPJwMFPJvP0pG/7dzFCM3XKYKbau9Jza4rnl1zPDye8s6+SSLDGMVLu3iql02+MDav1+SP7CN6Q==
X-Received: by 2002:a5d:654b:: with SMTP id z11mr23048418wrv.291.1606671146255;
        Sun, 29 Nov 2020 09:32:26 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id l24sm25306377wrb.28.2020.11.29.09.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:32:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] test timeout updates
Date:   Sun, 29 Nov 2020 17:29:05 +0000
Message-Id: <cover.1606670836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov (2):
  Add timeout update
  test/timeout: test timeout updates

 src/include/liburing.h          |   9 ++
 src/include/liburing/io_uring.h |   1 +
 test/timeout.c                  | 255 ++++++++++++++++++++++++++++++++
 3 files changed, 265 insertions(+)

-- 
2.24.0

