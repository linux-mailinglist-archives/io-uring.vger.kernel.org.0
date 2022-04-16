Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBC503407
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiDPA2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 20:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiDPA2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 20:28:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77371193FE
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o5so8727451pjr.0
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4P9X+6trL1Yp9xlONMoyp1zCs9RLnVfaC3p4NJxdxQ=;
        b=29IA3AkhQ7zZYpbzuqNmIKT/pCSiuNUDW/oZurAvgXGmlbm6/0lt8UoovwdRSfgNVn
         72M9N2c0yfnSFEDUG5gloZBlejIj1P/O3/58vcJb+GYXF/yISC0RTCLpnV+dld6Hw5Rt
         Rz1WQiIOgsmPWszMBYV2fDNc1To+I9NmO3TwBQ/rWCwVZAWVpS9aJAaZ0L11EnSPZFmj
         OKY1fd+NxncJXRfaFA3drNdN1ue/w2zJchr5aoF3Y8OH9Avpiot5WSQR/lFZcOSuRLyM
         gNwxFUuJT/5h+KazsGxq9CN8yJ814OwkxaWTh4At2tl7aD+tuyqr36uSrQfTj+XHqOt/
         SbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4P9X+6trL1Yp9xlONMoyp1zCs9RLnVfaC3p4NJxdxQ=;
        b=2qFoHFIboQY/OsCBeXg/Figvi/6LYaMtiIiPE3xhlBJq8zxtfCFyJx711ZzZWxyW0u
         sY5eDdOXWBkdBSRFpx3HthjwoG0o1SeNZjxlERkD3Fm/OMXeE9W99+K4aWIXXNkDGGkH
         JRNDX4k5X2L4cIVdBTdnUAWUmorxZGlp/PdllM2F+rDfkdSl3m3YUdivQM2ZaIlccKYs
         8HjYc512csy/2ND08Cky8mxDgY40o9LGdiuxMf1RXMYai6toOmnlCKiixd0k7ZSqT9U0
         uUwObmXxo+nxXH694+g8rOt4/oyG8N3RyNQZ28WCATNrWcEVj0ZP9kUV+T427swOk9c2
         LTdw==
X-Gm-Message-State: AOAM530yV+Agb3WR/88AeljaKMI+a+GpcW2BaWyzb7gAoM2q0sRD4JV7
        0AfNUriH81HoaCCICTIwf1X4whIuV31IEg==
X-Google-Smtp-Source: ABdhPJyL3SzlSwlZwoCQUsdlhmzb+BDCSrqoe7xGrZhSJtCZVBPcV3BhfohjC0+AsfPYF9xCeMLKag==
X-Received: by 2002:a17:90a:d58b:b0:1cd:65dc:6a62 with SMTP id v11-20020a17090ad58b00b001cd65dc6a62mr6709389pju.89.1650068763586;
        Fri, 15 Apr 2022 17:26:03 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm3895375pfe.186.2022.04.15.17.26.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:26:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3 next 0/4] Extend cancelation support
Date:   Fri, 15 Apr 2022 18:25:57 -0600
Message-Id: <20220416002601.360026-1-axboe@kernel.dk>
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

Patch 1 is just a cleanup spotted while doing this, 2 is a prep patch,
patch 3 adds support for IORING_ASYNC_CANCEL_ALL, and finally patch 4
adds support for IORING_ASYNC_CANCEL_FD.

If IORING_ASYNC_CANCEL_ALL is set, all requests matching the given
criteria are canceled. Return value is number of requests canceled,
and 0 if none were found, or any error encountered canceling requests.

If IORING_ASYNC_CANCEL_FD is set, requests matching sqe->fd are
canceled rather than matching on sqe->addr for user_data.

v3:
- Fixup issues with CANCEL_ALL
- Combine two prep patches, and extent io_cancel_data propagation
  further.
- Get rid of buggy task_work running, we don't need it anymore.

-- 
Jens Axboe


