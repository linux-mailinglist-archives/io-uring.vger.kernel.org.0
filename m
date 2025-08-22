Return-Path: <io-uring+bounces-9236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F03D6B30A7E
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 02:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C99905A41C3
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 00:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA822E41E;
	Fri, 22 Aug 2025 00:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/GszUtt"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E70B322A
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755823940; cv=none; b=mKHfPYkCuCyQJYtYOkJAklZL7S848VASrYTh+AVDVKKUXGcniTOFN25hEdngxVmQRjb1L9bKLdgapQzASNGqlvOzdy0Jzn/VuqL654IuSiGLHapyum5Mvxx6aGlJCsOk6xN0AMvfIKAsYFiqEZDGav6nXV/gKJO2GXX4TBpHThA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755823940; c=relaxed/simple;
	bh=FAZADBqPSeh2WY3ceOywv0ubV2xrClqayfIPnRfDP1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jO2JXfggV1HF3JOZzKkEiReDziTjoLxz/j69GAowfbkOS1hHaxIhM1ceQ05oQTpdv5FsOsspxPyaAVvCWrkEtt71ckHh41Y7g6VOZEqOhoKYzx7NT28R6NY9yCxY220vNb+vRDsGbGU8DLH6ps78SrHR8nbxcR9B6Xltk1eqvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/GszUtt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755823935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dcHExSF33jAXOLz7XZY3gRPWsGYhNPeePMG8Rr8D/TI=;
	b=C/GszUttJnUUoHgywPcGuG5BNyF6Mwk+MjBgnw98B2FgGnLi7N3FJ8r0OCfqbYP+PzFrJi
	1/EBQGbzOYYnzWfuxGbyGGd3LeB3RfcEgiNsc3uyG/j5JHtW93LL2IMgPzLiMo83Iq+U5R
	nXpsC4yyoy9THiY3ln1x8mPOJBIQpj8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-NG_1F2boNtuBvzpeNpnDDQ-1; Thu,
 21 Aug 2025 20:52:11 -0400
X-MC-Unique: NG_1F2boNtuBvzpeNpnDDQ-1
X-Mimecast-MFC-AGG-ID: NG_1F2boNtuBvzpeNpnDDQ_1755823930
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6951C1800346;
	Fri, 22 Aug 2025 00:52:10 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27D0A19560B0;
	Fri, 22 Aug 2025 00:52:06 +0000 (UTC)
Date: Fri, 22 Aug 2025 08:52:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH V5 2/2] io_uring: uring_cmd: add multishot support
Message-ID: <aKe_MZLcs5n1Uobw@fedora>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
 <20250821040210.1152145-3-ming.lei@redhat.com>
 <CADUfDZrUUZzhMw4z=Q0U7PAzp+0Aj_=NNyY6kJH21uQL36B-Fw@mail.gmail.com>
 <a9d16693-b52e-42c7-97aa-52484e4ce510@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9d16693-b52e-42c7-97aa-52484e4ce510@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Aug 21, 2025 at 10:38:57AM -0600, Jens Axboe wrote:
> On 8/21/25 10:29 AM, Caleb Sander Mateos wrote:
> > On Wed, Aug 20, 2025 at 9:02?PM Ming Lei <ming.lei@redhat.com> wrote:
> >>
> >> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
> >> uring_cmd operations with provided buffer.
> >>
> >> This enables drivers to post multiple completion events from a single
> >> uring_cmd submission, which is useful for:
> >>
> >> - Notifying userspace of device events (e.g., interrupt handling)
> >> - Supporting devices with multiple event sources (e.g., multi-queue devices)
> >> - Avoiding the need for device poll() support when events originate
> >>   from multiple sources device-wide
> >>
> >> The implementation adds two new APIs:
> >> - io_uring_cmd_select_buffer(): selects a buffer from the provided
> >>   buffer group for multishot uring_cmd
> >> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
> >>   pushed to the provided buffer
> >>
> >> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
> >> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
> >>
> >> The ublk driver will be the first user of this functionality:
> >>
> >>         https://github.com/ming1/linux/commits/ublk-devel/
> >>
> >> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >> ---
> >>  include/linux/io_uring/cmd.h  | 27 +++++++++++++
> >>  include/uapi/linux/io_uring.h |  6 ++-
> >>  io_uring/opdef.c              |  1 +
> >>  io_uring/uring_cmd.c          | 71 ++++++++++++++++++++++++++++++++++-
> >>  4 files changed, 103 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> >> index cfa6d0c0c322..856d343b8e2a 100644
> >> --- a/include/linux/io_uring/cmd.h
> >> +++ b/include/linux/io_uring/cmd.h
> >> @@ -70,6 +70,21 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >>  /* Execute the request from a blocking context */
> >>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
> >>
> >> +/*
> >> + * Select a buffer from the provided buffer group for multishot uring_cmd.
> >> + * Returns the selected buffer address and size.
> >> + */
> >> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
> >> +                                           unsigned buf_group, size_t *len,
> >> +                                           unsigned int issue_flags);
> >> +
> >> +/*
> >> + * Complete a multishot uring_cmd event. This will post a CQE to the completion
> >> + * queue and update the provided buffer.
> >> + */
> >> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> >> +                                struct io_br_sel *sel, unsigned int issue_flags);
> >> +
> >>  #else
> >>  static inline int
> >>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> >> @@ -102,6 +117,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> >>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
> >>  {
> >>  }
> >> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
> >> +                               unsigned buf_group,
> >> +                               void **buf, size_t *len,
> >> +                               unsigned int issue_flags)
> >> +{
> >> +       return -EOPNOTSUPP;
> >> +}
> >> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> >> +                               ssize_t ret, unsigned int issue_flags)
> >> +{
> >> +       return true;
> >> +}
> >>  #endif
> >>
> >>  /*
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >> index 6957dc539d83..1e935f8901c5 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -298,9 +298,13 @@ enum io_uring_op {
> >>   * sqe->uring_cmd_flags                top 8bits aren't available for userspace
> >>   * IORING_URING_CMD_FIXED      use registered buffer; pass this flag
> >>   *                             along with setting sqe->buf_index.
> >> + * IORING_URING_CMD_MULTISHOT  must be used with buffer select, like other
> >> + *                             multishot commands. Not compatible with
> >> + *                             IORING_URING_CMD_FIXED, for now.
> >>   */
> >>  #define IORING_URING_CMD_FIXED (1U << 0)
> >> -#define IORING_URING_CMD_MASK  IORING_URING_CMD_FIXED
> >> +#define IORING_URING_CMD_MULTISHOT     (1U << 1)
> >> +#define IORING_URING_CMD_MASK  (IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
> > 
> > One other question: what is the purpose of this additional flag?
> > io_uring_cmd_prep() checks that it matches IOSQE_BUFFER_SELECT, so
> > could we just check that flag instead and drop the check that
> > IORING_URING_CMD_MULTISHOT matches REQ_F_BUFFER_SELECT?
> 
> This is a good question - if we don't strictly needs to exist, eg it
> overlaps 100% with IOSQE_BUFFER_SELECT, we should just drop it.

Without this flag, who knows it is one mshot command?

Other mshot OPs use new OP for showing the purpose, here I just want to
avoid to add another uring_cmd variant.


Thanks,
Ming


