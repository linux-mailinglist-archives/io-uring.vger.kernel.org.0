Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E016123A01
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLQW3P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:29:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37520 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfLQW3P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:29:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so170909wru.4;
        Tue, 17 Dec 2019 14:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWt3ExeYVb/xt0x3jVaJlfGbFsShLKuVbmttW51IueE=;
        b=kfM6Q0/1Gf2mZKbm46WIyfVxZK8VpBb2002YJXgoY5oY0pkQKoFYaxNeD76WBF36XZ
         JaCMcFiJ3gn2LW/ccGxtyXHZCZWMf64p4jPQb1akaVf3DmiV83a6r/Tho9FYz95HTrRn
         ZA+MNFpNqMz8t6FYPl0ff7dFWEE513WBv1IJPrd5hS+JWt+eSFHvCgxkUs/ejHneYxX9
         wyOyWBjeRQsrLdjuGqPydESb5/nmCI20QAZWucmTDo28d1D08dJcair4F7PsYHl9cZsR
         GKS9qrx1siYqFAQFZrNz9EwS1/2FLVKCuXhohG9efCPfEh7DZ7oyCu0wzbgnjcYG7lIw
         5oYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWt3ExeYVb/xt0x3jVaJlfGbFsShLKuVbmttW51IueE=;
        b=asdpZ16F/IPe03qSz5lEMsBEhRtpgqPmJ34yucAHxdKJQ9P2t8ivGGlCWHO+SQxNlu
         iO8WOtxtoajTq7uOAtA2UL+9CFi2Aod0avoe28q7pveWX1zA97PTSuh7xKfemBOPcZdZ
         2Fld93o7n8ks1zAtJyAocrip9Mo1UQVec7H4vr6I2wU0844hFWx1oDpZ6ykdSaW4m7tB
         J92MVzobEYY37uMCjxW3KDEy3MWp85BUlB7c2NTLFO/Dna2pJj7URTIzm4fTKj6PSH9S
         YzcwKrfY9oAF5h7HUimbpci2zDZrwQOonFbYgCu04yWumg/HxNbkZVUbpgDKrKex7uUI
         Dh3g==
X-Gm-Message-State: APjAAAVTcznFCHe0gLtRwO/HfJOYBiJ479jyFWEGSR/jUTNu0YkNdzcB
        Zt/bg/B7kmVuvEeXgAnWG+lTkFwt
X-Google-Smtp-Source: APXvYqzFcZxyFVGyTB2tAeBNEcsOQevIlYU6VrSNZzKtZ13+c/sgnOzRyb/Y8ic3hwjDPsp338HrMg==
X-Received: by 2002:adf:f508:: with SMTP id q8mr39712456wro.334.1576621752896;
        Tue, 17 Dec 2019 14:29:12 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id q68sm306036wme.14.2019.12.17.14.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:29:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] optimise ctx's refs grabbing in io_uring
Date:   Wed, 18 Dec 2019 01:28:37 +0300
Message-Id: <cover.1576621553.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Optimise percpu_ref_tryget() by not calling it for each request, but
batching it. This gave a measurable performance boost, though with
a bit unconventional(/unrealistic?) workload.

There is still one step to add, which is not implemented with
patchset, and will amortise the effect calls to io_uring_enter().

rebased on top of for-5.6/io_uring

Pavel Begunkov (2):
  pcpu_ref: add percpu_ref_tryget_many()
  io_uring: batch getting pcpu references

 fs/io_uring.c                   | 11 ++++++++---
 include/linux/percpu-refcount.h | 24 ++++++++++++++++++++----
 2 files changed, 28 insertions(+), 7 deletions(-)

-- 
2.24.0

