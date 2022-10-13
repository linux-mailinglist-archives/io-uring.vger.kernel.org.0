Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A525FD301
	for <lists+io-uring@lfdr.de>; Thu, 13 Oct 2022 03:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJMBvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Oct 2022 21:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJMBvD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Oct 2022 21:51:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048EFEE0A7;
        Wed, 12 Oct 2022 18:51:03 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i3so632555pfk.9;
        Wed, 12 Oct 2022 18:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k+fj3xaPXr55GP2FJv1sRZl6lOLiSQ/9qXaPvpYFz2w=;
        b=Sm9uh2W7FEzUaBs04hT8hSWvVQG5de9bJ5uV8g35ZaNBfyeQEyzQyCv+/COgZdKuCY
         xWQrkJLHa18E97WyAsMNpkzyzvHEF36kq4d0D+e58dDnP54SV0Ks68V8xNbyGhz+nbA5
         ZgrjkUYgcIGUNkJTBiM4NrZPt0yHxPJ2SSqya2v3jIS1ivwnuQQzj6alQ2j9gw/3nJkx
         bfdcAKCVWHNB0UF1m4qfnjW+buy87goAruDFsHQrqdQqYc53xqSfN6BZDepREMH7dFrt
         SPBSrE3MIPPoIrxOyyKxQxCYIFzwWu8Hpu1c0GnG69tbmQKQlijJ6aMkrbr4gvzrPMSo
         Yi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+fj3xaPXr55GP2FJv1sRZl6lOLiSQ/9qXaPvpYFz2w=;
        b=bID/9CBFT8uTibYpCNEyMpmd6It/v8pUrK67a+nRGJWMncXq6KuZ3VFTadlMlgummx
         8nvHQCN0xoRs0e/TnVSFEWmc8OkMUOiyTKGU7eJ4X4GsCO1YKQKBnbmDpGoK+/Tt2XiI
         LK4ux4O1vmTH/VSYxFSgy+Z+G33qFqD5h4e2DEBb2GZKrf5uul5iIG1+2viChapEgbgr
         dr9VnwM+ltkOcS0+f/Deq5DuSEDM/AjgYGWYGIK1YO25aNq13j8ZkIyvMiacl/lhwk8f
         aHDMYxGKGu0Mws1hqZFYOjE7vV0JbKp6MtwNMZdTaeb9QsamLP906XO12n3oYy8DvEsQ
         bhpg==
X-Gm-Message-State: ACrzQf2eQ6jWgu8ALPR8+9OjiDWObEJA4x6H2ukM5KQ91E/+rYOVlpq1
        i3RCF1j+gzJBID/q+iiGl/A=
X-Google-Smtp-Source: AMsMyM75EDZVE7nkn1nTc50WrEt+rGU6bP4inf/wRAlexWY2XHy+pHtUGiG0l8M07fJ9CT1+s4wSCQ==
X-Received: by 2002:a63:c145:0:b0:44e:9366:f982 with SMTP id p5-20020a63c145000000b0044e9366f982mr27587348pgi.584.1665625862576;
        Wed, 12 Oct 2022 18:51:02 -0700 (PDT)
Received: from T590 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y4-20020a623204000000b00562ab71b863sm496161pfy.214.2022.10.12.18.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 18:51:02 -0700 (PDT)
Date:   Thu, 13 Oct 2022 09:50:55 +0800
From:   Ming Lei <tom.leiming@gmail.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "Richard W.M. Jones" <rjones@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kirill Tkhai <kirill.tkhai@openvz.org>,
        Manuel Bentele <development@manuel-bentele.de>,
        qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: ublk-qcow2: ublk-qcow2 is available
Message-ID: <Y0du/9K3II70tZTD@T590>
References: <Yza1u1KfKa7ycQm0@T590>
 <Yzs9xQlVuW41TuNC@fedora>
 <YzwARuAZdaoGTUfP@T590>
 <CAJSP0QXVK=wUy_JgJ9NmNMtKTRoRX0MwOZUuFWU-1mVWWKij8A@mail.gmail.com>
 <20221006101400.GC7636@redhat.com>
 <CAJSP0QXbnhkVgfgMfC=MAyvF63Oof_ZGDvNFhniDCvVY-f6Hmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXbnhkVgfgMfC=MAyvF63Oof_ZGDvNFhniDCvVY-f6Hmw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 12, 2022 at 10:15:28AM -0400, Stefan Hajnoczi wrote:
> On Thu, 6 Oct 2022 at 06:14, Richard W.M. Jones <rjones@redhat.com> wrote:
> >
> > On Tue, Oct 04, 2022 at 09:53:32AM -0400, Stefan Hajnoczi wrote:
> > > qemu-nbd doesn't use io_uring to handle the backend IO,
> >
> > Would this be fixed by your (not yet upstream) libblkio driver for
> > qemu?
> 
> I was wrong, qemu-nbd has syntax to use io_uring:
> 
>   $ qemu-nbd ... --image-opts driver=file,filename=test.img,aio=io_uring

Yeah, I saw the option, previously when I tried io_uring via:

qemu-nbd -c /dev/nbd11 -n --aio=io_uring $my_file

It complains that 'qemu-nbd: Invalid aio mode 'io_uring'' even though
that 'qemu-nbd --help' does say that io_uring is supported.

Today just tried it on Fedora 37, looks it starts working with
--aio=io_uring, but the IOPS is basically same with --aio=native, and
IO trace shows that io_uring is used by qemu-nbd.


Thanks,
Ming
