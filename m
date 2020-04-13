Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E80C1A6B55
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbgDMR0M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMR0L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:26:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8019C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m21so953928pff.13
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIPhBRhLcmhRKCdxNdyuD8ieE/Xx5yo+iKeqRWJ/RrA=;
        b=YwF0gYOwUw1yAnhNWbLc7r+qDZZRf3YXmbKegTQNkKhKJRWLJFfW/LJGW8CAtCkfl5
         XgOzo9XeLZJ/DL37r5isE5sG+p1j84lVjlWZyac7GEpWsjbq3uIgyzAHTfFxeVC8hjKB
         Zu7VuHkbgcFtH8ilwzOrJ54e29Sylly8YHET3gG2Q2vDElOlhGFAaM08v8yXzWD+/tdP
         x0ciXxxlhMlFzDczIMOCfkE2OqBX0GN9D7Ay9lhPntq6WF9moYeHgmzxBSL8crGKk6xA
         A0ZcdCiROmGF5C5qmHFFwx1c1hTTJ6MSKp7LMLKnnpym/q/Qc7S5+OrG2B1/1gklirli
         d0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIPhBRhLcmhRKCdxNdyuD8ieE/Xx5yo+iKeqRWJ/RrA=;
        b=sw8S4ir1laaOvQtGYPBTJieqHwHoigWDW0VsLYwcf7P2R4msputlF/Srxen7veA6t7
         zp+MN2XvT8PEHmhuSOaKAlnt9FYYuM8FLVfaJS0FU6YylvHltet8ErmAlYhqyKrkK611
         gLumRiVyaZ57pTHtwYC52gRLHVtom0lYh5RdbRwyITcxG/NHtwVFCYdTEGJm+r6mnkr/
         Lg+ayl3TzwAuyv3bX1mL677TnByyMQ2wy5+O/NkYzid7RC1tdtUJ+tewGc0MwqQVlKXL
         1n8d0P36NBwFS5/gP7F0kreZ3gpJP4cncdTOOowmudSLQmVhTH6QSAbHYo3cy5OBeoFY
         CKbQ==
X-Gm-Message-State: AGi0PuZ+43VSH/9cqX7igh+8hZzlk1pWiJdOI3qCbC2OmFZ//FJV/Jng
        uhh0CSo998FUqsblGjonX93xrvEoA5pxjg==
X-Google-Smtp-Source: APiQypLArW2rZXsoyWjsvA1SZ6I2ZDUCUUUPAzwTa95Vb+v7uYKeBC6ejBgzGM+BHfMLCnkx9/Vmhw==
X-Received: by 2002:a62:1a50:: with SMTP id a77mr19521332pfa.289.1586798769644;
        Mon, 13 Apr 2020 10:26:09 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q2sm2228834pfl.174.2020.04.13.10.26.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:26:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/2] 
Date:   Mon, 13 Apr 2020 11:26:04 -0600
Message-Id: <20200413172606.8836-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just two minor fixes here that should go into 5.7:

- Honor async request cancelation instead of trying to re-issue when
  it triggers

- Apply same re-wait approach for async poll that we do for regular poll,
  in case we get spurious wakeups.

Quick v2, since the one I sent out was not the tested on. Patch 2 was
missing a return after the io_put_req() on cancelation.

-- 
Jens Axboe


