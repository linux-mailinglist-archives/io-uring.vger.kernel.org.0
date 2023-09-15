Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D557A16D8
	for <lists+io-uring@lfdr.de>; Fri, 15 Sep 2023 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjIOHFL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Sep 2023 03:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjIOHFK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Sep 2023 03:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 778C9A1
        for <io-uring@vger.kernel.org>; Fri, 15 Sep 2023 00:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694761459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0ZKX9+ZDfk8TG2B9BpARJtWjXCRBlMo1JDLbdvybKk=;
        b=Qzf5fZVX+gVQ18fxWHy9bzwTEUHsz0JXk8zNAXaH336MUCntgCL/9aMwd6UVKx4MrF+He7
        LSpr3AUQpK7xS16Nh8eYYpM/e3x0L2uhEk4LsAojnXD4tZAl0H9bxVHZSup2dSITE3EdSo
        1NVYEGVQkxJXffFNTCRrNSAP/Nh9qDg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-pG2-lcBrMa-5RZELNNQSKA-1; Fri, 15 Sep 2023 03:04:18 -0400
X-MC-Unique: pG2-lcBrMa-5RZELNNQSKA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50081b0dba6so2159011e87.0
        for <io-uring@vger.kernel.org>; Fri, 15 Sep 2023 00:04:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694761456; x=1695366256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R0ZKX9+ZDfk8TG2B9BpARJtWjXCRBlMo1JDLbdvybKk=;
        b=KT4hcRGcnfcy2tQ+eVEJ/u4nFB/l2IQ9VVlpMSpLHIEN6UJcsnHDJixR0JdLDsNlbR
         YZS1Bt6dAgtnfBaQQ0dzlL8j9wXjKYcufN7EAM4sExB/d4tQDAdmhJU0xWwU3ox0mK5e
         HpnFfhgkV6eauxCSeLrrY3q+ho2/OlEqknpeVHNfPj7p9U1/5Fhg7USYEk5K1cyFs/qa
         EeeGzp+mWBcttYzN9NORMk80rGvB1qIz5PEeS0zqD4QMIqB9J7bFl6KI2dAkpmrNkDBK
         8VOyFB/K60dih7dbqnMuMUirQSXFoy7dm4d3p1WEr+9kBX+CpPEKQkdadwhAC8FwaC8S
         gorA==
X-Gm-Message-State: AOJu0YzH7OEuCYqACt86xu6a9u94Wd7IaloMUwg2GpwSBcw3eZs0iZaE
        zeI4a/tlXlpEjjslED1EA3PRxa1pKLbUMIVNF/oXG20+3rBL7zACK/aQ8C1EvIoi4QaXU3GusKb
        NZ+7vmGOps3JsmvHFiVsV3LNLcQZ3OQQwzxlXAKanE0nffg==
X-Received: by 2002:a05:6512:2149:b0:4fd:d002:ddad with SMTP id s9-20020a056512214900b004fdd002ddadmr643739lfr.12.1694761456390;
        Fri, 15 Sep 2023 00:04:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtta3SijY3RzwwYuYFpIpWRyB53UbRzdNZ6fENanosL+1QizYjo1V+WEDWxW8bolgTjIL8Pmv4Uv9BVbuxiSY=
X-Received: by 2002:a05:6512:2149:b0:4fd:d002:ddad with SMTP id
 s9-20020a056512214900b004fdd002ddadmr643715lfr.12.1694761456031; Fri, 15 Sep
 2023 00:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230908093009.540763-1-ming.lei@redhat.com> <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <ZPsxCYFgZjIIeaBk@fedora> <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk> <ZPs81IAYfB8J78Pv@fedora>
In-Reply-To: <ZPs81IAYfB8J78Pv@fedora>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 15 Sep 2023 15:04:05 +0800
Message-ID: <CACGkMEvP=f1mB=01CDOhHaDLNL9espKPrUffgHEdBVkW4fo=pw@mail.gmail.com>
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 8, 2023 at 11:25=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Fri, Sep 08, 2023 at 08:44:45AM -0600, Jens Axboe wrote:
> > On 9/8/23 8:34 AM, Ming Lei wrote:
> > > On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> > >> On 9/8/23 3:30 AM, Ming Lei wrote:
> > >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > >>> index ad636954abae..95a3d31a1ef1 100644
> > >>> --- a/io_uring/io_uring.c
> > >>> +++ b/io_uring/io_uring.c
> > >>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *wo=
rk)
> > >>>           }
> > >>>   }
> > >>>
> > >>> + /* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> > >>> + if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> > >>> +         issue_flags |=3D IO_URING_F_NONBLOCK;
> > >>> +
> > >>
> > >> I think this comment deserves to be more descriptive. Normally we
> > >> absolutely cannot block for polled IO, it's only OK here because io-=
wq
> > >
> > > Yeah, we don't do that until commit 2bc057692599 ("block: don't make =
REQ_POLLED
> > > imply REQ_NOWAIT") which actually push the responsibility/risk up to
> > > io_uring.
> > >
> > >> is the issuer and not necessarily the poller of it. That generally f=
alls
> > >> upon the original issuer to poll these requests.
> > >>
> > >> I think this should be a separate commit, coming before the main fix
> > >> which is below.
> > >
> > > Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and the
> > > approach in V2 doesn't need this change.
> > >
> > >>
> > >>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool can=
cel_all, struct io_sq_data *sqd)
> > >>>           finish_wait(&tctx->wait, &wait);
> > >>>   } while (1);
> > >>>
> > >>> + /*
> > >>> +  * Reap events from each ctx, otherwise these requests may take
> > >>> +  * resources and prevent other contexts from being moved on.
> > >>> +  */
> > >>> + xa_for_each(&tctx->xa, index, node)
> > >>> +         io_iopoll_try_reap_events(node->ctx);
> > >>
> > >> The main issue here is that if someone isn't polling for them, then =
we
> > >
> > > That is actually what this patch is addressing, :-)
> >
> > Right, that part is obvious :)
> >
> > >> get to wait for a timeout before they complete. This can delay exit,=
 for
> > >> example, as we're now just waiting 30 seconds (or whatever the timeo=
ut
> > >> is on the underlying device) for them to get timed out before exit c=
an
> > >> finish.
> > >
> > > For the issue on null_blk, device timeout handler provides
> > > forward-progress, such as requests are released, so new IO can be
> > > handled.
> > >
> > > However, not all devices support timeout, such as virtio device.
> >
> > That's a bug in the driver, you cannot sanely support polled IO and not
> > be able to deal with timeouts. Someone HAS to reap the requests and
> > there are only two things that can do that - the application doing the
> > polled IO, or if that doesn't happen, a timeout.
>
> OK, then device driver timeout handler has new responsibility of covering
> userspace accident, :-)
>
> We may document this requirement for driver.
>
> So far the only one should be virtio-blk, and the two virtio storage
> drivers never implement timeout handler.
>

Adding Stefan for more comments.

Thanks

