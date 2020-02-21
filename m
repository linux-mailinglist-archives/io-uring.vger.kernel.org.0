Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB52168978
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgBUVqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:12 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38826 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgBUVqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so1426022plj.5
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAsTNI4w42mSOQDuUBF66Z3dDFxeIwQTQ2WWU0MMte0=;
        b=OTxLkf0Q12KF1vYdRWlIsw8FinoFVZTeB2byIu6cSuFkJUdT5O5cqeFgFetVUrGQcQ
         dlILIRwPWxAGOQugLN8Xlasa75G51nKGm/eS/5owUo5m+Nwv2dGDLLZmEl2p0M8Rw2lk
         40VTuqHF+F1F+OwBqkbj2MSU//aFB/mXuZra6TLMdCilUuZCimA8QOOUoFNHf3dn/PCn
         cDXMuBxGReSDNdlOqlMwbsOAaBA9ghrzekh0AlszYVP5Brdgn+CUPyjYIVzaDr7fnFK1
         ddTsMTYkWJSmkzmmTeY0YK1n7i99V+HhUyJug1UWi0F82zMCQdzeQt0eQw8hJDIIFsH4
         w+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAsTNI4w42mSOQDuUBF66Z3dDFxeIwQTQ2WWU0MMte0=;
        b=o5Df6EwK52T9sqOtWadmLW+qvXEjibz4OYfrFKzfug3twpuIVEkC77DomU3Ko6rszm
         zYSV2+L5SfYCPEr6J93OwNUbLXag9Z8PcaS9rvOTNhsPDWTQbmnhaRsOrsC78O3Ybw5L
         9wM9+XJDghQvDHA5kPztxmMp7Pae5bh2xz0dcSdQ0ZWtdZi61qJaoJMvEi3Ax8fX9ZI4
         X64dzQvD/BTkCKbLSEAFo3B5qj1SlkiOtKhp/YtoaqcOM/IZqq9t4AoklH8hQS4C4IiY
         z+5Oqh2FVURqO4KksYVuue2sar1BB6w7KmZZLayqah4HLLL4O+/bEiG8vWkvivaJ32D9
         dE5Q==
X-Gm-Message-State: APjAAAVzOF0kMYkrD2XRXs+QdkGufj4aSKVPr9b4i/zI5ElvaX11qcRq
        w+9TGeDC5ya43Ad8oHvPfteajAa8CbU=
X-Google-Smtp-Source: APXvYqxjS9XwDhXd16X3qlpySFdgCZshaI3CvsL4vqI9cD17dD/uswxAZNkcFgIjQJQKR77puMXIAw==
X-Received: by 2002:a17:90a:23e5:: with SMTP id g92mr5646183pje.14.1582321569712;
        Fri, 21 Feb 2020 13:46:09 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com
Subject: [PATCHSET v2 0/7]  io_uring: use polled async retry
Date:   Fri, 21 Feb 2020 14:45:59 -0700
Message-Id: <20200221214606.12533-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here's v2 of the patchset that does poll based async IO for file types
that support it. See the v1 posting here:

https://lore.kernel.org/io-uring/20200220203151.18709-1-axboe@kernel.dk/T/#u

Still need to tackle the personality change (if the user has registered
others and set it in sqe->personality), but I'm waiting on Pavel to
clean/fix the mainline setup for links. I'll rebase on that when that
is done.

Changes since v1:

- Switch to task_work and drop the sched_work part of the patchset. This
  should be much safer, as we only go into issue from a known sane state.

- Various fixes and cleanups

-- 
Jens Axboe


