Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10289578D1B
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiGRVwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 17:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiGRVwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 17:52:16 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1972E9D4
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 14:52:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z12so18968210wrq.7
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 14:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9woUmKziOSYMEOzduzyD/qFH0+bR5EPCY6q/eggFXo=;
        b=EypuYtIoFxGWldjnCkEvixi/5nqZRcKxgu9gksofTF/7OzAHPa7nULrCiL7jAbKYAr
         Xgdrjgcisf4pc+AY4AnLrxTS2Ks5w0h3XMZSfZzqnjGLdZ5u2ewA/8Ksj1WmrTomqh47
         xp1XmGJqxGVxdfZNGx+vxw1Z6S95GVwzbMFA6UH8WNWYgmej1SP13Uce7EpORBhHYPxU
         2TwP0+gH5O3aQVh2vPRuSTrr8Lrr35X3YKdQ8RG7USZr0p6fHDzQAZVvqbT04hJZessh
         eNFHnt8M/P8EabU18CILE0P8s5dVT/bN3OzyhgwNhOa+BCS9G79k9OLCF0/rmzqnOSCT
         UC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9woUmKziOSYMEOzduzyD/qFH0+bR5EPCY6q/eggFXo=;
        b=NFXa8B0Sz2uMY8+ryiHBb7nB+Vrnx87owAxawylXGgNbWo7FIgycCbH22vKVnUZy0F
         CPo7IoCRd21Eh7QqM6JPGTNF3Bpi3LRjWB1JAqLV1E6pOV57Cz/N7x5jFQuyaoYdcyLs
         uwhSWTNYsIZ6fQZzmX2Lhth8BzOi1zpj+XloKCEG45014fGafaVgTG73VGnrgNffuYFm
         efjyuo4zASKjkXQOlE5EQC/E3SX0FwlISHso9sxqsXHtiArNn31+h1Jd7fmikbPWFRBI
         gm6vecAYSodM4HauTcDYlTjdscfw2rFFoGFnsVuontdk9D7K9tTzcScwkgtMn6iphq0u
         Q4sQ==
X-Gm-Message-State: AJIora+HIl8IGV9XxYGteu/qTkj2YRJLamTVtdsXokjub+3QsBuFLanj
        jpc1Pg+7X88nfSDrr/9DAEzor+03EOlLCXUciTmh
X-Google-Smtp-Source: AGRyM1sK8QBEOZVKtlfTmdajnsX69FmXFPbExPnoOWj0fyUUVKvHCszqdWqig5PeaOgS5K5CwqzofilUO6EDkOahZ0g=
X-Received: by 2002:a5d:64a3:0:b0:21d:adaa:ce4c with SMTP id
 m3-20020a5d64a3000000b0021dadaace4cmr24233512wrp.161.1658181133286; Mon, 18
 Jul 2022 14:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220715191622.2310436-1-mcgrof@kernel.org> <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
 <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com> <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
In-Reply-To: <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 18 Jul 2022 17:52:01 -0400
Message-ID: <CAHC9VhRzjLFg9B4wL7GvW3WY-qM4BoqqcpyS0gW8MUbQ9BD2mg@mail.gmail.com>
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file op
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 18, 2022 at 1:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 7/15/2022 8:33 PM, Paul Moore wrote:
> > On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
> >> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> >>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> >>>> add infrastructure for uring-cmd"), this extended the struct
> >>>> file_operations to allow a new command which each subsystem can use
> >>>> to enable command passthrough. Add an LSM specific for the command
> >>>> passthrough which enables LSMs to inspect the command details.
> >>>>
> >>>> This was discussed long ago without no clear pointer for something
> >>>> conclusive, so this enables LSMs to at least reject this new file
> >>>> operation.
> >>> From an io_uring perspective, this looks fine to me. It may be easier if
> >>> I take this through my tree due to the moving of the files, or the
> >>> security side can do it but it'd have to then wait for merge window (and
> >>> post io_uring branch merge) to do so. Just let me know. If done outside
> >>> of my tree, feel free to add:
> > I forgot to add this earlier ... let's see how the timing goes, I
> > don't expect the LSM/Smack/SELinux bits to be ready and tested before
> > the merge window opens so I'm guessing this will not be an issue in
> > practice, but thanks for the heads-up.
>
> I have a patch that may or may not be appropriate. I ran the
> liburing tests without (additional) failures, but it looks like
> there isn't anything there testing uring_cmd. Do you have a
> test tucked away somewhere I can use?

All I have at the moment is the audit-testsuite io_uring test (link
below) which is lacking a test for the io_uring CMD command.  I plan
on adding that, but I haven't finished the SELinux patch yet.

* https://github.com/linux-audit/audit-testsuite/tree/main/tests/io_uring

(Side note: there will be a SELinux io_uring test similar to the
audit-testsuite test, but that effort was delayed due to lack of
io_uring support in the Fedora policy for a while; it's working now,
but the SELinux/SCTP issues have been stealing my time lately.)

-- 
paul-moore.com
