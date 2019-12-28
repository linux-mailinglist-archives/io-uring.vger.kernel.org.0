Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A6712BD5F
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 12:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfL1LNk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 06:13:40 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:40616 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfL1LNk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 06:13:40 -0500
Received: by mail-wm1-f41.google.com with SMTP id t14so10273166wmi.5;
        Sat, 28 Dec 2019 03:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KElmZM5dkNAHQpTzzrjHnML4RPBEKGzTVPP1i0RJr8E=;
        b=ZeVIBTUeg+eAWruRVTTD2sDc52dRhuO1XtufRbTQ6WWy3kCgKjw+SSwflPcflZ/IzK
         j4Z5XNY0kaU43IoTsXvWJXDd65wQMAJiqQwtyjMAeGrEdLkwhHok45Ce3Kx7nFkJV4us
         xmrssh1k7RteUSB2MAXLhUn9UW/MwAPumOPG6fX1Cj874GB2V/cua6XwYiFZdcsiBBeE
         knB0ejaTWScka1/aciLT+4YCa5j2h7QjHRDfeCxEb+sUTDgRE5BX/lh68J2a79sBckFb
         0o2jJHC8zR2xtC+luLHOXz5UW6Q55s2ct0u4+Sq3XprSRDEtG02/F97zWlTK4pzgETZg
         Qg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KElmZM5dkNAHQpTzzrjHnML4RPBEKGzTVPP1i0RJr8E=;
        b=co2Ygu9080BoyNtF/gzCIPA9ximJa5vtPmwx5PPYrIdNTGTmf9+zqQxgyZnpb7qxqG
         tsSfwZr3e4neZ5bwCfrTUqKW11mbPpp11U/KHJ8cmyj1v0B8ntXZCelRxSWL7AY3Dgm2
         K/liNeTtCx0WnmW1j42+B7KSpUMf1d9c28V7O1tPCeOx2J1qimo7IfTM5J+eb/HLeQmm
         XL/b2dHWA4KtaD6lm/6oKXpMdfY7wQ3ka/aOXxhVfozTArxIIjWdcZCRWYO/hh5MI8rc
         TTfwt9/PJnnUi5W6hBont2INyEl1kaNFyRtivLDDAcJ8dEoXxtltuinpH3EbNqGz10aZ
         ycPg==
X-Gm-Message-State: APjAAAUALNUVVTAnfYP+fTYDtTdyd4ZLV+0caLYg6N617VSJa/fz3tE9
        guA+Wo8sANHIi3JRq0uXIl9zRRkI
X-Google-Smtp-Source: APXvYqwHDiWz56gLSReUATaFd7iR5Bga0tyJTpWEZW5vJa7oiLijQN3a2ZO8bnlvqdfjw0QIpQxDsA==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr23143964wmb.73.1577531618221;
        Sat, 28 Dec 2019 03:13:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id q11sm37432622wrp.24.2019.12.28.03.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 03:13:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] optimise ctx's refs grabbing in io_uring
Date:   Sat, 28 Dec 2019 14:13:01 +0300
Message-Id: <cover.1577528535.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576958402.git.asml.silence@gmail.com>
References: <cover.1576958402.git.asml.silence@gmail.com>
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

v3: drop "batching across syscalls"
    remove error handling in io_submit_sqes() from common path

v4: fix error handling

Pavel Begunkov (2):
  pcpu_ref: add percpu_ref_tryget_many()
  io_uring: batch getting pcpu references

 fs/io_uring.c                   | 26 +++++++++++++++++---------
 include/linux/percpu-refcount.h | 26 +++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 14 deletions(-)

-- 
2.24.0

