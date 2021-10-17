Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476F5430C01
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 22:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbhJQUfY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 16:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242900AbhJQUfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 16:35:23 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3981AC06161C
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:33:13 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d3so62158905edp.3
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 13:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8EbthODhXi/M1cP7quHaoZ9NwI6zhL6wnsh2Uloe48=;
        b=LHtwhzb2sez1i3vfa2JZrNWfHIprXLnVU2pdHs6GXFSiYyAG9Y5cRTeUfyeK/4xIJN
         qbFaIRgWy+UY3+WWGnjDGvFbqouuQC43vDtI5aBJyBDJUfECxaFthG6jT4gX1my4/5MR
         7TN7TIB94hgSNFA57OKao9tUgCzaScbeJOofufbyaxxdieDiHlYEAw0bU/5/jc64bpIR
         wOLQBxxLNrTtEE+h92t0QEsgUcquHGr3ltVPfiAazbyXGzMU7v/1EEYDIMQ11C0WKJ0u
         BogLmAPiK+H18LJpPvFl2zDpdIl5Vu/Cmcd5CodMmuHBK9U9a3uFu2P7K+ppxCZpY6C2
         86Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8EbthODhXi/M1cP7quHaoZ9NwI6zhL6wnsh2Uloe48=;
        b=2ttuSUvx+AY6nC/iu0s0eeObe0SCl3X+az5FitC7h6Kf2X1jeCIiAKHMrkITryZGMQ
         CCcGXwtNbN20uETV8QrG1Ma6d5YW22p2t0IFqHGey1eYy6qrQivU4LUVesUhowoBD8Ml
         sBWmDa7uMefLIMvSxzGzOzBz3tnH+6pV54WZ2WcNrlzUV3ERuXoJtkceekTCFlqcKPpm
         7deNvVMwuWXpou/FcNoyA8Nl9y8zJsWUJDNzh/q8wp2JwGaHjm5G08jkhbVs6wXTO58E
         CHqgT1E3U80T2adm8U2W7AY9y3o37m52yMo6/BqC3NhCiejMBzIpsDHkTi9t1/8Rw8un
         BrpQ==
X-Gm-Message-State: AOAM532ZsemldNwM0E36Z9/rjw2lyAiYkWzlTjXO4xBWkEKCTdiw0WDu
        DuArVrDmJ24cZq7mHzTDjaSOwLSDOe8KYA==
X-Google-Smtp-Source: ABdhPJyyQKxk0/weEcBiTcmlGicWOEV2CabtENNFq9a0bUfhl4ZWqph5x81XoQxrcFVA3b+HUdCmuA==
X-Received: by 2002:a17:907:330e:: with SMTP id ym14mr25825252ejb.417.1634502791733;
        Sun, 17 Oct 2021 13:33:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id ca4sm8119651ejb.1.2021.10.17.13.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 13:33:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/2] two small fixes
Date:   Sun, 17 Oct 2021 20:33:20 +0000
Message-Id: <cover.1634501363.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first correctly attributes failed iopoll requests.
2/2 fixes a for-next bug.

Pavel Begunkov (2):
  io_uring: fail iopoll links if can't retry
  io_uring: fix async_data checks for msg setup

 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.33.1

