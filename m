Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407B73A4C80
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 05:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhFLDrb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Jun 2021 23:47:31 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:34548 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLDr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Jun 2021 23:47:26 -0400
Received: by mail-io1-f53.google.com with SMTP id 5so33338139ioe.1
        for <io-uring@vger.kernel.org>; Fri, 11 Jun 2021 20:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=iSROzIWMtAd3ReAS3EhFFwKyOD88eOJ1co2kOMjLM/M=;
        b=RLwXUOQl0xlWoldBemsr3Rn/ntwEEPA9+4I/VsQT4p5K1uk+8lOcVTephQo6d0d8Kr
         NqpmIw/OBoabCSl2N3NFOkw1QnXnW3rlrCc+VBu2FyU52Sp/RpgZiE0XsE63kxgeVMcZ
         xn0Dn86H2nlYYxe24tr8ltqvMgUfdXR+GZCyec3F/LlLtXbsDx9TGkI40e3PzipCDlac
         m9QAPD/rFOgxT9kyY92VklZ77HdcHNrTLc8ZH+yHuwnY4d8+gAWmCF2S/nMpOFFDhi1y
         7dHWRTm3mKTwoXo0VrHi7obenCqJgGCBrZUSB4kYufGq6GOameavMp4zusXaP02+4Sv0
         j5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=iSROzIWMtAd3ReAS3EhFFwKyOD88eOJ1co2kOMjLM/M=;
        b=UIMJ5r8EQpuX+mP34H3nvGhFwSFHY+KqekzCDrHUqWICvmJI4yPc0ZFWlFKbTNJrMj
         brG3Y2vYtAIBv2ap6GPsgrWfGzISHWcFPS7ipd83aUu7BujpkeXxBsezb9uj/MhQDoRf
         psb3v6/15zOwIDQ10bojExg6ynee/SF/83AqatMKJZgPF9LRqSsOlj0Vjjghfw4U8KbQ
         NlZhzANOnXan+0GIRHTj3m1VIT84CzCd90GmZNdIddsqa7p9KatMrQRgkDemxjNGtfeV
         NrRHTRg6GszYEdSgeknkNe7B+iEN4La5p3/1nCgpfsBD2W3Q87GjJ+cWvMdtEdfuDSTu
         UaAA==
X-Gm-Message-State: AOAM533DVn6GGySCepZ+ftf1OGnw9wD3qmtmSj8zirNHDu9gSBpf7gHb
        cN6qzvpJNknHNaXfnIcOGULTi7xrbpBrAt0F4F+dmrcCF0+ATcpg
X-Google-Smtp-Source: ABdhPJwahXDNV28wVGgwmjvV5PZgRIXR5R3xEzTOR0bwMEMT3+hJYnEszKMVE/BAKWN1EBVPPpcb1L0diDjOYDFHPN8=
X-Received: by 2002:a02:a784:: with SMTP id e4mr6772101jaj.18.1623469453505;
 Fri, 11 Jun 2021 20:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBCWQJX4Xy8Sot7en5JBTuKrzy=_6xFkc+QgOxJEC7G6x+jzg@mail.gmail.com>
In-Reply-To: <CAFBCWQJX4Xy8Sot7en5JBTuKrzy=_6xFkc+QgOxJEC7G6x+jzg@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gmail.com>
Date:   Sat, 12 Jun 2021 10:43:56 +0700
Message-ID: <CAFBCWQKzNY3u=4Nk_XHcrUOh0o54+CKksN1mWpZb-rOCbEF--g@mail.gmail.com>
Subject: Re:
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

subscribe io-uring
