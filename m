Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7838215A2A
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGFPBX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFPBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 11:01:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F8C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 08:01:22 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l2so41052971wmf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 08:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FmI+mTQiagJ6jozXpHnmR4anDAKHSiXsXlGfF1n2UA=;
        b=Z4k1eq/oGWkRCrQ2oKb9lfFM02HJR0rBjshFM5A3OQ3mZ35PNExOolvQB7XjfNZiXu
         35+2PYoOVkCL+Esqed6CIzPVVwX9ooyAYBs8AHZBjw+OsMwZ4Oj0NhBMn5L0il0jpb31
         hC/wcBQXdG/1FgWKvfHnE5n6pxvyYMY/uTN1YSkz0NfARS1d4Dnup5jwdUdS4LIkxgNl
         vd42Bt5TeFCXUwNyutqCh8Y7yoP9+CqVDBaHkEJ2jVccCLdGSOXC34+WZCpmcvFskV6+
         k55fNpSe0EdjdKouQgHbxU8p/v6EwXHDr26JQ5nu4SY4FDvS4NUKBaAqnDr7QnmpCYQV
         xjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1FmI+mTQiagJ6jozXpHnmR4anDAKHSiXsXlGfF1n2UA=;
        b=kl9sJYG+FHVsNCW5gKuVhU33UGbL/YC6LEs1xEaUobyxvIbCVntykPL6Nm7qewX3kn
         ZXsoedho7FYIS32lD1oUY0TBWN0qh12Hnkzfh5bf3EAD3tr+3Q4v9zX53mpYmG9wjLRE
         KNRe10W5QDSPFe+X++J1OwkpN8EMD9W2y3Z5sCt3DaIm75ab95pJoWcGf88vQ3Rawr3u
         qLfaRcatiMQ2+RkT3BnDGCE6q4MYN3S6Gh6uLXMi2FD2IKa1A/LKl2zudS79ItsD1+vK
         8kG2NOycVYTmNgUZyxn9S1a74Wpjkzl1Ef3YrteR+/tjSMWYmJ5l4bZwjsMT5SN8qjhZ
         JUmQ==
X-Gm-Message-State: AOAM5336P/q8ew88E1JVwBh28R8jBWtPqdBhbU+lE9WQALRrtwBP+qet
        SgKoa6ZEUTxaGGHfHjTIy0BoYHz5
X-Google-Smtp-Source: ABdhPJxbcMgI4oUO5D0hUjMf5/i8zUiuPveXrhnRW+3uhjSgSm2lawk738TxUzVwxRoLCkYcwaYHIQ==
X-Received: by 2002:a1c:9994:: with SMTP id b142mr33306299wme.141.1594047681157;
        Mon, 06 Jul 2020 08:01:21 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k18sm15626168wrx.34.2020.07.06.08.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:01:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/3] iopoll improvements
Date:   Mon,  6 Jul 2020 17:59:28 +0300
Message-Id: <cover.1594047465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iopoll'ing should be more responsive with these.

v2: [3/3] extra need_resched() for reaping (Jens)

Pavel Begunkov (3):
  io_uring: don't delay iopoll'ed req completion
  io_uring: fix stopping iopoll'ing too early
  io_uring: briefly loose locks while reaping events

 fs/io_uring.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.24.0

