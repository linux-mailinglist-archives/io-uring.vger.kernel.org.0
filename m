Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C403B4DDAFB
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbiCRNzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 09:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiCRNzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 09:55:08 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC32192362
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 7-20020a05600c228700b00385fd860f49so4868130wmf.0
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CzbJpsO65K7YCQf/Pcc+zCIwC61oTRSmu8shEEswaHE=;
        b=A0e+RpUIuBnru9Thf3bAAFnBStt5oO6L/oV/uT+MJbwE1VdQng60WDBBLXNus3ozeo
         opH388A4lxSeegWclXox+DMQ7tpq1nAZquOozW+N0wB9xEK+svvtCSUUswB0BT2FxeR/
         3Q3tR7UiPYLyI6tWg6sjWbw/uQ8eC+R5wnnQ6JKnDU8pa8TyAm9DREjrzoyYCO/SfJAp
         bcq7nHKj1hpsaQLGBLWj6/CUIxXx1wUKrc9QIh/kk0sgh5bk2UNc1WyETDnNypfgVu/O
         OKI+nxDV+4JdoWuQm7ijvHcIqmmocE56azKBSfO3K9BAALzJGl253m0ecz7VvYD6Am/T
         emmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CzbJpsO65K7YCQf/Pcc+zCIwC61oTRSmu8shEEswaHE=;
        b=iUW+oImvDIeC6LhHwP/C10jC7mau8EMJUYXAAiYYnxtQ0KRazAbFcHZjFtUCnWI2nJ
         7qTIn6xHfRLqOCDyOya/xccSDnPsc4867Opnqx5yc/KGa8s0uRMmo/2QPfbpwBHvljMe
         ro1w0fPqmnJpscLHC817Xve19jdhpwLtdVACsklMSJG6Vt8CZ4/Iiwo/FYKlgnPFUThM
         gWbL0aJqx6yuseEIpFSMZhQY2c0jsqo5Wciix01gn1oYdk9vg0RC2Jcjoi/7ltJwJg2B
         4Cq4WFux+YmS0bdTnLrgyatenjAFHguYI00mUp1x3TewlkLaC7l5wvKYzR2AzlpZHMCl
         ZTog==
X-Gm-Message-State: AOAM531+Jhmcmhj9Gx5sewaAEMqdMT6GrRLuF6vRRT5xGXUWi1I5gUru
        zO2XFbtapxNQdJ52JdwygdlVyFNaELZB1g==
X-Google-Smtp-Source: ABdhPJwe88eZkJjCbS7e8XvOLO03UZbeI36RDygsrpAJgotEpF8phLaTMdUb4t9msPPuR21MjUSr4g==
X-Received: by 2002:a05:600c:19d4:b0:389:d5d2:e90f with SMTP id u20-20020a05600c19d400b00389d5d2e90fmr8279617wmq.103.1647611627463;
        Fri, 18 Mar 2022 06:53:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b0038c8da4d9b8sm1290375wms.30.2022.03.18.06.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:53:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 0/4] completion locking optimisation feature
Date:   Fri, 18 Mar 2022 13:52:19 +0000
Message-Id: <cover.1647610155.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A WIP feature optimising out CQEs posting spinlocking for some use cases.
For a more detailed description see 4/4.

Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
QD=1, and ~+2.5% for QD=4.

Pavel Begunkov (4):
  io_uring: get rid of raw fill cqe in kill_timeout
  io_uring: get rid of raw fill_cqe in io_fail_links
  io_uring: remove raw fill_cqe from linked timeout
  io_uring: optimise compl locking for non-shared rings

 fs/io_uring.c                 | 126 ++++++++++++++++++++++------------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 85 insertions(+), 42 deletions(-)

-- 
2.35.1

