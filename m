Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3B7533300
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbiEXVhe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiEXVhd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:33 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D47C173
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id a38so14475055pgl.9
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1h2MEavcVsPNrn4otZ0Wd+TcgG0TuC5F0zoxoBVX9q8=;
        b=hCz2QRMiFrjol5ArFuE1dCkwb4WiAeGmHwEn794GNFlKhb5SE6gQclYCMIx3Eshhzg
         xHc03ve85Du9zezB/w5AdobEvuI05oNH0wqYalrfivtHzr6ICTguWxQuTQNFmvWypNvo
         X/y2hJK8TaxblYQQY2kd0IXxbrm3FtI/7nycNoSgv19leihMNvmObre/eblMm7S4zoTA
         e9jiIrsQOKJN7PrZJTgFUEYtwt7oFIDjradSTVOm6ir2sPKEQxbqiFBNeXlqtOpku7ST
         5vyvN/5gIMxy8QRhiclHiLGIEW12oQUlqlrlHnVtTfGyf+5VWHlRhD3wrYRQP8Xqtzkc
         yN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1h2MEavcVsPNrn4otZ0Wd+TcgG0TuC5F0zoxoBVX9q8=;
        b=asHL3K1680pA4BLvQCFmEzHeKwM6f3sYoHjyk+MDcm3VNfzst8OrygtTmCum2zrukU
         gk/Xv2mmTndif+Fq2rqJboR1/iep8GkbQgKbhAuQa3fsf/u6hS5gAcrK8afq924P87AS
         lxaO02rPFsIUvtJPfrM1dn/MD/ReHXxLkP+Fum3GnTWwEiJ+9Mvzt9rmoF4hALmzOkKP
         A0a2vNuqGRwGqDkKKNN49fVor4wN7Zkl0L6NyiQdhwXyG6ELWsc43hngAmJADw0zAAAG
         iPba7AD4cuHDu99VuS8ht4O786hYrzRjJDomxB5yoXdqKRwYUt3YUTrbF0+FFfrWvVnZ
         4Ttg==
X-Gm-Message-State: AOAM531LZFiDKJ8mA3qca2hP/Ry5L3Zl6F5TwthOlBdk7MOFT4DYc4+9
        pEucskJ4xga8J1HehSRaScKYsCLUXwiOVw==
X-Google-Smtp-Source: ABdhPJxLlm6k8V7F1lacvSIc2/oQWlNFfpzhtIczSfikRLZJcaFbQyXM4dKYT+E8mFHdHO43YoOqPg==
X-Received: by 2002:a05:6a00:124c:b0:518:cbfa:c0f6 with SMTP id u12-20020a056a00124c00b00518cbfac0f6mr4580971pfi.85.1653428250821;
        Tue, 24 May 2022 14:37:30 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Misc cleanups
Date:   Tue, 24 May 2022 15:37:21 -0600
Message-Id: <20220524213727.409630-1-axboe@kernel.dk>
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

Just a few minor consistency fixups that I found while starting the
io_uring.c move and split. Aiming to put these into 5.19 to avoid
any extra hassle on the 5.20 front.

-- 
Jens Axboe


