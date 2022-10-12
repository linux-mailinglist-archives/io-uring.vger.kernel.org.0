Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE1A5FC714
	for <lists+io-uring@lfdr.de>; Wed, 12 Oct 2022 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJLOPx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Oct 2022 10:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJLOPm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Oct 2022 10:15:42 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCE3E086;
        Wed, 12 Oct 2022 07:15:41 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3573ed7cc15so156886517b3.1;
        Wed, 12 Oct 2022 07:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x5q5UaeIrzODWUHdSNbpGgDcgQ6EbQBZ+oosfLDb2YI=;
        b=m+2+i6+ySOcQ9xYX0M8qcI3zldLPcVnGR/MREtYGOuwWUR8klZ7DxqMRxCQG1uvI6T
         o4EaPCUuvRKHTjmCuCDazJc7eS2AOG2HADNfAH3b8zA9AyRuYn8I7cytI/+EfoAHfnPJ
         CO49E/nWCh8FWwSUSfO7j2yUY3sRIypwg+z6C6CCgQaGd6s0Qp82KXM4cMzLADYnOAy+
         Ne3OjEhvU0r/w6HKrdK+96gU3Ne3zWGXdhUaS7lXFr54viXrwB0lHGeRmMjANhL6+MHt
         VtqC46mrB7u4rntkAdUjf8yj/wxPqvadrP/EdSJURKYiGpPA6njKUdlSc2Eo8JNkqRk2
         Ayxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5q5UaeIrzODWUHdSNbpGgDcgQ6EbQBZ+oosfLDb2YI=;
        b=gzM0tV+lyhSxUHneSx3DMPT2OWnIc03j6XJAUEJry4IM+U7QcSgDLXssmSSiB1ZlSi
         YjyXtQjQbxzQ4OkXWVgedlfMkjKrCFHAN7f6Q2xXnk8vgTjqh8A2Tw2g4HV5r6KiIq3J
         t5nl/h8QfwSz8KVDm7MOdZjwy5EAr2XVwmSb48/nR8klgXOhUYPzigc4a37WBhu9RP5o
         O5z/+GWHkw4k1uvkCgmn9ubCm2B7876HlLmOapdhy7lfDWr0SZSkh6mZ2YvsdOtIdL4F
         vPHabHEZVJt0aG4sIYRvpoMB/bCKF1vU2oLmuZco77ahfgiT510h5eT1DrVTp+BIgGpF
         3KQg==
X-Gm-Message-State: ACrzQf3af8wDObnTaJ+/7FGjEOC1nuvIpUW70lTSboOnEyOIfnuAGOoM
        uQTLevABQErwfkdJ9R44NpSe/+xNeUt3fccnnWM=
X-Google-Smtp-Source: AMsMyM78XpQ2emyq3cEKwe6c/B+RtPQuw0V4XAcVx9GYt9ubZEDpXJ+zfRaTOZj2b/YhUXRskbRctqj6quzdULOPTkI=
X-Received: by 2002:a0d:d78c:0:b0:360:bbf0:ef88 with SMTP id
 z134-20020a0dd78c000000b00360bbf0ef88mr15764109ywd.206.1665584140677; Wed, 12
 Oct 2022 07:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <Yza1u1KfKa7ycQm0@T590> <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590> <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <20221006101400.GC7636@redhat.com>
In-Reply-To: <20221006101400.GC7636@redhat.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 12 Oct 2022 10:15:28 -0400
Message-ID: <CAJSP0QXbnhkVgfgMfC=MAyvF63Oof_ZGDvNFhniDCvVY-f6Hmw@mail.gmail.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
To:     "Richard W.M. Jones" <rjones@redhat.com>
Cc:     Ming Lei <tom.leiming@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
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

On Thu, 6 Oct 2022 at 06:14, Richard W.M. Jones <rjones@redhat.com> wrote:
>
> On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > qemu-nbd doesn't use io_uring to handle the backend IO,
>
> Would this be fixed by your (not yet upstream) libblkio driver for
> qemu?

I was wrong, qemu-nbd has syntax to use io_uring:

  $ qemu-nbd ... --image-opts driver=file,filename=test.img,aio=io_uring

The new libblkio driver will also support io_uring, but QEMU's
built-in io_uring support is already available and can be used as
shown above.

Stefan
