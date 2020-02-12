Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2446015B1C7
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBLUZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 15:25:19 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:36249 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgBLUZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 15:25:19 -0500
Received: by mail-io1-f53.google.com with SMTP id d15so3801757iog.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkZ54TmjuoQncn5LIcfLUWX+2v8MMbgcS9dyrLhx7oM=;
        b=CHZXUJdpQNBnu2EskS2qGVSCKo0hX/w3ps0QRi/3e0BI63UVgnn4gyhcv0yoyvpdDW
         lgu1LBYX8msukzOB9DDwkke0JyF2dUVmAYvCZse07Axqx5kxUk7REUf/op8FOXibFdwO
         ICBmKSOIHfr3XiP5UHZgo4ZVoJzkDNySl9P/ki+2yDMLiZoUHWR8Cq6Te1DXJiLKMr+G
         c2e+I5uUBjoWRjB/LwUURC9jnM9u5FcCk1w2tGjGamzULh2M5kLa0cM22z62llJJurz7
         iplS7Rp3mOrERcKICHz1/y5jIyKQrZnsUfXepFFCJIMjlv7XyiAIOT04nITzcQLk6RP5
         O4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkZ54TmjuoQncn5LIcfLUWX+2v8MMbgcS9dyrLhx7oM=;
        b=jyOHrmcdreVCvFC321B8hqp4nUIum+DJrkBYYdb2FE0XCFxYIJ5Io479p5SZDLQsW0
         VJ0Rb2ZsGK8bIF5bws4LX0TOVTt6mkdlGBOsPA7dGnZqm61SnW7gYdVja0Bpo4//tbBP
         1Ngw8HLHfQeqTuiPAsWOo/5kdOLaTfUliw/UAgPqYrtfH8TIJHcKaEH3OFt8h1jBI7uD
         z6ol6oY49cLLO3iMozVZVfKNUrsmBYnJVkE6w257h4P67JifHEuEQNZNPgggMLN7BxJz
         1pqF+BjzhnmKA2aDI+rX5nF57EL+Di/veXJ2tFuhBFnq0tg+mWv19WaMdpiHc9OZY6lc
         FcFg==
X-Gm-Message-State: APjAAAVGUqpXV/auKCZXk9KZ1oR7aFbzfptf0NCdeQr+9mLUx+2BRajR
        CB76SeKuFzZaZiR7XV2aIr/xVA/P4/Q=
X-Google-Smtp-Source: APXvYqzBqunfpCQH79URjAAu0d2Yo8Gu2w5F8e9aRF2vsMKZegiJbzsymG9/XXwnWM1fIvdifsxISA==
X-Received: by 2002:a6b:f913:: with SMTP id j19mr17942916iog.124.1581539117566;
        Wed, 12 Feb 2020 12:25:17 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 203sm37938ilb.42.2020.02.12.12.25.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 12:25:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] io_uring: make POLL_ADD support multiple waitqs
Date:   Wed, 12 Feb 2020 13:25:12 -0700
Message-Id: <20200212202515.15299-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here's v2 of the "let's make POLL_ADD work on everything" patchset. As
before, patches 1-2 are just basic prep patches, and should not have any
functional changes in them. Patch 3 adds support for allocating a new
io_poll_iocb unit if we get multiple additions through our queue proc
for the wait queues. This new 'poll' addition is queued up as well, and
it grabs a reference to the original poll request.

Changes since v1:

- Fix unused 'ret' variable in io_poll_double_wake()
- Fail if we get an attempt at a third waitqueue addition (Pavel)

-- 
Jens Axboe


