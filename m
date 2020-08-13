Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944CE243E95
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 19:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMR6M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMR6L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 13:58:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F59C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 10:58:11 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b16so8260782ioj.4
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 10:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CNsIjNGc/wHZ0yewt2X88tb3VGuV1iPEInHa3QK4IeE=;
        b=0z4unZ1LoXRr4iUXB+AnmgR5jEkYTAEOtDwQ0nDSGUveP88HnkIO2Zgz03YnSdVpHI
         oSJJkXYAUnwXzLKUVVQ7bU6+TIEp/1wAHcezgjVvSfa9flRkjlUjyJVM9Fi65tH1TvoW
         c5WkkV76/5c2Kg9VusAYCzT7/5URpr2oJEGe775l6d7yOlr/G3LoyHiVD2YqNmwObjaN
         OtaIg8OFp8b0RUbAlUsNwUce/BE0hJEk1A79onMBSAVt/Q4h68jxeyM919IUehmwB/XY
         b32Gt6JnygYv5bePrrtXISoco6zuGeXXJzuMQg6M+SPwBp7iGkkL4NSsWBW0jbMNaCjr
         FIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CNsIjNGc/wHZ0yewt2X88tb3VGuV1iPEInHa3QK4IeE=;
        b=CM+NkoJ755GsRp7PgMLzx0tdc+YxowFKoqF4h91wXP3W5QOvWPEmt530L8DoajbEwR
         dnGyUNPwuPP9YTyTF0/k6CtPD+VVpjwGfqnR6sEoKZbe1bbovI49UBGzlVL7w6wyKD++
         U2xcW2OTCW+zKBV/mW9zkVSvM+QepPvg+a/5daP+Z6v1ES/8KGy4CiyLrg35BoZ7oTTq
         mnxo/0/vMOh03mHkrh/xa5LH98ufLFsPsDRDS/W4fhN+VcUm9GoHP8anCLztqH/F8KRW
         Lo4Hh+HFWMIjiIFtYI6FMnoO2es8bFMmdCCmCs9hpN2suu0EunesIkHhzFpuxA/0j+av
         9WjA==
X-Gm-Message-State: AOAM531jemjZOrsrvEqquaLPsbfJSSCFFqYJ+ky3E10M1mxGmpjlgA1L
        1TabZ0bd8rK9/RzvcAV353j2k4DTx14=
X-Google-Smtp-Source: ABdhPJwRwa2TzS+vxbEqtL25OrZlhX/wAwA87YveizYE8hz9xL+ET3kcIszeKBwTKByf9QgzSuzDGQ==
X-Received: by 2002:a02:76d0:: with SMTP id z199mr6298000jab.39.1597341489387;
        Thu, 13 Aug 2020 10:58:09 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y9sm3029562ila.65.2020.08.13.10.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 10:58:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
Subject: [PATCHSET 0/2] io_uring: handle short reads internally
Date:   Thu, 13 Aug 2020 11:56:03 -0600
Message-Id: <20200813175605.993571-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we've had a few cases of applications not dealing with this
appopriately, I believe the safest course of action is to ensure that
we don't return short reads when we really don't have to.

The first patch is just a prep patch that retains iov_iter state over
retries, while the second one actually enables just doing retries if
we get a short read back.

-- 
Jens Axboe


