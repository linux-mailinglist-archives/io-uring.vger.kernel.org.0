Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D582D874E
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 16:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439274AbgLLPdS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 10:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgLLPdJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Dec 2020 10:33:09 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A119C06179C
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:53 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id q16so12531000edv.10
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 07:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=VSH9txC3VIcVOBiHlrdQM8uG2uXP61UxUJXLMpIkn8k=;
        b=MwK30BhT3/LgCxR5KtDlavEnj2PUKLlAdifYMq7lKSoPQgt+/Vi9z3x0DnV00jJQGc
         v/t89UoQbbBYh8HopS4P3559NzMn7UoVDmum9aQJwvLiun5XcoeqPZDt6sMWC3kCjOdp
         rFKfBwPfTMyUp01mqA4r8e8Z5jV1qXMK+/BOVrlNlBo3D2Cgy5eumjKJ90lYrzwCeMUm
         ChXw2h7YckMqYz6hQPhHCjXbARxgRKnrndl/TW8ixYuIY5KckzToJXgaCT6Hq9viCbNi
         6fe3aJkNtk04rVFV2ntDPEfu+8yRUVMD27wO7QUwVkTnrF/ojzjg1YBLypc1lnxsXmsD
         yYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VSH9txC3VIcVOBiHlrdQM8uG2uXP61UxUJXLMpIkn8k=;
        b=IHjmKBdXiJymTxwCLfThF1Q/W+JIs26wxAmvXBnmWdnAuZOm9sO8BrGQ3HBRTUCtoA
         oKoXbCyWHjlmqbeYfh8UqWyentR8mDyTEKFNJfp4/NHWwdkYfpVLYJBseozAXIrojvnH
         4o8deE5EA+Z3PIHgK4coRQczNwl1yPW10NtuqCIe7jxuJ3yiLmXkAsns+4FAMe6j8kUy
         nKGkvmYEBrrPnkqdg8lGhFRn4FiDLzUPwQnEnUFpbr4/I2BYqw4rGbmZD205PySFaCHj
         PXx8O9L3NGE9TUDFCzd3jcnFeANU5gMwwXsaWUFe9Xp7yHYa4gLqMSPHM2TBaPeqD0uH
         RWhw==
X-Gm-Message-State: AOAM531c9PC8Y7+d67lFcF1XRGzN3GuUu2cOc6UbeONnL7tkwEDivPNr
        arw485xJD2wDN53FKj76Zql7oH3UzyiNNmQ+XwwBqmcmkhQCQzrQ
X-Google-Smtp-Source: ABdhPJxF6fTeF6AN58lmc2bRqPHd5BwYPdNgSu7oW0dohYF3m3xY8AVC/7H7sb0W5xqpSmTxeZ8vaoMm6ZnCJWRpUvs=
X-Received: by 2002:aa7:c049:: with SMTP id k9mr16973431edo.49.1607787111890;
 Sat, 12 Dec 2020 07:31:51 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:41 +0000
Message-ID: <CAM1kxwg0jAoiL9esvh-RKRPdP+8_8rrYE1Bn2eR_0NSOcqUOHg@mail.gmail.com>
Subject: [PATCH 2/3] add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add PROTO_CMSG_DATA_ONLY to inet_dgram_ops

Signed-off by: Victor Stewart <v@nametag.social>
---
net/ipv4/af_inet.c | 1 +
1 file changed, 1 insertion(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b7260c8cef2e..c9fd5e7cfd6e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1052,6 +1052,7 @@ EXPORT_SYMBOL(inet_stream_ops);

 const struct proto_ops inet_dgram_ops = {
        .family            = PF_INET,
+       .flags             = PROTO_CMSG_DATA_ONLY,
        .owner             = THIS_MODULE,
        .release           = inet_release,
        .bind              = inet_bind,
