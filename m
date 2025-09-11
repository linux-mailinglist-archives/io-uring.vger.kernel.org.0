Return-Path: <io-uring+bounces-9727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E72D7B52664
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 04:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10F253B486C
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AED41F9F7A;
	Thu, 11 Sep 2025 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qp91fusV"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6457B21B192
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 02:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757557164; cv=none; b=F1oTKdhVwMEQuFHalDhA+VP0qFKHxfrUEi7MLdKq7P5bt080NWo2iM0KfWSZ0Sft4GZg3LWBOfcB10ndwzLfia9NuQavw+lrDGPZMpF067937cPm+47qiiIu7z5JkbnTuuLIbSSa5xcE6NrPjVTTpXlSGplo7FP+fPfQlSyx+IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757557164; c=relaxed/simple;
	bh=vHq0zHrx6DmpEk4ZY2GiKr5nvo/fYaX396kCf08sDKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPfaRBONi1vfXK+ahgycx5+16RGmeufCbBxMlS32K76ghUH2Rld/Zt6TZzIgGxrzk28OxZhg+JgZ1oHyTIzIwxfHBlSzsbYFAfIHtWIINY9qgIwc2dIHENovlZtMtEZ55aUJsRq8V3Bqu33g20zUVSVGc5BHfeFpXtwc0cbbq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qp91fusV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757557161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xkyB7j44b0qJeKfbI6cKElopSNt11EL6KVEDJj8p0yw=;
	b=Qp91fusVHcPUAuQmi9c4+hLoQvIJwxdiAxEPP/mh8BXOHaxV+jZ9xdWmk0dO41zWwQfMBc
	SSFOGE28a/8d74yYW3w/4FJruOx2pXOCxuqwKrWgZYPbNnuGp0RRsFHbeJtfkU/ZWgg7xQ
	4ON26Y4AQvKMdNw0x3pO7jDvXeaLCJ8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-BgEv9molOEWTwrQUs8iX_A-1; Wed,
 10 Sep 2025 22:19:17 -0400
X-MC-Unique: BgEv9molOEWTwrQUs8iX_A-1
X-Mimecast-MFC-AGG-ID: BgEv9molOEWTwrQUs8iX_A_1757557156
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BD361800452;
	Thu, 11 Sep 2025 02:19:16 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76497180035E;
	Thu, 11 Sep 2025 02:19:11 +0000 (UTC)
Date: Thu, 11 Sep 2025 10:19:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
Message-ID: <aMIxmiGv5D0GvSro@fedora>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
 <aMIv4zFIJVj-dza5@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMIv4zFIJVj-dza5@fedora>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
> On Wed, Sep 10, 2025 at 06:28:43PM -0600, Jens Axboe wrote:
> > On 9/10/25 11:44 AM, Caleb Sander Mateos wrote:
> > >> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > >> index 04ebff33d0e62..9cef9085f52ee 100644
> > >> --- a/include/uapi/linux/io_uring.h
> > >> +++ b/include/uapi/linux/io_uring.h
> > >> @@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
> > >>         IOSQE_ASYNC_BIT,
> > >>         IOSQE_BUFFER_SELECT_BIT,
> > >>         IOSQE_CQE_SKIP_SUCCESS_BIT,
> > >> +       IOSQE_SQE_128B_BIT,
> > > 
> > > Have you given any thought to how we would handle the likely scenario
> > > that we want to define more SQE flags in the future? Are there
> > > existing unused bytes of the SQE where the new flags could go? If not,
> > > we may need to repurpose some existing but rarely used field. And then
> > > we'd likely want to reserve this last flag bit to specify whether the
> > > SQE is using this "extended flags" field.
> > 
> > Yep this is my main problem with this change. If you search the io_uring
> > list on lore you can find discussions about this in relation to when
> > Ming had his SQE grouping patches that also used this last bit. My
> > suggestion then was indeed to have this last flag be "look at XX for
> > IOSQE2_* flags". But it never quite got finalized. IIRC, my suggestion
> > back then was to use the personality field, since it's a pretty
> > specialized use case. Only issue with that is that you could then not
> > use IOSQE2_* flags with personality.
> > 
> > IOW, I think the IOSQE_SQE_128B flag is fine for prototyping and testing
> > these patches, but we unfortunately do need to iron out how on earth
> > we'll expose some more flags before this can go in.
> 
> SQE128 is used for uring_cmd only, so it could be one uring_cmd
> private flag. However, the implementation may be ugly and fragile.

Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always interpreted
as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.


Thanks,
Ming


