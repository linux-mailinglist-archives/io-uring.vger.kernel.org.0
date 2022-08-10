Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53D58F440
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 00:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiHJWP4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 18:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiHJWPz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 18:15:55 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BFD5C9DA
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 15:15:54 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10dc1b16c12so19507355fac.6
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 15:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VTnegZyaFPfsdagJD4WUfYTIKxb9z6L0a/lV9cT5wlc=;
        b=fCsVIBxPniDLvxqtDGZSjF46mVcKedAftX2L73cEkTAx7IlLUM5jGmJxbu7jg3oVUm
         PbE3e7UJGoyb/3wK2E3b7/lzBeQzqXR4NNvc/oE0HNWKH5El//h4RakIyYADugvj594P
         2++DYpW7LurZAI+6C9YhmyC5VXdeeHxdQlhnZADWfJE93TlNPufMlojbU5MoxDp5UrbA
         J89cdVSijLKERJb8xzpX/4xBX1ZGtK5Tfrg26Ul4Lh6XK02HJmjXYJPZiJbS4I8XWlIf
         lP+ev3pbTqFoLBAtxuItTC3HqeYNggIg/mDxeaP6XII/BlE6t5YwAXQ3LaOpKs6+6R9W
         a05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VTnegZyaFPfsdagJD4WUfYTIKxb9z6L0a/lV9cT5wlc=;
        b=MW+8pzkAsUuLnNv6jxVcwufF7EFXRI6uDrF4EuiXDSg8AhbEIMlIcOglUm8QMYfeYS
         u9qQA+LcevZ9UnlvtYtQhpCjJGqXiWf5CZqzXvg4K6JxpmXqRBdtHH1fjg87irkB1w6y
         RNPyRAINehs8r3dp5nvtATHLukFbay7EEhmXKVjh1bIgzwi3h0UPE4M/wFS2D1+JPrBm
         fSrmpNe2XIGomOaCLCEVpTWN/H555U8nHqTDm+V5CZxTTq8PwpGyWFaXfbajGBv/7Za/
         xdMPkFgbMBCx4K5Bsd/6uaJYFHAAgG4fnruU80gHrsRnL55EK7X0lSaHC7ORaTyzexQG
         cOTQ==
X-Gm-Message-State: ACgBeo3H3ItK0c+wwBe2Cs1VlIuxZI3Yay6akivXYAdRdfjMiiyk05z5
        sEfJa6T/hpNIjvYycCfufNjWFXShZsxRAsgcYKEr
X-Google-Smtp-Source: AA6agR6eBmWxqg3XkoHYvhLYsvVWU6yf+tw0M88bpPbBWRisbp5T7RjnuwgCsPx/X+xpdOR/81Hp+D9ZDFCuRAuYP5M=
X-Received: by 2002:a05:6870:b41e:b0:116:5dc7:192a with SMTP id
 x30-20020a056870b41e00b001165dc7192amr2466807oap.136.1660169753648; Wed, 10
 Aug 2022 15:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220715191622.2310436-1-mcgrof@kernel.org> <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <YvP1jK/J4m8TE8BZ@bombadil.infradead.org> <CAHC9VhQnQqP1ww7fvCzKp_o1n7iMyYb564HSZy1Ed7k1-nD=jQ@mail.gmail.com>
 <YvP+aiGcBsik+v3y@bombadil.infradead.org> <d634ce85-f69b-5441-a72b-ca161cc1f00d@schaufler-ca.com>
In-Reply-To: <d634ce85-f69b-5441-a72b-ca161cc1f00d@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 10 Aug 2022 18:15:42 -0400
Message-ID: <CAHC9VhSkTV21tY_mLDxYr4YQ4LneNiLReRJ1Tgt4XxM=Jb1gow@mail.gmail.com>
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file op
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, joshi.k@samsung.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 10, 2022 at 3:26 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 8/10/2022 11:52 AM, Luis Chamberlain wrote:
> > On Wed, Aug 10, 2022 at 02:39:54PM -0400, Paul Moore wrote:
> >> On Wed, Aug 10, 2022 at 2:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >>> On Fri, Jul 15, 2022 at 01:28:35PM -0600, Jens Axboe wrote:
> >>>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> >>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> >>>>> add infrastructure for uring-cmd"), this extended the struct
> >>>>> file_operations to allow a new command which each subsystem can use
> >>>>> to enable command passthrough. Add an LSM specific for the command
> >>>>> passthrough which enables LSMs to inspect the command details.
> >>>>>
> >>>>> This was discussed long ago without no clear pointer for something
> >>>>> conclusive, so this enables LSMs to at least reject this new file
> >>>>> operation.
> >>>> From an io_uring perspective, this looks fine to me. It may be easier if
> >>>> I take this through my tree due to the moving of the files, or the
> >>>> security side can do it but it'd have to then wait for merge window (and
> >>>> post io_uring branch merge) to do so. Just let me know. If done outside
> >>>> of my tree, feel free to add:
> >>>>
> >>>> Acked-by: Jens Axboe <axboe@kernel.dk>
> >>> Paul, Casey, Jens,
> >>>
> >>> should this be picked up now that we're one week into the merge window?
> >> Your timing is spot on!  I wrapped up a SELinux/SCTP issue by posting
> >> the patches yesterday and started on the io_uring/CMD patches this
> >> morning :)
> >>
> >> Give me a few days to get this finished, tested, etc. and I'll post a
> >> patchset with your main patch, the Smack patch from Casey, the SELinux
> >> patch, and the /dev/null patch so we can all give it a quick sanity
> >> check before I merge it into the LSM/stable branch and send it to
> >> Linus.  Does that sound okay?
>
> It's taking a while to get a satisfactory test going for Smack,
> but I should have something in a few days.

Thanks Casey.  When I get a test working for SELinux I'll be sure to
send it your way just in case.

-- 
paul-moore.com
