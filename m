Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A4391B53
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhEZPNd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235309AbhEZPNc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622041921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/N0k31CwuQKGZMx5f/+9dk+RsNYm2+HO5x/7A80J9dM=;
        b=MG8vPEwhxk2TRvJs4sdlL9ieIh10cqP7+goe5urUtlwJUg0IfRCdgTb7eGpVhov4Aazs/X
        VLvlgjnQrBcKrHXE9yyt6Ju1mRxdbFjBHvFPe6Ls0ftvzjOf4EAcU7oq8zPQS3zFpb4IzR
        d7cMkJpIAep00A8mOnVnF8jSLL1BG08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-ofiMDKPWNRCg6bvvbMeH9g-1; Wed, 26 May 2021 11:11:58 -0400
X-MC-Unique: ofiMDKPWNRCg6bvvbMeH9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9313610082E1;
        Wed, 26 May 2021 15:11:57 +0000 (UTC)
Received: from x2.localnet (ovpn-119-19.rdu2.redhat.com [10.10.119.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CA961094;
        Wed, 26 May 2021 15:11:52 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, linux-audit@redhat.com
Cc:     Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit support to io_uring
Date:   Wed, 26 May 2021 11:11:50 -0400
Message-ID: <2197994.ElGaqSPkdT@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
References: <162163367115.8379.8459012634106035341.stgit@sifl> <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com> <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wednesday, May 26, 2021 10:38:38 AM EDT Paul Moore wrote:
> > > We would need to check with the current security requirements (there
> > > are distro people on the linux-audit list that keep track of that
> > > stuff),

The requirements generally care about resource access. File open, connect, 
accept, etc. We don't care about read/write itself as that would flood the 
analysis.

> > > but looking at the opcodes right now my gut feeling is that
> > > most of the opcodes would be considered "security relevant" so
> > > selective auditing might not be that useful in practice. 

I'd say maybe a quarter to a third look interesting.

> > > It would
> > > definitely clutter the code and increase the chances that new opcodes
> > > would not be properly audited when they are merged.

There is that...

> > I'm curious, why it's enabled by many distros by default? Are there
> > use cases they use?
> 
> We've already talked about certain users and environments where audit
> is an important requirement, e.g. public sector, health care,
> financial institutions, etc.; without audit Linux wouldn't be an
> option for these users,

People that care about auditing are under regulatory mandates. They care more 
about the audit event than the performance. Imagine you have a system with 
some brand new medical discovery. You want to know anyone who accesses the 
information in case it gets leaked out. You don't care how slow the system 
gets - you simply *have* to know everyone who's looked at the documents.

-Steve


