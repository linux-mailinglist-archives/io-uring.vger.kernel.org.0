Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066045EB5F1
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiIZXqB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIZXqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:46:00 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB578A1DB
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:45:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i203-20020a1c3bd4000000b003b3df9a5ecbso8446208wma.1
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Ln0tqQKEIspgHuSGFen/MH/4w6Xs06LflA4mqhUYAkc=;
        b=N5jOu9gGa6T1e0EoVudy1HJVbRYNXv6oAZWLmjydc0NG/HRZ+JLtHkVv35fGZUC4Bd
         oJiobCerouRKdXpLQog7zu3jFb6l5IT+avqtd10MarYXJcY3tNzfVl+q5ju34Z/ixYjr
         +j6PRvFSJSnTTjIV1gsAUjvILcGvcfp8yW3thu6dg/fvdYN7UfhTnhnY7no3TQOUZPVe
         MkGc1MWGTCjTXMxewwZgVkaS7al/ybe7iBrW4YoJeqx9wqw4pAmU/jNvVa9N7ox+P8CN
         RvqrdNN0xqE/cFiSQkT4T3GXxH5OROVUVBEN/rkXDClKQv2CBo6oiBr7OPw7r/hvbT0P
         k+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Ln0tqQKEIspgHuSGFen/MH/4w6Xs06LflA4mqhUYAkc=;
        b=y/6OW+wg0W4MCrRhgx+APATxHWOacwFUcVMtNOmRuLolURnsEVmri3exE4amsP95tx
         AA/pXnHWqHrC5gX7KwS5zVY+Au/S2ZkWBvbJG2jTDX/hV63oUkhBoTHIZ3/RyLUzSeF/
         G1XVMIjuUxKYRsi+dbA8Xe8ct1Hcoe5A95PNjw8AJIOHkmc20bxxyYcam5lDrlZF8X+9
         WCcd4PqbORyNBw65mFmFBXYtJarHufGok2ItK/liqC5hsfvPCNMf5ktX4yKDbDi0DFMC
         25e/gSCC+yOZ4XyNJ+JHoaKUhFn0RUC8Ekc/s8eJysN67FVcByY0JjaVrs/98W5S8g++
         kNKQ==
X-Gm-Message-State: ACrzQf15beGupMEGgrsQWWXTlCF2EOAZbDC1KaZ+5yTUBCuvW0Xr4GW9
        8VR0Dtwp8F9+hJ3pRLAhnEuKKsbwCWQ=
X-Google-Smtp-Source: AMsMyM7FF6rtM84rj3Kr21fnClMo7YDTGSNRQujpxy8p22q4HRJ9VRq/XGeHSLWj7elSeVeVWbXDVQ==
X-Received: by 2002:a1c:721a:0:b0:3b4:641c:5d99 with SMTP id n26-20020a1c721a000000b003b4641c5d99mr692767wmc.71.1664235957853;
        Mon, 26 Sep 2022 16:45:57 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600012d000b0022abd7d57b1sm89318wrx.115.2022.09.26.16.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:45:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 0/2] rw link fixes
Date:   Tue, 27 Sep 2022 00:44:38 +0100
Message-Id: <cover.1664235732.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 fixes an unexpected link breakage issue with reads.
2/2 makes pre-retry setup fails a bit nicer.

v2: rebase and add tested-by

Pavel Begunkov (2):
  io_uring/rw: fix unexpected link breakage
  io_uring/rw: don't lose short results on io_setup_async_rw()

 io_uring/rw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.37.2

