Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD41557F3B7
	for <lists+io-uring@lfdr.de>; Sun, 24 Jul 2022 09:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiGXHaj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jul 2022 03:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiGXHai (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jul 2022 03:30:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636595FCF;
        Sun, 24 Jul 2022 00:30:37 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id oy13so15295170ejb.1;
        Sun, 24 Jul 2022 00:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=psNAByhtc2S44J/noRtkFecmnWVyvGB3SDGwFE67vsQ=;
        b=Z510fyBCVtjWxSJD6jmBVEpRe2Fr2/elQgNDkz+nU+0/N8jqcEMWvUoj66jbfxF/cR
         ULowIG6FoXgwoCDTaEChTVZAWM6VsZ6v8btEw/6Tn6CzMCTMGP0C71IPPZn+78PJDnV5
         sS9INQ0ZJhM9HbUJQUkup7RKLpXgEcdC5f1siPAh4NauBYBcAe+dqX7hR2y5EXxyyrcT
         7RfwhSZvHt/cspQNOgUPv6JPgXHWGBi4ZEg2jlA1tDYtMkl8z7TljG2oiWU7+TX4B9mc
         DAvFgIbK9XM84JVxOppA5bENtL6pcrMET/OrtRxif3Tvd+6vtHC0BxP5UZmHvcwnIbBn
         vllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=psNAByhtc2S44J/noRtkFecmnWVyvGB3SDGwFE67vsQ=;
        b=50RO5LjLKrNHefHBqhBuJ7UO04T3FHFiI9D95t+mI9mFEfPXrNojaV9ezYbgF2ZLFP
         AG0J60IJrRjyLcLZwn6ioHPHdFiaYykb9eKT6UunlWIdFBxpfcteCumEotfl8d4rQSAt
         oN4sSZv7BC7Ip7K+P/QT1CB4aRQXwp8HDLBEscm7EO3W5GunB3sRECvKYCrNp5oGvosj
         iReTUzD0WhqrgEpKVxfrPelhR0ndl5ZYs43kTya/PDx64WBfRFlMCd9kFkX5C36w+9a1
         EVcDUdqQt56JfVn7AKPY3EDVTzNDlNOAX3XTK55yaerBaIe1qN0ChNpsE7Lr6cSrJwa8
         vemw==
X-Gm-Message-State: AJIora8Nn11dq01IDNCwy+8hZFpCE6Qcu3gWofsVZDaytosqxHCDzyrU
        v/yQ7iFcQHjKVS5Um+4yzwPfaFWavhV6ls1oCSw=
X-Google-Smtp-Source: AGRyM1vyN8JtIYBly0jo2YxBwqNLU4+SETUkvVfO8uZcRyyW5iXrUwzRVWgmHazX181bWGOTjHdmVnQq+nDiZWDclXM=
X-Received: by 2002:a17:907:7f1c:b0:72b:6e63:1798 with SMTP id
 qf28-20020a1709077f1c00b0072b6e631798mr5593276ejc.538.1658647835931; Sun, 24
 Jul 2022 00:30:35 -0700 (PDT)
MIME-Version: 1.0
References: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
 <e21e651299a4230b965cf79d4ae9efd1bc307491.camel@fb.com>
In-Reply-To: <e21e651299a4230b965cf79d4ae9efd1bc307491.camel@fb.com>
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Sun, 24 Jul 2022 00:30:24 -0700
Message-ID: <CANX2M5YXHVTZfst7h5vkPtyt-xBTn1-zsoA=XUAWztbVurioOA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __io_remove_buffers
To:     Dylan Yudaken <dylany@fb.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "fleischermarius@googlemail.com" <fleischermarius@googlemail.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "its.priyanka.bose@gmail.com" <its.priyanka.bose@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 21, 2022 at 4:06 AM Dylan Yudaken <dylany@fb.com> wrote:
>
> On Wed, 2022-07-20 at 18:41 -0700, Dipanjan Das wrote:
> > Hi,
> >
> > We would like to report the following bug which has been found by our
> > modified version of syzkaller.
>
> Hi,
>
> Both of the bug reports you sent seem to be fixed by the patch I just
> sent.
>
> This one however does not seem to terminate once fixed. Is there an
> expected run time?

Sorry for the late reply. We have just started looking into it, and
will get back on this shortly.

>
> Thanks!



-- 
Thanks and Regards,

Dipanjan
