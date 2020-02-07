Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B29155B06
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 16:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgBGPup (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 10:50:45 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:40277 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgBGPup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 10:50:45 -0500
Received: by mail-io1-f54.google.com with SMTP id x1so2672733iop.7
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 07:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FKT0gUc2nqzuxX556wQEvBkIjDF/fVZrp3euBZf5N1g=;
        b=Cbj/BGuz9SucJovJjBaDZqi7ESHzZKpmxT8gqj0jN+8FP+pGOzkTtQ0bvyHHp05nF0
         eZuLCvJQ9dIPRtpDwUCyJtsYiCyCySNhuQshe57QVXtzuIEJF4M/jGGZTtowCyQEQ7s1
         3djH8I9sFE8VrfGXcdRk/uPOszihN06VYeWg5vBKEj0Xbvq6MHHEh2eVAhRc6V7JiSBS
         FTmCZQ68F8EKK0gZimKC47l8s/95GZ7Fi4WXPS7ReIH4VWI5WNNMNfuRrQ6UdikoCb79
         /gGXb8VnguRTt3EAlV67NL1Jx0S0O/Mo+b4BewYKHz2898sOjgINw3NEhvHSbYQ11J35
         ocZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FKT0gUc2nqzuxX556wQEvBkIjDF/fVZrp3euBZf5N1g=;
        b=mG5X2HnFwH7iRqR9kh9VGG/CWcUkF3f8MV8pGEksWEza+moEAoYIXGhmMci810bCtq
         QNzj33DBwbkgzMMYRkFKL3dkVYf91sAMXAfFf9XnoRbNZnIQIM+k3Mz0M2bzpUNkxtwk
         ZslhA44/UfQe9q18b3zXxk1AFueHmtztNf76onOWXsqy6fp+EA+a/Z7Jlkx44hYImMzW
         92Hq925LOyAYE6ZZsJW22rWjApByMPl1ruw5UX3ClDgx0jNgW1c3r8otPS83qI3nrHD1
         6jIq3mGHLyUoHp3FMoeGPxWcIDi481Af1DmV/3WopxmLKSX1wNpPA5ua22P9l/l5L/ic
         M2jg==
X-Gm-Message-State: APjAAAW7BPiwXNwM8sIZZM9rnKqM1tv+AE+DN7wI0v3ohkzcN2S4Su/5
        dEdrxYyurMYRxN+tsJgyj3fr+hLUGPU=
X-Google-Smtp-Source: APXvYqwgPs1Xn5I/w4rI84TR/3blY6IoYpCUPC1STQpoyvyUdEOjmMKnQG7LHdot6L5J0XBWKioAQA==
X-Received: by 2002:a6b:fb02:: with SMTP id h2mr29532iog.126.1581090643513;
        Fri, 07 Feb 2020 07:50:43 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm978493iom.71.2020.02.07.07.50.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:50:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Allow relative lookups
Date:   Fri,  7 Feb 2020 08:50:35 -0700
Message-Id: <20200207155039.12819-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Due to an oversight on my part, AT_FDCWD lookups only work when the
lookup can be done inline, not async. This patchset rectifies that,
aiming for 5.6 for this one as it would be a shame to have openat etc
without that.

Just 3 small simple patches - grab the task ->fs, add io-wq suppor for
passing it in and setting it, and finally add a ->needs_fs to the opcode
table list of requirements for openat/openat2/statx.

Last patch just ensures we allow AT_FDCWD.

 fs/io-wq.c    | 19 +++++++++++++++----
 fs/io-wq.h    |  4 +++-
 fs/io_uring.c | 29 ++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 6 deletions(-)

-- 
Jens Axboe


