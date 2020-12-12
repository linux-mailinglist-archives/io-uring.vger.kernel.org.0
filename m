Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB92D874C
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLLPce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 10:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgLLPc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Dec 2020 10:32:29 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40D4C0613D3
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:43 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ce23so16484681ejb.8
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=aMMyJF+8p9QPej8J5CWrzbYkiGpmhZ+n45YrKy6JUhM=;
        b=wjPCMKyWrDavbnmdu55/krszJNVEFRFwfEcaR1hxaXhPiw/cE6nBYzNBZH+XwM57IH
         R1dAqFYgS6K4LnXnVFZ3n6upg7PX6kY7JR4wWIcv8hnCFEUcbG8W64nn/FxJg/M6q0LJ
         yufLz6vM3qucJtgXMa+kZICRmxHqjplzbY3cnoKSaK2/4Sw9O+NJDSLu8QJiZ07665UV
         pvNQz8F2BjC4exKH2QF9dVyNVsL70FIQ/6/2PueoEOYwbmoJQ0VcSfbxsNPMvkudFreb
         Q/8pn73zuqiainyagWeLEk5c1+7q+94Rn6ICl75Ki883/+gl1VHVAM+4Js7V/lYDb3RI
         AgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aMMyJF+8p9QPej8J5CWrzbYkiGpmhZ+n45YrKy6JUhM=;
        b=SkHELksbLkzuIDH1zcPhAo0ELxs/3fNW1dCeHp+/V14SpeIIx9Aqe80Len/F+dEgxz
         YP8oSRmp6OhYm12JbQUwjHMMOM7ukd/9YZDSRfHMek17TiZJ3nq60TNIQzIiH8Ei6qtb
         zzpuuvOmaSsT5faJenecTdaFbBCV3YOCU/UAGPOMdR3uMFwhsBj1I/s2fuRAKobwR78S
         un5gBGAqXSgHH5NvLQ49/qFexQGXb71T7+k6ehQnDVHSjQG4lJxzcsWQuaWcUMEyQyWm
         ttj3MvS+B5o7w9hnJHM7jyCJHONAxNFxyw3WCRqlyRg0Xanto4lPYApZMa+2p0UZGRPg
         W2/w==
X-Gm-Message-State: AOAM531IMvMjdj2K5J1Shod+mGElkMzuKfbCM789nKiMuHvTHSYu5VBs
        fyVn/7M97qSHcbNrwDefcYGzHMqDpLLIm3sUt1Nvj6qU3JSPjfe5
X-Google-Smtp-Source: ABdhPJyhggzsEk20gRi4OKpn78sVVGZIx/AMTRfn7B6QJpqXAL730Irnqzzjc69zTl1TKzkuTtd3ba9sFd1aNlxEJZA=
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr15850923ejj.214.1607787102060;
 Sat, 12 Dec 2020 07:31:42 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:30 +0000
Message-ID: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
Subject: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
cmsgs" thread...

https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/

here are the patches we discussed.

Victor Stewart (3):
   net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
   net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
   net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops

   net/ipv4/af_inet.c
     |   1 +
   net/ipv6/af_inet6.c
    |   1 +
   net/socket.c
       |   8 +-
   3 files changed, 7 insertions(+), 3 deletions(-)
