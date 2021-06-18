Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178003AD2A6
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhFRTV4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 15:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhFRTV4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 15:21:56 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F50C061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 12:19:46 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso10683983otl.13
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 12:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osU2PrpwUjJZPFxclKX7TDYw8TOo6wWG4MYG7Tt7A2Y=;
        b=RDoSDV5I/lfClEqCRYyT+Qr4LDMA1ylD/RBOs2L6Krem9GPfYDJxrnxIp/8XFOAGL7
         39gpXefC1kj3wl6kuKGOGGr2L5DngBNJ87AXoz5ixba6RlR6Q+PBfLrElOKo1pHdAvIu
         MeHWsGTg6CwrpfB4Q8TlrWAhvIcfxIWoNjXStYflJkM5PPLohVdpE2SIMAG1sopuCdjt
         742qB+LwAnQ9P7BdoXO0hs7eR/aoGZ6CiI70WhO2F/xxQ5XeqKUjArx6bMBNlQpIzxqV
         glj0ggK6w1ozYMEVzBdmf+CZRuHY08LVj4ZtjM8jKmBZZ5L1BMp4RJ5OKYvr3P34BApj
         PuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osU2PrpwUjJZPFxclKX7TDYw8TOo6wWG4MYG7Tt7A2Y=;
        b=ix9SYA4NgmLmZH67rEd+PkJfkzayQilakv40VGtuXgOptMFhZJYsn5rl9gYTqoGH7Q
         qMwfhuhO9CCDQ4bjJr0v4nQU0qS9Bn9wQwMUVwa5muChsSge/jFspX5JhjjuoGiLCAIl
         Lg9SPBU5gPz65qEjwS/Iqe30GcUPf8S/QYYd/cS2V6FllfonNH6TNzzOZ0JzbaxOtN1z
         yOjQCidO8cHLjzo5qnMvBBmalcEjHi1/iz0e3Rlfl0sii5nFm0dovGnxR5CBqGUrcW1s
         T+MwykwR0IVSSeXZAQqfn/sCLeaOU+oYiK5EUHErkzzZXj2Von9Ii4nsMqiPs21ckQb7
         Zd7Q==
X-Gm-Message-State: AOAM533ZvPDclVer0D0Mu4VOdzxT4IEkhwgP3isP6ELR7j90SgNn+n8E
        xtGKcPF/k0onlSL4qJLXVpx29/Rlbz2JdQ==
X-Google-Smtp-Source: ABdhPJzmyTEiJ6CxZKgKmogs6LUTHFNSNMZhthfmFKPESD2BuZDMH7xuYsTnam54icGLWAH15tBFAw==
X-Received: by 2002:a9d:70ce:: with SMTP id w14mr3592166otj.164.1624043985091;
        Fri, 18 Jun 2021 12:19:45 -0700 (PDT)
Received: from p1.localdomain ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id u15sm1981732ooq.24.2021.06.18.12.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 12:19:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     samuel@codeotaku.com
Subject: [PATCH] Add option to ignore O_NONBLOCK for retry purposes
Date:   Fri, 18 Jun 2021 13:19:39 -0600
Message-Id: <20210618191940.68303-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Just a minor behavioral tweak that makes non-blocking file descriptors
easier to deal with.

-- 
Jens Axboe


