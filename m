Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A127B2A3A1F
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 02:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgKCB5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 20:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKCB5E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 20:57:04 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBA0C0617A6
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 17:57:04 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y20so16968840iod.5
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 17:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K2+w9lnacbTj3CLBvrfgcpo1ooz+4moD9HUJzV2bOe0=;
        b=FIfyrfahLR/iB+6ZbMkoD/OIu8c+1xKUF8YOZbdrQbZwSPh/VfL0VuWa8w0p5xIkfB
         u2PbI5Pxh4dpWlsuFscAmUpzJRHUqQsZeI+253n1sMpghwsCCgVhPYQBrdKp9HJCIzIs
         /DAiScCbxbD96bZxgYkBLm2lPUpm5lB1mgZhVKicyQMHrCq8DSW6tBJxewR7tp+8CF+m
         PE5lvE6B5bjHY3LwLikOOW+IvlmqYLXV4ZCFOxX6Bu8rNN4ZPohBTaVRlQz5zD0GbQoh
         +eMeSp6qbmT/8OCDi0mYbCwwqhm/PY2H0wrZUw5Oiqj+znb8N/DVGKqKCfVz1ReA0YAr
         0dnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K2+w9lnacbTj3CLBvrfgcpo1ooz+4moD9HUJzV2bOe0=;
        b=DEXQfmULBf0QeeDqNvki6MxhYitxM0gwRsqQeiMbL7s8WVUOmPkU1hj6K9UPAhPeTN
         3an0eZMErt39Ne0bmBApxC7gvomG8kQ1xJxdAW+Ib9UfwY71xDoCyuF6CyJQkW2Q0gTK
         KZVxeqRRr584ZTUaJMABtN51KEpvtR6y/yh8XU1u5fDouoekrN+WkUw+qGJXqobkHrYV
         bNisMFSGKDo9C7Ev5Xodc9P+uci9fxTrHMv5OY/YNCwKqOo9OWdgQm3M6fjYzUuluFX8
         Hw5OG8s+8TI/XFjnQOEymv0RUMBaY5oK6byylRkswWUI4Xe5qUeOcV9TQGrwMXzBsoyD
         A0NA==
X-Gm-Message-State: AOAM530ck9mlw4fk3eT03TpNSJw5Zvx5xLfQTBsYTrFR2JDNB4gwN6ie
        Ls/wvPBCl/weq9f6dL5/iHgYb9gg8XE=
X-Google-Smtp-Source: ABdhPJyqjP9fkCXKB1mEVhhKbuyQbBil+5AoecrsFZ2gVULlAPOwKZPAU0skgFY1dK59D3bG53W7uA==
X-Received: by 2002:a02:228c:: with SMTP id o134mr13840232jao.56.1604368623593;
        Mon, 02 Nov 2020 17:57:03 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id o23sm7344026iob.47.2020.11.02.17.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 17:57:03 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
From:   David Ahern <dsahern@gmail.com>
Subject: io-uring and tcp sockets
Message-ID: <5324a8ca-bd5c-0599-d4d3-1e837338a7b5@gmail.com>
Date:   Mon, 2 Nov 2020 18:56:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi:

New to io_uring but can't find this answer online, so reaching out.

I was trying out io_uring with netperf - tcp stream sockets - and
noticed a submission is called complete even with a partial send
(io_send(), ret < sr->len). Saving the offset of what succeeded (plus
some other adjustments) and retrying the sqe again solves the problem.
But the issue seems fundamental so wondering if is intentional?

Thanks,
David
