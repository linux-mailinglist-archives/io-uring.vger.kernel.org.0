Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00EE6D08C2
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjC3Oyf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjC3Oye (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CA011F;
        Thu, 30 Mar 2023 07:54:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v1so19392124wrv.1;
        Thu, 30 Mar 2023 07:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1NUshns2dscT6D5x4+uShM+Ig+SNAzrFgP7zqcTDRxs=;
        b=V+FBz09jGww1eKaFOA8kJcaU380vqkij86H7jC1nKira3uA/za6mLPBuuzUwrwIhOT
         ojDVU6dnneSn3OStz5NtEoAs0aWtOgW0eGCQBU6JEjmMep3hyf74j6g0WuJBczYUK/N8
         YE6PUu4eXTmkyi5CRpLjDetHni9mUtSt5mk7Tp2JXVvTqul67m0UxCIrnl9L/MpoIMqw
         RO25qwIRfN2vGvGPehsP3l6S8sn8oJY1Y2SoTncQjAGoj//JW2LkEoAd2rAt4/Iq37SB
         ngpguHPBEOFejD54eEyJMuartKKnfhpuYmJ+Gf/2bY34HzzuKwswCXh8P/D7w7sZeD+Z
         JCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NUshns2dscT6D5x4+uShM+Ig+SNAzrFgP7zqcTDRxs=;
        b=oQmuO7dSEta9cQ7C7zvOugaxoEpzTSALJru1LnRdEoDHD1u2oB4cZW9EaHTJLqJd0P
         N7BdB5ycMYcQiBN42sY4UVq8BuqU/3ghcdenWrKclFZSn4ACOQ7Fqqs5531ZPgdF394l
         IW+sqnEGib367N0U+u0GsE0/DTAqvYWWanjqygoQVdqFKAb/fcNFlFYT89Y68fjFObFE
         jKQynRDikC5TfAKNouA23gY9QBrc4h6coeQoNAt6rC90+tlzUhHbPu4y2puMzhayior0
         E91reyWatJfYLW4siXPbhkadmDkGEjHi2Y42eqqvspektzGRQhKmEuySOjuL2FdQUA9E
         QT4Q==
X-Gm-Message-State: AAQBX9d1tm/yxfEk1iGgA4bDM1vOVng9ZrnYSqjdEVgLDvZp6Ql6HOEO
        ZVDyVfTo7KzIlU3t9XPpIK1Kn5P7itw=
X-Google-Smtp-Source: AKy350aWFc7blt+d3YPuDzVFkWEQKraqd/OzTdCpzvJCHS34omNJSWplmKevAnHeRYzYpYZphMgj/w==
X-Received: by 2002:adf:d08f:0:b0:2e4:c0b5:fdce with SMTP id y15-20020adfd08f000000b002e4c0b5fdcemr2348736wrh.4.1680188071234;
        Thu, 30 Mar 2023 07:54:31 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [RFC 00/11] optimise registered buffer/file updates
Date:   Thu, 30 Mar 2023 15:53:18 +0100
Message-Id: <cover.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Updating registered files and buffers is a very slow operation, which
makes it not feasible for workloads with medium update frequencies.
Rework the underlying rsrc infra for greater performance and lesser
memory footprint.

The improvement is ~11x for a benchmark updating files in a loop
(1040K -> 11468K updates / sec).

The set requires a couple of patches from the 6.3 branch, for that
reason it's an RFC and will be resent after merge.

https://github.com/isilence/linux.git optimise-rsrc-update

Pavel Begunkov (11):
  io_uring/rsrc: use non-pcpu refcounts for nodes
  io_uring/rsrc: keep cached refs per node
  io_uring: don't put nodes under spinlocks
  io_uring: io_free_req() via tw
  io_uring/rsrc: protect node refs with uring_lock
  io_uring/rsrc: kill rsrc_ref_lock
  io_uring/rsrc: rename rsrc_list
  io_uring/rsrc: optimise io_rsrc_put allocation
  io_uring/rsrc: don't offload node free
  io_uring/rsrc: cache struct io_rsrc_node
  io_uring/rsrc: add lockdep sanity checks

 include/linux/io_uring_types.h |   7 +-
 io_uring/io_uring.c            |  47 ++++++----
 io_uring/rsrc.c                | 152 +++++++++++----------------------
 io_uring/rsrc.h                |  50 ++++++-----
 4 files changed, 105 insertions(+), 151 deletions(-)

-- 
2.39.1

