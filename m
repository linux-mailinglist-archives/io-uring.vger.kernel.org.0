Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7C25CEA9
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 02:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgIDAEd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 20:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgIDAEd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 20:04:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333CAC061244
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 17:04:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y6so284346plk.10
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 17:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAVjzoSVUJlcq4qIcuACZla7v87XYF8dVfndOPwV3DU=;
        b=cv752S/H9jMQRI3G72+jXI5XZH4WjxQYxgVXs+FFFJ5AbxarWz4byUd7tztBW/Yolf
         iLYEKMvWVDCFzQNkX9stFToNb5n2955QqnjLeAwZ9s4WBvCMp1nlrYADNsWrNBZmESCm
         156E/k29YW2krNtZOM7w1dm5h+/chChEsfzT9MglVF1QxdD6RmQ975ac9pqfM70STmJl
         K7OCqYF70YsnlQuWeA18BXcvVCZkAJEQ5PmLnv4T14nVM4JUj/Ra4Y6FMEMWUv2qkpYn
         Ko8Ykgt7BJIOcRoxFXMXuo8b61fs9qHJqCandfbytOE2OpUfYNxxyvEAyV2nEzzd0trJ
         rKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uAVjzoSVUJlcq4qIcuACZla7v87XYF8dVfndOPwV3DU=;
        b=VJj6oZD/39AzzL8JOJWCovvDvl6Y0n9GV1ovK3xPEI/0hJ1CzEsBt/dbn8NjlP/Tmo
         Y7+lgPQD4SX4sPzOAojosSbUjBf/HcKMZqHYj4wz1UqiM68ZZumhPzIFC/2yfScvWDBb
         6fKTtRhiWeOaX29Sxv6HTEhb0maUFYdCRUj+OoFPl39/22W40ex6PU0INo7scHeiOnpZ
         rrt7084zBpam3o25ACggE/KYyyFAIGM8iLpj850a6ABOFbaW3UpdTiim+k5ERL5BPlMe
         cJ1rhnZb9cR970GOFdh4dBkAkPlQrdVow0yOQYI5GpFLBxawfYIgMQrwTR+oS3J8RYAU
         F0jA==
X-Gm-Message-State: AOAM532Hebf+I0AtjLeDhEYPVdQ6+qsg1NCIoHz1xb1AS7KZMyFWi7ed
        4OlW0Ug1WTes2l7T2YJxvMxso5RLdx0K9HxU
X-Google-Smtp-Source: ABdhPJyTHwyJKlSsqL23Q2ks0DuXyithimsLTM3GkS1Qp283mf7khD2fFccdSsgPooKKhINIBpIsPA==
X-Received: by 2002:a17:902:301:: with SMTP id 1mr6408739pld.198.1599177872103;
        Thu, 03 Sep 2020 17:04:32 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v8sm18894482pju.1.2020.09.03.17.04.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:04:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH for-next 0/2] io_uring SQPOLL related
Date:   Thu,  3 Sep 2020 18:02:26 -0600
Message-Id: <20200904000229.90868-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Patch #1 makes it easier to support a fool proof assignment of the
shared SQPOLL data structure, instead of doing it after the fact. Would
also enable some cleanups around the fd install.

Patch #2 enables an application to wait on SQ ring consumption if using
SQPOLL, instead of having to use busy polling for that part. This can
help provide the necessary backpressure when using SQPOLL.

-- 
Jens Axboe


