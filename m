Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DA833A47F
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 12:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhCNLPu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 07:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhCNLPd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 07:15:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49962C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 04:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:To:From:CC;
        bh=uK3gZiVn2En3tNK9TBbacPiZDKL2NiBuuMzXBJGVATo=; b=ezh2g3/Bzwi5H2ZdsDv7n6160o
        HYDuEqE8EiWpnJ5vkUHeL25N3IIUWWjZb/RUXy/pFA8jdRss/DfXXRzFGDPxunLUbdS/ONCJEbMaP
        bhwwcYDWua3CYbJ3o/mCOtimSCBla/Isf4ubJwVjq5ZxZvVETGML1tw6sGoVtXBbNmlaTYELkHsou
        DzVm/yhjLViAlohg29FmI+1eoERlNm2K8hRJ9LZpvbbdVrSOtRzv6S+tbwBck8kMLuYmB/uaAuZGV
        VWzBg8TNI3DXPeXNJiBvGE74oEAOiNsuYDmbiLw0eAhcLHgTqaDWgYXV5kQlf7wRwOLB4nQ6MUDae
        2axvXAbpo62Gs7G1LQowMQjBZcncKPlKFLCiL6VCy+epRKryriMlnTMMKhS0xD3Q138vUhWdA/K5B
        rFqHIzmfROYKtOJqQ7SquNDs6aIl6cF54Da07ZQkSmguYVVpdXTzjjHlSl1babbiXQmbFiUZJEiIm
        XAQEFK+cjxnb/MmbQfXyfrmW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLOiX-0000Ls-ED
        for io-uring@vger.kernel.org; Sun, 14 Mar 2021 11:15:29 +0000
From:   Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 0/2] Some header cleanups
To:     io-uring@vger.kernel.org
Message-ID: <ac4616e1-ce62-f363-7df4-c6315be17d9a@samba.org>
Date:   Sun, 14 Mar 2021 12:15:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

here're a few cleanups in order to make structures as private and
typesafe as possible. It also cleans up the layering from io_uring.c
being on top of io-wq.*.

Stefan Metzmacher (2):
  io_uring: remove structures from include/linux/io_uring.h
  io_uring: use typesafe pointers in io_uring_task

 fs/io-wq.h               | 10 +++++++++-
 fs/io_uring.c            | 16 ++++++++++++++++
 include/linux/io_uring.h | 25 -------------------------
 3 files changed, 25 insertions(+), 26 deletions(-)

-- 
2.25.1

