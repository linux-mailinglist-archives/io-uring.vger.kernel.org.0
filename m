Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254F958F43B
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 00:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiHJWPC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 18:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiHJWPA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 18:15:00 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5178C44C
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 15:14:59 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-f2a4c51c45so19487393fac.9
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 15:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=P25ltMRtJD/usTExdwvaP0sN/6HovIdZJUsoLXN0Pw8=;
        b=u8XLY8KfuDWm4X0an7AhBB3+RHpm1zr9rrmHSl8QQfXvDFxZSrKbT4yJe1jNtNxbdj
         icQnvzJNFel5LW4hi/hFIyTLptiBXldFpSPrpdSyrASCP9U71k8q2MAp1ERYsExXbQCD
         /t9hI7fmuP3oah70A7aeAinrP+Oo25aUL7OsU6K/qKOe4QJqW/kEaLR82yDnIrHT7LG7
         rqUBVczB4CxY+FIRT6LIqclNIVwb3IdZ2mr3JIjsnH6qLhA5KyM96rBRLx9H/zUQCTQh
         1MCTqCA1xvBMDJx/JWNC/mc4giWEp+xcGcuqQw/qk5UYOoWpiwEazDmFKkTGepMFbCrb
         20+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=P25ltMRtJD/usTExdwvaP0sN/6HovIdZJUsoLXN0Pw8=;
        b=U/iI0HCW4HTABm7hKjgF/aXWysahQHZ1WIK7aP3sOWGaHIDFtu8sZWVRhLdQwbMy78
         j5UTJtT5haXomTUzFUKfa6dxCTQTUVXeJSRDzz5coXZfjrQ5n6q3dQ1ZZoZLSFTICrY5
         cuAo1riHf4L5NYSPqP/2p8R7Xc6fme0hXTM/Zl0Eeq+AiTS5kjKoq3RMeEwZ4LLbYbDd
         M67pIGjyN/YbLW5Ez5VO+xu0+17QAUoLFdny1zEIW5m7dSU88dl83gRGR4WUkaITNJvu
         4Gmt8Q5rJI/121bg07xEqwoOBr6SLF17YXEOLSc1laRfog+zEb/YsuZis/uuOc2hMemr
         +ASw==
X-Gm-Message-State: ACgBeo0jadCVIFO74c2lYqSlQJkULhacpxvgcPw6qCjA0CyDHfWkJLcJ
        xQ4CbtF/GQOHp8UjlqFluP6ADGeu3n4s9MZgpkQ5
X-Google-Smtp-Source: AA6agR7lpEDOex8Xn/nwOzvRwkqdwihfKzZXcNXKibctA4d/DBBgX+tHbeIJEnc8xR8utAk/bU+7O6/2CM/jJn7Pe3U=
X-Received: by 2002:a05:6870:b41e:b0:116:5dc7:192a with SMTP id
 x30-20020a056870b41e00b001165dc7192amr2465315oap.136.1660169698931; Wed, 10
 Aug 2022 15:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220715191622.2310436-1-mcgrof@kernel.org> <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <YvP1jK/J4m8TE8BZ@bombadil.infradead.org> <CAHC9VhQnQqP1ww7fvCzKp_o1n7iMyYb564HSZy1Ed7k1-nD=jQ@mail.gmail.com>
 <YvP+aiGcBsik+v3y@bombadil.infradead.org>
In-Reply-To: <YvP+aiGcBsik+v3y@bombadil.infradead.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 10 Aug 2022 18:14:48 -0400
Message-ID: <CAHC9VhS-8DCw3oG+VySo-bWsN=Kgz9o0T+47pL9jWdAZ3=+REA@mail.gmail.com>
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file op
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        casey@schaufler-ca.com, joshi.k@samsung.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
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

On Wed, Aug 10, 2022 at 2:52 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> On Wed, Aug 10, 2022 at 02:39:54PM -0400, Paul Moore wrote:
> > On Wed, Aug 10, 2022 at 2:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Fri, Jul 15, 2022 at 01:28:35PM -0600, Jens Axboe wrote:
> > > > On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> > > > > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > > > > add infrastructure for uring-cmd"), this extended the struct
> > > > > file_operations to allow a new command which each subsystem can use
> > > > > to enable command passthrough. Add an LSM specific for the command
> > > > > passthrough which enables LSMs to inspect the command details.
> > > > >
> > > > > This was discussed long ago without no clear pointer for something
> > > > > conclusive, so this enables LSMs to at least reject this new file
> > > > > operation.
> > > >
> > > > From an io_uring perspective, this looks fine to me. It may be easier if
> > > > I take this through my tree due to the moving of the files, or the
> > > > security side can do it but it'd have to then wait for merge window (and
> > > > post io_uring branch merge) to do so. Just let me know. If done outside
> > > > of my tree, feel free to add:
> > > >
> > > > Acked-by: Jens Axboe <axboe@kernel.dk>
> > >
> > > Paul, Casey, Jens,
> > >
> > > should this be picked up now that we're one week into the merge window?
> >
> > Your timing is spot on!  I wrapped up a SELinux/SCTP issue by posting
> > the patches yesterday and started on the io_uring/CMD patches this
> > morning :)
> >
> > Give me a few days to get this finished, tested, etc. and I'll post a
> > patchset with your main patch, the Smack patch from Casey, the SELinux
> > patch, and the /dev/null patch so we can all give it a quick sanity
> > check before I merge it into the LSM/stable branch and send it to
> > Linus.  Does that sound okay?
>
> Works with me! But just note I'll be away on vacation starting tomorrow
> in the woods looking for Bigfoot with my dog, so I won't be around. And
> I suspect Linus plans to release 6.0 on Sunday, if the phb-crystall-ball [0]
> is still as accurate.

No worries, hopefully we'll have something working its way towards
Linus by the time you return.  Enjoy your time away.

-- 
paul-moore.com
