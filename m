Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9492659EAF6
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiHWS2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiHWS1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:27:36 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80C990C7E
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:48:41 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u14so16727002oie.2
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=SaVACCZwH8xQotDN92IFUrhdTD0EHmA54lklXB94n+E=;
        b=1Ok/wOesKzu5P/GWM9TLt92fPx47XR2jb6Bs1/YwT6s+aE3yjQT8rK6fg3W4gaMZHY
         mQo3ryfYq8vuTjmZQdmtbQFq/ztnDvKE2xVNpd1/ySE9vpgsf1lnEY4KGhMlMSPhRJOJ
         bsyrvWXn/fvwz/FlSXYczk5JGhN5CyCqvnNKzhX1UajRcoKEjeA6nBMngjWuNoZtqMwf
         pdHj0fbraSiaUe603p8b0m6b6TcOb+Jb+YN7pCuBwaR1frNMrBQDlHEQFhyGqw1QnLNu
         VybTy0xxYsUD4eZ5h7uJMlN0EtP7nJ51xAsCHwyt9gQRPFURU9QW0Wm/l8SaS1N1LmZa
         KBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=SaVACCZwH8xQotDN92IFUrhdTD0EHmA54lklXB94n+E=;
        b=qU9w5DiOsSRpGIEx2rPr3SVppEMs+SjKJasP+nVndx/gCUo7in6kZr855q+cPY2oOd
         rngv6Y1cH9B9AgwIqj+olS+4ajJ+jQoel/nL+wjSEMLmUa7Ms4M/QVp1MQGNP+spI6sJ
         5k5Nink1pVDLR4UccBNzR1GB7fM3J4rDe0E8HpFFCy/7rjLY+9RkURj/4/oODzqvbwWR
         7uIipI0iSPxonugjByt/AKQv0pzvICq+YSvxUcgQTOEhLqmAbiD0KFGbKAeHBXOn8Rwe
         lMRSfXaz7QZBMy+1UMc2ohIs8Dd9qY4+eVPymJNXV5vxlFYPQ4UHH0n8Xm1i415K6DHo
         r6zQ==
X-Gm-Message-State: ACgBeo3pAVrRBeTo4gXqApCzlKz637ZquoVCkMbY6N/EQaRgdGB/TR+Q
        kP3Yp+L+aCvimBK1bIIda7ZZ27mg8oFmnvmb9uPq9A8ta8AT
X-Google-Smtp-Source: AA6agR5r+WBH3Du54udJhIAVwDMynlMf9eKtVs3NIk9gYWmdmJqIMsAFjS7fy70yrHHRQNjEDLIJRAmJIyXSoSfZ5wA=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr1691234oif.136.1661273321128; Tue, 23
 Aug 2022 09:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120326788.369593.18304806499678048620.stgit@olly> <YwR5fDR0Whp0W3sG@kroah.com>
In-Reply-To: <YwR5fDR0Whp0W3sG@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Aug 2022 12:48:30 -0400
Message-ID: <CAHC9VhSkmJCXbKBOLDJjnap1+pYYnSVt2CzO3iQXmV7TZ+17SA@mail.gmail.com>
Subject: Re: [PATCH 1/3] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 2:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Aug 22, 2022 at 05:21:07PM -0400, Paul Moore wrote:
> > From: Luis Chamberlain <mcgrof@kernel.org>
> >
> > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > add infrastructure for uring-cmd"), this extended the struct
> > file_operations to allow a new command which each subsystem can use
> > to enable command passthrough. Add an LSM specific for the command
> > passthrough which enables LSMs to inspect the command details.
> >
> > This was discussed long ago without no clear pointer for something
> > conclusive, so this enables LSMs to at least reject this new file
> > operation.
> >
> > [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> >
> > Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
>
> You are not "fixing" anything, you are adding new functionality.
> Careful with using "Fixes:" for something like this, you will trigger
> the bug-detection scripts and have to fend off stable bot emails for a
> long time for stuff that should not be backported to stable trees.

This patch, as well as the SELinux and (soon to come) Smack hook
implementations, fix a LSM access control regression that occured when
the IORING_OP_URING_CMD functionality was merged in v5.19.  You may
disagree about this being a regression Greg, but there are at least
three people with their name on this patch that believe it is
important: Luis (patch author), Jens (io_uring maintainer), and myself
(LSM, SELinux maintainer).

--
paul-moore.com
