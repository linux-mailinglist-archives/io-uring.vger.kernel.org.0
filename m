Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB601158477
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 21:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBJU4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 15:56:55 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:33275 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJU4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 15:56:54 -0500
Received: by mail-io1-f48.google.com with SMTP id z8so9251219ioh.0
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 12:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXYxQxRn+MT3Hmu0xNRRqP9lpBnqXv3AyMyuwANABGI=;
        b=nvSiNJ4lkIGp7CdaH8PmvO9llGwtHAXlGUf95OZ8fUDRKSTZHqm7071uISUnBvxicI
         Z8BLKYkcXXS3BP7oLk4bVyLqfoQS8GCfaFCW3QCCd8+aToPpZyB1jOYN4y3pkFGtXe2p
         HYECgNmg0cvYzfllBiGiD0MdUQQO2t7w9uAVRM9uFustpzMLyfKa6K9GgZhQ5653nIc7
         hD1qaULUrhXlcl8f6uFI5Em8X4F48bjt6bQYdfA9xBIOwRBR6zG3u672qtf7c6TEfCMu
         4NBpXOVX6n5uH6nz2cGt+oVrkRfcmRPGo/kF3UIuMAIsDHzuk8IPcmPZrjx8qq+Pd1GJ
         XlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXYxQxRn+MT3Hmu0xNRRqP9lpBnqXv3AyMyuwANABGI=;
        b=XPS1xCgF0S2I1fGb/+HzVJeTYNrZJvv7urUHIwDX5OLx3GwTAlVXDM3G6yZQwPn0+R
         Lgm3Zh7oX1ibfmeS3Xs94pr2PkIFykS8HZE5d3cn3Yzj2q76RzJ1geDIT1gas8LH5oct
         5apV/up6Qm91WJPoTO+Gm4MgAvwtk0+R6SHRAyrFCRBLUIrPYHaQJgi8Hh4PKLIacXDg
         L3cw5XXAe0XwEI3lpKHfukuAB3/wO3D6QvfRg5QAoEpqJpMnPdXXnLuihK37UzkNt7rQ
         pEW+5ufoWS896gHYuvfpwueqTewlxGrSo3u3GMw4VUjpmVUz3BNg8NcrX795XhrVZF3E
         oGng==
X-Gm-Message-State: APjAAAUKwCIX4rDsSoHQeLz1uyRNPIUSNc5L4jhEUKbGl2waHETnNV6M
        DlqKRYFnV0MtlUB0aRuao1aWiehvI2U=
X-Google-Smtp-Source: APXvYqx6svfx66RB85GM+XC8EUIxQEOY/BY3wh59xxDZ6ufq4iFUreMeTeFtOxLKXniIO9drIXKlDg==
X-Received: by 2002:a6b:7d01:: with SMTP id c1mr10760244ioq.172.1581368212702;
        Mon, 10 Feb 2020 12:56:52 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c4sm391479ioa.72.2020.02.10.12.56.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 12:56:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] io_uring: make POLL_ADD support multiple waitqs
Date:   Mon, 10 Feb 2020 13:56:47 -0700
Message-Id: <20200210205650.14361-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As mentioned in the previous email, here are the three patches that add
support for multiple waitqueues for polling with io_uring.

Patches 1-2 are just basic prep patches, and should not have any
functional changes in them. Patch 3 adds support for allocating a new
io_poll_iocb unit if we get multiple additions through our queue proc
for the wait queues. This new 'poll' addition is queued up as well, and
it grabs a reference to the original poll request.

Please do review, would love to get this (long standing) issue fixed as
it's a real problem for various folks.

-- 
Jens Axboe


