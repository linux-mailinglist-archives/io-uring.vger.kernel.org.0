Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969632C0ED9
	for <lists+io-uring@lfdr.de>; Mon, 23 Nov 2020 16:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbgKWP3W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Nov 2020 10:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgKWP3W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Nov 2020 10:29:22 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D325CC0613CF
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 07:29:21 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o21so23843481ejb.3
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 07:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=tlSZHhBEU9+4NRbdMZQRiRMCi9ZBf218EK+Z/G0F10g=;
        b=y48mn3l3NI+Wwf1vUavZIVnpOid1VURK0zL7MgInuuaJzJRZLG/t/kYlIqZtMzd3SF
         E5HH2F7j3Txm+mLJ/405brikIWMXPs2GjQwF7XLhJP6qOpBulxGsq1v2/YKdzFN0ba8b
         XKIgNlhg3I03jVgdWecnBShxYl5XIriDejFBu6cxY1+Y+A45sXJrlAvkUHahL/8Mwbnf
         9bR2XLW/bvSxHQFAqprgHxDZPEwIgWGwT+6J3RjdcDncCVAKhgSuSSRCfeMgoMhXl+6F
         uU6Q0brnnT9i6C8lk1QvK8rbFEUpRo9aAnsfQyN/xZvXq+EBIQYzFlsTlT1giM0knXe4
         s50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tlSZHhBEU9+4NRbdMZQRiRMCi9ZBf218EK+Z/G0F10g=;
        b=GK36JXOKWeIpGom8NM3tcN7dHbqDf8w5/TbOa9NQ8sNdWqu0LxD7fDMg6LgNBMKIfX
         fBDhQTWhsPUDmvLpu8RqrVuHr1JKBDi8El0Giee9iahgEDCRTLKba68bT1QC4FUgOlju
         chGl0DQ0LOUYWTdfZ+9Wwxm31qJN0JA/Ybq9S+LEB50o6iciG5Zgv1UJ8AE+71f8dbhr
         smqkJPUchdUZ/aswXUbqBpTSxbNS27L5CupNF6fZIDaJdDtB02QFNV4k6mAmb6j8K+3A
         odE5/GUZ0GelT55TDYBTculYQpxLX75+w0TCW2C4lXMaqrXn+xPSnvcGkzZPWQF1hiRC
         CzVA==
X-Gm-Message-State: AOAM531UhRIIq7+NvntlTwtHW7EjYqf64xLduTFO8B6oHy+sckNwvWqZ
        xNQyYqqefCF5YV+wFOZIZlyOdJOpbAeP+wmpu1/lEHYJmaPjMeFR
X-Google-Smtp-Source: ABdhPJy09RaVHdWFmoel7qFFR6c/2FdxQ8DpXsx6tKacFdbxdVmRIw+Vh2gGgOGLbqncR1aNJBHuBZF2HuunJfNUCoo=
X-Received: by 2002:a17:906:f14c:: with SMTP id gw12mr110904ejb.261.1606145360188;
 Mon, 23 Nov 2020 07:29:20 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 23 Nov 2020 15:29:09 +0000
Message-ID: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
Subject: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

so currently all cmsg headers are disabled through sendmsg and recvmsg
operations through io_uring because of
https://www.exploit-db.com/exploits/47779

i think it's time we start whitelisting the good guys though? GSO and
GRO are hugely important for QUIC servers, and together offer a higher
throughput gain than io_uring alone (rate of data transit
considering), thus io_uring is the lesser performance choice for QUIC
servers at the moment.

RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
GSO is about +~63% and GRO +~82%.

this patch closes that loophole.

Victor Stewart (1);
   net/socket.c: add __sys_whitelisted_cmsghdrs()

   net/socket.c | 15 ++++++++++++---
   1 file changed, 12 insertions(+), 3 deletions(-)
