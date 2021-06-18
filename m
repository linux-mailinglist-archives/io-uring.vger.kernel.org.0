Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE973AD4DC
	for <lists+io-uring@lfdr.de>; Sat, 19 Jun 2021 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhFRWMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 18:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbhFRWMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 18:12:53 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433E7C061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 15:10:43 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id t140so12235269oih.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 15:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6wcipVC4Y7apaVNFdnySE8Ad6RbR9oXys914Rzp6vgk=;
        b=Q4Dz1ots/jsb+b9I4Z47xa5X4o1JGimcc86ZzZxijLHeQvloKVqs21tooIJLmt1G1D
         HA1CGaRSDsqmh2UZJs7lhsjXTQ6VlLQNmOGkwlF+CwWJAiW7WldIo4HQQHMtsxHHSZ9k
         n8Mvg8hxdQTghQblR3RQ6b0qVbNhXKHgZAtXSM2Fe+ffMe39LxHG50RR/HQ9wgspFin+
         Vo0Y8F8/IPg2KUlnMXZws2XzfwMthTp9if7cTR9gADY42drknXCgXOqXt8D+vodfYasE
         Qgf1FF8ad4QjMXYcdTTuBDvEOCYNP3/lXS046xnvP417gxsvNNI0lqAImdkh5ZdT4AbQ
         zGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6wcipVC4Y7apaVNFdnySE8Ad6RbR9oXys914Rzp6vgk=;
        b=uKG8UW+CB5mcNzbBCgG9L/mgnVLB+T6edQ8YSb9axcE6wrAywPDKQyK4gAJqEaizCJ
         yA/DFTNCgEuwaGnKjtQpCfM69+Q5vJadw2ty1TMuwH1iwwPgLQFbkHvFOWGGNVImS7QJ
         RcBM2BvS8WaQUUzMw/c7V79lITuOIGBr1DwntzPbDx3KjupN5TVU0Rnx+kQXKtr4nUI1
         mlzaATdiASvqjmbULBQbk6mZr8SyhQ1j6hQssSVrR6WQK+mgeRXkLKPLiFS/149RN4y7
         HzRHpo+Xoy2MZmFPqZaR9GsJh0rBmcV0sbg5lQIgxK1+KNeBJg6bUbPUzqmwOa1ORoQN
         Rj4w==
X-Gm-Message-State: AOAM532DMd/0LrkLLZwcoE2TmzqvCetdCb6CkR9UNVCZxuZcj+v1zrZS
        gPBNO1fQp8qpMsXpogkkpQ+GED+55mrNKw==
X-Google-Smtp-Source: ABdhPJwehw3i9B+9Vmty6d+xPdyi5byxbHpY7eg4IzdB8vefbArHi7OQF1Rp2DE+yED55vv5WNE8Zg==
X-Received: by 2002:aca:47d0:: with SMTP id u199mr8861703oia.12.1624054242419;
        Fri, 18 Jun 2021 15:10:42 -0700 (PDT)
Received: from p1.localdomain ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id w2sm654921oon.18.2021.06.18.15.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:10:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     samuel@codeotaku.com
Subject: [PATCH v2] Add option to ignore O_NONBLOCK for retry purposes
Date:   Fri, 18 Jun 2021 16:10:39 -0600
Message-Id: <20210618221040.91075-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

After thinking a bit more about this, I think this makes more sense to
do as a setup flag. That means that libraries/applications using it
can have this just in their setup path instead of the hot path, and
it also means that we can save precious space in the sqe flags.

Hence v2 turns this from an sqe flag into a setup flag instead, and
makes the behavior per ring rather than per sqe.

-- 
Jens Axboe


