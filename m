Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFBF2D874B
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393689AbgLLPce (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 10:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393277AbgLLPc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Dec 2020 10:32:29 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B019C061793
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:49 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id jx16so16476252ejb.10
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=AcrMK4/n37JI/DMV0HjZEiX27NSebyROaT8OWAvMNBw=;
        b=vtSV1iHT0efi46wPfoJpuFg1nK2bdC/VzZA6MRjeXr1xW4qXgjpUGnl/2DfzffR/6/
         2RhvKNb8QtR1MQiK1sL0gmZqgPriuym2CnvE/h1lFPPG8zMZBiTcOQnmNwaGq2+42B97
         /sZmH6KbGt5e+O+Xe/2iNo4yC4+jTEEUR/+CHdTVe+UzwPGha3xnIieQKElNxosqMSg5
         feiWxe713A0J2j5iiz6vS6hCjZ+yLdoi1SDMZV4jP2trxmdxtC9qqWdATGs7mAEZXtYx
         aPqbSA8VtDjqFsdQj/hezVvJbpVenDkJjT2ZZM2ntHE1SPYMDsJaEm5/vg2vBge2y4RP
         +Y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AcrMK4/n37JI/DMV0HjZEiX27NSebyROaT8OWAvMNBw=;
        b=U7NzwMks+H6Ke4E7gsjPqDNo6SwoEVMzZR4jV36PMptpKtWZmqYcb0HMhsaGS5QTm7
         LYoziSt+VgtLYB1UQeB+0DtIpZoAFaqVZzQVI28XvIK4kOZJ4y+DBTv3nRkbWTYQNRAn
         bBRwl6kvNtsYSOVRgLgByEGxYbW9iSY3qc+ULagOirc6WxFPb8u+3JgktCYPFnxlJZ60
         VMIyscBFnWWs68jy2YXWNH4RKlItOpE6tX0RQ1gvINJm0TxdgaWYuT5bURsnvfh0tkdN
         21lQ+KKB6TWfmJz9WJkeKBKh7T/RqY4EwhNQH1fsf5uoLG+mEs1mluDVBb0mtXdddlw4
         PWlA==
X-Gm-Message-State: AOAM530YE/JuKkkuRKt6EDpKY/3ZVnxjd3lDgVS+8sxSNwIKKhaW7+gK
        VUCbYg0pGjo+y8f4mksgZ+c156bVEZ8JHeUe7ofD8rQB9BKYxY50
X-Google-Smtp-Source: ABdhPJzdlRnKPfltvgEaKD8UIUmf7/DVijDULyHyNuR0R44sfbTuQ/Mi4ZzCT2fxkH8xmbbhZjQAC8DNvtrD5zyXVEg=
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr15228361ejk.98.1607787107557;
 Sat, 12 Dec 2020 07:31:47 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:36 +0000
Message-ID: <CAM1kxwgKVrpV-4UV5wKyEGbh61N1Bb1s0=pkK8kSp6Z-i3zTKg@mail.gmail.com>
Subject: [PATCH 1/3] add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add PROTO_CMSG_DATA_ONLY whitelisting to __sys_sendmsg_sock

Signed-off by: Victor Stewart <v@nametag.social>
---
 net/socket.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..6995835d6355 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock,
struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
                        unsigned int flags)
 {
-       /* disallow ancillary data requests from this path */
-       if (msg->msg_control || msg->msg_controllen)
-               return -EINVAL;
+       if (msg->msg_control || msg->msg_controllen) {
+               /* disallow ancillary data reqs unless cmsg is plain data */
+               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+                       return -EINVAL;
+       }

        return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
