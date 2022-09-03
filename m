Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669C95ABFE0
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiICQwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Sep 2022 12:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiICQwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Sep 2022 12:52:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D15C4B0DF
        for <io-uring@vger.kernel.org>; Sat,  3 Sep 2022 09:52:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f24so4780787plr.1
        for <io-uring@vger.kernel.org>; Sat, 03 Sep 2022 09:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5D5D6/CHhv9p8YXOStWAJgHrTy31iceKcN/3L1QGSoU=;
        b=CvdG9Yxz+UldSU/gmh7eD/BOZ3mcsIJS8m7H3Qa6ATmx/rZ4k1HZ/fjO8XkWe2mb8e
         /3Q6H/eaTBqnRHqWQ3VcrtVPQbpART2yCSny6TeadTnXx7ghFjhK0/kHbJP84Xz7Kgsx
         NqRqXI3Wab3rs44XiMXooCcQ18uMVy7jxPFS5VDdapP4WCj1rdC/sAB/RZWYATqID+w9
         tpWSbEyGPLmc6yxo1OByoVIm6MvNrqvIXcoRinnuF0eH8+ljNgJj+8GoadQhXH3q/E0t
         SpqBs/2heOmeWAZJ3Rq37apAyu7yoTNS7QEelhlkBrqEh8ZCfi4fArjYzTe33jziWBLe
         759w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5D5D6/CHhv9p8YXOStWAJgHrTy31iceKcN/3L1QGSoU=;
        b=xIVA1iF+ZuntBNoyXtT2+njjBlv77Ttiw6m2aOoLhh4aS3KD1UR1h9zLrP4TvwYIzR
         ObeCmp1EP1betKYTuq0YgGeS6Wp/k9F0+HpyvgZ0gnv0of8xauZIQueyKQVrgP7AiKjS
         bWAQf0XKoCsavllmzl/QBxro8QwkAKweaH1QDdhE7ixdtZHVUJeP0LCcdkweP89qj+qG
         8/2sDlAttadEwoui0y/HT+5iMI4sf9AnN3C2fXFS+59ia0+4JYbmxFHygq09toPdpo2F
         qzAFYJ4gHcjlhQWskLsUZcOBcdQ6goaYx/tRHD/FMMoJSracaux6cHE7k2psjLNEqyS5
         IGSQ==
X-Gm-Message-State: ACgBeo2nxyyiq1as9A8f0wC/1CPjgNWf94YOzUVFDXdP654gysI2IKoS
        uyczI2b6BnDb8OXpzxy+1DJ2q8AWQJfUKQ==
X-Google-Smtp-Source: AA6agR4hf8Ld5/jfn+jgx3oC+L5QbXlHOa+ym2IkaG2pjCJaNcKjz0KizSR0eOY+8fiH++DgAsXZwQ==
X-Received: by 2002:a17:902:6b88:b0:173:c1:691b with SMTP id p8-20020a1709026b8800b0017300c1691bmr41445020plk.18.1662223957645;
        Sat, 03 Sep 2022 09:52:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b005289a50e4c2sm4187296pfb.23.2022.09.03.09.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 09:52:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com
Subject: [PATCHSET v2 0/4] Fixups/improvements for iopoll passthrough
Date:   Sat,  3 Sep 2022 10:52:30 -0600
Message-Id: <20220903165234.210547-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

A mix of cleanups and fixes for the passthrough iopoll support.

1) Cleanup the io_uring iopoll checking, making sure we never mix
   types.

2) Prep patch for getting local task_work run efficiently for iopoll.

3) Fixup io_uring iopoll for local task_work.

4) Let's not add an ->uring_cmd_iopoll() handler with a type we know
   we have to change, once we support batching. And more importantly,
   pass in the poll flags.

Since v1:
- Fix some of patch 4 bleeding into patch 1
- Drop nvme patch, add the two io_uring iopoll patches instead

-- 
Jens Axboe


