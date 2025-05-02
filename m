Return-Path: <io-uring+bounces-7813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E460AA7481
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABB4C7A517D
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 14:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187AA23C4EB;
	Fri,  2 May 2025 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITYs4TcP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EF278F43
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 14:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746195008; cv=none; b=e9n7B78DdC39MiJpKxmyLXCKFt1OQWtDGzpodYcxJKcekKGtv56gvs0sTJPorS9XU8F1VBaYQWM4wR05V7zTXkPfVMAwXxc0ojS2b6VWRl75Zygc85/6uC1V53EBNfGmVmaLe15P3r0BW8MKlvsba0PCtjgcMNcz1rkzfNJSnVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746195008; c=relaxed/simple;
	bh=+S2rJgN2W2Kkh1Ng8udKdX+Fcd/NVrpLDShThMOO7tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7Av61YPV3c0QRHlYI4Bx5HXDHBOUwUBY372QYo6dcb80l7QZE5oArg/nSdG2Vije2do+v8y4e98chFUq8g1Gksrwm+N4UZhJEatpZky0oZCZeI5BcOKbTEZdW/SUfoNQHz3V+A+0Ddccwsegjmv1O6EXLALsPqh4nYLeuLExlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITYs4TcP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746195005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+YNtVn1i5yFYig04+gu1goo0m5dNCFVrTWHFVBTCvw=;
	b=ITYs4TcP8/9qcM1qSY3jtROx4qzS4H5ZHjQLHsQGn06QWgR50VGCQZ8kqplDgYFjJJRMNY
	ZwN3ZGUf5baMGxrpygK7FTzwXWW0H8zbaa1Rn2ZkSTreAvTuc+dhGBvOKQP++xKLt7kXLp
	GLvCFRoZQzVLDr4wVIe0XcT89zR0BLk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-55JgxcasNA-LWSjQfmmt5g-1; Fri,
 02 May 2025 10:10:01 -0400
X-MC-Unique: 55JgxcasNA-LWSjQfmmt5g-1
X-Mimecast-MFC-AGG-ID: 55JgxcasNA-LWSjQfmmt5g_1746195000
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C7921956096;
	Fri,  2 May 2025 14:10:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.6])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A70281956094;
	Fri,  2 May 2025 14:09:55 +0000 (UTC)
Date: Fri, 2 May 2025 22:09:50 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 6/7] ublk: register buffer to specified io_uring &
 buf index via UBLK_F_AUTO_BUF_REG
Message-ID: <aBTSLjCFOqdiS_WA@fedora>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
 <20250428094420.1584420-7-ming.lei@redhat.com>
 <CADUfDZrFDbYmnm7LEt94UVhn-tqGM6Fnfqvc2fuq8OqQPdNu3Q@mail.gmail.com>
 <aBJFk0FuWwt9GpC_@fedora>
 <CADUfDZq=3it0OAaSysHtdQ_+EdMwCNJ38HH1R6EdJM5U3JdkOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZq=3it0OAaSysHtdQ_+EdMwCNJ38HH1R6EdJM5U3JdkOA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Apr 30, 2025 at 09:30:16AM -0700, Caleb Sander Mateos wrote:
> On Wed, Apr 30, 2025 at 8:45 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Mon, Apr 28, 2025 at 05:52:28PM -0700, Caleb Sander Mateos wrote:
> > > On Mon, Apr 28, 2025 at 2:45 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > >
> > > > Add UBLK_F_AUTO_BUF_REG for supporting to register buffer automatically
> > > > to specified io_uring context and buffer index.
> > > >
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  drivers/block/ublk_drv.c      | 56 ++++++++++++++++++++++++++++-------
> > > >  include/uapi/linux/ublk_cmd.h | 38 ++++++++++++++++++++++++
> > > >  2 files changed, 84 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > > > index 1fd20e481a60..e82618442749 100644
> > > > --- a/drivers/block/ublk_drv.c
> > > > +++ b/drivers/block/ublk_drv.c
> > > > @@ -66,7 +66,8 @@
> > > >                 | UBLK_F_USER_COPY \
> > > >                 | UBLK_F_ZONED \
> > > >                 | UBLK_F_USER_RECOVERY_FAIL_IO \
> > > > -               | UBLK_F_UPDATE_SIZE)
> > > > +               | UBLK_F_UPDATE_SIZE \
> > > > +               | UBLK_F_AUTO_BUF_REG)
> > > >
> > > >  #define UBLK_F_ALL_RECOVERY_FLAGS (UBLK_F_USER_RECOVERY \
> > > >                 | UBLK_F_USER_RECOVERY_REISSUE \
> > > > @@ -146,7 +147,10 @@ struct ublk_uring_cmd_pdu {
> > > >
> > > >  struct ublk_io {
> > > >         /* userspace buffer address from io cmd */
> > > > -       __u64   addr;
> > > > +       union {
> > > > +               __u64   addr;
> > > > +               struct ublk_auto_buf_reg buf;
> > >
> > > Maybe add a comment justifying why these fields can overlap? From my
> > > understanding, buf is valid iff UBLK_F_AUTO_BUF_REG is set on the
> > > ublk_queue and addr is valid iff neither UBLK_F_USER_COPY,
> > > UBLK_F_SUPPORT_ZERO_COPY, nor UBLK_F_AUTO_BUF_REG is set.
> >
> > ->addr is for storing the userspace buffer, which is only used in
> > non-zc cases(zc, auto_buf_reg) or user copy case.
> 
> Right, could you add a comment to that effect? I think using

Sure.

> overlapping fields is subtle and has the potential to break in the
> future if the usage of the fields changes. Documenting the assumptions
> clearly would go a long way.

The usage is actually reliable and can be well documented 

- ->addr is used if data copy is required 

- ->zone_append_lba is for zoned, which requires UBLK_F_USER_COPY or 
UBLK_F_ZERO_COPY

- 'ublk_auto_buf_reg' is for UBLK_F_AUTO_BUF_REG which is actually one
special(automatic) zero copy, meantime zoned can't be supported for this
feature



Thanks, 
Ming


