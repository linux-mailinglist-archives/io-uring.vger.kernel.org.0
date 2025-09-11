Return-Path: <io-uring+bounces-9726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8C3B5264D
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 04:12:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F8184645D6
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5433230BDF;
	Thu, 11 Sep 2025 02:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDVrCspd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B44A23
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 02:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757556731; cv=none; b=u8p7+KklLj8T7jOVYCDOHANrAzn6pCB7NEiKZx0Bux2N2X6URK+mL3IDVUtPbtB3ujylNIrcirU+Ia9QDDhBcBr69ns8t2fdNHU8sR3bgPitoXECn5yByJSV3x7yn5AcmNXTZ+XbjU7WKqimkqC6t9IfbGR1Zo7TyfEmHS8X1oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757556731; c=relaxed/simple;
	bh=4mPADcE0s7ThEa4VBkS5gZXyIz86wZ08wH1P0fM7Iz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1MLtgXQzHC30gbnAmRNoo82o4KXAYUfUCS40S/6pvGm3uu0qNF3C8exQHfmo8GQj4xVmQWzRV4fVUrvlRJQZxwQhnFRdWTOAZutYfBL+X9TsPcta/2OROG6vMaAip1FJVygG5thuri5XacAz017igPE4qTxFP+D4XP6IAqp0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XDVrCspd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757556728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6gmKrIWt39S9gfCfIRU+24acQDdEiQoxSaAug6/+tg=;
	b=XDVrCspdj87IXD/Brd0EGtTdBrP3BtXV69gOFSl51QUSldJFzsbYZ/nQpDaOFBkjDTkuMh
	NoD1lTEj0GleNm9XjAV2he8r++woizCkg/RFsNQeDWG7glOFevdRIY+ubRhqUjo3ikrMCt
	MKTm1TAmhkwlcAXpGYhEPe+MRDRCn2Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27-NXuJe4L8Pj2cwVESAZR5fw-1; Wed,
 10 Sep 2025 22:12:00 -0400
X-MC-Unique: NXuJe4L8Pj2cwVESAZR5fw-1
X-Mimecast-MFC-AGG-ID: NXuJe4L8Pj2cwVESAZR5fw_1757556718
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06DB5195608D;
	Thu, 11 Sep 2025 02:11:58 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F667300018D;
	Thu, 11 Sep 2025 02:11:53 +0000 (UTC)
Date: Thu, 11 Sep 2025 10:11:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
Message-ID: <aMIv4zFIJVj-dza5@fedora>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Sep 10, 2025 at 06:28:43PM -0600, Jens Axboe wrote:
> On 9/10/25 11:44 AM, Caleb Sander Mateos wrote:
> >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >> index 04ebff33d0e62..9cef9085f52ee 100644
> >> --- a/include/uapi/linux/io_uring.h
> >> +++ b/include/uapi/linux/io_uring.h
> >> @@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
> >>         IOSQE_ASYNC_BIT,
> >>         IOSQE_BUFFER_SELECT_BIT,
> >>         IOSQE_CQE_SKIP_SUCCESS_BIT,
> >> +       IOSQE_SQE_128B_BIT,
> > 
> > Have you given any thought to how we would handle the likely scenario
> > that we want to define more SQE flags in the future? Are there
> > existing unused bytes of the SQE where the new flags could go? If not,
> > we may need to repurpose some existing but rarely used field. And then
> > we'd likely want to reserve this last flag bit to specify whether the
> > SQE is using this "extended flags" field.
> 
> Yep this is my main problem with this change. If you search the io_uring
> list on lore you can find discussions about this in relation to when
> Ming had his SQE grouping patches that also used this last bit. My
> suggestion then was indeed to have this last flag be "look at XX for
> IOSQE2_* flags". But it never quite got finalized. IIRC, my suggestion
> back then was to use the personality field, since it's a pretty
> specialized use case. Only issue with that is that you could then not
> use IOSQE2_* flags with personality.
> 
> IOW, I think the IOSQE_SQE_128B flag is fine for prototyping and testing
> these patches, but we unfortunately do need to iron out how on earth
> we'll expose some more flags before this can go in.

SQE128 is used for uring_cmd only, so it could be one uring_cmd
private flag. However, the implementation may be ugly and fragile.


Thanks,
Ming


