Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E222F128B66
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 21:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfLUUN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 15:13:28 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:44706 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfLUUN2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 15:13:28 -0500
Received: by mail-wr1-f47.google.com with SMTP id q10so12656013wrm.11;
        Sat, 21 Dec 2019 12:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YewY49XOAwtgbRRM+dP5nVDRUmX/pUzxJlp1fUg5boo=;
        b=ITBJT26HYgtPwbf6168Te/atLxFRAtSdNpkeflQI7gSTCyeH//PG6bJGBkCr45W43y
         7ZmWCcR0MaLpOCcjIrxCwnKEPhonlLaYsuJCXS0WHtSOABKzmNEAtl+X5P220Oex2aAA
         TQBICDi39CxAODjMzMQbpbg3L0ds3OAELwrCqFDv34JRwMvaDBkgcgyEPkXMkidk9qDt
         4W8XQQNb9lCR+FFutyz+M67p+7/MEjHIOPf073M+trlgseC1ukA6ze6zAUlJ54YExinH
         pzSBrfUJPSPnRVv7pYEeCbIT8mludl08xwbQEticqDpd5iDUiKT14gv6sSZySCAdagYD
         0/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YewY49XOAwtgbRRM+dP5nVDRUmX/pUzxJlp1fUg5boo=;
        b=MKJlLVFe0bu8ejjOyHhFwjPyraMVtQi1HSKNApoSQyBK6DnSVR7oMGg3nBCz9JLrYe
         to5qz2u+KkQwQf5Ar8eQ845zuwRmvz+AOwYKeJhuzyc/YESqYn0EQFWhKr2e4ZwrZ0HM
         HviMz/XzKHqpSh5lgDVxh/zl+TGzv4acchXdIz+9EKRuoSQ3uCbv3rDL5AdMRRMxCP/f
         MUMNBm9j++S7Zp0o9l9IEr7IuScCTH2I0gUyWFytcKX55Ia1zM96FJ16h6K06/lbsOyy
         ycY9So1XFbEU2EYf3yZHSV8+O+qvEigFgz7zHu/iUIfglLEmjml8JbOc0snteoWlgC5l
         L7JQ==
X-Gm-Message-State: APjAAAXjYjUZnfxwOCBHw6ghzGU6l62eenL/18WT1L2UsMp8qXw4vdCz
        Q0Mj2xJsq7lkb/HIqlz08Oc=
X-Google-Smtp-Source: APXvYqygGQW5SsTgWaiIi8noPMj5B8mAf3B2ZBWSegMJalCplWoLys/Gux5P+gVTlMf6TY6GgoNW6w==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr22981832wrs.276.1576959205632;
        Sat, 21 Dec 2019 12:13:25 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id l7sm14470821wrq.61.2019.12.21.12.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 12:13:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] optimise ctx's refs grabbing in io_uring
Date:   Sat, 21 Dec 2019 23:12:52 +0300
Message-Id: <cover.1576958402.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
References: <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
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

Pavel Begunkov (2):
  pcpu_ref: add percpu_ref_tryget_many()
  io_uring: batch getting pcpu references

 fs/io_uring.c                   | 14 ++++++++++----
 include/linux/percpu-refcount.h | 26 +++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.24.0

