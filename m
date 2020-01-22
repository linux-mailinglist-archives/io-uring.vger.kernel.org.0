Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3247145CE2
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 21:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVUKb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 15:10:31 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:37358 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUKa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 15:10:30 -0500
Received: by mail-wr1-f41.google.com with SMTP id w15so476091wru.4;
        Wed, 22 Jan 2020 12:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5K7uHa4XAr0Wm5LtbVFErRG4o0kd+uyDX5OfrAJGdE=;
        b=RZBppbORZFblq4QdGqKTDSfp1yOWfgAyPPLiQTM52MTxYYS2cGbgm2KjgGzSw0krTP
         Dwby7Ip3ELev10NjJMU20USbx4LU+/MxX8+kgYQ/anY8EWW/wHSKVZLlj1zKXkE86MyH
         iHod0cOoR5GypjirmClQ7eHqSOEnu2asvnP8I8b3cDMcnpRUW7H/AuX0l4TWMUjEQi1p
         K6xwhIIg4jaHIVzHU0ozjCpQx4T3VgK1LI5vfvONTLGZyMq5IlJxPDclRx14JUi3e4hs
         j1kWDzPiZvQXw8lLkXI6BGjJ6ldkCUS/zvlqHjrDC1UffQk7w+hoo6etlrI1S6ixw/NP
         SmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5K7uHa4XAr0Wm5LtbVFErRG4o0kd+uyDX5OfrAJGdE=;
        b=fvaAQgchONB4jIN3Oh1p32gf5srmb9bw0o7/Sp+NcckqxTw3BqmylPKxKqWPYCnyXc
         p0RoLzgd3DnFLkanZBBSvY27LRNA21CkoGxBEC7oyIb0CHQ1toYOy41S3gO3SurC+nnL
         yAuLrCYmZcGEeVkQ3++bAEkPiw08aig3qwmEWdzdj0F+unz7zKI6s1ENQRvDKZTYX9jy
         IPNxdcLdP6yIPV2D2WlbOVhnU9TfmKSaFQwevmzuZalivPBrEM5qEO8nysXDhnJdXMBr
         pDFMgmNdXKeQWszjkm2iy62OEVLmk3YVR3xaDZuobAc8Cwkld9yYPRGHE8Lch9ZYTnWo
         IZTQ==
X-Gm-Message-State: APjAAAUhqygCVriwpQN0Y0DWELUtYsCyX4LN8DVYE9IL+kdD1a+u9hbf
        7IqwvBj3PUUXkFCXsD9c/6I=
X-Google-Smtp-Source: APXvYqzT5e/aJu3CpSVeJviSTWAX8Xwv2LwjexGVpLLOsxlat+WS68oNlbW+77p7ttY3yhQYeymhaw==
X-Received: by 2002:a5d:6901:: with SMTP id t1mr12387309wru.94.1579723828405;
        Wed, 22 Jan 2020 12:10:28 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b16sm5058310wmj.39.2020.01.22.12.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 12:10:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] IOSQE_ASYNC patches
Date:   Wed, 22 Jan 2020 23:09:34 +0300
Message-Id: <cover.1579723710.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are 2 problems addressed:
1. it never calls *_prep() when going through IOSQE_ASYNC path.
2. non-head linked reqs ignore IOSQE_ASYNC.

Also, there could be yet another problem, when we bypass io_issue_req()
and going straight to async.

Pavel Begunkov (2):
  io_uring: prep req when do IOSQE_ASYNC
  io_uring: honor IOSQE_ASYNC for linked reqs

 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.24.0

