Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8216C9EFE
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 11:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjC0JJU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 05:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjC0JIy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 05:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6651835AA
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 02:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679908086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/jHqPQ9labkDpwONGksLRLwMhvFcLpODPDEk10PFbM=;
        b=MSnRWPPpAlaSdJ/xYjX2olTH3prFhPfUzmbC9Vm3dMOr5cYdxIUOmar7jWqlwPZzvLkjGi
        k6bgGXtiRILyEPrXnb6QFKzeshzrMCMTkQf3BLGt7ZTIFlRAXsx8Cj3ZoXeNkFI2OT63tp
        MU7vWpVsURhW+kHjacW05TSncLmJtuQ=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-OGV9_6D-M1qtB7tpjCad6Q-1; Mon, 27 Mar 2023 05:08:05 -0400
X-MC-Unique: OGV9_6D-M1qtB7tpjCad6Q-1
Received: by mail-yb1-f198.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so8168852ybw.13
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 02:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679908084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/jHqPQ9labkDpwONGksLRLwMhvFcLpODPDEk10PFbM=;
        b=D9kdGXlz1nhbcYw+eMNYQpLY3YaHZBfnPQuj40wLTPwR+f5001LfumcHKE7evrmV64
         GQ6byeqYHMkfYisdz+O6gIU2BEAmvTuJwepDe9j0YvAtGW/lmIY4WL3zzWaLut8DbPCX
         jQZAcHEZP4TcgzqmmP0SjHYDx8Y2ighjXFj/c1wO2m0mwaxYABjORiz6fkJS+H9fQFkB
         +SEbnK34W6o1RdV43eMC4wC5LIrVIYyfSpd1jXcxICwXS77f7fHxMZz/mEDOveg+G6MC
         NLDgii6pNcwrszcrSoczHt8FZkgvveD0QXnk7rW2YTIbRr6dOmyiboQkMNOnXsVVK2yN
         tWKQ==
X-Gm-Message-State: AAQBX9fr2GX5FcDdHWM8DGO9zkhYUTIyhP7LDC7EAl3olz/b6rxis4yH
        bS3Nm6VupYcC+AWn9hXpDLwIDPxcDgXmsXN3ybukjkvtLg63k6LaZbhmT57UbI7uQ3VD/dbVYre
        xHA7TrHJd8kKXfMSmWi4qse9A92E72zTkQPk=
X-Received: by 2002:a05:6902:168d:b0:b6d:1483:bc18 with SMTP id bx13-20020a056902168d00b00b6d1483bc18mr6595363ybb.7.1679908084552;
        Mon, 27 Mar 2023 02:08:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZK4A0vkFV+Fi54XXazb/aOmFl65dPrh+4dL2oYcZ2EWPZ/YWITfHG4vrrsNYo/PRnSdXQDyk1J9i2vTaifXNI=
X-Received: by 2002:a05:6902:168d:b0:b6d:1483:bc18 with SMTP id
 bx13-20020a056902168d00b00b6d1483bc18mr6595359ybb.7.1679908084346; Mon, 27
 Mar 2023 02:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075bebb05f79acfde@google.com> <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
 <ZBUGp5bvNuE3sK5g@bullseye>
In-Reply-To: <ZBUGp5bvNuE3sK5g@bullseye>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Mon, 27 Mar 2023 11:07:52 +0200
Message-ID: <CAGxU2F6StMA+Dp77thrC-Tdq+GMiA802yCgxpE5atDn3RiVA1w@mail.gmail.com>
Subject: Re: [syzbot] [net?] [virt?] [io-uring?] [kvm?] BUG: soft lockup in vsock_connect
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        syzbot <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com>,
        axboe@kernel.dk, davem@davemloft.net, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 25, 2023 at 1:44=E2=80=AFAM Bobby Eshleman <bobbyeshleman@gmail=
.com> wrote:
>
> On Fri, Mar 24, 2023 at 09:38:38AM +0100, Stefano Garzarella wrote:
> > Hi Bobby,
> > FYI we have also this one, but it seems related to
> > syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> >
> > Thanks,
> > Stefano
> >
>
> Got it, I'll look into it.

I think it is related to
syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com, so I tested the
same patch and syzbot seems happy.
I marked this as duplicated, but feel free to undup if it is not the case.

Thanks,
Stefano

