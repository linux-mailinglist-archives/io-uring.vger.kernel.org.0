Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9860D5507F1
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 04:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiFSCHV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 22:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiFSCHT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 22:07:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D047B6357
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:18 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cv13so4615255pjb.4
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nu77cphlgFXaV8P9RMbbQHEbUToZgStVNmO8QYefgQ0=;
        b=ycjHDTWmsIVpvyCl5T4KdgFtj/+2Z+rTnu1kY5+FqS5b9b+Ha4hKW9ON3THbG5UqTq
         CrC4Z+DL/74SJ3JKqG8sjia9JK8Rf8P/SW7XFIPfZMUHM+L+vMOf1K+/13bL4HJczWRF
         xwIOSiJOJ+MVN2jZYKCiq3XOla9tVAS8vwZuJcxOCxlp93KLP5/R/Mmkz1Pe/CfnE46a
         lXxWbt9iy8ZsWrEMLh/9cnsvpK0BT/R+/tBJZhcb0FwuAmP8iAJ3G8MEcocn0aAEQECY
         EmGMTZCV4TYqZ9+sffyx2TU36bfPanylemjXhUeJqW0o1qOn2qlULGd/3ZIEtebZXf7m
         iEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nu77cphlgFXaV8P9RMbbQHEbUToZgStVNmO8QYefgQ0=;
        b=aJ6DTIkK7FvPppABBki702U21234JKXx29h3v59rWe0gkz8JyOZ5kfhEOtLS0kIvEj
         gkZ7X4cd6caNriY+jTAKESwSKEW4pCUe9mBm1oXftTISZ4LStz/oowSgjdDw090YIm1+
         4c+V2Uo6l3DOBCJK5ZPQN2KFqU4CT3KiNc0hSQYeDKsbUxepTngb9sBtxrONsMksRA7s
         4dMbztI+AqbyUiuVW+JD3v94Axv3O0J+yXsCLUsn8q3nNM99SdvkzSwWoEdP1U1Y6Mro
         9KnXafQaMVbyrw/p+JcpJVmoW1V2zaTsorDa14qMGBWIMX0sKNc/BQgn5RWntBgPLTOq
         7R9A==
X-Gm-Message-State: AJIora9X1Lf7y8c2N7Wa9NTjBkppcR1QDtKyNIV/fM5c4Bl1kjtixuBT
        EEcmzjmZPgj+rcJgh/oZlJv3mcf7Z2YKwQ==
X-Google-Smtp-Source: AGRyM1vRi9KLbM7Y0Q6CurYmn3vsjsIikTx6Az6QP5xb9axbrQQxJpQHQkiwBo52uaew28tk9+nNlg==
X-Received: by 2002:a17:90a:65ca:b0:1e8:ae4e:69f8 with SMTP id i10-20020a17090a65ca00b001e8ae4e69f8mr29784979pjs.76.1655604437981;
        Sat, 18 Jun 2022 19:07:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0051c7038bd52sm6118598pfn.220.2022.06.18.19.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 19:07:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com
Subject: [PATCHSET RFC for-next 0/3] Add io_uring_register() based cancel
Date:   Sat, 18 Jun 2022 20:07:12 -0600
Message-Id: <20220619020715.1327556-1-axboe@kernel.dk>
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

One of the tricky parts of cancelations is work that is handled by io-wq,
and the regular cancelation API is naturally async and just returns
-EALREADY for work in that state. This means that the work cancelation
has been started, but we don't know if it's done yet.

With an async API for cancelation, we really can't do much better than
that. This leaves the application canceling work to need to wait for
a CQE from the original request.

Add a way to do sync cancel, even for io-wq. Since this isn't a natural
fit for an SQE based cancel, add it via io_uring_register(), adding a
IORING_REGISTER_SYNC_CANCEL operation. If we get -EALREADY, we wait
for completions to come in. When they do, we re-check. Once we get
-ENOENT for a lookup that previously gave us -EALREADY, we know the
targeted requests have been stopped.

By utilizing the usual ctx->cq_wait to trigger a retry of the cancel
operation, we avoid adding any kind of extra overhead to the normal
completion path and tracking specific requests.

This gives applications an easy way to cancel any kind of request, and
know that buffers associated with them will not be touched by the
kernel. This effectively returns ownership of the data back to the
application.

-- 
Jens Axboe


