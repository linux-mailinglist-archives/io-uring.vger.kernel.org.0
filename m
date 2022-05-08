Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E8351F221
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 03:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiEIB3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 21:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiEHXxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 19:53:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E71BF4C
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 16:49:13 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so12323153plr.9
        for <io-uring@vger.kernel.org>; Sun, 08 May 2022 16:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Fupl+SCGDvM2K2OfzeeG6qoDsr1ZXwc03tvoRQKG3I=;
        b=00SECuPjNfedL5OsSEmSIp/8NKBxEohqcM/aanatEFEBnc2kyPrMuDBtAsQhZA8+JH
         4C71RWyNoCphoea8zmLAqcvs66BrczidYnEgRBz39tfGCv9ZtPcjmSDIaXf9qQAIR32+
         RgnrRqfwUvz2A4BU9VDRNwRCB0hn9u4yk0N+bNOPpVTyefY5fu6OEyc+b5YE0OJ68ccL
         A819tEyCxNjJqbbocIMc9VGS3iwmTAuuFcm+6GYILyiPxczJVLHV0kjP3sSCp9mR2PVC
         DGUz2NqEL078I053WntV886mHsucOvJOsVeAP7OH2iPf3qpGIj/5Owd5YzyOBgxCpfLL
         un5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Fupl+SCGDvM2K2OfzeeG6qoDsr1ZXwc03tvoRQKG3I=;
        b=L+9cJkGdX9NDiIWAyEsNSQj5ClINjkJosjhj9qW5ZV6qFqy+grOrpNLLWtAILbTJKv
         rwQqplYmTykbHmnJO2c3y11AXjL1wuwDYV455OzlLQjLok4pd7dHEMTkYmeIhk+PSzOn
         Nib0TRtcpFQ6SY5AeQRyQAAIIVrhfhAPRtiglDxEBOVtyA4WyKj9ERiajcnAe7gHZPX3
         RId8mfXLBghJ2cNkH5LM4v1UtsqNn2h83oplcWLzzRLAWtUpekmnkpwGS8vgE9pLJQ1e
         Q+fR2iBADWCgnzfK4WKCLlkpPVifcARjC3PZhrCXNW3DFvIkRLvDJN+D4Goi6BS+OCCH
         GnNQ==
X-Gm-Message-State: AOAM533AMYzGjtctWAgLh2JFucZLF5NA62wa7K517W8jr+7bTzllsM/0
        LZL90OB0uyL4Oz0ubCG8b0BCsCGILSVocNcn
X-Google-Smtp-Source: ABdhPJwlX6JqmS1lbwhdDFq8qgF6k2MbqtypLjdaaWwL2frocoVCIGwzqeZrhnLf75KlckC5S5Uqqw==
X-Received: by 2002:a17:90b:1d11:b0:1dc:5dd1:b50e with SMTP id on17-20020a17090b1d1100b001dc5dd1b50emr23092729pjb.218.1652053752825;
        Sun, 08 May 2022 16:49:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a170902ccd100b0015e8d4eb2a2sm5675249ple.236.2022.05.08.16.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 16:49:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com
Subject: [PATCHSET 0/4] Allow allocated direct descriptors
Date:   Sun,  8 May 2022 17:49:05 -0600
Message-Id: <20220508234909.224108-1-axboe@kernel.dk>
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
by passing in UINT_MAX as the fixed slot, which otherwise has a limit
of INT_MAX like any file descriptor does.

 fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
  1 file changed, 94 insertions(+), 6 deletions(-)

-- 
Jens Axboe


