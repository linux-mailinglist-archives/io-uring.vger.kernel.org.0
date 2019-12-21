Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E70F128A4E
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfLUQPy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:15:54 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46672 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUQPy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:15:54 -0500
Received: by mail-wr1-f46.google.com with SMTP id z7so12252714wrl.13;
        Sat, 21 Dec 2019 08:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uWWA9BCgE+K2NQkuc50Eq4PxEQrT4ZogDuJJDySx0KY=;
        b=f1TlKUQM6/lUk71PGrO+nInax2XNJG50oWofeMLynCRSJtolr40efsW4LsA4zIf8/1
         xC+MkTgEdJmrF9aQFnGYJwQv1zndoxVsIM0gS/6X2UmTyhknmLAJ2L7bnzlqD2dJayab
         EpaX+rGsxFvN2nKm8X4RdOB4MlsQV8Y0cWDaF5BqtpRRWFnGIiNpIF6I1WY/S8a7uSEt
         xMNuqHS7fXA2DJj4Hxx0zvVaw3iFgqgx8s4EbTZrZ/pajNtF+Ye4QcexOJqJCEkQGtwq
         FnX2HI8l0t7CbMnj1XUIRwYOEI9CtElOzDibRn5eyVDwXt26f83o2bA1ufrvyh8QvEQK
         +Zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uWWA9BCgE+K2NQkuc50Eq4PxEQrT4ZogDuJJDySx0KY=;
        b=VAPuJ1kKj3fVKh9IZb9IyT877FMU5fBke6BMQsR54hmLMQ2nOWhxOzZIcUKLywrMbS
         s7DGrwqkpbYkq1iSMjT0z8fPOrqPfYPwaVM4gGjHziKRSQPARajajj2bCl8RcyHU6YpC
         IOto3WcE0G7bp4Bua6lHXFU7s8sKNkbh1a/AmOcVZ6GXo36fYY1xe17vddIvhNYsegYO
         dcBEL3rIvuaPXHYgErgAHJCpMEGNAcJ0kdJ3aVID3REWOJomgqmwALZfqH5QPg6u8MKE
         Jv0X6WR7dBCGNmFio5nSuYJkd6en/c0Mnl5N1whbQ4tTKIb5hHAa1Wmr2yGP0pUgqo7k
         OboA==
X-Gm-Message-State: APjAAAVyvzwUzktBpy8befMvCCl8/vAW4QzpvoLpWplavlUONPHQ4pZl
        3gkL7QyACVMCWfpKYg+kGQU=
X-Google-Smtp-Source: APXvYqyQkbqywsZ/+pSN3Q+6oQRcIzDb0Kfc/qx+tfWh/MW6nbyZsBc9IjeoRvifDcKJx9NpHLzHmQ==
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr22480303wro.279.1576944951783;
        Sat, 21 Dec 2019 08:15:51 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id o129sm13831260wmb.1.2019.12.21.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:15:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 0/3] optimise ctx's refs grabbing in io_uring
Date:   Sat, 21 Dec 2019 19:15:06 +0300
Message-Id: <cover.1576944502.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
References: <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Optimise percpu_ref_tryget() by not calling it for each request, but
batching it. This gave a measurable ~5% performance boost for large QD.

v2: fix uncommited plug (Jens Axboe)
    better comments for percpu_ref_tryget_many (Dennis Zhou)
    amortise across io_uring_enter() boundary

Pavel Begunkov (3):
  pcpu_ref: add percpu_ref_tryget_many()
  io_uring: batch getting pcpu references
  io_uring: batch get(ctx->ref) across submits

 fs/io_uring.c                   | 29 ++++++++++++++++++++++++++---
 include/linux/percpu-refcount.h | 26 +++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 8 deletions(-)

-- 
2.24.0

