Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E1933FAC8
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCQWK6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCQWKd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:33 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0611BC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id v3so188497ioq.2
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFhJnmX/s0oUEcROladmsKEjjXMSFe33w6iAkZJqd+0=;
        b=0oWT/E00w/f76eaGEEfnywI9EeZXkLvXaW89KycflSyDIvWxMtuOayhT5Xr+1yN8rS
         3vJaNQvjuDegrUBEtqDO+a2TAIkT8FemWaRbURwFm596X5RuQcxuL2FHbhxrJZA/ku1Z
         1Uhcto5dfHz+SBCX6nRfDPcrbJsYpd/kkAi8oT8TIuNw/19p8gh1QUw4xfYTZ1oGmbHn
         G+1Lgp9BZhwd4RuLsY0PyjZxrs1ZgTBfysvWDnIGO0ya72LC2pSTKdHOok7u5+rmQS/v
         2bMTnoy08wZOX4228PZqWp/x7LKlu8e60+8SVXtQUQcKLoO1NjOMVveEq15ZvFvwBFxO
         eQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFhJnmX/s0oUEcROladmsKEjjXMSFe33w6iAkZJqd+0=;
        b=SZnVWV+sofgDALl4bjDBn7UcL/2M5kKG3FWimSZHNho3ICTKjfNcm6hi+rDvfdLniz
         4gKF7zkrU76F6EVQX368G3EuB3XY+v6TiEfzm3cNvrlmsjcqBuy/TxKC88y/RooegkTb
         NRpKOvS0b2gMPBH4TQz5vpb7QJI1X+Mz3VA4el9YX9U0yJEsu3TiheXS7OiwdcXD097w
         aaG3j/LrwDBiGoR6zB88x/dtd5OFU2+7eCHk0pD+j+lh6nMuKjuq4iXiDSZXSE0xaFTv
         Dkukr4k9FSqLlqZKxjyZPBFKPkBBW9ON6xrQph7qoPaI900PbTYYrtoDXIM+5CjErOH0
         2Ysg==
X-Gm-Message-State: AOAM533NPTPJbLSEpBpwlnc0X1y1poNfPTp6pssnd5MbrhOCHh8El1S2
        w8NLpNMcwcOxXCHUEkCxSyKHX91uTDeeaA==
X-Google-Smtp-Source: ABdhPJxGlbDabSp3OtWPg2oo3h1A2WRDvHZzIhmSMzBeQg7akxFm83lwUcAt5NriSELf25wT5kBitg==
X-Received: by 2002:a5d:9245:: with SMTP id e5mr8312613iol.97.1616019032068;
        Wed, 17 Mar 2021 15:10:32 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
Subject: [PATCHSET v4 0/8] io_uring passthrough support
Date:   Wed, 17 Mar 2021 16:10:19 -0600
Message-Id: <20210317221027.366780-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I fiddled a bit with the v3 repo, and came up with what I think is a
better solution. Basically we split the io_uring_sqe into a header part,
and then a main part. io_uring_sqe remains the same, obviously, but
io_uring_cmd_sqe is then the sqe for these kinds of passthrough payloads.

In turn, consumers of that can then overlay on io_uring_cmd_sqe. Since
I think we need the personality in there, we may as well add op and len
as most/all will want that too. That leaves 40 bytes that can be used
freely. That may not seem like much, but remember that's 40 bytes outside
of the fd, len, and command op.

I updated and tested the block ioctl example, but didn't update the
net side outside of needing a tweak on the net command. Outside of that,
it should work like before.

I'd be interested in feedback on this approach. My main goal is to make
this flexible enough to be useful, but also fast enough to be useful.
That means no extra allocations if at all avoidable, and even being wary
of adding extra branches to the io_uring hot path. With this series, we
don't do the nasty split in io_init_req() anymore, which I really
disliked in the previous series.

This is by no means perfect yet, but I do think it's better than v3 by
quite a lot. So please send feedback and comments, I'd like to get this
moving forward as we have various folks already lined up to use it...

Kanchan, can you try and address the NVMe feedback and rebase on top
of this branch? Thanks!

You can also find this branch here:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v4

 block/blk-mq.c                |  11 +++
 fs/block_dev.c                |  30 ++++++
 fs/io_uring.c                 | 181 ++++++++++++++++++++++++----------
 include/linux/blk-mq.h        |   6 ++
 include/linux/blkdev.h        |  13 +++
 include/linux/fs.h            |  11 +++
 include/linux/io_uring.h      |  16 +++
 include/linux/net.h           |   2 +
 include/net/raw.h             |   3 +
 include/net/sock.h            |   6 ++
 include/net/tcp.h             |   2 +
 include/net/udp.h             |   2 +
 include/uapi/linux/io_uring.h |  21 ++++
 include/uapi/linux/net.h      |  17 ++++
 net/core/sock.c               |  17 +++-
 net/dccp/ipv4.c               |   1 +
 net/ipv4/af_inet.c            |   3 +
 net/ipv4/raw.c                |  27 +++++
 net/ipv4/tcp.c                |  36 +++++++
 net/ipv4/tcp_ipv4.c           |   1 +
 net/ipv4/udp.c                |  18 ++++
 net/ipv6/raw.c                |   1 +
 net/ipv6/tcp_ipv6.c           |   1 +
 net/ipv6/udp.c                |   1 +
 net/l2tp/l2tp_ip.c            |   1 +
 net/mptcp/protocol.c          |   1 +
 net/sctp/protocol.c           |   1 +
 net/socket.c                  |  13 +++
 28 files changed, 391 insertions(+), 52 deletions(-)

-- 
Jens Axboe



