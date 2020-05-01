Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605921C176B
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgEAOKw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728840AbgEAOKw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:10:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC50C061A0C;
        Fri,  1 May 2020 07:10:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x17so11658434wrt.5;
        Fri, 01 May 2020 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8v3kVI4yLmXq/VIVZwurKp05HhbRXPIJFuU6oZF2NPM=;
        b=jOHWzx9BhQ4y8ZGz0PWAWBQ2u6f3ts0FjGwtdsiTWqULyIFsmvDcGqroerFHny9RFD
         od6tzLLbejqoaVOTh9BlQUtOVLUNeSusPasRvGSIP3REroL/32aTrBfo7uC7RUxTVq/b
         FTD7J6lUxNX8QxEz1scF/nMAYV+vsNLFLI+n1PwpI70d2TEWh4aqFg8+Hz09ApHA94lN
         x6ZLS9zAfSfUFsGolxnFmXrX7pw1OLZq1sQ8KLCgwO6TGdylQToQ6G856CZCknZ+4xD3
         aDZs41cSEEBL6wobgF0YtE8WkITIThOzcVQuNjGEEYL4kJLgB+sHxd1CgXhF2ecySs+t
         gGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8v3kVI4yLmXq/VIVZwurKp05HhbRXPIJFuU6oZF2NPM=;
        b=FeNAUNAKL0kVHip8bC7hCqmDEeNAKMLq0O9DX8fjKOvYnCy2PtcxMOCHTKI30+xHJq
         f2KNTpIb1Zu8GpGLq7Fpd2jZntzsW/vlHbk+MXpJFlmmH4i+EOQ6uQDXIk3dDWeMl+le
         Q+/t50746RxvwtN5GNNR1Al4foHQ72D8zXun1yxst/xmYZTabUSKh1dEcvKZwqJdPWFL
         Mg1/6nr7NHg4Edco7YKvC+owoulqPpCvP4jlmiIpg1WhKkDjpg8SLhgoch0aXtLf/Fyd
         Ph4sqCPIo0j7pbq+eVXuzCKe8Osf8qkYYhCVf3layslmVIYFTo1mjmR/LpfTUPgxxmzo
         DYgA==
X-Gm-Message-State: AGi0PuZaGxSrz4831kwz0tw8NY/sgJ7/D+XDHcqCkeuUicGu/m5t6Bvw
        wfYE2IuIiQYTJJJlSlythx0=
X-Google-Smtp-Source: APiQypIiZxYqL0xDav+nSqLdWkN2TrUAx4mxObBQYgpVo4Bmyb35Do6Re75IAp97MY1niDRgjBM/3w==
X-Received: by 2002:adf:9d83:: with SMTP id p3mr4566152wre.142.1588342250199;
        Fri, 01 May 2020 07:10:50 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j17sm4837390wrb.46.2020.05.01.07.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:10:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] small fixes for-5.7
Date:   Fri,  1 May 2020 17:09:35 +0300
Message-Id: <cover.1588341674.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I split the sent patchset, please consider this part for current.

I'll send a test for [1] in a day or so.

Regarding [3], Jens, I haven't looked properly yet, how long
splice can wait on a inode mutex, but it can be problematic,
especially for latencies. How about go safe for-5.7, and
maybe think something out for next?


Pavel Begunkov (3):
  io_uring: fix extra put in sync_file_range()
  io_uring: check non-sync defer_list carefully
  io_uring: punt splice async because of inode mtx

 fs/io_uring.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

-- 
2.24.0

