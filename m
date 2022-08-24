Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA259FC83
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbiHXOBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 10:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbiHXOBB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 10:01:01 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED5587083
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:00:56 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id t11-20020a05683014cb00b0063734a2a786so11823928otq.11
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GvEowS2EBvbq9VPRlHSQopSA/WqPdS2i0F+uxDlmGjU=;
        b=gAY4IAxElEgpBa+x9apxUjbCl+lGxNxRg6XyyZpOeKjrnbArjqF8CqEPO0VFuEDm2a
         E4HQfbGQ7mndFQ8AdI+sbFsy2bvSPccu96OADLHEpJ6XAuYCaP4u0WmnzkUGDGMqnZDc
         fp+BHBG17q5aGStyvIUn+A0BQnuHJXogmv2rYm7S51pQNOs6hget3p1Fj98UchKbYw9L
         ZKJ5bx39sHz6QG0r5EXUJWOvHjSC4ZntB6YgihySFVyS6siDgDM4MOiae5x0la+NTuJc
         8pG4otueF2WmPmepkBkV/hpeeX5kz+RHGEtBf1nSK6VH34gw65G6hzATjunjzhx+Np3Q
         CrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GvEowS2EBvbq9VPRlHSQopSA/WqPdS2i0F+uxDlmGjU=;
        b=tVZdxEN78EoDOGa8OOYHlDR5xxWbXBtPTotsDsdd5sAThleF0aVlM3E+mZZWphWAq1
         ynlJi9ZkwuN9DbQuPA40n5HWiKiH+77/MessPZE2MAYp2rgB2cGlmmtjap//2BUnh0IX
         VukdYi89rvSTXvHIFe0yKDam0qguHotHFpjukwlCyzX9MteVQ0MoubqVDhw5IfLFO1qY
         mXoZq4sL3qNQKz82O6WJWOu6HBBRmkWhAZ8/FYNhL1m4piSPJhKM9KUXcvSQMCFSWl5W
         NP9heIm65J1wHIpXoSBZGw4q//2IEP+rH7SME0rTG82+4/bGzgftnUilSJlLOJMDB9lB
         g2IA==
X-Gm-Message-State: ACgBeo3m/s5xinbcLWv7ICZmS9jS1QZq9v8pawUllqeVfXv/jJBnPffp
        JdWpGPHc12d6srGr/F0HlrzXj4F8bq1+RKKZdu+i
X-Google-Smtp-Source: AA6agR6rtq2//tF95faC3o2HMbcYUfu3MoZDPOrj9rwG3FBcm4aIM9IQ+a48RDONgXu720yClBtTDCTitpiMFHdVzAM=
X-Received: by 2002:a9d:2de3:0:b0:638:e210:c9da with SMTP id
 g90-20020a9d2de3000000b00638e210c9damr10944491otb.69.1661349655908; Wed, 24
 Aug 2022 07:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120326788.369593.18304806499678048620.stgit@olly> <YwR5fDR0Whp0W3sG@kroah.com>
 <CAHC9VhSkmJCXbKBOLDJjnap1+pYYnSVt2CzO3iQXmV7TZ+17SA@mail.gmail.com> <YwXBMmdIJu3C5dPK@kroah.com>
In-Reply-To: <YwXBMmdIJu3C5dPK@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 24 Aug 2022 10:00:44 -0400
Message-ID: <CAHC9VhS3F-B848ZLvid9QFO4jT9B7T-vD7tmF7oVpf92b-53MA@mail.gmail.com>
Subject: Re: [PATCH 1/3] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 24, 2022 at 2:12 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 23, 2022 at 12:48:30PM -0400, Paul Moore wrote:
> > On Tue, Aug 23, 2022 at 2:53 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Mon, Aug 22, 2022 at 05:21:07PM -0400, Paul Moore wrote:
> > > > From: Luis Chamberlain <mcgrof@kernel.org>
> > > >
> > > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > > > add infrastructure for uring-cmd"), this extended the struct
> > > > file_operations to allow a new command which each subsystem can use
> > > > to enable command passthrough. Add an LSM specific for the command
> > > > passthrough which enables LSMs to inspect the command details.
> > > >
> > > > This was discussed long ago without no clear pointer for something
> > > > conclusive, so this enables LSMs to at least reject this new file
> > > > operation.
> > > >
> > > > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> > > >
> > > > Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
> > >
> > > You are not "fixing" anything, you are adding new functionality.
> > > Careful with using "Fixes:" for something like this, you will trigger
> > > the bug-detection scripts and have to fend off stable bot emails for a
> > > long time for stuff that should not be backported to stable trees.
> >
> > This patch, as well as the SELinux and (soon to come) Smack hook
> > implementations, fix a LSM access control regression that occured when
> > the IORING_OP_URING_CMD functionality was merged in v5.19.  You may
> > disagree about this being a regression Greg, but there are at least
> > three people with their name on this patch that believe it is
> > important: Luis (patch author), Jens (io_uring maintainer), and myself
> > (LSM, SELinux maintainer).
>
> Ok, I'll let it be, but note that "Fixes:" tags do not mean that a patch
> will ever get backported to a stable tree, so I guess we don't have to
> worry about it :)

Ha!  Now that's the *proper* LSM dismissing GregKH comment this thread
was missing :)

-- 
paul-moore.com
