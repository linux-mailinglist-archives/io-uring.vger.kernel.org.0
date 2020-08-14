Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD3244F08
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgHNT6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 15:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgHNT6y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 15:58:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6EDC061385
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t11so4655891plr.5
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=38u2B/Xxk1Hwd1yhTczHPaMpn1BKnxua+QfWICgjyAg=;
        b=IaVXslrkMwommsDQb7q8LaJvOqCCLqZ/dUe96kMzthd24qQ2ZUJamZsE1NCjEXQi0P
         JQH7nRN2jIdxOMjdPa3wXUEjhdE7+/TxZvSR9dFMGt48LCfKsG/Snr9Sv3n1WrwLeutB
         wLa3K0ixHIR8cwG1zdmwXeIgvHB1FZOakAJTnzJbEVEi1Th4qX7KC0/POD4dmDZsCVvI
         0hrQlz6BJ1kz4k0ibSzLFXtGUmeEm9UWnd9NjEHKksiaDbOf3sXIR64HPtSqZunvauys
         +ZsB92TpBbMc8eM7Z72WqkaGaUa1TtiVHiUUzIeBCac6fwZz31Zlo3CyNXTAVDDPYExs
         xaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=38u2B/Xxk1Hwd1yhTczHPaMpn1BKnxua+QfWICgjyAg=;
        b=emmcIKpiLmYzw4Ai70LqmVN8QQ9QPPh6Z9kouvtlZjGE7xFNubUnqBurW+9fsqgEgh
         w8qgXvHJXRVgqV57ytH7TrLC3Mx4lGg1Cf9NB0hTB3hh62890v71u6DAwCzgG3tAy+ur
         V1kmlzmzCIDVUyXPjWbBtoUI8UnNmv9rddhfXtRhAEoTOlRgQCdThyn+oPExSZknOrO1
         ceFfWVCviIVO4i08LA//zcf+fggpQ7eoc8EuVEXNvEDfo/zLIqRy4Nw7Z3N8Q35/n1o7
         mYLcgToBuq0apNkLExbegmakjs2zIDWK6tV6iMVG4vo8Ym+iUR4F5jshwqamJnCZMnvD
         5xNg==
X-Gm-Message-State: AOAM532381b6rkd9iEIi+S67hDLRgp9ErYl9iYf7ppTyve8xeisN9rov
        jvRyn8bli67v8yXB/Rrk/svUecT/dIK1fg==
X-Google-Smtp-Source: ABdhPJx4AXeSJ4yAJONuJACXc66eBl1uYj53vxbCufzjiCZtyf99a/Y+fPeIokUAUSPzjZqsT+aPew==
X-Received: by 2002:a17:90a:d78f:: with SMTP id z15mr3526830pju.9.1597435132601;
        Fri, 14 Aug 2020 12:58:52 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:58f:6be6:29b5:60da])
        by smtp.gmail.com with ESMTPSA id t11sm9695219pfe.165.2020.08.14.12.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 12:58:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
Subject: [PATCHSET v2 0/2] io_uring: handle short reads internally
Date:   Fri, 14 Aug 2020 12:54:47 -0700
Message-Id: <20200814195449.533153-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Since we've had a few cases of applications not dealing with this
appopriately, I believe the safest course of action is to ensure that
we don't return short reads when we really don't have to.

The first patch is just a prep patch that retains iov_iter state over
retries, while the second one actually enables just doing retries if
we get a short read back.

This passes all my testing, both liburing regression tests but also
tests that explicitly trigger internal short reads and hence retry
based on current state. No short reads are passed back to the
application.

Changes since v1:

- Fixed an issue with fixed/registered buffers
- Rewrite io_read() code flow to be a lot more readable
- Add comments

-- 
Jens Axboe


