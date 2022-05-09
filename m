Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA77F520195
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbiEIPyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238643AbiEIPyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:55 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F274507B
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:50:59 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id n6so7678745ili.7
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XgEoW4oMmVhh6sQOitGdyc460zF0pM4QEeVw/SsJmZM=;
        b=Y0ywXcXs7DQU0XbZQH9uhoWjqvd8Wb5g8B9xxxqWget+rW3tr8Lny3E4b28HCg2xnu
         ivNT/XsLJqU1JMHZ1NS/hOAnMtozj5/tFFsg191lnJB71WbtTsIeL2fdSmZQVjL5Tg8W
         f6I25d19Yx9sZbE4Ge5chFHksc+NPyGuLdWVcBuBnNNfg2/pDcwxx0Bk8w5ZRcR6w5gc
         EXkTecv4UGnRQ799Q5Hh6yR2oi7uRfhqyv5+x4LL2JyWxidnzLW5QSmkj9r7RLpAE97y
         0DzSRgdsCwLL93GEzZlWb5kIVAuZ20oS6LEBQg5gCMQDn41l/HIvXz0lU2tcO3oTVTwF
         APDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XgEoW4oMmVhh6sQOitGdyc460zF0pM4QEeVw/SsJmZM=;
        b=EHwgHdqRao7TKShuP3zIRSDaFtMSFAyWzn1j7zJDz9T/vdUfHdNoPle8/flFTuNMfJ
         4jQS4trhEYjt727pVZE4+aWH66HWk1kx4lcalicpibVzhg0vvrpkdL2VH2DbZjiVl2+k
         3CR9GtXaOMBpEEbIiuI5VDezgMsTsC3X54qq30aFEwAaXhcIxpFjc81fuC+wZyk0hgdu
         3JCEwqrSGKa1tiypewsLENIO7WP2/splwy+D3e+4Hb3kyaRVMdHMvngAYwyKLRB3R/+9
         9yFs9T0saeNet/Er/WOd65NgYFBAqZFdBtE5V6pgzSbeUIJGxtZtUgOR4JsrLYiLyp0u
         YAVw==
X-Gm-Message-State: AOAM532jNIC5RqBzASCQjQQGbED9IRsSUf5MYQiZLAORh4yfK5m1e6Rk
        NiXd9hFT65QvJEFj9BCMFE5EWU9HW9PN8Q==
X-Google-Smtp-Source: ABdhPJxSxsBwWK6NPh8vUC/kaqMVU22nMKX2ZitwPmHsGAS+paRSnPjST8nElRbNL3mJpxHabTz6lg==
X-Received: by 2002:a05:6e02:180d:b0:2cf:8481:4aa9 with SMTP id a13-20020a056e02180d00b002cf84814aa9mr6280407ilv.96.1652111458143;
        Mon, 09 May 2022 08:50:58 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:50:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com
Subject: [PATCHSET v2 0/6] Allow allocated direct descriptors
Date:   Mon,  9 May 2022 09:50:49 -0600
Message-Id: <20220509155055.72735-1-axboe@kernel.dk>
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

Currently using direct descriptors with open or accept requires the
application to manage the descriptor space, picking which slot to use
for any given file. However, there are cases where it's useful to just
get a direct descriptor and not care about which value it is, instead
just return it like a normal open or accept would.

This will also be useful for multishot accept support, where allocated
direct descriptors are a requirement to make that feature work with
these kinds of files.

This adds support for allocating a new fixed descriptor. This is chosen
by passing in IORING_FILE_INDEX_ALLOC as the fixed slot, which is beyond
any valid value for the file_index.

Can also be found here:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-fixed-alloc

 fs/io_uring.c                 | 113 +++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  17 ++++-
 2 files changed, 120 insertions(+), 10 deletions(-)

v2:	- Fix unnecessary clear (Hao)
	- Add define for allocating a descriptor rather than use
	  UINT_MAX.
	- Add patch bumping max file table size to 1M (from 32K)
	- Add ability to register a sparse file table upfront rather
	  then have the application pass in a big array of -1.

-- 
Jens Axboe


