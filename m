Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B5502B00
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354017AbiDONiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241388AbiDONfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:35:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF065782
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so8354772pjk.4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zW5PKhbRiNKQ7QNAaswGrb8ecjjfFrFyu3rZlve2EP8=;
        b=Acx32PoC61crqfnuuu3QppESoPT9GGFS1MQ1mvxvRiVd6G/ZzcjffcZelcclBdy5Nf
         fV/frGiiIYFgoNAQSV35H0tmoYxM++BwVtk+ZSRlDxlLWpfXPb3Wu4zyfjxl12ZdH8zT
         Oeyasx4X1iFhwXbL/maSSW9omgGvMXmJKX6fl5scdPqvKHkE39FwSoClBXi9RbyY1h2Y
         MRyBKKitUZYNrxYmeXU2oxb8BIG9DvotmIqX3OB5DwdPEXy8RvqAQidzoaskcts840aU
         7R00H56jhqJbG09ICDCA2rWa7WAjNZmsInN2Py89I7f/ON/a+DhLBjjUWCDQAw+5XbjW
         oEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zW5PKhbRiNKQ7QNAaswGrb8ecjjfFrFyu3rZlve2EP8=;
        b=nL1ao/aj3m+z5cKpDopW5Ebo9sfrBb4WRD7A9Ef/jxlqP825ikItGCgJT0OTl8/w81
         sGumkDvcduSY1SbCoj+XQAS4iw8DhXDKJTeTVj46CcYvm2aWFDeYKZ002ZCaCJHjbT+Y
         7XtiRaD2mZev7kquxYjkTch5SZHgoHcBeZ7JAOxDfjMeCyH2soOXmg1pRMe4E/XD8fmY
         3KBgPpQg39VVyVs7HIzjLdcoo4o43aDupH5Omj4mhZQJgmtRUW9vAGCGCnJZBQHE2+2b
         YMjYRE4I0qt7jnproF1cc3uApbuUNfOyNLJIJRjjG3fiHDV0JciF4P9Dc4/lpiM1GRxy
         SN8g==
X-Gm-Message-State: AOAM5312bNfCup4jy3XI+6P4vOYomyBatUNsqHj2Agdmoxp0FxGjnPAm
        4c5bVncf+qEam0CXa5kCpOZixZFwCGwk8A==
X-Google-Smtp-Source: ABdhPJxwof9JaJUojPYJZmw0ZDSrh4ZNjx6p558O/6TcGlNAeBQCmsG6+L8kg8myqC5DE48UDCtTPg==
X-Received: by 2002:a17:902:d487:b0:158:324c:e8c1 with SMTP id c7-20020a170902d48700b00158324ce8c1mr32805908plg.83.1650029602291;
        Fri, 15 Apr 2022 06:33:22 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET next 0/5] Extend cancelation support
Date:   Fri, 15 Apr 2022 07:33:14 -0600
Message-Id: <20220415133319.75077-1-axboe@kernel.dk>
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

We currently only support looking up and canceling requests based on
the user_data of the original request. Sometimes it can be useful to
instead key off the fd used in the original request, eg if a socket
goes away.

Patch 1 is just a cleanup spotted while doing this, 2+3 are prep patches,
patch 4 adds support for IORING_ASYNC_CANCEL_ALL, and finally patch 5
adds support for IORING_ASYNC_CANCEL_FD.

If IORING_ASYNC_CANCEL_ALL is set, all requests matching the given
criteria are canceled. Return value is -ENOENT if none were found, or
a positive return indicating how many requests were found and canceled.

If IORING_ASYNC_CANCEL_FD is set, requests matching sqe->fd are
canceled rather than matching on sqe->addr for user_data.

v2:
- Add IORING_ASYNC_CANCEL_ALL
- Minor fixes for IORING_ASYNC_CANCEL_FD

-- 
Jens Axboe


