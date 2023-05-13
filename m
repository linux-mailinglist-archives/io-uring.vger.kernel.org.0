Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FAD7017A5
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbjEMOQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238993AbjEMOQu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 10:16:50 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D3E7D
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:49 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-645cfeead3cso1499928b3a.1
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683987408; x=1686579408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=7M8cY9hPnKFRsU5MsI11+bFBCmfjbAIftxg3TNp0jGE=;
        b=OOqKmwhhvhk2pbWyqbL7eSC9syrweKWsDylRQj7IY7a52a0lFxWvQAgpGBYlsH5UtR
         J7Y5BTITwiTrbot5FC0wzC2jfwme258uI3sPIAvH5ZZZc2Ymy/xY21fmGutexZajvb0x
         ljEV5+CML73kg+pCf2OoAouzrIs+X8hb0NB1pQkDPBOwYbfKsfskAnS31u8zA2VYOPzs
         qI9Zt6ynw740ZaSXTPpvW7BExXwuhblrBys+nCmtQ5jWIC1IEbLCNBZbLVo8UcIi8R/y
         m46w81N7RwcREFf/0nz7H4hUqSNygRSbULFd/zlo/qxTwW7oJG6hJG7V6EtPGRKs2Swc
         Oxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683987408; x=1686579408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7M8cY9hPnKFRsU5MsI11+bFBCmfjbAIftxg3TNp0jGE=;
        b=Oylar4iyjNXBGkobvyScrQf/WvZqgF7/woAlNHDqkg7dB0tZtm54O/AbxPlOsLYSnE
         CR+sn17RklaGBqDbVYcYId4UBHyO+TfnkUIBJc+4kxlyo7oCe9KBxHZ1KMP5uEuDLXzW
         vYquiH1d4LRAyzPO9S1/7UHgT/GgR4AK1wVVSJu1m05KvyHUcYcYMkDW0jJAMB+ZJZqV
         XiIckGEuIJ7KssTfsvLLTNQeGlzF9DnXW5TyPbLapbKPLGk9qA0Lil4tm46z5whbY8sm
         ETRsSGOV2u9fGBhlI/RIBXvlyPaeye//7/5dfa9KgsZa+xQg8P8vhjDiQFAXmScZxVw8
         QI1w==
X-Gm-Message-State: AC+VfDwW10kg/GfXJOlz2auAp4MF3HilB8bKEuJvbLJJ2ATTf/H0twVG
        8bhvC95UcHvvxq38g7mH4TL/X1enJDpEZ6TugUo=
X-Google-Smtp-Source: ACHHUZ6UKwN+5LMF5Nevw1p4HTwLr5pCU5lkx1BSMg2F7LG0zetNhassVIoOrDGt8VRRXYczroD5xQ==
X-Received: by 2002:a05:6a21:33a3:b0:101:37b2:62eb with SMTP id yy35-20020a056a2133a300b0010137b262ebmr21066903pzb.5.1683987408122;
        Sat, 13 May 2023 07:16:48 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o4-20020a63f144000000b00513973a7014sm8360027pgk.12.2023.05.13.07.16.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 07:16:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4 v2] Support for mapping SQ/CQ rings into huge page
Date:   Sat, 13 May 2023 08:16:39 -0600
Message-Id: <20230513141643.1037620-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
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

io_uring SQ/CQ rings are allocated by the kernel from contigious, normal
pages, and then the application mmap()'s the rings into userspace. This
works fine, but does require contigious pages to be available for the
given SQ and CQ ring sizes. As uptime increases on a given system, so
does memory fragmentation. Entropy is invevitable.

This patchset adds support for the application passing in a pre-allocated
huge page, and then placing the rings in that. This reduces the need for
contigious pages, and also reduces the TLB pressure for larger rings.

The liburing huge.2 branch has support for using this trivially.
Applications may use the normal ring init helpers and set
IORING_SETUP_NO_MMAP, in which case a huge page will get allocated for
them and used. Or they may use io_uring_queue_init_mem() and pass in
a pre-allocated huge page, getting the amount of it used returned. This
allows placing multiple rings into a single huge page.

Changes since v1:
- Mandate that we're using a single page. May be a normal page if we
  don't need a lot of memory, or a huge page if the ring itself takes
  up more space than a single normal page.

-- 
Jens Axboe


