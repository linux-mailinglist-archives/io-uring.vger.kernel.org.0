Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8F215937
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgGFOQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFOQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:16:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3857C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:16:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q5so41108926wru.6
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6zdaugDhnt0s8o5PskJ90vVNuM4fjUt9BE5kuzsk/G8=;
        b=AHzQDcu6mNfHqMfvEdDknyF8yDXIiYtixph9I25F2Diwdasdxc7tcCdVxlEVmo1SKj
         gBGxHwZnGrxDDjF6K3CMKMQFaSjKdP96pZcQHJ3qRf7UBNJzLbXhJM+FXJOHaKdEst1z
         q+doOYNd+e7FxnjxiwhrdNkR/I/CY5J8EMDNEu6iHFmD02nI6Hribd0IQddgzcPTcQrE
         Z7vPOb5CH8hjfFS0IN3zGFRaJ55Aq8iOYMMoqPdzu5kKQP/e1Xm3etugPPaLYgEwzayT
         IxW524c3IdCQh6/ChVxjLuWCt11uZGHxPdrW7Z0mWD4GI7uNS/s5vrfeQej6D5Fye33F
         Z6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6zdaugDhnt0s8o5PskJ90vVNuM4fjUt9BE5kuzsk/G8=;
        b=a3lH2aLa/+SUrA1CrG684rNDafW1oFzr/EQzr5Ayo4s53SQCmasvEPc7pMmsMbcQYW
         ci7YhHvoYRnBGkuIKqdyWuVSp5clqfbf6LDumbidFXtM4dcqlNYJtRS0VucXnmfcl9YV
         PCgUzVqHtGmIIdlUjjUZE/fYK+EV9XIbkHjN34IOP3G3SMxtile+m9G/Fh1loYtryVzD
         guNC0KuxWHxuSw0AQoCvjws6Q7bAjKGSkdvXOZvz1LOKOAZgLAcbfC/4zq6yaN4gKjX4
         guLXfIg/PbslzP08G/387Urv2C3/RlgVy5PDOyiBoePZUv69Zu8Es/soqepbcc/MUr8I
         BWUA==
X-Gm-Message-State: AOAM533tGUhu1Q6VAb1I0FruTNcButTmEFOxWiXUs5oNYPmrXAm+frRk
        ezCboMEuwhAb5CF5c4NH09C3Y7MJ
X-Google-Smtp-Source: ABdhPJyY3CRDxfrWcmzocyoaXyR1tfm6n8I+5Jplt1STVnsbg2PzgUpSOR7mm++UocYUfEm4B19f6w==
X-Received: by 2002:a05:6000:1cf:: with SMTP id t15mr52834409wrx.180.1594044962654;
        Mon, 06 Jul 2020 07:16:02 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 1sm23719286wmf.0.2020.07.06.07.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:16:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] iopoll improvements
Date:   Mon,  6 Jul 2020 17:14:10 +0300
Message-Id: <cover.1594044830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iopoll'ing should be more responsive with these.

Pavel Begunkov (3):
  io_uring: don't delay iopoll'ed req completion
  io_uring: fix stopping iopoll'ing too early
  io_uring: briefly loose locks while reaping events

 fs/io_uring.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

-- 
2.24.0

