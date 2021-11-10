Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88144C49E
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 16:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhKJPw3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 10:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhKJPw3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 10:52:29 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7178DC061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:41 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u1so4756397wru.13
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGPYQRw/d38U+WKQeXZxtrIsF9lLNmdz8EeNxJvpBlA=;
        b=N8R1VG++rvfvdo3jSF06jh4MwRkzPP1ksHvO/OXF36iyloyIyEHkqqjxh290hLwLPz
         WaWV7tRn+PIMS6csH5umQZS+XyQ+jjGsBP9sTzFZaonozid/K+CEEh8ZOjz5+XMa0XIf
         my0qbdGybm5aHnQjMfLtTmfk6EJ9A/OuGeN63LxYuydgKLKt9iNIgcDmJm9F1lD9Yr7n
         hYiO/h2w1jHvIomqMUiUmIprEf92aIbANbpO6nL/rJcP8iH5OPgNNA9BsQTDOza/x2KD
         5ABYZKwYZnkNqviTZ77ViAZMT+gy/dK5gzvdbcdchlco7kTOk3m1jF1pKKpgTs7PL+PN
         Nr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iGPYQRw/d38U+WKQeXZxtrIsF9lLNmdz8EeNxJvpBlA=;
        b=WN/aNmXtfI9vAZtoFpneZdHbMW19ZxE72+lbUDwOhIXGDdDBW13QObhgcr9Y9Q0e2l
         18E3cA228Gb0knNErM35rbm0YEknyi9xYcnqfi77FVOFseh9g/FC5pbpKTrxRRn2RZW9
         g6AJ6P3Znx+ZbcTEWlm9QfAutk19kB5dQ5b3kts2os70/yZgWfRt1EHKoHghpn/HpS1q
         cGAzQSXwmxvYsrTe5IWmbwwSL1/TfYnhpE6OUkIh+YJIlJNxLyOF0LQxFXXMQhn4UcfF
         oVbRZ/fOv338csaBSC4Gp5gQZBnX0i95xh2mzU6wWQvqU8A/cpUEVJjMZc5pqUciHBIH
         ggmw==
X-Gm-Message-State: AOAM530OewNl+RTSgUYObvphSdiUUybzPvDo4NMDl9RGPxMmaPJnvL0N
        nc0BxA162/iwlIHUJi+VqWw+DApjPRw=
X-Google-Smtp-Source: ABdhPJx4BuQqVUqu7Ocp8EBkdNMRA8/r4WJiDV1bw0pDNAggdCgGKMmnKwAbA8THXiO4fUyqhUV5jA==
X-Received: by 2002:a5d:4443:: with SMTP id x3mr802739wrr.189.1636559379665;
        Wed, 10 Nov 2021 07:49:39 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id l15sm108820wme.47.2021.11.10.07.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:49:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 0/4] allow to skip CQE posting
Date:   Wed, 10 Nov 2021 15:49:30 +0000
Message-Id: <cover.1636559119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's expensive enough to post an CQE, and there are other
reasons to want to ignore them, e.g. for link handling and
it may just be more convenient for the userspace.

Try to cover most of the use cases with one flag. The overhead
is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
requests and a bit bloated req_set_fail(), should be bearable.

See 2/4 for the actual description of the flag.

v2: don't allow drain with the new flag (see 4/4)
    add IORING_FEAT_CQE_SKIP

Pavel Begunkov (4):
  io_uring: clean cqe filling functions
  io_uring: add option to skip CQE posting
  io_uring: don't spinlock when not posting CQEs
  io_uring: disable drain with cqe skip

 fs/io_uring.c                 | 114 +++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h |   4 ++
 2 files changed, 81 insertions(+), 37 deletions(-)

-- 
2.33.1

