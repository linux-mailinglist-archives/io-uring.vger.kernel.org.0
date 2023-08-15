Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1E77C4F3
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjHOBSw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 21:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjHOBSm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 21:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73B2B2
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 18:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692062276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GJZSb/K28s3fnxQUtqipmDAy6W549OVPD0eFsko4JeE=;
        b=OZWmiUJ0UeHrQNCBSm8Anot3A45/WOflRhS8tzeL9sgvNhFtnuf8f10dLcqTSk5GeI7bS4
        Rg/MUXeGLU5CgDzBnbCW3YW7rCjG9xEuefEh4EeFt9Iyvj2Fx12n8jcH1EY4c5FciWQhzX
        upFG7JY6XdmL9KXcHNEsC2Qph9BTVrU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-NIF718NrMy24XEUo4SqI5g-1; Mon, 14 Aug 2023 21:17:53 -0400
X-MC-Unique: NIF718NrMy24XEUo4SqI5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79D1D8011AD;
        Tue, 15 Aug 2023 01:17:52 +0000 (UTC)
Received: from fedora (unknown [10.72.120.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2B05401E6A;
        Tue, 15 Aug 2023 01:17:46 +0000 (UTC)
Date:   Tue, 15 Aug 2023 09:17:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Andreas Hindborg <nmi@metaspace.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        German Maglione <gmaglione@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Joe Thornber <ethornbe@redhat.com>, ming.lei@redhat.com
Subject: Re: Libublk-rs v0.1.0
Message-ID: <ZNrSNeCSg5qsOu61@fedora>
References: <ZNmX5UQev4qvFMaq@fedora>
 <87o7j95vql.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7j95vql.fsf@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Gabriel,

On Mon, Aug 14, 2023 at 02:23:14PM -0400, Gabriel Krisman Bertazi wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
> > Hello,
> >
> > Libublk-rs(Rust)[1][2] 0.1.0 is released.
> 
> Hi Ming,
> 
> Do you intend to effectively deprecate the code in ubdsrv in favor of
> libublk-rs or do you intend to keep the C library?  I'm asking because
> I'm looking into how to enable ublk in distributions.

So far, there are users of C ubdsrv library, and both are maintained
and co-exist, so C library is still kept.


Thanks
Ming

> 
> Thanks,
> 
> >
> > The original idea is to use Rust to write ublk target for covering all
> > kinds of block queue limits/parameters combination easily when talking
> > with Andreas and Shinichiro about blktests in LSFMM/BPF 2023.
> >
> > Finally it is evolved into one generic library. Attributed to Rust's
> > some modern language features, libublk interfaces are pretty simple:
> >
> > - one closure(tgt_init) for user to customize device by providing all
> >   kind of parameter
> >
> > - the other closure(io handling) for user to handling IO which is
> >   completely io_uring CQE driven: a) IO command CQE from ublk driver,
> >   b) target IO CQE originated from target io handling code, c) eventfd
> >   CQE if IO is offloaded to other context
> >
> > With low level APIs, <50 LoC can build one ublk-null, and if high level
> > APIs are used, 30 LoC is enough.
> >
> > Performance is basically aligned with pure C ublk implementation[3].
> >
> > The library has been verified on null, ramdisk, loop and zoned target.
> > The plan is to support async/await in 0.2 or 0.3 so that libublk can
> > be used to build complicated target easily and efficiently.
> >
> > Thanks Andreas for reviewing and providing lots of good ideas for
> > improvement & cleanup. Thanks German Maglione for some suggestions, such
> > as eventfd support. Thanks Joe for providing excellent Rust programming
> > guide.
> >
> > Any feedback is welcome!
> >
> > [1] https://crates.io/crates/libublk 
> > [2] https://github.com/ming1/libublk-rs
> > [3] https://github.com/osandov/blktests/blob/master/src/miniublk.c
> >
> > Thanks,
> > Ming
> >
> 
> -- 
> Gabriel Krisman Bertazi
> 

-- 
Ming

