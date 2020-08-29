Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72670256A70
	for <lists+io-uring@lfdr.de>; Sat, 29 Aug 2020 23:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgH2VbR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Aug 2020 17:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgH2VbM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Aug 2020 17:31:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A2EC061573
        for <io-uring@vger.kernel.org>; Sat, 29 Aug 2020 14:31:11 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id o18so3642325eje.7
        for <io-uring@vger.kernel.org>; Sat, 29 Aug 2020 14:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=F6QA/b71n9GBNNBrL3qsDOkszcl9nHy/lA8BIXtPLtg=;
        b=v/2AFp2SZFYxERWiJ7T0ixgNayyvZrubEmhS52gQRnyf8DO98BVIngio/COoc+tqFX
         pF8hDQpDivmEVdGkkGnWJGfHAnSvhBfc5vaOMLI4tjMoMgaulVDWZDojZbUEOWAzRS9v
         nTdnoC1LMIMVrRnqNsGYsMjzu6Tg10S/ZhuEhx4uJuOsJKGudP2g89i66CT4/xbEaj3l
         1hx5NAXEkIKpktvnu8m2mM2ltx5mVR5/p4ltkymYaJG1+aUD0zPOEIa0mfXkNL0JU3EY
         /Y/WhTWSuzaS9DHQG7jANUo4MfnTHEb5eF6nP6/fSLJvr4hokt4i8FnEHIvApH2C6ncE
         omOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=F6QA/b71n9GBNNBrL3qsDOkszcl9nHy/lA8BIXtPLtg=;
        b=WP/ZTugc8JAebVtJG+bQHs5A19QvSLTqloRO1mUmDaTGwYt6ehc4Ydo1/cjv9CUg1b
         MlMCVVtv8Ep7+Q2COXbMnZM6ozLP3+xaWO1PbchOMmmskcubtedetY0mKHOC8BfMjHQK
         noPxi2NEQZrKAClzNTh2mo61YtJ5j10d+7wUITIavt9pbhzAdnXoZvuAyPG3EoagaLCu
         hJgfsXrcdvvSRsHZD5T4+zlFME4FcpcbV5Nv45uh8Tlv1If320FvNXmmvqOw4Q5qM4v9
         anB0e2JqSco6rhVpsY61UYxnB5Fi4otwYSfknq0sxgrEEsdq70xtpg4dWSEc0sHvKsL9
         wV7w==
X-Gm-Message-State: AOAM531DxvHfqjxUS5EOvdHq6QGYgTsOvIHlXan7NMz8VP9xKS8csxvR
        o4P/v0ePpaxTXr82EiXBYPfIINh2Ij+qK2BHvIFFg6LIu7jf8A==
X-Google-Smtp-Source: ABdhPJxR4PLroelDdr/Z8eb62fim7mhSeGfTf3AdEfzbZ3QGGe2pMZUES0wTQiLVEbEx1d9C1Go75RVAMFRzw8+NKaY=
X-Received: by 2002:a17:906:9416:: with SMTP id q22mr4581184ejx.391.1598736667295;
 Sat, 29 Aug 2020 14:31:07 -0700 (PDT)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 29 Aug 2020 17:30:56 -0400
Message-ID: <CAM1kxwiDwDLWm-KY3KGE2vkBiCuYze9S+XCnthvyK=gNNMjkRQ@mail.gmail.com>
Subject: IORING_OP_SENDMSG_FIXED + IORING_OP_RECVMSG_FIXED
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello all my name is Victor Stewart.

I just mentioned to Jens on Twitter how fixed sendmsg and recvmsg
would be fantastic additions for burgeoning QUIC traffic.

We have MSG_ZEROCOPY, but it's fairly dead on arrival. For one, it's
only on the send side. It also involves locking pages into memory for
each send. Testing has shown it's only worth using for >10KB sends,
and even still only improves production traffic by single digit %s
(cite LWN).

so Jens suggested I post here to see if anyone is already working on
this. And if not, if someone would like to collaborate?

I've never contributed to the kernel before so I wouldn't know where
to begin with tooling, testing and guidelines, but I would enjoy
learning by doing.

Probably a weekend's work. Seems trivial enough to flag msg_iov as
within a registered buffer, on the back of fixed reads and writes. The
rest of msghdr is doubtfully worth the aggravation.

V
