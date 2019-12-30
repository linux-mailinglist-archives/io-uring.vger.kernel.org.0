Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38412D35C
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfL3SZd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:25:33 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:33822 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfL3SZc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:25:32 -0500
Received: by mail-wm1-f50.google.com with SMTP id c127so400289wme.1
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 10:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gv6hwKDyZKaL8DEh7J4mSstLxkq4FxBrnaFcTHbe0rk=;
        b=f6FnKVTTZCIMDIBgEBmirKeWnRcpCpmjapdOnkYCmkBFt32wgb/umpTGfj2FzlVrPt
         E3QhhPfXha9XLk22bHnaoU25D9F2K47a8dTeGBd6Dx6/K1L96mMXmKL7mdNg289cCj7Y
         gE0zp0KH+hxLmbH37303TBZv/G46OCFZz5WWMmrh5ksVIDkHEH6/KLhXvVXxj+3yluzx
         b/XlzvgS4+vZF+/VnkxajJMakx5OLmsbBcs3DvG2FjL5+FTjAxwaeD9Iyroy2YaFuHR2
         oZBkYy3zFpSFpHFBWh2Rj8flEWYBl1ffHlSE3aGLVJMF0CeJGU1TaAUQjabMAPTZSI1L
         sHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gv6hwKDyZKaL8DEh7J4mSstLxkq4FxBrnaFcTHbe0rk=;
        b=ubIm04HlngcAgR85bHnpkJxrCQODbuhnt0m9XD+ITa7njfKjBvVKaHStt74edwThKB
         qQITTXAiZmDPdxfcraOT7w0z69SFKDJXuNmIXaFyg/DTDdZyukmQKQrKc1gOgsBO70fs
         c9l/5KNKNGhoHI1VDGnhgrhfHcnbeIdsFuIhM84DubLnhhEtlHmzEg4CdewqlOu3mfTt
         U3eyg174C+lQScnhgziprGNdq8LHypMOGgeOCADQEKhekEqyP56Fgf51S3q1A7tuA1YD
         9eWG0/JVNVsLLrn7KxCYrEoiM3vNilqJVxqtUt3Gap35bnk+Vp4MLSZw6j/YUQEY4kj+
         vJng==
X-Gm-Message-State: APjAAAULySQa4pZxvpT/kfdCwHpfjP5ZBFAjigfXPOsLf+1HyHHsz1o/
        FOtShxxeSbRxMFkJIBz5ouERq7y/
X-Google-Smtp-Source: APXvYqwdx5v511AE4DgCIbElWkB7ir9wyiaZ/OTuz1YAJTiCqpg0sPesRQQ23MSclh5wlQXfr80cCg==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr287568wmi.35.1577730331054;
        Mon, 30 Dec 2019 10:25:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id u24sm231590wml.10.2019.12.30.10.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:25:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] a bunch of changes for submmission path 
Date:   Mon, 30 Dec 2019 21:24:43 +0300
Message-Id: <cover.1577729827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is mostly about batching smp_load_acquire() in io_get_sqring()
with other minor changes.

Pavel Begunkov (4):
  io_uring: clamp to_submit in io_submit_sqes()
  io_uring: optimise head checks in io_get_sqring()
  io_uring: optimise commit_sqring() for common case
  io_uring: remove extra io_wq_current_is_worker()

 fs/io_uring.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

-- 
2.24.0

