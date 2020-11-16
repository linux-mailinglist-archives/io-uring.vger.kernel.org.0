Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60902B3C39
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 05:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgKPEql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 23:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgKPEqk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 23:46:40 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E04BC0613CF;
        Sun, 15 Nov 2020 20:46:40 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id 142so5018985ljj.10;
        Sun, 15 Nov 2020 20:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiFFw8zZGY52pauMdMlJ7C+qqSJV0zI5XLyCjwLxVG8=;
        b=ML0tql6h3lq5fjkMps+DkEhlc+KeXgVwHVIwUA+Adsh8nf4Y+0E3NJkAc1lPbbZpFD
         yYHe3U15EiyDf5uKzw1ygu5wHQcMalPODYEJd4COfjyEXODKuHTWJTHrOs1SA1QBZaky
         6CXWM+9G9TR1aXqb5qwRZwkkrhemj8kO4RD3rMLBROsn3TMLujcYVkdJ9e7ymuaT03Fr
         K9kCO9/gMh77ySpaH+iV5eYS+rImFN4BWNrJUCKqBCtLwiYMPu2qaCSG2GG6ujQssEru
         IzABWSsEnMD/CZ8eyYvNVUYk8/h9VH+T1h575f5wc7n62MH1bSisgadCiAfNP/zlTffe
         qrew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiFFw8zZGY52pauMdMlJ7C+qqSJV0zI5XLyCjwLxVG8=;
        b=GNpcVVyGk6TB3W1x3eB3WkruPWzz2pnuDxxEjMWhua8OqML6+EEaNz5XJZmwIRKySH
         8ycepOlpUPT3cfktzlsUmCEKJLxgcYIbwstn991+8cRSUgVS0cj9vE5Xfb7UG04wkgwu
         ThFKOBO0DpDqPe40gSpkF1iZ/CrBb+nWP83W+nmKlHpUvRZ1hioUti56i1FOBkwuJZqd
         pJzcbg8W8aln9H2bYUEpkFIAfESER9upp2vmcXCsPFkv1Rt6B1kAj4xIAvR7P4o8BYTh
         jBt86bKxX6jOpXtpCmYeQCL6YgNVXoixdxRlsk7TZvqbA73M492K7zeEYnKTjwExhQMM
         Xttg==
X-Gm-Message-State: AOAM533ZEb/+dkUiuWr0wEdQlgA7X1FS/cq3hIIdROWsR6NNNmkdBX7b
        8UWw++RELvIrvw5FRoS42Am32iCRxwXWOQ==
X-Google-Smtp-Source: ABdhPJxVwQX5xdmxAmLkQ+IZQM67yiaDthWtolAOzfl7N1mWBQdRdnCSTzuXX/q+qQ4cDckzxMml3w==
X-Received: by 2002:a2e:86c8:: with SMTP id n8mr5420282ljj.43.1605501998801;
        Sun, 15 Nov 2020 20:46:38 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id d7sm2572781lji.114.2020.11.15.20.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:46:38 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 0/2] io_uring: add mkdirat support
Date:   Mon, 16 Nov 2020 11:45:27 +0700
Message-Id: <20201116044529.1028783-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds mkdirat support to io_uring and is heavily based on recently
added renameat() / unlinkat() support.

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

Based on for-5.11/io_uring.

Dmitry Kadashev (2):
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT

 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 20 ++++++++----
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 74 insertions(+), 6 deletions(-)

-- 
2.28.0

