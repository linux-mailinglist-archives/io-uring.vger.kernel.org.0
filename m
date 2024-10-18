Return-Path: <io-uring+bounces-3800-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 162D99A31C0
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 02:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90F49B20F5A
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 00:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703ED2A1C9;
	Fri, 18 Oct 2024 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evcqsgw0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09AB20E313
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 00:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729212326; cv=none; b=VlGrR4IKlnsog2Ll5ZZLQnLbYPObSVkwTiF7aPrn+VuE2qOqSEYDVvi2XTVj+P7trbPUGROlAfKwTOBv0fNfSCMHLJnMzclKUiILUNUZspLHD2YMBTHRunMadOW1BbBrDztLFjhArpzzuPt4xfQjzUBfOEJubSmHBrNn4Rpj9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729212326; c=relaxed/simple;
	bh=vRMov1pIOmpTvW12oyJrh0bZJJWtekmDvWmkj8YyBWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSSld6GNIdCIIADM1svp6opCHHpTEo18H+8ab1N2bjt+jkEoFoN9jkv9cQyu7UN1mouul6C2148FEzBTNrFxKxLfWmAXSgAQCJp75M6e/Bv8/cNYGbiCWbcJEbElzrx8P7bG8b5HIqbtOIYEbkGeWhbDIrxUi9sywCaa1PBiffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evcqsgw0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729212323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYqi1iNES82rcjmLgLLFVQs6xL4C1eOlVxTrDq28Yqc=;
	b=evcqsgw0wQMmLywCMlnaQ67nRlnYHf4lXz7iKcNjYcBshkN3JiLcSmgA2rbXbh8+fLXA1Q
	PUnux6dYyDztMJm3lrhLMV4m9mpCoU/uSiDB3+vbyHgly4mlsBa5XlBLLsun5iVT2eMqbb
	mJhocvzcO3muZi4zsREhbbP7uc5Lj20=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-ETAtrQAdPeanNkPeQlkMNA-1; Thu,
 17 Oct 2024 20:45:20 -0400
X-MC-Unique: ETAtrQAdPeanNkPeQlkMNA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE13C19560AD;
	Fri, 18 Oct 2024 00:45:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.56])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D7A119560AD;
	Fri, 18 Oct 2024 00:45:14 +0000 (UTC)
Date: Fri, 18 Oct 2024 08:45:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Uday Shankar <ushankar@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V6 8/8] ublk: support provide io buffer
Message-ID: <ZxGvlMfTdjr_1vPy@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-9-ming.lei@redhat.com>
 <ZxGQPgvfquLw8AgP@dev-ushankar.dev.purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxGQPgvfquLw8AgP@dev-ushankar.dev.purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Oct 17, 2024 at 04:31:26PM -0600, Uday Shankar wrote:
> On Thu, Sep 12, 2024 at 06:49:28PM +0800, Ming Lei wrote:
> > +static int ublk_provide_io_buf(struct io_uring_cmd *cmd,
> > +		struct ublk_queue *ubq, int tag)
> > +{
> > +	struct ublk_device *ub = cmd->file->private_data;
> > +	struct ublk_rq_data *data;
> > +	struct request *req;
> > +
> > +	if (!ub)
> > +		return -EPERM;
> > +
> > +	req = __ublk_check_and_get_req(ub, ubq, tag, 0);
> > +	if (!req)
> > +		return -EINVAL;
> > +
> > +	pr_devel("%s: qid %d tag %u request bytes %u\n",
> > +			__func__, tag, ubq->q_id, blk_rq_bytes(req));
> > +
> > +	data = blk_mq_rq_to_pdu(req);
> > +
> > +	/*
> > +	 * io_uring guarantees that the callback will be called after
> > +	 * the provided buffer is consumed, and it is automatic removal
> > +	 * before this uring command is freed.
> > +	 *
> > +	 * This request won't be completed unless the callback is called,
> > +	 * so ublk module won't be unloaded too.
> > +	 */
> > +	return io_uring_cmd_provide_kbuf(cmd, data->buf);
> > +}
> 
> We did some testing with this patchset and saw some panics due to
> grp_kbuf_ack being a garbage value. Turns out that's because we forgot
> to set the UBLK_F_SUPPORT_ZERO_COPY flag on the device. But it looks
> like the UBLK_IO_PROVIDE_IO_BUF command is still allowed for such
> devices. Should this function test that the device has zero copy
> configured and fail if it doesn't?

Yeah, it should, thanks for the test & report.


Thanks,
Ming


