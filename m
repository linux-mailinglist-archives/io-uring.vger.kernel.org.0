Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD6541F2AA
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJARJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJARJd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:09:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07606C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:07:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l7so13547450edq.3
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+H8c2CDAUkrp9HPEuec6UBYVPQyY356t5wNbQ4pgOA=;
        b=D6Azk2eeDSHV8MERks5VuMlTRlojM7O62Uv+zs/cmkZi2Vc6zNKx+1ak2RXF9Es0tg
         Z7MMx3QvS87TVBE87ZMI2YfQjWZGH8QjsyIGD1q9dx7q9IBCQDHfTSKPYOOmbjPO7cBC
         EUP7YJCUvl0BrzNsD4KcuLdjyBXGTHFQJ20NodSLdglzP0J3j61/+yqEI6ndMV406OGa
         ZGsrbfHICvhCGx3qaZKCDQNxUUJ5o4IkZQRSyjUOTJWVXfPnJdY+hjayvoUyhPrju7QM
         YqoPokE3DRLFCegMX1/f3DLAQEb1PtGa1lx2LKjiGE3fDXWBtqEXM064ZfNtB+WUDBVI
         qNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+H8c2CDAUkrp9HPEuec6UBYVPQyY356t5wNbQ4pgOA=;
        b=xeiRR4skWiDRFi1fKi+ayqDjJQgIzWEdylMT0CRW+tO48sOKlRxDdScDmujkVYbDrN
         gCZZnqQuIuP+EA5yC9jeTRRdcEGuS2rEqBYwUEJAY+1OuNE03MfsOunIRJkYVpvLOAip
         BEjt2GEbWcqCmVqDBS1k/aFfUIhs9/DgsK/L9GBLGhkU066g1exrRjZVwOjTRUOhPeG4
         WvkecV+ssAj1w5gg0zN4ljfj+uHDN2veeONUkbGMGmwEuLCgqquoIeLVPgqi/T7Ev0xz
         r5LxA90/xTyIN6zdZHghMj+f3i+7OnDQlvabb0X/rdRCro21uqCS1dp+Yv4gCBN59qHZ
         rfhA==
X-Gm-Message-State: AOAM532MGxjksfsF3onXRy5fFKhZv+U4CgOygIudfFjiDDucZzjj4AcE
        4HSoak/cvU/dnHznyN212WPBBPxmlbI=
X-Google-Smtp-Source: ABdhPJyaxUF37tB3Vxciv+nAt3aDOrybiWrerm7bZKeS2MTEq5hkb67POoR8+QsXgEMUOBIbXCPbgw==
X-Received: by 2002:a17:906:32d6:: with SMTP id k22mr7453791ejk.228.1633108067618;
        Fri, 01 Oct 2021 10:07:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id y93sm3604480ede.42.2021.10.01.10.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:07:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 0/4] small cleanups for-next
Date:   Fri,  1 Oct 2021 18:06:59 +0100
Message-Id: <cover.1633107393.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 cleans up after drain patches.

4/4 restructures storing selected buffers, gets rid of aliasing it
with rw.addr in particular.

Pavel Begunkov (4):
  io_uring: extra a helper for drain init
  io_uring: don't return from io_drain_req()
  io_uring: init opcode in io_init_req()
  io_uring: clean up buffer select

 fs/io_uring.c | 142 ++++++++++++++++++--------------------------------
 1 file changed, 52 insertions(+), 90 deletions(-)

-- 
2.33.0

