Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9153859FCBD
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 16:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbiHXOHB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 10:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbiHXOGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 10:06:42 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F098589
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:06:40 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id p187so12405134oia.9
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 07:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vuqWnah213DNr5H1tn4ngrXQB2l3I0G5wL/BS1TfAHU=;
        b=4CTpJ2CA2srjZiBgpJuzNh70tqshr8M8JZlh7r1vXXVe6IkKJhWj6f4e/oyuwHt9Cb
         3ln3zssJi3/pDymbdZrNuaLokwogS6IeSaFCwh7v2xh9C6Pf6DYvpmhiPTReI6BytPaw
         iA735qCdspKC9+CznKtPS/nrI1eN9pLMdI3UTMhQ4yXncb0O77D723FMO/Oxi4q0XTXM
         luM2X2HyV3tuUM5yr2TJQopFdQXCDRMzhFsIPw5GsE405w7wWX59Cc9EJx6j3SxvQL4U
         ckB3+eYS/hH7UYXu+LIzeBg5ohZDojQNDcmw1b9TFqJRo786YF8i4Scqd1QmijDO/R0y
         AzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vuqWnah213DNr5H1tn4ngrXQB2l3I0G5wL/BS1TfAHU=;
        b=7GecpuaiAyZIK4GKNz6gmPUOQXMCkMoZVHv2Sdrp7g+EWeP81QasgebQOocXyRFInQ
         SN/Cm74j1xvl3HO2oLyim/ZEw5h/awGxDxh48TV2wr4+L6ez5tkQmVu1vnJE88YgCKLm
         KZWFiJ1ELvPgRN9zZDyi5tzWx5+1akm5X3T+CJPe3tRRVHbspar+mtNN+46mYHOUhddo
         tIJbolufVi+bvgCHw9fp4uqhcllewh9u9TyfzJ/n+R77bfmUmP94dwBReWrho4Dl/4Fh
         a5CShD4ckCuWMPxGSvwzBBUR6EJ8kmoJrWupn3f08qr+u3/NpJHIYM/qe5vH8Yblc/8V
         8inQ==
X-Gm-Message-State: ACgBeo2b0RKnR2oE2qg4W/MNmklMVKbTROCq9ftEe0GY6Ci0ss76SPAs
        +13gBeE+1SHlrjfwdrjD+Ha6i0NlwU5Ve7UUvcw/
X-Google-Smtp-Source: AA6agR4kZuDhD9CQWEqCwv8GJP/H3Oi3rbFzJ9S9hgeov6GQmqTZiX0PeLxSUp3Vuw5SBnCLVZ9Lcjz5OyT5kUXOn0Q=
X-Received: by 2002:a05:6808:3a9:b0:343:4b14:ccce with SMTP id
 n9-20020a05680803a900b003434b14cccemr3332125oie.41.1661349999371; Wed, 24 Aug
 2022 07:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly> <YwR5HBazPxWjcYci@kroah.com>
 <CAHC9VhQOSr_CnLmy0pwgUETPh565951DdejQtgkfNk7=tj+BNA@mail.gmail.com> <YwXA6f6SmAxyMxzX@kroah.com>
In-Reply-To: <YwXA6f6SmAxyMxzX@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 24 Aug 2022 10:06:28 -0400
Message-ID: <CAHC9VhR4ePCaJunmFC+D0_7a7V_rCXQEubuF+V5SLOL2BhGGaA@mail.gmail.com>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
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

On Wed, Aug 24, 2022 at 2:10 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 23, 2022 at 01:02:08PM -0400, Paul Moore wrote:
> > On Tue, Aug 23, 2022 at 2:52 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> > > > This patch adds support for the io_uring command pass through, aka
> > > > IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> > > > /dev/null functionality, the implementation is just a simple sink
> > > > where commands go to die, but it should be useful for developers who
> > > > need a simple IORING_OP_URING_CMD test device that doesn't require
> > > > any special hardware.
> > >
> > > Also, shouldn't you document this somewhere?
> > >
> > > At least in the code itself saying "this is here so that /dev/null works
> > > as a io_uring sink" or something like that?  Otherwise it just looks
> > > like it does nothing at all.
> >
> > What about read_null() and write_null()?  I can definitely add a
> > comment (there is no /dev/null documentation in the kernel source tree
> > that I can see), but there is clearly precedence for /dev/null having
> > "do nothing" file_operations functions.
>
> Yes, they should "do nothing".

Right, I don't think anyone was disputing that.  You were asking for a
comment for the new function that effectively says "this function does
nothing", which seems a little silly given the simplicity of the
function, the name, and the context of it all.

> write_null() does report that it
> consumed everything, why doesn't this function have to also do that?

Because a file write (file_operations->write) and a
IORING_OP_URING_CMD (file_operations->uring_cmd) are fundamentally
different operations; uring_cmd_null() returns 0, which is the success
return code for this file op (not to mention a significant number of
kernel functions that return an int).

-- 
paul-moore.com
