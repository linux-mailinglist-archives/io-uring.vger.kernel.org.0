Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAFC22CBAD
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 19:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgGXRJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 13:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXRJX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 13:09:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C1C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y10so10731914eje.1
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 10:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GaJtEkudT4y6cmbupnCbLaYpDZwKYqu/TgQCnbr444E=;
        b=gvFkwovJimhvdgjoZ7Q4WQ+7JYe9UFSdfjMnYavc7hiA5/Ynh/zDoMA+3HM8WisSlx
         9PQ8Z/OH3vRiNeJCv5EXfvoq7wgWlfiYcK0DDjG2EoOZGUfcp+HP19bFLycTejNUUtSE
         MyrZJi5PVbSbUPYew++v2ngEJOwbQsqr5+Ldv3HCXOTD0LwODLihr+EwySVhG0eN9fNH
         /QhXSLnyh3ILRj/VmvxbQNMvw6Za08phu0BVrn9ll/SX5CVF05LnqiSKQFI9WHMxyJzr
         nNVJiVy0Jxt2tqJ/AZ9ZTs359Pf9DPH2v+nHIAIRSmYJFN4v9OfEXe1SXidTMJ14Xprr
         pykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GaJtEkudT4y6cmbupnCbLaYpDZwKYqu/TgQCnbr444E=;
        b=BoPzvl+392qcABZd019uk1XJraxQIt/0UUT+3vzlX7NwK7F2BzZ1DCfajQu4IjrUwx
         P5jXcGI6g1iWrOqYj/Q9gIh5o1z9uryyEAXURksOTOrDLRePZt0VzAtqn7Hc77IC7c19
         xdCa2OLbf0ymEPi0GCttD8hkzFrEMODEXytlMr86tD1Z2DLuiO8p9aZNogunYSE3hOEF
         VTWXLCSCNilzTddfbkIa6k4D9+gzJGbHwVENAbjM6tXyv5OJYfW6XVrvD+4V8VxsLffZ
         cuc2oMytO6r2CE6Rs1RroKeWRT4dotYd3/S7F5DgksQO0xBJW3YPoJGzPofg3BnvELvg
         L7OQ==
X-Gm-Message-State: AOAM533+XKTUQw9S4PTSe6R2mKyLR3DfsbU6dTFoVl2fN8IJSyJC/32F
        uXOxw0kZ26COsM+P426Cb7U3GJJG
X-Google-Smtp-Source: ABdhPJxwaQ8a171kS1d6WGRLjWKDgygQUc7TRY3SNIMTX5xZA6sq610Qcj7J/eUdjiX013g7/oQEmA==
X-Received: by 2002:a17:906:e91:: with SMTP id p17mr10529290ejf.252.1595610561290;
        Fri, 24 Jul 2020 10:09:21 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id b14sm1007832ejg.18.2020.07.24.10.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:09:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] two 5.8 fixes 
Date:   Fri, 24 Jul 2020 20:07:19 +0300
Message-Id: <cover.1595610422.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[2/2] is actually fixed in 5.9, but apparently it wasn't just a
speculation but rather an actual issue. It fixes locally, by moving
put out of lock, because don't see a reason why it's there.

Pavel Begunkov (2):
  io_uring: fix ->work corruption with poll_add
  io_uring: fix lockup in io_fail_links()

 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.24.0

