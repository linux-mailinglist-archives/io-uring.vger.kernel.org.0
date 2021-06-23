Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873DF3B1374
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 07:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFWFxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 01:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhFWFxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 01:53:08 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACEAC061760;
        Tue, 22 Jun 2021 22:50:50 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id j184so2284338qkd.6;
        Tue, 22 Jun 2021 22:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Db9qL5zTy0vsw0mjnrEBmE6Fe+DWbh68J6ElSvEbrrU=;
        b=ZXXoeKVebL472OQjgKRoVEHKKlWImzt2vhsobsy1f7UPobKcKKrCj1LFjffAvN0usu
         U0402v0CjGco9Lcxk+JrIWYN501JdtZChlbovp78iUK7FAvaSNS9913tiI5KuaHr0L57
         Azj/w2W/iu2KqzgxVI/1OA08uTu9Jvunxi6dFNC/jYtEdynMKmtvCOXHq0OxZA6WoDFm
         8APYCPWRgay0Odyn/ik8z6/iEWYiKiVpCImbp/FOs6OfFQCrVBjq+d+5EvQCzCkbjh9k
         ZTrV8o/FFU/DGk/C1W6mZVMUgpznnrwQUgYL9wdRCVJZisrllaREJaPcIxLe2PRqGEEh
         miQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Db9qL5zTy0vsw0mjnrEBmE6Fe+DWbh68J6ElSvEbrrU=;
        b=M40VIuytTQ5iKxoGqtjBL961tck706cIOOZfQW962oSOjd0VWQZcADyjLi9k39LVv1
         fFcHtSK6cR0NWFVj9FS4nh9JU0jckGGaopPgZXtZf0ADvYATVbQGe6+0Ou/k+n9JT/oC
         lZDhOO96E8a6iJcj6oi+PRPqIGKS5lrOc/tnNuQf0jIQhMfjRaKIBKZsoV68xNj8jxq2
         jdAgaj11zUojLD78tFw7opcTpjDPT8RhGwBXkw0vjRcS68ZsZeHrc4puWnAfYXd3Dlr/
         ZNyNAfBkFuM++UAyM7UGNvg/fYkkPr/+kv3yCwka6cVu0EC/M+zAmSEQn6dgj3cjUk8E
         vDQw==
X-Gm-Message-State: AOAM533FCfur/3vIOczRA80uqoGc+1t6fR7KlC+udnFW5r7YhD0OF72h
        Qjd9Dnl6cdfRv798j6WicHSb3a6EviqPfVxMLFU=
X-Google-Smtp-Source: ABdhPJzA1PxPe+tOzutMwgPur5Wei4yiGjyczfxCn/IQJSOTIEncYIcACovNKdEQysqpD5wIXpyRzqaN3XjGG+MNQpE=
X-Received: by 2002:a25:dfd0:: with SMTP id w199mr9969829ybg.337.1624427449954;
 Tue, 22 Jun 2021 22:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-3-dkadashev@gmail.com>
 <f45781a8-234e-af92-e73d-a6453bd24f16@gmail.com>
In-Reply-To: <f45781a8-234e-af92-e73d-a6453bd24f16@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 12:50:39 +0700
Message-ID: <CAOKbgA7VuG9JqgrGeSD_N7GTZBnocSnWCpGrcrodxWPq7+k47g@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 23, 2021 at 12:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> > IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
> > and arguments.
>
> Jens, a fold-in er discussed, and it will get you
> a conflict at 8/10

Thanks, Pavel

-- 
Dmitry Kadashev
