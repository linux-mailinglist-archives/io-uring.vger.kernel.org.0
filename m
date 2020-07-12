Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243F221CACC
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbgGLRm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgGLRm7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 13:42:59 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B237C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:42:59 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so9232127edq.8
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdaF+GW02OdZR9XPE/91DUj8MiVwoimHGmxXsr7+MfM=;
        b=cHmPZ7sOE70Tr2R5zKHYmfFQHJPLSQlpSUmguvnswhEH8vscSqWnkpXbxGaJT7en6k
         nfccLokeyovy8mZpdZC4A6ZOr3mJt9y/xpwhvaPEpV/6eomdGgZlQL4TDeUOpOenEoPd
         CxFo0DlGEhYU8G2RhJNRD816UhoODEjoZDW34cqqut/JytNVwf0e9ZYpXg9+OprJ35oc
         nx+8ka//kcOpPsYjCThQROA/7J+//n7h6wUEavLwr9mOERVFtTC6w8Ndh5FdjFV0mo2w
         I7WfpQ7LbW46F8BwUOPaBIijuRZmFqUhi+he6JniYe/tEre07EEbuf6b4pjxqYki7524
         GNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CdaF+GW02OdZR9XPE/91DUj8MiVwoimHGmxXsr7+MfM=;
        b=nbknnsyKp5dt1A+sGmk4IKjWQgd/733i14DpEZz0BirD61RfjDOZCmWBavCcGOSpyP
         FEpsUhOnTqV7bby4QD8jvGp9H5MLGsoU94XxHuFyHDJzIzP+Vr8n8yetmc4i2Vwkd1VD
         aDngb9xb26OJVl0qY2lR+NWDww4gXIWzr3WzyioKiMMVY3tYnwbazQAGqBkIM8VEV9B/
         urU47kH+gnlGQYo3V5ibFjL6SO4k193w1NWqf9LMxYvHgvImnL2r6nnOTfEcCj5kLdyf
         TwylrLN4gXqX8WxP2jd0bY1ew1hgJZ0TWyPgmPRLzQd16oKtO+ifLRNdv4HXueaS2iHo
         udJA==
X-Gm-Message-State: AOAM533QdKZvoAa87w8qh48QiAwsRm0Qy4NPazv86FSZUrrIcfCl5fhu
        RXri3wJVhHI054B5apf1RTP7kfMg
X-Google-Smtp-Source: ABdhPJxgquZQielwKJr0Im6I/KApt9egNwsuY9gvVMlRFX/Fk6KrZVtu60PMm5fcFslifSdwy89mvw==
X-Received: by 2002:aa7:d1c8:: with SMTP id g8mr88450020edp.337.1594575777704;
        Sun, 12 Jul 2020 10:42:57 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q7sm7957349eja.69.2020.07.12.10.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 10:42:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.9 0/3] send/recv msghdr init cleanups
Date:   Sun, 12 Jul 2020 20:41:03 +0300
Message-Id: <cover.1594571075.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A follow-up for the "msg_name" fix, cleaning it up and
deduplicating error prone parts.

Pavel Begunkov (3):
  io_uring: rename __user *msg into umsg
  io_uring: use more specific type in rcv/snd msg cp
  io_uring: extract io_sendmsg_copy_hdr()

 fs/io_uring.c | 86 +++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

-- 
2.24.0

