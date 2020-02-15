Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06541600DF
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBOWId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:08:33 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40575 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOWIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:08:32 -0500
Received: by mail-wr1-f50.google.com with SMTP id t3so15176913wru.7;
        Sat, 15 Feb 2020 14:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGwHTq1n37q0/5C8GoHHWk5t/f/z6n9gW6iag+Rm8Dg=;
        b=NnvUU9wauBkM5P3zXJHDFbhqSNmUBTs4jf4Cz29kFdrrzaE3J0SG1hH466xX1M1IYO
         Q5/5l3pULbCmy8fqp24A2mSUDdarHRYWYZUWRieLwJ2MYh5c1WciHYSKP6jIhLpT82aO
         VFqiadUDwGDPWbXmjxQpVmLbn5JyLixgZqdhi/uhLwVIDqGBpUEQyWmvjiuZ8/PMBDF6
         qxfe4TvwoMqU4+WM3czTYH6kCTlntrbP/miE+mPvfJ6vcVeA1R1mFmHpJrR6wd29WNbe
         LF49HMz5QBK3CQoSR6UJPcS9EexIybe9BwUj03BofjITWHDS32qzLJaW0pg+M2LDuKKK
         2R3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGwHTq1n37q0/5C8GoHHWk5t/f/z6n9gW6iag+Rm8Dg=;
        b=PRj8mNkPOItqbgqksYm5hOgkW3HKBtEhmuZfFLcqD4VrjQ+SweFCmCZTikrhQrVDKN
         tI2rdN9zgJBH15Ar2Y2mIB+oHrg0DzjlBaAh+70Ee0tjj2ydQPfNZkrOQIRNsIwzj57d
         4nXdzZ4Ux3+rR5dYMbq+DCo1i/vysgCb0bTeD0r6XmkiAaqbD89+Be9GCyX+TktqGo6T
         ng3gTguEnbCw3z4GwxlLygDaoaJTHxa8eDPcGZmI4v4vWGkZmXZ0JVTheka2gnQwNi4n
         9wXw1yq8mrrqIq1mNbTiondF8C7yYk45NBNeIzjR8ZXPkSZJVBFqQKjmDny2RY/cIwyp
         qq9Q==
X-Gm-Message-State: APjAAAVJSp0WOrQ7ruA5CH7TIuEX0GqF2TxQs1xnpt0ex/72xsKl4ZjJ
        odffNJTECp7QarU3HSbhrkQ=
X-Google-Smtp-Source: APXvYqyTalh1HSlFyRP82kJ2ZPAYK48OaNfVYFh5ZMgAZjkG9PB5vJekKRNEdIXZ1Jj5z/RfJwW73g==
X-Received: by 2002:adf:ec83:: with SMTP id z3mr11336465wrn.133.1581804511016;
        Sat, 15 Feb 2020 14:08:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id h71sm14539719wme.26.2020.02.15.14.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:08:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 0/2] splice helpers + tests
Date:   Sun, 16 Feb 2020 01:07:34 +0300
Message-Id: <cover.1581803684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add splice prep helpers and some basic tests.

Pavel Begunkov (2):
  splice: add splice(2) helpers
  test/splice: add basic splice tests

 src/include/liburing.h          |  12 +++
 src/include/liburing/io_uring.h |  14 +++-
 test/Makefile                   |   4 +-
 test/splice.c                   | 138 ++++++++++++++++++++++++++++++++
 4 files changed, 165 insertions(+), 3 deletions(-)
 create mode 100644 test/splice.c

-- 
2.24.0

