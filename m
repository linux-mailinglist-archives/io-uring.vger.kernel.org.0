Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FC542DAD4
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhJNNw4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 09:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhJNNwy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 09:52:54 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04222C061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 06:50:50 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id m20so3817089iol.4
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 06:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZbSRXp6QkSywNh6OBykUBgdufejnxNWNRr6NRmeeW0=;
        b=bFoKHyRBZ9H3R0kMHsmfwsqMspYe75MPcwIYpHCOWjDwqtDlM/N9jWOsAtDrgJT0UO
         W74dmHxiXnyNTZPJBOfFPUzZLzv7c8OJCEgJnYrkoYYNe0Ex+5q13ykJaJno/Rpa6nrb
         kglh5whJyc61jeJ1cS62/VKI9Eopwh0kXigXeGCToBE3OUxLfOEt+i8Jxl24rI2Zy6ou
         aghShRwKWVJzu2jBiJJ+rKYcXFyrA/QpCVZm60vDI5t8EGjl0XAUZGOGvKoHP0cFiMwv
         bE07OD8DFRy2CZSI36F5UGsWR8J6HVyzvk1t9nEvbEOn6v+D34O2V0HXPT+RKO7yMQPF
         dZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZbSRXp6QkSywNh6OBykUBgdufejnxNWNRr6NRmeeW0=;
        b=frTgN9AkVIB4TA0ef0HU8vxAouRGyXw20EGC6rz0CGm4+A7p/uRBLODkZrkwY/OlDU
         cOEThmkF2blqLpGlYB14LV0TtW8YgEvTKU8+Xq1yL3LWzuaV4j2GD7+f/l7N7Y3bD+ce
         GCTAfailh/v7W39/qT/Brxn6ovpanEfubvUD48hBJol2W9XeqSTYbepchGJmD7FNZqKq
         PFcV6JsAx77QVHEFqEE57q7mqf/KzBcDVVr7bCZh6jHWKwWGBkwDyOZc9U2+eCz46q+j
         TxjGZXtR97POY5HCiPlpR6rthEvuuytO/H/12PG0R5WVAmcZTPmfkAtCGWngpckscmPQ
         NFGQ==
X-Gm-Message-State: AOAM531HlE1kpgG9NedeVOWCuFj4JokFZKkTivfqyImKWJ1WGjEjmiAD
        olS9llPMs1oSb2e3/FuypYgFOg==
X-Google-Smtp-Source: ABdhPJyl3wT8EWXX0HhFH5w1wWuPMsDDDbFQ4TSAO774/zGlbq1y9Jvuc9UJMzP9yoeFy37Ca0iHLw==
X-Received: by 2002:a05:6602:14d2:: with SMTP id b18mr2470749iow.123.1634219449419;
        Thu, 14 Oct 2021 06:50:49 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id w15sm1355684ill.23.2021.10.14.06.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:50:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: (subset) [PATCH 0/2] yet another optimisation for-next
Date:   Thu, 14 Oct 2021 07:50:38 -0600
Message-Id: <163421943414.1284039.10600625733648576061.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1633817310.git.asml.silence@gmail.com>
References: <cover.1633817310.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 9 Oct 2021 23:14:39 +0100, Pavel Begunkov wrote:
> ./io_uring -d 32 -s 32 -c 32 -b512 -p1 /dev/nullb0
> 
> 3.43 MIOPS -> ~3.6 MIOPS, so getting us another 4-6% for nullblk I/O
> 
> Pavel Begunkov (2):
>   io_uring: optimise io_req_set_rsrc_node()
>   io_uring: optimise ctx referencing
> 
> [...]

Applied, thanks!

[1/2] io_uring: optimise io_req_set_rsrc_node()
      commit: 5d72a8b5371a761423c0bb781e717f8ff28c6851

Best regards,
-- 
Jens Axboe


