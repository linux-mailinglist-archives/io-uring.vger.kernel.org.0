Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24D41D1452
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgEMNQ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 09:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgEMNQ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 09:16:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36CFC061A0E
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 06:16:26 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n14so17207661qke.8
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 06:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3R5SdQIoAX0wUpOC7ifsB1IKxBw7F4aNgsbGUrAs2FY=;
        b=XBFycjKBzsfn2aCP1HbJ/4SVG4bou/zasPWk0j95qpJRXRmtyBO1yH2Z0FlNXWmRGr
         YIrOeO5zYoS9qCKVSbwUbrfezvVkLGVZFxNU2BkrxORu8nIPUDYywQVN7s+u8zj8lJe9
         /NAbU4ZEHqf6USRnxlWaW4nan80xle8U/CLzkgjZSWvgL4lxfdE4hP2+5HkOIs0VGOoN
         yi3RgKD0XLnjr0KVNkwsDqXyKEet/ODktjQYpS29qVaIgFDNYdyixKZN/qdz2X4+i0dq
         KfBq8pWxeeOGTvoXFsuAI6kVSD+wi1UktlU269Y1ZEUvrr2+hDmGUuJTb8A9M4E8Wen5
         PxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3R5SdQIoAX0wUpOC7ifsB1IKxBw7F4aNgsbGUrAs2FY=;
        b=uaQLO9hF1ggVegJXoU6voXnn/2Wrb3LlHPpgPsxnOr9e4dc9GVy7fzS6IpnO8qcDxi
         poZD56rwMfCsm232ki9fo3rWBcTE7S7hSU1CPnbJkGHA2+S9UiFcpn61a2YukPs4p/HC
         pKgADalALyNpaXxwRkXN2hdhb5EV1jNDTTk2Fs1iZ0OROCfRsP+IlwdKnQCaLolIM9fi
         H6zPvi3v1s7P2ATjDah6K5746tUeUBuDy7UPFg8cDaft1O0DiD7/kx9bhE1CDNsRlQHa
         dv3Sa+D6N+cUlb+nIJcEfQJhL7VGJuXk2PW/DnMx4oSwDNY3fX3iNxZISPBGlXAebA3Y
         jlXw==
X-Gm-Message-State: AGi0Pubpqm7hFBIMSpaiiPOol6dcC+6ZYifFGHs2RMcRgMmlDWabgz1x
        pvVvbJtLKcT9i8PERkWg85+Q63ti6EfA6lqgMJZuFoM=
X-Google-Smtp-Source: APiQypKr/A7XaSiSI/D1Esagp06fJOetwdRzquztY22kGzZf5uypGczKhQsy0NhRM1XHch5tmpItgrDIahCDQrE3QvY=
X-Received: by 2002:a05:620a:1009:: with SMTP id z9mr25343883qkj.319.1589375785938;
 Wed, 13 May 2020 06:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com>
In-Reply-To: <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 16:15:51 +0300
Message-ID: <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey Mark,

Or we could share one SQ and one CQ between multiple threads(bound by
the max number of CPU cores) for direct read/write access using very
light mutex to sync.

This also solves threads starvation issue  - thread A submits the job
into shared SQ while thread B both collects and _processes_ the result
from the shared CQ instead of waiting on his own unique CQ for next
completion event.

On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
<markuspapadakis@icloud.com> wrote:
>
> For what it=E2=80=99s worth, I am (also) using using multiple =E2=80=9Cre=
actor=E2=80=9D (i.e event driven) cores, each associated with one OS thread=
, and each reactor core manages its own io_uring context/queues.
>
> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 by e.g=
 collecting all such SQEs in every OS thread and then somehow =E2=80=9Cmovi=
ng=E2=80=9D them to the one OS thread that manages the SQ so that it can en=
queue them all -- is very cheap, you =E2=80=98d still need to drain the CQ =
from that thread and presumably process those CQEs in a single OS thread, w=
hich will definitely be more work than having each reactor/OS thread dequeu=
e CQEs for SQEs that itself submitted.
> You could have a single OS thread just for I/O and all other threads coul=
d do something else but you=E2=80=99d presumably need to serialize access/s=
hare state between them and the one OS thread for I/O which maybe a scalabi=
lity bottleneck.
>
> ( if you are curious, you can read about it here https://medium.com/@mark=
papadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
>
> If you experiment with the various possible designs though, I=E2=80=99d l=
ove it if you were to share your findings.
>
> =E2=80=94
> @markpapapdakis
>
>
> > On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com> wro=
te:
> >
> > Hi Hielke,
> >
> >> If you want max performance, what you generally will see in non-blocki=
ng servers is one event loop per core/thread.
> >> This means one ring per core/thread. Of course there is no simple answ=
er to this.
> >> See how thread-based servers work vs non-blocking servers. E.g. Apache=
 vs Nginx or Tomcat vs Netty.
> >
> > I think a lot depends on the internal uring implementation. To what
> > degree the kernel is able to handle multiple urings independently,
> > without much congestion points(like updates of the same memory
> > locations from multiple threads), thus taking advantage of one ring
> > per CPU core.
> >
> > For example, if the tasks from multiple rings are later combined into
> > single input kernel queue (effectively forming a congestion point) I
> > see
> > no reason to use exclusive ring per core in user space.
> >
> > [BTW in Windows IOCP is always one input+output queue for all(active) t=
hreads].
> >
> > Also we could pop out multiple completion events from a single CQ at
> > once to spread the handling to cores-bound threads .
> >
> > I thought about one uring per core at first, but now I'am not sure -
> > maybe the kernel devs have something to add to the discussion?
> >
> > P.S. uring is the main reason I'am switching from windows to linux dev
> > for client-sever app so I want to extract the max performance possible
> > out of this new exciting uring stuff. :)
> >
> > Thanks, Dmitry
>
